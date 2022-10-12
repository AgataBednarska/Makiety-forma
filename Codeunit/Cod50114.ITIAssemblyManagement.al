codeunit 50114 "ITI AssemblyManagement"
{
    procedure SetNewResidueRecord(var ItemJnlLine: Record "Item Journal Line"; AssemblyHeader: Record "Assembly Header")
    var
        AssemblySetup: Record "Assembly Setup";
        ExItemJnlLine: Record "Item Journal Line";
    begin
        AssemblySetup.get();

        ItemJnlLine."Journal Template Name" := AssemblySetup."Item Journal Tmpl. for Residue";
        ItemJnlLine."Journal Batch Name" := AssemblySetup."Item Journal Batch for Residue";

        ExItemJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        ExItemJnlLine.SetRange("Journal Template Name", ItemJnlLine."Journal Template Name");
        ExItemJnlLine.SetRange("Journal Batch Name", ItemJnlLine."Journal Batch Name");
        If ExItemJnlLine.FindLast() then
            ItemJnlLine."Line No." := ExItemJnlLine."Line No." + 1000;

        ItemJnlLine.validate("Gen. Bus. Posting Group", AssemblySetup."Def.Gen.Bus.Post.Gr. for Adjmt");
        ItemJnlLine."Posting Date" := WorkDate();
        //ItemJnlLine."Document Type" := ItemJnlLine."Document Type"::"Posted Assembly";
        ItemJnlLine."Document No." := AssemblyHeader."No.";
        ItemJnlLine."External Document No." := AssemblyHeader."External Document No.";
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
        ItemJnlLine."Location Code" := AssemblySetup."Default Location for Residue";
    end;

    procedure PostResidueLines(var AssemblyHeader: Record "Assembly Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPostLine: codeunit "Item Jnl.-Post Line";
    begin
        AssemblySetup.Get();
        ItemJnlLine.SetRange("Journal Template Name", AssemblySetup."Item Journal Tmpl. for Residue");
        ItemJnlLine.SetRange("Journal Batch Name", AssemblySetup."Item Journal Batch for Residue");
        //ItemJnlLine.SetRange("Document Type", ItemJnlLine."Document Type"::"Posted Assembly");
        ItemJnlLine.SetRange("Document No.", AssemblyHeader."No.");
        if ItemJnlLine.FindSet() then
            repeat
                ItemJnlPostLine.Run(ItemJnlLine);
                ItemJnlLine.Delete();
            until ItemJnlLine.Next() = 0;
    end;


    procedure PostTransferLines(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        QtyToTransfer: Decimal;
        ItemJournalLine: Record "Item Journal Line" temporary;
        ItemJnlPostLine: codeunit "Item Jnl.-Post Line";
        AssyMgt: Codeunit "ITI AssemblyManagement";
    begin
        AssemblySetup.get();
        AssemblyLine.SetFilter("Location Code", '<>%1', AssemblySetup."In-Production Location");
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        if AssemblyLine.FindSet() then begin
            repeat
                AssemblyLine.CalcFields("External Document No.", "Quantity Transferred");
                QtyToTransfer := AssemblyLine.Quantity;// + AssemblyLine."Transfers on location";
                                                       //If QtyToTransfer > AssemblyLine.Quantity then
                                                       //    error('Quantity to transfer %1/%2', QtyToTransfer, AssemblyLine.Quantity);
                IF QtyToTransfer > 0 then begin
                    InsertTransferLine(ItemJournalLine, AssemblyLine, QtyToTransfer);
                    ItemJnlPostLine.Run(ItemJournalLine);
                    InsertTransferredAssemblyLine(AssemblyLine, QtyToTransfer);
                    ReduceAssemblyLineQuantity(AssemblyLine, QtyToTransfer, false);
                end;
            until AssemblyLine.Next() = 0;

        end;
    end;

    local procedure InsertTransferLine(var ItemJournalLine: Record "Item Journal Line"; AssemblyLine: Record "Assembly Line"; QtyToTransfer: Decimal)
    var
        LineNo: Integer;
    begin
        LineNo := ItemJournalLine."Line No." + 1000;

        ItemJournalLine.Init();
        ItemJournalLine."Line No." := LineNo;

        ItemJournalLine."Journal Template Name" := AssemblySetup."Item Journal Tmpl. for Residue";
        ItemJournalLine."Journal Batch Name" := AssemblySetup."Item Journal Batch for Residue";

        ItemJournalLine.Validate("Posting Date", WorkDate);
        AssemblySetup.get();
        AssemblySetup.testfield("Def.Gen.Bus.Post.Gr. for Adjmt");
        ItemJournalLine.validate("Gen. Bus. Posting Group", AssemblySetup."Def.Gen.Bus.Post.Gr. for Adjmt");
        //ItemJournalLine.Validate("Document Type", ItemJournalLine."Document Type"::"Posted Assembly");
        ItemJournalLine.Validate("Document No.", AssemblyLine."Document No.");
        ItemJournalLine.Validate("Document Line No.", AssemblyLine."Line No.");
        ItemJournalLine.Validate("External Document No.", AssemblyLine."External Document No.");
        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::Transfer);
        ItemJournalLine.Validate("Item No.", AssemblyLine."No.");
        ItemJournalLine.Validate(Quantity, QtyToTransfer);
        ItemJournalLine.Validate("Location Code", AssemblyLine."Location Code");
        ItemJournalLine.Validate("New Location Code", AssemblySetup."In-Production Location");
        ItemJournalLine.Validate("Dimension Set ID", AssemblyLine."Dimension Set ID");
        ItemJournalLine.Validate("New Dimension Set ID", AssemblyLine."Dimension Set ID");
        ItemJournalLine.Insert();
    end;

    local procedure InsertTransferredAssemblyLine(AssemblyLine: Record "Assembly Line"; QtyToTransfer: Decimal)
    var
        TfdAssemblyLine: Record "Assembly Line";
    begin
        TfdAssemblyLine.copy(AssemblyLine);

        AssemblyLine.SetRange("Document Type", AssemblyLine."Document Type");
        AssemblyLine.SetRange("Document No.", AssemblyLine."Document No.");
        AssemblyLine.SetRange("Line No.", AssemblyLine."Line No.", AssemblyLine."Line No." + 1000);
        if AssemblyLine.FindLast() then;

        TfdAssemblyLine."Line No." := AssemblyLine."Line No." + 10;
        TfdAssemblyLine."Location Code" := AssemblySetup."In-Production Location";
        TfdAssemblyLine.Validate(Quantity, QtyToTransfer);
        TfdAssemblyLine.Validate("Quantity to Consume", QtyToTransfer);

        TfdAssemblyLine.Insert();
    end;

    local procedure ReduceAssemblyLineQuantity(var AssemblyLine: Record "Assembly Line"; QtyToTransfer: Decimal; DeleteIfFullyTransferred: Boolean)
    begin
        AssemblyLine.validate(Quantity, AssemblyLine.Quantity - QtyToTransfer);
        AssemblyLine.Modify();

        IF DeleteIfFullyTransferred then
            IF AssemblyLine.Quantity = 0 then
                AssemblyLine.Delete();
    end;

    procedure UpdateResidueJournalLines(AssemblyHeader: Record "Assembly Header"; ResidueItemJnlLine: Record "Item Journal Line")
    var
        ItemJnlLine: Record "Item Journal Line";
        AssemblyLine: Record "Assembly Line";
        ResidueItemNo: code[20];
        ResidueUnitAmount: Decimal;
    begin
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        if AssemblyLine.FindSet() then begin
            ItemJnlLine.SetRange("Journal Template Name", ResidueItemJnlLine."Journal Template Name");
            ItemJnlLine.SetRange("Journal Batch Name", ResidueItemJnlLine."Journal Batch Name");
            ItemJnlLine.SetRange("External Document No.", ResidueItemJnlLine."External Document No.");
            ItemJnlLine.SetRange("Document No.", ResidueItemJnlLine."Document No.");
            repeat
                ResidueItemNo := FindRelatedItem(AssemblyLine."No.", 'O');
                ResidueUnitAmount := Round(AssemblyLine."Unit Cost" * 0.75, 0.01, '=');

                ItemJnlLine.SetRange("Item No.", ResidueItemNo);
                ItemJnlLine.SetRange("Unit Cost", ResidueUnitAmount);
                if ResidueItemNo <> '' then
                    if ItemJnlLine.IsEmpty then begin
                        ItemJnlLine.Init();
                        SetNewResidueRecord(ItemJnlLine, AssemblyHeader);
                        ItemJnlLine.validate("Item No.", ResidueItemNo);
                        ItemJnlLine.validate("Unit Amount", ResidueUnitAmount);
                        ItemJnlLine.Validate("Dimension Set ID", AssemblyHeader."Dimension Set ID");
                        ItemJnlLine.Insert();
                    end;
            until AssemblyLine.Next() = 0;
        end;
    end;

    local procedure FindRelatedItem(ItemNo: Code[20]; FindWithPrefix: Char): code[20]
    var
        Item: Record Item;
        ItemToFindNo: Code[20];
    begin
        ItemToFindNo := STRSUBSTNO('%1%2', FindWithPrefix, CopyStr(ItemNo, 2));
        IF Item.GET(ItemToFindNo) then
            exit(Item."No.");
    end;

    procedure UpdateAssemblyLinesWithDefaultLocation(AssemblyHeader: Record "Assembly Header")
    var
        AssemblySetup: Record "Assembly Setup";
        AssemblyLine: Record "Assembly Line";
    begin
        AssemblySetup.get();
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        AssemblyLine.ModifyAll("Location Code", AssemblySetup."Default Location for Material");
    end;

    procedure GetATOExternalDocumentNo(AssemblyHeader: Record "Assembly Header"): code[35]
    var
        SalesHeader: Record "Sales Header";
        ATOLink: Record "Assemble-to-Order Link";
    begin
        if AssemblyHeader.IsAsmToOrder() then
            if ATOLink.GetATOLink(AssemblyHeader) then
                if SalesHeader.get(ATOLink."Document Type", ATOLink."Document No.") then
                    exit(SalesHeader."External Document No.");
    end;

    procedure TestATOReleased(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        ATOHeader: Record "Assembly Header";
    begin
        if (SalesHeader."Document Type" <> "Sales Document Type"::Order) and
           (NOT SalesHeader.Ship) then
            exit;
        SalesLine.SetRange("Document Type", "Sales Document Type"::Order);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.Setfilter("Qty. to Assemble to Order", '<>0');
        SalesLine.Setfilter("Qty. to Ship", '<>0');
        If SalesLine.FindSet() then begin
            repeat
                If SalesLine.AsmToOrderExists(ATOHeader) then
                    ATOHeader.TestField(Status, ATOHeader.Status::Released);
            until SalesLine.Next() = 0;
        end;
    end;

    procedure SetHeaderDimensionsFromInventoryAdjmtAccount(var AssemblyHeader: Record "Assembly Header"; UpdateLines: Boolean)
    var
        DefaultDimension: Record "Default Dimension";
        DimMgt: Codeunit DimensionManagement;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        AsmLine: Record "Assembly Line";
        OldDimSet: Integer;
        NewDimSet: Integer;
    begin
        DefaultDimension.SetRange("Table ID", Database::"G/L Account");
        DefaultDimension.SetRange("No.", GetInventoryAdjustmentAccount(AssemblyHeader));
        DefaultDimension.SetRange("Value Posting", DefaultDimension."Value Posting"::"Same Code");
        if DefaultDimension.FindSet() then begin
            DimMgt.GetDimensionSet(TempDimSetEntry, AssemblyHeader."Dimension Set ID");
            repeat
                TempDimSetEntry.Init;
                TempDimSetEntry.Validate("Dimension Code", DefaultDimension."Dimension Code");
                TempDimSetEntry.Validate("Dimension Value Code", DefaultDimension."Dimension Value Code");
                if not TempDimSetEntry.Insert() then
                    if not TempDimSetEntry.Modify then
                        ;
            until DefaultDimension.Next() = 0;

            OldDimSet := AssemblyHeader."Dimension Set ID";
            NewDimSet := DimMgt.GetDimensionSetID(TempDimSetEntry);

            //AssemblyHeader.Validate("Dimension Set ID", NewDimSet;
            AssemblyHeader."Dimension Set ID" := NewDimSet;
            DimMgt.UpdateGlobalDimFromDimSetID(AssemblyHeader."Dimension Set ID", AssemblyHeader."Shortcut Dimension 1 Code", AssemblyHeader."Shortcut Dimension 2 Code");

            AsmLine.SetRange("Document No.", AssemblyHeader."No.");
            AsmLine.SetRange("Document Type", AssemblyHeader."Document Type");
            // AsmLine.ModifyAll("Dimension Set ID", NewDimSet, true);
            If AsmLine.FindSet() then
                repeat
                    AsmLine.UpdateDim(NewDimSet, OldDimSet);
                    AsmLine.Modify();
                until AsmLine.Next() = 0;
        end;
    end;


    procedure SetResidueDimensionsFromInventoryAdjmtAccount(var AssemblyHeader: Record "Assembly Header")
    var
        DefaultDimension: Record "Default Dimension";
        ItemJnlLine: Record "Item Journal Line";
        AssemblySetup: Record "Assembly Setup";
        GLSetup: Record "General Ledger Setup";
    begin
        AssemblySetup.Get();
        GLSetup.Get();
        ItemJnlLine.SetRange("Journal Template Name", AssemblySetup."Item Journal Tmpl. for Residue");
        ItemJnlLine.SetRange("Journal Batch Name", AssemblySetup."Item Journal Batch for Residue");
        ItemJnlLine.SetRange("External Document No.", AssemblyHeader."External Document No.");
        ItemJnlLine.SetRange("Document No.", AssemblyHeader."No.");
        if ItemJnlLine.FindSet() then
            repeat
                DefaultDimension.SetRange("Table ID", Database::"G/L Account");
                DefaultDimension.SetRange("No.", GetInventoryAdjustmentAccount(AssemblyHeader));
                DefaultDimension.SetRange("Value Posting", DefaultDimension."Value Posting"::"Same Code");
                if DefaultDimension.FindSet() then begin
                    repeat
                        if GLSetup."Shortcut Dimension 1 Code" = DefaultDimension."Dimension Code" then begin
                            ItemJnlLine.validate("Shortcut Dimension 1 Code", DefaultDimension."Dimension Value Code");
                            ItemJnlLine.Modify();
                        end;
                        if GLSetup."Shortcut Dimension 2 Code" = DefaultDimension."Dimension Code" then begin
                            ItemJnlLine.validate("Shortcut Dimension 2 Code", DefaultDimension."Dimension Value Code");
                            ItemJnlLine.Modify();
                        end;
                    until DefaultDimension.Next() = 0;
                end;
            until ItemJnlLine.Next() = 0;
    end;

    procedure UpdateResidueDimensionsFromAssemblyHeader(var AssemblyHeader: Record "Assembly Header")
    var
        ItemJnlLine: Record "Item Journal Line";
        AssemblySetup: Record "Assembly Setup";
        GLSetup: Record "General Ledger Setup";
    begin
        AssemblySetup.Get();
        GLSetup.Get();
        ItemJnlLine.SetRange("Journal Template Name", AssemblySetup."Item Journal Tmpl. for Residue");
        ItemJnlLine.SetRange("Journal Batch Name", AssemblySetup."Item Journal Batch for Residue");
        ItemJnlLine.SetRange("External Document No.", AssemblyHeader."External Document No.");
        ItemJnlLine.SetRange("Document No.", AssemblyHeader."No.");
        if ItemJnlLine.FindSet() then
            repeat
                ItemJnlLine.CopyDim(AssemblyHeader."Dimension Set ID");
                ItemJnlLine.Modify();
            until ItemJnlLine.Next() = 0;
    end;

    local procedure GetInventoryAdjustmentAccount(AssemblyHeader: Record "Assembly Header"): Code[20]
    var
        GenPostSetup: Record "General Posting Setup";
        GLAccount: Record "G/L Account";
    begin
        if not GLAccount.get('411-1') then
            if not GLAccount.get('4111') then
                if GenPostSetup.get(AssemblyHeader."ITI Gen. Bus. Posting Group", AssemblyHeader."Gen. Prod. Posting Group") then
                    GLAccount.get(GenPostSetup."Inventory Adjmt. Account");
        exit(GLAccount."No.");
    end;

    var
        AssemblySetup: Record "Assembly Setup";
}

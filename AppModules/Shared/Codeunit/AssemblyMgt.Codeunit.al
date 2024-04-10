codeunit 50110 "AssemblyMgt N24"
{
    procedure SetNewResidueRecord(var ItemJnlLine: Record "Item Journal Line"; AssemblyHeader: Record "Assembly Header")
    var
        AssemblySetup: Record "Assembly Setup";
        ExItemJnlLine: Record "Item Journal Line";
    begin
        AssemblySetup.Get();

        ItemJnlLine."Journal Template Name" := AssemblySetup."Item Journal Tmpl. Residue N24";
        ItemJnlLine."Journal Batch Name" := AssemblySetup."Item Journal Batch Residue N24";

        ExItemJnlLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        ExItemJnlLine.SetRange("Journal Template Name", ItemJnlLine."Journal Template Name");
        ExItemJnlLine.SetRange("Journal Batch Name", ItemJnlLine."Journal Batch Name");
        if ExItemJnlLine.FindLast() then
            ItemJnlLine."Line No." := ExItemJnlLine."Line No." + 1000;

        ItemJnlLine.Validate("Gen. Bus. Posting Group", AssemblySetup."Def.Gen.Bus.Post.Gr. Adjmt N24");
        ItemJnlLine."Posting Date" := WorkDate();
        ItemJnlLine."Document No." := AssemblyHeader."No.";
        ItemJnlLine."External Document No." := AssemblyHeader."External Document No. N24";
        ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
        ItemJnlLine."Location Code" := AssemblySetup."Def. Location for Residue N24";
    end;

    procedure PostResidueLines(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblySetup: Record "Assembly Setup";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin
        AssemblySetup.Get();

        ItemJnlLine.SetRange("Journal Template Name", AssemblySetup."Item Journal Tmpl. Residue N24");
        ItemJnlLine.SetRange("Journal Batch Name", AssemblySetup."Item Journal Batch Residue N24");
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
        AssemblySetup: Record "Assembly Setup";
        TempItemJournalLine: Record "Item Journal Line" temporary;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        QtyToTransfer: Decimal;
    begin
        AssemblySetup.Get();

#pragma warning disable LC0051
        //Filtr może być większy od pola
        AssemblyLine.SetFilter("Location Code", '<>%1', AssemblySetup."In-Production Location N24");
#pragma warning restore LC0051
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        if AssemblyLine.FindSet() then
            repeat
                AssemblyLine.CalcFields("External Document No. N24", "Quantity Transferred N24");

                QtyToTransfer := AssemblyLine.Quantity;

                if QtyToTransfer > 0 then begin
                    InsertTransferLine(TempItemJournalLine, AssemblyLine, QtyToTransfer);
                    ItemJnlPostLine.Run(TempItemJournalLine);
                    InsertTransferredAssemblyLine(AssemblyLine, QtyToTransfer);
                    ReduceAssemblyLineQuantity(AssemblyLine, QtyToTransfer, false);
                end;
            until AssemblyLine.Next() = 0;

    end;

    local procedure InsertTransferLine(var ItemJournalLine: Record "Item Journal Line"; AssemblyLine: Record "Assembly Line"; QtyToTransfer: Decimal)
    var
        AssemblySetup: Record "Assembly Setup";
        LineNo: Integer;
    begin
        LineNo := ItemJournalLine."Line No." + 1000;

        ItemJournalLine.Init();
        ItemJournalLine."Line No." := LineNo;

        AssemblySetup.Get();

        ItemJournalLine."Journal Template Name" := AssemblySetup."Item Journal Tmpl. Residue N24";
        ItemJournalLine."Journal Batch Name" := AssemblySetup."Item Journal Batch Residue N24";

        ItemJournalLine.Validate("Posting Date", WorkDate());


        AssemblySetup.TestField("Def.Gen.Bus.Post.Gr. Adjmt N24");

        ItemJournalLine.Validate("Gen. Bus. Posting Group", AssemblySetup."Def.Gen.Bus.Post.Gr. Adjmt N24");
        ItemJournalLine.Validate("Document No.", AssemblyLine."Document No.");
        ItemJournalLine.Validate("Document Line No.", AssemblyLine."Line No.");
        ItemJournalLine.Validate("External Document No.", AssemblyLine."External Document No. N24");
        ItemJournalLine.Validate("Entry Type", ItemJournalLine."Entry Type"::Transfer);
        ItemJournalLine.Validate("Item No.", AssemblyLine."No.");
        ItemJournalLine.Validate(Quantity, QtyToTransfer);
        ItemJournalLine.Validate("Location Code", AssemblyLine."Location Code");
        ItemJournalLine.Validate("New Location Code", AssemblySetup."In-Production Location N24");
        ItemJournalLine.Validate("Dimension Set ID", AssemblyLine."Dimension Set ID");
        ItemJournalLine.Validate("New Dimension Set ID", AssemblyLine."Dimension Set ID");
        ItemJournalLine.Insert();
    end;

    local procedure InsertTransferredAssemblyLine(AssemblyLine: Record "Assembly Line"; QtyToTransfer: Decimal)
    var
        AssemblyLine2: Record "Assembly Line";
        AssemblySetup: Record "Assembly Setup";
    begin
        AssemblySetup.Get();

        AssemblyLine2.Copy(AssemblyLine);

        AssemblyLine.SetRange("Document Type", AssemblyLine."Document Type");
        AssemblyLine.SetRange("Document No.", AssemblyLine."Document No.");
        AssemblyLine.SetRange("Line No.", AssemblyLine."Line No.", AssemblyLine."Line No." + 1000);
        if AssemblyLine.FindLast() then;

        AssemblyLine2."Line No." := AssemblyLine."Line No." + 10;
        AssemblyLine2."Location Code" := CopyStr(AssemblySetup."In-Production Location N24", 1, MaxStrLen(AssemblyLine2."Location Code"));
        AssemblyLine2.Validate(Quantity, QtyToTransfer);
        AssemblyLine2.Validate("Quantity to Consume", QtyToTransfer);

        AssemblyLine2.Insert();
    end;

    local procedure ReduceAssemblyLineQuantity(var AssemblyLine: Record "Assembly Line"; QtyToTransfer: Decimal; DeleteIfFullyTransferred: Boolean)
    begin
        AssemblyLine.Validate(Quantity, AssemblyLine.Quantity - QtyToTransfer);
        AssemblyLine.Modify();

        if DeleteIfFullyTransferred then
            if AssemblyLine.Quantity = 0 then
                AssemblyLine.Delete();
    end;

    procedure UpdateResidueJournalLines(AssemblyHeader: Record "Assembly Header"; ResidueItemJnlLine: Record "Item Journal Line")
    var
        AssemblyLine: Record "Assembly Line";
        ItemJnlLine: Record "Item Journal Line";
        ResidueItemNo: Code[20];
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
                        ItemJnlLine.Validate("Item No.", ResidueItemNo);
                        ItemJnlLine.Validate("Unit Amount", ResidueUnitAmount);
                        ItemJnlLine.Validate("Dimension Set ID", AssemblyHeader."Dimension Set ID");
                        ItemJnlLine.Insert();
                    end;
            until AssemblyLine.Next() = 0;
        end;
    end;

    local procedure FindRelatedItem(ItemNo: Code[20]; FindWithPrefix: Char): Code[20]
    var
        Item: Record Item;
        ItemToFindNo: Code[20];
        JoinTwoValuesTok: Label '%1%2', Locked = true;
    begin
        ItemToFindNo := StrSubstNo(JoinTwoValuesTok, FindWithPrefix, CopyStr(ItemNo, 2));

        if Item.Get(ItemToFindNo) then
            exit(Item."No.");
    end;

    procedure UpdateAssemblyLinesWithDefaultLocation(AssemblyHeader: Record "Assembly Header")
    var
        AssemblyLine: Record "Assembly Line";
        AssemblySetup: Record "Assembly Setup";
    begin
        AssemblySetup.Get();
        AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
        AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
        AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
        AssemblyLine.ModifyAll("Location Code", AssemblySetup."Def. Location for Material N24");
    end;

    procedure GetATOExternalDocumentNo(AssemblyHeader: Record "Assembly Header"): Code[35]
    var
        ATOLink: Record "Assemble-to-Order Link";
        SalesHeader: Record "Sales Header";
    begin
        if not AssemblyHeader.IsAsmToOrder() then
            exit;

        if not ATOLink.GetATOLink(AssemblyHeader) then
            exit;

        if SalesHeader.Get(ATOLink."Document Type", ATOLink."Document No.") then
            exit(SalesHeader."External Document No.");
    end;

    procedure TestATOReleased(SalesHeader: Record "Sales Header")
    var
        AssemblyHeader: Record "Assembly Header";
        SalesLine: Record "Sales Line";
    begin
        if (SalesHeader."Document Type" <> "Sales Document Type"::Order) and (not SalesHeader.Ship) then
            exit;

        SalesLine.SetRange("Document Type", "Sales Document Type"::Order);
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("Qty. to Assemble to Order", '<>0');
        SalesLine.SetFilter("Qty. to Ship", '<>0');
        if SalesLine.FindSet() then
            repeat
                if SalesLine.AsmToOrderExists(AssemblyHeader) then
                    AssemblyHeader.TestField(Status, AssemblyHeader.Status::Released);
            until SalesLine.Next() = 0;
    end;

    procedure SetHeaderDimensionsFromInventoryAdjmtAccount(var AssemblyHeader: Record "Assembly Header"; UpdateLines: Boolean)
    var
        AsmLine: Record "Assembly Line";
        DefaultDimension: Record "Default Dimension";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
        NewDimSet: Integer;
        OldDimSet: Integer;
    begin
        DefaultDimension.SetRange("Table ID", Database::"G/L Account");
        DefaultDimension.SetRange("No.", GetInventoryAdjustmentAccount(AssemblyHeader));
        DefaultDimension.SetRange("Value Posting", DefaultDimension."Value Posting"::"Same Code");
        if DefaultDimension.FindSet() then begin
            DimMgt.GetDimensionSet(TempDimSetEntry, AssemblyHeader."Dimension Set ID");

            repeat
                TempDimSetEntry.Init();
                TempDimSetEntry.Validate("Dimension Code", DefaultDimension."Dimension Code");
                TempDimSetEntry.Validate("Dimension Value Code", DefaultDimension."Dimension Value Code");
                if not TempDimSetEntry.Insert() then
                    if not TempDimSetEntry.Modify() then;
            until DefaultDimension.Next() = 0;

            OldDimSet := AssemblyHeader."Dimension Set ID";
            NewDimSet := DimMgt.GetDimensionSetID(TempDimSetEntry);

            AssemblyHeader."Dimension Set ID" := NewDimSet;
            DimMgt.UpdateGlobalDimFromDimSetID(AssemblyHeader."Dimension Set ID", AssemblyHeader."Shortcut Dimension 1 Code", AssemblyHeader."Shortcut Dimension 2 Code");

            AsmLine.SetRange("Document No.", AssemblyHeader."No.");
            AsmLine.SetRange("Document Type", AssemblyHeader."Document Type");
            if AsmLine.FindSet() then
                repeat
                    AsmLine.UpdateDim(NewDimSet, OldDimSet);

#pragma warning disable AA0214
                    //UpdateDim modyfikuje AsmLine
                    AsmLine.Modify();
#pragma warning restore AA0214
                until AsmLine.Next() = 0;
        end;
    end;

    procedure SetResidueDimensionsFromInventoryAdjmtAccount(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblySetup: Record "Assembly Setup";
        DefaultDimension: Record "Default Dimension";
        GLSetup: Record "General Ledger Setup";
        ItemJnlLine: Record "Item Journal Line";
    begin
        AssemblySetup.Get();
        GLSetup.Get();
        ItemJnlLine.SetRange("Journal Template Name", AssemblySetup."Item Journal Tmpl. Residue N24");
        ItemJnlLine.SetRange("Journal Batch Name", AssemblySetup."Item Journal Batch Residue N24");
        ItemJnlLine.SetRange("External Document No.", AssemblyHeader."External Document No. N24");
        ItemJnlLine.SetRange("Document No.", AssemblyHeader."No.");
        if ItemJnlLine.FindSet() then
            repeat
                DefaultDimension.SetRange("Table ID", Database::"G/L Account");
                DefaultDimension.SetRange("No.", GetInventoryAdjustmentAccount(AssemblyHeader));
                DefaultDimension.SetRange("Value Posting", DefaultDimension."Value Posting"::"Same Code");
                if DefaultDimension.FindSet() then
                    repeat
                        if GLSetup."Shortcut Dimension 1 Code" = DefaultDimension."Dimension Code" then begin
                            ItemJnlLine.Validate("Shortcut Dimension 1 Code", DefaultDimension."Dimension Value Code");
                            ItemJnlLine.Modify();
                        end;

                        if GLSetup."Shortcut Dimension 2 Code" = DefaultDimension."Dimension Code" then begin
                            ItemJnlLine.Validate("Shortcut Dimension 2 Code", DefaultDimension."Dimension Value Code");
                            ItemJnlLine.Modify();
                        end;
                    until DefaultDimension.Next() = 0;
            until ItemJnlLine.Next() = 0;
    end;

    procedure UpdateResidueDimensionsFromAssemblyHeader(var AssemblyHeader: Record "Assembly Header")
    var
        AssemblySetup: Record "Assembly Setup";
        GLSetup: Record "General Ledger Setup";
        ItemJnlLine: Record "Item Journal Line";
    begin
        AssemblySetup.Get();
        GLSetup.Get();

        ItemJnlLine.SetRange("Journal Template Name", AssemblySetup."Item Journal Tmpl. Residue N24");
        ItemJnlLine.SetRange("Journal Batch Name", AssemblySetup."Item Journal Batch Residue N24");
        ItemJnlLine.SetRange("External Document No.", AssemblyHeader."External Document No. N24");
        ItemJnlLine.SetRange("Document No.", AssemblyHeader."No.");
        if ItemJnlLine.FindSet() then
            repeat
                ItemJnlLine.CopyDim(AssemblyHeader."Dimension Set ID");

#pragma warning disable AA0214
                //CopyDim modyfikuje ItemJnlLine
                ItemJnlLine.Modify();
#pragma warning restore AA0214

            until ItemJnlLine.Next() = 0;
    end;

    local procedure GetInventoryAdjustmentAccount(AssemblyHeader: Record "Assembly Header"): Code[20]
    var
        GLAccount: Record "G/L Account";
        GenPostSetup: Record "General Posting Setup";
        GLAccount2Tok: Label '411-1', Locked = true;
        GLAccountTok: Label '4111', Locked = true;
    begin
        if (not GLAccount.Get(GLAccount2Tok)) and (not GLAccount.Get(GLAccountTok)) then
            exit;

        if GenPostSetup.Get(AssemblyHeader."ITI Gen. Bus. Posting Group", AssemblyHeader."Gen. Prod. Posting Group") then
            GLAccount.Get(GenPostSetup."Inventory Adjmt. Account");

        exit(GLAccount."No.");
    end;

    procedure CheckAssemblyBeforValidateExtDocumentNo(SalesHeader: Record "Sales Header")
    var
        AssembletoOrderLink: Record "Assemble-to-Order Link";
        ConfirmManagement: Codeunit "Confirm Management";
        ExternalDocumentNoMgt: Codeunit "ExternalDocumentNoMgt N24";
        UpdateQst: Label 'Field %1 will not be updated on related assembly orders.\Do you want to continue?', Comment = '%1 - "External Document No." caption';
    begin
        ExternalDocumentNoMgt.ExternalDocumentNoWasUsed(SalesHeader."External Document No.", true);

        AssembletoOrderLink.SetRange("Document Type", SalesHeader."Document Type");
        AssembletoOrderLink.SetRange("Document No.", SalesHeader."No.");
        if not AssembletoOrderLink.IsEmpty() then
            if not ConfirmManagement.GetResponse(StrSubstNo(UpdateQst, SalesHeader.FieldCaption("External Document No.")), false) then
                Error('');
    end;

    procedure FilterItemJnlBatchOnBeforeLookupName(var ItemJnlBatch: Record "Item Journal Batch")
    var
        AssemblySetup: Record "Assembly Setup";
    begin
        if not AssemblySetup.Get() then
            exit;

        if ItemJnlBatch."Journal Template Name" = AssemblySetup."Item Journal Tmpl. Residue N24" then begin
            ItemJnlBatch.FilterGroup(2);
            ItemJnlBatch.SetFilter(Name, '<>%1', AssemblySetup."Item Journal Batch Residue N24");
            ItemJnlBatch.FilterGroup(0);
        end;
    end;

    procedure SetDefaultMaterialLocation(var AssemblyLine: Record "Assembly Line")
    var
        AssemblySetup: Record "Assembly Setup";
    begin
        if not AssemblySetup.Get() then
            exit;

        if AssemblySetup."Def. Location for Material N24" <> '' then
            AssemblyLine.Validate("Location Code", AssemblySetup."Def. Location for Material N24");
    end;

    procedure ValidateInProdAssemblyLine(var Rec: Record "Assembly Line"; var xRec: Record "Assembly Line")
    var
        AssemblySetup: Record "Assembly Setup";
        ConfirmManagement: Codeunit "Confirm Management";
        UpdateFieldQst: Label 'This action may lead to an inconsistency in stock because item was transferred to production already.\Do you want to continue?';
    begin
        AssemblySetup.Get();
        if (Rec."Location Code" = AssemblySetup."In-Production Location N24") or
            (xRec."Location Code" = AssemblySetup."In-Production Location N24") then
            if (Rec.Quantity <> xRec.Quantity) or (Rec."Location Code" <> xRec."Location Code") then
                if not ConfirmManagement.GetResponse(UpdateFieldQst, false) then
                    Error('');
    end;

    procedure NotifyIfLocationisInProduction(AssemblyLine: Record "Assembly Line"; UpdateLocation: Boolean; UpdateQuantity: Boolean; UpdateUOM: Boolean)
    var
        AssemblySetup: Record "Assembly Setup";
        NoAssemblySetupErr: Label 'No assembly setup exists';
        UpdateLineErr: Label 'You could not update %1 because assembly order is in progress or completed', Comment = '%1 - Location Code';
    begin
        if not AssemblySetup.Get() then
            Error(NoAssemblySetupErr);

        if AssemblyLine."Location Code" = AssemblySetup."In-Production Location N24" then begin
            if UpdateLocation then
                Error(UpdateLineErr, AssemblyLine.FieldCaption("Location Code"));

            if UpdateQuantity then
                Error(UpdateLineErr, AssemblyLine.FieldCaption(Quantity));

            if UpdateUOM then
                Error(UpdateLineErr, AssemblyLine.FieldCaption("Unit of Measure Code"));
        end;
    end;
}
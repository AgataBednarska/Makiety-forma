codeunit 50000 "Custom Events N24"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendPurchaseDocForApproval', '', false, false)]
    local procedure ApprovalsMgmt_OnSendPurchaseDocForApproval(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseMgtN24: Codeunit "PurchaseMgt N24";
    begin
        PurchaseMgtN24.CheckPurchaseDocumentDimensions(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::table, database::"Assemble-to-Order Link", 'OnAfterUpdateAsm', '', false, false)]
    local procedure AssembletoOrderLink_OnAfterUpdateAsm(AsmHeader: Record "Assembly Header")
    var
        AssemblyMgtN24: Codeunit "AssemblyMgt N24";
    begin
        AsmHeader."External Document No. N24" := AssemblyMgtN24.GetATOExternalDocumentNo(AsmHeader);
        AsmHeader.Modify();
    end;

    [EventSubscriber(ObjectType::table, database::"Assemble-to-Order Link", 'OnBeforeAsmHeaderModify', '', false, false)]
    local procedure AssembletoOrderLink_OnBeforeAsmHeaderModify(var AssemblyHeader: Record "Assembly Header"; var SalesLine: Record "Sales Line")
    var
        AssemblyMgtN24: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgtN24.UpdateAssemblyLinesWithDefaultLocation(AssemblyHeader);

        AssemblyMgtN24.SetHeaderDimensionsFromInventoryAdjmtAccount(AssemblyHeader, true);
    end;

    [EventSubscriber(ObjectType::Table, database::"Assembly Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure AssemblyLine_OnAfterCopyFromItem(var AssemblyLine: Record "Assembly Line"; Item: Record Item; AssemblyHeader: Record "Assembly Header")
    var
        AssemblyMgt: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgt.SetDefaultMaterialLocation(AssemblyLine);
    end;

    [EventSubscriber(ObjectType::Table, database::"Assembly Line", 'OnBeforeValidateEvent', 'Location Code', false, false)]
    local procedure AssemblyLine_OnBeforeValidateEvent_LocationCode(var Rec: Record "Assembly Line"; var xRec: Record "Assembly Line"; CurrFieldNo: Integer)
    var
        AssemblyMgtN24: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgtN24.ValidateInProdAssemblyLine(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Assembly Line", 'OnBeforeValidateEvent', 'Quantity', false, false)]
    local procedure AssemblyLine_OnBeforeValidateEvent_Quantity(var Rec: Record "Assembly Line"; var xRec: Record "Assembly Line"; CurrFieldNo: Integer)
    var
        AssemblyMgtN24: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgtN24.ValidateInProdAssemblyLine(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Assembly Line Management", 'OnBeforeUpdateExistingLine', '', false, false)]
    local procedure AssemblyLineManagement_OnBeforeUpdateExistingLine(var AsmHeader: Record "Assembly Header"; OldAsmHeader: Record "Assembly Header"; CurrFieldNo: Integer; var AssemblyLine: Record "Assembly Line"; UpdateDueDate: Boolean; UpdateLocation: Boolean; UpdateQuantity: Boolean; UpdateUOM: Boolean; UpdateQtyToConsume: Boolean; UpdateDimension: Boolean; var IsHandled: Boolean)
    var
        AssemblyMgtN24: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgtN24.NotifyIfLocationisInProduction(AssemblyLine, UpdateLocation, UpdateQuantity, UpdateUOM);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ItemJnlManagement, 'OnBeforeLookupName', '', false, false)]
    local procedure ItemJnlManagement_OnBeforeLookupName(var ItemJnlBatch: Record "Item Journal Batch")
    var
        AssemblyMgt: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgt.FilterItemJnlBatchOnBeforeLookupName(ItemJnlBatch);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterCheckPurchDoc', '', false, false)]
    local procedure OnAfterCheckPurchDoc(var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    begin
        PurchHeader.TestField("ITI SAFT Ext. Document No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure OnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        FinancialMgt: Codeunit "FinancialMgt N24";
    begin
        FinancialMgt.AssignPostingDescriptionToGLFromPurchaseLine(PurchaseLine, InvoicePostBuffer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ITI Post Bank Statement", 'OnBeforeGenJnlPostlineRunWithCheck', '', false, false)]
    local procedure OnBeforeGenJnlPostlineRunWithCheck(var GenJnlLine: Record "Gen. Journal Line")
    var
        FinancialMgt: Codeunit "FinancialMgt N24";
    begin
        FinancialMgt.TransferSalespersonCode(GenJnlLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldSalesDocNoLine', '', false, false)]
    local procedure OnBeforeInsertOldSalesDocNoLine(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; OldDocType: Option; OldDocNo: Code[20]; var IsHandled: Boolean)
    var
        ExternalDocumentNoMgt: Codeunit "ExternalDocumentNoMgt N24";
    begin
        ExternalDocumentNoMgt.CheckExternalDocNoAlreadyExistsAndCreatenewSalesLine(ToSalesLine, OldDocType, OldDocNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    begin
        SalesHeader.TestField("Salesperson Code");
    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Assembly Line Management", 'OnBeforeUpdateAssemblyLines', '', false, false)]
    local procedure OnBeforeUpdateAssemblyLines(var AsmHeader: Record "Assembly Header"; OldAsmHeader: Record "Assembly Header"; FieldNum: Integer; ReplaceLinesFromBOM: Boolean; CurrFieldNo: Integer; CurrentFieldNum: Integer)
    var
        AssemblyMgtN24: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgtN24.UpdateResidueDimensionsFromAssemblyHeader(AsmHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'ITI VAT Settlement Date', false, false)]
    local procedure PurchaseHeader_OnAfterValidateEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    begin
        Rec.SetHideValidationDialog(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeConfirmUpdateCurrencyFactor', '', false, false)]
    local procedure PurchaseHeader_OnBeforeConfirmUpdateCurrencyFactor(PurchaseHeader: Record "Purchase Header"; var HideValidationDialog: Boolean)
    begin
        HideValidationDialog := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure PurchaseHeader_OnBeforeInsertEvent(var Rec: Record "Purchase Header")
    begin
        Rec."Assigned User ID" := CopyStr(UserId, 1, MaxStrLen(Rec."Assigned User ID"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeUpdatePurchLinesByFieldNo', '', false, false)]
    local procedure PurchaseHeader_OnBeforeUpdatePurchLinesByFieldNo(var PurchaseHeader: Record "Purchase Header"; ChangedFieldNo: Integer; var AskQuestion: Boolean; var IsHandled: Boolean)
    begin
        if ChangedFieldNo = PurchaseHeader.FieldNo("Currency Factor") then
            AskQuestion := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeValidateEvent', 'ITI VAT Settlement Date', false, false)]
    local procedure PurchaseHeader_OnBeforeValidateEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    begin
        Rec.SetHideValidationDialog(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure PurchaseLine_OnBeforeValidateEvent(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if Rec.Type <> Rec.Type::Item then
            exit;

        if PurchaseHeader.Get(Rec."Document Type", Rec."Document No.") then
            PurchaseHeader.TestField("Location Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure PurchPost_OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        PurchaseMgt: Codeunit "PurchaseMgt N24";
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
            PurchaseMgt.RemoveInvoicedOrdersOfPostedInvoice(PurchInvHdrNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure PurchPost_OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        PurchRcptHeader."SAFT Ext. Document No. N24" := CopyStr(PurchaseHeader."ITI SAFT Ext. Document No.", 1, MaxStrLen(PurchRcptHeader."SAFT Ext. Document No. N24"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeReturnShptHeaderInsert', '', false, false)]
    local procedure PurchPost_OnBeforeReturnShptHeaderInsert(var ReturnShptHeader: Record "Return Shipment Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        ReturnShptHeader."SAFT Ext. Document No. N24" := CopyStr(PurchHeader."ITI SAFT Ext. Document No.", 1, MaxStrLen(ReturnShptHeader."SAFT Ext. Document No. N24"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure ReportManagement_OnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        case ReportId of
            Report::"Customer/Item Sales":
                NewReportId := Report::"Customer/Item Sales Total N24";
        end;
    end;

    [EventSubscriber(ObjectType::table, Database::"Return Receipt Line", 'OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine', '', false, false)]
    local procedure ReturnReceiptLine_OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine(var ReturnReceiptLine: Record "Return Receipt Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var IsHandled: Boolean)
    var
        ExternalDocumentNoMgt: Codeunit "ExternalDocumentNoMgt N24";
    begin
        ReturnReceiptLine.CalcFields("External Document No. N24");
        ExternalDocumentNoMgt.InsertSalesLineForExternalDocumentNo(SalesLine, ReturnReceiptLine."External Document No. N24", NextLineNo);
    end;

    [EventSubscriber(ObjectType::Table, database::"Assembly Header", 'OnAfterValidateEvent', 'ITI Gen. Bus. Posting Group', false, false)]
    local procedure RunOnAfterValidateGenBusPostingGroup(var Rec: Record "Assembly Header")
    var
        AssemblyMgtN24: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgtN24.SetHeaderDimensionsFromInventoryAdjmtAccount(Rec, true);
        AssemblyMgtN24.SetResidueDimensionsFromInventoryAdjmtAccount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Assembly Header", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure RunOnAfterValidateItemNo(var Rec: Record "Assembly Header")
    var
        AssemblyMgtN24: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgtN24.SetHeaderDimensionsFromInventoryAdjmtAccount(Rec, true);
        AssemblyMgtN24.SetResidueDimensionsFromInventoryAdjmtAccount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure SalesHeader_OnBeforeInsertEvent(var Rec: Record "Sales Header")
    begin
        Rec."Assigned User ID" := CopyStr(UserId, 1, MaxStrLen(Rec."Assigned User ID"));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'External Document No.', false, false)]
    local procedure SalesHeader_OnBeforeValidateEvent(var Rec: Record "Sales Header")
    var
        AssemblyMgt: Codeunit "AssemblyMgt N24";
    begin
        AssemblyMgt.CheckAssemblyBeforValidateExtDocumentNo(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure SalesLine_OnBeforeValidateEvent_No(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec.Type <> Rec.Type::Item then
            exit;

        if SalesHeader.Get(Rec."Document Type", Rec."Document No.") then
            SalesHeader.TestField("Location Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Qty. to Assemble to Order', false, false)]
    local procedure SalesLine_OnBeforeValidateEventQty_toAssembletoOrder(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec."Qty. to Assemble to Order" > 0 then begin
            SalesHeader.Get(Rec."Document Type", Rec."Document No.");
            SalesHeader.TestField("External Document No.");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckSalesDoc', '', false, false)]
    local procedure SalesPost_OnAfterCheckSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    var
        AssyMgt: Codeunit "AssemblyMgt N24";
    begin
        SalesHeader.TestField("External Document No.");

        if SalesHeader."Document Type" = "Sales Document Type"::Order then
            AssyMgt.TestATOReleased(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure SalesPost_OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
    var
        SalesMgt: Codeunit "SalesMgt N24";
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            SalesMgt.RemoveInvoicedOrdersOfPostedInvoice(SalesInvHdrNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnAfterCreateLinesOnBeforeGLPosting', '', false, false)]
    local procedure SalesPostPrepayments_OnAfterCreateLinesOnBeforeGLPosting(var SalesHeader: Record "Sales Header"; SalesInvHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var TempPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer" temporary; DocumentType: Option Invoice,"Credit Memo"; var LastLineNo: Integer)
    var
        SalesMgt: Codeunit "SalesMgt N24";
    begin
        SalesMgt.InsertCommentsToPostedSaleslines(SalesHeader, SalesInvHeader, SalesCrMemoHeader, DocumentType, LastLineNo);
    end;

    [EventSubscriber(ObjectType::table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure SalesShipmentLine_OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean)
    var
        ExternalDocumentNoMgt: Codeunit "ExternalDocumentNoMgt N24";
    begin
        SalesShptLine.CalcFields("External Document No. N24");
        ExternalDocumentNoMgt.InsertSalesLineForExternalDocumentNo(SalesLine, SalesShptLine."External Document No. N24", NextLineNo);
    end;
}
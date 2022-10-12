codeunit 50120 "ITI CU6620EventHandler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Copy Document Mgt.", 'OnBeforeInsertOldSalesDocNoLine', '', false, false)]
    local procedure OnBeforeInsertOldSalesDocNoLine(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; OldDocType: Option; OldDocNo: Code[20]; var IsHandled: Boolean)
    var
        SalesLine2: Record "Sales Line";
        ExtDocNoText: Label 'Ext. Document No. %1:';
        ExtDocNo: code[250];
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ReturnReceiptHeader: Record "Return Receipt Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        FromDocType: Option "Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo";
    begin
        case (OldDocType - 1) of
            FromDocType::"Sales Shipment":
                If SalesShipmentHeader.get(OldDocNo) then
                    ExtDocNo := SalesShipmentHeader."External Document No.";
            FromDocType::"Sales Invoice":
                If SalesInvoiceHeader.get(OldDocNo) then
                    ExtDocNo := SalesInvoiceHeader."External Document No.";
            FromDocType::"Sales Return Receipt":
                If ReturnReceiptHeader.get(OldDocNo) then
                    ExtDocNo := ReturnReceiptHeader."External Document No.";
            FromDocType::"Sales Credit Memo":
                If SalesCrMemoHeader.get(OldDocNo) then
                    ExtDocNo := SalesCrMemoHeader."External Document No.";
        end;
        if ExtDocNo <> '' then begin
            SalesLine2.copy(ToSalesLine);
            SalesLine2."Line No." -= 1000;
            SalesLine2.Description := StrSubstNo(ExtDocNoText, ExtDocNo);
            SalesLine2.Insert();
        end;
    end;
}

codeunit 50117 "ITI CU90EventHandler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeReturnShptHeaderInsert', '', false, false)]
    local procedure RunOnBeforeReturnShptHeaderInsert(var ReturnShptHeader: Record "Return Shipment Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        ReturnShptHeader."ITI SAFT Ext. Document No." := PurchHeader."ITI SAFT Ext. Document No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePurchRcptHeaderInsert', '', false, false)]
    local procedure OnBeforePurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        PurchRcptHeader."ITI SAFT Ext. Document No." := PurchaseHeader."ITI SAFT Ext. Document No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterCheckPurchDoc', '', false, false)]
    local procedure OnAfterCheckPurchDoc(var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    begin
        PurchHeader.TestField("ITI SAFT Ext. Document No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    procedure RunOnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
            RemoveInvoicedOrdersOfPostedInvoice(PurchInvHdrNo);
    end;

    local procedure RemoveInvoicedOrdersOfPostedInvoice(PurchInvHdrNo: Code[20])
    var
        PurchHeaders: Record "Purchase Header";
        PurchInvLine: Record "Purch. Inv. Line";
        DeleteInvoicedPurchOrders: Report "Delete Invoiced Purch. Orders";
        OrderNoFilter: Text;
    begin
        PurchInvLine.SetRange("Document No.", PurchInvHdrNo);
        if PurchInvLine.FindSet() then
            repeat
                if PurchInvLine."Order No." <> '' then
                    if StrPos(OrderNoFilter, PurchInvLine."Order No.") = 0 then
                        if OrderNoFilter = '' then
                            OrderNoFilter := PurchInvLine."Order No."
                        else
                            OrderNoFilter += '|' + PurchInvLine."Order No.";
            until PurchInvLine.Next() = 0;
        if OrderNoFilter = '' then
            exit;

        PurchHeaders.SetFilter("No.", OrderNoFilter);
        DeleteInvoicedPurchOrders.SetTableView(PurchHeaders);
        DeleteInvoicedPurchOrders.UseRequestPage := false;
        DeleteInvoicedPurchOrders.Run();
    end;
}

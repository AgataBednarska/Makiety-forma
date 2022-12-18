codeunit 50006 "PurchaseMgt N24"
{
    procedure CheckPurchaseDocumentDimensions(PurchaseHeader: Record "Purchase Header")
    var
        TempErrorMessage: Record "Error Message" temporary;
        TempPurchaseLine: Record "Purchase Line" temporary;
        CheckDimensions: Codeunit "Check Dimensions";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        ErrorMessageMgt: Codeunit "Error Message Management";
        PurchPost: Codeunit "Purch.-Post";
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);

        PurchPost.FillTempLines(PurchaseHeader, TempPurchaseLine);
        PurchPost.SetPostingFlags(PurchaseHeader);
        CheckDimensions.CheckPurchDim(PurchaseHeader, TempPurchaseLine);

        ErrorMessageHandler.AppendTo(TempErrorMessage);
        if TempErrorMessage.HasErrors(false) then
            if ErrorMessageHandler.ShowErrors() then
                Error('');
    end;

    procedure RemoveInvoicedOrdersOfPostedInvoice(PurchInvHdrNo: Code[20])
    var
        PurchInvLine: Record "Purch. Inv. Line";
        PurchHeaders: Record "Purchase Header";
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
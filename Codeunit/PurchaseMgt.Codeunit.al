codeunit 50006 "PurchaseMgt N24"
{
    procedure CheckPurchaseDocumentDimensions(PurchaseHeader: Record "Purchase Header")
    var
        TempPurchaseLine: Record "Purchase Line" temporary;
        TempErrorMessage: Record "Error Message" temporary;
        CheckDimensions: codeunit "Check Dimensions";
        PurchPost: Codeunit "Purch.-Post";
        ErrorMessageHandler: Codeunit "Error Message Handler";
        ErrorMessageMgt: Codeunit "Error Message Management";
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
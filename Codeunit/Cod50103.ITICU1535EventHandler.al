codeunit 50103 "ITI CU1535EventHandler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSendPurchaseDocForApproval', '', false, false)]
    procedure OnSendPurchaseDocForApproval(var PurchaseHeader: Record "Purchase Header")
    var
        AutoPurchSplitPaymentMgt: Codeunit "ITI AutoPurchSplitPaymentMgt";
    begin
        // AutoPurchSplitPaymentMgt.SetPurchaseSplitPaymentFromPurchaseHeader(PurchaseHeader);
        CheckPurchaseDocumentDimensions(PurchaseHeader);
    end;

    local procedure CheckPurchaseDocumentDimensions(PurchaseHeader: Record "Purchase Header")
    var
        CheckDimensions: codeunit "Check Dimensions";
        PurchPost: Codeunit "Purch.-Post";
        TempPurchaseLine: Record "Purchase Line" temporary;
        ErrorMessageHandler: Codeunit "Error Message Handler";
        ErrorMessageMgt: Codeunit "Error Message Management";
        TempErrorMessage: Record "Error Message" temporary;
    begin
        ErrorMessageMgt.Activate(ErrorMessageHandler);

        PurchPost.FillTempLines(PurchaseHeader, TempPurchaseLine);
        PurchPost.SetPostingFlags(PurchaseHeader);
        CheckDimensions.CheckPurchDim(PurchaseHeader, TempPurchaseLine);

        ErrorMessageHandler.AppendTo(TempErrorMessage);
        if TempErrorMessage.HasErrors(false) then
            if ErrorMessageHandler.ShowErrors then
                Error('');
    end;
}

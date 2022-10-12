codeunit 50104 "ITI CU415EventHandler"
{
    var
        AutoPurchSplitPaymentMgt: Codeunit "ITI AutoPurchSplitPaymentMgt";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure RunOnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        // AutoPurchSplitPaymentMgt.SetPurchaseSplitPaymentFromPurchaseHeader(PurchaseHeader);
    end;
}

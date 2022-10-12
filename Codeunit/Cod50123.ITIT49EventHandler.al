codeunit 50123 "ITI T49 EventHandler"
{
    ObsoleteState = Pending;
    ObsoleteReason = 'This table will be marked as temporary';

    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    local procedure OnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        if PurchaseLine.Type = PurchaseLine.type::"G/L Account" then begin
            PurchSetup.Get();
            if PurchSetup."Use GLAcc. Line Posting Desc." then
                InvoicePostBuffer."Entry Description" := PurchaseLine.Description;
        end;
    end;
}

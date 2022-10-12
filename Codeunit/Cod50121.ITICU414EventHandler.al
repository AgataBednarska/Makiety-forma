codeunit 50121 "ITI CU414EventHandler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    var
        AutoPurchSplitPaymentMgt: Codeunit "ITI AutoPurchSplitPaymentMgt";
    begin
        SalesHeader.TestField("Salesperson Code");
    end;
}

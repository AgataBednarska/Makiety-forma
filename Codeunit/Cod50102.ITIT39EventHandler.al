codeunit 50102 "ITI T39EventHandler"
{
    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEvent(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line")
    begin
        // if (Rec.Amount <> xRec.Amount) or
        //    (Rec."Amount Including VAT" <> xRec."Amount Including VAT") then
        //     ITIAutoPurchSplitPaymentMgt.SetPurchaseSplitPaymentFromPurchaseLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure OnAfterDeleteEvent(var Rec: Record "Purchase Line")
    begin
        // ITIAutoPurchSplitPaymentMgt.SetPurchaseSplitPaymentFromPurchaseLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEvent(var Rec: Record "Purchase Line")
    begin
        // ITIAutoPurchSplitPaymentMgt.SetPurchaseSplitPaymentFromPurchaseLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure OnBeforeValidateNo(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if Rec.Type = Rec.Type::Item then
            if PurchaseHeader.get(Rec."Document Type", Rec."Document No.") then
                PurchaseHeader.TestField("Location Code");
    end;

    var
        ITIAutoPurchSplitPaymentMgt: Codeunit "ITI AutoPurchSplitPaymentMgt";
}

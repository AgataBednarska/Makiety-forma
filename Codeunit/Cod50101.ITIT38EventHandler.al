codeunit 50101 "ITI T38EventHandler"
{
    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', false, false)]
    local procedure OnAfterCopyBuyFromVendorFieldsFromVendor(var PurchaseHeader: Record "Purchase Header")
    begin
        // ITIAutoPurchSplitPaymentMgt.SetPurchaseSplitPaymentFromPurchaseHeader(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterValidateEvent', 'VAT Registration No.', false, false)]
    local procedure OnafterValidateVATRegistrationNo(var Rec: Record "Purchase Header")
    begin
        // ITIAutoPurchSplitPaymentMgt.SetPurchaseSplitPaymentFromPurchaseHeader(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterValidateEvent', 'Currency Code', false, false)]
    local procedure OnafterValidateCurrencyCode(var Rec: Record "Purchase Header")
    begin
        // ITIAutoPurchSplitPaymentMgt.SetPurchaseSplitPaymentFromPurchaseHeader(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnAfterValidateEvent', 'Buy-from Country/Region Code', false, false)]
    local procedure OnafterValidateBuyFromCountryRegionCode(var Rec: Record "Purchase Header")
    begin
        // ITIAutoPurchSplitPaymentMgt.SetPurchaseSplitPaymentFromPurchaseHeader(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Purchase Header", 'OnBeforeConfirmUpdateCurrencyFactor', '', false, false)]
    local procedure OnBeforeConfirmUpdateCurrencyFactor(PurchaseHeader: Record "Purchase Header"; var HideValidationDialog: Boolean)
    begin
        HideValidationDialog := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeValidateEvent', 'ITI VAT Settlement Date', false, false)]
    local procedure OnBeforeValidateVATSettlementDate(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    begin
        Rec.SetHideValidationDialog(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'ITI VAT Settlement Date', false, false)]
    local procedure OnAfterValidateVATSettlementDate(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; CurrFieldNo: Integer)
    begin
        Rec.SetHideValidationDialog(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeUpdatePurchLinesByFieldNo', '', false, false)]
    local procedure OnBeforeUpdatePurchLinesByFieldNo(var PurchaseHeader: Record "Purchase Header"; ChangedFieldNo: Integer; var AskQuestion: Boolean; var IsHandled: Boolean)
    begin
        If ChangedFieldNo = PurchaseHeader.fieldno("Currency Factor") then
            AskQuestion := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure RunOnBeforeInsertEvent(var Rec: Record "Purchase Header")
    begin
        Rec."Assigned User ID" := UserId;
    end;

    var
        ITIAutoPurchSplitPaymentMgt: Codeunit "ITI AutoPurchSplitPaymentMgt";
}

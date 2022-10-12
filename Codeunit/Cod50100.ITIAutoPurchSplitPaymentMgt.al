codeunit 50100 "ITI AutoPurchSplitPaymentMgt"
{
    procedure SetPurchaseSplitPaymentFromPurchaseLine(var PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseLine.IsTemporary then
            exit;
        if PurchaseHeader.get(PurchaseLine."Document Type", PurchaseLine."Document No.") then begin
            if SetPurchaseSplitPayment(PurchaseHeader) then
                PurchaseHeader.Modify();
        end;
    end;

    procedure SetPurchaseSplitPaymentFromPurchaseHeader(var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader.IsTemporary then
            exit;
        SetPurchaseSplitPayment(PurchaseHeader);
    end;

    local procedure SetPurchaseSplitPayment(var PurchHeader: Record "purchase header") SplitPaymentChanged: Boolean;
    var
        GLSetup: Record "General Ledger Setup";
        CompanyInformation: Record "Company Information";
        SplitPaymentOnMsg: Label 'Split Payment has been turned on';
        SplitPaymentOffMsg: Label 'Split Payment has been turned off';
        SplitPaymentConditionMet: Boolean;
        BigInt: BigInteger;
    begin
        CompanyInformation.get();
        if CompanyInformation."Country/Region Code" <> 'PL' then
            exit;
        if PurchHeader."ITI SP Created Manually" then
            exit;
        GLSetup.get();
        PurchHeader.calcfields("Amount Including VAT", Amount);
        SplitPaymentConditionMet := (PurchHeader."Buy-from Country/Region Code" = 'PL') and
                                    (Evaluate(BigInt, PurchHeader."VAT Registration No.")) and (StrLen(PurchHeader."VAT Registration No.") = 10) and
                                    (PurchHeader."Currency Code" = '') and
                                    (PurchHeader."Amount Including VAT" - PurchHeader.Amount > 0);

        Case PurchHeader."ITI Split Payment" of
            true:
                if not SplitPaymentConditionMet then begin
                    PurchHeader.Validate("ITI Split Payment", false);
                    if not PurchHeader."ITI Split Payment" then begin
                        PurchHeader.validate("ITI SP Created Manually", false);
                        Message(SplitPaymentOffMsg);
                        exit(true);
                    end;
                end;
            false:
                if SplitPaymentConditionMet then begin
                    PurchHeader.Validate("ITI Split Payment", true);
                    if PurchHeader."ITI Split Payment" then begin
                        PurchHeader.validate("ITI SP Created Manually", false);
                        Message(SplitPaymentOnMsg);
                        exit(true);
                    end;
                end;
        end;
    end;
}

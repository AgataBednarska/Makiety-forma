codeunit 50009 "AutoPurchSplitPaymentMgt N24"
{
    procedure SetPurchaseSplitPaymentFromPurchaseLine(var PurchaseLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseLine.IsTemporary then
            exit;

        if not PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then
            exit;
            
        if SetPurchaseSplitPayment(PurchaseHeader) then
            PurchaseHeader.Modify();
    end;

    procedure SetPurchaseSplitPaymentFromPurchaseHeader(var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader.IsTemporary then
            exit;

        SetPurchaseSplitPayment(PurchaseHeader);
    end;

    local procedure SetPurchaseSplitPayment(var PurchHeader: Record "Purchase Header"): Boolean;
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        CompanyInformation: Record "Company Information";
        Constants: Codeunit "Constants N24";
        SplitPaymentConditionMet: Boolean;
        BigInt: BigInteger;
        SplitPaymentOnMsg: Label 'Split Payment has been turned on';
        SplitPaymentOffMsg: Label 'Split Payment has been turned off';
    begin
        CompanyInformation.Get();

        if CompanyInformation."Country/Region Code" <> 'PL' then
            exit;

        if PurchHeader."ITI SP Created Manually" then
            exit;

        GeneralLedgerSetup.Get();

        PurchHeader.CalcFields("Amount Including VAT", Amount);

        SplitPaymentConditionMet := (PurchHeader."Buy-from Country/Region Code" = Constants.GetPLLanguageCode()) and
                                    (Evaluate(BigInt, PurchHeader."VAT Registration No.")) and (StrLen(PurchHeader."VAT Registration No.") = 10) and
                                    (PurchHeader."Currency Code" = '') and
                                    (PurchHeader."Amount Including VAT" - PurchHeader.Amount > 0);

        case PurchHeader."ITI Split Payment" of
            true:
                if not SplitPaymentConditionMet then begin
                    PurchHeader.Validate("ITI Split Payment", false);
                    
                    if not PurchHeader."ITI Split Payment" then begin
                        PurchHeader.Validate("ITI SP Created Manually", false);

                        Message(SplitPaymentOffMsg);

                        exit(true);
                    end;
                end;
            false:
                if SplitPaymentConditionMet then begin
                    PurchHeader.Validate("ITI Split Payment", true);
                    
                    if PurchHeader."ITI Split Payment" then begin
                        PurchHeader.Validate("ITI SP Created Manually", false);

                        Message(SplitPaymentOnMsg);

                        exit(true);
                    end;
                end;
        end;
    end;
}
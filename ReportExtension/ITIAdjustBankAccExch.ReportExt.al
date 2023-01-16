reportextension 50000 "ITIAdjustBankAccExch N24" extends ITIAdjustBankAccExchangeRates
{
    requestpage
    {
        trigger OnOpenPage()
        var
            ErrorLbl: Label 'You cannot use IT Integro functionality because of installed NAV24 functionality';
        begin
            Error(ErrorLbl);
        end;
    }
}
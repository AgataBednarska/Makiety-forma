tableextension 50141 "ITI BankAccountExt" extends "Bank Account"
{
    fields
    {
        field(60000; "ITI Excl. from Exch. Rate Adj."; Boolean)
        {
            Caption = 'Exclude from Exch. Rate Adj.';
            DataClassification = CustomerContent;
        }
    }
}
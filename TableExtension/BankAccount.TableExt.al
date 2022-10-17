tableextension 50027 "Bank Account N24" extends "Bank Account"
{
    fields
    {
        field(50000; "Excl. from Exch. Rate Adj. N24"; Boolean)
        {
            Caption = 'Exclude from Exch. Rate Adj.';
            DataClassification = CustomerContent;
        }
    }
}
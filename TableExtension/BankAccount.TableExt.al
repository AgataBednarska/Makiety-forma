tableextension 50127 "Bank Account N24" extends "Bank Account"
{
    fields
    {
        field(50100; "Excl. from Exch. Rate Adj. N24"; Boolean)
        {
            Caption = 'Exclude from Exch. Rate Adj.';
            DataClassification = CustomerContent;
        }
    }
}
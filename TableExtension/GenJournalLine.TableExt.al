tableextension 50028 "Gen. Journal Line N24" extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "Exchange Rate Diff. N24"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Exchange Rate Difference';
        }
        field(50001; "Appl. to Bank Entry No. N24"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied to Bank Entry No.';
        }
    }
}
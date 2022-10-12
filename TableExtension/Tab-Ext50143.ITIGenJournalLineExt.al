tableextension 50143 "ITI GenJournalLineExt" extends "Gen. Journal Line"
{
    fields
    {
        field(60000; "ITI Exchange Rate Diff."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Exchange Rate Difference';
        }
        field(60001; "ITI Appl. to Bank Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied to Bank Entry No.';
        }
    }
}
tableextension 50173 "Gen. Journal Line N24" extends "Gen. Journal Line"
{
    fields
    {
        field(50102; "Exchange Rate Diff. N24"; Boolean)
        {
            Caption = 'Exchange Rate Difference';
            DataClassification = CustomerContent;
        }
        field(50101; "Appl. to Bank Entry No. N24"; Integer)
        {
            Caption = 'Applied to Bank Entry No.';
            DataClassification = CustomerContent;
        }
        field(50100; "Salespers./Purch. Code N24"; Code[20])
        {
            Caption = 'Salespers./Purch. Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
    }
}
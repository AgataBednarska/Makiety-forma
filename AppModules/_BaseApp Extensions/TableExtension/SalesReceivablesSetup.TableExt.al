tableextension 50176 "Sales & Receivables Setup N24" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Prepmt VAT23 Account N24"; Code[20])
        {
            Caption = 'Prepayment VAT 23% Account';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where("Account Type" = const(Posting), Blocked = const(false), "Direct Posting" = const(true));
        }
        field(50101; "Prepmt VAT8 Account N24"; Code[20])
        {
            Caption = 'Prepayment VAT 8% Account';
            DataClassification = CustomerContent;
            TableRelation = "G/L Account"."No." where("Account Type" = const(Posting), Blocked = const(false), "Direct Posting" = const(true));
        }
    }

}
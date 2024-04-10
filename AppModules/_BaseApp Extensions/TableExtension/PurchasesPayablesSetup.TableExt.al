tableextension 50169 "Purchases & Payables Setup N24" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50100; "GLAcc. Line Post. Desc. N24"; Boolean)
        {
            Caption = 'Use G/L Account Line Posting Description';
            DataClassification = CustomerContent;
        }
    }
}
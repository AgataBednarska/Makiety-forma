tableextension 50129 "Source Code Setup N24" extends "Source Code Setup"
{
    fields
    {
        field(50100; "Bank Trans. Recalculation N24"; Code[10])
        {
            Caption = 'Bank Trans. Recalculation';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
        }
    }
}
tableextension 50029 "Source Code Setup N24" extends "Source Code Setup"
{
    fields
    {
        field(50000; "Bank Trans. Recalculation N24"; Code[10])
        {
            Caption = 'Bank Trans. Recalculation';
            TableRelation = "Source Code";
            DataClassification = CustomerContent;
        }
    }
}
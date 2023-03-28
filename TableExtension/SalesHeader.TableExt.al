tableextension 50100 "Sales Header N24" extends "Sales Header"
{
    fields
    {
        field(50100; "Execution Status N24"; Enum "Sales Execution Status N24")
        {
            Caption = 'Execution Status';
            DataClassification = CustomerContent;
        }
    }
}
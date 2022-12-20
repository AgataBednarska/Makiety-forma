tableextension 50025 "ITI Bank Statement Line N24" extends "ITI Bank Statement Line"
{
    fields
    {
        field(50002; "Salespers./Purch. Code N24"; Code[20])
        {
            Caption = 'Salespers./Purch. Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
    }
}
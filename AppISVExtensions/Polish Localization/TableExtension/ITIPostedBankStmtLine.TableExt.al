tableextension 50026 "ITI Posted Bank Stmt. Line N24" extends "ITI Posted Bank Stmt. Line"
{
    fields
    {
        field(50002; "Salespers./Purch. Code N24"; Code[20])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
        }
    }
}
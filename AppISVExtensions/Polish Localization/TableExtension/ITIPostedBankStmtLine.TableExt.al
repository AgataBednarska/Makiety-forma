tableextension 50126 "ITI Posted Bank Stmt. Line N24" extends "ITI Posted Bank Stmt. Line"
{
    fields
    {
        field(50100; "Salespers./Purch. Code N24"; Code[20])
        {
            Caption = 'Salespers./Purch. Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
    }
}
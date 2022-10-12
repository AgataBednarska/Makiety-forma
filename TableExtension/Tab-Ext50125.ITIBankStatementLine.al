tableextension 50125 "ITI BankStatementLine" extends "ITI Bank Statement Line"
{
    fields
    {
        field(26; "Salespers./Purch. Code"; Code[20])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser";
        }
    }
}
tableextension 50126 "ITI PostedBankStmtLine" extends "ITI Posted Bank Stmt. Line"
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
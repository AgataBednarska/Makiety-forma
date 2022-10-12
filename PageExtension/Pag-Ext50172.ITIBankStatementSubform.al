pageextension 50172 "ITI BankStatementSubform" extends "ITI Bank Statement Subform"
{
    layout
    {
        addafter(CurrencyCode)
        {
            field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
            {
                ApplicationArea = Suite;
            }
        }
    }
}
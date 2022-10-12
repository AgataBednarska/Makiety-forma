pageextension 50173 "ITI PostedBankStmtSubform" extends "ITI Posted Bank Stmt. Subform"
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
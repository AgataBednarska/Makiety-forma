pageextension 50171 "ITI Posted Bank Stmt. Sub. N24" extends "ITI Posted Bank Stmt. Subform"
{
    layout
    {
        addafter(CurrencyCode)
        {
            field("Salespers./Purch. Code N24"; Rec."Salespers./Purch. Code N24")
            {
                ApplicationArea = Suite;
            }
        }
    }
}
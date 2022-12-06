pageextension 50070 "ITI Bank Statement Subform N24" extends "ITI Bank Statement Subform"
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
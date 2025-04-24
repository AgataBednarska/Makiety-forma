pageextension 50217 "Sales & Receivables Setup N24" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group("Prepayments N24")
            {
                Caption = 'Prepayments';

                field("Prepmt VAT23 Account N24"; Rec."Prepmt VAT23 Account N24")
                {
                    ApplicationArea = All;
                }
                field("Prepmt VAT8 Account N24"; Rec."Prepmt VAT8 Account N24")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}
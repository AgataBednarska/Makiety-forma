pageextension 50169 "ITI CustomerLookup" extends "Customer Lookup"
{
    layout
    {
        addafter(Name)
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

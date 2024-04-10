pageextension 50209 "Customer Lookup N24" extends "Customer Lookup"
{
    layout
    {
        addafter(Name)
        {
            field("VAT Registration No. N24"; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
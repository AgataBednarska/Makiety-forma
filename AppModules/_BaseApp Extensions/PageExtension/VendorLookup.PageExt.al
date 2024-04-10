pageextension 50208 "Vendor Lookup N24" extends "Vendor Lookup"
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
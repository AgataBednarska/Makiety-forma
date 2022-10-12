pageextension 50168 "ITI VendorLookup" extends "Vendor Lookup"
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

pageextension 50106 "VendorCard N24" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("Employee N24"; Rec."Employee N24")
            {
                ApplicationArea = All;
            }
        }
        modify("No.")
        {
            Visible = true;
        }
    }
}
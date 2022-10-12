pageextension 50106 "ITI VendorCard" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("ITI Employee"; Rec."ITI Employee")
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

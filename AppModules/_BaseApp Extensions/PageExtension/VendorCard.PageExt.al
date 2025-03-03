pageextension 50146 "VendorCard N24" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("Employee N24"; Rec."Employee N24")
            {
                ApplicationArea = All;
            }
            field("Square Meters Rounding N24"; Rec."Square Meters Rounding N24")
            {
                ApplicationArea = All;
                ToolTip = 'Accepted Values: 0.1, 0.01, 0.001, 0.0001.';
            }
        }
        modify("No.")
        {
            Visible = true;
        }
    }
}
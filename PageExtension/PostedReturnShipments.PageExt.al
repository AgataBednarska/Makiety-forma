pageextension 50028 "Posted Return Shipments N24" extends "Posted Return Shipments"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Return Order No. N24"; Rec."Return Order No.")
            {
                ApplicationArea = Suite;
            }
        }
        modify("Document Date")
        {
            Visible = true;
        }
    }
}
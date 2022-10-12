pageextension 50128 "ITI PostedReturnShipments" extends "Posted Return Shipments"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Return Order No."; Rec."Return Order No.")
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

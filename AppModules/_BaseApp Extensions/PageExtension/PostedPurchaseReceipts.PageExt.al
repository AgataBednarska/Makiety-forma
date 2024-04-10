pageextension 50167 "Posted Purchase Receipts N24" extends "Posted Purchase Receipts"
{
    layout
    {
        modify("Document Date")
        {
            Visible = true;
        }
        addafter("Buy-from Vendor Name")
        {
            field("Vendor Order No. N24"; Rec."Vendor Order No.")
            {
                ApplicationArea = Suite;
            }
            field("Vendor Shipment No. N24"; Rec."Vendor Shipment No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        moveafter("Vendor Shipment No. N24"; "Document Date")
    }
}
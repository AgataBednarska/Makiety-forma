pageextension 50163 "Posted Sales Shipments N24" extends "Posted Sales Shipments"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = true;
        }
        modify("Document Date")
        {
            Visible = true;
        }
        moveafter("Sell-to Customer Name"; "External Document No.")
    }
}
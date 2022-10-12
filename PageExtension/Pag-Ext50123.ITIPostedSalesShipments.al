pageextension 50123 "ITI PostedSalesShipments" extends "Posted Sales Shipments"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = true;
        }
        moveafter("Sell-to Customer Name"; "External Document No.")
        modify("Document Date")
        {
            Visible = true;
        }
    }
}

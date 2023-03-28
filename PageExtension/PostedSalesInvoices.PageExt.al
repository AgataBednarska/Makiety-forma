pageextension 50124 "Posted Sales Invoices N24" extends "Posted Sales Invoices"
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
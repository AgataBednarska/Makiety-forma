pageextension 50124 "ITI PostedSalesInvoices" extends "Posted Sales Invoices"
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

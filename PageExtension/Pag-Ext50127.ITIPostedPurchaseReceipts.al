pageextension 50127 "ITI PostedPurchaseReceipts" extends "Posted Purchase Receipts"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = Suite;
                ToolTip = 'Specifies the vendor''s order number.';
            }
            field("Vendor Shipment No."; Rec."Vendor Shipment No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the vendor''s shipment number. It is inserted in the corresponding field on the source document during posting.';
            }
        }
        modify("Document Date")
        {
            Visible = true;
        }
        moveafter("Vendor Shipment No."; "Document Date")
    }
}

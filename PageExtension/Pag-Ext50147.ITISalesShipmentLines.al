pageextension 50147 "ITI SalesShipmentLines" extends "Sales Shipment Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

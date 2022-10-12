pageextension 50155 "ITI ReturnShipmentLines" extends "Return Shipment Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("ITI SAFT Ext. Document No."; Rec."ITI SAFT Ext. Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

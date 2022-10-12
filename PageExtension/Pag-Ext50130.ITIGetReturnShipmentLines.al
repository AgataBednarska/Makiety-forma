pageextension 50130 "ITI GetReturnShipmentLines" extends "Get Return Shipment Lines"
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

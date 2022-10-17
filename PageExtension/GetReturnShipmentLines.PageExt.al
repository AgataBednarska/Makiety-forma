pageextension 50030 "Get Return Shipment Lines N24" extends "Get Return Shipment Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("SAFT Ext. Document No. N24"; Rec."SAFT Ext. Document No. N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
tableextension 50018 "Return Shipment Header N24" extends "Return Shipment Header"
{
    fields
    {
        field(50000; "SAFT Ext. Document No. N24"; Code[35])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
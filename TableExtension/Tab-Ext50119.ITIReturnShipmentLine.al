tableextension 50119 "ITI ReturnShipmentLine" extends "Return Shipment Line"
{
    fields
    {
        field(50100; "ITI SAFT Ext. Document No."; Code[250])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Return Shipment Header"."ITI SAFT Ext. Document No." where("No." = field("Document No.")));
        }
    }
}

tableextension 50019 "Return Shipment Line N24" extends "Return Shipment Line"
{
    fields
    {
        field(50000; "SAFT Ext. Document No. N24"; Code[250])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Return Shipment Header"."SAFT Ext. Document No. N24" where("No." = field("Document No.")));
        }
    }
}
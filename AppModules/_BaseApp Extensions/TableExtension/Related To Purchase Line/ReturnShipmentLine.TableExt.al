tableextension 50164 "Return Shipment Line N24" extends "Return Shipment Line"
{
    fields
    {
        field(50100; "SAFT Ext. Document No. N24"; Code[250])
        {
            CalcFormula = lookup("Return Shipment Header"."SAFT Ext. Document No. N24" where("No." = field("Document No.")));
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
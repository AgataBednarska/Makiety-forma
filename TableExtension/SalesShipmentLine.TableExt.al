tableextension 50011 "Sales Shipment Line N24" extends "Sales Shipment Line"
{
    fields
    {
        field(50000; "External Document No. N24"; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."External Document No." where("No." = field("Document No.")));
        }
    }
}
tableextension 50111 "Sales Shipment Line N24" extends "Sales Shipment Line"
{
    fields
    {
        field(50100; "External Document No. N24"; Code[35])
        {
            CalcFormula = lookup("Sales Shipment Header"."External Document No." where("No." = field("Document No.")));
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
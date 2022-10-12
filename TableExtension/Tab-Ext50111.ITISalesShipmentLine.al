tableextension 50111 "ITI SalesShipmentLine" extends "Sales Shipment Line"
{
    fields
    {
        field(50100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Shipment Header"."External Document No." where("No." = field("Document No.")));
        }
    }
}

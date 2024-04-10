tableextension 50154 "Sales Invoice Line N24" extends "Sales Invoice Line"
{
    fields
    {
        field(50100; "External Document No. N24"; Code[35])
        {
            CalcFormula = lookup("Sales Invoice Header"."External Document No." where("No." = field("Document No.")));
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
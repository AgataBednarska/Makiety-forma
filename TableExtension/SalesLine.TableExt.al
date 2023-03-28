tableextension 50108 "Sales Line N24" extends "Sales Line"
{
    fields
    {
        field(50100; "External Document No. N24"; Code[35])
        {
            CalcFormula = lookup("Sales Header"."External Document No." where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
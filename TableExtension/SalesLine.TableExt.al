tableextension 50008 "Sales Line N24" extends "Sales Line"
{
    fields
    {
        field(50000; "External Document No. N24"; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."External Document No." where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
    }
}
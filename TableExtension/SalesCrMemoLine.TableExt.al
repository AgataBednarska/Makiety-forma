tableextension 50110 "Sales Cr.Memo Line N24" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50100; "External Document No. N24"; Code[35])
        {
            CalcFormula = lookup("Sales Cr.Memo Header"."External Document No." where("No." = field("Document No.")));
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
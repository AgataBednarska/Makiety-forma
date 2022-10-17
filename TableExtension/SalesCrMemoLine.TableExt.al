tableextension 50010 "Sales Cr.Memo Line N24" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50000; "External Document No. N24"; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."External Document No." where("No." = field("Document No.")));
        }
    }
}
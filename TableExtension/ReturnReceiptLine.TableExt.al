tableextension 50012 "Return Receipt Line N24" extends "Return Receipt Line"
{
    fields
    {
        field(50000; "External Document No. N24"; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Return Receipt Header"."External Document No." where("No." = field("Document No.")));
        }
    }
}
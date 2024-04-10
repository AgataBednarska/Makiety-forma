tableextension 50157 "Return Receipt Line N24" extends "Return Receipt Line"
{
    fields
    {
        field(50100; "External Document No. N24"; Code[35])
        {
            CalcFormula = lookup("Return Receipt Header"."External Document No." where("No." = field("Document No.")));
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
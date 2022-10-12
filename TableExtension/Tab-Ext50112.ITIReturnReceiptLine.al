tableextension 50112 "ITI ReturnReceiptLine" extends "Return Receipt Line"
{
    fields
    {
        field(50100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Return Receipt Header"."External Document No." where("No." = field("Document No.")));
        }
    }
}

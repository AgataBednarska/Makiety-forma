tableextension 50110 "ITI SalesCrMemoLine" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Cr.Memo Header"."External Document No." where("No." = field("Document No.")));
        }
    }
}

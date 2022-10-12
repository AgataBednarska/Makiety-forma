tableextension 50108 "ITI SalesLine" extends "Sales Line"
{
    fields
    {
        field(50100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Header"."External Document No." where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
    }
}

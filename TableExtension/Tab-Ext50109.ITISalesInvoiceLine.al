tableextension 50109 "ITI SalesInvoiceLine" extends "Sales Invoice Line"
{
    fields
    {
        field(50100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Invoice Header"."External Document No." where("No." = field("Document No.")));
        }
    }
}

tableextension 50113 "Purchase Line N24" extends "Purchase Line"
{
    fields
    {
        field(50100; "SAFT Ext. Document No. N24"; Code[250])
        {
            CalcFormula = lookup("Purchase Header"."ITI SAFT Ext. Document No." where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
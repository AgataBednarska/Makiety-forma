tableextension 50113 "ITI PurchaseLine" extends "purchase line"
{
    fields
    {
        field(50100; "ITI SAFT Ext. Document No."; Code[250])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Header"."ITI SAFT Ext. Document No." where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
    }
}

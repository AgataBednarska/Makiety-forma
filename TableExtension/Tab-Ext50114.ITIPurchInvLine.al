tableextension 50114 "ITI PurchInvLine" extends "Purch. Inv. Line"
{
    fields
    {
        field(50100; "ITI SAFT Ext. Document No."; Code[250])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Vendor Invoice No." where("No." = field("Document No.")));
        }
    }
}

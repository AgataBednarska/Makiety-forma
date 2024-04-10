tableextension 50159 "Purch. Inv. Line N24" extends "Purch. Inv. Line"
{
    fields
    {
        field(50100; "SAFT Ext. Document No. N24"; Code[250])
        {
            CalcFormula = lookup("Purch. Inv. Header"."Vendor Invoice No." where("No." = field("Document No.")));
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
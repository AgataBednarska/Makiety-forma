tableextension 50014 "Purch. Inv. Line N24" extends "Purch. Inv. Line"
{
    fields
    {
        field(50000; "SAFT Ext. Document No. N24"; Code[250])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."Vendor Invoice No." where("No." = field("Document No.")));
        }
    }
}
tableextension 50015 "Purch. Cr. Memo Line N24" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50000; "SAFT Ext. Document No. N24"; Code[250])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Cr. Memo Hdr."."ITI SAFT Ext. Document No." where("No." = field("Document No.")));
        }
    }
}
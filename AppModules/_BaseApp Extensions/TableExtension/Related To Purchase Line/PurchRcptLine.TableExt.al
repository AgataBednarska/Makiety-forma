tableextension 50162 "Purch. Rcpt. Line N24" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50100; "SAFT Ext. Document No. N24"; Code[35])
        {
            CalcFormula = lookup("Purch. Rcpt. Header"."SAFT Ext. Document No. N24" where("No." = field("Document No.")));
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
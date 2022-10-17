tableextension 50017 "Purch. Rcpt. Line N24" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50000; "SAFT Ext. Document No. N24"; Code[35])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."SAFT Ext. Document No. N24" where("No." = field("Document No.")));
        }
    }
}
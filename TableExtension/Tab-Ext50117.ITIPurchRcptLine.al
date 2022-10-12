tableextension 50117 "ITI PurchRcptLine" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50100; "ITI SAFT Ext. Document No."; Code[35])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Rcpt. Header"."ITI SAFT Ext. Document No." where("No." = field("Document No.")));
        }
    }
}

tableextension 50002 "Purch. Rcpt. Header N24" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50000; "SAFT Ext. Document No. N24"; Code[35])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
}
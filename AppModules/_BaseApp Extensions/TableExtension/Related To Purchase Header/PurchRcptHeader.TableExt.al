tableextension 50147 "Purch. Rcpt. Header N24" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50100; "SAFT Ext. Document No. N24"; Code[35])
        {
            Caption = 'SAFT Ext. Document No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
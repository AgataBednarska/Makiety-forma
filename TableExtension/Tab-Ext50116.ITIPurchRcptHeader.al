tableextension 50116 "ITI PurchRcptHeader" extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50100; "ITI SAFT Ext. Document No."; Code[35])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
        }
    }
}

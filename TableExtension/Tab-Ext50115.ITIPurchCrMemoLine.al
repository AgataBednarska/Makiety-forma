tableextension 50115 "ITI PurchCrMemoLine" extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50100; "ITI SAFT Ext. Document No."; Code[250])
        {
            Caption = 'SAFT Ext. Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Cr. Memo Hdr."."ITI SAFT Ext. Document No." where("No." = field("Document No.")));
        }
    }
}

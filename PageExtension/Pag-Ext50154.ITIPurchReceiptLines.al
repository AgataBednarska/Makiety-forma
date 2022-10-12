pageextension 50154 "ITI PurchReceiptLines" extends "Purch. Receipt Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("ITI SAFT Ext. Document No."; Rec."ITI SAFT Ext. Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

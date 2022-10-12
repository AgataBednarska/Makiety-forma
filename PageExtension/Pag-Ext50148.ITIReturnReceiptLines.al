pageextension 50148 "ITI ReturnReceiptLines" extends "Return Receipt Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

pageextension 50131 "ITI GetReturnReceiptLines" extends "Get Return Receipt Lines"
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

pageextension 50166 "VAT Entries N24" extends "VAT Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No. N24"; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
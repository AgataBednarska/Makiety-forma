pageextension 50139 "Item Ledger Entries N24" extends "Item Ledger Entries"
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
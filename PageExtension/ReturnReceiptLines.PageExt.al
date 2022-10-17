pageextension 50048 "Return Receipt Lines N24" extends "Return Receipt Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No. N24"; Rec."External Document No. N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
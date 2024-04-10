pageextension 50189 "ITI Get Sales Invoice Lines" extends "ITI Get Sales Invoice Lines"
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
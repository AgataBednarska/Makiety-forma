pageextension 50061 "Posted Assembly Orders N24" extends "Posted Assembly Orders"
{
    layout
    {
        addafter("No.")
        {
            field("External Document No. N24"; Rec."External Document No. N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
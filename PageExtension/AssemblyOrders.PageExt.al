pageextension 50109 "Assembly Orders N24" extends "Assembly Orders"
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
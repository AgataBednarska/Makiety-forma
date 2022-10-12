pageextension 50109 "ITI AssemblyOrders" extends "Assembly Orders"
{
    layout
    {
        addafter("No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

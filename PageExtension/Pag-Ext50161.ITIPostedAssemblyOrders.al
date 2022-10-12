pageextension 50161 "ITI PostedAssemblyOrders" extends "Posted Assembly Orders"
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

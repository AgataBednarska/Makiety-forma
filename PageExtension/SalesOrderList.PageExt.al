pageextension 50001 "Sales Order List N24" extends "Sales Order List"
{
    layout
    {
        addafter(Status)
        {
            field("Execution Status N24"; Rec."Execution Status N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
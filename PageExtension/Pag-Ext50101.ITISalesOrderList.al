pageextension 50101 "ITI Sales Order List" extends "Sales Order List"
{
    layout
    {
        addafter(Status)
        {
            field("Execution Status"; Rec."Execution Status")
            {
                ApplicationArea = All;
            }
        }
    }
}

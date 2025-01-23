pageextension 50216 "Consumption Journal N24" extends "Consumption Journal"
{
    layout
    {
        addafter("Item No.")
        {
            field("Lot No. N24"; Rec."Lot No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
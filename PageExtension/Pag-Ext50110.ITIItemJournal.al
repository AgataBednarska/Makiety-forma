pageextension 50110 "ITI ItemJournal" extends "Item Journal"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
        addafter("Gen. Bus. Posting Group")
        {
            field("Inventory Posting Group"; Rec."Inventory Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}

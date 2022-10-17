pageextension 50010 "Item Journal N24" extends "Item Journal"
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
            field("Inventory Posting Group N24"; Rec."Inventory Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
}
pageextension 50186 "Item List N24" extends "Item List"
{
    layout
    {
        modify("Item Category Code")
        {
            Visible = true;
        }
        addbefore("Item Category Code")
        {
            field("Parent Item Category Code N24"; Rec."Parent Item Category Code N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
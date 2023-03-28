pageextension 50145 "Item Card N24" extends "Item Card"
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
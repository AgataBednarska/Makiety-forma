pageextension 50145 "ITI ItemCard" extends "Item Card"
{
    layout
    {
        modify("Item Category Code")
        {
            Visible = true;
        }
        addbefore("Item Category Code")
        {
            field("Parent Item Category Code"; Rec."Parent Item Category Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

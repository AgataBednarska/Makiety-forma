pageextension 50146 "ITI ItemList" extends "Item List"
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

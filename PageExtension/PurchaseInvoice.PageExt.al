pageextension 50112 "Purchase Invoice N24" extends "Purchase Invoice"
{
    layout
    {
        modify("Buy-from Vendor No.")
        {
            Importance = Promoted;
        }
        addbefore("Buy-from")
        {
            field("Posting No. Series N24"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }
        }
        modify(Control81) //Location Code
        {
            Visible = true;
        }
    }
}
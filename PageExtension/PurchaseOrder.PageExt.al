pageextension 50111 "Purchase Order N24" extends "Purchase Order"
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
        modify(Control98) //Location Code
        {
            Visible = true;
        }
    }
}
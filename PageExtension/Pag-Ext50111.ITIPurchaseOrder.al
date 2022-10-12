pageextension 50111 "ITI PurchaseOrder" extends "Purchase Order"
{
    layout
    {
        modify("Buy-from Vendor No.")
        {
            Importance = Promoted;
        }
        addbefore("Buy-from")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
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

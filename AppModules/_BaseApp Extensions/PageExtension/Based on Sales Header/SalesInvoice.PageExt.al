pageextension 50145 "Sales Invoice N24" extends "Sales Invoice"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            Importance = Promoted;
        }
        addbefore("Sell-to")
        {
            field("Posting No. Series N24"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
        }
        addafter("Work Description")
        {
            group("CommentsGroup N24")
            {
                Caption = 'Comments';
            }
        }
        movefirst("CommentsGroup N24"; WorkDescription)
    }
}
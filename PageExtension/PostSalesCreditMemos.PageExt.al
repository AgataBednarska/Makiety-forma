pageextension 50025 "Post. Sales Credit Memos N24" extends "Posted Sales Credit Memos"
{
    layout
    {
        modify("Document Date")
        {
            Visible = true;
        }
        addafter("Sell-to Customer Name")
        {
            field("External Document No. N24"; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
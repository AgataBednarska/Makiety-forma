pageextension 50126 "Posted Return Receipts N24" extends "Posted Return Receipts"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("External Document No. N24"; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
        modify("Document Date")
        {
            Visible = true;
        }
    }
}
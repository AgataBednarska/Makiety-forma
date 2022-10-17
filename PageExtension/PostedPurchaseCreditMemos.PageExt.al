pageextension 50029 "Posted Purchase Credit Memos" extends "Posted Purchase Credit Memos"
{
    layout
    {
        modify("Document Date")
        {
            Visible = true;
        }
        addafter("Buy-from Vendor Name")
        {
            field("Vendor Cr. Memo No. N24"; Rec."Vendor Cr. Memo No.")
            {
                ApplicationArea = Suite;
            }
            field("Return Order No. N24"; Rec."Return Order No.")
            {
                ApplicationArea = Suite;
            }
        }
    }
}
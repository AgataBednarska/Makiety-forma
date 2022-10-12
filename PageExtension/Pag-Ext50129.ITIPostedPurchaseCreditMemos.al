pageextension 50129 "ITI PostedPurchaseCreditMemos" extends "Posted Purchase Credit Memos"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Vendor Cr. Memo No."; Rec."Vendor Cr. Memo No.")
            {
                ApplicationArea = Suite;
            }
            field("Return Order No."; Rec."Return Order No.")
            {
                ApplicationArea = Suite;
            }
        }
        modify("Document Date")
        {
            Visible = true;
        }
    }
}

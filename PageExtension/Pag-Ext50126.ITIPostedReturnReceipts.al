pageextension 50126 "ITI PostedReturnReceipts" extends "Posted Return Receipts"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
            }
        }
        modify("Document Date")
        {
            Visible = true;
        }
    }
}

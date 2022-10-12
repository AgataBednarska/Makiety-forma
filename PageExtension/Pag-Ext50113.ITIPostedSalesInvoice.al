pageextension 50113 "ITI PostedSalesInvoice" extends "Posted Sales Invoice"
{
    layout
    {
        addbefore("Sell-to")
        {
            field("Debit Note"; Rec."Debit Note")
            {
                ApplicationArea = All;
                Importance = Standard;
                Editable = false;
            }
        }
        addafter("Work Description")
        {
            group(CommentsGroup)
            {
                Caption = 'Comments';
            }
        }
        movefirst(CommentsGroup; GetWorkDescription)
    }
}
pageextension 50100 "ITI Sales Order" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field("Execution Status"; Rec."Execution Status")
            {
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Customer No.")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                Importance = Promoted;
                Enabled = false;
            }
        }
        addafter("Work Description")
        {
            group(CommentsGroup)
            {
                Caption = 'Comments';
            }
        }
        movefirst(CommentsGroup; WorkDescription)

        modify("Sell-to Customer No.")
        {
            Importance = Promoted;
        }
    }
    actions
    {
        modify(PostPrepaymentInvoice)
        {
            Promoted = true;
            PromotedCategory = Category6;
        }
        modify(PreviewPrepmtInvoicePosting)
        {
            Promoted = true;
            PromotedCategory = Category6;
        }
        modify(PostPrepaymentCreditMemo)
        {
            Promoted = true;
            PromotedCategory = Category6;
        }
        modify(PreviewPrepmtCrMemoPosting)
        {
            Promoted = true;
            PromotedCategory = Category6;
        }
    }
}

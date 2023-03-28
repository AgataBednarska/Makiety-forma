pageextension 50100 "Sales Order N24" extends "Sales Order"
{
    layout
    {
        addafter(Status)
        {
            field("Execution Status N24"; Rec."Execution Status N24")
            {
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Customer No.")
        {
            field("Posting No. Series N24"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                Enabled = false;
                Importance = Promoted;
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
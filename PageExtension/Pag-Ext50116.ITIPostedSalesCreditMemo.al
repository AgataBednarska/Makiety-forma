pageextension 50116 "ITI PostedSalesCreditMemo" extends "Posted Sales Credit Memo"
{
    layout
    {
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

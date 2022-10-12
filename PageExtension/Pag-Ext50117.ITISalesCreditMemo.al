pageextension 50117 "ITI SalesCreditMemo" extends "Sales Credit Memo"
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
        movefirst(CommentsGroup; WorkDescription)
    }
}

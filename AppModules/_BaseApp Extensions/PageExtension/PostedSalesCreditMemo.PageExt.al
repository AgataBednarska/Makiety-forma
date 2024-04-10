pageextension 50156 "Posted Sales Credit Memo N24" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Work Description")
        {
            group("CommentsGroup N24")
            {
                Caption = 'Comments';
            }
        }
        movefirst("CommentsGroup N24"; GetWorkDescription)
    }
}
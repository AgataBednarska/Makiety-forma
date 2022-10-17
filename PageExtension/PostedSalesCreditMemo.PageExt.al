pageextension 50016 "Posted Sales Credit Memo N24" extends "Posted Sales Credit Memo"
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
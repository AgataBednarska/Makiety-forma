pageextension 50157 "Sales Credit Memo N24" extends "Sales Credit Memo"
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
        movefirst("CommentsGroup N24"; WorkDescription)
    }
}
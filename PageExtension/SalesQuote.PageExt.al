pageextension 50015 "Sales Quote N24" extends "Sales Quote"
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
pageextension 50113 "Posted Sales Invoice N24" extends "Posted Sales Invoice"
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
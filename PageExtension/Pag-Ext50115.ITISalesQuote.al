pageextension 50115 "ITI SalesQuote" extends "Sales Quote"
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

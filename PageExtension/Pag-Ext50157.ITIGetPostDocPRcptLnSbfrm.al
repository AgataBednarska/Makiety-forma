pageextension 50157 "ITI GetPostDocPRcptLnSbfrm" extends "Get Post.Doc - P.RcptLn Sbfrm"
{
    layout
    {
        addafter("Document No.")
        {
            field("ITI SAFT Ext. Document No."; Rec."ITI SAFT Ext. Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

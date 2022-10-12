pageextension 50156 "ITI GetPostDocPCrMemoLnSbfrm" extends "Get Post.Doc-P.Cr.MemoLn Sbfrm"
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

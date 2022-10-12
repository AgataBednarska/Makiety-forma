pageextension 50153 "ITI GetPostDocSCrMemoLnSbfrm" extends "Get Post.Doc-S.Cr.MemoLn Sbfrm"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

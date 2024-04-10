pageextension 50193 "Get Post. S.Cr.MemoLn Sub. N24" extends "Get Post.Doc-S.Cr.MemoLn Sbfrm"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No. N24"; Rec."External Document No. N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
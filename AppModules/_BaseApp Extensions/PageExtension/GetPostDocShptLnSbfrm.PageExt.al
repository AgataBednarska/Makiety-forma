pageextension 50190 "Get Post.Doc ShptLn Sbfrm N24" extends "Get Post.Doc - S.ShptLn Sbfrm"
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
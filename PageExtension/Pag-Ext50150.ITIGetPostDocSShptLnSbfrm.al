pageextension 50150 "ITI GetPostDocSShptLnSbfrm" extends "Get Post.Doc - S.ShptLn Sbfrm"
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

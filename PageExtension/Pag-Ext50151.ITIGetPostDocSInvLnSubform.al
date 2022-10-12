pageextension 50151 "ITI GetPostDocSInvLnSubform" extends "Get Post.Doc - S.InvLn Subform"
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

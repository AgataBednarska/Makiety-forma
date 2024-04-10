pageextension 50191 "Get Post.Doc S.InvLn Sub. N24" extends "Get Post.Doc - S.InvLn Subform"
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
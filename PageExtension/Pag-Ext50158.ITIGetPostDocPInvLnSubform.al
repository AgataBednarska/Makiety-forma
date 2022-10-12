pageextension 50158 "ITI GetPostDocPInvLnSubform" extends "Get Post.Doc - P.InvLn Subform"
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

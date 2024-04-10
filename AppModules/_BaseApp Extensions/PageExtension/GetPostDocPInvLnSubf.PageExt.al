pageextension 50198 "Get Post.Doc P.InvLn Subf. N24" extends "Get Post.Doc - P.InvLn Subform"
{
    layout
    {
        addafter("Document No.")
        {
            field("SAFT Ext. Document No. N24"; Rec."SAFT Ext. Document No. N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
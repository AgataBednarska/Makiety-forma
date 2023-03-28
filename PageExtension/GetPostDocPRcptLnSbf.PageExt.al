pageextension 50157 "Get Post.Doc P.RcptLn Sbf. N24" extends "Get Post.Doc - P.RcptLn Sbfrm"
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
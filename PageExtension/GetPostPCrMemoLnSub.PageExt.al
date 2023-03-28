pageextension 50156 "Get Post. P.Cr.MemoLn Sub. N24" extends "Get Post.Doc-P.Cr.MemoLn Sbfrm"
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
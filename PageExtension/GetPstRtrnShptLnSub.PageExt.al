pageextension 50159 "Get Pst. RtrnShptLn Sub. N24" extends "Get Pst.Doc-RtrnShptLn Subform"
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
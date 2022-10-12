pageextension 50159 "ITI GetPstDocRtrnShptLnSubform" extends "Get Pst.Doc-RtrnShptLn Subform"
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

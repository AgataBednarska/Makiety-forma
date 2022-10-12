pageextension 50152 "ITI GetPstDocRtrnRcptLnSubform" extends "Get Pst.Doc-RtrnRcptLn Subform"
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

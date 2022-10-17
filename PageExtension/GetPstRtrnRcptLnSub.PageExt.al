pageextension 50052 "Get Pst. RtrnRcptLn Sub. N24" extends "Get Pst.Doc-RtrnRcptLn Subform"
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
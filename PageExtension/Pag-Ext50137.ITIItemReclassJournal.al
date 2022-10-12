pageextension 50137 "ITI ItemReclassJournal" extends "Item Reclass. Journal"
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
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
        }
    }
}

pageextension 50037 "Item Reclass. Journal N24" extends "Item Reclass. Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No. N24"; Rec."External Document No.")
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
pageextension 50160 "ITI PostedAssemblyOrder" extends "Posted Assembly Order"
{
    layout
    {
        addlast(General)
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Editable = NOT Rec."Assemble to Order";
            }
            field("Transfers"; Rec."Item Transfer Entries")
            {
                ApplicationArea = All;
            }
        }
    }
}

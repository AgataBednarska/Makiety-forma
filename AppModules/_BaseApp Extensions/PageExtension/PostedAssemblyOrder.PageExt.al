pageextension 50200 "Posted Assembly Order N24" extends "Posted Assembly Order"
{
    layout
    {
        addlast(General)
        {
            field("External Document No. N24"; Rec."External Document No. N24")
            {
                ApplicationArea = All;
                Editable = not Rec."Assemble to Order";
            }
            field("Transfers N24"; Rec."Item Transfer Entries N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
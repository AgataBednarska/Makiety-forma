pageextension 50160 "Source Code Setup N24" extends "Source Code Setup"
{
    layout
    {
        addlast(General)
        {
            field("Bank Trans. Recalculation N24"; Rec."Bank Trans. Recalculation N24")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}
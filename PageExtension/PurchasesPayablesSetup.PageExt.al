pageextension 50136 "Purchases Payables Setup N24" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("GLAcc. Line Post. Desc. N24"; Rec."GLAcc. Line Post. Desc. N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
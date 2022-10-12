pageextension 50170 "ITI Purchases&PayablesSetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Use GLAcc. Line Posting Desc."; Rec."Use GLAcc. Line Posting Desc.")
            {
                ApplicationArea = All;
            }
        }
    }
}

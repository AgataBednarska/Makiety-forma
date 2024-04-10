pageextension 50175 "Assembly Setup N24" extends "Assembly Setup"
{
    layout
    {
        addlast(General)
        {
            field("Default Location for Material N24"; Rec."Def. Location for Material N24")
            {
                ApplicationArea = All;
            }
            field("Item Journal Batch for Residue N24"; Rec."Item Journal Batch Residue N24")
            {
                ApplicationArea = All;
            }
            field("Default Location for Residue N24"; Rec."Def. Location for Residue N24")
            {
                ApplicationArea = All;
            }
            field("In-Production Location N24"; Rec."In-Production Location N24")
            {
                ApplicationArea = All;
            }
        }
        addlast("ITI Posting")
        {
            field("Def.Gen.Bus.Post.Gr. for Adjmt N24"; Rec."Def.Gen.Bus.Post.Gr. Adjmt N24")
            {
                ApplicationArea = All;
            }
        }
    }
}
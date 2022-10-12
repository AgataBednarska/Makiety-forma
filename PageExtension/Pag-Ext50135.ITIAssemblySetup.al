pageextension 50135 "ITI AssemblySetup" extends "Assembly Setup"
{
    layout
    {
        addlast(General)
        {
            field("Default Location for Material"; Rec."Default Location for Material")
            {
                ApplicationArea = All;
            }
            field("Item Journal Batch for Residue"; Rec."Item Journal Batch for Residue")
            {
                ApplicationArea = All;
            }
            field("Default Location for Residue"; Rec."Default Location for Residue")
            {
                ApplicationArea = All;
            }
            field("In-Production Location"; Rec."In-Production Location")
            {
                ApplicationArea = All;
            }
        }
        addlast("ITI Posting")
        {
            field("Def.Gen.Bus.Post.Gr. for Adjmt"; Rec."Def.Gen.Bus.Post.Gr. for Adjmt")
            {
                ApplicationArea = All;
            }
        }
    }
}

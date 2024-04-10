pageextension 50183 "Purch. Invoice Subform N24" extends "Purch. Invoice Subform"
{
    layout
    {
        modify("Bin Code")
        {
            Visible = false;
        }
        modify("ITI Full VAT Base Amount")
        {
            Visible = false;
        }
    }
}
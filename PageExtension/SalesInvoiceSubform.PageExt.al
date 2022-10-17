pageextension 50018 "Sales Invoice Subform N24" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Amount Including VAT N24"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        movelast(Control1; "ITI PKWiU", "ITI Skip in VAT Register", "ITI Full VAT Base Amount", "Tax Area Code", "Tax Group Code")
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
    }
}

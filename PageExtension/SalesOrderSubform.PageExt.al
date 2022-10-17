pageextension 50002 "Sales Order Subform N24" extends "Sales Order Subform"
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
            field("Gen. Prod. Posting Group N24"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Gen. Prod. Posting Group N24"; "VAT Prod. Posting Group")
        movelast(Control1; "ITI PKWiU", "ITI Skip in VAT Register", "ITI Full VAT Base Amount", "Tax Area Code", "Tax Group Code")
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
    }
}
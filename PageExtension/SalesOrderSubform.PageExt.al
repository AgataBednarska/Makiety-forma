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
        addbefore("Unit Price")
        {
            field("Line Price for Unit Price Calculation N24"; LinePriceForCalc)
            {
                Caption = 'Line Price for Unit Price Calculation';
                ApplicationArea = All;
                BlankZero = true;

                trigger OnValidate()
                begin
                    if LinePriceForCalc <> 0 then
                        Rec.Validate("Unit Price", Round(LinePriceForCalc / Rec.Quantity, 0.01, '='));
                    
                    LinePriceForCalc := 0;
                end;
            }
        }

        moveafter("Gen. Prod. Posting Group N24"; "VAT Prod. Posting Group")
        movelast(Control1; "ITI PKWiU", "ITI Skip in VAT Register", "ITI Full VAT Base Amount", "Tax Area Code", "Tax Group Code")
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
    }

    var
        LinePriceForCalc: Decimal;
}
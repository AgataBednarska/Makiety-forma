pageextension 50158 "Sales Invoice Subform N24" extends "Sales Invoice Subform"
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
        addbefore("Unit Price")
        {
            field("Line Price for Unit Price Calculation N24"; LinePriceForCalc)
            {
                ApplicationArea = All;
                BlankZero = true;
                Caption = 'Line Price for Unit Price Calculation';

                trigger OnValidate()
                begin
                    if LinePriceForCalc <> 0 then
                        Rec.Validate("Unit Price", Round(LinePriceForCalc / Rec.Quantity, 0.01, '='));

                    LinePriceForCalc := 0;
                end;
            }
        }
        movelast(Control1; "ITI PKWiU", "ITI Skip in VAT Register", "ITI Full VAT Base Amount", "Tax Area Code", "Tax Group Code")
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
    }

    actions
    {
        addafter(SelectMultiItems)
        {
            action("AddPrepaymentLines N24")
            {
                ApplicationArea = All;
                Caption = 'Add Prepayment Lines';
                Image = Prepayment;

                trigger OnAction()
                var
                    AddPrepaymentLines: Codeunit "Add Prepayment Lines N24";
                begin
                    AddPrepaymentLines.SelectMultipleItems(Rec);
                end;
            }
        }
    }


    var
        LinePriceForCalc: Decimal;
}

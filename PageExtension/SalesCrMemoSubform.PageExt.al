pageextension 50172 "Sales Cr. Memo Subform N24" extends "Sales Cr. Memo Subform"
{
    layout
    {
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
    }

    var
        LinePriceForCalc: Decimal;
}
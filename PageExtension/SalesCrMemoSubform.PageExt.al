pageextension 50072 "Sales Cr. Memo Subform N24" extends "Sales Cr. Memo Subform"
{
    layout
    {
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
    }

    var
        LinePriceForCalc: Decimal;
}
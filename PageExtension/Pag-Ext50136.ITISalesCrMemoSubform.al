pageextension 50136 "ITI SalesCrMemoSubform" extends "Sales Cr. Memo Subform"
{
    layout
    {
        addbefore("Unit Price")
        {
            field("Line Price for Unit Price Calculation"; LinePriceForCalc)
            {
                Caption = 'Line Price for Unit Price Calculation';
                ApplicationArea = All;
                BlankZero = true;

                trigger OnValidate()
                begin
                    if LinePriceForCalc <> 0 then
                        Rec.Validate("Unit Price", round(LinePriceForCalc / Rec.Quantity, 0.01, '='));
                    LinePriceForCalc := 0;
                end;
            }
        }
    }

    var
        LinePriceForCalc: Decimal;
}

pageextension 50102 "ITI Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
        }
        movelast(Control1; "ITI PKWiU", "ITI Skip in VAT Register", "ITI Full VAT Base Amount", "Tax Area Code", "Tax Group Code")
        moveafter("Gen. Prod. Posting Group"; "VAT Prod. Posting Group")
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }
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

    actions
    {
        addafter(GetPrices)
        {
            action(GetPriceDCY)
            {
                ObsoleteState = Pending;
                ObsoleteReason = 'Replaced by the new implementation of price calculation';
                AccessByPermission = TableData "Sales Price" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Get DCY Price';
                Ellipsis = true;
                Image = Price;
                Visible = not ExtendedPriceEnabled;
                ToolTip = 'Insert the selected price exchanged to document currency in the Unit Price field according to any special price that you have set up.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesPriceMgt: Codeunit "ITI SalesPriceMgt";
                begin
                    SalesHeader.get(Rec."Document Type", Rec."Document No.");
                    SalesPriceMgt.GetSalesLinePrice(SalesHeader, Rec);
                end;
            }
            action(GetPricesDCY)
            {
                AccessByPermission = TableData "Sales Price Access" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Get Price DCY';
                Ellipsis = true;
                Image = Price;
                Visible = ExtendedPriceEnabled;
                ToolTip = 'Insert the lowest possible price in the Unit Price field according to any special price that you have set up.';

                trigger OnAction()
                var
                    SalesPricesMgt: Codeunit "ITI SalesPricesMgt";
                begin
                    SalesPricesMgt.ShowPrices(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
    begin
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();
    end;

    var
        LinePriceForCalc: Decimal;
        ExtendedPriceEnabled: Boolean;
}

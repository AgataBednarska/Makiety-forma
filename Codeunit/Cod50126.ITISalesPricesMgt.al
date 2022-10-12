codeunit 50126 "ITI SalesPricesMgt"
{
    Description = 'V16';

    var
        PriceType: Enum "Price Type";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";

    procedure ShowPrices(var Rec: Record "Sales Line")
    begin
        SalesLine := Rec;
        PickPrice();
        Rec := SalesLine;
    end;

    // procedure PickPrice()
    // var
    //     PriceCalculation: Interface "Price Calculation";
    // begin
    //     GetPriceCalculationHandler(PriceType::Sale, SalesHeader, PriceCalculation);
    //     PriceCalculation.PickPrice();
    //     GetLineWithCalculatedPrice(PriceCalculation);

    //     OnAfterPickPrice(Rec, PriceCalculation);
    // end;

    procedure PickPrice()
    //SalesLine
    var
        PriceCalculation: Interface "Price Calculation";
    begin
        GetPriceCalculationHandler(PriceType::Sale, SalesHeader, PriceCalculation);
        PriceCalculation.PickPrice();
        GetLineWithCalculatedPrice(PriceCalculation);
    end;

    local procedure GetLineWithCalculatedPrice(var PriceCalculation: Interface "Price Calculation")
    var
        Line: Variant;
    begin
        PriceCalculation.GetLine(Line);
        SalesLine := Line;
    end;


    // procedure GetPriceCalculationHandler(PriceType: Enum "Price Type"; SalesHeader: Record "Sales Header"; var PriceCalculation: Interface "Price Calculation")
    // var
    //     PriceCalculationMgt: codeunit "Price Calculation Mgt.";
    //     LineWithPrice: Interface "Line With Price";
    // begin
    //     if (SalesHeader."No." = '') and ("Document No." <> '') then
    //         SalesHeader.Get(SalesLine."Document Type", "Document No.");
    //     GetLineWithPrice(LineWithPrice);
    //     LineWithPrice.SetLine(PriceType, SalesHeader, Rec);
    //     PriceCalculationMgt.GetHandler(LineWithPrice, PriceCalculation);
    // end;

    procedure GetPriceCalculationHandler(PriceType: Enum "Price Type"; SalesHeader: Record "Sales Header"; var PriceCalculation: Interface "Price Calculation")
    //SalesLine
    var
        PriceCalculationMgt: codeunit "Price Calculation Mgt.";
        LineWithPrice: Interface "Line With Price";
    begin
        if (SalesHeader."No." = '') and (SalesLine."Document No." <> '') then
            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        SalesLine.GetLineWithPrice(LineWithPrice);
        LineWithPrice.SetLine(PriceType, SalesHeader, SalesLine);
        GetHandler(LineWithPrice, PriceCalculation);
    end;

    // procedure GetHandler(LineWithPrice: Interface "Line With Price"; var PriceCalculation: Interface "Price Calculation") Result: Boolean;
    // var
    //     PriceCalculationSetup: Record "Price Calculation Setup";
    // begin
    //     Result := FindSetup(LineWithPrice, PriceCalculationSetup);
    //     PriceCalculation := PriceCalculationSetup.Implementation;
    //     PriceCalculation.Init(LineWithPrice, PriceCalculationSetup);
    // end;

    procedure GetHandler(LineWithPrice: Interface "Line With Price"; var PriceCalculation: Interface "Price Calculation") Result: Boolean;
    //Price Calculation Mgt.
    var
        PriceCalculationSetup: Record "Price Calculation Setup";
        ITIPriceCalculationV16: Codeunit "ITI Price Calculation - V16";
        PriceCalculationMgt: codeunit "Price Calculation Mgt.";
    begin
        Result := PriceCalculationMgt.FindSetup(LineWithPrice, PriceCalculationSetup);
        PriceCalculation := ITIPriceCalculationV16;
        PriceCalculation.Init(LineWithPrice, PriceCalculationSetup);
    end;
}

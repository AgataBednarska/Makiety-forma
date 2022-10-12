codeunit 50125 "ITI SalesPriceMgt"
{
    ObsoleteState = Pending;
    ObsoleteReason = 'Replaced by the new implementation of price calculation';

    var
        TempSalesPrice: Record "Sales Price" temporary;
        DateCaption: Text[30];
        Text000: Label '%1 is less than %2 in the %3.';
        Text001: Label 'The %1 in the %2 must be same as in the %3.';
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
        QtyPerUOM: Decimal;
        Qty: Decimal;
        Item: Record Item;
        CurrExchRate: Record "Currency Exchange Rate";


    procedure GetSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        GetSalesPrice: Page "ITI Get Sales Price DCY";
    begin
        SalesPriceCalcMgt.SalesLinePriceExists(SalesHeader, SalesLine, true);
        SalesPriceCalcMgt.FindSalesPrice(
                      TempSalesPrice, SalesHeader."Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
                      SalesLine."Customer Price Group", '', SalesLine."No.", SalesLine."Variant Code", SalesLine."Unit of Measure Code",
                      SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), true);

        GetSalesPrice.SetRec(TempSalesPrice);
        GetSalesPrice.SetCurrencyDate(SalesLine."Posting Date");
        GetSalesPrice.SetHeaderCurrency(SalesLine."Currency Code");
        GetSalesPrice.LookupMode := true;
        if GetSalesPrice.RunModal() = ACTION::LookupOK then begin
            GetSalesPrice.GetRecord(TempSalesPrice);

            TempSalesPrice."Currency Code" := '';
            TempSalesPrice."Unit Price" := GetSalesPrice.GetUnitPriceDCY();

            SalesPriceCalcMgt.SetVAT(
              SalesHeader."Prices Including VAT", SalesLine."VAT %", SalesLine."VAT Calculation Type".AsInteger(), SalesLine."VAT Bus. Posting Group");
            SalesPriceCalcMgt.SetUoM(Abs(SalesLine.Quantity), SalesLine."Qty. per Unit of Measure");
            SetUoM(Abs(SalesLine.Quantity), SalesLine."Qty. per Unit of Measure");
            SalesPriceCalcMgt.SetCurrency(
              SalesHeader."Currency Code", SalesHeader."Currency Factor", SalesHeaderExchDate(SalesHeader));

            if not IsInMinQty(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Minimum Quantity") then
                Error(
                  Text000,
                  SalesLine.FieldCaption(Quantity),
                  TempSalesPrice.FieldCaption("Minimum Quantity"),
                  TempSalesPrice.TableCaption);
            if not (TempSalesPrice."Currency Code" in [SalesLine."Currency Code", '']) then
                Error(
                  Text001,
                  SalesLine.FieldCaption("Currency Code"),
                  SalesLine.TableCaption,
                  TempSalesPrice.TableCaption);
            if not (TempSalesPrice."Unit of Measure Code" in [SalesLine."Unit of Measure Code", '']) then
                Error(
                  Text001,
                  SalesLine.FieldCaption("Unit of Measure Code"),
                  SalesLine.TableCaption,
                  TempSalesPrice.TableCaption);
            if TempSalesPrice."Starting Date" > SalesHeaderStartDate(SalesHeader, DateCaption) then
                Error(
                  Text000,
                  DateCaption,
                  TempSalesPrice.FieldCaption("Starting Date"),
                  TempSalesPrice.TableCaption);

            SalesPriceCalcMgt.ConvertPriceToVAT(
              TempSalesPrice."Price Includes VAT", SalesLine."VAT Prod. Posting Group",
              TempSalesPrice."VAT Bus. Posting Gr. (Price)", TempSalesPrice."Unit Price");
            ConvertPriceToUoM(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Unit Price");
            // SalesPriceCalcMgt.ConvertPriceLCYToFCY(TempSalesPrice."Currency Code", TempSalesPrice."Unit Price");

            SalesLine."Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
            SalesLine."Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
            if not SalesLine."Allow Line Disc." then
                SalesLine."Line Discount %" := 0;

            SalesLine.Validate("Unit Price", TempSalesPrice."Unit Price");
        end;
    end;

    local procedure SalesHeaderExchDate(SalesHeader: Record "Sales Header"): Date
    begin
        if SalesHeader."Posting Date" <> 0D then
            exit(SalesHeader."Posting Date");
        exit(WorkDate);
    end;

    local procedure ConvertPriceToUoM(UnitOfMeasureCode: Code[10]; var UnitPrice: Decimal)
    begin
        if UnitOfMeasureCode = '' then
            UnitPrice := UnitPrice * QtyPerUOM;
    end;

    procedure SetUoM(Qty2: Decimal; QtyPerUoM2: Decimal)
    begin
        Qty := Qty2;
        QtyPerUOM := QtyPerUoM2;
    end;

    local procedure IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal): Boolean
    begin
        if UnitofMeasureCode = '' then
            exit(MinQty <= QtyPerUOM * Qty);
        exit(MinQty <= Qty);
    end;

    local procedure SalesHeaderStartDate(var SalesHeader: Record "Sales Header"; var DateCaption: Text[30]): Date
    begin
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"] then begin
            DateCaption := SalesHeader.FieldCaption("Posting Date");
            exit(SalesHeader."Posting Date")
        end else begin
            DateCaption := SalesHeader.FieldCaption("Order Date");
            exit(SalesHeader."Order Date");
        end;
    end;
}

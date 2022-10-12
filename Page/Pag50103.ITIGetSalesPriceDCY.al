page 50103 "ITI Get Sales Price DCY"
{
    Caption = 'Get Sales Price DCY';
    PageType = list;
    SourceTable = "Sales Price";
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ObsoleteState = Pending;
    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
    ObsoleteTag = '16.0';

    layout
    {
        area(content)
        {
            group(header)
            {
                ShowCaption = false;
                field(HeaderCurrencyCode; HeaderCurrencyCode)
                {
                    Caption = 'Document Currency Code';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(CurrencyExchDate; CurrencyExchangeDate)
                {
                    Caption = 'Currency Exchange Date';
                    ApplicationArea = All;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
            }

            repeater(Control1)
            {
                ShowCaption = false;
                Editable = false;
                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the sales price type, which defines whether the price is for an individual, group, all customers, or a campaign.';
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the code that belongs to the Sales Type.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the number of the item for which the sales price is valid.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    // ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Minimum Quantity"; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the minimum sales quantity required to warrant the sales price.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    // ToolTip = 'Specifies the code for the currency of the sales price.';
                    // Visible = false;
                }
                field(CurrencyExchRate; CurrencyExchangeRate)
                {
                    Caption = 'Currency Exchange Rate';
                    ApplicationArea = All;
                    Editable = false;
                    BlankZero = true;
                }
                field(UnitPriceDCY; UnitPriceDCY)
                {
                    Caption = 'Unit Price DCY';
                    ApplicationArea = ToBeClassified;
                    Style = Strong;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the date from which the sales price is valid.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the calendar date when the sales price agreement ends.';
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies if the sales price includes VAT.';
                    Visible = false;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies if an invoice discount will be calculated when the sales price is offered.';
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the VAT business posting group for customers for whom you want the sales price (which includes VAT) to apply.';
                    Visible = false;
                }
                field("Allow Line Disc."; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies if a line discount will be calculated when the sales price is offered.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    var
        UnitPriceDCY: Decimal;
        CurrencyExchangeDate: Date;
        CurrencyExchangeRate: Decimal;
        HeaderCurrencyCode: Code[20];
        VarRec: Record "Sales Price" temporary;
        CurrExchRate: Record "Currency Exchange Rate";

    trigger OnAfterGetRecord()
    begin
        CurrencyExchangeRate := GetExchangedAmount(1);
        if CurrencyExchangeRate = 1 then
            CurrencyExchangeRate := 0;
        UnitPriceDCY := GetExchangedAmount(Rec."Unit Price");
    end;

    procedure SetCurrencyDate(CurrDate: Date)
    begin
        CurrencyExchangeDate := CurrDate;
    end;

    procedure SetHeaderCurrency(CurrencyCode: Code[20])
    begin
        HeaderCurrencyCode := CurrencyCode;
    end;

    procedure GetUnitPriceDCY(): Decimal
    begin
        exit(UnitPriceDCY);
    end;

    local procedure GetExchangedAmount(Amount: Decimal): Decimal
    begin
        IF Rec."Currency Code" = HeaderCurrencyCode then
            exit(Amount);
        if HeaderCurrencyCode = '' then
            exit(Round(CurrExchRate.ExchangeAmtFCYToLCY(CurrencyExchangeDate, Rec."Currency Code", Amount, CurrExchRate.ExchangeRate(CurrencyExchangeDate, Rec."Currency Code")), 0.01));
        exit(Round(CurrExchRate.ExchangeAmtFCYToFCY(CurrencyExchangeDate, Rec."Currency Code", HeaderCurrencyCode, Amount), 0.01));
    end;

    procedure SetRec(var SalesPrice: Record "Sales Price" temporary)
    begin
        VarRec.Copy(SalesPrice, true);
    end;

    trigger OnOpenPage()
    begin
        if CurrencyExchangeDate = 0D then
            CurrencyExchangeDate := WorkDate();

        FillTable();
    end;

    local procedure FillTable()
    begin
        if varrec.FindSet() then
            repeat
                Rec := VarRec;
                Rec.Insert();
            until VarRec.Next() = 0;
    end;
}

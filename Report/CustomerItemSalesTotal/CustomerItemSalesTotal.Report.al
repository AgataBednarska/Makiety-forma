report 50003 "Customer/Item Sales Total N24"
{
    Caption = 'Customer/Item Sales with Total';
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    RDLCLayout = './Report/CustomerItemSalesTotal/CustomerItemSalesTotal.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group";
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(PeriodLbl, PeriodText))
            {
            }
            column(COMPANYNAME; CompanyProperty.DisplayName())
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
            {
            }
            column(Customer_TABLECAPTION__________CustFilter; TableCaption + ': ' + CustFilter)
            {
            }
            column(CustFilter; CustFilter)
            {
            }
            column(Value_Entry__TABLECAPTION__________ItemLedgEntryFilter; "Value Entry".TableCaption + ': ' + ValueEntryFilter)
            {
            }
            column(ItemLedgEntryFilter; ValueEntryFilter)
            {
            }
            column(Customer__No__; "No.")
            {
            }
            column(Customer_Name; Name)
            {
            }
            column(Customer__Phone_No__; "Phone No.")
            {
            }
            column(ValueEntryBuffer__Sales_Amount__Actual__; TempValueEntryBuffer."Sales Amount (Actual)")
            {
            }
            column(ValueEntryBuffer__Discount_Amount_; -TempValueEntryBuffer."Discount Amount")
            {
            }
            column(Profit; Profit)
            {
                AutoFormatType = 1;
            }
            column(ProfitPct; ProfitPct)
            {
                DecimalPlaces = 1 : 1;
            }
            column(Customer_Item_SalesCaption; Customer_Item_SalesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(All_amounts_are_in_LCYCaption; All_amounts_are_in_LCYCaptionLbl)
            {
            }
            column(ValueEntryBuffer__Item_No__Caption; ValueEntryBuffer__Item_No__CaptionLbl)
            {
            }
            column(Item_DescriptionCaption; Item_DescriptionCaptionLbl)
            {
            }
            column(ValueEntryBuffer__Invoiced_Quantity_Caption; ValueEntryBuffer__Invoiced_Quantity_CaptionLbl)
            {
            }
            column(Item__Base_Unit_of_Measure_Caption; Item__Base_Unit_of_Measure_CaptionLbl)
            {
            }
            column(ValueEntryBuffer__Sales_Amount__Actual___Control44Caption; ValueEntryBuffer__Sales_Amount__Actual___Control44CaptionLbl)
            {
            }
            column(ValueEntryBuffer__Discount_Amount__Control45Caption; ValueEntryBuffer__Discount_Amount__Control45CaptionLbl)
            {
            }
            column(Profit_Control46Caption; Profit_Control46CaptionLbl)
            {
            }
            column(ProfitPct_Control47Caption; ProfitPct_Control47CaptionLbl)
            {
            }
            column(Customer__Phone_No__Caption; FieldCaption("Phone No."))
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(IncludeOrderResidue; IncludeOrderResidue)
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Source No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Source Type", "Source No.", "Item No.", "Variant Code", "Posting Date") where("Source Type" = const(Customer), "Item Charge No." = const(''), "Expected Cost" = const(false), Adjustment = const(false));
                RequestFilterFields = "Item No.", "Posting Date";

                trigger OnAfterGetRecord()
                var
                    PostedAssemblyHeader: Record "Posted Assembly Header";
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    SalesInvoiceLine: Record "Sales Invoice Line";
                    ValueEntry: Record "Value Entry";
                    EntryInBufferExists: Boolean;
                begin
                    TempValueEntryBuffer.Init();
                    TempValueEntryBuffer.SetRange("Item No.", "Item No.");
                    EntryInBufferExists := TempValueEntryBuffer.FindFirst();

                    if not EntryInBufferExists then
                        TempValueEntryBuffer."Entry No." := "Item Ledger Entry No.";

                    TempValueEntryBuffer."Item No." := "Item No.";
                    TempValueEntryBuffer."Invoiced Quantity" += "Invoiced Quantity";
                    TempValueEntryBuffer."Sales Amount (Actual)" += "Sales Amount (Actual)";
                    TempValueEntryBuffer."Cost Amount (Actual)" += "Cost Amount (Actual)";
                    TempValueEntryBuffer."Cost Amount (Non-Invtbl.)" += "Cost Amount (Non-Invtbl.)";
                    TempValueEntryBuffer."Discount Amount" += "Discount Amount";

                    if IncludeOrderResidue then
                        if "Document Type" = "Document Type"::"Sales Invoice" then
                            if SalesInvoiceHeader.Get("Document No.") then begin
                                // FIND ASSEMBLY BY EXTERNAL NO
                                if SalesInvoiceHeader."External Document No." <> '' then begin
                                    PostedAssemblyHeader.SetRange("External Document No. N24", SalesInvoiceHeader."External Document No.");
                                    if PostedAssemblyHeader.FindSet() then
                                        repeat
                                            if not PostedAssemblyHeaderBuffer.Get(PostedAssemblyHeader."No.") then begin
                                                PostedAssemblyHeaderBuffer := PostedAssemblyHeader;

                                                if PostedAssemblyHeaderBuffer.Insert() then;
                                            end;
                                        until PostedAssemblyHeader.Next() = 0;
                                end;
                                // FIND ASSEMBLY BY LINE REFERENCE TO ORDER
                                SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                                SalesInvoiceLine.SetFilter("Order No.", '<>%1', '');
                                if SalesInvoiceLine.FindSet() then
                                    repeat
                                        SalesInvoiceHeader.SetRange("Order No.", SalesInvoiceLine."Order No.");
                                        if SalesInvoiceHeader.FindSet() then
                                            repeat
                                                if SalesInvoiceHeader."External Document No." <> '' then begin
                                                    PostedAssemblyHeader.SetRange("External Document No. N24", SalesInvoiceHeader."External Document No.");
                                                    if PostedAssemblyHeader.FindSet() then
                                                        repeat
                                                            if not PostedAssemblyHeaderBuffer.Get(PostedAssemblyHeader."No.") then begin
                                                                PostedAssemblyHeaderBuffer := PostedAssemblyHeader;

                                                                if PostedAssemblyHeaderBuffer.Insert() then;
                                                            end;
                                                        until PostedAssemblyHeader.Next() = 0;
                                                end;
                                            until SalesInvoiceHeader.Next() = 0;
                                    until SalesInvoiceLine.Next() = 0;
                            end;

                    TempItemLedgerEntry.SetRange("Entry No.", "Item Ledger Entry No.");
                    if TempItemLedgerEntry.IsEmpty then begin
                        TempItemLedgerEntry."Entry No." := "Item Ledger Entry No.";
                        TempItemLedgerEntry.Insert();

                        // Add item charges regardless of their posting date
                        ValueEntry.SetRange("Item Ledger Entry No.", "Item Ledger Entry No.");
                        ValueEntry.SetFilter("Item Charge No.", '<>%1', '');
                        ValueEntry.CalcSums("Sales Amount (Actual)", "Cost Amount (Actual)", "Cost Amount (Non-Invtbl.)", "Discount Amount");

                        TempValueEntryBuffer."Sales Amount (Actual)" += ValueEntry."Sales Amount (Actual)";
                        TempValueEntryBuffer."Cost Amount (Actual)" += ValueEntry."Cost Amount (Actual)";
                        TempValueEntryBuffer."Cost Amount (Non-Invtbl.)" += ValueEntry."Cost Amount (Non-Invtbl.)";
                        TempValueEntryBuffer."Discount Amount" += ValueEntry."Discount Amount";

                        // Add cost adjustments regardless of their posting date
                        ValueEntry.SetRange("Item Charge No.", '');
                        ValueEntry.SetRange(Adjustment, true);
                        ValueEntry.CalcSums("Cost Amount (Actual)");
                        TempValueEntryBuffer."Cost Amount (Actual)" += ValueEntry."Cost Amount (Actual)";
                    end;

                    if EntryInBufferExists then
                        TempValueEntryBuffer.Modify()
                    else
                        TempValueEntryBuffer.Insert();
                end;

                trigger OnPreDataItem()
                begin
                    TempValueEntryBuffer.Reset();
                    TempValueEntryBuffer.DeleteAll();
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(ValueEntryBuffer__Item_No__; TempValueEntryBuffer."Item No.")
                {
                }
                column(Item_Description; Item.Description)
                {
                }
                column(ValueEntryBuffer__Invoiced_Quantity_; -TempValueEntryBuffer."Invoiced Quantity")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(ValueEntryBuffer__Sales_Amount__Actual___Control44; TempValueEntryBuffer."Sales Amount (Actual)")
                {
                    AutoFormatType = 1;
                }
                column(ValueEntryBuffer__Discount_Amount__Control45; -TempValueEntryBuffer."Discount Amount")
                {
                    AutoFormatType = 1;
                }
                column(Profit_Control46; Profit)
                {
                    AutoFormatType = 1;
                }
                column(ProfitPct_Control47; ProfitPct)
                {
                    DecimalPlaces = 1 : 1;
                }
                column(Item__Base_Unit_of_Measure_; Item."Base Unit of Measure")
                {
                }

                column(ResidueAmount; ResidueAmount)
                {
                }

                dataitem(PostedAssemblyHeaderBuffer; "Posted Assembly Header")
                {
                    PrintOnlyIfDetail = true;
                    UseTemporary = true;

                    column(AssyTest; StrSubstNo(ResidueExtDocNoTxt, "External Document No. N24")) { }
                    column(Residue_ExternalDocumentNo; "External Document No. N24") { }

                    dataitem(ResItemLedgerEntry; "Item Ledger Entry")
                    {

                        CalcFields = "Cost Amount (Actual)";
                        DataItemLink = "External Document No." = field("External Document No. N24");
                        DataItemTableView = sorting("Entry Type") where("Entry Type" = const("Positive Adjmt."), "Document Type" = const(" "));

                        column(Residue_ItemNo; "Item No.") { }
                        column(ResItem_Description; ResItem.Description) { }
                        column(Residue_Quantity; Quantity) { }
                        column(Residue_UnitofMeasureCode; "Unit of Measure Code") { }
                        column(Residue_CostAmountActual; "Cost Amount (Actual)") { }

                        trigger OnAfterGetRecord()
                        begin
                            if not ResItem.Get("Item No.") then;

                            ResidueAmount += "Cost Amount (Actual)";
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        Clear(ResidueAmount);

                        PostedAssemblyHeaderBuffer.SetRange("Item No.", TempValueEntryBuffer."Item No.");
                    end;

                    trigger OnAfterGetRecord()
                    var
                        PATOLink: Record "Posted Assemble-to-Order Link";
                    begin
                        Clear(TempResidueValueEntry);

                        OrderNo := '';

                        if PATOLink.Get(PATOLink."Assembly Document Type"::Assembly, PostedAssemblyHeaderBuffer."No.") then
                            OrderNo := PATOLink."Order No.";
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempValueEntryBuffer.Find('-')
                    else
                        TempValueEntryBuffer.Next();

                    Profit :=
                      TempValueEntryBuffer."Sales Amount (Actual)" +
                      TempValueEntryBuffer."Cost Amount (Actual)" +
                      TempValueEntryBuffer."Cost Amount (Non-Invtbl.)";

                    if Item.Get(TempValueEntryBuffer."Item No.") then;
                end;

                trigger OnPreDataItem()
                begin
                    TempValueEntryBuffer.Reset();

                    SetRange(Number, 1, TempValueEntryBuffer.Count);

                    Clear(Profit);
                end;
            }

            trigger OnPreDataItem()
            begin
                Clear(Profit);
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(TempResidueValueEntry);
                Clear(PostedAssemblyHeaderBuffer);
                PostedAssemblyHeaderBuffer.DeleteAll();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPageField; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Customer';
                    }

                    field(IncludeOrderResidueField; IncludeOrderResidue)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Order Residue';
                    }
                }
            }
        }
    }

    labels
    {
        ResItemNoLbl = 'Residue Item No.';
        ExtDocNoLbl = 'Ext. Doc. No.';
    }

    trigger OnPostReport()
    begin
        if Customer.IsEmpty() and GuiAllowed() then
            Error(EmptyReportDatasetTxt);
    end;

    trigger OnPreReport()
    var
        FormatDocument: Codeunit "Format Document";
    begin
        CustFilter := FormatDocument.GetRecordFiltersWithCaptions(Customer);
        ValueEntryFilter := "Value Entry".GetFilters;
        PeriodText := "Value Entry".GetFilter("Posting Date");
    end;


    var
        Item: Record Item;
        ResItem: Record Item;
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        TempResidueValueEntry: Record "Value Entry" temporary;
        TempValueEntryBuffer: Record "Value Entry" temporary;
        IncludeOrderResidue: Boolean;
        PrintOnlyOnePerPage: Boolean;
        Profit: Decimal;
        ProfitPct: Decimal;
        ResidueAmount: Decimal;
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Customer_Item_SalesCaptionLbl: Label 'Customer/Item Sales';
        EmptyReportDatasetTxt: Label 'There is nothing to print for the selected filters.';
        Item__Base_Unit_of_Measure_CaptionLbl: Label 'Unit of Measure';
        Item_DescriptionCaptionLbl: Label 'Description';
        PeriodLbl: Label 'Period: %1', Comment = '%1 - Pieriod text';
        Profit_Control46CaptionLbl: Label 'Profit';
        ProfitPct_Control47CaptionLbl: Label 'Profit %';
        ResidueExtDocNoTxt: Label 'External Document No.: %1', Comment = '%1 - External Document No.';
        TotalCaptionLbl: Label 'Total';
        ValueEntryBuffer__Discount_Amount__Control45CaptionLbl: Label 'Discount Amount';
        ValueEntryBuffer__Invoiced_Quantity_CaptionLbl: Label 'Invoiced Quantity';
        ValueEntryBuffer__Item_No__CaptionLbl: Label 'Item No.';
        ValueEntryBuffer__Sales_Amount__Actual___Control44CaptionLbl: Label 'Amount';
        CustFilter: Text;
        OrderNo: Text;
        PeriodText: Text;
        ValueEntryFilter: Text;

    procedure InitializeRequest(NewPagePerCustomer: Boolean)
    begin
        PrintOnlyOnePerPage := NewPagePerCustomer;
    end;
}
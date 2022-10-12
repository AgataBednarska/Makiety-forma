report 50107 "Customer/Item Sales with Total"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/RDLC/CustomerItemSalesWithTotal.rdlc';
    Caption = 'Customer/Item Sales with Total';
    PreviewMode = PrintLayout;
    //ApplicationArea = Basic, Suite;
    //UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Customer Posting Group";
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Text000, PeriodText))
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
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
            column(ValueEntryBuffer__Sales_Amount__Actual__; ValueEntryBuffer."Sales Amount (Actual)")
            {
            }
            column(ValueEntryBuffer__Discount_Amount_; -ValueEntryBuffer."Discount Amount")
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
                DataItemLink = "Source No." = FIELD("No."), "Posting Date" = FIELD("Date Filter"), "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"), "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter");
                DataItemTableView = SORTING("Source Type", "Source No.", "Item No.", "Variant Code", "Posting Date") WHERE("Source Type" = CONST(Customer), "Item Charge No." = CONST(''), "Expected Cost" = CONST(false), Adjustment = CONST(false));
                RequestFilterFields = "Item No.", "Posting Date";

                trigger OnAfterGetRecord()
                var
                    ValueEntry: Record "Value Entry";
                    EntryInBufferExists: Boolean;
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                    SalesInvoiceLine: Record "Sales Invoice Line";
                    PostedAssemblyHeader: Record "Posted Assembly Header";
                begin
                    ValueEntryBuffer.Init();
                    ValueEntryBuffer.SetRange("Item No.", "Item No.");
                    EntryInBufferExists := ValueEntryBuffer.FindFirst;

                    if not EntryInBufferExists then
                        ValueEntryBuffer."Entry No." := "Item Ledger Entry No.";
                    ValueEntryBuffer."Item No." := "Item No.";
                    ValueEntryBuffer."Invoiced Quantity" += "Invoiced Quantity";
                    ValueEntryBuffer."Sales Amount (Actual)" += "Sales Amount (Actual)";
                    ValueEntryBuffer."Cost Amount (Actual)" += "Cost Amount (Actual)";
                    ValueEntryBuffer."Cost Amount (Non-Invtbl.)" += "Cost Amount (Non-Invtbl.)";
                    ValueEntryBuffer."Discount Amount" += "Discount Amount";


                    If IncludeOrderResidue then begin

                        if "Document Type" = "Document Type"::"Sales Invoice" then
                            if SalesInvoiceHeader.get("Document No.") then begin
                                // FIND ASSEMBLY BY EXTERNAL NO
                                if SalesInvoiceHeader."External Document No." <> '' then begin
                                    PostedAssemblyHeader.SetRange("External Document No.", SalesInvoiceHeader."External Document No.");
                                    if PostedAssemblyHeader.FindSet() then
                                        repeat
                                            if not PostedAssemblyHeaderBuffer.Get(PostedAssemblyHeader."No.") then begin
                                                PostedAssemblyHeaderBuffer := PostedAssemblyHeader;
                                                if PostedAssemblyHeaderBuffer.insert() then;
                                            end;
                                        until PostedAssemblyHeader.Next() = 0;
                                end;
                                // FIND ASSEMBLY BY LINE REFERENCE TO ORDER
                                SalesInvoiceLine.SetRange("Document No.", SalesInvoiceHeader."No.");
                                SalesInvoiceLine.SetFilter("Order No.", '<>%1', '');
                                if SalesInvoiceLine.FindSet() then
                                    repeat
                                        SalesInvoiceHeader.SetRange("Order No.", SalesInvoiceLine."Order No.");
                                        If SalesInvoiceHeader.FindSet() then
                                            repeat
                                                if SalesInvoiceHeader."External Document No." <> '' then begin
                                                    PostedAssemblyHeader.SetRange("External Document No.", SalesInvoiceHeader."External Document No.");
                                                    if PostedAssemblyHeader.FindSet() then
                                                        repeat
                                                            if not PostedAssemblyHeaderBuffer.Get(PostedAssemblyHeader."No.") then begin
                                                                PostedAssemblyHeaderBuffer := PostedAssemblyHeader;
                                                                if PostedAssemblyHeaderBuffer.insert() then;
                                                            end;
                                                        until PostedAssemblyHeader.Next() = 0;
                                                end;
                                            until SalesInvoiceHeader.Next() = 0;

                                    until SalesInvoiceLine.Next() = 0;
                            end;
                    end;

                    TempItemLedgerEntry.SetRange("Entry No.", "Item Ledger Entry No.");
                    if TempItemLedgerEntry.IsEmpty then begin
                        TempItemLedgerEntry."Entry No." := "Item Ledger Entry No.";
                        TempItemLedgerEntry.Insert();

                        // Add item charges regardless of their posting date
                        ValueEntry.SetRange("Item Ledger Entry No.", "Item Ledger Entry No.");
                        ValueEntry.SetFilter("Item Charge No.", '<>%1', '');
                        ValueEntry.CalcSums("Sales Amount (Actual)", "Cost Amount (Actual)", "Cost Amount (Non-Invtbl.)", "Discount Amount");

                        ValueEntryBuffer."Sales Amount (Actual)" += ValueEntry."Sales Amount (Actual)";
                        ValueEntryBuffer."Cost Amount (Actual)" += ValueEntry."Cost Amount (Actual)";
                        ValueEntryBuffer."Cost Amount (Non-Invtbl.)" += ValueEntry."Cost Amount (Non-Invtbl.)";
                        ValueEntryBuffer."Discount Amount" += ValueEntry."Discount Amount";

                        // Add cost adjustments regardless of their posting date
                        ValueEntry.SetRange("Item Charge No.", '');
                        ValueEntry.SetRange(Adjustment, true);
                        ValueEntry.CalcSums("Cost Amount (Actual)");
                        ValueEntryBuffer."Cost Amount (Actual)" += ValueEntry."Cost Amount (Actual)";
                    end;

                    if EntryInBufferExists then
                        ValueEntryBuffer.Modify
                    else
                        ValueEntryBuffer.Insert();
                end;

                trigger OnPreDataItem()
                begin
                    ValueEntryBuffer.Reset();
                    ValueEntryBuffer.DeleteAll();
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = SORTING(Number);
                column(ValueEntryBuffer__Item_No__; ValueEntryBuffer."Item No.")
                {
                }
                column(Item_Description; Item.Description)
                {
                }
                column(ValueEntryBuffer__Invoiced_Quantity_; -ValueEntryBuffer."Invoiced Quantity")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(ValueEntryBuffer__Sales_Amount__Actual___Control44; ValueEntryBuffer."Sales Amount (Actual)")
                {
                    AutoFormatType = 1;
                }
                column(ValueEntryBuffer__Discount_Amount__Control45; -ValueEntryBuffer."Discount Amount")
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
                    UseTemporary = true;
                    PrintOnlyIfDetail = true;

                    column(AssyTest; strsubstno(ResidueExtDocNoTxt, "External Document No.", OrderNo, "No.")) { }
                    column(Residue_ExternalDocumentNo; "External Document No.") { }

                    dataitem(ResItemLedgerEntry; "Item Ledger Entry")
                    {

                        DataItemLink = "External Document No." = field("External Document No.");
                        DataItemTableView = sorting("Entry Type")
                                            where("Entry Type" = const("Positive Adjmt."), "Document Type" = const(" "));
                        CalcFields = "Cost Amount (Actual)";

                        column(Residue_ItemNo; "Item No.") { }
                        column(ResItem_Description; ResItem.Description) { }
                        column(Residue_Quantity; Quantity) { }
                        column(Residue_UnitofMeasureCode; "Unit of Measure Code") { }
                        column(Residue_CostAmountActual; "Cost Amount (Actual)") { }

                        trigger OnAfterGetRecord()
                        begin
                            If not ResItem.Get("Item No.") then;
                            ResidueAmount += "Cost Amount (Actual)";
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        Clear(ResidueAmount);
                        PostedAssemblyHeaderBuffer.SetRange("Item No.", ValueEntryBuffer."Item No.");
                    end;

                    trigger OnAfterGetRecord()
                    var
                        ValueEntry2: Record "Value Entry";
                        AssemblySetup: Record "Assembly Setup";
                        PATOLink: Record "Posted Assemble-to-Order Link";
                    begin
                        Clear(ResidueValueEntry);
                        ResidueEntryNo := 0;
                        OrderNo := '';
                        if PATOLink.GET(PATOLink."Assembly Document Type"::Assembly, PostedAssemblyHeaderBuffer."No.") then
                            OrderNo := PATOLink."Order No.";
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        ValueEntryBuffer.Find('-')
                    else
                        ValueEntryBuffer.Next;

                    Profit :=
                      ValueEntryBuffer."Sales Amount (Actual)" +
                      ValueEntryBuffer."Cost Amount (Actual)" +
                      ValueEntryBuffer."Cost Amount (Non-Invtbl.)";

                    if Item.Get(ValueEntryBuffer."Item No.") then;
                end;

                trigger OnPreDataItem()
                begin
                    ValueEntryBuffer.Reset();
                    SetRange(Number, 1, ValueEntryBuffer.Count);
                    Clear(Profit);
                end;
            }

            trigger OnPreDataItem()
            begin
                Clear(Profit);
            end;

            trigger OnAfterGetRecord()
            begin
                Clear(ResidueValueEntry);
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
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Page per Customer';
                        ToolTip = 'Specifies if each customer''s information is printed on a new page if you have chosen two or more customers to be included in the report.';
                    }

                    field(IncludeOrderResidue; IncludeOrderResidue)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Include Order Residue';
                        ToolTip = 'Specifies if additional information about orders and residue is printed';
                    }
                }
            }
        }

        actions
        {
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
        Text000: Label 'Period: %1';
        Item: Record Item;
        ValueEntryBuffer: Record "Value Entry" temporary;
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        CustFilter: Text;
        ValueEntryFilter: Text;
        PeriodText: Text;
        PrintOnlyOnePerPage: Boolean;
        Profit: Decimal;
        ProfitPct: Decimal;
        Customer_Item_SalesCaptionLbl: Label 'Customer/Item Sales';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        All_amounts_are_in_LCYCaptionLbl: Label 'All amounts are in LCY';
        ValueEntryBuffer__Item_No__CaptionLbl: Label 'Item No.';
        Item_DescriptionCaptionLbl: Label 'Description';
        ValueEntryBuffer__Invoiced_Quantity_CaptionLbl: Label 'Invoiced Quantity';
        Item__Base_Unit_of_Measure_CaptionLbl: Label 'Unit of Measure';
        ValueEntryBuffer__Sales_Amount__Actual___Control44CaptionLbl: Label 'Amount';
        ValueEntryBuffer__Discount_Amount__Control45CaptionLbl: Label 'Discount Amount';
        Profit_Control46CaptionLbl: Label 'Profit';
        ProfitPct_Control47CaptionLbl: Label 'Profit %';
        TotalCaptionLbl: Label 'Total';
        EmptyReportDatasetTxt: Label 'There is nothing to print for the selected filters.';
        IncludeOrderResidue: Boolean;
        // PostedAssemblyHeaderBuffer: Record "Posted Assembly Header" temporary;
        //  AssemblyBuffer: Record "Assembly Comment Line" temporary;
        ResidueValueEntry: Record "Value Entry" temporary;
        ResidueEntryNo: Integer;
        OrderNo: Text;
        ResItem: Record Item;
        ResidueLineTxt: Label 'Ext. Doc. No.: %1, Order: %2, Assy Doc. No. %3';
        ResidueExtDocNoTxt: Label 'External Document No.: %1';
        ResidueAmount: Decimal;

    procedure InitializeRequest(NewPagePerCustomer: Boolean)
    begin
        PrintOnlyOnePerPage := NewPagePerCustomer;
    end;
}


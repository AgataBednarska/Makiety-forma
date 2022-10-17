report 50000 "Order Profitability N24"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/OrderProfitability/OrderProfitability.rdlc';
    Caption = 'Order Profitability';
    Permissions = tabledata "Document Buffer N24" = RIMD;

    dataset
    {
        dataitem(PostedAssemblyHeader; "Posted Assembly Header")
        {
            RequestFilterFields = "No.", "External Document No. N24", "Order No.", "Posting Date";
            PrintOnlyIfDetail = true;

            column(PostedAssemblyHeader_No; "No.") { }
            column(PostedAssemblyHeader_ExternalDocumentNo; "External Document No. N24") { IncludeCaption = true; }
            column(AssembledItem_No; AssembledItem."No.") { }
            column(AssembledItem_ItemCategoryCode; AssembledItem."Item Category Code") { }
            column(AssembledItem_Description; AssembledItem.Description) { }
            column(AssembledItem_AssembletoOrder; "Assemble to Order") { }
            column(Posting_Date; "Posting Date") { IncludeCaption = true; }

            dataitem(PostedAssemblyLine; "Posted Assembly Line")
            {
                DataItemLinkReference = PostedAssemblyHeader;
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where(Quantity = filter(<> 0));
                CalcFields = "External Document No. N24";

                trigger OnPreDataItem()
                begin
                    Clear(ConsumptionDates);
                    Clear(ConsumptionCost);
                    Clear(DocBuffer);
                    DocBuffer.DeleteAll();
                end;

                trigger OnPostDataItem()
                var
                    Item: Record Item;
                    ResidueItemLedgerEntry: Record "Item Ledger Entry";
                begin
                    ResidueItemLedgerEntry.SetRange("Entry Type", ResidueItemLedgerEntry."Entry Type"::"Positive Adjmt.");
                    ResidueItemLedgerEntry.SetRange("Document Type", ResidueItemLedgerEntry."Document Type"::" ");
                    ResidueItemLedgerEntry.SetRange("Document No.", PostedAssemblyHeader."Order No.");
                    ResidueItemLedgerEntry.SetRange("External Document No.", PostedAssemblyHeader."External Document No. N24");
                    if ResidueItemLedgerEntry.FindSet() then
                        repeat
                            DocBuffer.Init();
                            DocBuffer."Item No." := ResidueItemLedgerEntry."Item No.";

                            if Item.Get(ResidueItemLedgerEntry."Item No.") then begin
                                DocBuffer."Item Description" := Item.Description;
                                DocBuffer."Item Category Code" := Item."Item Category Code";
                            end;

                            DocBuffer.Quantity := ResidueItemLedgerEntry.Quantity;
                            ResidueItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                            DocBuffer.Amount := ResidueItemLedgerEntry."Cost Amount (Actual)";
                            DocBuffer."Date Text" := Format(ResidueItemLedgerEntry."Posting Date");
                            DocBuffer.Insert(true);
                        until ResidueItemLedgerEntry.Next() = 0;
                end;

                trigger OnAfterGetRecord()
                var
                    ConsumptionItemLedgerEntry: Record "Item Ledger Entry";
                begin
                    if not ConsumedItem.Get(PostedAssemblyLine."No.") then;

                    Clear(ConsumptionDates);

                    if PostedAssemblyLine."External Document No. N24" <> '' then begin
                        ConsumptionItemLedgerEntry.SetRange("Item No.", PostedAssemblyLine."No.");
                        ConsumptionItemLedgerEntry.SetRange("External Document No.", PostedAssemblyLine."External Document No. N24");
                        ConsumptionItemLedgerEntry.SetRange("Location Code", PostedAssemblyLine."Location Code");
                        ConsumptionItemLedgerEntry.SetRange("Entry Type", ConsumptionItemLedgerEntry."Entry Type"::Transfer);
                        if ConsumptionItemLedgerEntry.FindSet() then begin
                            ConsumptionDates := Format(ConsumptionItemLedgerEntry."Posting Date");

                            if ConsumptionItemLedgerEntry.Next() <> 0 then
                                repeat
                                    if StrPos(ConsumptionDates, Format(ConsumptionItemLedgerEntry."Posting Date")) = 0 then
                                        ConsumptionDates += StrSubstNo(ConsumptionDatesJoinTok, ConsumptionItemLedgerEntry."Posting Date");
                                until ConsumptionItemLedgerEntry.Next() = 0;
                        end;
                    end;

                    Clear(ConsumptionItemLedgerEntry);
                    Clear(ConsumptionCost);

                    ConsumptionItemLedgerEntry.SetRange("Posting Date", PostedAssemblyHeader."Posting Date");
                    ConsumptionItemLedgerEntry.SetRange("Document No.", PostedAssemblyHeader."No.");
                    ConsumptionItemLedgerEntry.SetRange("Document Line No.", PostedAssemblyLine."Line No.");
                    if ConsumptionItemLedgerEntry.FindFirst() then begin
                        ConsumptionItemLedgerEntry.CalcFields("Cost Amount (Actual)");
                        ConsumptionCost += ConsumptionItemLedgerEntry."Cost Amount (Actual)";
                    end;

                    DocBuffer.Init();
                    DocBuffer."Item No." := PostedAssemblyLine."No.";
                    DocBuffer."Item Description" := PostedAssemblyLine.Description;
                    DocBuffer."Item Category Code" := ConsumedItem."Item Category Code";
                    DocBuffer.Quantity := -PostedAssemblyLine.Quantity;
                    DocBuffer.Amount := ConsumptionCost;
                    DocBuffer."Date Text" := CopyStr(ConsumptionDates, 1, MaxStrLen(DocBuffer."Date Text"));
                    DocBuffer.Insert(true);
                end;
            }

            dataitem(DocBuffer; "Document Buffer N24")
            {
                DataItemTableView = sorting("Entry No.");

                column(Buffer_ItemNo; "Item No.") { }
                column(Buffer_ItemDescription; "Item Description") { }
                column(Buffer_ItemCategoryCode; "Item Category Code") { }
                column(Buffer_Quantity; Quantity) { }
                column(Buffer_Amount; Amount) { }
                column(Buffer_PostingDate; "Date Text") { }
            }

            dataitem(PostedATOLink; "Posted Assemble-to-Order Link")
            {
                DataItemLinkReference = PostedAssemblyHeader;
                DataItemLink = "Assembly Document No." = field("No.");
                DataItemTableView = sorting("Assembly Document Type", "Assembly Document No.")
                                    where("Assembly Document Type" = const(Assembly), "Document Type" = const("Sales Shipment"));


                column(SalesShipmentHeader_No; SalesShipmentHeader."No.") { }
                column(SalesShipmentHeader_PostingDate; SalesShipmentHeader."Posting Date") { }
                column(SalesShipmentLine_Quantity; -SalesShipmentLine.Quantity) { }
                column(PostedATOLink_OrderNo; "Order No.") { }

                dataitem(SalesInvoiceLine; "Sales Invoice Line")
                {
                    DataItemLink = "Order No." = field("Order No."), "Order Line No." = field("Order Line No.");
                    DataItemTableView = sorting("Document No.", "Line No.");

                    column(SalesInvoiceLine_LineNo; "Line No.") { }
                    column(SalesInvoiceLine_Quantity; Quantity) { IncludeCaption = true; }
                    column(SalesInvoiceLine_LineAmount; "Line Amount") { }
                    column(SalesInvoiceLine_LineAmountLCY; LineAmountLCY) { }
                    column(SalesInvoiceHeader_No; SalesInvoiceHeader."No.") { }
                    column(SalesInvoiceHeader_PostingDate; SalesInvoiceHeader."Posting Date") { }
                    column(SalesInvoiceHeader_SellToCustomerNo; SalesInvoiceHeader."Sell-to Customer No.") { }
                    column(SalesInvoiceHeader_SellToCustomerName; SalesInvoiceHeader."Sell-to Customer Name") { }
                    column(SalesInvoiceHeader_AmountLCY; HeaderAmountLCY) { }

                    trigger OnAfterGetRecord()
                    begin
                        if not SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.") then;

                        SalesInvoiceHeader.CalcFields(Amount);

                        if SalesInvoiceHeader."Currency Factor" <> 0 then begin
                            LineAmountLCY := Round(SalesInvoiceLine."Line Amount" / SalesInvoiceHeader."Currency Factor", 0.01);
                            HeaderAmountLCY := Round(SalesInvoiceHeader.Amount / SalesInvoiceHeader."Currency Factor", 0.01);
                        end else begin
                            LineAmountLCY := SalesInvoiceLine."Line Amount";
                            HeaderAmountLCY := SalesInvoiceHeader.Amount;
                        end;


                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if not SalesShipmentHeader.Get(PostedATOLink."Document No.") then;
                    if not SalesShipmentLine.Get(PostedATOLink."Document No.", PostedATOLink."Document Line No.") then;
                end;

                trigger OnPreDataItem()
                begin
                    if not PostedAssemblyHeader."Assemble to Order" then
                        CurrReport.Skip();
                end;
            }
            dataitem(RWItemLedgerEntry; "Item Ledger Entry")
            {
                DataItemLink = "External Document No." = field("External Document No. N24");
                DataItemTableView = sorting("Entry No.") where("Entry Type" = const("Negative Adjmt."));

                column(RWItemLedgerEntry_EntryNo_; "Entry No.") { }
                column(RWItemLedgerEntry_NoSeries; "No. Series") { IncludeCaption = true; }
                column(RWItemLedgerEntry_DocumentNo; "Document No.") { IncludeCaption = true; }
                column(RWItemLedgerEntry_PostingDate; "Posting Date") { }
                column(RWItemLedgerEntry_SourceNo; "Source No.") { IncludeCaption = true; }
                column(RWCustomer_Name; RWCustomer.Name) { }
                column(RWValueEntry_Cost; RWValueEntry."Cost Amount (Actual)") { }

                trigger OnPreDataItem()
                begin
                    if PostedAssemblyHeader."Assemble to Order" then
                        CurrReport.Break();

                    if PostedAssemblyHeader."External Document No. N24" = '' then
                        CurrReport.Break();
                end;

                trigger OnAfterGetRecord()
                begin
                    RWValueEntry.SetRange("Item Ledger Entry No.", RWItemLedgerEntry."Entry No.");
                    RWValueEntry.CalcSums("Cost Posted to G/L");

                    if not RWCustomer.Get("Source No.") then;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if not AssembledItem.Get(PostedAssemblyHeader."Item No.") then;

                PostedAssemblyHeader.CalcFields("Assemble to Order");
            end;
        }
    }

    labels
    {
        AssemblyLbl = 'Assembly';
        ConsumptionLbl = 'Consumption';
        ShipmentLbl = 'Shipment';
        InvoiceLbl = 'Invoice';
        ExpenseLbl = 'Expense';
        SalesOrderNoLbl = 'Sales Order No.';
        ExternalDocumentNoLbl = 'External Doc. No.';
        ItemNoLbl = 'Item No.';
        ItemDescriptionLbl = 'Item Description';
        PostedAssemblyNoLbl = 'Posted Assembly No.';
        PostedShipmentNoLbl = 'Posted Shipment No.';
        PostedInvoiceNoLbl = 'Posted Invoice No.';
        CustomerNoLbl = 'Customer No.';
        CustomerNameLbl = 'Customer Name';
        NetAmountLbl = 'Net Amount';
        InvoiceNetAmountLbl = 'Invoice Net Amount';
        ItemJournalNoSeriesLbl = 'Item Journal No. Series';
        QuantityLbl = 'Quantity';
        AmountLbl = 'Amount';
        ItemCategoryCodeLbl = 'Item Category Code';
    }

    var
        ConsumedItem: Record Item;
        AssembledItem: Record Item;
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        RWValueEntry: Record "Value Entry";
        RWCustomer: Record Customer;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ConsumptionDates: Text;
        ConsumptionCost: Decimal;
        LineAmountLCY: Decimal;
        HeaderAmountLCY: Decimal;
        ConsumptionDatesJoinTok: Label ' / %1', Locked = true;
}
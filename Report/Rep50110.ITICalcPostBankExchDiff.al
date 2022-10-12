report 50110 "ITI Calc.Post Bank Exch. Diff."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CalcPostBankExchDiff.rdlc';
    Caption = 'Calc. & Post Bank Exch. Diff.';
    Permissions = TableData "Bank Account Ledger Entry" = m;
    ApplicationArea = Basic, Suite;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = where("ITI Excl. from Exch. Rate Adj." = const(false));
            RequestFilterFields = "No.";
            column(No_BankAccount; "No.")
            {
            }
            column(Name_BankAccount; Name)
            {
            }
            column(CurrencyCode_BankAccount; "Currency Code")
            {
                IncludeCaption = true;
            }
            column(Balance_BankAccount; Balance)
            {
            }
            column(FORMATEndDateReq; '..' + Format(VEndDateReq, 0, DateFormat))
            {
            }
            column(GetAppVersion_CompanyInfo; GetAppNameAndVersion.AppNameAndVersion())
            {
            }
            column(COMPANYNAME; COMPANYNAME())
            {
            }
            column(TestMode; VTestMode)
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("No."), "Currency Code" = field("Currency Code");
                DataItemTableView = sorting("Bank Account No.", "Posting Date");

                trigger OnAfterGetRecord()
                var
                    ApplBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
                    AmountLCY: Decimal;
                begin
                    CalculatingNo += 1;
                    Window.Update(2, ROUND(CalculatingNo / CalculatingNoTotal * 10000, 1));

                    if VTestMode then begin
                        if BankAccLedgEntryTemp.Get("Entry No.") then
                            "Bank Account Ledger Entry" := BankAccLedgEntryTemp;
                        if "ITI Applied" or Reversed or "ITI Skip in Difference Calc." then
                            CurrReport.Skip();
                    end;

                    if Amount <= 0 then
                        CurrReport.Skip();

                    ExchRate := "Amount (LCY)" / Amount;
                    RemainingAmount := Amount - "ITI Applied Amount";

                    BankAccLedgEntry.Reset();
                    BankAccLedgEntry.SetCurrentkey("Bank Account No.", "Posting Date");       //FIFO
                    BankAccLedgEntry.CopyFilters("Bank Account Ledger Entry");
                    BankAccLedgEntry.SetRange("ITI Skip in Difference Calc.", false);
                    BankAccLedgEntry.SetRange(Reversed, false);
                    if BankAccLedgEntry.FindFirst() then
                        repeat
                            ExchDiff := 0;

                            if VTestMode then
                                if BankAccLedgEntryTemp.Get(BankAccLedgEntry."Entry No.") then
                                    BankAccLedgEntry := BankAccLedgEntryTemp;
                            if ((not BankAccLedgEntry."ITI Applied") or (not BankAccLedgEntry.Reversed)
                                or (not BankAccLedgEntry."ITI Skip in Difference Calc.")) and (BankAccLedgEntry.Amount < 0) then begin
                                if -RemainingAmount <= (BankAccLedgEntry.Amount - BankAccLedgEntry."ITI Applied Amount") then begin
                                    AppAmount := BankAccLedgEntry.Amount - BankAccLedgEntry."ITI Applied Amount";
                                    RemainingAmount := RemainingAmount + AppAmount;
                                    BankAccLedgEntry."ITI Applied" := true;
                                    if VTestMode then begin
                                        BankAccLedgEntryTemp := BankAccLedgEntry;
                                        if not BankAccLedgEntryTemp.Modify() then begin
                                            BankAccLedgEntryTemp.Insert();
                                            if BankAccLedgEntryTemp."Posting Date" < StartTempDate then
                                                StartTempDate := BankAccLedgEntryTemp."Posting Date";
                                        end;
                                    end;
                                end else begin
                                    AppAmount := -RemainingAmount;
                                    RemainingAmount := 0;
                                end;

                                AmountLCY := BankAccLedgEntry."Amount (LCY)";

                                ApplBankAccountLedgerEntry.SetRange("ITI Applied to Entry", BankAccLedgEntry."Entry No.");
                                if ApplBankAccountLedgerEntry.FindFirst() then
                                    repeat
                                        if VTestMode then begin
                                            if not BankAccLedgEntryTemp.Get(ApplBankAccountLedgerEntry."Entry No.") then
                                                AmountLCY += ApplBankAccountLedgerEntry."Amount (LCY)";
                                        end else
                                            AmountLCY += ApplBankAccountLedgerEntry."Amount (LCY)";
                                    until ApplBankAccountLedgerEntry.Next() = 0;

                                if VTestMode then begin
                                    BankAccLedgEntryTemp.SetRange("ITI Applied to Entry", BankAccLedgEntry."Entry No.");
                                    if BankAccLedgEntryTemp.FindFirst() then
                                        repeat
                                            AmountLCY += BankAccLedgEntryTemp."Amount (LCY)";
                                        until BankAccLedgEntryTemp.Next() = 0;
                                    BankAccLedgEntryTemp.SetRange("ITI Applied to Entry");
                                end;

                                if VTestMode then
                                    if BankAccLedgEntryTemp.Get(BankAccLedgEntry."Entry No.") then
                                        BankAccLedgEntry := BankAccLedgEntryTemp;
                                if BankAccLedgEntry.Amount <> 0 then
                                    ExchDiff := -(AppAmount * ExchRate - (AmountLCY * (AppAmount / BankAccLedgEntry.Amount)));
                                BankAccLedgEntry."ITI Difference Amount" := BankAccLedgEntry."ITI Difference Amount" + ExchDiff;
                                BankAccLedgEntry."ITI Difference Amount" := ROUND(BankAccLedgEntry."ITI Difference Amount", Currency."Amount Rounding Precision");
                                BankAccLedgEntry."ITI Applied Amount" := BankAccLedgEntry."ITI Applied Amount" + AppAmount;
                                BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry."Remaining Amount" - AppAmount;
                                BankAccLedgEntry."ITI Applied to Entry" := "Entry No.";
                                if BankAccLedgEntry."Remaining Amount" = 0 then
                                    BankAccLedgEntry.Open := false;

                                if VTestMode then begin
                                    BankAccLedgEntryTemp := BankAccLedgEntry;
                                    if not BankAccLedgEntryTemp.Modify() then begin
                                        BankAccLedgEntryTemp.Insert();
                                        if BankAccLedgEntryTemp."Posting Date" < StartTempDate then
                                            StartTempDate := BankAccLedgEntryTemp."Posting Date";
                                    end;
                                end else
                                    BankAccLedgEntry.Modify();


                                if VTestMode then
                                    if BankAccLedgEntryTemp.Get("Entry No.") then
                                        "Bank Account Ledger Entry" := BankAccLedgEntryTemp;

                                "ITI Applied Amount" := Amount - RemainingAmount;
                                "Remaining Amount" := RemainingAmount;
                                if RemainingAmount = 0 then begin
                                    "ITI Applied" := true;
                                    Open := false;
                                    "ITI Applied to Entry" := "Entry No."
                                end;

                                if VTestMode then begin
                                    BankAccLedgEntryTemp := "Bank Account Ledger Entry";
                                    if not BankAccLedgEntryTemp.Modify() then begin
                                        BankAccLedgEntryTemp.Insert();
                                        if BankAccLedgEntryTemp."Posting Date" < StartTempDate then
                                            StartTempDate := BankAccLedgEntryTemp."Posting Date";
                                    end;
                                end;

                            end;
                        until (RemainingAmount = 0) or (BankAccLedgEntry.Next() = 0);
                    if not VTestMode then
                        Modify();
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", 0D, EndDate);
                    if not VTestMode then begin
                        SetRange("ITI Applied", false);
                        SetRange(Reversed, false);
                        SetRange("ITI Skip in Difference Calc.", false);
                    end;
                    CalculatingNoTotal := Count();
                end;
            }
            dataitem("Bank Account Ledger Entry 2"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("No.");
                DataItemTableView = sorting("Bank Account No.", "Posting Date") where(Reversed = const(false), "ITI Skip in Difference Calc." = const(false));
                column(EntryNo_BankAccLedgEntryTemp; BankAccLedgEntryTemp."Entry No.")
                {
                    IncludeCaption = true;
                }
                column(FORMATPostingDate_BankAccLedgEntryTemp; Format(BankAccLedgEntryTemp."Posting Date", 0, DateFormat))
                {
                }
                column(Amount_BankAccLedgEntryTemp; BankAccLedgEntryTemp.Amount)
                {
                    IncludeCaption = true;
                }
                column(AmountLCY_BankAccLedgEntryTemp; BankAccLedgEntryTemp."Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                column(AppliedAmount_BankAccLedgEntryTemp; BankAccLedgEntryTemp."ITI Applied Amount")
                {
                    IncludeCaption = true;
                }
                column(DifferenceAmount_BankAccLedgEntryTemp; BankAccLedgEntryTemp."ITI Difference Amount")
                {
                    DecimalPlaces = 2 : 2;
                    IncludeCaption = true;
                }
                column(AppliedToEntry_BankAccLedgEntryTemp; BankAccLedgEntryTemp."ITI Applied to Entry")
                {
                    IncludeCaption = true;
                }
                column(ExRate; ExRate)
                {
                    DecimalPlaces = 4 : 4;
                }
                column(Applied_BankAccLedgEntryTemp; AppliedOpt)
                {
                    OptionCaption = ' ,Yes';
                    OptionMembers = " ",Yes;
                }
                column(PostedDifference_BankAccLedgEntryTemp; DifferencePostedOpt)
                {
                    OptionCaption = ' ,Yes';
                    OptionMembers = " ",Yes;
                }
                column(RealizedGains; RealizedGains)
                {
                }
                column(RealizedLosses; RealizedLosses)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PrintingNo += 1;
                    Window.Update(4, ROUND(PrintingNo / PrintingNoTotal * 10000, 1));

                    if not BankAccLedgEntryTemp.Get("Entry No.") then
                        CurrReport.Skip();

                    if BankAccLedgEntryTemp."ITI Applied" then
                        AppliedOpt := Appliedopt::Yes
                    else begin
                        AppliedOpt := Appliedopt::" ";
                        if (Amount < 0) and (Amount - "ITI Applied Amount" <> 0) then
                            BankAccLedgEntryTemp."ITI Difference Amount" := 0;
                    end;
                    if BankAccLedgEntryTemp."ITI Difference Amount" < 0 then
                        RealizedGains -= BankAccLedgEntryTemp."ITI Difference Amount"
                    else
                        RealizedLosses -= BankAccLedgEntryTemp."ITI Difference Amount";

                    if BankAccLedgEntryTemp.Amount <> 0 then
                        ExRate := BankAccLedgEntryTemp."Amount (LCY)" / BankAccLedgEntryTemp.Amount
                    else
                        ExRate := 0;

                    if BankAccLedgEntryTemp."ITI Difference Posted" then
                        DifferencePostedOpt := Differencepostedopt::Yes
                    else
                        DifferencePostedOpt := Differencepostedopt::" ";
                end;

                trigger OnPreDataItem()
                begin
                    if not VTestMode then
                        CurrReport.Break();

                    SetRange("Posting Date", StartTempDate, EndDate);
                    SetRange("ITI Applied", false);
                    SetRange(Reversed, false);
                    SetRange("ITI Skip in Difference Calc.", false);
                    CurrReport.CreateTotals(BankAccLedgEntryTemp.Amount, BankAccLedgEntryTemp."Amount (LCY)",
                                            BankAccLedgEntryTemp."ITI Difference Amount");

                    PrintingNoTotal := Count();
                end;
            }
            dataitem("Bank Account Ledger Entry 3"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("No.");
                DataItemTableView = sorting("Bank Account No.", "Posting Date") where("ITI Applied" = const(true), "ITI Difference Posted" = const(false));
                column(EntryNo_BankAccountLedgerEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(FORMATPostingDate_BankAccountLedgerEntry; Format("Posting Date", 0, DateFormat))
                {
                }
                column(Amount_BankAccountLedgerEntry; Amount)
                {
                    IncludeCaption = true;
                }
                column(AmountLCY_BankAccountLedgerEntry; "Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                column(AppliedAmount_BankAccountLedgerEntry; "ITI Applied Amount")
                {
                    IncludeCaption = true;
                }
                column(DifferenceAmount_BankAccountLedgerEntry; "ITI Difference Amount")
                {
                    DecimalPlaces = 0 : 8;
                    IncludeCaption = true;
                }
                column(AppliedToEntry_BankAccountLedgerEntry; "ITI Applied to Entry")
                {
                    IncludeCaption = true;
                }
                column(ExRate2; ExRate)
                {
                    DecimalPlaces = 4 : 4;
                }
                column(Applied_BankAccountLedgerEntry; AppliedOpt)
                {
                    OptionCaption = ' ,Yes';
                    OptionMembers = " ",Yes;
                }
                column(PostedDifference_BankAccountLedgerEntry; DifferencePostedOpt)
                {
                    OptionCaption = ' ,Yes';
                    OptionMembers = " ",Yes;
                }
                column(RealizedGains2; RealizedGains)
                {
                }
                column(RealizedLosses2; RealizedLosses)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PostingNo += 1;
                    Window.Update(3, ROUND(PostingNo / PostingNoTotal * 10000, 1));
                    if "ITI Applied" then
                        AppliedOpt := Appliedopt::Yes
                    else begin
                        AppliedOpt := Appliedopt::" ";
                        if (Amount < 0) and (Amount - "ITI Applied Amount" <> 0) then
                            "ITI Difference Amount" := 0;
                    end;
                    if "ITI Difference Amount" <> 0 then begin
                        if "ITI Difference Amount" < 0 then
                            RealizedGains -= "ITI Difference Amount"
                        else
                            RealizedLosses -= "ITI Difference Amount";
                        if "Bank Account Ledger Entry 3".Next(1) = 0 then begin
                            RoundingDifference += "ITI Difference Amount" - ROUND("ITI Difference Amount", Currency."Amount Rounding Precision");
                            PostDifference(ROUND("ITI Difference Amount", Currency."Amount Rounding Precision") + ROUND(RoundingDifference, Currency."Amount Rounding Precision"), Amount,
                                         Format("Document Type"), "Document No.", "Posting Date",
                                         "Entry No.", "Dimension Set ID");
                        end else begin
                            "Bank Account Ledger Entry 3".Next(-1);
                            PostDifference("ITI Difference Amount", Amount,
                                         Format("Document Type"), "Document No.", "Posting Date",
                                         "Entry No.", "Dimension Set ID");
                            RoundingDifference += "ITI Difference Amount" - ROUND("ITI Difference Amount", Currency."Amount Rounding Precision");
                        end;
                        "ITI Difference Posted" := true;
                        Modify();
                    end;

                    if Amount <> 0 then
                        ExRate := "Amount (LCY)" / Amount
                    else
                        ExRate := 0;
                    if "ITI Difference Posted" then
                        DifferencePostedOpt := Differencepostedopt::Yes
                    else
                        DifferencePostedOpt := Differencepostedopt::" ";
                end;

                trigger OnPreDataItem()
                begin
                    if VTestMode then
                        CurrReport.Break();

                    SetRange("Posting Date", 0D, EndDate);

                    Currency.Get("Bank Account"."Currency Code");

                    Currency.TestField("Realized Gains Acc.");
                    Currency.TestField("Realized Losses Acc.");

                    PostingNoTotal := Count();

                    RealizedGains := 0;
                    RealizedLosses := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RealizedGains := 0;
                RealizedLosses := 0;

                BankAccNo += 1;
                Window.Update(1, ROUND(BankAccNo / BankAccNoTotal * 10000, 1));

                if VTestMode then
                    BankAccLedgEntryTemp.DeleteAll();
                StartTempDate := Dmy2date(31, 12, 9999);
            end;

            trigger OnPreDataItem()
            begin
                BankAccNoTotal := Count();
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
                    group("Adjustment Period")
                    {
                        Caption = 'Adjustment Period';
                        field(EndDateReq; VEndDateReq)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ending Date';
                        }
                    }
                    field(PostingDescription; VPostingDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Description';
                    }
                    field(PostingDocNo; VPostingDocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                    }
                    field(TestMode; VTestMode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Test Mode';
                        MultiLine = true;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if VPostingDescription = '' then
                VPostingDescription := BankTransCalcLbl;
            VTestMode := true;
        end;
    }

    labels
    {
        Applied_BankAccLedgEntryTempCaption = 'Applied';
        Applied_BankAccountLedgerEntryCaption = 'Applied';
        BankAccLedgEntryAmountLCYCaption = 'Amount (LCY)';
        BankAccLedgEntryAppliedCaption = 'Applied';
        BankAccLedgEntryAppliedAmountCaption = 'Applied Amount';
        BankAccLedgEntryAppliedToEntryCaption = 'Applied to Entry';
        BankAccLedgEntryAmountCaption = 'Amount';
        BankAccLedgEntryDifferenceAmountCaption = 'Difference Amount';
        BankAccLedgEntryEntryNoCaption = 'Entry No.';
        BankAccLedgEntryPostingDateCaption = 'Posting Date';
        CalcPostBankExchDiffCaption = 'Calc. & Post Bank Exch. Diff.';
        PostedDifference_BankAccLedgEntryTempCaption = 'Difference Posted';
        PostedDifference_BankAccountLedgerEntryCaption = 'Difference Posted';
        ExchangeRateCaption = 'Exchange Rate';
        LastPageCaption = 'Last Page';
        PageNoCaption = 'Page';
        PeriodCaption = 'Period:';
        PostedDifferenceCaption = 'Posted Difference';
        RealizedGainsCaption = 'Realized Gains';
        RealizedLossesCaption = 'Realized Losses';
    }

    trigger OnPostReport()
    begin
        Window.Close();

        if not VTestMode then
            UpdateAnalysisView.UpdateAll(0, true);
    end;

    trigger OnPreReport()
    begin
        GLSetup.Get();
        SalesSetup.Get();
        SourceCodeSetup.Get();

        DateFormat := '<Year4>-<Month,2>-<Day,2>';

        if VEndDateReq = 0D then
            EndDate := Dmy2date(31, 12, 9999)
        else
            EndDate := VEndDateReq;

        PostingDateForClosedPeriod := GLSetup.FirstAllowedPostingDate();

        if VPostingDocNo = '' then
            Error(MustBeEnteredErr, GenJnlLine.FieldCaption("Document No."));

        WindowText := CalculatingTransactionsMsg + BankAccLbl + CalcLbl;
        if VTestMode then
            WindowText := CopyStr(WindowText + PrintingLbl, 1, 1024)
        else
            WindowText := CopyStr(WindowText + PostingLbl, 1, 1024);

        Window.Open(WindowText);
    end;

    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        BankAccLedgEntryTemp: Record "Bank Account Ledger Entry" temporary;
        Currency: Record Currency;
        GenJnlLine: Record "Gen. Journal Line";
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        SourceCodeSetup: Record "Source Code Setup";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        GetAppNameAndVersion: Codeunit "ITI GetAppNameAndVersion";
        DimMgt: Codeunit DimensionManagement;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        AppAmount: Decimal;
        AppliedOpt: Option " ",Yes;
        BankAccNo: Decimal;
        BankAccNoTotal: Decimal;
        CalculatingNo: Decimal;
        CalculatingNoTotal: Decimal;
        DateFormat: Text[30];
        DifferencePostedOpt: Option " ",Yes;
        EndDate: Date;
        VEndDateReq: Date;
        ExchDiff: Decimal;
        ExchRate: Decimal;
        ExRate: Decimal;
        MustBeEnteredErr: label '%1 must be entered.';
        BankTransCalcLbl: label 'Bank Trans. Calc. of %1 %2 %3 %4';
        CalculatingTransactionsMsg: label 'Calculating bank transactions...\\';
        BankAccLbl: label 'Bank Account    @1@@@@@@@@@@@@@\\';
        CalcLbl: label 'Calculating        @2@@@@@@@@@@@@@\';
        PostingLbl: label 'Posting          @3@@@@@@@@@@@@@\';
        PostingDateForClosedPeriod: Date;
        VPostingDescription: Text[50];
        VPostingDocNo: Code[20];
        PostingNo: Decimal;
        PostingNoTotal: Decimal;
        PrintingLbl: label 'Printing          @4@@@@@@@@@@@@@\';
        PrintingNo: Decimal;
        PrintingNoTotal: Decimal;
        RealizedGains: Decimal;
        RealizedLosses: Decimal;
        RemainingAmount: Decimal;
        StartTempDate: Date;
        VTestMode: Boolean;
        Window: Dialog;
        WindowText: Text[1024];
        RoundingDifference: Decimal;

    procedure PostDifference(Amount: Decimal; BaseAmount: Decimal; DocNo: Code[20]; DocType: Text[30]; PostingDate: Date; BankAccLedgEntryNo: Integer; BankAccLedgEntryDimSetID: Integer)
    begin
        TempDimSetEntry.Reset();
        TempDimSetEntry.DeleteAll();
        GenJnlLine.Init();

        GenJnlLine."Document No." := VPostingDocNo;

        if VPostingDescription <> '' then
            //GenJnlLine.Description := VPostingDescription
            GenJnlLine.Description := COPYSTR(STRSUBSTNO(VPostingDescription,
                                                        "Bank Account"."Currency Code",
                                                        BaseAmount, DocType, DocNo),
                                            1, MaxStrLen(GenJnlLine.Description));

        GenJnlLine.TestField(Description);

        if GLSetup.IsPostingAllowed(PostingDate) then
            GenJnlLine."Posting Date" := PostingDate
        else
            GenJnlLine."Posting Date" := PostingDateForClosedPeriod;
        GenJnlLine.Validate("ITI VAT Settlement Date", GenJnlLine."Posting Date");

        GenJnlLine."Currency Code" := "Bank Account"."Currency Code";
        GenJnlLine."ITI Exchange Rate Diff." := true;
        GenJnlLine."Allow Zero-Amount Posting" := true;
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Source Code" := SourceCodeSetup."ITI Bank Trans. Recalculation";

        GenJnlLine."Account Type" := GenJnlLine."bal. account type"::"G/L Account";
        GenJnlLine."Amount (LCY)" := ROUND(Amount, Currency."Amount Rounding Precision");
        GenJnlLine.Amount := 0;
        if Amount > 0 then
            GenJnlLine."Account No." := Currency."Realized Losses Acc."
        else
            GenJnlLine."Account No." := Currency."Realized Gains Acc.";
        GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"Bank Account";
        GenJnlLine."Bal. Account No." := "Bank Account"."No.";
        GenJnlLine."ITI Appl. to Bank Entry No." := BankAccLedgEntryNo;

        GetJnlLineDim(GenJnlLine, TempDimSetEntry, BankAccLedgEntryDimSetID);
        PostGenJnlLine(GenJnlLine, TempDimSetEntry);
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry")
    begin
        GenJnlLine."Shortcut Dimension 1 Code" := GetGlobalDimVal(GLSetup."Global Dimension 1 Code", DimSetEntry);
        GenJnlLine."Shortcut Dimension 2 Code" := GetGlobalDimVal(GLSetup."Global Dimension 2 Code", DimSetEntry);
        GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(DimSetEntry);
        GenJnlPostLine.Run(GenJnlLine);
    end;

    local procedure GetJnlLineDim(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry"; BankAccLedgEntryDimSetID: Integer)
    var
        DimSetEntry2: Record "Dimension Set Entry";
    begin
        DimSetEntry2.SetRange("Dimension Set ID", BankAccLedgEntryDimSetID);
        if DimSetEntry2.FindFirst() then
            repeat
                DimSetEntry := DimSetEntry2;
                DimSetEntry.Insert();
            until DimSetEntry2.Next() = 0
    end;

    local procedure GetGlobalDimVal(GlobalDimCode: Code[20]; var DimSetEntry: Record "Dimension Set Entry"): Code[20]
    var
        DimVal: Code[20];
    begin
        if GlobalDimCode = '' then
            DimVal := ''
        else begin
            DimSetEntry.SetRange("Dimension Code", GlobalDimCode);
            if DimSetEntry.Find('-') then
                DimVal := DimSetEntry."Dimension Value Code"
            else
                DimVal := '';
            DimSetEntry.SetRange("Dimension Code");
        end;
        exit(DimVal);
    end;
}


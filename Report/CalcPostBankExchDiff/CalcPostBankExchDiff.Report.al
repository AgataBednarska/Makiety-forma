report 50105 "Calc.Post Bank Exch. Diff. N24"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Calc. & Post Bank Exch. Diff.';
    DefaultLayout = RDLC;
    Permissions = tabledata "Bank Account Ledger Entry" = m;
    RDLCLayout = './Report/CalcPostBankExchDiff/CalcPostBankExchDiff.rdlc';
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = where("Excl. from Exch. Rate Adj. N24" = const(false));
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
            column(FORMATEndDateReq; '..' + Format(VEndDateReq, 0, DateFormatLbl))
            {
            }
            column(GetAppVersion_CompanyInfo; GetAppNameAndVersion.AppNameAndVersion())
            {
            }
            column(COMPANYNAME; CompanyName())
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

                    Window.Update(2, Round(CalculatingNo / CalculatingNoTotal * 10000, 1));

                    if VTestMode then begin
                        if TempBankAccLedgEntry.Get("Entry No.") then
                            "Bank Account Ledger Entry" := TempBankAccLedgEntry;
                        if "Applied N24" or Reversed or "Skip in Difference Calc. N24" then
                            CurrReport.Skip();
                    end;

                    if Amount <= 0 then
                        CurrReport.Skip();

                    ExchRate := "Amount (LCY)" / Amount;
                    RemainingAmount := Amount - "Applied Amount N24";

                    BankAccountLedgerEntry.Reset();
                    BankAccountLedgerEntry.SetCurrentKey("Bank Account No.", "Posting Date");       //FIFO
                    BankAccountLedgerEntry.CopyFilters("Bank Account Ledger Entry");
                    BankAccountLedgerEntry.SetRange("Skip in Difference Calc. N24", false);
                    BankAccountLedgerEntry.SetRange(Reversed, false);
                    if BankAccountLedgerEntry.FindFirst() then
                        repeat
                            ExchDiff := 0;

                            if VTestMode then
                                if TempBankAccLedgEntry.Get(BankAccountLedgerEntry."Entry No.") then
                                    BankAccountLedgerEntry := TempBankAccLedgEntry;

                            if ((not BankAccountLedgerEntry."Applied N24") or (not BankAccountLedgerEntry.Reversed)
                                or (not BankAccountLedgerEntry."Skip in Difference Calc. N24")) and (BankAccountLedgerEntry.Amount < 0) then begin
                                if -RemainingAmount <= (BankAccountLedgerEntry.Amount - BankAccountLedgerEntry."Applied Amount N24") then begin
                                    AppAmount := BankAccountLedgerEntry.Amount - BankAccountLedgerEntry."Applied Amount N24";
                                    RemainingAmount := RemainingAmount + AppAmount;
                                    BankAccountLedgerEntry."Applied N24" := true;

                                    if VTestMode then begin
                                        TempBankAccLedgEntry := BankAccountLedgerEntry;

                                        if not TempBankAccLedgEntry.Modify() then begin
                                            TempBankAccLedgEntry.Insert();

                                            if TempBankAccLedgEntry."Posting Date" < StartTempDate then
                                                StartTempDate := TempBankAccLedgEntry."Posting Date";
                                        end;
                                    end;
                                end else begin
                                    AppAmount := -RemainingAmount;
                                    RemainingAmount := 0;
                                end;

                                AmountLCY := BankAccountLedgerEntry."Amount (LCY)";

                                ApplBankAccountLedgerEntry.SetRange("Applied to Entry N24", BankAccountLedgerEntry."Entry No.");
                                if ApplBankAccountLedgerEntry.FindFirst() then
                                    if VTestMode then begin
                                        if not TempBankAccLedgEntry.Get(ApplBankAccountLedgerEntry."Entry No.") then
                                            AmountLCY += ApplBankAccountLedgerEntry."Amount (LCY)";
                                    end else
                                        AmountLCY += ApplBankAccountLedgerEntry."Amount (LCY)";

                                if VTestMode then begin
                                    TempBankAccLedgEntry.SetRange("Applied to Entry N24", BankAccountLedgerEntry."Entry No.");
                                    if TempBankAccLedgEntry.FindFirst() then
                                        repeat
                                            AmountLCY += TempBankAccLedgEntry."Amount (LCY)";
                                        until TempBankAccLedgEntry.Next() = 0;
                                    TempBankAccLedgEntry.SetRange("Applied to Entry N24");
                                end;

                                if VTestMode then
                                    if TempBankAccLedgEntry.Get(BankAccountLedgerEntry."Entry No.") then
                                        BankAccountLedgerEntry := TempBankAccLedgEntry;

                                if BankAccountLedgerEntry.Amount <> 0 then
                                    ExchDiff := -(AppAmount * ExchRate - (AmountLCY * (AppAmount / BankAccountLedgerEntry.Amount)));

                                BankAccountLedgerEntry."Difference Amount N24" := BankAccountLedgerEntry."Difference Amount N24" + ExchDiff;
                                BankAccountLedgerEntry."Difference Amount N24" := Round(BankAccountLedgerEntry."Difference Amount N24", Currency."Amount Rounding Precision");
                                BankAccountLedgerEntry."Applied Amount N24" := BankAccountLedgerEntry."Applied Amount N24" + AppAmount;
                                BankAccountLedgerEntry."Remaining Amount" := BankAccountLedgerEntry."Remaining Amount" - AppAmount;
                                BankAccountLedgerEntry."Applied to Entry N24" := "Entry No.";
                                if BankAccountLedgerEntry."Remaining Amount" = 0 then
                                    BankAccountLedgerEntry.Open := false;

                                if VTestMode then begin
                                    TempBankAccLedgEntry := BankAccountLedgerEntry;

                                    if not TempBankAccLedgEntry.Modify() then begin
                                        TempBankAccLedgEntry.Insert();

                                        if TempBankAccLedgEntry."Posting Date" < StartTempDate then
                                            StartTempDate := TempBankAccLedgEntry."Posting Date";
                                    end;
                                end else
                                    BankAccountLedgerEntry.Modify();


                                if VTestMode then
                                    if TempBankAccLedgEntry.Get("Entry No.") then
                                        "Bank Account Ledger Entry" := TempBankAccLedgEntry;

                                "Applied Amount N24" := Amount - RemainingAmount;
                                "Remaining Amount" := RemainingAmount;

                                if RemainingAmount = 0 then begin
                                    "Applied N24" := true;
                                    Open := false;
                                    "Applied to Entry N24" := "Entry No."
                                end;

                                if VTestMode then begin
                                    TempBankAccLedgEntry := "Bank Account Ledger Entry";

                                    if not TempBankAccLedgEntry.Modify() then begin
                                        TempBankAccLedgEntry.Insert();

                                        if TempBankAccLedgEntry."Posting Date" < StartTempDate then
                                            StartTempDate := TempBankAccLedgEntry."Posting Date";
                                    end;
                                end;

                            end;
                        until (RemainingAmount = 0) or (BankAccountLedgerEntry.Next() = 0);
                    if not VTestMode then
                        Modify();
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", 0D, EndDate);
                    if not VTestMode then begin
                        SetRange("Applied N24", false);
                        SetRange(Reversed, false);
                        SetRange("Skip in Difference Calc. N24", false);
                    end;
                    CalculatingNoTotal := Count();
                end;
            }
            dataitem("Bank Account Ledger Entry 2"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("No.");
                DataItemTableView = sorting("Bank Account No.", "Posting Date") where(Reversed = const(false), "Skip in Difference Calc. N24" = const(false));
                column(EntryNo_BankAccLedgEntryTemp; TempBankAccLedgEntry."Entry No.")
                {
                    IncludeCaption = true;
                }
                column(FORMATPostingDate_BankAccLedgEntryTemp; Format(TempBankAccLedgEntry."Posting Date", 0, DateFormatLbl))
                {
                }
                column(Amount_BankAccLedgEntryTemp; TempBankAccLedgEntry.Amount)
                {
                    IncludeCaption = true;
                }
                column(AmountLCY_BankAccLedgEntryTemp; TempBankAccLedgEntry."Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                column(AppliedAmount_BankAccLedgEntryTemp; TempBankAccLedgEntry."Applied Amount N24")
                {
                    IncludeCaption = true;
                }
                column(DifferenceAmount_BankAccLedgEntryTemp; TempBankAccLedgEntry."Difference Amount N24")
                {
                    DecimalPlaces = 2 : 2;
                    IncludeCaption = true;
                }
                column(AppliedToEntry_BankAccLedgEntryTemp; TempBankAccLedgEntry."Applied to Entry N24")
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
                    Window.Update(4, Round(PrintingNo / PrintingNoTotal * 10000, 1));

                    if not TempBankAccLedgEntry.Get("Entry No.") then
                        CurrReport.Skip();

                    if TempBankAccLedgEntry."Applied N24" then
                        AppliedOpt := AppliedOpt::Yes
                    else begin
                        AppliedOpt := AppliedOpt::" ";
                        if (Amount < 0) and (Amount - "Applied Amount N24" <> 0) then
                            TempBankAccLedgEntry."Difference Amount N24" := 0;
                    end;
                    if TempBankAccLedgEntry."Difference Amount N24" < 0 then
                        RealizedGains -= TempBankAccLedgEntry."Difference Amount N24"
                    else
                        RealizedLosses -= TempBankAccLedgEntry."Difference Amount N24";

                    if TempBankAccLedgEntry.Amount <> 0 then
                        ExRate := TempBankAccLedgEntry."Amount (LCY)" / TempBankAccLedgEntry.Amount
                    else
                        ExRate := 0;

                    if TempBankAccLedgEntry."Difference Posted N24" then
                        DifferencePostedOpt := DifferencePostedOpt::Yes
                    else
                        DifferencePostedOpt := DifferencePostedOpt::" ";
                end;

                trigger OnPreDataItem()
                begin
                    if not VTestMode then
                        CurrReport.Break();

                    SetRange("Posting Date", StartTempDate, EndDate);
                    SetRange("Applied N24", false);
                    SetRange(Reversed, false);
                    SetRange("Skip in Difference Calc. N24", false);

                    PrintingNoTotal := Count();
                end;
            }
            dataitem("Bank Account Ledger Entry 3"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("No.");
                DataItemTableView = sorting("Bank Account No.", "Posting Date") where("Applied N24" = const(true), "Difference Posted N24" = const(false));
                column(EntryNo_BankAccountLedgerEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(FORMATPostingDate_BankAccountLedgerEntry; Format("Posting Date", 0, DateFormatLbl))
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
                column(AppliedAmount_BankAccountLedgerEntry; "Applied Amount N24")
                {
                    IncludeCaption = true;
                }
                column(DifferenceAmount_BankAccountLedgerEntry; "Difference Amount N24")
                {
                    DecimalPlaces = 0 : 8;
                    IncludeCaption = true;
                }
                column(AppliedToEntry_BankAccountLedgerEntry; "Applied to Entry N24")
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

                    Window.Update(3, Round(PostingNo / PostingNoTotal * 10000, 1));

                    if "Applied N24" then
                        AppliedOpt := AppliedOpt::Yes
                    else begin
                        AppliedOpt := AppliedOpt::" ";

                        if (Amount < 0) and (Amount - "Applied Amount N24" <> 0) then
                            "Difference Amount N24" := 0;
                    end;

                    if "Difference Amount N24" <> 0 then begin
                        if "Difference Amount N24" < 0 then
                            RealizedGains -= "Difference Amount N24"
                        else
                            RealizedLosses -= "Difference Amount N24";

                        if "Bank Account Ledger Entry 3".Next(1) = 0 then begin
                            RoundingDifference += "Difference Amount N24" - Round("Difference Amount N24", Currency."Amount Rounding Precision");

                            PostDifference(Round("Difference Amount N24", Currency."Amount Rounding Precision") + Round(RoundingDifference, Currency."Amount Rounding Precision"), Amount,
                                         Format("Document Type"), "Document No.", "Posting Date",
                                         "Entry No.", "Dimension Set ID");
                        end else begin
                            "Bank Account Ledger Entry 3".Next(-1);

                            PostDifference("Difference Amount N24", Amount,
                                         Format("Document Type"), "Document No.", "Posting Date",
                                         "Entry No.", "Dimension Set ID");

                            RoundingDifference += "Difference Amount N24" - Round("Difference Amount N24", Currency."Amount Rounding Precision");
                        end;

                        "Difference Posted N24" := true;

                        Modify();
                    end;

                    if Amount <> 0 then
                        ExRate := "Amount (LCY)" / Amount
                    else
                        ExRate := 0;

                    if "Difference Posted N24" then
                        DifferencePostedOpt := DifferencePostedOpt::Yes
                    else
                        DifferencePostedOpt := DifferencePostedOpt::" ";
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
                Window.Update(1, Round(BankAccNo / BankAccNoTotal * 10000, 1));

                if VTestMode then
                    TempBankAccLedgEntry.DeleteAll();

                StartTempDate := DMY2Date(31, 12, 9999);
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
            area(Content)
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
    var

    begin
        GeneralLedgerSetup.Get();
        SourceCodeSetup.Get();

        if VEndDateReq = 0D then
            EndDate := DMY2Date(31, 12, 9999)
        else
            EndDate := VEndDateReq;

        PostingDateForClosedPeriod := GeneralLedgerSetup.FirstAllowedPostingDate();

        if VPostingDocNo = '' then
            Error(MustBeEnteredErr, GenJournalLine.FieldCaption("Document No."));

        WindowText := CalculatingTransactionsMsg + BankAccLbl + CalcLbl;

        if VTestMode then
            WindowText := CopyStr(WindowText + PrintingLbl, 1, 1024)
        else
            WindowText := CopyStr(WindowText + PostingLbl, 1, 1024);

        Window.Open(WindowText);
    end;

    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        TempBankAccLedgEntry: Record "Bank Account Ledger Entry" temporary;
        Currency: Record Currency;
        GenJournalLine: Record "Gen. Journal Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GetAppNameAndVersion: Codeunit "ITI GetAppNameAndVersion";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        VTestMode: Boolean;
        VPostingDocNo: Code[20];
        EndDate: Date;
        PostingDateForClosedPeriod: Date;
        StartTempDate: Date;
        VEndDateReq: Date;
        AppAmount: Decimal;
        BankAccNo: Decimal;
        BankAccNoTotal: Decimal;
        CalculatingNo: Decimal;
        CalculatingNoTotal: Decimal;
        ExchDiff: Decimal;
        ExchRate: Decimal;
        ExRate: Decimal;
        PostingNo: Decimal;
        PostingNoTotal: Decimal;
        PrintingNo: Decimal;
        PrintingNoTotal: Decimal;
        RealizedGains: Decimal;
        RealizedLosses: Decimal;
        RemainingAmount: Decimal;
        RoundingDifference: Decimal;
        Window: Dialog;
        BankAccLbl: Label 'Bank Account    @1@@@@@@@@@@@@@\\';
        BankTransCalcLbl: Label 'Bank Trans. Calc. of %1 %2 %3 %4', Comment = '%1 - "Currency Code", %2 - BaseAmount, %3 - DocType, %4 - DocNo)';
        CalcLbl: Label 'Calculating        @2@@@@@@@@@@@@@\';
        CalculatingTransactionsMsg: Label 'Calculating bank transactions...\\';
        DateFormatLbl: Label '<Year4>-<Month,2>-<Day,2>', Locked = true;
        MustBeEnteredErr: Label '%1 must be entered.', Comment = '%1 - GenJnlLine."Document No."';
        PostingLbl: Label 'Posting          @3@@@@@@@@@@@@@\';
        PrintingLbl: Label 'Printing          @4@@@@@@@@@@@@@\';
        AppliedOpt: Option " ",Yes;
        DifferencePostedOpt: Option " ",Yes;
        VPostingDescription: Text[50];
        WindowText: Text[1024];

    procedure PostDifference(Amount: Decimal; BaseAmount: Decimal; DocNo: Code[20]; DocType: Text[30]; PostingDate: Date; BankAccLedgEntryNo: Integer; BankAccLedgEntryDimSetID: Integer)
    var
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
    begin
        TempDimensionSetEntry.Reset();
        TempDimensionSetEntry.DeleteAll();
        GenJournalLine.Init();

        GenJournalLine."Document No." := VPostingDocNo;

        if VPostingDescription <> '' then
            GenJournalLine.Description := CopyStr(StrSubstNo(VPostingDescription,
                                                        "Bank Account"."Currency Code",
                                                        BaseAmount, DocType, DocNo),
                                            1, MaxStrLen(GenJournalLine.Description));

        GenJournalLine.TestField(Description);

        if GeneralLedgerSetup.IsPostingAllowed(PostingDate) then
            GenJournalLine."Posting Date" := PostingDate
        else
            GenJournalLine."Posting Date" := PostingDateForClosedPeriod;

        GenJournalLine.Validate("ITI VAT Settlement Date", GenJournalLine."Posting Date");

        GenJournalLine."Currency Code" := "Bank Account"."Currency Code";
        GenJournalLine."Exchange Rate Diff. N24" := true;
        GenJournalLine."Allow Zero-Amount Posting" := true;
        GenJournalLine."System-Created Entry" := true;
        GenJournalLine."Source Code" := SourceCodeSetup."Bank Trans. Recalculation N24";
        GenJournalLine."Account Type" := GenJournalLine."Bal. Account Type"::"G/L Account";
        GenJournalLine."Amount (LCY)" := Round(Amount, Currency."Amount Rounding Precision");
        GenJournalLine.Amount := 0;

        if Amount > 0 then
            GenJournalLine."Account No." := Currency."Realized Losses Acc."
        else
            GenJournalLine."Account No." := Currency."Realized Gains Acc.";

        GenJournalLine."Bal. Account Type" := GenJournalLine."Bal. Account Type"::"Bank Account";
        GenJournalLine."Bal. Account No." := "Bank Account"."No.";
        GenJournalLine."Appl. to Bank Entry No. N24" := BankAccLedgEntryNo;

        GetJnlLineDim(TempDimensionSetEntry, BankAccLedgEntryDimSetID);
        PostGenJnlLine(GenJournalLine, TempDimensionSetEntry);
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry")
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        GenJnlLine."Shortcut Dimension 1 Code" := GetGlobalDimVal(GeneralLedgerSetup."Global Dimension 1 Code", DimSetEntry);
        GenJnlLine."Shortcut Dimension 2 Code" := GetGlobalDimVal(GeneralLedgerSetup."Global Dimension 2 Code", DimSetEntry);
        GenJnlLine."Dimension Set ID" := DimensionManagement.GetDimensionSetID(DimSetEntry);
        GenJnlPostLine.Run(GenJnlLine);
    end;

    local procedure GetJnlLineDim(var DimSetEntry: Record "Dimension Set Entry"; BankAccLedgEntryDimSetID: Integer)
    var
        DimSetEntry2: Record "Dimension Set Entry";
    begin
        DimSetEntry2.SetRange("Dimension Set ID", BankAccLedgEntryDimSetID);
        if DimSetEntry2.FindFirst() then begin
            DimSetEntry := DimSetEntry2;
            DimSetEntry.Insert();
        end;
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
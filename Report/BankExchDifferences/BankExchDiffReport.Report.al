report 50104 "Bank Exch. Diff. Report N24"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Bank Exch. Differences Report';
    DefaultLayout = RDLC;
    RDLCLayout = './Report/BankExchDifferences/BankExchDifferences.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
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
            column(FORMATStartDate; Format(VStartDate, 0, DateFormatLbl))
            {
            }
            column(FORMATEndDate; Format(VEndDateReq, 0, DateFormatLbl))
            {
            }
            column(COMPANYNAME; CompanyName())
            {
            }
            column(GetAppVersion_CompanyInfo; ITIGetAppNameAndVersion.AppNameAndVersion())
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("No.");
                DataItemTableView = sorting("Bank Account No.", "Posting Date");
                column(EntryNo_BankAccountLedgerEntry; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(PostingDate_BankAccountLedgerEntry; Format("Posting Date", 0, DateFormatLbl))
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
                }
                column(DifferenceAmount_BankAccountLedgerEntry; "Difference Amount N24")
                {
                }
                column(AppliedToEntry_BankAccountLedgerEntry; "Applied to Entry N24")
                {
                }
                column(ExRate; ExRate)
                {
                }
                column(Applied_BankAccountLedgerEntry; AppliedOpt)
                {
                }
                column(PostedDifference_BankAccountLedgerEntry; DifferencePostedOpt)
                {
                }
                column(RealizedGains; RealizedGains)
                {
                }
                column(RealizedLosses; RealizedLosses)
                {
                }
                column(AppliedAmountCptn; AppliedAmountLbl)
                {
                }
                column(DifferenceAmountCptn; DifferenceAmountLbl)
                {
                }
                column(AppliedToEntryCptn; AppliedToEntryLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Difference Amount N24" < 0 then
                        RealizedGains += -"Difference Amount N24"
                    else
                        RealizedLosses += -"Difference Amount N24";

                    if Amount <> 0 then
                        ExRate := "Amount (LCY)" / Amount
                    else
                        ExRate := 0;

                    if "Applied N24" then
                        AppliedOpt := AppliedOpt::Yes
                    else
                        AppliedOpt := AppliedOpt::Blank;

                    if "Difference Posted N24" then
                        DifferencePostedOpt := DifferencePostedOpt::Yes
                    else
                        DifferencePostedOpt := DifferencePostedOpt::Blank;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Posting Date", VStartDate, EndDate);
                end;
            }
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
                    group("Printing Period")
                    {
                        Caption = 'Printing Period';
                        field(StartDate; VStartDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Date';
                        }
                        field(EndDateReq; VEndDateReq)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ending Date';
                        }
                    }
                }
            }
        }
    }

    labels
    {
        Applied_BankAccountLedgerEntryCaption = 'Applied';
        BankExchDifferencesReportCaption = 'Bank Exch. Differences Report';
        ExchangeRateCaption = 'Exchange Rate';
        LastPageCaption = 'Last Page';
        PageNoCaption = 'Page';
        PeriodCaption = 'Period:';
        PostedDifferenceCaption = 'Posted Difference';
        PostedDifference_BankAccountLedgerEntryCaption = 'Difference Posted';
        PostingDateCaption = 'Posting Date';
        RealizedGainsCaption = 'Realized Gains';
        RealizedLossesCaption = 'Realized Losses';
    }

    trigger OnPreReport()
    var

    begin
        if VEndDateReq = 0D then
            EndDate := DMY2Date(31, 12, 9999)
        else
            EndDate := VEndDateReq;
    end;

    var
        ITIGetAppNameAndVersion: Codeunit "ITI GetAppNameAndVersion";
        EndDate: Date;
        VEndDateReq: Date;
        VStartDate: Date;
        ExRate: Decimal;
        RealizedGains: Decimal;
        RealizedLosses: Decimal;
        AppliedOpt: Enum "BlankYesOption N24";
        DifferencePostedOpt: Enum "BlankYesOption N24";
        AppliedAmountLbl: Label 'Applied Amount';
        AppliedToEntryLbl: Label 'Applied to Entry';
        DateFormatLbl: Label '<Year4>-<Month,2>-<Day,2>', Locked = true;
        DifferenceAmountLbl: Label 'Difference Amount';
}
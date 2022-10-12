report 50109 "ITI Bank Exch. Diff. Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/BankExchDifferencesReport.rdlc';
    Caption = 'Bank Exch. Differences Report';
    ApplicationArea = Basic, Suite;
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
            column(FORMATStartDate; Format(VStartDate, 0, DateFormat))
            {
            }
            column(FORMATEndDate; Format(VEndDateReq, 0, DateFormat))
            {
            }
            column(COMPANYNAME; COMPANYNAME())
            {
            }
            column(GetAppVersion_CompanyInfo; GetAppNameAndVersion.AppNameAndVersion())
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
                column(PostingDate_BankAccountLedgerEntry; Format("Posting Date", 0, DateFormat))
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
                }
                column(DifferenceAmount_BankAccountLedgerEntry; "ITI Difference Amount")
                {
                }
                column(AppliedToEntry_BankAccountLedgerEntry; "ITI Applied to Entry")
                {
                }
                column(ExRate; ExRate)
                {
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
                    if "ITI Difference Amount" < 0 then
                        RealizedGains += -"ITI Difference Amount"
                    else
                        RealizedLosses += -"ITI Difference Amount";

                    if Amount <> 0 then
                        ExRate := "Amount (LCY)" / Amount
                    else
                        ExRate := 0;

                    if "ITI Applied" then
                        AppliedOpt := Appliedopt::Yes
                    else
                        AppliedOpt := Appliedopt::" ";

                    if "ITI Difference Posted" then
                        DifferencePostedOpt := Differencepostedopt::Yes
                    else
                        DifferencePostedOpt := Differencepostedopt::" ";
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
            area(content)
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

        actions
        {
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
    begin
        DateFormat := '<Year4>-<Month,2>-<Day,2>';

        if VEndDateReq = 0D then
            EndDate := Dmy2date(31, 12, 9999)
        else
            EndDate := VEndDateReq;
    end;

    var
        GetAppNameAndVersion: Codeunit "ITI GetAppNameAndVersion";
        AppliedOpt: Option " ",Yes;
        EndDate: Date;
        VEndDateReq: Date;
        ExRate: Decimal;
        DateFormat: Text[30];
        DifferencePostedOpt: Option " ",Yes;
        RealizedGains: Decimal;
        RealizedLosses: Decimal;
        VStartDate: Date;
        AppliedAmountLbl: Label 'Applied Amount';
        DifferenceAmountLbl: Label 'Difference Amount';
        AppliedToEntryLbl: Label 'Applied to Entry';
}


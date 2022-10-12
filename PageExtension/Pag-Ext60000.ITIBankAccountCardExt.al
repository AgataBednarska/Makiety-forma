pageextension 50196 "ITI BankAccountCardExt" extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(processing)
        {
            action(ITICalcPostExchangeDifferences)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Calculate & Post Exchange Differences';
                Image = CalculateVAT;

                trigger OnAction()
                var
                    BankAccount: Record "Bank Account";
                begin
                    CurrPage.SetSelectionFilter(BankAccount);
                    Report.Run(Report::"ITI Calc.Post Bank Exch. Diff.", true, true, BankAccount);
                end;
            }
            action(ITIReportExchangeDifferences)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Report Exchange Differences';
                Image = Report;

                trigger OnAction()
                var
                    BankAccount: Record "Bank Account";
                begin
                    CurrPage.SetSelectionFilter(BankAccount);
                    Report.Run(Report::"ITI Bank Exch. Diff. Report", true, true, BankAccount);
                end;
            }
        }
    }
}
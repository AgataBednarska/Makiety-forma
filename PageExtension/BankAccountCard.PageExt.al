pageextension 50022 "Bank Account Card N24" extends "Bank Account Card"
{
    actions
    {
        addlast(processing)
        {
            action("CalcPostExchangeDifferences N24")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Calculate & Post Exchange Differences';
                Image = CalculateVAT;

                trigger OnAction()
                var
                    BankAccount: Record "Bank Account";
                begin
                    CurrPage.SetSelectionFilter(BankAccount);
                    Report.Run(Report::"Calc.Post Bank Exch. Diff. N24", true, true, BankAccount);
                end;
            }
            action("ReportExchangeDifferences N24")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Report Exchange Differences';
                Image = Report;

                trigger OnAction()
                var
                    BankAccount: Record "Bank Account";
                begin
                    CurrPage.SetSelectionFilter(BankAccount);
                    Report.Run(Report::"Bank Exch. Diff. Report N24", true, true, BankAccount);
                end;
            }
        }
    }
}
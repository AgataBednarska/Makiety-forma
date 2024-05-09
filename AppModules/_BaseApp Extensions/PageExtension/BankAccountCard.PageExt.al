pageextension 50162 "Bank Account Card N24" extends "Bank Account Card"
{
    actions
    {
        addlast(processing)
        {
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
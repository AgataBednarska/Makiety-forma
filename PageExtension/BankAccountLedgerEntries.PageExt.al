pageextension 50119 "Bank Account Ledger Entries" extends "Bank Account Ledger Entries"
{
    layout
    {
        addfirst(Control1)
        {
            field("ITI Applied Amount N24"; Rec."Applied Amount N24")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addlast(Control1)
        {
            field("ITI Skipped by UserID N24"; Rec."Skipped by UserID N24")
            {
                ApplicationArea = Basic, Suite;
            }
            field("ITI Unskipped by UserID N24"; Rec."Unskipped by UserID N24")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    var
        FinancialMgt: Codeunit "FinancialMgt N24";
    begin
        FinancialMgt.EditBankLedgerEntry(Rec);
        exit(false);
    end;
}
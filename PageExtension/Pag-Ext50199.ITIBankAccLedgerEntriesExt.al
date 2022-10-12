pageextension 50199 "ITI BankAccLedgerEntriesExt" extends "Bank Account Ledger Entries"
{
    layout
    {
        addfirst(Control1)
        {
            field("ITI Applied Amount"; "ITI Applied Amount")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
            }
        }
        addlast(Control1)
        {
            field("ITI Skipped by UserID"; "ITI Skipped by UserID")
            {
                ApplicationArea = Basic, Suite;
            }
            field("ITI Unskipped by UserID"; "ITI Unskipped by UserID")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        Codeunit.Run(Codeunit::"ITI BankLedgerEntry - Edit", Rec);
        exit(false);
    end;
}
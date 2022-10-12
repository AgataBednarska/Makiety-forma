codeunit 50147 "ITI BankLedgerEntry - Edit"
{
    Permissions = TableData "Bank Account Ledger Entry" = m;
    TableNo = "Bank Account Ledger Entry";

    trigger OnRun()
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccLedgEntry := Rec;
        BankAccLedgEntry.LockTable();
        BankAccLedgEntry.Find();
        if not BankAccLedgEntry."ITI Difference Posted" then
            BankAccLedgEntry."ITI Skip in Difference Calc." := Rec."ITI Skip in Difference Calc."
        else
            Error(BlankErr);

        BankAccLedgEntry.Modify();
        Rec := BankAccLedgEntry;
    end;

    var
        BlankErr: Label '';
}


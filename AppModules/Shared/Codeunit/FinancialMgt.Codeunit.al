codeunit 50108 "FinancialMgt N24"
{
    Permissions = tabledata "Bank Account Ledger Entry" = m;
    //TODO Table 'Invoice Post. Buffer' is marked for removal. Reason: This table will be replaced by table Invoice Posting Buffer in new Invoice Posting implementation.. Tag: 20.0.
    procedure AssignPostingDescriptionToGLFromPurchaseLine(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        if PurchaseLine.Type <> PurchaseLine.Type::"G/L Account" then
            exit;

        PurchasesPayablesSetup.Get();

        if PurchasesPayablesSetup."GLAcc. Line Post. Desc. N24" then
            InvoicePostBuffer."Entry Description" := PurchaseLine.Description;
    end;

    procedure EditBankLedgerEntry(var Rec: Record "Bank Account Ledger Entry")
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
    begin
        BankAccLedgEntry := Rec;
        BankAccLedgEntry.ReadIsolation := IsolationLevel::UpdLock;

        BankAccLedgEntry.Find();
        if not BankAccLedgEntry."Difference Posted N24" then
            BankAccLedgEntry."Skip in Difference Calc. N24" := Rec."Skip in Difference Calc. N24"
        else
            Error('');

        BankAccLedgEntry.Modify();

        Rec := BankAccLedgEntry;
    end;

    procedure TransferSalespersonCode(var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine."Salespers./Purch. Code" := GenJnlLine."Salespers./Purch. Code N24";
    end;
}
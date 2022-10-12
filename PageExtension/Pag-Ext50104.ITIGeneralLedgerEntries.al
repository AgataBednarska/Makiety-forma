pageextension 50104 "ITI GeneralLedgerEntries" extends "General Ledger Entries"
{
    layout
    {
        modify("G/L Account Name")
        {
            Visible = true;
        }
        moveafter("Document No."; "External Document No.")
    }
}

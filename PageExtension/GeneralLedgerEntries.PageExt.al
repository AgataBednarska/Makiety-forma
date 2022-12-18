pageextension 50004 "General Ledger Entries N24" extends "General Ledger Entries"
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

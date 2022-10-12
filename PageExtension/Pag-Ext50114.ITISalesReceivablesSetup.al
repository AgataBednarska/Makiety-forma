pageextension 50114 "ITI Sales&ReceivablesSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Direct Debit Mandate Nos.")
        {
            field("Posted Debit Note Nos."; Rec."Posted Debit Note Nos.")
            {
                ApplicationArea = All;
            }
        }
    }
}

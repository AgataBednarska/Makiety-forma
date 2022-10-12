tableextension 50102 "ITI Sales&ReceivablesSetup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Posted Debit Note Nos."; Code[10])
        {
            Caption = 'Posted Debit Note No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
    }
}
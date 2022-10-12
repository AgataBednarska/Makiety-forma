tableextension 50103 "ITI SalesInvoiceHeader" extends "Sales Invoice Header"
{
    fields
    {
        field(50101; "Debit Note"; Boolean)
        {
            Caption = 'Debit note';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
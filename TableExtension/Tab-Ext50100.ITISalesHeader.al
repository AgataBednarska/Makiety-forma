tableextension 50100 "ITI SalesHeader" extends "Sales Header"
{
    fields
    {
        field(50100; "Execution Status"; Enum "ITI Sales Execution Status")
        {
            Caption = 'Execution Status';
            DataClassification = ToBeClassified;
        }
        field(50101; "Debit Note"; Boolean)
        {
            Caption = 'Debit note';
            DataClassification = ToBeClassified;

            trigger OnValidate();
            var
                DebitNoteMgt: Codeunit "ITI DebitNoteMgt";
            begin
                DebitNoteMgt.ValidateDebitNote(Rec);
            end;
        }
    }
}

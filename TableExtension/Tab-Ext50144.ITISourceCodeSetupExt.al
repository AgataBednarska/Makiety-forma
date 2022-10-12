tableextension 50144 "ITI SourceCodeSetupExt" extends "Source Code Setup"
{
    fields
    {
        field(60000; "ITI Bank Trans. Recalculation"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Bank Trans. Recalculation';
            TableRelation = "Source Code";
        }
    }
}
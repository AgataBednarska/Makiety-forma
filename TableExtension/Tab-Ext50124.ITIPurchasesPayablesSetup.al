tableextension 50124 "ITI Purchases&PayablesSetup" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50100; "Use GLAcc. Line Posting Desc."; Boolean)
        {
            Caption = 'Use G/L Account Line Posting Description';
            DataClassification = ToBeClassified;
        }
    }
}

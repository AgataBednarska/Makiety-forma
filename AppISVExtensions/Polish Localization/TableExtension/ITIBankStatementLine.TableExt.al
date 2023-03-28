tableextension 50125 "ITI Bank Statement Line N24" extends "ITI Bank Statement Line"
{
    fields
    {
        field(50100; "Salespers./Purch. Code N24"; Code[20])
        {
            Caption = 'Salespers./Purch. Code';
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
        }
        modify("Bal. Account No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                if Rec."Bal. Account Type" <> "Bal. Account Type"::Customer then
                    exit;

                if Customer.Get(Rec."Bal. Account No.") then
                    "Salespers./Purch. Code N24" := Customer."Salesperson Code";
            end;
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            var
                Customer: Record Customer;
            begin
                if Rec."Account Type" <> "Account Type"::Customer then
                    exit;

                if Customer.Get(Rec."Account No.") then
                    "Salespers./Purch. Code N24" := Customer."Salesperson Code";
            end;
        }
    }
}
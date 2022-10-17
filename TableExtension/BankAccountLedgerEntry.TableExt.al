tableextension 50030 "Bank Account Ledger Entry N24" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50000; "Applied Amount N24"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied Amount';
        }
        field(50001; "Difference Amount N24"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Difference Amount';
        }
        field(50002; "Applied to Entry N24"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied to Entry';
            TableRelation = "Bank Account Ledger Entry"."Entry No.";
        }
        field(50003; "Applied N24"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied';
        }
        field(50004; "Difference Posted N24"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Difference Posted';
        }
        field(50005; "Skip in Difference Calc. N24"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Skip in Difference Calc.';

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                SkipBankLedgerErr: Label 'You don''t have permission to change the field Skip in Difference Calc.';
            begin
                if not UserSetup.Get(UserId()) then
                    Error(SkipBankLedgerErr);

                if not UserSetup."Allow Skip Bank Ldg. Entry N24" then
                    Error(SkipBankLedgerErr);

                if not (xRec."Skip in Difference Calc. N24") then begin
                    "Skipped by UserID N24" := CopyStr(UserId(), 1, 30);
                    "Skipped Date/Time N24" := CurrentDateTime();

                    Modify();
                end;

                if xRec."Skip in Difference Calc. N24" then begin
                    "Unskipped by UserID N24" := CopyStr(UserId(), 1, 30);
                    "Unskipped Date/Time N24" := CurrentDateTime();

                    Modify();
                end;
            end;
        }
        field(50006; "Skipped by UserID N24"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Skipped by UserID';
        }
        field(50007; "Skipped Date/Time N24"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Skipped Date/Time';
        }
        field(50008; "Unskipped by UserID N24"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Unskipped by UserID';
        }
        field(50009; "Unskipped Date/Time N24"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Unskipped Date/Time';
        }
    }
}
tableextension 50175 "Bank Account Ledger Entry N24" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50100; "Applied Amount N24"; Decimal)
        {
            Caption = 'Applied Amount';
            DataClassification = CustomerContent;
        }
        field(50101; "Difference Amount N24"; Decimal)
        {
            Caption = 'Difference Amount';
            DataClassification = CustomerContent;
        }
        field(50102; "Applied to Entry N24"; Integer)
        {
            Caption = 'Applied to Entry';
            DataClassification = CustomerContent;
            TableRelation = "Bank Account Ledger Entry"."Entry No.";
        }
        field(50103; "Applied N24"; Boolean)
        {
            Caption = 'Applied';
            DataClassification = CustomerContent;
        }
        field(50104; "Difference Posted N24"; Boolean)
        {
            Caption = 'Difference Posted';
            DataClassification = CustomerContent;
        }
        field(50105; "Skip in Difference Calc. N24"; Boolean)
        {
            Caption = 'Skip in Difference Calc.';
            DataClassification = CustomerContent;

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
        field(50106; "Skipped by UserID N24"; Code[30])
        {
            Caption = 'Skipped by UserID';
            DataClassification = CustomerContent;
        }
        field(50107; "Skipped Date/Time N24"; DateTime)
        {
            Caption = 'Skipped Date/Time';
            DataClassification = CustomerContent;
        }
        field(50108; "Unskipped by UserID N24"; Code[30])
        {
            Caption = 'Unskipped by UserID';
            DataClassification = CustomerContent;
        }
        field(50109; "Unskipped Date/Time N24"; DateTime)
        {
            Caption = 'Unskipped Date/Time';
            DataClassification = CustomerContent;
        }
    }
}
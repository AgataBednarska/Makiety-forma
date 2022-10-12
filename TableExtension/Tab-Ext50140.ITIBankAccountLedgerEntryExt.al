tableextension 50140 "ITI BankAccountLedgerEntryExt" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(60000; "ITI Applied Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied Amount';
        }
        field(60001; "ITI Difference Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Difference Amount';
        }
        field(60002; "ITI Applied to Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied to Entry';
            TableRelation = "Bank Account Ledger Entry"."Entry No.";
        }
        field(60003; "ITI Applied"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Applied';
        }
        field(60004; "ITI Difference Posted"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Difference Posted';
        }
        field(60005; "ITI Skip in Difference Calc."; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Skip in Difference Calc.';

            trigger OnValidate()
            var
                BankAccLE: Record "Bank Account Ledger Entry";
                OK: Boolean;
            begin
                if UserSetup.Get(UserId()) then begin
                    if not UserSetup."ITI Allow Skip Bank Ldg. Entry" then
                        Error(SkipBankLedgerErr)
                end else
                    Error(SkipBankLedgerErr);

                if not (xRec."ITI Skip in Difference Calc.") then begin
                    "ITI Skipped by UserID" := CopyStr(UserId(), 1, 30);
                    "ITI Skipped Date/Time" := CurrentDateTime();
                    Modify();
                end;

                OK := false;
                BankAccLE.SetRange("Bank Account No.", "Bank Account No.");
                BankAccLE.SetRange("Entry No.", "Entry No.");
                BankAccLE.SetRange(Open, true);
                BankAccLE.SetRange("ITI Applied Amount", 0);
                BankAccLE.SetRange("ITI Difference Amount", 0);
                BankAccLE.SetRange("ITI Applied to Entry", 0);
                BankAccLE.SetRange("ITI Applied", false);
                BankAccLE.SetRange("ITI Difference Posted", false);
                BankAccLE.SetRange(Reversed, false);
                if BankAccLE.FindFirst() then
                    OK := true;

                BankAccLE.Reset();
                BankAccLE.SetRange("Bank Account No.", "Bank Account No.");
                BankAccLE.SetFilter("ITI Applied Amount", '>%1', 0);
                if BankAccLE.FindLast() then
                    if "Entry No." < BankAccLE."Entry No." then
                        OK := false;

                if xRec."ITI Skip in Difference Calc." then begin
                    BankAccLE.Reset();
                    BankAccLE.SetRange("Bank Account No.", "Bank Account No.");
                    BankAccLE.SetRange("ITI Applied", true);
                    BankAccLE.SetRange("ITI Difference Posted", true);
                    if BankAccLE.FindLast() then
                        if "Entry No." < BankAccLE."Entry No." then
                            OK := false;
                    "ITI Unskipped by UserID" := CopyStr(UserId(), 1, 30);
                    "ITI Unskipped Date/Time" := CurrentDateTime();
                    Modify();
                end;
            end;
        }
        field(60006; "ITI Skipped by UserID"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Skipped by UserID';
        }
        field(60007; "ITI Skipped Date/Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Skipped Date/Time';
        }
        field(60008; "ITI Unskipped by UserID"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Unskipped by UserID';
        }
        field(60009; "ITI Unskipped Date/Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Caption = 'Unskipped Date/Time';
        }
    }

    var
        UserSetup: Record "User Setup";
        SkipBankLedgerErr: Label 'You don''t have permission to change the field Skip in Difference Calc.';

}
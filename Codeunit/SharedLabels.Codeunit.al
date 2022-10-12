codeunit 50005 "Shared Labels N24"
{
    SingleInstance = true;

    procedure GetProcessCompletedSuccessfullyLbl(): Text
    var
        ProcessCompletedSuccessfullyLbl: Label 'Process completed successfully';
    begin
        exit(ProcessCompletedSuccessfullyLbl);
    end;
}
codeunit 50004 "Constants N24"
{
    SingleInstance = true;

    procedure GetPLLanguageCodeConst(): Text[3]
    begin
        exit('PLK');
    end;

    procedure GetPLWindowsLanguageIDConst(): Integer
    begin
        exit(1045);
    end;
}
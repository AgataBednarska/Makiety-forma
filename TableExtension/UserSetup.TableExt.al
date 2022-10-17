tableextension 50016 "User Setup N24" extends "User Setup"
{
    fields
    {
        field(50000; "Allow Skip Bank Ldg. Entry N24"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Skip Bank Ledger Entry';
        }
    }
    
    procedure GetOrCreateUserSetup(): Record "User Setup"
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId()) then
            exit(UserSetup);

        UserSetup.Init();
        UserSetup."User ID" := CopyStr(UserId(), 1, MaxStrLen(UserSetup."User ID"));
        UserSetup.Insert(true);

        exit(UserSetup);
    end;

    procedure GetFullUserName(): Text[80];
    var
        User: Record User;
    begin
        User.SetRange("User Name", Rec."User ID");

        if User.FindFirst() then
            exit(GetFullUserName(User));
    end;

    procedure GetFullUserName(UserGuid: Guid): Text[80];
    var
        User: Record User;
    begin
        if User.Get(UserGuid) then
            exit(GetFullUserName(User));
    end;

    local procedure GetFullUserName(User: Record User): Text[80]
    begin
        if User."Full Name" <> '' then
            exit(User."Full Name");

        exit(User."User Name");
    end;
}
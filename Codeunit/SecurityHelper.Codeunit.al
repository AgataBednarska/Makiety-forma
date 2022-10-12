codeunit 50001 "Security Helper N24"
{
    SingleInstance = true;

    procedure UserHasSuperPermissionSet(): Boolean
    var
        UserPermissions: Codeunit "User Permissions";
    begin
        exit(UserPermissions.IsSuper(UserSecurityId()));
    end;

    procedure ThrowErrorIfUserHasNotSuperPermissionSet()
    var
        UserMustBeSuperErr: Label 'User must have "SUPER" permission set to perform this operation.';
    begin
        if not UserHasSuperPermissionSet() then
            Error(UserMustBeSuperErr);
    end;

    /// <param name="UserSetupFieldNo">Sample: UserSetup.FieldNo("Field Name")</param>
    procedure UserHasPrivilege(UserSetupFieldNo: Integer): Boolean
    var
        UserSetupFieldRef: FieldRef;
    begin
        UserSetupFieldRef := GetUserSetupFieldRef(UserSetupFieldNo);

        exit(UserSetupFieldRef.Value);
    end;

    /// <param name="UserSetupFieldNo">Sample: UserSetup.FieldNo("Field Name")</param>
    procedure ThrowErrorOnMissingPrivilege(UserSetupFieldNo: Integer)
    var
        UserSetupFieldRef: FieldRef;
    begin
        UserSetupFieldRef := GetUserSetupFieldRef(UserSetupFieldNo);

        UserSetupFieldRef.TestField(true);
    end;

    local procedure GetUserSetupFieldRef(UserSetupFieldNo: Integer): FieldRef
    var
        UserSetup: Record "User Setup";
        RecRef: RecordRef;
    begin
        UserSetup := UserSetup.GetOrCreateUserSetup();

        RecRef.Get(UserSetup.RecordId());

        exit(RecRef.Field(UserSetupFieldNo));
    end;
}
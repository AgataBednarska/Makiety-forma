codeunit 50112 "Upgrade Mgt. N24"
{
    Access = Internal;
    Subtype = Upgrade;

    #region OnUpgradePerDatabase

    trigger OnCheckPreconditionsPerDatabase()
    begin
        // Code to make sure database is OK to upgrade.
    end;

    trigger OnUpgradePerDatabase()
    begin
        // Code to perform database related table upgrade tasks
    end;

    trigger OnValidateUpgradePerDatabase()
    begin
        // Code to make sure that upgrade was successful for database
    end;

    #endregion OnUpgradePerDatabase

    #region OnUpgradePerCompany

    trigger OnCheckPreconditionsPerCompany()
    begin
        // Code to make sure company is OK to upgrade.
    end;

    trigger OnUpgradePerCompany()
    var
        CurrentModuleInfo: ModuleInfo;
    begin
        // Code to perform company related table upgrade tasks
        if not NavApp.GetCurrentModuleInfo(CurrentModuleInfo) then
            exit;
    end;

    trigger OnValidateUpgradePerCompany()
    begin
        // Code to make sure that upgrade was successful for each company
    end;

    #endregion OnUpgradePerCompany
}
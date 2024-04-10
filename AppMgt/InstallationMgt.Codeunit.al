codeunit 50111 "Installation Mgt. N24"
{
    Subtype = Install;

    #region OnInstallAppPerDatabase

    trigger OnInstallAppPerDatabase()
    var
        MyAppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(MyAppInfo); // Get info about the currently executing module

        if MyAppInfo.DataVersion() = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
            HandleFreshInstallPerDatabase()
        else
            HandleReinstallPerDatabase(); // If not a fresh install, then we are Re-installing the same version of the extension
    end;

    local procedure HandleFreshInstallPerDatabase()
    begin
        // Do work needed the first time this extension is ever installed for this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was installed
        // - Initial data setup for use
    end;

    local procedure HandleReinstallPerDatabase()
    begin
        // Do work needed when reinstalling the same version of this extension back on this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was reinstalled
        // - Data 'patchup' work, for example, detecting if new 'base' records have been changed while you have been working 'offline'.
        // - Setup 'welcome back' messaging for next user access.
    end;

    #endregion OnInstallAppPerDatabase

    #region OnInstallAppPerCompany

    trigger OnInstallAppPerCompany()
    var
        MyAppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(MyAppInfo); // Get info about the currently executing module

        if MyAppInfo.DataVersion() = Version.Create(0, 0, 0, 0) then // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
            HandleFreshInstallPerCompany()
        else
            HandleReinstallPerCompany(); // If not a fresh install, then we are Re-installing the same version of the extension
    end;

    local procedure HandleFreshInstallPerCompany()
    begin
        // Do work needed the first time this extension is ever installed for this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was installed
        // - Initial data setup for use
    end;

    local procedure HandleReinstallPerCompany()
    begin
        // Do work needed when reinstalling the same version of this extension back on this tenant.
        // Some possible usages:
        // - Service callback/telemetry indicating that extension was reinstalled
        // - Data 'patchup' work, for example, detecting if new 'base' records have been changed while you have been working 'offline'.
        // - Setup 'welcome back' messaging for next user access.
    end;

    #endregion OnInstallAppPerCompany
}
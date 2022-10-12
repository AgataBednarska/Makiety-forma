codeunit 50499 "App Mgt. Shared N24"
{
    #region General

    procedure AddWebService(ObjectTypeParam: Option ,,,,,Codeunit,,,Page,Query; ObjectId: Integer; WebServiceName: Text[250])
    var
        TenantWebService: Record "Tenant Web Service";
    begin
        TenantWebService.SetRange("Object Type", ObjectTypeParam);
        TenantWebService.SetRange("Object ID", ObjectId);
        TenantWebService.SetRange("Service Name", WebServiceName);

        if not TenantWebService.IsEmpty() then
            exit;

        TenantWebService.Reset();

        TenantWebService.Init();
        TenantWebService."Object Type" := ObjectTypeParam;
        TenantWebService."Object ID" := ObjectId;
        TenantWebService."Service Name" := WebServiceName;
        TenantWebService.Published := true;
        TenantWebService.Insert(true);
    end;

    #endregion General
}
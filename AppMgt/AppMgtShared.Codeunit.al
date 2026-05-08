codeunit 50113 "App Mgt. Shared N24"
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

    #region Upgrade

    procedure MoveITIGenBusPostingGroupToBC()
    var
        UpgradeTag: Codeunit "Upgrade Tag";
    begin
        if UpgradeTag.HasUpgradeTag(GetMoveITIGenBusPostingGroupToBCTag()) then
            exit;

        MoveAssemblyHeaderGenBusPostingGroup();
        MovePostedAssemblyHeaderGenBusPostingGroup();
        MoveAssemblySetupDefGenBusPostGroup();

        UpgradeTag.SetUpgradeTag(GetMoveITIGenBusPostingGroupToBCTag());
    end;

    local procedure MoveAssemblyHeaderGenBusPostingGroup()
    var
        AssemblyHeader: Record "Assembly Header";
    begin
        AssemblyHeader.SetFilter("ITI Gen. Bus. Posting Group", '<>%1', '');
        if AssemblyHeader.FindSet(true) then
            repeat
                if AssemblyHeader."Gen. Bus. Posting Group" = '' then begin
                    AssemblyHeader."Gen. Bus. Posting Group" := AssemblyHeader."ITI Gen. Bus. Posting Group";
                    AssemblyHeader.Modify();
                end;
            until AssemblyHeader.Next() = 0;
    end;

    local procedure MovePostedAssemblyHeaderGenBusPostingGroup()
    var
        PostedAssemblyHeader: Record "Posted Assembly Header";
    begin
        PostedAssemblyHeader.SetFilter("ITI Gen. Bus. Posting Group", '<>%1', '');
        if PostedAssemblyHeader.FindSet(true) then
            repeat
                if PostedAssemblyHeader."Gen. Bus. Posting Group" = '' then begin
                    PostedAssemblyHeader."Gen. Bus. Posting Group" := PostedAssemblyHeader."ITI Gen. Bus. Posting Group";
                    PostedAssemblyHeader.Modify();
                end;
            until PostedAssemblyHeader.Next() = 0;
    end;

    local procedure MoveAssemblySetupDefGenBusPostGroup()
    var
        AssemblySetup: Record "Assembly Setup";
    begin
        if not AssemblySetup.Get() then
            exit;

        if (AssemblySetup."ITI DefGenBusPostGrAssemOrder" <> '') and (AssemblySetup."Default Gen. Bus. Post. Group" = '') then begin
            AssemblySetup."Default Gen. Bus. Post. Group" := AssemblySetup."ITI DefGenBusPostGrAssemOrder";
            AssemblySetup.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", OnGetPerCompanyUpgradeTags, '', false, false)]
    local procedure RegisterPerCompanyUpgradeTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        PerCompanyUpgradeTags.Add(GetMoveITIGenBusPostingGroupToBCTag());
    end;

    local procedure GetMoveITIGenBusPostingGroupToBCTag(): Code[250]
    begin
        exit('N24-000001-MoveITIGenBusPostGroupToBC-20260401');
    end;

    #endregion Upgrade
}
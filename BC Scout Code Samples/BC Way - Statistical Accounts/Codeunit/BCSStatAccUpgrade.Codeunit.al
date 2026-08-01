codeunit 60708 "BCS Stat. Acc. Upgrade"
{
    Subtype = Upgrade;
    Access = Internal;

    trigger OnCheckPreconditionsPerCompany()
    var
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);

        // Block upgrade from versions older than 1.0.0.0
        if (AppInfo.DataVersion <> Version.Create(0, 0, 0, 0)) and
           (AppInfo.DataVersion < Version.Create(1, 0, 0, 0)) then
            Error(MinVersionRequiredErr, '1.0.0.0', Format(AppInfo.DataVersion));
    end;

    trigger OnUpgradePerCompany()
    begin
        // Add upgrade procedures here as versions evolve
        // Each procedure should be guarded by upgrade tags
        UpgradeStatAccStatementReportSelection();
    end;

    local procedure UpgradeStatAccStatementReportSelection()
    var
        UpgradeTagDef: Codeunit "BCS Stat. Acc. Upg. Tag Def.";
        UpgradeTag: Codeunit "Upgrade Tag";
        InstallCU: Codeunit "BCS Stat. Account Install";
    begin
        if UpgradeTag.HasUpgradeTag(UpgradeTagDef.GetStatAccStatementReportSelectionTag()) then
            exit;

        InstallCU.InsertDefaultStatAccStatementReportSelection();

        UpgradeTag.SetUpgradeTag(UpgradeTagDef.GetStatAccStatementReportSelectionTag());
    end;

    trigger OnValidateUpgradePerCompany()
    var
        BCSStatisticalAccountSetup: Record "BCS Statistical Account Setup";
        BCSStatAccountInstall: Codeunit "BCS Stat. Account Install";
    begin
        // Verify setup record exists after upgrade
        if not BCSStatisticalAccountSetup.Get() then
            BCSStatAccountInstall.DeployInstallationSetup();
    end;

    // Example upgrade procedure for future use
    // Uncomment and modify when you need to migrate data in a future version
    // local procedure UpgradeStatAccFieldData()
    // var
    //   UpgradeTagDef: Codeunit "BCS Stat. Acc. Upg. Tag Def.";
    //   UpgradeTag: Codeunit "Upgrade Tag";
    //   StatAccount: Record "Statistical Account";
    // begin
    //   if UpgradeTag.HasUpgradeTag(UpgradeTagDef.GetFieldMigrationTag()) then
    //     exit;
    //
    //   // Migration logic here
    //   // Example: Move data from old field to new field
    //   // StatAccount.SetLoadFields("Old Field", "New Field");
    //   // StatAccount.SetFilter("Old Field", '<>%1', '');
    //   // StatAccount.SetRange("New Field", '');
    //   // if StatAccount.FindSet() then
    //   //   repeat
    //   //     StatAccount."New Field" := StatAccount."Old Field";
    //   //     StatAccount.Modify(false);
    //   //   until StatAccount.Next() = 0;
    //
    //   UpgradeTag.SetUpgradeTag(UpgradeTagDef.GetFieldMigrationTag());
    // end;

    var
        MinVersionRequiredErr: Label 'Upgrade requires minimum version %1. Current data version is %2.', Comment = '%1 = Required version, %2 = Current version';
}

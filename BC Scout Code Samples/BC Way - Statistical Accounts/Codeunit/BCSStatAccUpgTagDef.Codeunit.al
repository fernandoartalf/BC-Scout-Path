codeunit 60709 "BCS Stat. Acc. Upg. Tag Def."
{
    Access = Internal;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", OnGetPerCompanyUpgradeTags, '', false, false)]
    local procedure OnGetPerCompanyTags(var PerCompanyUpgradeTags: List of [Code[250]])
    begin
        // Register all per-company upgrade tags here
        PerCompanyUpgradeTags.Add(GetFieldMigrationTag());
        PerCompanyUpgradeTags.Add(GetSetupUpgradeTag());
        PerCompanyUpgradeTags.Add(GetStatAccStatementReportSelectionTag());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Upgrade Tag", OnGetPerDatabaseUpgradeTags, '', false, false)]
    local procedure OnGetPerDatabaseTags(var PerDatabaseUpgradeTags: List of [Code[250]])
    begin
        // Register all per-database upgrade tags here if needed
    end;

    // Example upgrade tag - uncomment and modify when you need it
    procedure GetFieldMigrationTag(): Code[250]
    begin
        exit('BCS-60705-StatAccFieldMigration-20260329');
    end;

    // Example setup upgrade tag
    procedure GetSetupUpgradeTag(): Code[250]
    begin
        exit('BCS-60705-StatAccSetupUpgrade-20260329');
    end;

    procedure GetStatAccStatementReportSelectionTag(): Code[250]
    begin
        exit('BCS-60712-StatAccStatementReportSelection-20260731');
    end;
}

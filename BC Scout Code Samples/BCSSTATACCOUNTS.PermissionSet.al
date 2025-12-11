permissionset 60700 "BCS STATACCOUNTS"
{
    Assignable = true;
    Permissions = tabledata "BCS Statistical Account Setup" = RIMD,
        table "BCS Statistical Account Setup" = X,
        codeunit "BCS Attachment Management" = X,
        codeunit "DVC Stat. Acc. Journal Mgmt" = X,
        codeunit "DVC Stat. Acc.Setup Management" = X,
        page "BCS DVC Stat. Acc. Journal API" = X,
        page "BCS DVC Stat. Ledger Entry API" = X,
        page "BCS StaT. Acc.Setup Wizard" = X,
        page "BCS Statistic Account API" = X,
        page "BCS Statistical Account Setup" = X;
}
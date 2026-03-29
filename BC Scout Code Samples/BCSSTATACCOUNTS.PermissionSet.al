permissionset 60700 "BCS STATACCOUNTS"
{
    Assignable = true;
    Permissions = tabledata "BCS Statistical Account Setup" = RIMD,
        table "BCS Statistical Account Setup" = X,
        codeunit "BCS Attachment Management" = X,
        page "BCS StaT. Acc.Setup Wizard" = X,
        page "BCS Statistic Account API" = X,
        page "BCS Statistical Account Setup" = X,
        codeunit "BCS Stat. Acc. Journal Mgmt" = X,
        codeunit "BCS Stat. Acc.Setup Management" = X,
        page "BCS Stat. Acc. Journal API" = X,
        page "BCS Stat. Ledger Entry API" = X,
        query "BCS Stat. Ledger Entry API" = X;
}
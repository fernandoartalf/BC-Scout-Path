namespace BCSSTATACCOUNTS;

permissionset 50700 "BCS STA PermSet"
{
    Assignable = true;
    Permissions = tabledata "BCS Statistical Account Setup" = RIMD,
        table "BCS Statistical Account Setup" = X,
        codeunit "BCS Attachment Management" = X,
        codeunit "BCS Stat. Account Install" = X,
        page "BCS Statistical Account Setup" = X;
}
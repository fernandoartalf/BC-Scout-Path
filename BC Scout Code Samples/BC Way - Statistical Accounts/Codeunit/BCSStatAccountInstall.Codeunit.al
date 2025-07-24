codeunit 50701 "BCS Stat. Account Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        StatisticalAccountModuleInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(StatisticalAccountModuleInfo);
        if IsFirstTimeDeployment(StatisticalAccountModuleInfo) and IsSandboxEnvironment() then
            DeployInstallationSetup();
    end;

    local procedure DeployInstallationSetup()
    begin
        InitialiseStatisticalAccountSetup();
        SetStatisticalAccountDefaultSeriesNo(SetStatisticalAccountSeriesNo());
    end;

    local procedure InitialiseStatisticalAccountSetup()
    var

    begin
        BCSStatisticalAccountSetup.Reset();
        if not BCSStatisticalAccountSetup.Get() then begin
            BCSStatisticalAccountSetup.Init();
            BCSStatisticalAccountSetup.Insert();
        end;
    end;

    local procedure SetStatisticalAccountSeriesNo(): Code[20]
    var
        NoSeries: Record "No. Series";
        DefaultSeriesNoCode: Code[20];
        SeriesPrefixTxt: TextConst ENU = 'STA';
    begin
        DefaultSeriesNoCode := CopyStr(SeriesPrefixTxt, 1, MaxStrLen(DefaultSeriesNoCode));
        if not NoSeries.Get(DefaultSeriesNoCode) then begin
            InitStatisticalAccountSeries(NoSeries, DefaultSeriesNoCode);
            InitStatisticalAccountSeriesLine(DefaultSeriesNoCode);
        end;
        exit(DefaultSeriesNoCode);
    end;

    local procedure SetStatisticalAccountDefaultSeriesNo(SeriesNO: Code[20])
    begin
        BCSStatisticalAccountSetup.Reset();
        if BCSStatisticalAccountSetup.Get() then begin
            BCSStatisticalAccountSetup."Statistical Account Nos." := SeriesNO;
            BCSStatisticalAccountSetup.Modify();
        end;
    end;

    local procedure InitStatisticalAccountSeriesLine(DefaultSeriesNoCode: Code[20])
    var
        NoSeriesLines: Record "No. Series Line";
    begin
        NoSeriesLines.SetRange("Series Code", DefaultSeriesNoCode);
        if NoSeriesLines.IsEmpty then begin
            NoSeriesLines.Reset();
            NoSeriesLines.Init();
            NoSeriesLines."Series Code" := DefaultSeriesNoCode;
            NoSeriesLines."Line No." := 10000;
            NoSeriesLines."Starting No." := CopyStr(DefaultSeriesNoCode + '0000001', 1, MaxStrLen(NoSeriesLines."Starting No."));
            NoSeriesLines."Ending No." := CopyStr(DefaultSeriesNoCode + '9999999', 1, MaxStrLen(NoSeriesLines."Starting No."));
            NoSeriesLines."Increment-by No." := 1;
            NoSeriesLines.Insert();
        end;
    end;

    local procedure InitStatisticalAccountSeries(var NoSeries: Record "No. Series"; DefaultSeriesNoCode: Code[20])
    begin
        NoSeries.Init();
        NoSeries."Code" := DefaultSeriesNoCode;
        NoSeries."Description" := 'Statistical Account Nos.';
        NoSeries."Default Nos." := true;
        NoSeries.Insert();
    end;
    // TODO:Use SandboxEnvironment to check if the environment is a sandbox to deploy sample data.
    procedure IsSandboxEnvironment() IsSandbox: Boolean
    var
        EnvironmentInformation: Codeunit "Environment Information";
    begin
        if EnvironmentInformation.IsSandbox() then
            IsSandbox := true;
    end;

    // Check if this is the first time the module is being deployed.
    local procedure IsFirstTimeDeployment(var StatisticalAccountModuleInfo: ModuleInfo): Boolean
    begin
        if StatisticalAccountModuleInfo.DataVersion = Version.Create(0, 0, 0, 0) then
            exit(true);
    end;

    var
        BCSStatisticalAccountSetup: Record "BCS Statistical Account Setup";
}

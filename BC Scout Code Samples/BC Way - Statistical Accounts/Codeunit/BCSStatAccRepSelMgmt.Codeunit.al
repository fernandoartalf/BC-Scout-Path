codeunit 60712 "BCS Stat. Acc. Rep. Sel. Mgmt."
{
    // Pattern reference: codeunit 77 "Report Selections".
    // Only integration point between business actions and Report Selections
    // for the Statistical Account Statement usage. Business code must NEVER
    // call Report.RunModal with a hardcoded report ID.
    Access = Public;

    var
        NoReportSelectedErr: Label 'No report is configured for %1. Set up the report in the Statistical Account Report Selection page.', Comment = '%1 = usage caption';
        UsageCaptionLbl: Label 'Statistical Account Statement';

    /// <summary>
    /// Prints every report configured for the Statistical Account
    /// Statement usage, in Sequence order, filtered by the supplied
    /// Statistical Account record. The request page is displayed.
    /// </summary>
    procedure PrintStatement(var StatisticalAccount: Record "Statistical Account")
    begin
        RunConfiguredReports(StatisticalAccount, true);
    end;

    /// <summary>
    /// Prints every report configured for the Statistical Account
    /// Statement usage, in Sequence order, filtered by the supplied
    /// Statistical Account record. The request page is skipped.
    /// </summary>
    procedure PrintStatementSilently(var StatisticalAccount: Record "Statistical Account")
    begin
        RunConfiguredReports(StatisticalAccount, false);
    end;

    /// <summary>
    /// Returns the first configured Report ID for the Statistical Account
    /// Statement usage, or 0 if none is configured.
    /// </summary>
    procedure GetDefaultReportId(): Integer
    var
        ReportSelection: Record "Report Selections";
    begin
        ReportSelection.SetRange(Usage, ReportSelection.Usage::"BCS Stat. Account Statement");
        ReportSelection.SetFilter("Report ID", '<>0');
        ReportSelection.SetCurrentKey(Sequence);
        if ReportSelection.FindFirst() then
            exit(ReportSelection."Report ID");

        exit(0);
    end;

    local procedure RunConfiguredReports(var StatisticalAccount: Record "Statistical Account"; ShowRequestPage: Boolean)
    var
        ReportSelection: Record "Report Selections";
    begin
        ReportSelection.Reset();
        ReportSelection.SetRange(Usage, ReportSelection.Usage::"BCS Stat. Account Statement");
        ReportSelection.SetFilter("Report ID", '<>0');
        ReportSelection.SetCurrentKey(Sequence);
        if not ReportSelection.FindSet() then
            Error(NoReportSelectedErr, UsageCaptionLbl);

        repeat
            Report.RunModal(
                ReportSelection."Report ID", ShowRequestPage, false, StatisticalAccount);
        until ReportSelection.Next() = 0;
    end;
}

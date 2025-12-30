codeunit 60702 "BCS Stat. Acc. Journal Mgmt"
{
    TableNo = "Statistical Acc. Journal Line";

    trigger OnRun()
    begin
        InitStatisticalAccountSetup();
        NewStatisticalAccJournalLine := Rec;
        CommitStatisticalAccJournalLine(NewStatisticalAccJournalLine);
        PostAPIStatisticalAccJournal(NewStatisticalAccJournalLine);
    end;

    local procedure InitStatisticalAccountSetup()
    begin
        BCSStatisticalAccountSetup.Get();
        BCSStatisticalAccountSetup.TestField("Default API Journal Temp. Name");
        BCSStatisticalAccountSetup.TestField("Default API Journal Name");
        BCSStatisticalAccountSetup.TestField("Default API Document No.");
    end;

    local procedure CommitStatisticalAccJournalLine(var StatisticalAccJournalLine: Record "Statistical Acc. Journal Line")
    begin
        if StatisticalAccJournalLine."Journal Template Name" = '' then
            StatisticalAccJournalLine."Journal Template Name" := BCSStatisticalAccountSetup."Default API Journal Temp. Name";
        if StatisticalAccJournalLine."Journal Batch Name" = '' then
            StatisticalAccJournalLine."Journal Batch Name" := BCSStatisticalAccountSetup."Default API Journal Name";
        if StatisticalAccJournalLine."Document No." = '' then
            StatisticalAccJournalLine."Document No." := NoSeries.GetNextNo(BCSStatisticalAccountSetup."Default API Document No.");
        if StatisticalAccJournalLine."Line No." = 0 then
            StatisticalAccJournalLine."Line No." := GetNextStatisticalAccJournalLine(StatisticalAccJournalLine."Journal Template Name", StatisticalAccJournalLine."Journal Batch Name");
        StatisticalAccJournalLine.Insert();
        Commit();
    end;

    local procedure GetNextStatisticalAccJournalLine(JournalTemplateName: code[10]; JournalBatchName: code[10]): Integer
    var
        LastStatisticalAccJournalLine: Record "Statistical Acc. Journal Line";
    begin
        LastStatisticalAccJournalLine.Reset();
        LastStatisticalAccJournalLine.SetRange("Journal Template Name", JournalTemplateName);
        LastStatisticalAccJournalLine.SetRange("Journal Batch Name", JournalBatchName);
        if LastStatisticalAccJournalLine.FindLast() then
            exit(LastStatisticalAccJournalLine."Line No." + 10000)
        else
            exit(10000);
    end;

    procedure PostAPIStatisticalAccJournal(var StatisticalAccJournalLine: Record "Statistical Acc. Journal Line"): Boolean
    begin
        if not BCSStatisticalAccountSetup."Allow API Journal Posting" then
            exit(false)
        else
            exit(Codeunit.Run(Codeunit::"Stat. Acc. Post. Batch", StatisticalAccJournalLine));
    end;

    var
        BCSStatisticalAccountSetup: Record "BCS Statistical Account Setup";
        NewStatisticalAccJournalLine: Record "Statistical Acc. Journal Line";
        NoSeries: Codeunit "No. Series";

}

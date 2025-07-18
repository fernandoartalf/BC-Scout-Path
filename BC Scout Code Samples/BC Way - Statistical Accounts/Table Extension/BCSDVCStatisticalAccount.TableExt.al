tableextension 50700 "BCS DVC Statistical Account" extends "Statistical Account"
{
    fields
    {
        field(50700; "BCS No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
    trigger OnBeforeInsert()
    begin
        if "No." = '' then begin
            BCSStatisticalAccountSetup.Get();
            BCSStatisticalAccountSetup.TestField("Statistical Account Nos.");
            if NoSeries.AreRelated(BCSStatisticalAccountSetup."Statistical Account Nos.", xRec."BCS No. Series") then
                "BCS No. Series" := xRec."BCS No. Series"
            else
                "BCS No. Series" := BCSStatisticalAccountSetup."Statistical Account Nos.";
            "No." := NoSeries.GetNextNo("BCS No. Series");
        end;
    end;

    procedure AssistEdit(): Boolean
    begin
        if not BCSStatisticalAccountSetup.Get() then
            exit(false);
        if NoSeries.LookupRelatedNoSeries(BCSStatisticalAccountSetup."Statistical Account Nos.", xRec."BCS No. Series", "BCS No. Series") then
            "No." := NoSeries.GetNextNo("BCS No. Series");
    end;

    var
        BCSStatisticalAccountSetup: Record "BCS Statistical Account Setup";
        NoSeries: Codeunit "No. Series";
}

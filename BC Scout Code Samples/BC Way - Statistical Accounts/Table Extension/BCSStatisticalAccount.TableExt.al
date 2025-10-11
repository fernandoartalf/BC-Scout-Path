tableextension 60700 "BCS Statistical Account" extends "Statistical Account"
{
    fields
    {
        field(60700; "BCS No. Series"; Code[20])
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

    trigger OnBeforeRename()
    begin
        if "No." = '' then begin
            BCSStatisticalAccountSetup.Get();
            BCSStatisticalAccountSetup.TestField("Statistical Account Nos.");
            if NoSeries.AreRelated(BCSStatisticalAccountSetup."Statistical Account Nos.", Rec."BCS No. Series") then
                "BCS No. Series" := Rec."BCS No. Series"
            else
                "BCS No. Series" := BCSStatisticalAccountSetup."Statistical Account Nos.";
            "No." := NoSeries.GetNextNo("BCS No. Series");
        end;
        RenameAttachments();
    end;

    trigger OnBeforeDelete()
    begin
        BCSAttachmentManagement.DeleteRelatedDocumentAttachments(Rec."No.");
    end;

    procedure AssistEdit(): Boolean
    begin
        if not BCSStatisticalAccountSetup.Get() then
            exit(false);
        if NoSeries.LookupRelatedNoSeries(BCSStatisticalAccountSetup."Statistical Account Nos.", xRec."BCS No. Series", "BCS No. Series") then
            "No." := NoSeries.GetNextNo("BCS No. Series");
    end;

    local procedure RenameAttachments()
    begin
        BCSAttachmentManagement.CopyRelatedDocumentAttachments(xRec."No.", "No.");
        BCSAttachmentManagement.DeleteRelatedDocumentAttachments(xRec."No.");
    end;

    var
        BCSStatisticalAccountSetup: Record "BCS Statistical Account Setup";
        NoSeries: Codeunit "No. Series";
        BCSAttachmentManagement: Codeunit "BCS Attachment Management";
}

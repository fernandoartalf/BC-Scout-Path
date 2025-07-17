codeunit 50700 "BCS Attachment Management"
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);

    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Statistical Account":
                begin
                    RecRef.Open(DATABASE::"Statistical Account");
                    if StatisticalAccount.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(StatisticalAccount);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Statistical Account":
                begin
                    FieldRef := RecRef.Field(StatisticalAccount.FieldNo("No."));
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                    DocumentAttachment.SetRange("Document Type", DocumentAttachment."Document Type"::BCSStatisticalAccount);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Statistical Account":
                begin
                    FieldRef := RecRef.Field(StatisticalAccount.FieldNo("No."));
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                    DocumentAttachment.Validate("Document Type", DocumentAttachment."Document Type"::BCSStatisticalAccount);
                end;
        end;
    end;

    procedure EntityEnabledAttachments(TableId: Integer): Boolean
    begin
        case TableId of
            DATABASE::"Statistical Account":
                begin
                    if BCSStatisticalAccountSetup.Get() then
                        exit(BCSStatisticalAccountSetup."Enable Attachments");
                    exit(false);
                end;
            else
                exit(false);
        end;
    end;

    procedure EntityEnabledLinks(TableId: Integer): Boolean
    begin
        case TableId of
            DATABASE::"Statistical Account":
                begin
                    if BCSStatisticalAccountSetup.Get() then
                        exit(BCSStatisticalAccountSetup."Enable links");
                    exit(false);
                end;
            else
                exit(false);
        end;
    end;

    procedure EntityEnabledNotes(TableId: Integer): Boolean
    begin
        case TableId of
            DATABASE::"Statistical Account":
                begin
                    if BCSStatisticalAccountSetup.Get() then
                        exit(BCSStatisticalAccountSetup."Enable Notes");
                    exit(false);
                end;
            else
                exit(false);
        end;
    end;

    var
        StatisticalAccount: Record "Statistical Account";
        BCSStatisticalAccountSetup: Record "BCS Statistical Account Setup";
}

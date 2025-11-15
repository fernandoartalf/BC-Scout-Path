page 60703 "BCS DVC Stat. Acc. Journal API"
{
    APIGroup = 'statisticAccounts';
    APIPublisher = 'businessCentralScout';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'dvcStatAccJournalAPI';
    DelayedInsert = true;
    EntityName = 'statisticalAccJournalLine';
    EntitySetName = 'statisticalAccJournalLines';
    PageType = API;
    SourceTable = "Statistical Acc. Journal Line";
    ODataKeyFields = SystemId;
    SourceTableTemporary = true;
    AboutText = 'Manages Statistical Account Journal.Supports CRUD operations for creating Statistical lines records and post it on the entry. Ideal to register Statistical Account historical data, the required fields to be informed before posting are statisticalAccountNo, postingDate and amount, the other fields are optional.';
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(journalTemplateName; Rec."Journal Template Name")
                {
                    Caption = 'Journal Template Name';
                }
                field(journalBatchName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal batch name';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(statisticalAccountNo; Rec."Statistical Account No.")
                {
                    Caption = 'Statistical Account No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Codeunit.Run(Codeunit::"DVC Stat. Acc. Journal Mgmt", Rec);
        exit(false);
    end;
}

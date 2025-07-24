page 50700 "BCS Statistical Account Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Statistical Account Setup';
    PageType = Card;
    SourceTable = "BCS Statistical Account Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = Administration;
    // This page is used to configure the Statistical Accounts Business Logic.
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Enable Attachments"; Rec."Enable Attachments")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enable Attachments on Statistical Accounts field.', Comment = '%';
                }
                field("Enable Links"; Rec."Enable Links")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enable Links on Statistical Accounts field.', Comment = '%';
                }
                field("Enable Notes"; Rec."Enable Notes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Enable Notes on Statistical Accounts field.', Comment = '%';
                }
            }
            group("Number Series")
            {
                Caption = 'Number Series';
                field("Statistical Account Nos."; Rec."Statistical Account Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series used for Statistical Accounts.', Comment = '%';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DownloadJson)
            {
                ApplicationArea = All;
                Caption = 'Download JSON';
                Image = Download;
                ToolTip = 'Download the Statistical Accounts as a JSON file.';
                trigger OnAction()
                var
                    StatisticalAccount: Record "Statistical Account";
                    BCSDownloadJson: Codeunit "BCS Download Json";
                begin
                    if StatisticalAccount.FindFirst() then
                        BCSDownloadJson.DownloadJson(StatisticalAccount);
                end;
            }
            action(DeployDemoData)
            {
                ApplicationArea = All;
                Caption = 'Deploy Demo Data';
                Image = Import;
                ToolTip = 'Deploy the Statistical Accounts demo data.';
                trigger OnAction()
                var
                    BCSDemoDataDeployment: Codeunit "BCS Demo Data Deployment";
                begin

                    BCSDemoDataDeployment.InternalJsonList();
                    Message('Statistical Accounts demo data deployed successfully.');
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}

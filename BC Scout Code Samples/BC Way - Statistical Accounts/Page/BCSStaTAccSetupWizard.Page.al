page 60701 "BCS StaT. Acc.Setup Wizard"
{
    ApplicationArea = All;
    Caption = '✨Statistical Account Setup Wizard✨';
    PageType = NavigatePage;
    SourceTable = "BCS Statistical Account Setup";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            Group(SetupWIPBanner)
            {
                Caption = '';
                Editable = false;
                Visible = (not FinishActionEnabled) and BannersVisible;
                field(MediaRepositoryWIPField; MediaResourcesWIP."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(SetupFinishedBanner)
            {
                Caption = '';
                Editable = false;
                Visible = FinishActionEnabled and BannersVisible;
                field(MediaRepositoryFinishedField; MediaResourcesFinished."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Step10)
            {
                Visible = Step10Visible;
                group(S11)
                {
                    Caption = '🛠️Welcome to the Statistical Account Setup Wizard🛠️';
                    InstructionalText = 'This wizard will guide you through the setup process for Statistical Accounts 🚀. 👉 Please follow the steps to configure the necessary settings.';
                }
                group(S12)
                {
                    ShowCaption = false;
                    InstructionalText = 'Choose Next when you are ready to start setting the module 👇 (It will be quick and painless😉.). ';
                }
            }
            group(Step20)
            {
                Visible = Step20Visible;
                group(S21)
                {
                    Caption = 'Attachments Settings 📎(Step 1/3)';
                    field("Enable Attachments"; Rec."Enable Attachments")
                    {
                        ApplicationArea = All;
                        Caption = 'Enable Attachments on Statistical Accounts';
                        ToolTip = 'Specifies whether attachments are enabled on Statistical Accounts.';
                    }
                    field("Enable Links"; Rec."Enable Links")
                    {
                        ApplicationArea = All;
                        Caption = 'Enable Links on Statistical Accounts';
                        ToolTip = 'Specifies whether links are enabled on Statistical Accounts.';
                    }
                    field("Enable Notes"; Rec."Enable Notes")
                    {
                        ApplicationArea = All;
                        Caption = 'Enable Notes on Statistical Accounts';
                        ToolTip = 'Specifies whether notes are enabled on Statistical Accounts.';
                    }
                }
            }
            group(Step30)
            {
                Visible = Step30Visible;

                group(S31)
                {
                    Caption = 'Number Series Setup 🆔 (Step 2/3)';
                    field("Statistical Account Nos."; Rec."Statistical Account Nos.")
                    {
                        ApplicationArea = All;
                        Caption = 'Statistical Account Nos.';
                        ToolTip = 'Specifies the number series used for Statistical Accounts.';
                    }
                }
            }
            group(Step40)
            {
                Visible = Step40Visible;

                group(S41)
                {
                    Caption = 'Review & Finish 🧐 (Step 3/3)';
                    InstructionalText = '🎉Congratulations!🎉 You have survived the setup for Statistical Accounts! 😎 Please review your settings below and click Finish to save your configuration. If you need to make any changes, use the Back👈 button to navigate to the previous steps.';
                }
                group(S42)
                {
                    Caption = 'Attachments Settings 📎';
                    Editable = false;
                    field("Enable Attachments Review"; Rec."Enable Attachments")
                    {
                        ApplicationArea = All;
                        Caption = 'Enable Attachments on Statistical Accounts';
                        ToolTip = 'Specifies whether attachments are enabled on Statistical Accounts.';
                    }
                    field("Enable Links Review"; Rec."Enable Links")
                    {
                        ApplicationArea = All;
                        Caption = 'Enable Links on Statistical Accounts';
                        ToolTip = 'Specifies whether links are enabled on Statistical Accounts.';
                    }
                    field("Enable Notes Review"; Rec."Enable Notes")
                    {
                        ApplicationArea = All;
                        Caption = 'Enable Notes on Statistical Accounts';
                        ToolTip = 'Specifies whether notes are enabled on Statistical Accounts.';
                    }
                }
                group(S43)
                {
                    Caption = 'Number Series Setup 🆔';
                    Editable = false;
                    field("Statistical Account Nos Review"; Rec."Statistical Account Nos.")
                    {
                        ApplicationArea = All;
                        Caption = 'Statistical Account Nos.';
                        ToolTip = 'Specifies the number series used for Statistical Accounts.';
                    }

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                ApplicationArea = all;
                Caption = 'Back👈';
                Enabled = BackActionEnabled;
                Image = PreviousRecord;
                InFooterBar = true;
                trigger OnAction()
                begin
                    NextStep(true);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = all;
                Caption = 'Next👉';
                Enabled = NextActionEnabled;
                Image = NextRecord;
                InFooterBar = true;
                trigger OnAction()
                begin
                    NextStep(false);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = all;
                Caption = '✨Finish✨';
                Enabled = FinishActionEnabled;
                Image = Approve;
                InFooterBar = true;
                trigger OnAction()
                begin
                    FinishAction();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        InitStatisticalAccountSetup();
        EnableControls();
        LoadSetupBanner();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ExitDeleteTxt: Label 'The changes will be lost☠️. Do you want to exit?🙁💔';
    begin
        if FinishedProcess then begin
            CommitStatisticalAccountSetup();
            GuidedExperience.CompleteAssistedSetup(ObjectType::Page, Page::"BCS StaT. Acc.Setup Wizard");
        end else
            if GuiAllowed and not (Confirm(ExitDeleteTxt)) then
                Error('')
    end;

    local procedure ResetControls()
    begin
        FinishActionEnabled := false;
        BackActionEnabled := true;
        NextActionEnabled := true;

        Step10Visible := false;
        Step20Visible := false;
        Step30Visible := false;
        Step40Visible := false;
    end;

    local procedure NextStep(Backwards: Boolean)
    begin
        if Backwards then
            Step := Step - 1
        ELSE
            Step := Step + 1;

        EnableControls();
    end;

    local procedure EnableControls()
    begin
        ResetControls();

        Case Step of
            Step::Step10:
                SetControlsStep10();
            Step::Step20:
                SetControlsStep20();
            Step::Step30:
                SetControlsStep30();
            Step::Step40:
                SetControlsStep40();
        end;
    end;

    local procedure SetControlsStep10()
    begin
        Step10Visible := true;
        FinishActionEnabled := false;
        BackActionEnabled := false;
    end;

    local procedure SetControlsStep20()
    begin
        Step20Visible := true;
    end;

    local procedure SetControlsStep30()
    begin
        Step30Visible := true;
    end;

    local procedure SetControlsStep40()
    begin
        Step40Visible := true;
        NextActionEnabled := false;
        FinishActionEnabled := true;
    end;

    local procedure FinishAction()
    begin
        FinishedProcess := true;
        CurrPage.Close();
    end;

    local procedure CommitStatisticalAccountSetup()
    begin
        BCSStatisticalAccountSetup.Reset();
        if not BCSStatisticalAccountSetup.Get() then begin
            BCSStatisticalAccountSetup.Init();
            BCSStatisticalAccountSetup.TransferFields(Rec, false);
            BCSStatisticalAccountSetup.Insert();
        end else begin
            BCSStatisticalAccountSetup.TransferFields(Rec, false);
            BCSStatisticalAccountSetup.Modify(true);
        end;
    end;

    local procedure InitStatisticalAccountSetup()
    begin
        BCSStatisticalAccountSetup.Reset();
        if not BCSStatisticalAccountSetup.Get() then begin
            Rec.Init();
            Rec.Insert();
        end else begin
            Rec.Init();
            Rec.TransferFields(BCSStatisticalAccountSetup, false);
            Rec.Insert();
        end;
    end;

    local procedure LoadSetupBanner();
    begin
        if MediaRepositoryWIP.get('AssistedSetup-NoText-400px.png', FORMAT(CurrentClientType())) and
           MediaRepositoryFinished.get('AssistedSetupDone-NoText-400px.png', FORMAT(CurrentClientType()))
        then
            if MediaResourcesWIP.get(MediaRepositoryWIP."Media Resources Ref") and
               MediaResourcesFinished.get(MediaRepositoryFinished."Media Resources Ref")
            then
                BannersVisible := MediaResourcesFinished."Media Reference".HasValue();
    end;

    var
        BCSStatisticalAccountSetup: Record "BCS Statistical Account Setup";
        MediaRepositoryFinished: Record "Media Repository";
        MediaRepositoryWIP: Record "Media Repository";
        MediaResourcesFinished: Record "Media Resources";
        MediaResourcesWIP: Record "Media Resources";
        GuidedExperience: Codeunit "Guided Experience";
        Step10Visible: Boolean;
        Step20Visible: Boolean;
        Step30Visible: Boolean;
        Step40Visible: Boolean;
        BackActionEnabled: Boolean;
        NextActionEnabled: Boolean;
        FinishActionEnabled: Boolean;
        FinishedProcess: Boolean;
        BannersVisible: Boolean;
        Step: Option Step10,Step20,Step30,Step40;
}

page 60700 "BCS Statistical Account Setup"
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
                field("Default API Journal Temp. Name"; Rec."Default API Journal Temp. Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default API Journal Template Name for Statistical Accounts.', Comment = '%';
                }
                field("Default API Journal Name"; Rec."Default API Journal Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default API Journal Name for Statistical Accounts.', Comment = '%';
                }
                field("Default API Document No."; Rec."Default API Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default API Document No. Series for Statistical Accounts.', Comment = '%';
                }
                field("Allow API Journal Posting"; Rec."Allow API Journal Posting")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether to allow direct posting of Statistical Account journals via the API.', Comment = '%';
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
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}

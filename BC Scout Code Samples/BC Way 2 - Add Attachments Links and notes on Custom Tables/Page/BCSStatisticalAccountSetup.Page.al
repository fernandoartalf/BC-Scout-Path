page 50700 "BCS Statistical Account Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Statistical Account Setup';
    PageType = Card;
    SourceTable = "BCS Statistical Account Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = Administration;

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

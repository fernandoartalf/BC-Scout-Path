pageextension 50700 "BCS Statistical Account Card" extends "Statistical Account Card"
{
    // This page extension is used to extend the current functionality of the Statistical Account Card page.
    layout
    {
        modify("No.")
        {
            trigger OnAssistEdit()
            begin
                if Rec.AssistEdit() then
                    CurrPage.Update();
            end;
        }
        addfirst(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                ToolTip = 'View and manage attachments related to this statistical account.';
                ObsoleteTag = '25.0';
                ObsoleteState = Pending;
                ObsoleteReason = 'The "Document Attachment FactBox" has been replaced by "Doc. Attachment List Factbox", which supports multiple files upload.';
                SubPageLink = "Table ID" = const(Database::"Statistical Account"),
                              "No." = field("No."),
                              "Document Type" = const(BCSStatisticalAccount);
                Visible = false;
                Editable = enabledattachments;
            }
            part("Attached Documents List"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Documents';
                UpdatePropagation = Both;
                SubPageLink = "Table ID" = const(Database::"Statistical Account"),
                              "No." = field("No.");
                Visible = enabledattachments;
                Editable = enabledattachments;
            }
        }
        modify(Control1900383207)
        {
            Visible = enablelinks;
        }
        modify(Control1905767507)
        {
            Visible = enablenotes;
        }
    }
    trigger OnOpenPage()
    begin
        enabledattachments := BCSAttachmentManagement.EntityEnabledAttachments(DATABASE::"Statistical Account");
        enablelinks := BCSAttachmentManagement.EntityEnabledLinks(DATABASE::"Statistical Account");
        enablenotes := BCSAttachmentManagement.EntityEnabledNotes(DATABASE::"Statistical Account");
    end;

    var
        BCSAttachmentManagement: Codeunit "BCS Attachment Management";
        enabledattachments: Boolean;
        enablelinks: Boolean;
        enablenotes: Boolean;

}

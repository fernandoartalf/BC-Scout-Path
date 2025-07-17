pageextension 50700 "BCS Statistical Account Card" extends "Statistical Account Card"
{
    LinksAllowed = true;
    layout
    {
        addfirst(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                ToolTip = 'View and manage attachments related to this statistical account.';
                SubPageLink = "Table ID" = const(Database::"Statistical Account"),
                              "No." = field("No."),
                              "Document Type" = const(BCSStatisticalAccount);
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

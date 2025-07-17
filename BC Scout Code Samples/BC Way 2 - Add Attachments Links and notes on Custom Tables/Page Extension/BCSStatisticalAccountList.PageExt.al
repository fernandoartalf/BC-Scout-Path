pageextension 50701 "BCS Statistical Account List" extends "Statistical Account List"
{
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
    }
    trigger OnOpenPage()
    begin
        enabledattachments := BCSAttachmentManagement.EntityEnabledAttachments(DATABASE::"Statistical Account");
    end;

    var
        BCSAttachmentManagement: Codeunit "BCS Attachment Management";
        enabledattachments: Boolean;

}

pageextension 60700 "BCS Statistical Account Card" extends "Statistical Account Card"
{
    // This page extension is used to extend the current functionality of the Statistical Account Card page.
    layout
    {
        modify(General)
        {
            Editable = GPageEditable;
        }
        modify("No.")
        {
            trigger OnAssistEdit()
            begin
                if Rec.AssistEdit() then
                    CurrPage.Update();
            end;
        }
        addafter("No.")
        {
            field("BCS Approval Status"; Rec."BCS Approval Status")
            {
                ApplicationArea = All;
                Caption = 'Approval Status';
                Editable = false;
                StyleExpr = BCSApprovalStatusStyleTxt;
                ToolTip = 'Specifies the approval status of the Statistical Account.';
            }
        }
        addfirst(factboxes)
        {
            // part("Attached Documents"; "Document Attachment Factbox")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Attachments';
            //     ObsoleteTag = '25.0';
            //     ObsoleteState = Pending;
            //     ObsoleteReason = 'The "Document Attachment FactBox" has been replaced by "Doc. Attachment List Factbox", which supports multiple files upload.';
            //     SubPageLink = "Table ID" = const(Database::"Statistical Account"),
            //                   "No." = field("No."),
            //                   "Document Type" = const(BCSStatisticalAccount);
            //     Visible = false;
            //     Editable = enabledattachments;
            // }
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
    actions
    {
        addlast(processing)
        {
            group("BCS BCSApproval")
            {
                Caption = 'Approval';
                Image = Approval;

                action("BCS BCS_SendApprovalRequest")
                {
                    ApplicationArea = All;
                    Caption = 'Send Approval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Send an approval request for this Statistical Account.';

                    trigger OnAction()
                    var
                        BCSApprovalMgmt: Codeunit "BCS Stat. Acc. Approval Mgmt.";
                    begin
                        if BCSApprovalMgmt.CheckStatAccApprovalPossible(Rec) then
                            BCSApprovalMgmt.OnSendStatAccForApproval(Rec);
                        CurrPage.Update(false);
                    end;
                }

                action("BCS BCS_CancelApprovalRequest")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Approval Request';
                    Enabled = CanCancelApprovalForRecord or CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Cancel the approval request for this Statistical Account.';

                    trigger OnAction()
                    var
                        BCSApprovalMgmt: Codeunit "BCS Stat. Acc. Approval Mgmt.";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        BCSApprovalMgmt.OnCancelStatAccApprovalRequest(Rec);
                        WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OpenApprovalEntriesExist :=
            ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord :=
            ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(
            Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);

        BCSSetApprovalStatusStyle();
        GPageEditable := Rec."BCS Approval Status" <> Rec."BCS Approval Status"::Approved;
    end;

    trigger OnOpenPage()
    begin
        enabledattachments := BCSAttachmentManagement.EntityEnabledAttachments(DATABASE::"Statistical Account");
        enablelinks := BCSAttachmentManagement.EntityEnabledLinks(DATABASE::"Statistical Account");
        enablenotes := BCSAttachmentManagement.EntityEnabledNotes(DATABASE::"Statistical Account");
    end;

    local procedure BCSSetApprovalStatusStyle()
    begin
        case Rec."BCS Approval Status" of
            Rec."BCS Approval Status"::Open:
                BCSApprovalStatusStyleTxt := 'Standard';
            Rec."BCS Approval Status"::"Pending Approval":
                BCSApprovalStatusStyleTxt := 'Ambiguous';
            Rec."BCS Approval Status"::Approved:
                BCSApprovalStatusStyleTxt := 'Favorable';
            Rec."BCS Approval Status"::Rejected:
                BCSApprovalStatusStyleTxt := 'Unfavorable';
        end;
    end;

    var
        BCSAttachmentManagement: Codeunit "BCS Attachment Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        enabledattachments: Boolean;
        enablelinks: Boolean;
        enablenotes: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        BCSApprovalStatusStyleTxt: Text;
        GPageEditable: Boolean;

}

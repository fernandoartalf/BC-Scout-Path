codeunit 60710 "BCS Stat. Acc. Approval Mgmt."
{
    // ═══════════════════════════════════════════════════════════════════════════
    // INTEGRATION EVENTS (Publishers)
    // ═══════════════════════════════════════════════════════════════════════════

    [IntegrationEvent(false, false)]
    procedure OnSendStatAccForApproval(var StatisticalAccount: Record "Statistical Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelStatAccApprovalRequest(var StatisticalAccount: Record "Statistical Account")
    begin
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // VALIDATION
    // ═══════════════════════════════════════════════════════════════════════════

    procedure CheckStatAccApprovalPossible(var StatisticalAccount: Record "Statistical Account"): Boolean
    begin
        if not IsStatAccApprovalWorkflowEnabled(StatisticalAccount) then
            Error(NoWorkflowEnabledErr);

        exit(true);
    end;

    procedure IsStatAccApprovalWorkflowEnabled(var StatisticalAccount: Record "Statistical Account"): Boolean
    begin
        exit(WorkflowManagement.CanExecuteWorkflow(
            StatisticalAccount,
            RunWorkflowOnSendStatAccForApprovalCode()));
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // EVENT CODE IDENTIFIERS
    // ═══════════════════════════════════════════════════════════════════════════

    procedure RunWorkflowOnSendStatAccForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendStatAccForApproval'));
    end;

    procedure RunWorkflowOnCancelStatAccApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelStatAccApprovalRequest'));
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // WORKFLOW EVENT HANDLERS (subscribe to own publishers)
    // ═══════════════════════════════════════════════════════════════════════════

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BCS Stat. Acc. Approval Mgmt.",
        'OnSendStatAccForApproval', '', true, true)]
    local procedure RunWorkflowOnSendStatAccForApproval(
        var StatisticalAccount: Record "Statistical Account")
    begin
        WorkflowManagement.HandleEvent(
            RunWorkflowOnSendStatAccForApprovalCode(), StatisticalAccount);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BCS Stat. Acc. Approval Mgmt.",
        'OnCancelStatAccApprovalRequest', '', true, true)]
    local procedure RunWorkflowOnCancelStatAccApprovalRequest(
        var StatisticalAccount: Record "Statistical Account")
    begin
        WorkflowManagement.HandleEvent(
            RunWorkflowOnCancelStatAccApprovalRequestCode(), StatisticalAccount);
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // WORKFLOW EVENT LIBRARY
    // ═══════════════════════════════════════════════════════════════════════════

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling",
        'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(
            RunWorkflowOnSendStatAccForApprovalCode(),
            Database::"Statistical Account",
            SendForApprovalEventDescTxt, 0, false);

        WorkflowEventHandling.AddEventToLibrary(
            RunWorkflowOnCancelStatAccApprovalRequestCode(),
            Database::"Statistical Account",
            CancelApprovalEventDescTxt, 0, false);
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // EVENT PREDECESSORS
    // ═══════════════════════════════════════════════════════════════════════════

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelStatAccApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelStatAccApprovalRequestCode(), RunWorkflowOnSendStatAccForApprovalCode());
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendStatAccForApprovalCode());
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(), RunWorkflowOnSendStatAccForApprovalCode());
            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunWorkflowOnSendStatAccForApprovalCode());
        end;
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // APPROVAL ENTRY POPULATION
    // ═══════════════════════════════════════════════════════════════════════════

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.",
        'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(
        var ApprovalEntryArgument: Record "Approval Entry";
        var RecRef: RecordRef;
        WorkflowStepInstance: Record "Workflow Step Instance")
    var
        StatisticalAccount: Record "Statistical Account";
    begin
        case RecRef.Number of
            Database::"Statistical Account":
                begin
                    RecRef.SetTable(StatisticalAccount);
                    ApprovalEntryArgument."Document No." := StatisticalAccount."No.";
                    ApprovalEntryArgument."Table ID" := Database::"Statistical Account";
                end;
        end;
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // STATUS UPDATES
    // ═══════════════════════════════════════════════════════════════════════════

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(
        RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        StatisticalAccount: Record "Statistical Account";
    begin
        case RecRef.Number of
            Database::"Statistical Account":
                begin
                    RecRef.SetTable(StatisticalAccount);
                    StatisticalAccount.Validate(
                        "BCS Approval Status",
                        StatisticalAccount."BCS Approval Status"::"Pending Approval");
                    StatisticalAccount.Modify(true);
                    Variant := StatisticalAccount;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        StatisticalAccount: Record "Statistical Account";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        RecRef.Get(ApprovalEntry."Record ID to Approve");
        case RecRef.Number of
            Database::"Statistical Account":
                begin
                    RecRef.SetTable(StatisticalAccount);
                    if not ApprovalsMgmt.HasOpenOrPendingApprovalEntries(
                        ApprovalEntry."Record ID to Approve")
                    then begin
                        StatisticalAccount."BCS Approval Status" :=
                            StatisticalAccount."BCS Approval Status"::Approved;
                        StatisticalAccount.Modify(true);
                    end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        StatisticalAccount: Record "Statistical Account";
        RecRef: RecordRef;
    begin
        RecRef.Get(ApprovalEntry."Record ID to Approve");
        case RecRef.Number of
            Database::"Statistical Account":
                begin
                    RecRef.SetTable(StatisticalAccount);
                    StatisticalAccount."BCS Approval Status" :=
                        StatisticalAccount."BCS Approval Status"::Rejected;
                    StatisticalAccount.Modify(true);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeShowCommonApprovalStatus', '', false, false)]
    local procedure OnBeforeShowCommonApprovalStatus(var RecRef: RecordRef; var IsHandle: Boolean)
    var
        StatisticalAccount: Record "Statistical Account";
    begin
        case RecRef.Number of
            Database::"Statistical Account":
                begin
                    RecRef.SetTable(StatisticalAccount);
                    case StatisticalAccount."BCS Approval Status" of
                        StatisticalAccount."BCS Approval Status"::Open:
                            ;
                        StatisticalAccount."BCS Approval Status"::"Pending Approval":
                            Message(PendingApprovalMsg);
                        StatisticalAccount."BCS Approval Status"::Approved:
                            Message(ApprovedMsg);
                        StatisticalAccount."BCS Approval Status"::Rejected:
                            Message(RejectedMsg);
                    end;
                    IsHandle := true;
                end;
        end;
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // WORKFLOW RESPONSE HANDLING
    // ═══════════════════════════════════════════════════════════════════════════

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        StatisticalAccount: Record "Statistical Account";
    begin
        case RecRef.Number of
            Database::"Statistical Account":
                begin
                    RecRef.SetTable(StatisticalAccount);
                    StatisticalAccount."BCS Approval Status" :=
                        StatisticalAccount."BCS Approval Status"::Approved;
                    StatisticalAccount.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        StatisticalAccount: Record "Statistical Account";
    begin
        case RecRef.Number of
            Database::"Statistical Account":
                begin
                    RecRef.SetTable(StatisticalAccount);
                    StatisticalAccount.Validate(
                        "BCS Approval Status",
                        StatisticalAccount."BCS Approval Status"::Open);
                    StatisticalAccount.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    procedure SetStatisticalAccountStatustoOpen(var StatisticalAccount: Record "Statistical Account")
    begin
        StatisticalAccount.Validate("BCS Approval Status", StatisticalAccount."BCS Approval Status"::Open);
        StatisticalAccount.Modify(true);
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // RESPONSE PREDECESSORS
    // ═══════════════════════════════════════════════════════════════════════════

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(
        ResponseFunctionName: Code[128])
    begin
        case ResponseFunctionName of
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.SendApprovalRequestForApprovalCode(),
                    RunWorkflowOnSendStatAccForApprovalCode());

            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.SetStatusToPendingApprovalCode(),
                    RunWorkflowOnSendStatAccForApprovalCode());

            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.CancelAllApprovalRequestsCode(),
                    RunWorkflowOnCancelStatAccApprovalRequestCode());

            WorkflowResponseHandling.OpenDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.OpenDocumentCode(),
                    RunWorkflowOnCancelStatAccApprovalRequestCode());

            WorkflowResponseHandling.CreateApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(
                    WorkflowResponseHandling.CreateApprovalRequestsCode(),
                    RunWorkflowOnSendStatAccForApprovalCode());
        end;
    end;

    // ═══════════════════════════════════════════════════════════════════════════
    // CARD PAGE MAPPING
    // ═══════════════════════════════════════════════════════════════════════════

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', true, true)]
    local procedure OnConditionalCardPageIDNotFound(
        RecordRef: RecordRef; var CardPageID: Integer)
    begin
        case RecordRef.Number of
            Database::"Statistical Account":
                CardPageID := Page::"Statistical Account Card";
        end;
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        NoWorkflowEnabledErr:
            Label 'No approval workflow for this record type is enabled.';
        SendForApprovalEventDescTxt:
            Label 'Approval of a Statistical Account is requested.';
        CancelApprovalEventDescTxt:
            Label 'An approval request for a Statistical Account is canceled.';
        PendingApprovalMsg:
            Label 'An approval request has been sent.';
        ApprovedMsg:
            Label 'The Statistical Account has been approved.';
        RejectedMsg:
            Label 'The Statistical Account has been rejected.';
}

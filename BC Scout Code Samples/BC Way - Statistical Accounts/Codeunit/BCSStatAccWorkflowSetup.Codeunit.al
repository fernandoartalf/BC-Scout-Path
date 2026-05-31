codeunit 60711 "BCS Stat. Acc. Workflow Setup"
{
    // ─────────────────────────────────────────────
    // Workflow Category
    // ─────────────────────────────────────────────

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup",
        'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(
            CategoryCodeLbl, CategoryDescLbl);
    end;

    // ─────────────────────────────────────────────
    // Approval Table Relations
    // ─────────────────────────────────────────────

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup",
        'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(
            Database::"Statistical Account", 0,
            Database::"Approval Entry",
            ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    // ─────────────────────────────────────────────
    // Workflow Template
    // ─────────────────────────────────────────────

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup",
        'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertWorkflowTemplates()
    begin
        InsertApprovalWorkflowTemplate();
    end;

    local procedure InsertApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(
            Workflow,
            WorkflowCodeLbl,
            WorkflowDescLbl,
            CategoryCodeLbl);

        InsertApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        StatisticalAccount: Record "Statistical Account";
        ApprovalMgmt: Codeunit "BCS Stat. Acc. Approval Mgmt.";
        BlankDateFormula: DateFormula;
    begin
        WorkflowSetup.InitWorkflowStepArgument(
            WorkflowStepArgument,
            WorkflowStepArgument."Approver Type"::Approver,
            WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
            0, '', BlankDateFormula, true);

        StatisticalAccount.Init();

        WorkflowSetup.InsertRecApprovalWorkflowSteps(
            Workflow,
            BuildConditions(StatisticalAccount),
            ApprovalMgmt.RunWorkflowOnSendStatAccForApprovalCode(),
            WorkflowResponseHandling.CreateApprovalRequestsCode(),
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode(),
            ApprovalMgmt.RunWorkflowOnCancelStatAccApprovalRequestCode(),
            WorkflowStepArgument, false, false);
    end;

    local procedure BuildConditions(var StatisticalAccount: Record "Statistical Account"): Text
    begin
        exit(StrSubstNo(
            ConditionTxt,
            WorkflowSetup.Encode(StatisticalAccount.GetView(false))));
    end;

    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        CategoryCodeLbl: Label 'BCSSTATACCAPPR', Locked = true;
        CategoryDescLbl: Label 'BCS Statistical Account Approvals';
        WorkflowCodeLbl: Label 'BCSSTATACCAPPRWF', Locked = true;
        WorkflowDescLbl: Label 'Statistical Account Approval Workflow';
        ConditionTxt:
            Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Statistical Account">%1</DataItem></DataItems></ReportParameters>',
            Locked = true;
}

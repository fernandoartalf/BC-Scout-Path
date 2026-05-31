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
        StatisticalAccount: Record "Statistical Account";
        WorkflowWebhookEntry: Record "Workflow Webhook Entry";
    begin
        WorkflowSetup.InsertTableRelation(Database::"Statistical Account", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(Database::"Statistical Account", StatisticalAccount.FieldNo("SystemId"), Database::"Workflow Webhook Entry", WorkflowWebhookEntry.FieldNo("Data ID"));
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
        UpdateMatrixData();
        InsertApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        StatisticalAccount: Record "Statistical Account";
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

    local procedure UpdateMatrixData()
    var
        WorkflowResponse: Record "Workflow Response";
        WFEventResponseCombination: Record "WF Event/Response Combination";
    begin
        WorkflowResponse.Reset();

        if not (WFEventResponseCombination.get(WFEventResponseCombination.Type::Response, SENDAPPROVALREQUESTFORAPPROVALLbl, WFEventResponseCombination."Predecessor Type"::"Event", ApprovalMgmt.RunWorkflowOnSendStatAccForApprovalCode())) then begin
            WorkflowResponse.SetRange("Function Name", SENDAPPROVALREQUESTFORAPPROVALLbl);
            WorkflowResponse.FindFirst();
            WorkflowResponseHandling.AddResponsePredecessor(SENDAPPROVALREQUESTFORAPPROVALLbl, ApprovalMgmt.RunWorkflowOnSendStatAccForApprovalCode());
            WorkflowResponse.MakeIndependent();
        end;
        if not (WFEventResponseCombination.get(WFEventResponseCombination.Type::Response, SETSTATUSTOPENDINGAPPROVALLbl, WFEventResponseCombination."Predecessor Type"::"Event", ApprovalMgmt.RunWorkflowOnSendStatAccForApprovalCode())) then begin
            WorkflowResponse.SetRange("Function Name", SETSTATUSTOPENDINGAPPROVALLbl);
            WorkflowResponse.FindFirst();
            WorkflowResponseHandling.AddResponsePredecessor(SETSTATUSTOPENDINGAPPROVALLbl, ApprovalMgmt.RunWorkflowOnSendStatAccForApprovalCode());
            WorkflowResponse.MakeIndependent();
        end;
        if not (WFEventResponseCombination.get(WFEventResponseCombination.Type::Response, SENDNOTIFICATIONTOWEBHOOKLbl, WFEventResponseCombination."Predecessor Type"::"Event", ApprovalMgmt.RunWorkflowOnSendStatAccForApprovalCode())) then begin
            WorkflowResponse.SetRange("Function Name", SENDNOTIFICATIONTOWEBHOOKLbl);
            WorkflowResponse.FindFirst();
            WorkflowResponseHandling.AddResponsePredecessor(SENDNOTIFICATIONTOWEBHOOKLbl, ApprovalMgmt.RunWorkflowOnSendStatAccForApprovalCode());
            WorkflowResponse.MakeIndependent();
        end;
        if not (WFEventResponseCombination.get(WFEventResponseCombination.Type::Response, CANCELALLAPPROVALREQUESTSLbl, WFEventResponseCombination."Predecessor Type"::"Event", ApprovalMgmt.RunWorkflowOnCancelStatAccApprovalRequestCode())) then begin
            WorkflowResponse.SetRange("Function Name", CANCELALLAPPROVALREQUESTSLbl);
            WorkflowResponse.FindFirst();
            WorkflowResponseHandling.AddResponsePredecessor(CANCELALLAPPROVALREQUESTSLbl, ApprovalMgmt.RunWorkflowOnCancelStatAccApprovalRequestCode());
            WorkflowResponse.MakeIndependent();
        end;
    end;

    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ApprovalMgmt: Codeunit "BCS Stat. Acc. Approval Mgmt.";
        SENDAPPROVALREQUESTFORAPPROVALLbl: label 'SENDAPPROVALREQUESTFORAPPROVAL', Locked = true;
        SENDNOTIFICATIONTOWEBHOOKLbl: label 'SENDNOTIFICATIONTOWEBHOOK', Locked = true;
        SETSTATUSTOPENDINGAPPROVALLbl: label 'SETSTATUSTOPENDINGAPPROVAL', Locked = true;
        CANCELALLAPPROVALREQUESTSLbl: label 'CANCELALLAPPROVALREQUESTS', Locked = true;
        CategoryCodeLbl: Label 'BCSSTATACCAPPR', Locked = true;
        CategoryDescLbl: Label 'BCS Statistical Account Approvals';
        WorkflowCodeLbl: Label 'BCSSTATACCAPPRWF', Locked = true;
        WorkflowDescLbl: Label 'Statistical Account Approval Workflow';
        ConditionTxt:
            Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Statistical Account">%1</DataItem></DataItems></ReportParameters>',
            Locked = true;
}

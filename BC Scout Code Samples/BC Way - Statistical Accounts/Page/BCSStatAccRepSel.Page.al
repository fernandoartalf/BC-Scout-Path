page 60705 "BCS Stat. Acc. Rep. Sel."
{
    // Pattern reference: page 9657 "Report Selection - Sales".
    // Locks the Usage filter via FilterGroup(2) so users cannot accidentally
    // edit unrelated Report Selections entries, and pre-fills Usage on new
    // records via OnNewRecord.
    ApplicationArea = All;
    Caption = 'Statistical Account Report Selection';
    PageType = List;
    UsageCategory = Administration;
    SourceTable = "Report Selections";
    SourceTableView = sorting(Usage, Sequence)
                      where(Usage = const("BCS Stat. Account Statement"));
    DelayedInsert = true;
    AdditionalSearchTerms = 'statement,report selection,statistical';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the order in which the reports are printed when more than one report is configured for this usage.';
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the object ID of the report to run for this usage.';
                }
                field("Report Caption"; Rec."Report Caption")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Specifies the caption of the report referenced by Report ID.';
                }
                field("Use for Email Body"; Rec."Use for Email Body")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the report is used as the body of an outgoing email.';
                }
                field("Use for Email Attachment"; Rec."Use for Email Attachment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the report is attached to an outgoing email.';
                }
                field("Email Body Layout Description"; Rec."Email Body Layout Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the layout used when the report is used as the email body.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Lock the Usage filter so it cannot be removed from the UI.
        Rec.FilterGroup(2);
        Rec.SetRange(Usage, Rec.Usage::"BCS Stat. Account Statement");
        Rec.FilterGroup(0);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Usage := Rec.Usage::"BCS Stat. Account Statement";
    end;
}

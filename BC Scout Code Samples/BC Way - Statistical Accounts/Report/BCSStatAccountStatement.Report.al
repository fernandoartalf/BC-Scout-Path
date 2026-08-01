report 60700 "BCS Stat. Account Statement"
{
    Caption = 'Statistical Account Statement';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = StatementLayout;

    dataset
    {
        dataitem(StatisticalAccount; "Statistical Account")
        {
            RequestFilterFields = "No.";
            column(CompanyName_StatAcc; CompanyProperty.DisplayName()) { }
            column(ReportCaption_StatAcc; ReportCaptionLbl) { }
            column(FilterHeader_StatAcc; StatisticalAccount.GetFilters()) { }
            column(No_StatAcc; StatisticalAccount."No.") { }
            column(Name_StatAcc; StatisticalAccount.Name) { }
            column(NoCaption_StatAcc; NoCaptionLbl) { }
            column(NameCaption_StatAcc; NameCaptionLbl) { }
            column(EntriesHeaderCaption; EntriesHeaderCaptionLbl) { }
            column(PostingDateCaption; PostingDateCaptionLbl) { }
            column(DocumentNoCaption; DocumentNoCaptionLbl) { }
            column(DescriptionCaption; DescriptionCaptionLbl) { }
            column(AmountCaption; AmountCaptionLbl) { }

            dataitem(StatisticalLedgerEntry; "Statistical Ledger Entry")
            {
                DataItemLink = "Statistical Account No." = field("No.");
                DataItemLinkReference = StatisticalAccount;
                DataItemTableView = sorting("Statistical Account No.", "Posting Date");

                column(EntryNo_StatLedger; StatisticalLedgerEntry."Entry No.") { }
                column(PostingDate_StatLedger; Format(StatisticalLedgerEntry."Posting Date")) { }
                column(DocumentNo_StatLedger; StatisticalLedgerEntry."Document No.") { }
                column(Description_StatLedger; StatisticalLedgerEntry.Description) { }
                column(Amount_StatLedger; StatisticalLedgerEntry.Amount) { }
            }
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    rendering
    {
        layout(StatementLayout)
        {
            Type = RDLC;
            LayoutFile = 'BC Way - Statistical Accounts/Report/BCSStatAccountStatement.rdlc';
            Caption = 'Statistical Account Statement (RDLC)';
            Summary = 'Prints the Statistical Account header and its ledger entries grouped by account.';
        }
    }

    var
        ReportCaptionLbl: Label 'Statistical Account Statement';
        NoCaptionLbl: Label 'No.';
        NameCaptionLbl: Label 'Name';
        EntriesHeaderCaptionLbl: Label 'Statistical Ledger Entries';
        PostingDateCaptionLbl: Label 'Posting Date';
        DocumentNoCaptionLbl: Label 'Document No.';
        DescriptionCaptionLbl: Label 'Description';
        AmountCaptionLbl: Label 'Amount';
}

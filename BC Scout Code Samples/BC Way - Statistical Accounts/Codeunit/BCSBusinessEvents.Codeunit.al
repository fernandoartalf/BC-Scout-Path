codeunit 60703 "BCS Business Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Stat. Acc. Jnl. Line Post", OnBeforeInsertStatisticalLedgerEntry, '', false, false)]
    local procedure "Stat. Acc. Jnl. Line Post_OnBeforeInsertStatisticalLedgerEntry"(var StatisticalAccJournalLine: Record "Statistical Acc. Journal Line"; var StatisticalLedgerEntry: Record "Statistical Ledger Entry")
    begin
        OnBeforeStatisticalLedgerEntryPosted(
            StatisticalAccJournalLine."Statistical Account No.",
            StatisticalAccJournalLine."Posting Date",
            StatisticalAccJournalLine.Amount,
            StatisticalAccJournalLine."Document No.",
            StatisticalLedgerEntry."Entry No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Statistical Account", OnAfterInsertStatisticalAccount, '', false, false)]
    local procedure OnAfterInsertStatisticalAccount(var StatisticalAccount: Record "Statistical Account")
    begin
        OnStatisticalAccountCreated(StatisticalAccount."No.", StatisticalAccount.Name);
    end;

    [ExternalBusinessEvent('beforeStatisticalLedgerEntryPosted', 'before statistical ledger entry is posted', 'Triggered before the statistical ledger entry is posted', EventCategory::"BCS Stat. Accounts")]
    procedure OnBeforeStatisticalLedgerEntryPosted(StatisticalAccountNo: Code[20]; PostingDate: Date; Amount: Decimal; DocumentNo: Code[20]; EntryNo: Integer)
    begin
    end;

    [ExternalBusinessEvent('statisticalAccountCreated', 'statistical account created', 'Triggered when a new statistical account is created', EventCategory::"BCS Stat. Accounts")]
    procedure OnStatisticalAccountCreated(AccountNo: Code[20]; AccountName: Text[100])
    begin
    end;
}

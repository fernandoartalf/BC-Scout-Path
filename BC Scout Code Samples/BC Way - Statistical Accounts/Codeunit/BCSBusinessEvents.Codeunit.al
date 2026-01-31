codeunit 60703 "BCS Business Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Stat. Acc. Jnl. Line Post", OnBeforeInsertStatisticalLedgerEntry, '', false, false)]
    local procedure "Stat. Acc. Jnl. Line Post_OnBeforeInsertStatisticalLedgerEntry"(var StatisticalAccJournalLine: Record "Statistical Acc. Journal Line"; var StatisticalLedgerEntry: Record "Statistical Ledger Entry")
    begin
        OnBeforeStatisticalLedgerEntryPosted(StatisticalAccJournalLine, StatisticalLedgerEntry);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Statistical Account", OnAfterInsertStatisticalAccount, '', false, false)]
    local procedure OnAfterInsertStatisticalAccount(var StatisticalAccount: Record "Statistical Account")
    begin
        OnStatisticalAccountCreated(StatisticalAccount);
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeStatisticalLedgerEntryPosted(var StatisticalAccJournalLine: Record "Statistical Acc. Journal Line"; var StatisticalLedgerEntry: Record "Statistical Ledger Entry")
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnStatisticalAccountCreated(var StatisticalAccount: Record "Statistical Account")
    begin
    end;
}

query 60704 "BCS DVC Stat. Ledger Entry API"
{
    APIGroup = 'statisticAccounts';
    APIPublisher = 'businessCentralScout';
    APIVersion = 'v2.0';
    Caption = 'dvcStatLedgerEntryAPI';
    EntityName = 'statisticalLedgerEntry';
    EntitySetName = 'statisticalLedgerEntries';
    QueryType = API;

    elements
    {
        dataitem(statisticalLedgerEntry; "Statistical Ledger Entry")
        {
            column(entryNo; "Entry No.")
            {
                Caption = 'Entry No.';
            }
            column(statisticalAccountNo; "Statistical Account No.")
            {
                Caption = 'Statistical Account No.';
            }
            column(postingDate; "Posting Date")
            {
                Caption = 'Posting Date';
            }
            column(documentNo; "Document No.")
            {
                Caption = 'Document No.';
            }
            column(description; Description)
            {
                Caption = 'Description';
            }
            column(amount; Amount)
            {
                Caption = 'Amount';
            }
            column(globalDimension1Code; "Global Dimension 1 Code")
            {
                Caption = 'Global Dimension 1 Code';
            }
            column(globalDimension2Code; "Global Dimension 2 Code")
            {
                Caption = 'Global Dimension 2 Code';
            }
            column(userID; "User ID")
            {
                Caption = 'User ID';
            }
            column(journalBatchName; "Journal Batch Name")
            {
                Caption = 'Journal Batch Name';
            }
            column(transactionNo; "Transaction No.")
            {
                Caption = 'Transaction No.';
            }
            column(reversed; Reversed)
            {
                Caption = 'Reversed';
            }
            column(reversedByEntryNo; "Reversed by Entry No.")
            {
                Caption = 'Reversed by Entry No.';
            }
            column(reversedEntryNo; "Reversed Entry No.")
            {
                Caption = 'Reversed Entry No.';
            }
            column(dimensionSetID; "Dimension Set ID")
            {
                Caption = 'Dimension Set ID';
            }
            column(shortcutDimension3Code; "Shortcut Dimension 3 Code")
            {
                Caption = 'Shortcut Dimension 3 Code';
            }
            column(shortcutDimension4Code; "Shortcut Dimension 4 Code")
            {
                Caption = 'Shortcut Dimension 4 Code';
            }
            column(shortcutDimension5Code; "Shortcut Dimension 5 Code")
            {
                Caption = 'Shortcut Dimension 5 Code';
            }
            column(shortcutDimension6Code; "Shortcut Dimension 6 Code")
            {
                Caption = 'Shortcut Dimension 6 Code';
            }
            column(shortcutDimension7Code; "Shortcut Dimension 7 Code")
            {
                Caption = 'Shortcut Dimension 7 Code';
            }
            column(shortcutDimension8Code; "Shortcut Dimension 8 Code")
            {
                Caption = 'Shortcut Dimension 8 Code';
            }
        }
    }
}

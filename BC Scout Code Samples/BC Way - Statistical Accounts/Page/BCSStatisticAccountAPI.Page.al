page 60702 "BCS Statistic Account API"
{
    APIGroup = 'statisticAccounts';
    APIPublisher = 'businessCentralScout';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'bcsStatisticAccountAPI';
    DelayedInsert = true;
    EntityName = 'statisticalAccount';
    EntitySetName = 'statisticalAccounts';
    PageType = API;
    SourceTable = "Statistical Account";
    ODataKeyFields = SystemId;
    AboutText = 'Manages Statistical Accounts master data including names and related dimmension codes.Supports full CRUD operations for retrieving, creating, updating, and deleting Statistical Account records. Ideal for integration scenarios requiring access to Statistical Account data and non financial KPIs.';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    Caption = 'Global Dimension 1 Code';
                }
                field(globalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    Caption = 'Global Dimension 2 Code';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(balanceAtDate; Rec."Balance at Date")
                {
                    Caption = 'Balance at Date';
                }
                field(netChange; Rec."Net Change")
                {
                    Caption = 'Net Change';
                }
                field(balance; Rec.Balance)
                {
                    Caption = 'Balance';
                }
                field(bcsNoSeries; Rec."BCS No. Series")
                {
                    Caption = 'No. Series';
                }
            }
        }
    }
}

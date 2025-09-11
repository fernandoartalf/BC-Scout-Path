namespace BCScoutCodeSamples.BCScoutCodeSamples;

using Microsoft.Finance.Analysis.StatisticalAccount;

page 50701 "BCS Statistical Account API"
{
    APIGroup = 'BCS';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'statisticalAccountAPI';
    DelayedInsert = true;
    EntityName = 'statisticalAccount';
    EntitySetName = 'statisticalAccounts';
    PageType = API;
    SourceTable = "Statistical Account";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
            }
        }
    }
}

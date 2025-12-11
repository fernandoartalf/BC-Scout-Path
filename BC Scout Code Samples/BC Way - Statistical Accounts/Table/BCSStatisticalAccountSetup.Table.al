table 60700 "BCS Statistical Account Setup"
{
    Caption = 'Statistical Account Setup';
    DataClassification = ToBeClassified;
    DrillDownPageID = "BCS Statistical Account Setup";
    LookupPageID = "BCS Statistical Account Setup";
    // This table is used to store the setup for Statistical Accounts.
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "Statistical Account Nos."; code[20])
        {
            Caption = 'Statistical Account Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(10; "Enable Attachments"; Boolean)
        {
            Caption = 'Enable Attachments on Statistical Accounts';
            InitValue = true;
        }
        field(11; "Enable Links"; Boolean)
        {
            Caption = 'Enable Links on Statistical Accounts';
            InitValue = true;
        }
        field(12; "Enable Notes"; Boolean)
        {
            Caption = 'Enable Notes on Statistical Accounts';
            InitValue = true;
        }
        field(13; "Default API Journal Temp. Name"; Code[10])
        {
            Caption = 'Default APIJournal Template Name';
            TableRelation = "Statistical Acc. Journal Batch"."Journal Template Name";
            trigger OnValidate()
            begin
                "Default API Journal Name" := '';
            end;
        }
        field(14; "Default API Journal Name"; Code[10])
        {
            Caption = 'Default API Journal Name';
            TableRelation = "Statistical Acc. Journal Batch".Name where("Journal Template Name" = field("Default API Journal Temp. Name"));
        }
        field(15; "Default API Document No."; Code[20])
        {
            Caption = 'Default API Document No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(16; "Allow API Journal Posting"; Boolean)
        {
            Caption = 'Allow API Journal direct Posting';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
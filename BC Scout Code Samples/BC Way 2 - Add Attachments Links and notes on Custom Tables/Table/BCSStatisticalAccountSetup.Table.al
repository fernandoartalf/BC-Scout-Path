table 50700 "BCS Statistical Account Setup"
{
    Caption = 'Statistical Account Setup';
    DataClassification = ToBeClassified;
    DrillDownPageID = "BCS Statistical Account Setup";
    LookupPageID = "BCS Statistical Account Setup";
    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
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
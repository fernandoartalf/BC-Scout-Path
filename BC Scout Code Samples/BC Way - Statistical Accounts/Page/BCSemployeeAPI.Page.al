namespace BCScoutCodeSamples.BCScoutCodeSamples;

using Microsoft.HumanResources.Employee;
using Microsoft.HumanResources.Setup;
using Microsoft.Projects.Resources.Resource;
using Microsoft.Foundation.NoSeries;
using Microsoft.Projects.Resources.Setup;

page 50702 "BCS employee API"
{
    APIGroup = 'bcs';
    APIPublisher = 'bcScout';
    APIVersion = 'v2.0';
    Caption = 'employeeAPI';
    DelayedInsert = true;
    EntityName = 'employee';
    EntitySetName = 'employees';
    PageType = API;
    SourceTable = Employee;

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
                field(secondFamilyName; Rec."Second Family Name")
                {
                    Caption = 'Second Family Name';
                }
                field(firstFamilyName; Rec."First Family Name")
                {
                    Caption = 'First Family Name';
                }
                field(jobTitle; Rec."Job Title")
                {
                    Caption = 'Job Title';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(mobilePhoneNo; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                }
                field(companyEMail; Rec."Company E-Mail")
                {
                    Caption = 'Company Email';
                }
                field(resourceNo; Rec."Resource No.")
                {
                    Caption = 'Resource No.';
                }
                field(statisticsGroupCode; Rec."Statistics Group Code")
                {
                    Caption = 'Statistics Group Code';
                }
                field(birthDate; Rec."Birth Date")
                {
                    Caption = 'Birth Date';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Employee.Reset();
        Employee.SetRange("Company E-Mail", Rec."Company E-Mail");
        if not Employee.FindFirst() then begin
            HRSetup.Get();
            Employee.Init();
            Employee."No." := NoSeries.GetNextNo(HRSetup."Employee Nos.");
            Employee.Insert();
            ModifyEmployee();
        end else
            ModifyEmployee();

        Commit();
        exit(false);
    end;

    local procedure ModifyEmployee()
    begin
        Employee.Validate(Name, Rec.Name);
        Employee.Validate("E-Mail", Rec."E-Mail");
        Employee.Validate("Company E-Mail", Rec."Company E-Mail");
        Employee.validate("First Name", Rec."First Name");
        Employee.validate("Middle Name", Rec."Middle Name");
        Employee.validate("Last Name", Rec."Last Name");
        Employee.validate("Search Name", Rec."Search Name");
        Employee.validate(Address, Rec.Address);
        Employee.validate("Address 2", Rec."Address 2");
        Employee.Modify();
    end;

    var
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        NoSeries: Codeunit "No. Series";
}

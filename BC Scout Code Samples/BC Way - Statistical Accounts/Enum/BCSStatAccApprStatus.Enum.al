enum 60702 "BCS Stat. Acc. Appr. Status"
{
    Extensible = true;
    Caption = 'Statistical Account Approval Status';

    value(0; "Open")
    {
        Caption = 'Open';
    }
    value(1; "Pending Approval")
    {
        Caption = 'Pending Approval';
    }
    value(2; "Rejected")
    {
        Caption = 'Rejected';
    }
    value(3; "Approved")
    {
        Caption = 'Approved';
    }
}

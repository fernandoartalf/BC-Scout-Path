codeunit 50705 "BCS Statistical Accounts BS"
{
    [EventSubscriber(ObjectType::Table, Database::"Statistical Account", OnAfterInsertEvent, '', true, true)]
    local procedure OnAfterInsertEventStatisticalAccount(var Rec: Record "Statistical Account"; RunTrigger: Boolean)
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Statistical Account", OnAfterModifyEvent, '', true, true)]
    local procedure StatisticalAccountOnAfterModifyEvent(var Rec: Record "Statistical Account"; XRec: Record "Statistical Account"; RunTrigger: Boolean)
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Statistical Account", OnAfterRenameEvent, '', true, true)]
    local procedure StatisticalAccountOnAfterRenameEvent(var Rec: Record "Statistical Account"; XRec: Record "Statistical Account"; RunTrigger: Boolean)
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Statistical Account", OnAfterDeleteEvent, '', true, true)]
    local procedure StatisticalAccountOnAfterDeleteEvent(var Rec: Record "Statistical Account"; RunTrigger: Boolean)
    begin

    end;
}

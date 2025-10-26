codeunit 60701 "DVC Stat. Acc.Setup Management"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure AddGeneralLedgerSetupWizard()
    var
        AssistedSetup: Codeunit "Guided Experience";
        Language: Codeunit Language;
        CurrentGlobalLanguage: Integer;
    begin
        CurrentGlobalLanguage := GlobalLanguage;
        AssistedSetup.InsertAssistedSetup(SetupTxt, SetupTxt, SetupDescriptionTxt, 1000, ObjectType::Page, Page::"BCS StaT. Acc.Setup Wizard",
                        "Assisted Setup Group"::DoMoreWithBC, 'https://www.youtube.com/watch?v=edGJn3IzS8o&list=OLAK5uy_loMTyCCFteD6M6QIcNNbmpY6lyADQl-LQ&index=8',
                        "Video Category"::Uncategorized,
                        'https://learn.microsoft.com/en-us/dynamics365/business-central/bi-use-statistical-accounts');
        GlobalLanguage(Language.GetDefaultApplicationLanguageId());
        AssistedSetup.AddTranslationForSetupObjectDescription(Enum::"Guided Experience Type"::"Assisted Setup", ObjectType::Page, Page::"BCS StaT. Acc.Setup Wizard", Language.GetDefaultApplicationLanguageId(), SetupTxt);
        GlobalLanguage(CurrentGlobalLanguage);
    end;

    local procedure GetAppId(): Guid
    var
        EmptyGuid: Guid;
    begin
        if Info.Id() = EmptyGuid then
            NavApp.GetCurrentModuleInfo(Info);
        exit(Info.Id());
    end;

    var
        Info: ModuleInfo;
        SetupTxt: Label 'Set up Statistical Accounts';
        SetupDescriptionTxt: Label 'Statistical accounts let you add metrics that are based on non-transactional data.';


}

codeunit 50703 "BCS Demo Data Deployment"
{
    procedure InternalJsonList()
    begin
        DeployInternalJson('BCSStatisticalAccountsDemoData.json');
    end;

    local procedure DeployInternalJson(Filename: Text)
    var
        EntityJsonObject: JsonObject;
        EntityJsonToken: JsonToken;
        TableId: Integer;
    begin
        EntityJsonObject := NavApp.GetResourceAsJson(Filename);
        EntityJsonToken := EntityJsonObject.AsToken();
        TableId := GetTableIdValue(EntityJsonToken);

        LoadEntityDemoData(TableId, EntityJsonObject);
    end;

    procedure LoadEntityDemoData(TableId: Integer; var SelectedJsonObject: JsonObject)
    var
        SelectedArray: JsonArray;
        SelectedRecordIdToken: JsonToken;
        SelectedFieldIdToken: JsonToken;
        TargetRecRef: RecordRef;
        RecordIdText: Text;
        fldRef: FieldRef;
        i: Integer;
        RecordNumber: Integer;
        fieldNumber: Integer;
    begin
        Clear(TargetRecRef);
        Clear(fldRef);
        Clear(RecordNumber);
        SelectedJsonObject.Get('recordId', SelectedRecordIdToken);
        SelectedArray := SelectedRecordIdToken.AsArray();
        TargetRecRef.Open(TableId);
        foreach SelectedRecordIdToken in SelectedArray do begin
            RecordNumber += 1;
            RecordIdText := SelectedArray.GetText(RecordNumber);
            Clear(fieldNumber);
            for i := 1 to TargetRecRef.FieldCount do begin  // Will loop through all the fields count which are available.
                fieldNumber += 1;
                fldRef := TargetRecRef.FieldIndex(i);
                if not (fldRef.Class() = FieldClass::FlowField) then
                    if TargetRecRef.FieldExist(fldRef.number) then // this statement will skip those records which are not exist in Source Table.
                                                                   // fldRef.Value := SourceRecRef.Field(fldRef.Number).Value;
                                                                   // fldRef.Value := GetFieldValue(SelectedRecordIdToken, Format(fldRef.Number)); // This will get the value from the Json Token.
                        SetFieldValue(TargetRecRef, fldRef, SelectedRecordIdToken, RecordNumber, fieldNumber);
            end;
            TargetRecRef.Insert(); // Finally Inserting the Target Table (Archive Table.
        end;
        TargetRecRef.Close();
    end;
    // Using to create the Query https://jsonpath.com/ 

    local procedure SetFieldValue(var TargetRecRef: RecordRef; var CurrentFieldRef: FieldRef; RecordIdJsonToken: JsonToken; RecordNumber: Integer; FieldNumber: Integer)
    var
        query: Text;
        FieldToken: JsonToken;
    begin
        query := '$[' + Format(RecordNumber) + ']['' fields''][' + Format(FieldNumber) + '][''value'']';
        RecordIdJsonToken.SelectToken(query, FieldToken);
        // TODO: ADJUST POLIMORFISM
        if FieldToken.AsValue().AsText() = 'null' then
            exit;
        SetFieldRefValueFromJsonToken(TargetRecRef, CurrentFieldRef, FieldToken);
    end;

    local procedure GetTableIdValue(RecordIdJsonToken: JsonToken): Integer
    var
        TableIdToken: JsonToken;
        queryTxt: TextConst ENU = '$[0][''id'']';
    begin
        RecordIdJsonToken.SelectToken(queryTxt, TableIdToken);
        exit(TableIdToken.AsValue().AsInteger());
    end;

    local procedure SetFieldRefValueFromJsonToken(var RecordRefField: RecordRef; var CurrentFieldRef: FieldRef; FieldToken: JsonToken)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        FieldValue: JsonValue;
        BoolValue: Boolean;
        IntValue: Integer;
        DecimalValue: Decimal;
        DateValue: Date;
        TimeValue: Time;
        DateTimeValue: DateTime;
        DurationValue: Duration;
        BigIntegerValue: BigInteger;
        GuidValue: Guid;
    begin
        case CurrentFieldRef.Type() of
            FieldType::Boolean:
                CurrentFieldRef.Value := FieldToken.AsValue().AsBoolean();
            FieldType::Code:
                CurrentFieldRef.Value := FieldToken.AsValue().AsCode();
            FieldType::Integer:
                CurrentFieldRef.Value := FieldToken.AsValue().AsInteger();
            FieldType::Decimal:
                CurrentFieldRef.Value := FieldToken.AsValue().AsDecimal();
            FieldType::Date:
                CurrentFieldRef.Value := FieldToken.AsValue().AsDate();
            FieldType::Time:
                CurrentFieldRef.Value := FieldToken.AsValue().AsTime();
            FieldType::DateTime:
                CurrentFieldRef.Value := FieldToken.AsValue().AsDateTime();
            FieldType::Duration:
                CurrentFieldRef.Value := FieldToken.AsValue().AsDuration();
            FieldType::BigInteger:
                CurrentFieldRef.Value := FieldToken.AsValue().AsBigInteger();
            // TODO: Add support for MEdia and MediaSet types.
            FieldType::MediaSet:
                exit; // MediaSet is not handled in this context.
            FieldType::Media:
                exit; // Media is not handled in this context.
            else
                CurrentFieldRef.Value := FieldToken.AsValue().AsText();
        end;
    end;

}

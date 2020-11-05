unit Helper.TDataSet;

interface

uses
  System.SysUtils,
  System.RTTI,
  System.Generics.Collections,
  Data.DB;

type
  TDataSetHelper = class helper for TDataSet
  private const
    Version = '1.7';
  public
    /// <summary>
    ///   Iterates through the dataset and it's calling anonymous methods
    ///   (proc) for each row. Disables all UI notification and preserving
    ///   current dataset position.
    /// </summary>
    procedure WhileNotEof(proc: TProc);
    /// <summary>
    ///   Iterates through the dataset, clone "WhileNotEof" method.
    /// </summary>
    procedure ForEachRow(proc: TProc);
    /// <summary>
    ///   Iterates through the dataset and calculates maximum value of
    ///   the integer data field (TIntegerField) in all data rows.
    /// </summary>
    function GetMaxIntegerValue(const fieldName: string): integer;
    /// <summary>
    ///   Creates new TDataSource component assigned to this dataset.
    ///   The owner of TDataSource is this dataset.
    /// </summary>
    function CreateDataSource: TDataSource;
    /// <summary>
    ///   Iterates through base dataset and for each row creates new object
    ///   using generic class T provided through a generic parameter.
    ///   The attributes/fields in the newly created object are filled with
    ///   values from the data set. Default mapping is: dataset field name
    ///   have to equal to object attribute name. Different mapping can be
    ///   applied with Custom attribute "MappedToField".
    /// </summary>
    /// <exception cref="EInvalidMapping">
    ///   Exception <b>EInvalidMapping</b> is thrown when you provide invalid
    ///   mapping through MappedToField attribute, when filed name is not
    ///   found in dataset.
    /// </exception>
    /// <remarks>
    ///   To define custom mapping developer has to include unit
    ///   Attribute.MappedToField.pas in which attribute "MappedToField" is
    ///   defined. Sample mapping added above class field can look like:
    ///   `[MapedToField('city')]`. For more mapping examples check sample code.
    /// </remarks>
    function LoadData<T: class, constructor>: TObjectList<T>;
    /// <summary>
    ///   Allows to append multiple row into dataset. Each master item in
    ///   the array is appended as a new row, and each detail item value
    ///   from this array is assigned to following dataset fields - ordered
    ///   by index. To skip a value assignment for one field put Null variant
    ///   value in the array
    /// </summary>
    /// <exception cref="EDatabaseError">
    ///   Exception <b>EDatabaseError</b> has detailed information about
    ///   row number and field index which was not able to assigned
    /// </exception>
    procedure AppendRows(aRecordArray: TArray < TArray < Variant >> );
  end;

  EInvalidMapping = class(Exception)
  end;

  TDataSetToObjectMapper = class
  private
    class function SetObjectField(const aDataset: TDataSet; aFieldName: string;
      const objectField: TRttiField; dest: TObject): boolean; static;
  public
    class procedure DataSetRowToObject(aDataset: TDataSet; aObject: TObject);
  end;

implementation

uses
  Attribute.MappedToField;

// ----------------------------------------------------------------------
// TDataSetToObjectMapper
// ----------------------------------------------------------------------

class function TDataSetToObjectMapper.SetObjectField(const aDataset: TDataSet;
  aFieldName: string; const objectField: TRttiField; dest: TObject): boolean;
var
  valueOfField: TValue;
  field: TField;
begin
  field := aDataset.FindField(aFieldName);
  if field = nil then
    Result := False
  else
  begin
    if field is TBlobField then
      valueOfField := TValue.From((field as TBlobField).Value)
    else
      valueOfField := TValue.From(field.Value);
    objectField.SetValue(TObject(dest), valueOfField);
    Result := True;
  end;
end;

class procedure TDataSetToObjectMapper.DataSetRowToObject(aDataset: TDataSet;
  aObject: TObject);
var
  rttiType: TRttiType;
  RttiContext: TRttiContext;
  customAttr: TCustomAttribute;
  rttiField: TRttiField;
  customattribute: TCustomAttribute;
  fieldName: string;
  isDone: boolean;
begin
  rttiType := RttiContext.GetType(aObject.ClassType);
  for rttiField in rttiType.GetFields do
  begin
    fieldName := rttiField.Name;
    isDone := SetObjectField(aDataset, fieldName, rttiField, aObject);
    if not isDone then
    begin
      // Find CustomAttribute defined above the class field
      customAttr := nil;
      for customattribute in rttiField.GetAttributes do
        if customattribute is MappedToFieldAttribute then
        begin
          customAttr := customattribute;
          break;
        end;
      // --------------------------------------------------------
      if customAttr <> nil then
      begin
        fieldName := (customAttr as MappedToFieldAttribute).fieldName;
        if not SetObjectField(aDataset, fieldName, rttiField, aObject) then
          raise EInvalidMapping.Create
            (Format('Invalid mapping defined for field "%s" in class %s',
            [rttiField.Name, rttiType.Name]));
      end;
    end;
  end;
end;

// ----------------------------------------------------------------------
// TDataSetHelper
// ----------------------------------------------------------------------

function TDataSetHelper.GetMaxIntegerValue(const fieldName: string): integer;
var
  MaxValue: integer;
  CurrentValue: integer;
begin
  MaxValue := 0;
  self.WhileNotEof(
    procedure
    begin
      CurrentValue := self.FieldByName(fieldName).AsInteger;
      if CurrentValue > MaxValue then
        MaxValue := CurrentValue;
    end);
  Result := MaxValue;
end;

procedure TDataSetHelper.WhileNotEof(proc: TProc);
var
  Bookmark: TBookmark;
begin
  Bookmark := self.GetBookmark;
  self.DisableControls;
  try
    self.First;
    while not self.Eof do
    begin
      proc();
      self.Next;
    end;
  finally
    if self.BookmarkValid(Bookmark) then
      self.GotoBookmark(Bookmark);
    self.FreeBookmark(Bookmark);
    self.EnableControls;
  end;
end;

function TDataSetHelper.CreateDataSource: TDataSource;
begin
  Result := TDataSource.Create(self);
  Result.DataSet := self;
end;

procedure TDataSetHelper.ForEachRow(proc: TProc);
begin
  WhileNotEof(proc);
end;

function TDataSetHelper.LoadData<T>: TObjectList<T>;
var
  dataList: TObjectList<T>;
  dataField: TField;
  obj: T;
begin
  dataList := TObjectList<T>.Create(True);
  try
    WhileNotEof(
      procedure
      begin
        obj := T.Create();
        dataList.Add(obj);
        TDataSetToObjectMapper.DataSetRowToObject(self, obj);
      end);
    Result := dataList;
  except on E: Exception do
    begin
      dataList.Free;
      raise;
    end
  end;
end;

procedure TDataSetHelper.AppendRows(aRecordArray: TArray < TArray <
  Variant >> );
var
  idxRow: integer;
  idxField: integer;
begin
  for idxRow := 0 to High(aRecordArray) do
  begin
    self.Append;
    for idxField := 0 to High(aRecordArray[idxRow]) do
    begin
      try
        self.Fields[idxField].Value := aRecordArray[idxRow][idxField];
      except
        on E: EDatabaseError do
        begin
          E.Message := E.Message + Format(' (Row nr:%d, Index of field:%d)',
            [idxRow + 1, idxField]);
          raise;
        end
      end;
    end;
    try
      self.Post;
    except
      on E: EDatabaseError do
      begin
        E.Message := E.Message + Format(' (Row nr:%d)', [idxRow + 1]);
        raise;
      end
    end;
  end;
end;

end.

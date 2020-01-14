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
    Version = '1.5';
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
  end;

  EInvalidMapping = class(Exception)
  end;

implementation

uses
  Attribute.MappedToField;

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
  item: T;
  RttiContext: TRttiContext;
  itemType: TRttiType;
  dataField: TField;
  customAttr: TCustomAttribute;
  aDataFieldName: string;
begin
  dataList := TObjectList<T>.Create(True);
  WhileNotEof(
    procedure
    var
      i: integer;
      itemField: TRttiField;
      ca: TCustomAttribute;
    begin
      item := T.Create();
      itemType := RttiContext.GetType(item.ClassType);
      for itemField in itemType.GetFields do
      begin
        dataField := self.FindField(itemField.Name);
        if dataField <> nil then
          itemField.SetValue(TObject(item), TValue.From(dataField.Value))
        else
        begin
          // --------------------------------------------------------
          // Find Custom Attribute define for field in class
          // --------------------------------------------------------
          customAttr := nil;
          for ca in itemField.GetAttributes do
            if ca is MappedToFieldAttribute then
            begin
              customAttr := ca;
              break;
            end;
          // --------------------------------------------------------
          if customAttr <> nil then
          begin
            aDataFieldName := (customAttr as MappedToFieldAttribute).fieldName;
            dataField := self.FindField(aDataFieldName);
            if dataField <> nil then
              itemField.SetValue(TObject(item), TValue.From(dataField.Value))
            else
              raise EInvalidMapping.Create
                (Format('Invalid mapping defined for field "%s" in class %s',
                [itemField.Name, itemType.Name]));
          end
        end;
      end;
      dataList.Add(item);
    end);
  Result := dataList;
end;

end.

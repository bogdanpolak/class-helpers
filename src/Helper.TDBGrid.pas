unit Helper.TDBGrid;

interface

uses
  Vcl.DBGrids,
  System.JSON,
  System.SysUtils,
  System.Generics.Collections,
  System.Variants;

type
  TDBGridHelper = class helper for TDBGrid
  public const
    SufixForAdditionalColumnWidth = '   ';
  private const
    Version = '1.4';
  public
    /// <summary>
    ///   Counts and sets the width of the grid columns in pixels
    /// </summary>
    /// <param name="CalcForNumberOfRows">
    ///   The number of rows for which widths are counted
    /// </param>
    function AutoSizeColumns(const CalcForNumberOfRows: integer = 25): integer;
    procedure LoadColumnsFromJson(aStoredColumns: TJSONArray);
    procedure LoadColumnsFromJsonString(const aJsonString: string);
  end;

type
  EJSONProcessing = class(Exception);

implementation

uses
  Data.DB, System.Math, System.Classes;

function TDBGridHelper.AutoSizeColumns(const CalcForNumberOfRows
  : integer = 25): integer;
var
  DataSet: TDataSet;
  Bookmark: TBookmark;
  Count, i: integer;
  ColumnsWidth: array of integer;
begin
  SetLength(ColumnsWidth, self.Columns.Count);
  for i := 0 to self.Columns.Count - 1 do
    if self.Columns[i].Visible then
      ColumnsWidth[i] := self.Canvas.TextWidth(self.Columns[i].Title.Caption +
        SufixForAdditionalColumnWidth)
    else
      ColumnsWidth[i] := 0;
  if self.DataSource <> nil then
    DataSet := self.DataSource.DataSet
  else
    DataSet := nil;
  if (DataSet <> nil) and DataSet.Active then
  begin
    Bookmark := DataSet.GetBookmark;
    DataSet.DisableControls;
    try
      Count := 0;
      DataSet.First;
      while not DataSet.Eof and (Count < CalcForNumberOfRows) do
      begin
        for i := 0 to self.Columns.Count - 1 do
          if self.Columns[i].Visible then
            ColumnsWidth[i] := Max(ColumnsWidth[i],
              self.Canvas.TextWidth(self.Columns[i].Field.DisplayText +
              SufixForAdditionalColumnWidth));
        Inc(Count);
        DataSet.Next;
      end;
    finally
      DataSet.GotoBookmark(Bookmark);
      DataSet.FreeBookmark(Bookmark);
      DataSet.EnableControls;
    end;
  end;
  Count := 0;
  for i := 0 to self.Columns.Count - 1 do
    if self.Columns[i].Visible then
    begin
      self.Columns[i].Width := ColumnsWidth[i];
      Inc(Count, ColumnsWidth[i]);
    end;
  Result := Count - self.ClientWidth;
end;

function GetJsonObjectValue(jsObj: TJSONObject; const key: string): string;
var
  jv: TJSONValue;
begin
  jv := jsObj.Values[key];
  if (jv = nil) or (jv.Null) then
    Result := ''
  else
    Result := jv.Value;
end;

function GetJsonObjectValueBoolen(jsObj: TJSONObject; const key: string;
  deafultValue: boolean): boolean;
var
  jv: TJSONValue;
begin
  jv := jsObj.Values[key];
  if (jv <> nil) and not(jv is TJSONBool) then
    raise EJSONProcessing.Create
      (Format('Expected boolean value in JSON object for key:"%s"', [key]));
  if (jv = nil) or (jv.Null) then
    Result := deafultValue
  else
    Result := (jv is TJSONTrue);
end;

function GetJsonObjectValueInteger(jsObj: TJSONObject;
  const key: string): Variant;
var
  jv: TJSONValue;
begin
  jv := jsObj.Values[key];
  if (jv <> nil) and not(jv is TJSONNumber) then
    raise EJSONProcessing.Create
      (Format('Expected number value in JSON object for key:"%s"', [key]));
  if (jv = nil) or (jv.Null) then
    Result := System.Variants.Null()
  else
    Result := (jv as TJSONNumber).AsInt;
end;

procedure TDBGridHelper.LoadColumnsFromJson(aStoredColumns: TJSONArray);
var
  i: integer;
  jsCol: TJSONObject;
  aFieldName: string;
  aColumnTitle: string;
  aColumn: TColumn;
  aField: TField;
  aVisible: boolean;
  aWidth: Variant;
begin
  self.Columns.Clear;
  if (self.DataSource = nil) or (self.DataSource.DataSet = nil) then
    exit;
  for i := 0 to aStoredColumns.Count - 1 do
  begin
    jsCol := aStoredColumns.Items[i] as TJSONObject;
    aFieldName := GetJsonObjectValue(jsCol, 'fieldName');
    aColumnTitle := GetJsonObjectValue(jsCol, 'title');
    aVisible := GetJsonObjectValueBoolen(jsCol, 'visible', True);
    aWidth := GetJsonObjectValueInteger(jsCol, 'width');
    // --
    aField := self.DataSource.DataSet.FindField(aFieldName);
    if (aField <> nil) or (aColumnTitle <> '') then
    begin
      aColumn := self.Columns.Add;
      aColumn.Field := aField;
      if aColumnTitle <> '' then
        aColumn.Title.Caption := aColumnTitle;
      aColumn.Visible := aVisible;
      if aWidth <> System.Variants.Null() then
        aColumn.Width := aWidth;
    end;
  end;
end;

procedure TDBGridHelper.LoadColumnsFromJsonString(const aJsonString: string);
var
  jsValue: TJSONValue;
  jsColumns: TJSONArray;
begin
  jsValue := TJSONObject.ParseJSONValue(aJsonString);
  if jsValue = nil then
    raise EJSONProcessing.Create
      ('Parsing error! Expected valid JSON string as parameter.');
  try
    if not(jsValue is TJSONArray) then
      raise EJSONProcessing.Create
        ('Expected JSON array in provided string parameter.');
    jsColumns := jsValue as TJSONArray;
    Self.LoadColumnsFromJson(jsColumns);
  finally
    jsValue.Free;
  end;
end;

end.

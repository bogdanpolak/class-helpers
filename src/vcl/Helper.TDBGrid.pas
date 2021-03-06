﻿unit Helper.TDBGrid;

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
    Version = '1.8';
  public
    /// <summary>
    ///   Counts and sets the width of the grid columns in pixels
    /// </summary>
    /// <param name="CalcForNumberOfRows">
    ///   The number of rows for which widths are counted
    /// </param>
    function AutoSizeColumns(const CalcForNumberOfRows: integer = 25): integer;
    /// <summary>
    ///   Allows to set TDBGrid columns layout: column visibility, column
    ///   width and display column title. Layout definition is provided
    ///   through JSON array.
    /// </summary>
    /// <exception cref="EJSONProcessing">
    ///   Exception <b>EJSONProcessing</b> is thrown when then passed JSON
    ///   array has unexpected structure.
    /// </exception>
    /// <remarks>
    ///   Parameter <b>aStoredColumns</b> is JSON array contains JSON
    ///   objects and each of them can has following fields:
    ///   <b>fieldname</b> - name of DataSet field displayed in this column.
    ///   <b>title</b> - title of the column displayed in header.
    ///   <b>width</b> - column width in pixels (numeric value).
    ///   <b>visible</b> - column visibility (boolean value)
    /// </remarks>
    procedure LoadColumnsFromJson(aStoredColumns: TJSONArray);
    /// <summary>
    ///   Allows to set TDBGrid columns layout: column visibility, column
    ///   width and column title. Layout definition is provided through
    ///   string parameter which contains valid JSON array.
    /// </summary>
    /// <exception cref="EJSONProcessing">
    ///   Exception <b>EJSONProcessing</b> is thrown when string parameter
    ///   contains not valid JSON text or JSONArray stored there has
    ///   unexpected structure.
    /// </exception>
    /// <remarks>
    ///   Parameter <b>aJsonString</b> is well formatted JSON array stored
    ///   in String. This JSON array has contain JSON objects with following
    ///   fields:
    ///   <b>fieldname</b> - name of DataSet field displayed in this column.
    ///   <b>title</b> - title of the column displayed in header.
    ///   <b>width</b> - column width in pixels (numeric value).
    ///   <b>visible</b> - column visibility (boolean value)
    /// </remarks>
    procedure LoadColumnsFromJsonString(const aJsonString: string);
    /// <summary>
    ///   Saves TDBGrid columns layout into string formatted in JSON.
    ///   Result is JSON array includes JSON objects (each one for one the 
    ///   TBGrid column). This object contains: column field name, title, 
    ///   width and visibility. JSON data format is compatible with method
    ///   loading DBGrid columns.
    /// </summary>
    function SaveColumnsToString: string;
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


// ------------------------------------------------------------------------
// TJSONObjectEx - Exteded methods to TJSONObject
// ------------------------------------------------------------------------

type
  TJSONObjectProcessor = class
  private
    fJsonObject: TJSONObject;
  public
    constructor Create(aJsonObject: TJSONObject);
    function GetValueString(const key: string): string;
    function GetValueBoolen(const key: string; deafultValue: boolean): boolean;
    function GetValueInteger(const key: string): Variant;
    procedure NormalizeCase();
  end;

constructor TJSONObjectProcessor.Create(aJsonObject: TJSONObject);
begin
  fJsonObject := aJsonObject;
end;

function TJSONObjectProcessor.GetValueString(const key: string): string;
var
  jv: TJSONValue;
begin
  jv := fJsonObject.Values[key];
  if (jv = nil) or (jv.Null) then
    Result := ''
  else
    Result := jv.Value;
end;

function TJSONObjectProcessor.GetValueBoolen(const key: string;
  deafultValue: boolean): boolean;
var
  jv: TJSONValue;
begin
  jv := fJsonObject.Values[key];
  if (jv <> nil) and not(jv is TJSONBool) then
    raise EJSONProcessing.Create
      (Format('Expected boolean value in JSON object for key:"%s"', [key]));
  if (jv = nil) or (jv.Null) then
    Result := deafultValue
  else
    Result := (jv is TJSONTrue);
end;

function TJSONObjectProcessor.GetValueInteger(const key: string): Variant;
var
  jv: TJSONValue;
begin
  jv := fJsonObject.Values[key];
  if (jv <> nil) and not(jv is TJSONNumber) then
    raise EJSONProcessing.Create
      (Format('Expected number value in JSON object for key:"%s"', [key]));
  if (jv = nil) or (jv.Null) then
    Result := System.Variants.Null()
  else
    Result := (jv as TJSONNumber).AsInt;
end;

procedure TJSONObjectProcessor.NormalizeCase();
var
  aPair: TJSONPair;
  sLowerKey: string;
begin
  for aPair in fJsonObject do
  begin
    sLowerKey := LowerCase(aPair.JsonString.Value);
    if sLowerKey <> aPair.JsonString.Value then
    begin
      if not aPair.JsonString.Owned then
        aPair.JsonString.Free;
      aPair.JsonString := TJSONString.Create(sLowerKey);
    end;
  end;
end;

// ------------------------------------------------------------------------

procedure TDBGridHelper.LoadColumnsFromJson(aStoredColumns: TJSONArray);
var
  i: integer;
  jsObjProcessor: TJSONObjectProcessor;
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
    jsObjProcessor := TJSONObjectProcessor.Create
      (aStoredColumns.Items[i] as TJSONObject);
    jsObjProcessor.NormalizeCase();
    aFieldName := jsObjProcessor.GetValueString('fieldname');
    aColumnTitle := jsObjProcessor.GetValueString('title');
    aVisible := jsObjProcessor.GetValueBoolen('visible', True);
    aWidth := jsObjProcessor.GetValueInteger('width');
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
    self.LoadColumnsFromJson(jsColumns);
  finally
    jsValue.Free;
  end;
end;

function TDBGridHelper.SaveColumnsToString: string;
var
  aColumn: TColumn;
  i: integer;
  sJson: string;
begin
  sJson := '';
  for i := 0 to self.Columns.Count - 1 do
  begin
    aColumn := self.Columns[i];
    if i > 0 then
      sJson := sJson + ',';
    sJson := sJson +
      Format('{"fieldname":"%s", "title":"%s", "width":%d, "visible":true}',
      [aColumn.FieldName, aColumn.Title.Caption, aColumn.Width]);
  end;
  Result := '[' + sJson + ']';
end;

end.

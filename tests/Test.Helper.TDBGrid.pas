unit Test.Helper.TDBGrid;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.JSON,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.DBGrids,
  Data.DB,
  Datasnap.DBClient,

  Helper.TDBGrid;

{$M+}

type

  [TestFixture]
  TestTDBGridHelper = class(TObject)
  private
    fForm: TForm;
    fDBGrid: TDBGrid;
    function GivenEmptyDataset(aOwner: TComponent): TDataSet;
    function GivenDataSet_WithOneCity(aOwner: TComponent): TDataSet;
    procedure AddColumn(const aFieldName, aTitle: string; aWidth: integer);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure DeviceDPI;
    procedure AutoSizeColumns_TextColumn;
    procedure AutoSizeColumns_KeepsSameRowPosition;
    procedure AutoSizeColumns_CurrencyColumn;
    procedure LoadColumns_TwoColumns;
    procedure LoadColumns_OneFieldInvalid;
    procedure LoadColumns_TwoColumnsWithCaption;
    procedure LoadColumns_SecondColumnWithoutField;
    procedure LoadColumns_ThreeColumnsAndOneInvible;
    procedure LoadColumns_TwoColumnsWidth;
    procedure LoadColumns_LoadFromJson;
    procedure LoadColumns_CaseBug;
    procedure SaveColumns_OneColumn;
    procedure SaveColumns_TwoColumns;
  end;

implementation

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestTDBGridHelper.Setup;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm, fForm);
  fForm.Name := 'MainForm';
  fForm.Caption := 'Main Form';
  fDBGrid := TDBGrid.Create(fForm);
  with fDBGrid do
  begin
    Align := alClient;
    Parent := fForm;
    DataSource := TDataSource.Create(fForm);
  end;
end;

procedure TestTDBGridHelper.TearDown;
begin
  fForm.Free;
end;

// -----------------------------------------------------------------------
// Utilities
// -----------------------------------------------------------------------

function TestTDBGridHelper.GivenEmptyDataset(aOwner: TComponent): TDataSet;
var
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(aOwner);
  with cds do
  begin
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('city', ftWideString, 30);
    FieldDefs.Add('rank', ftInteger);
    FieldDefs.Add('visited', ftDateTime);
    FieldDefs.Add('budget', ftCurrency);
    CreateDataSet;
  end;
  Result := cds;
end;

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTDBGridHelper.DeviceDPI;
var
  aDataSet: TDataSet;
  expectColumn2Width: integer;
begin
  aDataSet := GivenEmptyDataset(fForm);
  aDataSet.AppendRecord([1, 'Edinburgh', EncodeDate(2013, 06, 21)]);
  fDBGrid.DataSource.DataSet := aDataSet;

  // no Act session - just asserting device dpi

  // Column with in pixels is device dependent (dpi)
  // requires more investigation how to tes this in more device independent way
  expectColumn2Width := 184; // px -
  Assert.AreEqual(expectColumn2Width, fDBGrid.Columns.Items[1].Width);
end;

procedure TestTDBGridHelper.AutoSizeColumns_TextColumn;
var
  aDataSet: TDataSet;
begin
  aDataSet := GivenEmptyDataset(fForm);
  aDataSet.AppendRecord([1, 'Edinburgh', 7, EncodeDate(2013, 06, 21)]);
  fDBGrid.DataSource.DataSet := aDataSet;

  fDBGrid.AutoSizeColumns();

  Assert.AreEqual(57{px}, fDBGrid.Columns.Items[1].Width);
end;

procedure TestTDBGridHelper.AutoSizeColumns_KeepsSameRowPosition;
var
  aDataSet: TDataSet;
begin
  aDataSet := GivenEmptyDataset(fForm);
  aDataSet.AppendRecord([1, 'Edinburgh', 7, EncodeDate(2013, 06, 21)]);
  aDataSet.AppendRecord([2, 'Glassgow', 4, EncodeDate(2015, 09, 13)]);
  aDataSet.AppendRecord([3, 'Cracow', 6, EncodeDate(2019, 01, 01)]);
  aDataSet.AppendRecord([4, 'Prague', 4, EncodeDate(2013, 06, 21)]);
  aDataSet.Locate('id', 3, []);
  fDBGrid.DataSource.DataSet := aDataSet;

  fDBGrid.AutoSizeColumns();

  Assert.AreEqual('Cracow', aDataSet.FieldByName('city').AsString);
end;

procedure TestTDBGridHelper.AutoSizeColumns_CurrencyColumn;
var
  aDataSet: TDataSet;
  fBudgetField: TCurrencyField;
begin
  FormatSettings := TFormatSettings.Create('en-GB');
  aDataSet := GivenEmptyDataset(fForm);
  aDataSet.AppendRecord([1, 'Edinburgh', 7, TDateTime(0), 125.99]);
  fDBGrid.DataSource.DataSet := aDataSet;
  fBudgetField := aDataSet.FieldByName('budget') as TCurrencyField;

  fDBGrid.AutoSizeColumns();

  // 49{px} = fForm.Canvas.TextWidth ('£125.99' + fDBGrid.SufixForAdditionalColumnWidth);
  Assert.AreEqual(49{px}, fDBGrid.Columns.Items[4].Width);
end;

// -----------------------------------------------------------------------
// Tests for LoadColumns
// -----------------------------------------------------------------------

function TestTDBGridHelper.GivenDataSet_WithOneCity(aOwner: TComponent)
  : TDataSet;
var
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(aOwner);
  with cds do
  begin
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('city', ftWideString, 30);
    FieldDefs.Add('rank', ftInteger);
    FieldDefs.Add('visited', ftDateTime);
    FieldDefs.Add('budget', ftCurrency);
    CreateDataSet;
  end;
  cds.AppendRecord([1, 'Edinburgh', 7, EncodeDate(2013, 06, 21), 1250]);
  Result := cds;
end;

procedure TestTDBGridHelper.LoadColumns_TwoColumns;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);

  fDBGrid.LoadColumnsFromJsonString('[' //.
    + '  {"fieldname":"id"}' //.
    + ', {"fieldname":"visited"} ' //.
    + ']');

  Assert.AreEqual('id', fDBGrid.Columns.Items[0].FieldName);
  Assert.AreEqual('visited', fDBGrid.Columns.Items[1].FieldName);
end;

procedure TestTDBGridHelper.LoadColumns_OneFieldInvalid;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);

  fDBGrid.LoadColumnsFromJsonString('[' //.
    + '  {"fieldname":"id"}' //.
    + ', {"fieldname":"ciiiity"} ' // invalid column name
    + ']');

  Assert.AreEqual(1, fDBGrid.Columns.Count);
end;

procedure TestTDBGridHelper.LoadColumns_TwoColumnsWithCaption;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);

  fDBGrid.LoadColumnsFromJsonString('[' //.
    + '  {"fieldname":"id", "title":"CityID"}' //.
    + ', {"fieldname":"city", "title":"City name"} ' //.
    + ']');

  Assert.AreEqual('City name', fDBGrid.Columns.Items[1].Title.Caption);
end;

procedure TestTDBGridHelper.LoadColumns_SecondColumnWithoutField;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);

  fDBGrid.LoadColumnsFromJsonString('[' //.
    + '  {"fieldname":"id", "title":"CityID"}' //.
    + ', {"title":"User column"} ' //.
    + ']');

  Assert.AreEqual(2, fDBGrid.Columns.Count);
end;

procedure TestTDBGridHelper.LoadColumns_ThreeColumnsAndOneInvible;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);

  fDBGrid.LoadColumnsFromJsonString('[' //.
    + '  {"fieldname":"id", "title":"CityID", "visible":true}' //.
    + ', {"fieldname":"city", "title":"City name", "visible":false} ' //.
    + ', {"fieldname":"budget", "title":"City Budget"} ' //.
    + ']');

  Assert.AreEqual(false, fDBGrid.Columns.Items[1].Visible);
end;

procedure TestTDBGridHelper.LoadColumns_TwoColumnsWidth;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);

  fDBGrid.LoadColumnsFromJsonString('[' //.
    + '  {"fieldname":"id", "width":90}' //.
    + ', {"fieldname":"city", "width":250} ' //.
    + ']');

  Assert.AreEqual(250, fDBGrid.Columns.Items[1].Width);
end;

procedure TestTDBGridHelper.LoadColumns_LoadFromJson;
var
  sColumns: String;
  jsColumns: TJSONArray;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);
  sColumns := '[' //.
    + '  {"fieldname":"id", "title":"CityID", "width":90, "visible":true}' //.
    + ', {"fieldname":"city", "title":"City name", "width":160, "visible":false} '
    + ', {"fieldname":"rank", "title":"Rank", "width":80, "visible":false} ' //.
    + ', {"fieldname":"visited", "title":"Last time visited", "width":120} ' //.
    + ', {"fieldname":"budget", "title":"City Budget", "width":100} ' //.
    + ', {"title":"Budget Graph", "width":280} ' //.
    + ']';
  jsColumns := TJSONObject.ParseJSONValue(sColumns) as TJSONArray;

  fDBGrid.LoadColumnsFromJson(jsColumns);
  jsColumns.Free;

  Assert.AreEqual(6, fDBGrid.Columns.Count);
  Assert.AreEqual('id', fDBGrid.Columns.Items[0].Field.FieldName);
  Assert.AreEqual('City name', fDBGrid.Columns.Items[1].Title.Caption);
  Assert.AreEqual(false, fDBGrid.Columns.Items[2].Visible);
  Assert.AreEqual(120, fDBGrid.Columns.Items[3].Width);
end;

procedure TestTDBGridHelper.LoadColumns_CaseBug;
var
  sColumns: String;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);
  sColumns := '[' //.
    + '  {"fieldName":"id", "TITLE":"CityID", "Width":90}' //.
    + ']';

  fDBGrid.LoadColumnsFromJsonString(sColumns);

  Assert.AreEqual(1, fDBGrid.Columns.Count);
  Assert.AreEqual('id', fDBGrid.Columns.Items[0].Field.FieldName);
  Assert.AreEqual('CityID', fDBGrid.Columns.Items[0].Title.Caption);
  Assert.AreEqual(90, fDBGrid.Columns.Items[0].Width);
end;

// ------------------------------------------------------------------------
// Utils - Save TDBGrid Columns
// ------------------------------------------------------------------------

procedure TestTDBGridHelper.AddColumn(const aFieldName: string;
  const aTitle: string; aWidth: integer);
var
  col: TColumn;
begin
  col := fDBGrid.Columns.Add;
  if aFieldName <> '' then
    col.FieldName := aFieldName;
  if aTitle <> '' then
    col.Title.Caption := aTitle;
  if aWidth > 0 then
    col.Width := aWidth;
end;

// ------------------------------------------------------------------------
// Tests - Save TDBGrid Columns
// ------------------------------------------------------------------------

procedure TestTDBGridHelper.SaveColumns_OneColumn;
var
  sExpectedColumns: string;
  sActualColumns: string;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);
  fDBGrid.Columns.Clear;
  AddColumn('city', '', 100);

  sActualColumns := fDBGrid.SaveColumnsToString;

  sExpectedColumns := '[' +
    '{"fieldname":"city", "title":"city", "width":100, "visible":true}]';
  Assert.AreEqual(sExpectedColumns, sActualColumns);
end;

procedure TestTDBGridHelper.SaveColumns_TwoColumns;
var
  sExpectedColumns: string;
  sActualColumns: string;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);
  fDBGrid.Columns.Clear;
  AddColumn('city', '', 100);
  AddColumn('visited', 'Last visit', 60);

  sActualColumns := fDBGrid.SaveColumnsToString;

  sExpectedColumns := '[' +
    '{"fieldname":"city", "title":"city", "width":100, "visible":true}' +
    ',{"fieldname":"visited", "title":"Last visit", "width":60, "visible":true}'
    + ']';
  Assert.AreEqual(sExpectedColumns, sActualColumns);
end;

initialization

TDUnitX.RegisterTestFixture(TestTDBGridHelper);

end.

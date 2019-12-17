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
    procedure LoadColumnsFromString(aDBGrid: TDBGrid; const sColumns: string);
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
  expectColumn2Width: Integer;
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
  expectedWidth: Integer;
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
begin
  Result := GivenEmptyDataset(aOwner);
  Result.AppendRecord([1, 'Edinburgh', 7, EncodeDate(2013, 06, 21), 1250]);
end;

procedure TestTDBGridHelper.LoadColumnsFromString(aDBGrid: TDBGrid;
  const sColumns: string);
var
  jsColumns: TJSONArray;
begin
  jsColumns := TJSONObject.ParseJSONValue(sColumns) as TJSONArray;
  try
    aDBGrid.LoadColumnsFromJson(jsColumns);
  finally
    jsColumns.Free;
  end;
end;

procedure TestTDBGridHelper.LoadColumns_TwoColumns;
var
  aDataSet: TDataSet;
begin
  fDBGrid.DataSource.DataSet := GivenDataSet_WithOneCity(fForm);

  LoadColumnsFromString(fDBGrid, '[' //.
  +'  {"fieldName":"id"}' //.
  +', {"fieldName":"visited"} ' //.
  +']');

  Assert.AreEqual('id', fDBGrid.Columns.Items[0].FieldName);
  Assert.AreEqual('visited', fDBGrid.Columns.Items[1].FieldName);
end;

initialization

TDUnitX.RegisterTestFixture(TestTDBGridHelper);

end.

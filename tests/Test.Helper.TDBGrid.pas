unit Test.Helper.TDBGrid;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
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
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure DeviceDPI;
    procedure AutoSizeColumns_TextColumn;
    procedure AutoSizeColumns_KeepsSameRowPosition;
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
  with fDBGrid do begin
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

function TestTDBGridHelper.GivenEmptyDataset(aOwner:TComponent): TDataSet;
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
  Result :=  cds;
end;

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTDBGridHelper.DeviceDPI;
var
  aDataSet: TDataSet;
  expectColumn2Widht: Integer;
begin
  aDataSet := GivenEmptyDataset(fForm);
  aDataset.AppendRecord([1, 'Edinburgh', EncodeDate(2013, 06, 21)]);
  fDBGrid.DataSource.DataSet := aDataSet;

  // no Act session - just asserting device dpi

  // Column with in pixels is device dependent (dpi)
  // requires more investigation how to tes this in more device independent way
  expectColumn2Widht := 184;  // px -
  Assert.AreEqual(expectColumn2Widht,fDBGrid.Columns.Items[1].Width);
end;

procedure TestTDBGridHelper.AutoSizeColumns_TextColumn;
var
  aDataSet: TDataSet;
begin
  aDataSet := GivenEmptyDataset(fForm);
  aDataset.AppendRecord([1, 'Edinburgh', EncodeDate(2013, 06, 21)]);
  fDBGrid.DataSource.DataSet := aDataSet;

  fDBGrid.AutoSizeColumns();

  Assert.AreEqual(57{px},fDBGrid.Columns.Items[1].Width);
end;

procedure TestTDBGridHelper.AutoSizeColumns_KeepsSameRowPosition;
var
  aDataSet: TDataSet;
begin
  aDataSet := GivenEmptyDataset(fForm);
  aDataset.AppendRecord([1, 'Edinburgh', EncodeDate(2013, 06, 21)]);
  aDataset.AppendRecord([2, 'Glassgow', 4, EncodeDate(2015, 09, 13)]);
  aDataset.AppendRecord([3, 'Cracow', 6, EncodeDate(2019, 01, 01)]);
  aDataset.AppendRecord([4, 'Prague', 4, EncodeDate(2013, 06, 21)]);
  aDataset.Locate('id',3,[]);
  fDBGrid.DataSource.DataSet := aDataSet;

  fDBGrid.AutoSizeColumns();

  Assert.AreEqual('Cracow',aDataset.FieldByName('city').AsString);
end;

initialization

TDUnitX.RegisterTestFixture(TestTDBGridHelper);

end.

unit Test.Helper.TDataSet;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.JSON,
  Data.DB,
  Datasnap.DBClient,

  Helper.TDataSet;

{$M+}

type

  [TestFixture]
  TestTDataSetHelper = class(TObject)
  private
    fDataset: TClientDataSet;
    procedure BuildDataSet1;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure GetMaxIntegerValue_546;
    procedure ForEachRowVisitedDates;
  end;

implementation

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestTDataSetHelper.Setup;
begin
  fDataset := TClientDataSet.Create(nil);
end;

procedure TestTDataSetHelper.TearDown;
begin
  fDataset.Close;
end;

// -----------------------------------------------------------------------
// Utilities
// -----------------------------------------------------------------------

procedure TestTDataSetHelper.BuildDataSet1;
begin
  with fDataset do
  begin
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('city', ftWideString, 30);
    FieldDefs.Add('rank', ftInteger);
    FieldDefs.Add('visited', ftDateTime);
    CreateDataSet;
  end;
end;

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTDataSetHelper.GetMaxIntegerValue_546;
var
  aMaxValue: Integer;
begin
  // Arrange
  BuildDataSet1;
  fDataset.AppendRecord([1, 'Edynburgh', 5]);
  fDataset.AppendRecord([2, 'Glassgow', 4]);
  fDataset.AppendRecord([3, 'Cracow', 6]);
  fDataset.First;
  // Act
  aMaxValue := fDataset.GetMaxIntegerValue('rank');
  // Assert
  Assert.AreEqual(6, aMaxValue);
end;

procedure TestTDataSetHelper.ForEachRowVisitedDates;
var
  visitedField: TDateTimeField;
  s: string;
begin
  // Arrange
  BuildDataSet1;
  // .   GivenDataSetWithFourVisitedCities
  fDataset.AppendRecord([1, 'Edynburgh', 5, EncodeDate(2018, 05, 28)]);
  fDataset.AppendRecord([2, 'Glassgow', 4, EncodeDate(2015, 09, 13)]);
  fDataset.AppendRecord([3, 'Cracow', 6, EncodeDate(2019, 01, 01)]);
  fDataset.AppendRecord([4, 'Prague', 4, EncodeDate(2013, 06, 21)]);
  visitedField := fDataset.FieldByName('visited') as TDateTimeField;
  fDataset.First;
  s := '';
  // Act
  fDataset.ForEachRow(
    procedure
    begin
      s := s + FormatDateTime('yyyy-mm', visitedField.Value)+' '
    end);
  // Assert
  Assert.AreEqual ('2018-05 2015-09 2019-01 2013-06 ',s);
end;

initialization

TDUnitX.RegisterTestFixture(TestTDataSetHelper);

end.

unit Test.Helper.TDataSet;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
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
    procedure LoadData_OneCity_NoAttributes;
    procedure LoadData_OneCity_Mapped;
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
  fDataset.AppendRecord([1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]);
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
      s := s + FormatDateTime('yyyy-mm', visitedField.Value) + ' '
    end);
  // Assert
  Assert.AreEqual('2018-05 2015-09 2019-01 2013-06 ', s);
end;

type
  TCityForDataset = class
  public
    id: Integer;
    city: string;
    rank: Integer;
    visited: TDateTime;
  end;

procedure TestTDataSetHelper.LoadData_OneCity_NoAttributes;
var
  cities: TObjectList<TCityForDataset>;
begin
  BuildDataSet1;
  fDataset.AppendRecord([1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]);
  fDataset.First;

  cities := fDataset.LoadData<TCityForDataset>();

  Assert.AreEqual(1, cities.Count);
  Assert.AreEqual(1, cities[0].id);
  Assert.AreEqual('Edinburgh', cities[0].city);
  Assert.AreEqual(5, cities[0].rank);
  Assert.AreEqual(EncodeDate(2018, 05, 28), cities[0].visited);
  cities.Free;
end;

type
  TMyCity = class
  public
    [MapedToField('id')]
    cityId: Integer;
    [MapedToField('city')]
    cityName: string;
    [MapedToField('rank')]
    rank: Integer;
    [MapedToField('visited')]
    visitDate: TDateTime;
  end;

procedure TestTDataSetHelper.LoadData_OneCity_Mapped;
var
  cities: TObjectList<TMyCity>;
begin
  BuildDataSet1;
  fDataset.AppendRecord([1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]);
  fDataset.First;

  cities := fDataset.LoadData<TMyCity>();

  Assert.AreEqual(1, cities.Count);
  Assert.AreEqual(1, cities[0].cityId);
  Assert.AreEqual('Edinburgh', cities[0].cityName);
  Assert.AreEqual(5, cities[0].rank);
  Assert.AreEqual(EncodeDate(2018, 05, 28), cities[0].visitDate);
  cities.Free;
end;

initialization

TDUnitX.RegisterTestFixture(TestTDataSetHelper);

end.

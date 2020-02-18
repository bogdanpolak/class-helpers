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
    procedure BuildDataSet_VisitedCities;
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
    procedure LoadData_OneCity_InvalidMapping;
    procedure AppendRows_CheckCountRows;
    procedure AppendRows_CheckFields;
    procedure AppendRows_WillRise_InvalidNumericValue;
    procedure AppendRows_WillRise_MissingRequired;
  end;

implementation

uses
  Attribute.MappedToField;

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

procedure TestTDataSetHelper.BuildDataSet_VisitedCities;
begin
  with fDataset do
  begin
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('city', ftWideString, 30);
    FieldDefs.Add('rank', ftInteger);
    FieldDefs.Add('visited', ftDateTime);
    FieldDefs[0].Required := True;
    FieldDefs[1].Required := True;
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
  BuildDataSet_VisitedCities;
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
  BuildDataSet_VisitedCities;
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
    City: string;
    Rank: Integer;
    visited: TDateTime;
  end;

procedure TestTDataSetHelper.LoadData_OneCity_NoAttributes;
var
  cities: TObjectList<TCityForDataset>;
begin
  BuildDataSet_VisitedCities;
  fDataset.AppendRecord([1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]);
  fDataset.First;

  cities := fDataset.LoadData<TCityForDataset>();

  Assert.AreEqual(1, cities.Count);
  Assert.AreEqual(1, cities[0].id);
  Assert.AreEqual('Edinburgh', cities[0].City);
  Assert.AreEqual(5, cities[0].Rank);
  Assert.AreEqual(EncodeDate(2018, 05, 28), cities[0].visited);
  cities.Free;
end;

type
  TMyCity = class
  public
    [MappedToField('id')]
    cityId: Integer;
    [MappedToField('city')]
    cityName: string;
    [MappedToField('rank')]
    Rank: Integer;
    [MappedToField('visited')]
    visitDate: TDateTime;
  end;

procedure TestTDataSetHelper.LoadData_OneCity_Mapped;
var
  cities: TObjectList<TMyCity>;
begin
  BuildDataSet_VisitedCities;
  fDataset.AppendRecord([1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]);
  fDataset.First;

  cities := fDataset.LoadData<TMyCity>();

  Assert.AreEqual(1, cities.Count);
  Assert.AreEqual(1, cities[0].cityId, '(assert: CityId)');
  Assert.AreEqual('Edinburgh', cities[0].cityName);
  Assert.AreEqual(5, cities[0].Rank);
  Assert.AreEqual(EncodeDate(2018, 05, 28), cities[0].visitDate);
  cities.Free;
end;

type
  TInvalidCity = class
  public
    [MappedToField('cityName')]
    cityName: string;
  end;

procedure TestTDataSetHelper.LoadData_OneCity_InvalidMapping;
var
  cities: TObjectList<TInvalidCity>;
begin
  BuildDataSet_VisitedCities;
  fDataset.AppendRecord([1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]);
  fDataset.First;

  Assert.WillRaise(
    procedure
    begin
      try
        cities := fDataset.LoadData<TInvalidCity>();
      finally
        cities.Free;
      end;
    end, EInvalidMapping);
end;

procedure TestTDataSetHelper.AppendRows_CheckCountRows;
begin
  BuildDataSet_VisitedCities;

  fDataset.AppendRows([
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)],
  { } [2, 'Glassgow', 4, EncodeDate(2015, 09, 13)],
  { } [3, 'Cracow', 6, EncodeDate(2019, 01, 01)],
  { } [4, 'Prague', 4, EncodeDate(2013, 06, 21)]]);

  Assert.AreEqual(4, fDataset.RecNo);
end;

procedure TestTDataSetHelper.AppendRows_CheckFields;
begin
  BuildDataSet_VisitedCities;

  fDataset.AppendRows([[1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]]);

  Assert.AreEqual('Edinburgh', fDataset.FieldByName('City').AsString);
  Assert.AreEqual(5, fDataset.FieldByName('rank').AsInteger);
  Assert.AreEqual(EncodeDate(2018, 5, 28), fDataset.FieldByName('visited')
    .AsDateTime);
end;

procedure TestTDataSetHelper.AppendRows_WillRise_InvalidNumericValue;
begin
  BuildDataSet_VisitedCities;

  Assert.WillRaise(
    procedure
    begin
      fDataset.AppendRows([[1, 'A', 5], [2, 'B', 'invalid numebr'],
        [3, 'C', 6]]);
    end, EDatabaseError);
end;

procedure TestTDataSetHelper.AppendRows_WillRise_MissingRequired;
begin
  BuildDataSet_VisitedCities;

  Assert.WillRaise(
    procedure
    begin
      fDataset.AppendRows([[1, 'A', 5], [2], [3, 'C', 6]]);
    end, EDatabaseError);
end;

initialization

TDUnitX.RegisterTestFixture(TestTDataSetHelper);

end.

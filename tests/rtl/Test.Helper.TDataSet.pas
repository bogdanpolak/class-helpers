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
    // --
    procedure LoadData_OneCity_NoAttributes;
    procedure LoadData_OneCity_Mapped;
    procedure LoadData_OneCity_InvalidMapping;
    // --
    procedure LoadData_WithBlob;
    procedure LoadData_UsingAttributes_WithBlob;
    // --
    procedure SaveData_WhenLoadAndChangeOneItem;
    // --
    procedure AppendRows_CheckCountRows;
    procedure AppendRows_CheckFields;
    procedure AppendRows_WillRise_InvalidNumericValue;
    procedure AppendRows_WillRise_MissingRequired;
  end;

implementation

uses
  Attribute.MappedToDBField;

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
    FieldDefs.Add('blob', ftBlob);
    FieldDefs[0].Required := True;
    FieldDefs[1].Required := True;
    CreateDataSet;
    FieldByName('id').ProviderFlags := [pfInKey, pfInWhere, pfInUpdate]
  end;
end;

procedure WriteStringToBlob(aDataSet: TDataSet; const aFieldName: string;
  const aContent: string);
var
  ss: TStringStream;
  isBrowse: boolean;
begin
  ss := TStringStream.Create(aContent, TEncoding.UTF8);
  try
    isBrowse := (aDataSet.State = dsBrowse);
    aDataSet.Edit;
    (aDataSet.FieldByName(aFieldName) as TBlobField).Value := ss.Bytes;
    if isBrowse then
      aDataSet.Post;
  finally
    ss.Free;
  end;
end;

function StringAsUtf8Bytes(const s: string): TBytes;
var
  ss: TStringStream;
begin
  ss := TStringStream.Create(s, TEncoding.UTF8);
  Result := ss.Bytes;
  ss.Free;
end;

// -----------------------------------------------------------------------
// TBytes helper
// -----------------------------------------------------------------------

type
  TBytesHelper = record helper for TBytes
    function AsUtf8String(): String;
  end;

function TBytesHelper.AsUtf8String(): String;
var
  ss: TStringStream;
begin
  ss := TStringStream.Create('', TEncoding.UTF8);
  ss.Write(self[0], Length(self));
  Result := ss.DataString;
  ss.Free;
end;

// -----------------------------------------------------------------------
// Tests: GetMaxIntegerValue, ForEachRow
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

// -----------------------------------------------------------------------
// Tests: LoadData   - (no blobs)
// -----------------------------------------------------------------------

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
    [MappedToDBField('id')]
    cityId: Integer;
    [MappedToDBField('city')]
    cityName: string;
    [MappedToDBField('rank')]
    Rank: Integer;
    [MappedToDBField('visited')]
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
    [MappedToDBField('cityName')]
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
    end, EDataMapperError);
end;

// -----------------------------------------------------------------------
// Tests: LoadData - with blob field
// -----------------------------------------------------------------------

type
  TBlobCity = class
  public
    id: Integer;
    City: string;
    blob: TBytes;
  end;

procedure TestTDataSetHelper.LoadData_WithBlob();
var
  citiesWithBlob: TObjectList<TBlobCity>;
begin
  BuildDataSet_VisitedCities;
  fDataset.AppendRecord([1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]);
  WriteStringToBlob(fDataset, 'blob', 'Sample: русский алфавит');
  fDataset.First;
  citiesWithBlob := fDataset.LoadData<TBlobCity>();
  Assert.AreEqual(1, citiesWithBlob.Count);
  Assert.AreEqual('Sample: русский алфавит',
    citiesWithBlob[0].blob.AsUtf8String);
  citiesWithBlob.Free;
end;

type
  TBlobCityWithAttributes = class
  private
    [MappedToDBField('city')]
    fName: string;
    [MappedToDBField('blob')]
    fBinaryDetails: TBytes;
  public
    property Name: string read fName;
    property BinaryDetails: TBytes read fBinaryDetails;
  end;

procedure TestTDataSetHelper.LoadData_UsingAttributes_WithBlob();
var
  cities: TObjectList<TBlobCityWithAttributes>;
begin
  BuildDataSet_VisitedCities;
  fDataset.AppendRecord([1, 'Moscow', 7, EncodeDate(2015, 07, 11)]);
  WriteStringToBlob(fDataset, 'blob', 'Russian: русский алфавит');
  fDataset.AppendRecord([1, 'Warsaw', 6, EncodeDate(2011, 10, 02)]);
  WriteStringToBlob(fDataset, 'blob', 'Polish: zażółć gęślą jaźń');
  fDataset.First;
  cities := fDataset.LoadData<TBlobCityWithAttributes>();
  Assert.AreEqual(2, cities.Count);
  Assert.AreEqual('Russian: русский алфавит',
    cities[0].BinaryDetails.AsUtf8String);
  Assert.AreEqual('Polish: zażółć gęślą jaźń',
    cities[1].BinaryDetails.AsUtf8String);
  cities.Free;
end;

// -----------------------------------------------------------------------
// Tests:  SaveData
// -----------------------------------------------------------------------

type
  TCity = class
  public
    Id: Integer;
    City: string;
    Rank: Integer;
    Visited: TDateTime;
    Blob: TBytes;
    IsChanged: boolean;
  end;

procedure TestTDataSetHelper.SaveData_WhenLoadAndChangeOneItem();
var
  cities: TObjectList<TCity>;
  changed: Integer;
  actual: string;
begin
  BuildDataSet_VisitedCities;
  fDataset.AppendRecord([1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]);
  fDataset.AppendRecord([2, 'Glassgow', 4, EncodeDate(2015, 09, 13)]);
  fDataset.AppendRecord([3, 'Cracow', 6, EncodeDate(2019, 01, 01)]);
  fDataset.AppendRecord([4, 'Prague', 4, EncodeDate(2013, 06, 21)]);
  fDataset.First;
  cities := fDataset.LoadData<TCity>();
  with cities[0] do
  begin
    Blob := StringAsUtf8Bytes('Polish: zażółć gęślą jaźń');
    IsChanged := True;
  end;
  with cities[1] do
  begin
    City := 'Moscow';
    Visited := EncodeDate(2020, 07, 29);
    IsChanged := True;
  end;
  with cities[3] do
  begin
    City := 'Brno';
    IsChanged := True;
  end;
  changed := fDataset.SaveData<TCity>(cities);
  Assert.AreEqual(3, changed);
  fDataset.Locate('Id', 2, []);
  Assert.AreEqual('Moscow', fDataset.FieldByName('city').AsString);
  Assert.AreEqual(EncodeDate(2020, 07, 29), fDataset.FieldByName('visited')
    .AsDateTime, 0.9);
  fDataset.Locate('Id', 4, []);
  Assert.AreEqual('Brno', fDataset.FieldByName('city').AsString);
  fDataset.Locate('Id', 1, []);
  actual := (fDataset.FieldByName('blob') as TBlobField).Value.AsUtf8String;
  Assert.AreEqual('Polish: zażółć gęślą jaźń', actual);
end;

// -----------------------------------------------------------------------
// Tests:  AppendRows
// -----------------------------------------------------------------------

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

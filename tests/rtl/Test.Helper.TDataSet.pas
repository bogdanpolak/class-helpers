unit Test.Helper.TDataSet;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  System.Variants,
  Data.DB,
  Datasnap.DBClient,

  Helper.TDataSet;

{$M+}

type

  [TestFixture]
  TestTDataSetHelper = class(TObject)
  private
    fOwner: TComponent;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure GetMaxIntegerValue_546;
    procedure ForEachRowVisitedDates;
    // --
    procedure LoadData_OneCity;
    procedure LoadData_OneCity_WithNulls;
    procedure LoadData_OneCity_Mapped;
    procedure LoadData_OneCity_InvalidMapping;
    // --
    procedure LoadData_WithBlob;
    procedure LoadData_UsingAttributes_WithBlob;
    // --
    procedure SaveData_ExceptionWhenIsChangedNotExist;
    procedure SaveData_WhenChangedOneObject;
    procedure SaveData_WhenFlagIs_HasBeenModified;
    procedure SaveData_AllCasesScenario();
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
  fOwner := TComponent.Create(nil);
end;

procedure TestTDataSetHelper.TearDown;
begin
  fOwner.Free;
end;

// -----------------------------------------------------------------------
// Utilities
// -----------------------------------------------------------------------

type
  TVariantArray = array of Variant;

function GivenDataSet(fOwner: TComponent; const Data: TArray<TVariantArray>)
  : TDataSet;
var
  dataset: TClientDataSet;
  idx: Integer;
  j: Integer;
begin
  dataset := TClientDataSet.Create(fOwner);
  with dataset do
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
  for idx := 0 to High(Data) do
  begin
    dataset.Append;
    for j := 0 to High(Data[idx]) do
      dataset.Fields[j].Value := Data[idx][j];
    dataset.Post;
  end;
  dataset.First;
  Result := dataset;
end;

// -----------------------------------------------------------------------
// Blob Utilities
// -----------------------------------------------------------------------

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
  dataset: TDataSet;
  actual: Integer;
begin
  dataset := GivenDataSet(fOwner, [
    { } [1, 'Edynburgh', 5],
    { } [2, 'Glassgow', 4],
    { } [3, 'Cracow', 6]]);
  actual := dataset.GetMaxIntegerValue('rank');
  Assert.AreEqual(6, actual);
end;

procedure TestTDataSetHelper.ForEachRowVisitedDates;
var
  dataset: TDataSet;
  actual: string;
begin
  dataset := GivenDataSet(fOwner, [
    { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)],
    { } [2, 'Glassgow', 4, EncodeDate(2015, 09, 13)],
    { } [3, 'Cracow', 6, EncodeDate(2019, 01, 01)],
    { } [4, 'Prague', 4, EncodeDate(2013, 06, 21)]]);
  actual := '';
  dataset.ForEachRow(
    procedure
    begin
      actual := actual + FormatDateTime('yyyy-mm',
        dataset.FieldByName('visited').AsDateTime) + ' '
    end);
  // Assert
  Assert.AreEqual('2018-05 2015-09 2019-01 2013-06 ', actual);
end;

// -----------------------------------------------------------------------
// Tests: LoadData   - (no blobs)
// -----------------------------------------------------------------------

type
  TCityForDataset = class
  public
    id: Integer;
    City: string;
    Rank: Variant; // Nullable<Integer>
    visited: Variant; // Nullable<TDateTime>
  end;

procedure TestTDataSetHelper.LoadData_OneCity;
var
  dataset: TDataSet;
  cities: TObjectList<TCityForDataset>;
begin
  dataset := GivenDataSet(fOwner, [
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]]);

  cities := dataset.LoadData<TCityForDataset>();

  Assert.AreEqual(1, cities.Count);
  Assert.AreEqual(1, cities[0].id);
  Assert.AreEqual('Edinburgh', cities[0].City);
  Assert.AreEqual(5, Integer(cities[0].Rank));
  Assert.AreEqual(EncodeDate(2018, 05, 28), TDateTime(cities[0].visited));
  cities.Free;
end;

procedure TestTDataSetHelper.LoadData_OneCity_WithNulls;
var
  dataset: TDataSet;
  cities: TObjectList<TCityForDataset>;
  cityEdi: TCityForDataset;
begin
  dataset := GivenDataSet(fOwner, [
  { } [1, 'Edinburgh', Null, Null]]);

  cities := dataset.LoadData<TCityForDataset>();
  cityEdi := cities[0];

  Assert.AreEqual(1, cities.Count);
  Assert.AreEqual(1, cityEdi.id);
  Assert.AreEqual('Edinburgh', cityEdi.City);
  Assert.AreEqual(Null, cityEdi.Rank);
  Assert.AreEqual(Null, cityEdi.visited);
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
  dataset: TDataSet;
  cities: TObjectList<TMyCity>;
begin
  dataset := GivenDataSet(fOwner, [
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]]);

  cities := dataset.LoadData<TMyCity>();

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
  dataset: TDataSet;
  cities: TObjectList<TInvalidCity>;
begin
  dataset := GivenDataSet(fOwner, [
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]]);

  Assert.WillRaise(
    procedure
    begin
      try
        cities := dataset.LoadData<TInvalidCity>();
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
  bytesRussian: TBytes;
  dataset: TDataSet;
  citiesWithBlob: TObjectList<TBlobCity>;
begin
  bytesRussian := StringAsUtf8Bytes('Sample: русский алфавит');
  dataset := GivenDataSet(fOwner, [
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28), bytesRussian]]);

  citiesWithBlob := dataset.LoadData<TBlobCity>();

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
  dataset: TDataSet;
  cities: TObjectList<TBlobCityWithAttributes>;
begin
  dataset := GivenDataSet(fOwner, [
  { } [1, 'Moscow', 7, EncodeDate(2015, 07, 11),
    StringAsUtf8Bytes('Russian: русский алфавит')],
  { } [2, 'Warsaw', 6, EncodeDate(2011, 10, 02),
    StringAsUtf8Bytes('Polish: zażółć gęślą jaźń')]]);

  cities := dataset.LoadData<TBlobCityWithAttributes>();

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
  TCity01 = class
  public
    id: Integer;
    City: string;
    IsChanged: boolean;
  end;

procedure TestTDataSetHelper.SaveData_WhenChangedOneObject();
var
  dataset: TDataSet;
  cities: TObjectList<TCity01>;
  changed: Integer;
begin
  dataset := GivenDataSet(fOwner, [
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]]);
  cities := dataset.LoadData<TCity01>();
  cities[0].City := 'Warsaw';
  cities[0].IsChanged := True;

  changed := dataset.SaveData<TCity01>(cities);

  Assert.AreEqual(1, changed);
  Assert.AreEqual('Warsaw', dataset.FieldByName('city').AsString);
  cities.Free;
end;

type
  TCity02 = class
  public
    id: Integer;
    City: string;
    HasBeenModified: boolean;
  end;

procedure TestTDataSetHelper.SaveData_ExceptionWhenIsChangedNotExist();
var
  dataset: TDataSet;
  cities: TObjectList<TCity02>;
  changed: Integer;
begin
  dataset := GivenDataSet(fOwner, [
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]]);
  cities := dataset.LoadData<TCity02>();

  Assert.WillRaise(
    procedure
    begin
      try
        changed := dataset.SaveData<TCity02>(cities);
      finally
        cities.Free;
      end;
    end, EDataMapperError);
end;

procedure TestTDataSetHelper.SaveData_WhenFlagIs_HasBeenModified();
var
  dataset: TDataSet;
  cities: TObjectList<TCity02>;
  changed: Integer;
begin
  dataset := GivenDataSet(fOwner, [
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]]);
  cities := dataset.LoadData<TCity02>();
  cities[0].City := 'New York';
  cities[0].HasBeenModified := True;

  changed := dataset.SaveData<TCity02>(cities, 'HasBeenModified');

  Assert.AreEqual(1, changed);
end;

type
  TCity03 = class
  private
    [MappedToDBField('Blob')]
    fBlob: TBytes;
  public
    Id: Integer;
    City: string;
    Rank: Integer;
    Visited: TDateTime;
    IsChanged: boolean;
    property Blob: TBytes read fBlob write fBlob;
  end;

procedure TestTDataSetHelper.SaveData_AllCasesScenario();
var
  dataset: TDataSet;
  cities: TObjectList<TCity03>;
  changed: Integer;
  actual: string;
begin
  dataset := GivenDataSet(fOwner, [[1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)
    ], [2, 'Glassgow', 4, EncodeDate(2015, 09, 13)], [3, 'Cracow', 6,
    EncodeDate(2019, 01, 01)], [4, 'Prague', 4, EncodeDate(2013, 06, 21)]]);
  cities := dataset.LoadData<TCity03>();
  with cities[0] do
  begin
    blob := StringAsUtf8Bytes('Polish: zażółć gęślą jaźń');
    IsChanged := True;
  end;
  with cities[1] do
  begin
    City := 'Moscow';
    visited := EncodeDate(2020, 07, 29);
    IsChanged := True;
  end;
  with cities[3] do
  begin
    City := 'Brno';
    IsChanged := True;
  end;

  changed := dataset.SaveData<TCity03>(cities);

  Assert.AreEqual(3, changed);
  dataset.Locate('Id', 2, []);
  Assert.AreEqual('Moscow', dataset.FieldByName('city').AsString);
  Assert.AreEqual(EncodeDate(2020, 07, 29), dataset.FieldByName('visited')
    .AsDateTime, 0.9);
  dataset.Locate('Id', 4, []);
  Assert.AreEqual('Brno', dataset.FieldByName('city').AsString);
  dataset.Locate('Id', 1, []);
  actual := (dataset.FieldByName('blob') as TBlobField).Value.AsUtf8String;
  Assert.AreEqual('Polish: zażółć gęślą jaźń', actual);
  cities.Free;
end;

// -----------------------------------------------------------------------
// Tests:  AppendRows
// -----------------------------------------------------------------------

procedure TestTDataSetHelper.AppendRows_CheckCountRows;
var
  dataset: TDataSet;
begin
  dataset := GivenDataSet(fOwner, []);

  dataset.AppendRows([
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)],
  { } [2, 'Glassgow', 4, EncodeDate(2015, 09, 13)],
  { } [3, 'Cracow', 6, EncodeDate(2019, 01, 01)],
  { } [4, 'Prague', 4, EncodeDate(2013, 06, 21)]]);

  Assert.AreEqual(4, dataset.RecNo);
end;

procedure TestTDataSetHelper.AppendRows_CheckFields;
var
  dataset: TDataSet;
begin
  dataset := GivenDataSet(fOwner, []);

  dataset.AppendRows([
  { } [1, 'Edinburgh', 5, EncodeDate(2018, 05, 28)]]);

  Assert.AreEqual('Edinburgh', dataset.FieldByName('City').AsString);
  Assert.AreEqual(5, dataset.FieldByName('rank').AsInteger);
  Assert.AreEqual(EncodeDate(2018, 5, 28), dataset.FieldByName('visited')
    .AsDateTime);
end;

procedure TestTDataSetHelper.AppendRows_WillRise_InvalidNumericValue;
var
  dataset: TDataSet;
begin
  dataset := GivenDataSet(fOwner, []);

  Assert.WillRaise(
    procedure
    begin
      dataset.AppendRows([
        { } [1, 'A', 5],
        { } [2, 'B', 'invalid numebr'],
        { } [3, 'C', 6]]);
    end, EDatabaseError);
end;

procedure TestTDataSetHelper.AppendRows_WillRise_MissingRequired;
var
  dataset: TDataSet;
begin
  dataset := GivenDataSet(fOwner, []);

  Assert.WillRaise(
    procedure
    begin
      dataset.AppendRows([
        { } [1, 'A', 5],
        { } [2],
        { } [3, 'C', 6]]);
    end, EDatabaseError);
end;

initialization

TDUnitX.RegisterTestFixture(TestTDataSetHelper);

end.

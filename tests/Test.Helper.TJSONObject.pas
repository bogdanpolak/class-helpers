unit Test.Helper.TJSONObject;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.JSON,

  Helper.TJSONObject;

{$M+}

type

  [TestFixture]
  TestTJSONObjectHelper = class(TObject)
  private
    fJsonObject: TJSONObject;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure IsAvaliable_ForExistingField;
    procedure IsNotAvaliable_ForNotExistingField;
    procedure IsValidIsoDate_ForVaildDate;
    procedure IsValidIsoDate_ForVaildDateTime;
    procedure IsValidIsoDate_ForInvalidDate;
    procedure IsValidIsoDate_ForTextValue;
    procedure IsValidIsoDate_ForNull;
    procedure GetFieldInt_ForNumber;
    procedure GetFieldInt_ForFloat;
    procedure GetFieldIsoDate_ForValidDate;
    procedure GetFieldOrEmpty_ForText;
    procedure GetFieldOrEmpty_ForNull;
    procedure Bug028_InvalidDecimalValueInIsoDate;
  end;

implementation

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestTJSONObjectHelper.Setup;
begin
  fJsonObject := TJSONObject.Create;
end;

procedure TestTJSONObjectHelper.TearDown;
begin
  fJsonObject.Free;
end;

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTJSONObjectHelper.IsAvaliable_ForExistingField;
var
  b: boolean;
begin
  // Arrange
  fJsonObject.AddPair('id', TJSONNumber.Create(1));
  fJsonObject.AddPair('city', 'Gdansk');
  fJsonObject.AddPair('rank', TJSONNumber.Create(1));
  // Act
  b := fJsonObject.IsFieldAvailable('rank');
  // Assert
  Assert.AreEqual(True, b);
end;

procedure TestTJSONObjectHelper.IsNotAvaliable_ForNotExistingField;
var
  b: boolean;
begin
  fJsonObject.AddPair('id', TJSONNumber.Create(1));
  b := fJsonObject.IsFieldAvailable('rank');
  Assert.AreEqual(False, b);
end;

procedure TestTJSONObjectHelper.IsValidIsoDate_ForVaildDate;
var
  b: boolean;
begin
  // Arrange
  fJsonObject.AddPair('id', TJSONNumber.Create(1));
  fJsonObject.AddPair('visited', '2018-11-25');
  // Act
  b := fJsonObject.IsValidIsoDate('visited');
  // Assert
  Assert.AreEqual(True, b);
end;

procedure TestTJSONObjectHelper.IsValidIsoDate_ForVaildDateTime;
var
  b: boolean;
begin
  fJsonObject.AddPair('timestamp', '2018-11-25T16:55:00');
  b := fJsonObject.IsValidIsoDate('timestamp');
  Assert.AreEqual(True, b);
end;

procedure TestTJSONObjectHelper.IsValidIsoDate_ForInvalidDate;
var
  b: boolean;
begin
  fJsonObject.AddPair('visited', '2018-25-11');
  b := fJsonObject.IsValidIsoDate('visited');
  Assert.AreEqual(False, b);
end;

procedure TestTJSONObjectHelper.IsValidIsoDate_ForTextValue;
var
  b: boolean;
begin
  fJsonObject.AddPair('city', 'Gdansk');
  b := fJsonObject.IsValidIsoDate('city');
  Assert.AreEqual(False, b);
end;

procedure TestTJSONObjectHelper.IsValidIsoDate_ForNull;
var
  b: boolean;
begin
  fJsonObject.AddPair('note', TJSONNull.Create);
  b := fJsonObject.IsValidIsoDate('note');
  Assert.AreEqual(False, b);
end;

procedure TestTJSONObjectHelper.GetFieldInt_ForNumber;
var
  v: Integer;
begin
  fJsonObject.AddPair('number', TJSONNumber.Create(99));
  v := fJsonObject.GetFieldInt('number');
  Assert.AreEqual(99, v);
end;

procedure TestTJSONObjectHelper.GetFieldInt_ForFloat;
begin
  fJsonObject.AddPair('number', TJSONNumber.Create(9.99));
  // EConvertError
  Assert.WillRaise(
    procedure
    begin
      fJsonObject.GetFieldInt('number');
    end, EConvertError);
end;

procedure TestTJSONObjectHelper.GetFieldIsoDate_ForValidDate;
var
  dt: TDateTime;
begin
  fJsonObject.AddPair('visited', '2018-11-25');
  dt := fJsonObject.GetFieldIsoDate('visited');
  Assert.AreEqual(EncodeDate(2018, 11, 25), dt);
end;

procedure TestTJSONObjectHelper.GetFieldOrEmpty_ForText;
var
  s: string;
begin
  fJsonObject.AddPair('id', TJSONNumber.Create(1));
  fJsonObject.AddPair('city', 'Gdansk');
  s := fJsonObject.GetFieldOrEmpty('city');
  Assert.AreEqual('Gdansk', s);
end;

procedure TestTJSONObjectHelper.GetFieldOrEmpty_ForNull;
var
  s: string;
begin
  fJsonObject.AddPair('id', TJSONNumber.Create(1));
  fJsonObject.AddPair('city', TJSONNull.Create);
  s := fJsonObject.GetFieldOrEmpty('city');
  Assert.IsEmpty(s);
end;

procedure TestTJSONObjectHelper.Bug028_InvalidDecimalValueInIsoDate;
var
  jso: TJSONObject;
  actualDate: TDateTime;
  expectedDate: Double;
begin
  jso := TJSONObject.Create(TJSONPair.Create('visited', '2018-11-25'));
  actualDate := jso.GetFieldIsoDate('visited');
  expectedDate := EncodeDate(2018, 11, 25);
  Assert.AreEqual(expectedDate, actualDate);
  jso.Free;
end;

initialization

TDUnitX.RegisterTestFixture(TestTJSONObjectHelper);

end.

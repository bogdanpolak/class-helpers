unit Test.Helper.TBytes;
// ♥ 2020 (c) https://github.com/bogdanpolak

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.IOUtils,

  Helper.TBytes;

{$M+}

type

  [TestFixture]
  TestTBytesHelper = class(TObject)
  private
    fBytes: TBytes;
  public
    [Setup]
    procedure Setup;
  published
    // -----
    procedure GetSize_With5Items;
    procedure GetSize_WithEmpty;
    procedure SetSize_OnEmptyArray;
    procedure SetSize_On4ItemsArray;
    procedure PropertySize;
    // -----
    procedure InitialiseFromBase64String_SampleText;
    procedure LoadFromStream;
    procedure SaveToStream;
    procedure SaveToFile_And_LoadFromFile;
    procedure SaveToStream_TwoBlocks;
    // -----
    procedure GetSectorAsString;
    procedure GetSectorAsHex;
    procedure GetLongWord;
    procedure GetReverseLongWord;
  end;

implementation

// -----------------------------------------------------------------------
// Uitls
// -----------------------------------------------------------------------

function GivenMemoryStream(const aBytes: TBytes): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  Result.Write(aBytes[0], Length(aBytes));
  Result.Position := 0;
end;

function GivenPNGImageAsBytes: TBytes;
begin
  Result.InitialiseFromBase64String
    ('iVBORw0KGgoAAAANSUhEUgAAAFsAAAAaCAMAAADv7NBiAAAAe1BMVEXw8PD/' +
    '///Z2dnwz4c3NofP8PAAAAAoKSmHz/Dw8Ks2AgA1h8+r8PDPz4cANodgEmBd' +
    'qfIABDarYADwq2DPhzeHNgAAYKvw8M+rz4dgCzZgBwA2DmAADGA5ZLPP8Ktg' +
    'YKtlTzk2BjZks9ir8Ks4ZWU4N2VnZkWPZQBgNgB6DF3BAAABJUlEQVRIx+2T' +
    '25LCIAyGU7BZ2m67ldq6B9fVPen7P6EhNGMd8EoZxxlzw58QPgIB2EA6ezrK' +
    'B5tMKZWOnWUjW13fjmy4tj3Yt2XrErECWKAb9CwHiU5dUaHJbJT9ZqD4gkWT' +
    'Q/FeSVLB0YvZL8+exSm1sDm67Kl4OtDcsNIlKf23x+8eW/DebIfY8myMbXHg' +
    'jZn4yqNEpZ5ucIr2c7tvTTc3XbP2XtlC1+TxunkpDgHbRZnIN8+rncAVZZAm' +
    'qniUdJbNzJ/TO5F7ccu2hlcLQHTtvZD9P2F/cobvZStJ2kf1h8NTo52i6Ql7' +
    'Ld6YF627d73iN+gbhCvKW45Ri5VF/CUCKb6dWs4gHvNt2MvwIV3+dzYxNlgq' +
    '9X7+fAq2SmHCzhJYWvYBmzQSEHa+IRoAAAAASUVORK5CYII=');
end;

// -----------------------------------------------------------------------
// SetUp / TearDown
// -----------------------------------------------------------------------

procedure TestTBytesHelper.Setup;
begin
  fBytes := [];
end;

// -----------------------------------------------------------------------
// Tests TBytes - Size
// -----------------------------------------------------------------------

procedure TestTBytesHelper.GetSize_With5Items;
var
  actual: Integer;
begin
  fBytes := [1, 2, 3, 4, 5];
  actual := fBytes.GetSize;
  Assert.AreEqual(5, actual);
end;

procedure TestTBytesHelper.GetSize_WithEmpty;
var
  actual: Integer;
begin
  actual := fBytes.GetSize;
  Assert.AreEqual(0, actual);
end;

procedure TestTBytesHelper.SetSize_OnEmptyArray;
begin
  fBytes.SetSize(5);
  Assert.AreEqual(5, Length(fBytes));
end;

procedure TestTBytesHelper.SetSize_On4ItemsArray;
begin
  fBytes := [1, 2, 3, 4];
  fBytes.SetSize(10);
  Assert.AreEqual(10, Length(fBytes));
end;

procedure TestTBytesHelper.PropertySize;
begin
  fBytes := [1, 2, 3];
  Assert.AreEqual(3, fBytes.Size);
  // resize array
  fBytes.Size := 8;
  Assert.AreEqual(8, Length(fBytes));
end;

// -----------------------------------------------------------------------
// Tests TBytes - Load, Save, Initialise
// -----------------------------------------------------------------------

procedure TestTBytesHelper.InitialiseFromBase64String_SampleText;
var
  actual: String;
begin
  fBytes.InitialiseFromBase64String('U2FtcGxlIHRleHQ=');
  actual := Char(fBytes[0]) + Char(fBytes[1]) + Char(fBytes[2]) + Char(fBytes[3]
    ) + Char(fBytes[4]) + Char(fBytes[5]) + Char(fBytes[6]) + Char(fBytes[7]) +
    Char(fBytes[8]) + Char(fBytes[9]) + Char(fBytes[10]);
  Assert.AreEqual('Sample text', actual);
end;

procedure TestTBytesHelper.LoadFromStream;
var
  ms: TMemoryStream;
begin
  ms := GivenMemoryStream([101, 102, 103, 104, 105, 106, 107]);
  fBytes.LoadFromStream(ms);
  ms.Free;
  Assert.AreEqual(7, fBytes.Size);
  Assert.AreEqual(107, Integer(fBytes[6]));
end;

procedure TestTBytesHelper.SaveToStream;
var
  ms: TMemoryStream;
begin
  fBytes := [201, 202, 203];
  ms := GivenMemoryStream([]);
  fBytes.SaveToStream(ms);
  Assert.AreEqual(3, Integer(ms.Size));
end;

procedure TestTBytesHelper.SaveToFile_And_LoadFromFile;
var
  aFileName: string;
begin
  aFileName := TPath.GetTempFileName;
  fBytes := [1, 2, 3, 4, 5, 6, 7, 8, 9, 101, 102];
  fBytes.SaveToFile(aFileName);
  fBytes := [];
  fBytes.LoadFromFile(aFileName);
  DeleteFile(aFileName);
  Assert.AreEqual(11, fBytes.Size);
  Assert.AreEqual(1, Integer(fBytes[0]));
  Assert.AreEqual(102, Integer(fBytes[10]));
end;

procedure TestTBytesHelper.SaveToStream_TwoBlocks;
var
  ms: TMemoryStream;
begin
  ms := GivenMemoryStream([]);
  fBytes := [101, 102];
  fBytes.SaveToStream(ms);
  fBytes := [201, 202, 203];
  fBytes.SaveToStream(ms);
  fBytes := [];

  // test 1:
  Assert.AreEqual(5, Integer(ms.Position));

  // test 2: Load and data
  fBytes.LoadFromStream(ms);
  Assert.AreEqual(5, Integer(fBytes.Size));
  Assert.AreEqual(101, Integer(fBytes[0]));
  Assert.AreEqual(203, Integer(fBytes[4]));
end;

// -----------------------------------------------------------------------
// Tests TBytes - Data getters
// -----------------------------------------------------------------------

procedure TestTBytesHelper.GetSectorAsHex;
var
  actual: string;
begin
  fBytes := [0, 0, 15, 16, $A0, $A1, $FF, 0, 0, 0];
  actual := fBytes.GetSectorAsHex(2, 6);
  Assert.AreEqual('0F 10 A0 A1 FF 00', actual);
end;

procedure TestTBytesHelper.GetSectorAsString;
var
  actual: string;
begin
  fBytes := GivenPNGImageAsBytes;
  actual := fBytes.GetSectorAsString(1, 3);
  Assert.AreEqual('PNG', actual);
end;

procedure TestTBytesHelper.GetLongWord;
var
  actual: Cardinal;
begin
  fBytes := [255, 2, 0, 0, 0, 255];
  actual := fBytes.GetLongWord(1);
  Assert.AreEqual(2, actual);
end;

procedure TestTBytesHelper.GetReverseLongWord;
var
  actual: Cardinal;
begin
  fBytes := [255, 0, 0, 0, 3, 255];
  actual := fBytes.GetReverseLongWord(1);
  Assert.AreEqual(3, actual);
end;

initialization

TDUnitX.RegisterTestFixture(TestTBytesHelper);

end.

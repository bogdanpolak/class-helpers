unit Test.Helper.TBytes;
// ♥ 2020 (c) https://github.com/bogdanpolak

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,

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
  end;

implementation

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

initialization

TDUnitX.RegisterTestFixture(TestTBytesHelper);

end.

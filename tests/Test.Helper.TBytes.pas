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
  published
    procedure GetSize_With5Items;
    procedure GetSize_WithEmpty;
    procedure SetSize_OnEmptyArray;
    procedure SetSize_On4ItemsArray;
    procedure PropertySize;
  end;



implementation

// -----------------------------------------------------------------------
// Tests TBytes - Size
// -----------------------------------------------------------------------

procedure TestTBytesHelper.GetSize_With5Items;
var
  actual: Integer;
begin
  fBytes := [1, 2, 3, 4, 5];
  actual := fBytes.GetSize;
  Assert.AreEqual(5 ,actual);
end;

procedure TestTBytesHelper.GetSize_WithEmpty;
var
  actual: Integer;
begin
  fBytes := [];
  actual := fBytes.GetSize;
  Assert.AreEqual(0 ,actual);
end;

procedure TestTBytesHelper.SetSize_OnEmptyArray;
begin
  fBytes := [];
  fBytes.SetSize(5);
  Assert.AreEqual(5 ,Length(fBytes));
end;

procedure TestTBytesHelper.SetSize_On4ItemsArray;
begin
  fBytes := [1, 2, 3, 4];
  fBytes.SetSize(10);
  Assert.AreEqual(10 ,Length(fBytes));
end;


procedure TestTBytesHelper.PropertySize;
begin
  fBytes := [1, 2, 3];
  Assert.AreEqual(3, fBytes.Size);
  // resize array
  fBytes.Size := 8;
  Assert.AreEqual(8 , Length(fBytes));
end;

initialization

TDUnitX.RegisterTestFixture(TestTBytesHelper);

end.

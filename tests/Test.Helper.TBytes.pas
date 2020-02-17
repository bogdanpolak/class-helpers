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
  end;



implementation

// -----------------------------------------------------------------------
// Tests
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

initialization

TDUnitX.RegisterTestFixture(TestTBytesHelper);

end.

unit Test.Helper.TDBGrid;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,

  Helper.TDBGrid;

{$M+}

type

  [TestFixture]
  TestTDBGridHelper = class(TObject)
  private
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure Test1;
  end;

implementation

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestTDBGridHelper.Setup;
begin
end;

procedure TestTDBGridHelper.TearDown;
begin
end;

// -----------------------------------------------------------------------
// Utilities
// -----------------------------------------------------------------------

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTDBGridHelper.Test1;
begin
  Assert.Fail();
end;

initialization

TDUnitX.RegisterTestFixture(TestTDBGridHelper);

end.

unit Test.Helper.TDataSet;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.JSON,
  Datasnap.DBClient,

  Helper.TDataSet;

{$M+}

type

  [TestFixture]
  TestTDataSetHelper = class(TObject)
  private
    dataset: TClientDataSet;
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

procedure TestTDataSetHelper.Setup;
begin
  dataset := TClientDataSet.Create(nil);
end;

procedure TestTDataSetHelper.TearDown;
begin
  dataset.Close;
end;

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTDataSetHelper.Test1;
begin
  // Arrange

  // Act

  // Assert
  Assert.AreEqual (0,1);
end;

initialization

TDUnitX.RegisterTestFixture(TestTDataSetHelper);

end.

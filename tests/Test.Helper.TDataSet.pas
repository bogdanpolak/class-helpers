unit Test.Helper.TDataSet;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.JSON,
  Data.DB,
  Datasnap.DBClient,

  Helper.TDataSet;

{$M+}

type

  [TestFixture]
  TestTDataSetHelper = class(TObject)
  private
    fDataset: TClientDataSet;
    procedure BuildDataSet1;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure GetMaxIntegerValue_546;
  end;

implementation

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

procedure TestTDataSetHelper.BuildDataSet1;
begin
  with fDataset do
  begin
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('city', ftWideString, 30);
    FieldDefs.Add('rank', ftInteger);
    FieldDefs.Add('visited', ftDateTime);
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
  BuildDataSet1;
  fDataset.AppendRecord([1, 'Edynburgh', 5]);
  fDataset.AppendRecord([2, 'Glassgow', 4]);
  fDataset.AppendRecord([3, 'Cracow', 6]);
  fDataset.First;
  // Act
  aMaxValue := fDataset.GetMaxIntegerValue('rank');
  // Assert
  Assert.AreEqual(6, aMaxValue);
end;

initialization

TDUnitX.RegisterTestFixture(TestTDataSetHelper);

end.

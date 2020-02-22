unit Test.Helper.TField;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  Data.DB,
  Datasnap.DBClient,

  Helper.TField;

{$M+}

type

  [TestFixture]
  TestTFieldHelper = class(TObject)
  private
    fOwner: TComponent;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure Test01;
  end;

implementation

// -----------------------------------------------------------------------
// Utilities
// -----------------------------------------------------------------------

function Givien_DataSet(aOwner: TCOmponent): TDataSet;
var
  aDataset: TClientDataSet;
begin
  aDataset := TClientDataSet.Create(aOwner);
  with aDataset do
  begin
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('city', ftWideString, 30);
    FieldDefs.Add('rank', ftInteger);
    FieldDefs.Add('visited', ftDateTime);
    FieldDefs[0].Required := True;
    FieldDefs[1].Required := True;
  end;
  aDataset.CreateDataSet;
  Result := aDataset;
end;

// -----------------------------------------------------------------------
// Test Setup and TearDown
// -----------------------------------------------------------------------

procedure TestTFieldHelper.Setup;
begin
  fOwner := TComponent.Create(nil);
end;

procedure TestTFieldHelper.TearDown;
begin
  fOwner.Free;
end;

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTFieldHelper.Test01;
var
  aDataSet: TDataSet;
begin
  aDataSet := Givien_DataSet(fOwner);
  Assert.AreEqual(1,aDataSet.RecordCount);
end;


initialization

TDUnitX.RegisterTestFixture(TestTFieldHelper);

end.

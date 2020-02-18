unit Test.Helper.TStream;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.IOUtils,

  Helper.TStream;

{$M+}

type

  [TestFixture]
  TestTStreamHelper = class(TObject)
  private
    fStream: TMemoryStream;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure Test;
  end;

implementation

uses
  Attribute.MappedToField;

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestTStreamHelper.Setup;
begin
  fStream := TMemoryStream.Create;
end;

procedure TestTStreamHelper.TearDown;
begin
  fStream.Free;
end;

// -----------------------------------------------------------------------
// Utilities
// -----------------------------------------------------------------------

procedure GivenBytesStream(aStream: TStream; const aBytes: TBytes);
begin
  aStream.Write(aBytes[0], Length(aBytes));
  aStream.Position := 0;
end;

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTStreamHelper.Test;
var
  aFileName: string;
begin
   GivenBytesStream(fStream, [ 1, 2, 3, 4, 5, 6]);

   aFileName := fStream.SaveToTempFile;

   Assert.IsTrue(FileExists(aFileName),'File '+aFileName+' not created');
   DeleteFile(aFileName);
end;


initialization

TDUnitX.RegisterTestFixture(TestTStreamHelper);

end.

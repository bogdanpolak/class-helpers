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
    procedure SaveToTempFile_FileExists;
    procedure SaveToTempFile_SizeAndContent;
    procedure AsString_AsciiText;
  end;

implementation

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

procedure GivenStringStream(aStream: TStream; aText: String; aEncoding: TEncoding);
var
  ss: TStringStream;
begin
  ss := TStringStream.Create(aText, aEncoding);
  try
    aStream.CopyFrom(ss, ss.Size);
  aStream.Position := 0;
  finally
    ss.Free;
  end;
end;

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTStreamHelper.SaveToTempFile_FileExists;
var
  aFileName: string;
begin
   GivenBytesStream(fStream, [ 1, 2, 3, 4, 5, 6]);

   aFileName := fStream.SaveToTempFile;

   Assert.IsTrue(FileExists(aFileName),'File '+aFileName+' not created');
   DeleteFile(aFileName);
end;

procedure TestTStreamHelper.SaveToTempFile_SizeAndContent;
var
  aFileName: string;
  actual: TBytes;
begin
   GivenBytesStream(fStream, [ 101, 102, 103, 104, 105, 106]);

   aFileName := fStream.SaveToTempFile;
   actual := TFile.ReadAllBytes(aFileName);

   Assert.AreEqual(6, Length(actual));
   Assert.AreEqual(byte(101), actual[0]);
   Assert.AreEqual(byte(106), actual[5]);
   DeleteFile(aFileName);
end;


procedure TestTStreamHelper.AsString_AsciiText;
var
  actual: string;
begin
  GivenStringStream(fStream, '|ASCII text 123|',TEncoding.UTF8);

  actual := fStream.AsString;

  Assert.AreEqual('|ASCII text 123|',actual);
end;

initialization

TDUnitX.RegisterTestFixture(TestTStreamHelper);

end.

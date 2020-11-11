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
    procedure AsString_CyrlicUtf8Stream;
    procedure AsString_Unicode16Stream;
    procedure AsString_IgnorePosition;
    procedure WriteString_SimpleText;
    procedure WriteString_UnicodeText;
    procedure WriteString_HearthUtf8;
    procedure WriteString_AppendToStream;
    // ----
    procedure ToHexString_FiveBytes;
    procedure ToHexString_EmptyStream;
    procedure ToHexString_SomeBytes;
    procedure ToHexString_TooMuchBytes;
    // ----
    procedure WriteLine_SimpleText;
    procedure WriteLine_UnicodeText;
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

procedure GivenStringStream(aStream: TStream; aText: String;
  aEncoding: TEncoding);
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
// Tests: SaveToTempFile
// -----------------------------------------------------------------------

procedure TestTStreamHelper.SaveToTempFile_FileExists;
var
  aFileName: string;
begin
  GivenBytesStream(fStream, [1, 2, 3, 4, 5, 6]);

  aFileName := fStream.SaveToTempFile;

  Assert.IsTrue(FileExists(aFileName), 'File ' + aFileName + ' not created');
  DeleteFile(aFileName);
end;

procedure TestTStreamHelper.SaveToTempFile_SizeAndContent;
var
  aFileName: string;
  actual: TBytes;
begin
  GivenBytesStream(fStream, [101, 102, 103, 104, 105, 106]);

  aFileName := fStream.SaveToTempFile;
  actual := TFile.ReadAllBytes(aFileName);

  Assert.AreEqual(6, Length(actual));
  Assert.AreEqual(byte(101), actual[0]);
  Assert.AreEqual(byte(106), actual[5]);
  DeleteFile(aFileName);
end;

// -----------------------------------------------------------------------
// Tests: AsString
// -----------------------------------------------------------------------

procedure TestTStreamHelper.AsString_AsciiText;
var
  actual: string;
begin
  GivenStringStream(fStream, '|ASCII text 123|', TEncoding.UTF8);

  actual := fStream.AsString;

  Assert.AreEqual('|ASCII text 123|', actual);
end;

procedure TestTStreamHelper.AsString_CyrlicUtf8Stream;
var
  actual: string;
begin
  GivenStringStream(fStream, '|Каждый человек|', TEncoding.UTF8);

  actual := fStream.AsString;

  Assert.AreEqual('|Каждый человек|', actual);
end;

procedure TestTStreamHelper.AsString_Unicode16Stream;
var
  actual: string;
begin
  GivenStringStream(fStream, '|Sample Text|', TEncoding.Unicode);

  actual := fStream.AsString(TEncoding.Unicode);

  Assert.AreEqual('|Sample Text|', actual);
end;

procedure TestTStreamHelper.AsString_IgnorePosition;
var
  actual: string;
begin
  GivenStringStream(fStream, '1234567890', TEncoding.UTF8);

  fStream.Position := 5;
  actual := fStream.AsString;

  Assert.AreEqual('1234567890', actual);
end;

// -----------------------------------------------------------------------
// Tests: WriteString
// -----------------------------------------------------------------------

function StreamToHexString(fStream: TStream): string;
var
  aBytes: TBytes;
  i: Integer;
begin
  SetLength(aBytes, fStream.Size);
  fStream.Position := 0;
  fStream.Read(aBytes[0], fStream.Size);
  for i := 0 to High(aBytes) do
    if i = 0 then
      Result := IntToHex(aBytes[0], 2)
    else
      Result := Result + ' ' + IntToHex(aBytes[i], 2);
end;

procedure TestTStreamHelper.WriteString_SimpleText;
begin
  fStream.WriteString('Sample');
  // . . . . . . . S  a  m  p  l  e
  Assert.AreEqual('53 61 6D 70 6C 65', StreamToHexString(fStream));
end;

procedure TestTStreamHelper.WriteString_UnicodeText;
begin
  fStream.WriteString('abc', TEncoding.Unicode);
  // . . . . . . . a     b     c
  Assert.AreEqual('61 00 62 00 63 00', StreamToHexString(fStream));
end;

procedure TestTStreamHelper.WriteString_HearthUtf8;
begin
  fStream.WriteString('1234 ♥');
  // . . . . . . . 1  2  3  4     heart=♥
  Assert.AreEqual('31 32 33 34 20 E2 99 A5', StreamToHexString(fStream));
end;

procedure TestTStreamHelper.WriteString_AppendToStream;
begin
  GivenBytesStream(fStream, [1, 2, 3]);
  fStream.Seek(0, soEnd);

  fStream.WriteString('4567');

  Assert.AreEqual(7, Integer(fStream.Size));
end;


// -----------------------------------------------------------------------
// Tests: ToHexString
// -----------------------------------------------------------------------

procedure TestTStreamHelper.ToHexString_FiveBytes;
var
  actual: string;
begin
 GivenBytesStream(fStream, [3, 4, 5, 6, 7]);
 actual := fStream.ToHexString;
 Assert.AreEqual('03 04 05 06 07',actual);
end;

procedure TestTStreamHelper.ToHexString_EmptyStream;
var
  actual: string;
begin
 actual := fStream.ToHexString;
 Assert.AreEqual('',actual);
end;


procedure TestTStreamHelper.ToHexString_SomeBytes;
var
  actual: string;
begin
 GivenBytesStream(fStream, [3, 4, 5, 6, 7]);
 actual := fStream.ToHexString(2);
 Assert.AreEqual('03 04',actual);
end;

procedure TestTStreamHelper.ToHexString_TooMuchBytes;
var
  actual: string;
begin
 GivenBytesStream(fStream, [101, 102, 103]);
 actual := fStream.ToHexString(9);
 Assert.AreEqual('65 66 67',actual);
end;


// -----------------------------------------------------------------------
// Tests: WriteLine
// -----------------------------------------------------------------------

procedure TestTStreamHelper.WriteLine_SimpleText;
begin
  fStream.WriteLine('12');

  Assert.AreEqual(4, Integer(fStream.Size));
end;

procedure TestTStreamHelper.WriteLine_UnicodeText;
begin
  fStream.WriteLine('12', TEncoding.Unicode);

  Assert.AreEqual(8, Integer(fStream.Size));
end;

initialization

TDUnitX.RegisterTestFixture(TestTStreamHelper);

end.

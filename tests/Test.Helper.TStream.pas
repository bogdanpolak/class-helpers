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

procedure TestTStreamHelper.WriteString_SimpleText;
begin
  fStream.WriteString('Sample');

  Assert.AreEqual(6, integer(fStream.Size));
  Assert.AreEqual(byte(ord('S')), (PByte(fStream.Memory))^);
  Assert.AreEqual(byte(ord('e')), (PByte(fStream.Memory) + 5)^);
end;

procedure TestTStreamHelper.WriteString_UnicodeText;
begin
  fStream.WriteString('Abc', TEncoding.Unicode);

  Assert.AreEqual(6, integer(fStream.Size));
  Assert.AreEqual(byte(ord('A')), (PByte(fStream.Memory))^);
  Assert.AreEqual(byte(0), (PByte(fStream.Memory) + 1)^);
  Assert.AreEqual(byte(ord('b')), (PByte(fStream.Memory) + 2)^);
  Assert.AreEqual(byte(0), (PByte(fStream.Memory) + 3)^);
  Assert.AreEqual(byte(ord('c')), (PByte(fStream.Memory) + 4)^);
  Assert.AreEqual(byte(0), (PByte(fStream.Memory) + 5)^);
end;

procedure TestTStreamHelper.WriteString_HearthUtf8;
begin
  fStream.WriteString('1234 ♥');

  Assert.AreEqual(8, integer(fStream.Size));
  Assert.AreEqual(byte(ord(' ')), (PByte(fStream.Memory) + 4)^);
  Assert.AreEqual(byte($E2), (PByte(fStream.Memory) + 5)^);
  Assert.AreEqual(byte($99), (PByte(fStream.Memory) + 6)^);
  Assert.AreEqual(byte($A5), (PByte(fStream.Memory) + 7)^);
end;

procedure TestTStreamHelper.WriteString_AppendToStream;
begin
  GivenBytesStream(fStream, [1, 2, 3]);
  fStream.Seek(0, soEnd);

  fStream.WriteString('4567');

  Assert.AreEqual(7, integer(fStream.Size));
end;

// -----------------------------------------------------------------------
// Tests: WriteLine
// -----------------------------------------------------------------------

procedure TestTStreamHelper.WriteLine_SimpleText;
begin
  fStream.WriteLine('12');

  Assert.AreEqual(4, integer(fStream.Size));
end;

procedure TestTStreamHelper.WriteLine_UnicodeText;
begin
  fStream.WriteLine('12', TEncoding.Unicode);

  Assert.AreEqual(8, integer(fStream.Size));
end;

initialization

TDUnitX.RegisterTestFixture(TestTStreamHelper);

end.

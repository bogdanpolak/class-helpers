unit Helper.TBytes;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TBytesHelper = record helper for TBytes
  private
  public
    // ---------------------
    // Size:
    function GetSize: Integer;
    procedure SetSize(aSize: Integer);
    property Size: Integer read GetSize write SetSize;
    // ---------------------
    // InitialiseFrom / Load / Save
    procedure LoadFromStream(const aStream: TStream);
    procedure LoadFromFile(const aFileName: string);
    procedure SaveToStream(const aStream: TStream);
    procedure SaveToFile(const aFileName: string);
    procedure InitialiseFromBase64String(const aBase64Str: String);
    // ---------------------
    // Data getters
    function GetSectorAsHex(aIndex: Integer = 0;
      aLength: Integer = 100): string;
    function GetSectorAsString(aIndex: Integer = 0;
      aLength: Integer = 100): string;
    function GetLongWord(aIndex: Integer = 0): LongWord;
    function GetReverseLongWord(aIndex: Integer = 0): LongWord;
    function GetSectorCRC32(aIndex: Integer; aLength: Integer): LongWord;
  end;

implementation

uses
  System.NetEncoding;

// -----------------------------------------------------------------------
// Size
// -----------------------------------------------------------------------

function TBytesHelper.GetSize: Integer;
begin
  Result := Length(Self);
end;

procedure TBytesHelper.SetSize(aSize: Integer);
begin
  SetLength(Self, aSize);
end;

// -----------------------------------------------------------------------
// InitialiseFrom / Load / Save
// -----------------------------------------------------------------------

procedure TBytesHelper.InitialiseFromBase64String(const aBase64Str: String);
begin
  Self := TNetEncoding.Base64.DecodeStringToBytes(aBase64Str);
end;

procedure TBytesHelper.LoadFromFile(const aFileName: string);
var
  aFileStream: TFileStream;
begin
  aFileStream := TFileStream.Create(aFileName, fmOpenRead);
  try
    SetLength(Self, aFileStream.Size);
    aFileStream.Read(Self[0], aFileStream.Size);
  finally
    aFileStream.Free;
  end;
end;

procedure TBytesHelper.LoadFromStream(const aStream: TStream);
begin
  aStream.Position := 0;
  SetLength(Self, aStream.Size);
  aStream.Read(Self[0], aStream.Size);
end;

procedure TBytesHelper.SaveToFile(const aFileName: string);
var
  aFileStream: TFileStream;
begin
  aFileStream := TFileStream.Create(aFileName, fmCreate);
  try
    aFileStream.Write(Self[0], Length(Self));
  finally
    aFileStream.Free;
  end;
end;

procedure TBytesHelper.SaveToStream(const aStream: TStream);
begin
  aStream.Write(Self[0], Length(Self));
end;

// -----------------------------------------------------------------------
// Data getters
// -----------------------------------------------------------------------

function TBytesHelper.GetSectorAsHex(aIndex: Integer = 0;
  aLength: Integer = 100): string;
begin

end;

function TBytesHelper.GetSectorAsString(aIndex: Integer = 0;
  aLength: Integer = 100): string;
begin

end;

function TBytesHelper.GetLongWord(aIndex: Integer = 0): LongWord;
begin

end;

function TBytesHelper.GetReverseLongWord(aIndex: Integer = 0): LongWord;
begin

end;

function TBytesHelper.GetSectorCRC32(aIndex: Integer; aLength: Integer)
  : LongWord;
begin

end;

end.

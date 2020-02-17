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
begin

end;

procedure TBytesHelper.LoadFromStream(const aStream: TStream);
begin
  aStream.Position := 0;
  SetLength(Self, aStream.Size);
  aStream.Read(Self[0], aStream.Size);
end;

procedure TBytesHelper.SaveToFile(const aFileName: string);
begin

end;

procedure TBytesHelper.SaveToStream(const aStream: TStream);
begin
  aStream.Write(Self[0], Length(Self));
end;

end.

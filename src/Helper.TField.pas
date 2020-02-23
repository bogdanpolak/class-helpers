unit Helper.TField;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.DB;

type
  TImageFormat = (ifUnknown, ifPNG, ifJPEG, ifGIF, ifBMP);

  TFieldHelper = class helper for TField
  private const
    Version = '1.6';
  private
    procedure AssertIsBlobField;
    procedure AssertNotNull;
  public
    function SetBlobFromBase64String(const aBase64Str: String): TBlobField;
    function CheckBlobImageFormat: TImageFormat;
  end;

implementation

uses
  System.NetEncoding;

procedure TFieldHelper.AssertIsBlobField;
begin
  if not(Self is TBlobField) then
    raise EDatabaseError.Create('Invalid type in field ' + Self.FieldName +
      '. Method LoadFromBase64String is supported only for blob fields');
end;

procedure TFieldHelper.AssertNotNull;
begin
  if Self.IsNull then
    raise EDatabaseError.Create('Field ' + Self.FieldName + ' has null value.');
end;

function TFieldHelper.SetBlobFromBase64String(const aBase64Str: String)
  : TBlobField;
begin
  AssertIsBlobField;
  Result := (Self as TBlobField);
  Result.Value := TNetEncoding.Base64.DecodeStringToBytes(aBase64Str);
end;

function BytesSectorToHex(const aBytes: TBytes; aLength: integer): string;
var
  idx: Integer;
begin
  Result := '';
  for idx := 0 to aLength-1 do
    Result := Result + IntToHex(aBytes[idx],2);
end;

function TFieldHelper.CheckBlobImageFormat: TImageFormat;
const
  // .................. _-P-N-G-_-_-_-_-
  PNG_HEX_SIGNATURE =  '89504E470D0A1A0A';
  JPEG_HEX_SIGNATURE = 'FFD8FFE0';
var
  aBlobField: TBlobField;
  aSize: Integer;
  aSign: TBytes;
begin
  AssertIsBlobField;
  AssertNotNull;
  aBlobField := (Self as TBlobField);
  aSize := Length(aBlobField.Value);
  if aSize < 8 then
    Exit(ifUnknown);
  SetLength(aSign,8);
  move(aBlobField.Value[0],aSign[0],8);
  if BytesSectorToHex(aSign,8) = PNG_HEX_SIGNATURE then
    Exit(ifPNG)
  else if BytesSectorToHex(aSign,4) = JPEG_HEX_SIGNATURE then
    Exit(ifJPEG)
end;

end.

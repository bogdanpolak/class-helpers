unit Helper.TField;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.DB;

type
  /// <summary>
  ///   Recognizable BLOB data formats: Images (PNG, JPEG, GIF, BMP) ...
  /// </summary>
  ///  <see cref="TFieldHelper.GetBlobFormat"/>
  TBlobFormat = (bfUnknown, bfImagePNG, bfImageJPEG, bfImageGIF, bfImageBMP);

  TFieldHelper = class helper for TField
  private const
    Version = '1.7';
  private
    procedure AssertIsBlobField;
    procedure AssertNotNull;
  public
    /// <summary>
    ///   Stored BLOB data in the field. Provided parameter has to be a valid
    ///   Base64 format string.
    /// </summary>
    /// <exception cref="EDatabaseError">
    ///   Exception <b>EDatabaseError</b> is thrown when field in not TBlobField
    /// </exception>
    function SetBlobFromBase64String(const aBase64Str: String): TBlobField;
    /// <summary>
    ///   Loads 8 bytes signature of BLOB data and checks for knowns data
    ///   formats, like images: PNG, JPEG.
    /// </summary>
    /// <returns cref="TBlobFormat">
    ///   Enumereted type <b>TBlobFormat</b> informs about recognized format of
    ///   then BLOB content.
    /// </returns>
    /// <exception cref="EDatabaseError">
    ///   Exception <b>EDatabaseError</b> is thrown when field in not
    ///   a TBlobField or has NULL value.
    /// </exception>
    function GetBlobFormat: TBlobFormat;
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
  idx: integer;
begin
  Result := '';
  for idx := 0 to aLength - 1 do
    Result := Result + IntToHex(aBytes[idx], 2);
end;

function GetBitmapSize(const aSignature: TBytes): integer;
begin
  Result := Cardinal(aSignature[2]) or (Cardinal(aSignature[3]) shl 8) or
    (Cardinal(aSignature[4]) shl 16) or (Cardinal(aSignature[5]) shl 24);
end;

function TFieldHelper.GetBlobFormat: TBlobFormat;
const
  // ................. _-P-N-G-_-_-_-_-
  PNG_HEX_SIGNATURE = '89504E470D0A1A0A';
  JPEG_HEX_SIGNATURE = 'FFD8FFE0';
  // ................. G-I-F-8-9-a-
  GIF_HEX_SIGNATURE = '474946383961';
  // ................. B-M-
  BMP_HEX_SIGNATURE = '424D';
var
  aBlobField: TBlobField;
  aSize: integer;
  aSign: TBytes;
begin
  AssertIsBlobField;
  AssertNotNull;
  aBlobField := (Self as TBlobField);
  aSize := Length(aBlobField.Value);
  if aSize < 8 then
    Exit(bfUnknown);
  SetLength(aSign, 8);
  move(aBlobField.Value[0], aSign[0], 8);
  if BytesSectorToHex(aSign, 8) = PNG_HEX_SIGNATURE then
    Result := bfImagePNG
  else if BytesSectorToHex(aSign, 4) = JPEG_HEX_SIGNATURE then
    Result := bfImageJPEG
  else if BytesSectorToHex(aSign, 6) = GIF_HEX_SIGNATURE then
    Result := bfImageGIF
  else if (BytesSectorToHex(aSign, 2) = BMP_HEX_SIGNATURE) and
    (GetBitmapSize(aSign) = aSize) then
    Result := bfImageBMP
  else
    Result := bfUnknown;
end;

end.

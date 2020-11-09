unit Helper.TPicture;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Vcl.Imaging.pngimage,
  Vcl.Imaging.jpeg,
  Vcl.Graphics;

type
  TPictureHelper = class helper for TPicture
  private const
    Version = '1.7';
  public
    /// <summary>
    ///   Identifes binary signature of the image format creates TGraphics
    ///   descending impage object and assign it to Picture. Supports JPEG
    ///   and PNG images.
    /// </summary>
    /// <exception cref="EPictureReadError">
    ///   Exception <b>EPictureReadError</b> will be raise when image's
    ///   header is not recognized (not JPEG or PNG)
    /// </exception>
    procedure AssignBytes(const aBytes: TBytes);
    /// <summary>
    ///   TODO
    /// </summary>
    procedure AssignBlobField(const aField: TField);
  end;

  EPictureReadError = class(Exception);

implementation

function BytesAreEqual(const aData: TBytes; const aSignature: TBytes): boolean;
var
  i: Integer;
begin
  if (Length(aData) < Length(aSignature)) then
    exit(False);
  for i := 0 to Length(aSignature) - 1 do
    if aData[i] <> aSignature[i] then
      exit(False);
  Result := True;
end;

procedure TPictureHelper.AssignBlobField(const aField: TField);
begin
  Assert(aField <> nil, 'Provided field is NULL');
  if not(aField is TBlobField) then
    raise EPictureReadError.Create(Format('Database field %s',
      [aField.FieldName]));
  AssignBytes(aField.AsBytes);
end;

procedure TPictureHelper.AssignBytes(const aBytes: TBytes);
const
  PNG_SIGNATURE: TBytes = [$89, $50, $4E, $47, $0D, $0A, $1A, $0A];
  JPEG_SIGNATURE: TBytes = [$FF, $D8, $FF, $E0];
var
  isPng: boolean;
  ms: TMemoryStream;
  png: TPngImage;
  isJpeg: boolean;
  jpeg: TJPEGImage;
begin
  isPng := BytesAreEqual(aBytes, PNG_SIGNATURE);
  isJpeg := BytesAreEqual(aBytes, JPEG_SIGNATURE);
  if not(isPng) and not(isJpeg) then
    raise EPictureReadError.Create
      ('Unsupported format: expected JPEG or PNG image');
  ms := TMemoryStream.Create();
  try
    ms.Write(aBytes, Length(aBytes));
    ms.Position := 0;
    if isPng then
    begin
      png := TPngImage.Create;
      try
        png.LoadFromStream(ms);
        self.Graphic := png;
      finally
        png.Free;
      end;
    end
    else if isJpeg then
    begin
      jpeg := TJPEGImage.Create;
      try
        jpeg.LoadFromStream(ms);
        self.Graphic := jpeg;
      finally
        jpeg.Free;
      end;
    end
  finally
    ms.Free;
  end;
end;

end.

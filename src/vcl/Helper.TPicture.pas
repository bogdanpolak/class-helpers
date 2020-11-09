unit Helper.TPicture;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Math,
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
    ///   Recogonize binary header of the image inside stream "aStream" and
    ///   creates adequate TGraphics descending image object inside TPicture.
    ///   Method supports JPEG and PNG images.
    /// </summary>
    /// <exception cref="EPictureReadError">
    ///   Exception <b>EPictureReadError</b> will be raise when stream
    ///   header is not recognized image format (not JPEG or PNG)
    /// </exception>
    procedure AssignStream(const aStream: TStream);
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

function AreBytesEqual(const aBytes1, aBytes2: TBytes): boolean;
var
  i: Integer;
begin
  if (Length(aBytes1) < Length(aBytes2)) then
    exit(False);
  for i := 0 to Length(aBytes2) - 1 do
    if aBytes1[i] <> aBytes2[i] then
      exit(False);
  Result := True;
end;

type
  TGraphicFormat = (gfUnkonwn, gfJpeg, gfPng, gfBmp, gfGif);

function RecognizeGraphicFormat(const aStream: TStream): TGraphicFormat;
const
  PNG_SIGNATURE: TBytes = [$89, $50, $4E, $47, $0D, $0A, $1A, $0A];
  JPEG_SIGNATURE: TBytes = [$FF, $D8, $FF, $E0];
var
  i: Integer;
  currentPos: Int64;
  countBytesToRead: Integer;
  bytes: TBytes;
begin
  currentPos := aStream.Position;
  try
    countBytesToRead := System.Math.Min(aStream.Size - currentPos, 8);
    SetLength(bytes, countBytesToRead);
    aStream.Read(bytes, countBytesToRead);
    if AreBytesEqual(bytes, JPEG_SIGNATURE) then
      Result := gfJpeg
    else if AreBytesEqual(bytes, PNG_SIGNATURE) then
      Result := gfPng
    else
      Result := gfUnkonwn;
  finally
    aStream.Position := currentPos;
  end;
end;

procedure TPictureHelper.AssignStream(const aStream: TStream);
var
  graphicFormat: TGraphicFormat;
  png: TPngImage;
  jpeg: TJPEGImage;
begin
  graphicFormat := RecognizeGraphicFormat(aStream);
  if graphicFormat = gfPng then
  begin
    png := TPngImage.Create;
    try
      png.LoadFromStream(aStream);
      self.Graphic := png;
    finally
      png.Free;
    end;
  end
  else if graphicFormat = gfJpeg then
  begin
    jpeg := TJPEGImage.Create;
    try
      jpeg.LoadFromStream(aStream);
      self.Graphic := jpeg;
    finally
      jpeg.Free;
    end;
  end
  else
    raise EPictureReadError.Create
      ('Unsupported format: expected JPEG or PNG image');
end;

procedure TPictureHelper.AssignBlobField(const aField: TField);
begin
  Assert(aField <> nil, 'Provided field is NULL');
  if aField is TBlobField then
    self.AssignStream(aField.DataSet.CreateBlobStream(aField, bmRead))
  else
    raise EPictureReadError.Create(Format('Database field %s',
      [aField.FieldName]));
end;

procedure TPictureHelper.AssignBytes(const aBytes: TBytes);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create();
  try
    ms.Write(aBytes, Length(aBytes));
    ms.Position := 0;
    AssignStream(ms);
  finally
    ms.Free;
  end;
end;

end.

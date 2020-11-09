unit Test.Helper.TPicture;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  System.NetEncoding,
  data.DB,
  Datasnap.DBClient,
  Vcl.Graphics,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage,
  {}
  Helper.TPicture;

{$M+}

type

  [TestFixture]
  TestTPictureHelper = class(TObject)
  private
    fOwner: TComponent;
    fPicture: TPicture;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure AssignBytes_PNG;
    procedure AssignBytes_JPEG;
    // --
    procedure AssignBlobField_PNG;
  end;
{$M-}

implementation

// -----------------------------------------------------------------------
// Images - Base64
// -----------------------------------------------------------------------

const
  PNG_DelphiPL_Base64 =
{$REGION}
    'iVBORw0KGgoAAAANSUhEUgAAAEAAAABKCAMAAAA8LKKKAAADAFBMVEXuAhnCeXvq6OjvEB' +
    '/c19f31db1xsj////9+fn58PDxuLr74+TlDBTMvb3fo6XWCQ61np/Sj5HETVCSNzmvGBzO' +
    'ICSYWVmgeHkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' +
    'AAAAAAAAAAAAAAAAAAAAAAAAAAAACZyjt0AAAACXBIWXMAAAsTAAALEwEAmpwYAAAFkElE' +
    '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' +
    'jllf8AX6eJFWaDbXYAAAAASUVORK5CYII=';
{$ENDREGION}
  JPEG_SmartbearLogo_Base64 =
{$REGION}
    '/9j/4AAQSkZJRgABAQEAAQABAAD/4QAYRXhpZgAASUkqAAgAAAAAAAAAAAAAAP/hAzVodH' +
    'RwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0i' +
    'VzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYm' +
    'U6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5LjE1NDkx' +
    'MSwgMjAxMy8xMC8yOS0xMTo0NzoxNiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPS' +
    'JodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpE' +
    'ZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY2' +
    '9tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4w' +
    'L21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS' +
    '9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIEVsZW1l' +
    'bnRzIDEzLjAgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjczQzQ1QU' +
    'RGMUMyQjExRUE4RDNBQzg4RjhENTg3MzkxIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlk' +
    'OjczQzQ1QUUwMUMyQjExRUE4RDNBQzg4RjhENTg3MzkxIj4gPHhtcE1NOkRlcml2ZWRGcm' +
    '9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6NzNDNDVBREQxQzJCMTFFQThEM0FDODhG' +
    'OEQ1ODczOTEiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6NzNDNDVBREUxQzJCMTFFQT' +
    'hEM0FDODhGOEQ1ODczOTEiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94' +
    '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';
{$ENDREGION}

function GivenBytes(const base64data: string): TBytes;
begin
  Result := TBase64Encoding.Base64.DecodeStringToBytes(base64data);
end;

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestTPictureHelper.Setup;
begin
  fOwner := TComponent.Create(nil);
  fPicture := TPicture.Create;
end;

procedure TestTPictureHelper.TearDown;
begin
  fPicture.Free;
  fOwner.Free;
end;

// -----------------------------------------------------------------------
// Utilites
// -----------------------------------------------------------------------

type
  TVariantArray = array of Variant;

function GivenDataSet(fOwner: TComponent; const data: TArray<TVariantArray>)
  : TDataSet;
var
  dataset: TClientDataSet;
  idx: Integer;
  j: Integer;
begin
  dataset := TClientDataSet.Create(fOwner);
  with dataset do
  begin
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('title', ftWideString, 50);
    FieldDefs.Add('image', ftBlob);
    CreateDataSet;
  end;
  for idx := 0 to High(data) do
  begin
    dataset.Append;
    for j := 0 to High(data[idx]) do
      dataset.Fields[j].Value := data[idx][j];
    dataset.Post;
  end;
  dataset.First;
  Result := dataset;
end;

// -----------------------------------------------------------------------
// Tests - AssignBytes
// -----------------------------------------------------------------------

procedure TestTPictureHelper.AssignBytes_PNG;
var
  bytes: TBytes;
begin
  bytes := GivenBytes(PNG_DelphiPL_Base64);

  fPicture.AssignBytes(bytes);

  Assert.IsTrue(fPicture.Graphic is TPNGImage, 'Expected PNG graphic');
  Assert.AreEqual(74, (fPicture.Graphic as TPNGImage).Height);
end;

procedure TestTPictureHelper.AssignBytes_JPEG;
var
  bytes: TBytes;
begin
  bytes := GivenBytes(JPEG_SmartbearLogo_Base64);

  fPicture.AssignBytes(bytes);

  Assert.IsTrue(fPicture.Graphic is TJPEGImage, 'Expected JPEG graphic');
  Assert.AreEqual(220, (fPicture.Graphic as TJPEGImage).Height);
end;

// -----------------------------------------------------------------------
// Tests - TField
// -----------------------------------------------------------------------

procedure TestTPictureHelper.AssignBlobField_PNG;
var
  imagebytes: TBytes;
  dataset: TDataSet;
begin
  dataset := GivenDataSet(fOwner, [
    { } [1, 'delphipl.png', GivenBytes(PNG_DelphiPL_Base64)]]);

  fPicture.AssignBlobField(dataset.FieldByName('image'));

  Assert.IsTrue(fPicture.Graphic is TPngImage, 'Expected PNG graphic');
  Assert.AreEqual(74, (fPicture.Graphic as TPngImage).Height);
end;

initialization

TDUnitX.RegisterTestFixture(TestTPictureHelper);

end.

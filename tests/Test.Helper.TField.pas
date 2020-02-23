unit Test.Helper.TField;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  Data.DB,
  Datasnap.DBClient,

  Helper.TField;

{$M+}

type

  [TestFixture]
  TestTFieldHelper = class(TObject)
  private
    fOwner: TComponent;
    fDataset: TDataSet;
    fBytes: TBytes;
    fMemoryStream: TMemoryStream;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure SetBlobFromBase64String_Size;
    procedure SetBlobFromBase64String_Siganture;
    procedure SetBlobFromBase64String_LoadToPngImage;
    procedure SetBlobFromBase64String_WillRaise;
    procedure CheckBlobImageFormat_PNG;
    procedure CheckBlobImageFormat_Jpeg;
  end;

implementation

uses
  Vcl.Imaging.pngimage;

// -----------------------------------------------------------------------
// Utilities
// -----------------------------------------------------------------------

function Givien_DataSet(aOwner: TComponent): TDataSet;
var
  aDataset: TClientDataSet;
begin
  aDataset := TClientDataSet.Create(aOwner);
  with aDataset do
  begin
    FieldDefs.Add('id', ftInteger);
    FieldDefs.Add('blob', ftBlob);
    FieldDefs[0].Required := True;
  end;
  aDataset.CreateDataSet;
  Result := aDataset;
end;

// -----------------------------------------------------------------------
// Test Setup and TearDown
// -----------------------------------------------------------------------

procedure TestTFieldHelper.Setup;
begin
  fOwner := TComponent.Create(nil);
  fMemoryStream := TMemoryStream.Create;
end;

procedure TestTFieldHelper.TearDown;
begin
  fOwner.Free;
  fMemoryStream.Free;
end;

// -----------------------------------------------------------------------
// Images
// -----------------------------------------------------------------------

const
  PNG_IMAGE1 = 'iVBORw0KGgoAAAANSUhEUgAAAHwAAAAbCAMAAACJMRtuAAAAclBMVEX////w' +
    '8PDZ2dn/248AAADb/v85OY85AwCP2////bYAOZDbjzm2/v9mtv9mCAA5j9vb' +
    '248BDmZmDDlmFGb//tv/tmbb/LYABDkAZra22484EGaQOgA4ZWW2ZgC2ZmaP' +
    'OTiPZQC2/LaPZo86OmZmOTk6Bznxkw7DAAABV0lEQVRIx+1W7W6DMAzMSsKA' +
    'hAIbtKys+977v+IOX5WBWDfWPxEqVpWcE/sOOylC3QS0axbfBDKKqyAm4ptA' +
    '4uErX6Z4FJuLw6fiVmtdzCagE90iKYdXd5kZczSA7Vxxi+z6zfxPHAMeIAd4' +
    '/0jIkW5F3VZOqSc3U/wuwSC17JMofkFBHlfOaqC6Q1myJhVnFOdgi2OhUuGQ' +
    'tfrZ01XuFM7UH8X5ZOm9Q3aJYpps57G0se1pub/b5l5XcqDVgB2euNg4OKFD' +
    'oG1TCSedOSOOyrKyP8TqITaI85hnK+SRXxuJY0bZA3FCHsthSOfOth0RsWHO' +
    'GH8m/cyf3x+03WpYMWg74EQc428Xjg1lzhibfh+97DtIavjcxFLdYRV9n1y4' +
    'V2k7w0H3x1+NDS4p6LE6av0YG0wFD6ChL9H7xBcrHPk3XXu6cAxn6vLfcKv4' +
    'Kr6oLxmYWi2EfQE93BbPGkadYAAAAABJRU5ErkJggg==';

  JPEG_IMAGE1 =
    '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMF' +
    'BwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYD' +
    'AwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwM' +
    'DAwMDAz/wgARCAAeAB4DAREAAhEBAxEB/8QAGQAAAwADAAAAAAAAAAAAAAAABQcIAgYJ' +
    '/8QAGwEAAgIDAQAAAAAAAAAAAAAABAUDBwECBgj/2gAMAwEAAhADEAAAAH55x7xJvIUy' +
    '20xLGpKuyY9sGJD9FHq5Sjs1T7WIbDIRrWMOQvvyqZ13YJwHOoEkP//EAC8QAAEDAwIG' +
    'AgEBCQAAAAAAAAECAwQFBhESIQAHCBMiMQkUMhUXI0FRUnGDobH/2gAIAQEAAT8AF2UV' +
    't4IV2Vup/dNuL1dv8AoeOMkAbAn2VYO3HVv1rHphqtIYh0SDXzWm3XXUO1FyN2gkpAHi' +
    'hWdWV5GwTjx1HgfLrNQ8pSeW9BydI3rb2Nv8G2T7/mOKP8yCX3pTcnl1Rw6heA2xVHig' +
    'JH8SQhKtRzn0Qc8SY8ZLwL3eCGUax9dKsupHiHEhWTgAYPrP/Ove9oX7VqfAn0lupNU+' +
    'ltmP9iQuIWu4ckkN41atAznP+9xe1vMP6U2pR9Zz4Lqksr297BYPFKrdEhX1Uag5btKS' +
    'h9sj6cmW92Gsr/JCtYXvoPiVEAes++IfLei3XWIFGgzPp1N1tZjtPzCHpyG0YIAAUopT' +
    'nOcYByRvx1y3tdPKHqVrVtQrbtetoosWNHalzbN/WZISY6XNCHcZDSdRITpABzvvxdPO' +
    'K8+aFtSqGbdgrhrdbckooFlJZUwpBC063WGStpONyCpIUkbkpPHLC3r+gVmbPs63rsqj' +
    'wZRHcl0q1Hau0hBw521K+s80F7oOMBY/sd7usi5K/ZT1Yl1ePGrtpOu1GK4zlbYS35BI' +
    'JSCCAMDIIykHAyRxffyz3nVobdPixqjAZYw1LW3VgFzz/V4MJDer2QnIGcbgbo+Sqt0q' +
    'zbop1HthNKRVIUpLq0XDLJR3GSC4dKU9xWFelYB9Z46auve5+kjlWza1ApMeZCdcTNUt' +
    'dYmQ/NTaEfgwpKPxbRvjj//EAB4RAAICAwADAQAAAAAAAAAAAAABAhEDBAUSEyEU/9oA' +
    'CAECAQE/AJSRz+b7kLgi4KojBuRwY1Av6Rfw0NN7Co5+t+bFRBJkYKrODmcMtEcnm6Mb' +
    'Z5tH/8QAHREAAwACAgMAAAAAAAAAAAAAAAECAxEEIRITMf/aAAgBAwEBPwAuyc+kPmI8' +
    'yjJGpKT2RRCLjo9b2zGYy30T9Z//2Q==';

// -----------------------------------------------------------------------
// Tests - SetBlobFromBase64String
// -----------------------------------------------------------------------

procedure TestTFieldHelper.SetBlobFromBase64String_Size;
begin
  fDataset := Givien_DataSet(fOwner);

  fDataset.Append;
  fDataset.FieldByName('id').AsInteger := 1;
  fDataset.FieldByName('blob').SetBlobFromBase64String(PNG_IMAGE1);
  fDataset.Post;

  fBytes := TBlobField(fDataset.FieldByName('blob')).Value;

  Assert.AreEqual(526, Length(fBytes));
end;

procedure TestTFieldHelper.SetBlobFromBase64String_Siganture;
var
  aSignature: String;
begin
  fDataset := Givien_DataSet(fOwner);

  fDataset.Append;
  fDataset.FieldByName('id').AsInteger := 1;
  fDataset.FieldByName('blob').SetBlobFromBase64String(PNG_IMAGE1);
  fDataset.Post;

  fBytes := TBlobField(fDataset.FieldByName('blob')).Value;
  aSignature := Chr(fBytes[1]) + Chr(fBytes[2]) + Chr(fBytes[3]);

  Assert.AreEqual('PNG', aSignature);
end;

procedure TestTFieldHelper.SetBlobFromBase64String_LoadToPngImage;
var
  aPngImage: TPngImage;
  actualRes: string;
begin
  fDataset := Givien_DataSet(fOwner);

  fDataset.Append;
  fDataset.FieldByName('id').AsInteger := 1;
  fDataset.FieldByName('blob').SetBlobFromBase64String(PNG_IMAGE1);
  fDataset.Post;

  fBytes := TBlobField(fDataset.FieldByName('blob')).Value;
  fMemoryStream.Write(fBytes[0], Length(fBytes));
  fMemoryStream.Position := 0;
  aPngImage := TPngImage.Create;
  aPngImage.LoadFromStream(fMemoryStream);
  actualRes := Format('%dx%d', [aPngImage.Width, aPngImage.Height]);
  aPngImage.Free;

  // 1) no exception was at line: aPngImage.LoadFromStream
  Assert.AreEqual('124x27', actualRes);
end;

procedure TestTFieldHelper.SetBlobFromBase64String_WillRaise;
begin
  fDataset := Givien_DataSet(fOwner);

  fDataset.Append;
  Assert.WillRaise(
    procedure
    begin
      fDataset.FieldByName('id').SetBlobFromBase64String(PNG_IMAGE1);
    end, EDatabaseError);
end;

// -----------------------------------------------------------------------
// Tests - CheckBlobImageFormat
// -----------------------------------------------------------------------

procedure AppendImage(aDataset: TDataSet; aID: Integer;
const aImageBase64: string);
begin
  aDataset.Append;
  aDataset.FieldByName('id').AsInteger := aID;
  aDataset.FieldByName('blob').SetBlobFromBase64String(aImageBase64);
  aDataset.Post;
end;

procedure TestTFieldHelper.CheckBlobImageFormat_PNG;
var
  actualFormat: TImageFormat;
begin
  fDataset := Givien_DataSet(fOwner);
  AppendImage(fDataset, 1, PNG_IMAGE1);

  actualFormat := fDataset.FieldByName('blob').CheckBlobImageFormat;

  Assert.AreEqual(ifPNG, actualFormat);
end;

procedure TestTFieldHelper.CheckBlobImageFormat_Jpeg;
var
  actualFormat: TImageFormat;
begin
  fDataset := Givien_DataSet(fOwner);
  AppendImage(fDataset, 1, JPEG_IMAGE1);

  actualFormat := fDataset.FieldByName('blob').CheckBlobImageFormat;

  Assert.AreEqual(ifJPEG, actualFormat);
end;

initialization

TDUnitX.RegisterTestFixture(TestTFieldHelper);

end.

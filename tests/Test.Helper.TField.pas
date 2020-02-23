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
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure SetBlobFromBase64String_Size;
  end;

implementation

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
end;

procedure TestTFieldHelper.TearDown;
begin
  fOwner.Free;
end;

// -----------------------------------------------------------------------
// Tests
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


initialization

TDUnitX.RegisterTestFixture(TestTFieldHelper);

end.

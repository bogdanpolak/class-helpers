unit Frame.ByteAndStreamHelpers;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  Winapi.Windows, Winapi.Messages,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TBytesStreamHelpersFrame = class(TFrame)
    FlowPanel1: TFlowPanel;
    btnShowPngImage: TButton;
    Memo1: TMemo;
    Image1: TImage;
    ScrollBox1: TScrollBox;
    Splitter1: TSplitter;
    btnShowSmaile: TButton;
    btnShowJPEG: TButton;
    btnSaveAsTempFile: TButton;
    btnWriteTextToStream: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnShowPngImageClick(Sender: TObject);
    procedure btnShowSmaileClick(Sender: TObject);
    procedure btnShowJPEGClick(Sender: TObject);
    procedure btnSaveAsTempFileClick(Sender: TObject);
    procedure btnWriteTextToStreamClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  System.NetEncoding,
  Vcl.Imaging.pngimage,
  Vcl.Imaging.JPEG,
  Helper.TBytes,
  Helper.TStream;

{$R *.dfm}
// ------------------------------------------------------------------------
// TBytes Helper new method candidates
// ------------------------------------------------------------------------

function BytesAsStream(const aStream: TStream; const aBytes: TBytes): TStream;
var
  aPos: Int64;
begin
  aPos := aStream.Position;
  aStream.Write(aBytes[0], aBytes.Size);
  aStream.Position := aPos;
  Result := aStream;
end;

function SubBytes(const aBytes: TBytes; aIndex: Integer;
  aLength: Integer): TBytes;
begin
  if aIndex + aLength > Length(aBytes) then
    aLength := Length(aBytes) - aIndex;
  SetLength(Result, aLength);
  move(aBytes[0], Result[0], aLength);
end;

function BytesIsEqual(const aBytes1: TBytes; const aBytes2: TBytes): boolean;
var
  i: Integer;
begin
  if Length(aBytes1) <> Length(aBytes2) then
    Exit(False);
  for i := 0 to High(aBytes1) do
  begin
    if aBytes1[i] <> aBytes2[i] then
      Exit(False);
  end;
  Result := True;
end;

// ------------------------------------------------------------------------
// TBytes Helper samples
// ------------------------------------------------------------------------

procedure AssignBytesToPicture(aPicture: TPicture; const aBytes: TBytes);
const
  // . . . . . . . . . . . . . . . P    N    G   lineBreak
  PNG_SIGNATURE: TArray<byte> = [$89, $50, $4E, $47, $0D, $0A, $1A, $0A];
  JPEG_SIGNATURE: TArray<byte> = [$FF, $D8, $FF, $E0];
var
  aStream: TStream;
  aSignature: TBytes;
  aIsPngImage: boolean;
  aIsJpegImage: boolean;
  png: TPngImage;
  JPEG: TJPEGImage;
begin
  if aBytes.Size < 8 then
    raise Exception.Create('Picture data too small. Minimal size is 8 bytes');
  aSignature := SubBytes(aBytes, 0, 8);
  aIsPngImage := BytesIsEqual(aSignature, PNG_SIGNATURE);
  aIsJpegImage := BytesIsEqual(SubBytes(aSignature, 0, 4), JPEG_SIGNATURE);
  if not(aIsPngImage) and not(aIsJpegImage) then
    raise Exception.Create('Not supported image format');
  aStream := BytesAsStream(TMemoryStream.Create, aBytes);
  try
    if aIsPngImage then
    begin
      png := TPngImage.Create;
      try
        png.LoadFromStream(aStream);
        aPicture.Graphic := png;
      finally
        png.Free;
      end;
    end
    else if aIsJpegImage then
    begin
      JPEG := TJPEGImage.Create;
      try
        JPEG.LoadFromStream(aStream);
        aPicture.Graphic := JPEG;
      finally
        JPEG.Free;
      end;
    end
  finally
    aStream.Free;
  end;
end;

procedure TBytesStreamHelpersFrame.btnShowPngImageClick(Sender: TObject);
var
  aBytes: TBytes;
begin
  aBytes.InitialiseFromBase64String
    ('iVBORw0KGgoAAAANSUhEUgAAAFsAAAAaCAMAAADv7NBiAAAAe1BMVEXw8PD/' +
    '///Z2dnwz4c3NofP8PAAAAAoKSmHz/Dw8Ks2AgA1h8+r8PDPz4cANodgEmBd' +
    'qfIABDarYADwq2DPhzeHNgAAYKvw8M+rz4dgCzZgBwA2DmAADGA5ZLPP8Ktg' +
    'YKtlTzk2BjZks9ir8Ks4ZWU4N2VnZkWPZQBgNgB6DF3BAAABJUlEQVRIx+2T' +
    '25LCIAyGU7BZ2m67ldq6B9fVPen7P6EhNGMd8EoZxxlzw58QPgIB2EA6ezrK' +
    'B5tMKZWOnWUjW13fjmy4tj3Yt2XrErECWKAb9CwHiU5dUaHJbJT9ZqD4gkWT' +
    'Q/FeSVLB0YvZL8+exSm1sDm67Kl4OtDcsNIlKf23x+8eW/DebIfY8myMbXHg' +
    'jZn4yqNEpZ5ucIr2c7tvTTc3XbP2XtlC1+TxunkpDgHbRZnIN8+rncAVZZAm' +
    'qniUdJbNzJ/TO5F7ccu2hlcLQHTtvZD9P2F/cobvZStJ2kf1h8NTo52i6Ql7' +
    'Ld6YF627d73iN+gbhCvKW45Ri5VF/CUCKb6dWs4gHvNt2MvwIV3+dzYxNlgq' +
    '9X7+fAq2SmHCzhJYWvYBmzQSEHa+IRoAAAAASUVORK5CYII=');
  AssignBytesToPicture(Image1.Picture, aBytes);
  Memo1.Lines.Add('Image file size: ' + aBytes.Size.ToString);
  Memo1.Lines.Add('  Bytes[1..3] as string: ' + aBytes.GetSectorAsString(1, 3));
  Memo1.Lines.Add('  Bytes[0..7] as hex: ' + aBytes.GetSectorAsHex(0, 8));
  Memo1.Lines.Add('  Chunk length (bytes)' + aBytes.GetReverseLongWord(8)
    .ToString);
  Memo1.Lines.Add('  Chunk header: ' + aBytes.GetSectorAsString(12, 4));
  Memo1.Lines.Add('  Height:' + aBytes.GetReverseLongWord(16).ToString);
  Memo1.Lines.Add('  Width:' + aBytes.GetReverseLongWord(20).ToString);
  Memo1.Lines.Add('  Bit depth:' + Word(aBytes[24]).ToString);
  Memo1.Lines.Add('  CRC: 0x' + IntToHex(aBytes.GetReverseLongWord(29)));
  Memo1.Lines.Add('  --');
  Memo1.Lines.Add('  Chunk length (bytes)' + aBytes.GetReverseLongWord(33)
    .ToString);
  Memo1.Lines.Add('  Chunk header: ' + aBytes.GetSectorAsString(37, 4));
end;

procedure TBytesStreamHelpersFrame.btnShowSmaileClick(Sender: TObject);
var
  aBytes: TBytes;
begin
  aBytes.InitialiseFromBase64String
    ('iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAMAAABHPGVmAAABrVBMVEX+2Gj////vUmQkKz' +
    'j+2Wz/22sAAi7/3Wo1NTr+12H+1lahjVEAJzL/1lkxMznxVWUAAzIuMDkwKzkpLjjuOmPv' +
    'VGX2VGf83IH+2GX/11z/32z923n/2Gn91FE6OTosKzhAPzv16c335bn75Kf64aL51Wvty2' +
    'jvQWP92nT20moAEjT+8c/zUmV1aEYgKDf99+f99Nv258T63ZH90mrox2fkxGa8o1qciVAY' +
    'JTb86bT1pGjzmGaIeEweJTUUITUDHDTz69b94Iz73In92nHy0GndvmTuR2PJrl/Ap1y1nl' +
    'mqlVVMSD3u7ej97L79567945z94ZX712v5v2n4s2jnUmTvTGThUGLDSVqyRFalkFSlQ1GZ' +
    'Pk6Bc0k1LTn9+ezv69717dn446/635v8zWrzkGbfwGXuXGPYumLVtWLPs2CVgk97bUhpX0' +
    'RYUT8NHjX+++728+v379v87cb24rP1q2fziWbwdmTwb2TwSmSOfU6COUhiWUJaMz/86rz6' +
    '6Lv6yGrwfWXXTWDMS12xmlisQ1ORPEx2OEZFLjsKKTXyZWRrNUNOMD719/n39/exLlSEaK' +
    '5lAAAIDUlEQVRo3tzWW08aQRQA4G129szOGCaz4YHltsFyCWKwhaBgAtiLBu/WRxJjbBOi' +
    'CNpan4yxLz73Pxd3t84OLOKCbZqeJ5Ll5Jtz5szsKq/+QvxbyJvFvUw5Eonn8wjlI+8P0t' +
    'elkxdFrq6/xAlN0ih5CNMkJEppKKpE0t9PXgTZfbsaITREFGSHYof7m1CqfPh8NStyvPeB' +
    'JG1A8QkHMsul3RmQd+k4JYoA/CElSiN70yLfMogSITzlkGT+birkLk8VIUxkaLwUGJmPJI' +
    'lNBGAOroIhq8RpVCCGKq8DIG/eJ0WnAjAmLT8bWVRCggjGhCLzz0PuqCmMoAoxS89B9kWr' +
    'plEU8noykk4KYjqFfp6EpClSZg2h+CP7s9Qhtv/6KWRV1DFTREvjkUVhzBhkfhzy1jRfCE' +
    'EkPgY5jhBhzLwtZX8k4zYLxzCOacoUoYlMRH/4IYshx9CW76tzrYXgDMa5lWp1cx1L2yIh' +
    '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');
  AssignBytesToPicture(Image1.Picture, aBytes);
end;

procedure TBytesStreamHelpersFrame.btnShowJPEGClick(Sender: TObject);
var
  aBytes: TBytes;
begin
  aBytes.InitialiseFromBase64String
    ('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');
  AssignBytesToPicture(Image1.Picture, aBytes);
  Memo1.Lines.Add('Image file size: ' + aBytes.Size.ToString);
  Memo1.Lines.Add('  Bytes[0..3] as hex: ' + aBytes.GetSectorAsHex(0, 4));
  Memo1.Lines.Add('  Bytes[3,4] as word (reverse): ' + aBytes.GetReverseWord(4)
    .ToString);
  Memo1.Lines.Add('  Bytes[6..9] as string: ' + aBytes.GetSectorAsString(6, 4));
  Memo1.Lines.Add('  Byte[10] Zero: ' + IntToStr(aBytes[10]));
  Memo1.Lines.Add('  Bytes[11,12] Version: ' + Format('%d.%d',
    [aBytes[11], aBytes[13]]));
end;

// ------------------------------------------------------------------------
// TStream Helper samples
// ------------------------------------------------------------------------

procedure TBytesStreamHelpersFrame.btnSaveAsTempFileClick(Sender: TObject);
var
  aBytes: TBytes;
  ms: TMemoryStream;
  png: TPngImage;
  aFileName: string;
  aTempPngFileName: string;
begin
  Memo1.Lines.Add('--------------------------------');
  aBytes.InitialiseFromBase64String
    ('iVBORw0KGgoAAAANSUhEUgAAAFsAAAAaCAMAAADv7NBiAAAAe1BMVEXw8PD/' +
    '///Z2dnwz4c3NofP8PAAAAAoKSmHz/Dw8Ks2AgA1h8+r8PDPz4cANodgEmBd' +
    'qfIABDarYADwq2DPhzeHNgAAYKvw8M+rz4dgCzZgBwA2DmAADGA5ZLPP8Ktg' +
    'YKtlTzk2BjZks9ir8Ks4ZWU4N2VnZkWPZQBgNgB6DF3BAAABJUlEQVRIx+2T' +
    '25LCIAyGU7BZ2m67ldq6B9fVPen7P6EhNGMd8EoZxxlzw58QPgIB2EA6ezrK' +
    'B5tMKZWOnWUjW13fjmy4tj3Yt2XrErECWKAb9CwHiU5dUaHJbJT9ZqD4gkWT' +
    'Q/FeSVLB0YvZL8+exSm1sDm67Kl4OtDcsNIlKf23x+8eW/DebIfY8myMbXHg' +
    'jZn4yqNEpZ5ucIr2c7tvTTc3XbP2XtlC1+TxunkpDgHbRZnIN8+rncAVZZAm' +
    'qniUdJbNzJ/TO5F7ccu2hlcLQHTtvZD9P2F/cobvZStJ2kf1h8NTo52i6Ql7' +
    'Ld6YF627d73iN+gbhCvKW45Ri5VF/CUCKb6dWs4gHvNt2MvwIV3+dzYxNlgq' +
    '9X7+fAq2SmHCzhJYWvYBmzQSEHa+IRoAAAAASUVORK5CYII=');
  ms := TMemoryStream.Create;
  aBytes.SaveToStream(ms);
  ms.Position := 0;
  // -----
  aFileName := ms.SaveToTempFile;
  Memo1.Lines.Add('1. Saved PNG stream to temp file: ' + aFileName);
  aTempPngFileName := ChangeFileExt(aFileName, '.png');
  Memo1.Lines.Add('2. Renamed temp file to: ' + aTempPngFileName);
  RenameFile(aFileName, aTempPngFileName);
  ms.Free;
  // -----
  png := TPngImage.Create;
  Memo1.Lines.Add('3. Loaded PNG image form file');
  png.LoadFromFile(aTempPngFileName);
  Image1.Picture.Graphic := png;
  png.Free;
end;

procedure TBytesStreamHelpersFrame.btnWriteTextToStreamClick(Sender: TObject);
begin
end;

end.

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
    procedure btnShowPngImageClick(Sender: TObject);
    procedure btnShowSmaileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  System.NetEncoding,
  Vcl.Imaging.pngimage,
  Helper.TBytes,
  Helper.TStream;

{$R *.dfm}

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

procedure AssignBytesToPicture(aPicture: TPicture; const aBytes: TBytes);
const
  // . . . . . . . . . . . . . . . P    N    G   lineBreak
  PNG_HEADER: TArray<byte> = [$89, $50, $4E, $47, $0D, $0A, $1A, $0A];
var
  png: TPngImage;
  aStream: TStream;
begin
  if aBytes.Size < 0 then
    raise Exception.Create('Picture data too small. Minimal size is 8 bytes');
  if BytesIsEqual(SubBytes(aBytes, 0, 8), PNG_HEADER) then
  begin
    png := TPngImage.Create;
    try
      aStream := BytesAsStream(TMemoryStream.Create, aBytes);
      try
        png.LoadFromStream(aStream);
        aPicture.Graphic := png;
      finally
        aStream.Free;
      end;
    finally
      png.Free;
    end;
  end
  else
    raise Exception.Create('Not supported image format');
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

end.

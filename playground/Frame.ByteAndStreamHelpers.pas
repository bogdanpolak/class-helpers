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
    procedure btnShowPngImageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
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

procedure TBytesStreamHelpersFrame.btnShowPngImageClick(Sender: TObject);
var
  aBytes: TBytes;
  png: TPngImage;
  aStream: TStream;
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
  aStream := BytesAsStream(TMemoryStream.Create, aBytes);
  // -----
  png := TPngImage.Create;
  png.LoadFromStream(aStream);
  Image1.Picture.Graphic := png;
  Memo1.Lines.Add('Image file size: ' + aBytes.Size.ToString);
  Memo1.Lines.Add('  Bytes[1..3] as string: ' + aBytes.GetSectorAsString(1, 3));
  Memo1.Lines.Add('  Bytes[0..7] as hex: ' + aBytes.GetSectorAsHex(0, 8));
  Memo1.Lines.Add('  Chunk length (bytes)' + aBytes.GetReverseLongWord(8).ToString);
  Memo1.Lines.Add('  Chunk header: ' + aBytes.GetSectorAsString(12, 4));
  Memo1.Lines.Add('  Height:' + aBytes.GetReverseLongWord(16).ToString);
  Memo1.Lines.Add('  Width:' + aBytes.GetReverseLongWord(20).ToString);
  Memo1.Lines.Add('  Bit depth:' + Word(aBytes[24]).ToString);
  Memo1.Lines.Add('  CRC: 0x' + IntToHex(aBytes.GetReverseLongWord(29)));
  Memo1.Lines.Add('  --');
  Memo1.Lines.Add('  Chunk length (bytes)' + aBytes.GetReverseLongWord(33).ToString);
  Memo1.Lines.Add('  Chunk header: ' + aBytes.GetSectorAsString(37, 4));
  aStream.Free;
  png.Free;
end;

end.

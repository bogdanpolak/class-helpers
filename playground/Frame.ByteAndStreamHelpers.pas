unit Frame.ByteAndStreamHelpers;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  Winapi.Windows, Winapi.Messages,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

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
  Helper.TBytes,
  Helper.TStream;

{$R *.dfm}

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
  // -----
  Memo1.Lines.Add ('Image file size: ' + aBytes.Size.ToString);
  Memo1.Lines.Add ('Bytes[1..3] as string: ' + aBytes.GetSectorAsString(1, 3));
  Memo1.Lines.Add ('Bytes[0..7] as hex: ' + aBytes.GetSectorAsHex(0, 8));

  {
  Assert.AreEqual(13, aBytes.GetReverseLongWord(8)); // Chunk length (bytes)
  Assert.AreEqual('IHDR', aBytes.GetSectorAsString(12, 4)); // Chunk header
  Assert.AreEqual(91, aBytes.GetReverseLongWord(16)); // Height
  Assert.AreEqual(26, aBytes.GetReverseLongWord(20)); // Width
  Assert.AreEqual(8, Word(aBytes[24])); // Bit depth:
  Assert.AreEqual(3, Word(aBytes[25])); // Color type (3 = PLTE)
  Assert.AreEqual(0, Word(aBytes[26])); // Compression method
  Assert.AreEqual(0, Word(aBytes[27])); // Filter method
  Assert.AreEqual(0, Word(aBytes[28])); // Interlace method
  Assert.AreEqual($EFECD062, aBytes.GetReverseLongWord(29)); // CRC
  // ----------------------------------
  Assert.AreEqual(123, aBytes.GetReverseLongWord(33)); // Chunk length
  Assert.AreEqual('PLTE', aBytes.GetSectorAsString(37, 4)); // Chunk header
  Assert.AreEqual($7A0C5DC1, aBytes.GetSectorCRC32(37, 127)); // Calulate CRC
  Assert.AreEqual($7A0C5DC1, aBytes.GetReverseLongWord(41 + 123)); // CRC
  // ----------------------------------
  Assert.AreEqual(293, aBytes.GetReverseLongWord(168)); // Chunk length
  Assert.AreEqual('IDAT', aBytes.GetSectorAsString(172, 4)); // Chunk header
  Assert.AreEqual($76BE211A, aBytes.GetSectorCRC32(172, 297)); // Calulate CRC
  Assert.AreEqual($76BE211A, aBytes.GetReverseLongWord(176 + 293)); // CRC
  // ----------------------------------
  Assert.AreEqual(0, aBytes.GetReverseLongWord(473)); // Chunk length (bytes)
  Assert.AreEqual('IEND', aBytes.GetSectorAsString(477, 4)); // Chunk header
  Assert.AreEqual($AE426082, aBytes.GetSectorCRC32(477, 4)); // Calulate CRC
  Assert.AreEqual($AE426082, aBytes.GetReverseLongWord(481)); // CRC
  }
end;

end.

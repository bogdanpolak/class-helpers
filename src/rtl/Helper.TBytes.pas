unit Helper.TBytes;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TBytesHelper = record helper for TBytes
  private const
    Version = '1.8';
  private
  public
    // ---------------------
    // Size:
    // ---------------------
    /// <summary>
    ///   Returns size of byte array
    /// </summary>
    function GetSize: Integer;
    /// <summary>
    ///   Changes size of byte array to "aSize" bytes
    /// </summary>
    procedure SetSize(aSize: Integer);
    /// <summary>
    ///   allows to get or set size of byte array
    /// </summary>
    property Size: Integer read GetSize write SetSize;
    // ---------------------
    // InitialiseFrom / Load / Save
    // ---------------------
    procedure LoadFromStream(const aStream: TStream);
    procedure LoadFromFile(const aFileName: string);
    procedure SaveToStream(const aStream: TStream);
    procedure SaveToFile(const aFileName: string);
    /// <summary>
    ///   Encodes provided string "aBase64Str" to array of bytes using
    ///   Base64 encoding algorithm and stores it
    /// </summary>
    procedure InitialiseFromBase64String(const aBase64Str: String);
    // ---------------------
    // Data getters
    // ---------------------
    /// <summary>
    ///   Reads block of bytes starting at "aIndex" position with length
    ///   "aLength" (default: 100 bytes or less if array size is smaller)
    ///   and converts read block to a text of a hex values separated with
    ///   spaces, eg: "A5 13 F0 81 DD 73 89"
    /// </summary>
    function GetSectorAsHex(aIndex: Integer = 0;
      aLength: Integer = 100): string;
    /// <summary>
    ///   Reads block of bytes starting at "aIndex" position with length
    ///   "aLength" (defualt: 100 bytes or less if array size is smaller)
    ///   then converts each readed byte into Unicode character and return
    ///    result as string with all converted characters
    /// </summary>
    function GetSectorAsString(aIndex: Integer = 0;
      aLength: Integer = 100): string;
    /// <summary>
    ///    Reads two bytes at position "aIndex" position and converts them
    ///    into "word" number (0..65535) with little-endian order (first
    ///    byte is less significant)
    /// </summary>
    function GetWord(aIndex: Integer = 0): Word;
    /// <summary>
    ///    Reads two bytes at position "aIndex" position and converts them
    ///    into "word" number (0..65535) using big-endian order (first
    ///    byte is more significant)
    /// </summary>
    function GetReverseWord(aIndex: Integer = 0): Word;
    /// <summary>
    ///    Reads four bytes at position "aIndex" position and converts them
    ///    into "longword" number using little-endian order
    /// </summary>
    function GetLongWord(aIndex: Integer = 0): LongWord;
    /// <summary>
    ///    Reads four bytes at position "aIndex" position and converts them
    ///    into "longword" number using big-endian order
    /// </summary>
    function GetReverseLongWord(aIndex: Integer = 0): LongWord;
    /// <summary>
    ///   Returns sub-block of bytes starting at "aIndex" position with
    ///   length "aLength" (if source array is smaller returns only available
    ///   portion of bytes
    /// </summary>
    function SubBytes(aIndex, aLength: Integer): TBytes;
    // ---------------------
    // Compare
    // ---------------------
    function IsEqual(const aBytes: TBytes): boolean;
    // ---------------------
    // Utils
    // ---------------------
    /// <summary>
    ///   Creates new TMemoryStream object and stores byte array. Method is
    ///   not taking ownership of the stream memory and code which is calling
    ///   that method should "Free" returned stream memory.
    /// </summary>
    function CreateStream: TMemoryStream;
    /// <summary>
    ///   Converts byte's array to string encoded with Base64 algorithm
    /// </summary>
    function GenerateBase64Code(aLineLength: Integer = 68): string;
    /// <summary>
    ///   Calculates check sum of the byte's array using CRC32 algorithm
    /// </summary>
    function GetSectorCRC32(aIndex: Integer; aLength: Integer): LongWord;
    // ---------------------
    // Compress
    // ---------------------
    /// <summary>
    ///   Decompress content od the stream "aComressedStream" and
    ///   stores result using ZLib library. Stream has to contain
    ///   vaild ZIP compressed data.
    /// </summary>
    procedure DecompressFromStream(aCompressedStream: TStream);
    /// <summary>
    ///   Compress byte's array using ZLib library (ZIP format) and
    //    as saves results in "aStream" stream.
    /// </summary>
    procedure CompressToStream(aStream: TStream);
  end;

implementation

uses
  System.NetEncoding,
  System.Math,
  System.ZLib;

// -----------------------------------------------------------------------
// Size
// -----------------------------------------------------------------------

function TBytesHelper.GetSize: Integer;
begin
  Result := Length(Self);
end;

procedure TBytesHelper.SetSize(aSize: Integer);
begin
  SetLength(Self, aSize);
end;

// -----------------------------------------------------------------------
// InitialiseFrom / Load / Save
// -----------------------------------------------------------------------

procedure TBytesHelper.InitialiseFromBase64String(const aBase64Str: String);
begin
  Self := TNetEncoding.Base64.DecodeStringToBytes(aBase64Str);
end;

procedure TBytesHelper.LoadFromFile(const aFileName: string);
var
  aFileStream: TFileStream;
begin
  aFileStream := TFileStream.Create(aFileName, fmOpenRead);
  try
    SetLength(Self, aFileStream.Size);
    aFileStream.Read(Self[0], aFileStream.Size);
  finally
    aFileStream.Free;
  end;
end;

procedure TBytesHelper.LoadFromStream(const aStream: TStream);
begin
  aStream.Position := 0;
  SetLength(Self, aStream.Size);
  aStream.Read(Self[0], aStream.Size);
end;

procedure TBytesHelper.SaveToFile(const aFileName: string);
var
  aFileStream: TFileStream;
begin
  aFileStream := TFileStream.Create(aFileName, fmCreate);
  try
    aFileStream.Write(Self[0], Length(Self));
  finally
    aFileStream.Free;
  end;
end;

procedure TBytesHelper.SaveToStream(const aStream: TStream);
begin
  aStream.Write(Self[0], Length(Self));
end;

// -----------------------------------------------------------------------
// Data getters
// -----------------------------------------------------------------------

function TBytesHelper.GetSectorAsHex(aIndex: Integer = 0;
  aLength: Integer = 100): string;
var
  len: Integer;
  i: Integer;
begin
  len := Min(aLength, Length(Self));
  for i := 0 to len - 1 do
    if Result = '' then
      Result := IntToHex(Self[aIndex + i])
    else
      Result := Result + ' ' + IntToHex(Self[aIndex + i]);
end;

function TBytesHelper.GetSectorAsString(aIndex: Integer = 0;
  aLength: Integer = 100): string;
var
  len: Integer;
  i: Integer;
begin
  len := Min(aLength, Length(Self));
  for i := 0 to len - 1 do
    if Result = '' then
      Result := chr(Self[aIndex + i])
    else
      Result := Result + chr(Self[aIndex + i]);
end;

function TBytesHelper.GetWord(aIndex: Integer = 0): Word;
begin
  Result := Word(Self[aIndex]) or (Word(Self[aIndex + 1] shl 8));
end;

function TBytesHelper.GetReverseWord(aIndex: Integer = 0): Word;
begin
  Result := (Word(Self[aIndex]) shl 8) or Word(Self[aIndex + 1]);
end;

function TBytesHelper.GetLongWord(aIndex: Integer = 0): LongWord;
begin
  Result := LongWord(Self[aIndex]) or (LongWord(Self[aIndex + 1]) shl 8) or
    (LongWord(Self[aIndex + 2]) shl 16) or (LongWord(Self[aIndex + 3]) shl 24);
end;

function TBytesHelper.GetReverseLongWord(aIndex: Integer = 0): LongWord;
begin
  Result := (LongWord(Self[aIndex]) shl 24) or
    (LongWord(Self[aIndex + 1]) shl 16) or (LongWord(Self[aIndex + 2]) shl 8) or
    LongWord(Self[aIndex + 3]);
end;

function TBytesHelper.SubBytes(aIndex: Integer;  aLength: Integer): TBytes;
begin
  if aIndex + aLength > Length(Self) then
    aLength := Length(Self) - aIndex;
  SetLength(Result, aLength);
  move(Self[aIndex], Result[0], aLength);
end;

// -----------------------------------------------------------------------
// Comparers
// -----------------------------------------------------------------------

function TBytesHelper.IsEqual(const aBytes: TBytes): boolean;
var
  i: Integer;
begin
  if Length(Self) <> Length(aBytes) then
    Exit(False);
  for i := 0 to High(Self) do
  begin
    if Self[i] <> aBytes[i] then
      Exit(False);
  end;
  Result := True;
end;

// -----------------------------------------------------------------------
// Utils:
//  * CreateStream - Creates TMemoryStream and files it with bytes
//  * GenerateBase64Code - Fake code generator
//  * GetSectorCRC32 - Calc Checksums
// -----------------------------------------------------------------------

function TBytesHelper.CreateStream: TMemoryStream;
begin
  Result := TMemoryStream.Create;
  Result.Write(Self[0], Length(Self));
  Result.Position := 0;
end;

function TBytesHelper.GenerateBase64Code(aLineLength: Integer = 68): string;
var
  sBase64: string;
  sDecodedLines: string;
  sLine: string;
begin
  sBase64 := TNetEncoding.Base64.EncodeBytesToString(Self);
  sBase64 := StringReplace(sBase64, sLineBreak, '', [rfReplaceAll]);
  sDecodedLines := '';
  while Length(sBase64) > 0 do
  begin
    sLine := QuotedStr(sBase64.Substring(0, aLineLength));
    sBase64 := sBase64.Remove(0, aLineLength);
    if sDecodedLines = '' then
      sDecodedLines := sLine
    else
      sDecodedLines := sDecodedLines + ' +' + sLineBreak + sLine;
  end;
  Result := 'aBytes.InitialiseFromBase64String(' + sDecodedLines + ');';
end;

function TBytesHelper.GetSectorCRC32(aIndex: Integer; aLength: Integer)
  : LongWord;
const
  crc32tab: array [0 .. 255] of LongWord = ($00000000, $77073096, $EE0E612C,
    $990951BA, $076DC419, $706AF48F, $E963A535, $9E6495A3, $0EDB8832, $79DCB8A4,
    $E0D5E91E, $97D2D988, $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91, $1DB71064,
    $6AB020F2, $F3B97148, $84BE41DE, $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC, $14015C4F, $63066CD9, $FA0F3D63,
    $8D080DF5, $3B6E20C8, $4C69105E, $D56041E4, $A2677172, $3C03E4D1, $4B04D447,
    $D20D85FD, $A50AB56B, $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940, $32D86CE3,
    $45DF5C75, $DCD60DCF, $ABD13D59, $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F, $2802B89E, $5F058808, $C60CD9B2,
    $B10BE924, $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D, $76DC4190, $01DB7106,
    $98D220BC, $EFD5102A, $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433, $7807C9A2,
    $0F00F934, $9609A88E, $E10E9818, $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E, $6C0695ED, $1B01A57B, $8208F4C1,
    $F50FC457, $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C, $62DD1DDF, $15DA2D49,
    $8CD37CF3, $FBD44C65, $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2, $4ADFA541,
    $3DD895D7, $A4D1C46D, $D3D6F4FB, $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9, $5005713C, $270241AA, $BE0B1010,
    $C90C2086, $5768B525, $206F85B3, $B966D409, $CE61E49F, $5EDEF90E, $29D9C998,
    $B0D09822, $C7D7A8B4, $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD, $EDB88320,
    $9ABFB3B6, $03B6E20C, $74B1D29A, $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8, $E40ECF0B, $9309FF9D, $0A00AE27,
    $7D079EB1, $F00F9344, $8708A3D2, $1E01F268, $6906C2FE, $F762575D, $806567CB,
    $196C3671, $6E6B06E7, $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC, $F9B9DF6F,
    $8EBEEFF9, $17B7BE43, $60B08ED5, $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B, $D80D2BDA, $AF0A1B4C, $36034AF6,
    $41047A60, $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79, $CB61B38C, $BC66831A,
    $256FD2A0, $5268E236, $CC0C7795, $BB0B4703, $220216B9, $5505262F, $C5BA3BBE,
    $B2BD0B28, $2BB45A92, $5CB36A04, $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
    $9B64C2B0, $EC63F226, $756AA39C, $026D930A, $9C0906A9, $EB0E363F, $72076785,
    $05005713, $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38, $92D28E9B, $E5D5BE0D,
    $7CDCEFB7, $0BDBDF21, $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E, $81BE16CD,
    $F6B9265B, $6FB077E1, $18B74777, $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45, $A00AE278, $D70DD2EE, $4E048354,
    $3903B3C2, $A7672661, $D06016F7, $4969474D, $3E6E77DB, $AED16A4A, $D9D65ADC,
    $40DF0B66, $37D83BF0, $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9, $BDBDF21C,
    $CABAC28A, $53B39330, $24B4A3A6, $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94, $B40BBE37, $C30C8EA1, $5A05DF1B,
    $2D02EF8D);
var
  i: LongWord;
begin
  Result := $FFFFFFFF;
  for i := 0 to aLength - 1 do
    Result := (Result shr 8) xor
    { } crc32tab[Self[LongWord(aIndex) + i] xor byte(Result and $000000FF)];
  Result := not Result;
end;

// ---------------------
// Compress
procedure TBytesHelper.DecompressFromStream(aCompressedStream: TStream);
var
  decompressionStream: TZDecompressionStream;
  ms: TMemoryStream;
begin
  decompressionStream := TZDecompressionStream.Create(aCompressedStream);
  try
    ms := TMemoryStream.Create;
    try
      ms.CopyFrom(decompressionStream, 0);
      self.LoadFromStream(ms);
    finally
      ms.Free;
    end;
  finally
    decompressionStream.Free;
  end;
end;

procedure TBytesHelper.CompressToStream(aStream: TStream);
var
  ms: TMemoryStream;
  compressionStream: TZCompressionStream;
begin
  ms := TMemoryStream.Create;
  try
    self.SaveToStream(ms);
    ms.Position := 0;
    compressionStream := TZCompressionStream.Create(aStream);
    try
      compressionStream.CopyFrom(ms, 0);
    finally
      compressionStream.Free;
    end;
  finally
    ms.Free;
  end;
end;

end.

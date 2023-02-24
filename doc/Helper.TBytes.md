# Helper.TBytes

## GetSize, SetSize, Size

```
function GetSize(): Integer;
procedure SetSize(aSize: Integer);
property Size: Integer read GetSize write SetSize;
```

* Function `GetSize` returns size of a byte's array,
* Procedure `SetSize` changes size of a byte's array to *aSize* bytes,
* Property `Size` allows to get or set size of byte array.

Sample:
```
var
  bytes: TBytes;
begin
  bytes := [1, 2, 3, 4, 5];
  writeln(bytes.GetSize);  // 5
  bytes.SetSize(20);
  writeln(bytes.GetSize);  // 20
  bytes.Size := 28;
  writeln(bytes.Size);     // 28
end;
```

## Load, Save and initialize

```
procedure LoadFromStream(const aStream: TStream);
procedure LoadFromFile(const aFileName: string);
procedure SaveToStream(const aStream: TStream);
procedure SaveToFile(const aFileName: string);
procedure InitialiseFromBase64String(const aBase64Str: String);
```

* Procedures `LoadFromStream` and `LoadFromFile` allows to populate an array of bytes with data from a file or from a stream,
* Procedures `SaveToStream` and `SaveToFile` allows to write an array of bytes in a stream or in a file,
* Procedure `InitialiseFromBase64String` encodes provided string *aBase64Str* to an array of bytes using Base64 encoding algorithm.

Sample:
```
var
  bytes: TBytes;
  memorystream: TMemoryStream;
begin
  bytes := [1, 2, 3, 4, 5];
  memorystream:= TMemoryStream.Create();
  bytes.SaveToFile('numbers.dat');
  bytes := [6, 7];
  bytes.SaveToStream(memorystream);
  bytes.InitialiseFromBase64String('U2FtcGxlIHRleHQ=');
  writeln(BytesToUft8String(bytes));   // 'Sample text'
  bytes.LoadFromFile('numbers.dat');
  writeln(BytesToText(bytes));         // [1, 2, 3, 4, 5]
  memorystream.Position := 0;
  bytes.LoadFromStream(memorystream);
  writeln(BytesToText(bytes));         // [6, 7]
  memorystream.Free;
end;
```

## Block readers

```
function GetSectorAsHex(aIndex: Integer = 0;  aLength: Integer = 100): string;
function GetSectorAsString(aIndex: Integer = 0;  aLength: Integer = 100): string;
function GetWord(aIndex: Integer = 0): Word;
function GetReverseWord(aIndex: Integer = 0): Word;
function GetLongWord(aIndex: Integer = 0): LongWord;
function GetReverseLongWord(aIndex: Integer = 0): LongWord;
function SubBytes(aIndex, aLength: Integer): TBytes;
```

* Function `GetSectorAsHex` reads block of bytes starting at *aIndex* position with length *aLength* bytes (default length is equal to 100 bytes or less if size of byte's array is smaller) and converts read block to a text of a hex values separated with spaces,
* Function `GetSectorAsString` reads block of bytes from the array starting at *aIndex* position with length *aLength* bytes and converts each byte into Unicode character,
* Function `GetWord` reads two bytes at position *aIndex* position and converts them into `word` number (0..65535) using little-endian order (first byte is less significant) and function `GetReverseWord` is using big-endian order,
* Functions `GetLongWord` and `GetReverseLongWord` are similar, but read 4 bytes
* Function `SubBytes` returns sub-block (array of bytes) starting at *aIndex* position with length *aLength* bytes

Sample:
```
var
  bytes: TBytes;
begin
  bytes := [0, 0, 15, 16, $A0, 255, 0, 0];
  writeln(bytes.GetSectorAsHex(2, 4));        // '0F 10 A0 FF'
  bytes := GivenPNGImageAsBytes;
  writeln(bytes.GetSectorAsString(1, 3));  // 'PNG'
  bytes := [0, ,0, 2, 0, 0, 0, 255];
  writeln(bytes.GetLongWord(2));             //  2
  bytes := [255, ,255, 0, 0, 0, 3, 255];
  writeln(bytes.GetReverseLongWord(2));      //  3
  bytes := [255, 255, 16, 0, 255, 255, 255];
  writeln(bytes.SubBytes(2,2).GetWord(0));   // 16
end;
```

## Compare

```
function IsEqual(const aBytes: TBytes): boolean;
```

Sample:
```
var
  bytes1, bytes2: TBytes;
begin
  bytes1 := [0, 255, 0];
  bytes2 := [0, 255];
  writeln(bytes1.IsEqual(bytes2));                // False;
  writeln(bytes1.SubBytes(0,2).IsEqual(bytes2));  // True;
```

## Misc utility functions

```
function CreateStream: TMemoryStream;
function GenerateBase64Code(aLineLength: Integer = 68): string;
function CalculateCRC32(aIndex: Integer = 0; aLength: Integer = -1): LongWord;
procedure FromAscii(const aText: string);
```

* Function `CreateStream` creates new TMemoryStream object and stores byte array. Method is not taking ownership of the stream memory and code which is calling that method should "Free" returned stream memory,
* Function `GenerateBase64Code` converts a byte's array to a text string encoded using the Base64 algorithm,
* Function `CalculateCRC32` calculates check sum of the byte's array using the CRC32 algorithm. By default it calcualtes check sum of the whole byte array, but parameters allows to provide range of bytes starting from the index `aIndex` and/or using `aLength` bytes.
* Function `FromAscii` is initalizing size and content of the byte array from the string which has contain only ASCII characters: #0 .. #128

Sample:
```
  fBytes.FromAscii('Bogdan Polak.');
  writeln(IntToHex(fBytes.CalculateCRC32())); // '5ECDA8F5'
  writeln(fBytes.GenerateBase64Code());  // 'AEJvZ2RhbiBQb2xhaw=='
  ms := fBytes.CreateStream(); // ms: TMemoryStream
  writeln(PAnsiChar(ms.Memory)+12)^); // '.'
  ms.Free;
```

## ZLib compression

```
procedure DecompressFromStream(aCompressedStream: TStream);
procedure CompressToStream(aStream: TStream);
```

* Procedure `DecompressFromStream` decompress content od the stream *aCompressedStream* using ZLib library. Stream has to contain a valid ZIP's compressed data,
* Procedure `CompressToStream` compress an array of bytes using ZLib library (ZIP format) and saves results in *aStream* stream.

Sample:
```
  // TODO: Add sample
```

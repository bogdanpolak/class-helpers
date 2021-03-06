﻿unit Helper.TStream;

interface

uses
  System.Classes,
  System.SysUtils;

type
  EStreamException = class(Exception);

  TStreamHelper = class helper for TStream
  private const
    Version = '1.8';
  private
  public
    /// <summary>
    ///   Saves the entire contents of the stream to a file (method can be
    ///   overwritten in inherited classes)
    /// </summary>
    procedure SaveToFile(aFileName: string);
    /// <summary>
    ///   Saves whole contet of the stream into a temporary file in the
    ///   temporary operating system folder (for Windows 10 it is:
    ///   `C:\Users\{profile}\AppData\Local\Temp\`. This method returns
    ///   a name of newlly created file
    ///   Saves the entire stream content to a temporary file in the temporary
    ///   operating system folder (for Windows 10:
    ///   `C:\Users\{profile}\AppData\Local\Temp\`). This method returns the
    ///   name of the newly created file
    /// </summary>
    function SaveToTempFile: string;
    /// <summary>
    ///   Reads whole content of the stream interprets this as UTF8 unicode
    ///   text and return as String. Accepts the optional "aEncoding" parameter,
    ///   which allows stream bytes to be interpreted as differently encoded
    ///   text, eg: ANSI text, UTF16 text or other.
    /// </summary>
    function AsString: string; overload;
    function AsString(aEncoding: TEncoding): string; overload;
    /// <summary>
    ///   Convert whole bytes from the stream or portion of it into string of
    ///   a hex values. If parameter "aByteCount" is equal to 0 then method is
    ///   converting all bytes (be careful with a big streams) otherwise is
    ///   converting only provided numbers of bytes
    /// </summary>
    function ToHexString(aByteCount: integer = 0): string;
    /// <summary>
    ///   Writes a string to the stream using the UTF8 encodeing (by default)
    ///   or any other provided encoding.
    /// </summary>
    procedure WriteString(const aText: string); overload;
    procedure WriteString(const aText: string; aEncoding: TEncoding); overload;
    /// <summary>
    ///   Writes a string finished with thne system End of Line code to the
    ///   stream using the UTF8 encodeing (by default) or any other provided
    ///   encoding.
    /// </summary>
    procedure WriteLine(const aText: string); overload;
    procedure WriteLine(const aText: string; aEncoding: TEncoding); overload;
  end;

implementation

uses
  System.IOUtils;

procedure TStreamHelper.SaveToFile(aFileName: string);
var
  fs: TFileStream;
begin
  if Self.Size = 0 then
    raise EStreamException.Create('Not able to save empty stream');
  Self.Position := 0;
  fs := TFileStream.Create(aFileName, fmCreate);
  try
    fs.CopyFrom(Self, Self.Size);
  finally
    fs.Free;
  end;
end;

function TStreamHelper.SaveToTempFile: string;
begin
  Result := TPath.GetTempFileName;
  SaveToFile(Result);
end;

function TStreamHelper.AsString: string;
begin
  Result := AsString(TEncoding.UTF8);
end;

function TStreamHelper.AsString(aEncoding: TEncoding): string;
var
  aBytes: TBytes;
begin
  Self.Position := 0;
  SetLength(aBytes, Self.Size);
  Self.Read(aBytes, Self.Size);
  Result := aEncoding.GetString(aBytes);
end;

function TStreamHelper.ToHexString(aByteCount: integer = 0): string;
var
  aBytes: TBytes;
  idx: Integer;
begin
  SetLength(aBytes, Self.Size);
  Self.Position := 0;
  Self.Read(aBytes[0], Self.Size);
  if aByteCount<=0 then
    aByteCount := Length(aBytes)
  else if aByteCount>Length(aBytes) then
    aByteCount:=Length(aBytes);
  Result := '';
  for idx := 0 to aByteCount-1 do
    if idx = 0 then
      Result := IntToHex(aBytes[0], 2)
    else
      Result := Result + ' ' + IntToHex(aBytes[idx], 2);
end;

procedure TStreamHelper.WriteString(const aText: string);
begin
  WriteString(aText, TEncoding.UTF8);
end;

procedure TStreamHelper.WriteString(const aText: string; aEncoding: TEncoding);
var
  aBytes: TBytes;
begin
  aBytes := aEncoding.GetBytes(aText);
  Self.Write(aBytes[0], Length(aBytes))
end;

procedure TStreamHelper.WriteLine(const aText: string);
begin
  WriteString(aText + sLineBreak, TEncoding.UTF8);
end;

procedure TStreamHelper.WriteLine(const aText: string; aEncoding: TEncoding);
begin
  WriteString(aText + sLineBreak, aEncoding);
end;

end.

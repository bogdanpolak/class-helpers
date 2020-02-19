unit Helper.TStream;

interface

uses
  System.Classes,
  System.SysUtils;

type
  EStreamException = class(Exception);

  TStreamHelper = class helper for TStream
  private const
    Version = '1.6';
  private
  public
    procedure SaveToFile(aFileName: string);
    function SaveToTempFile: string;
    function AsString: string; overload;
    function AsString(aEncoding: TEncoding): string; overload;
    procedure WriteString(const aText: string); overload;
    procedure WriteString(const aText: string; aEncoding: TEncoding); overload;
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

end;

function TStreamHelper.AsString(aEncoding: TEncoding): string;
begin

end;

procedure TStreamHelper.WriteLine(const aText: string);
begin

end;

procedure TStreamHelper.WriteLine(const aText: string; aEncoding: TEncoding);
begin

end;

procedure TStreamHelper.WriteString(const aText: string);
begin

end;

procedure TStreamHelper.WriteString(const aText: string; aEncoding: TEncoding);
begin

end;

end.

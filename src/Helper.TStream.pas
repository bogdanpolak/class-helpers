unit Helper.TStream;

interface

uses
  System.Classes,
  System.SysUtils;

type
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

procedure TStreamHelper.SaveToFile(aFileName: string);
begin

end;

function TStreamHelper.SaveToTempFile: string;
begin

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

unit Helper.TApplication;

interface

uses
  Vcl.Forms;

type
  TApplicationHelper = class helper for TApplication
  private const
    Version = '1.6';
  public
    { TODO: Please add XML Documentation here }
    function InDeveloperMode: boolean;
  end;

implementation

uses
  System.SysUtils;

function TApplicationHelper.InDeveloperMode: boolean;
var
  Extention: string;
  AExeName: string;
  ProjectFileName: string;
begin
{$IFDEF DEBUG}
  Extention := '.dpr';
  AExeName := ExtractFileName(Application.ExeName);
  ProjectFileName := ChangeFileExt(AExeName, Extention);
  Result := FileExists(ProjectFileName) or
    FileExists('..\..\' + ProjectFileName);
{$ELSE}
  Result := False;
{$ENDIF}
end;

end.

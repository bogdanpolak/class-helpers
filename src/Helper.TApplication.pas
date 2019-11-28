unit Helper.TApplication;

interface

uses
  Vcl.Forms;

type
  THelperApplication = class helper for TApplication
  const
    // * --------------------------------------------------------------------
    ReleaseDate = '2019.11.04';
    ReleaseVersion = '1.1';
    // * --------------------------------------------------------------------
  public
    { TODO: Please add XML Documentation here }
    function InDeveloperMode: boolean;
  end;

implementation

uses
  System.SysUtils;

function THelperApplication.InDeveloperMode: boolean;
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

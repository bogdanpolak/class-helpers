unit Main;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,

  AppConfiguration;

type
  TMainApplication = class
  private
    fAppConfig: TAppConfiguration;
    fSilentMode: boolean;
    procedure ValidateSourceDir();
    function ExtractInputParameters(): string;
    function ScanSourceDir(const aFilter: string): TArray<string>;
  public
    constructor Create();
    destructor Destroy; override;
    procedure ExecuteApplication();
    class procedure Run;
  end;

implementation

uses
  HelperPascalProcessor;

constructor TMainApplication.Create();
begin
  fAppConfig := TAppConfiguration.Create;
  fAppConfig.LoadFromFile;
  fSilentMode := true;
end;

destructor TMainApplication.Destroy;
begin
  fAppConfig.Free;
  inherited;
end;

procedure TMainApplication.ValidateSourceDir();
var
  aSourceDir: string;
begin
  aSourceDir := fAppConfig.GetHelperSourceDiectory;
  if not DirectoryExists(aSourceDir) then
  begin
    writeln(Format
      ('Configured source directory [%s] didnt exists. Please update configuration!',
      [aSourceDir]));
    Halt(1);
  end;
end;

function TMainApplication.ScanSourceDir(const aFilter: string): TArray<string>;
var
  FilePath: String;
  Source: String;
begin
  Result := TDirectory.GetFiles(fAppConfig.GetHelperSourceDiectory, aFilter);
end;

procedure TMainApplication.ExecuteApplication();
var
  aNewVersion: string;
  aFiles: TArray<string>;
  aPath: string;
  aSourceText: string;
  aNewSource: string;
begin
  ValidateSourceDir;
  aNewVersion := ExtractInputParameters;
  aFiles := ScanSourceDir('Helper.*.pas');
  for aPath in aFiles do
  begin
    aSourceText := TFile.ReadAllText(aPath, TEncoding.UTF8);
    writeln('Updating: ' + aPath);
    aNewSource := TPascalUnitProcessor.ProcessUnit(aSourceText, aNewVersion);
    if aSourceText <> aNewSource then
      TFile.WriteAllText(aPath, aNewSource, TEncoding.UTF8);
  end;
  if fSilentMode = false then
  begin
    writeln('');
    write('All files was updated. Press [Enter] to close application ...');
    readln;
  end;
end;

function TMainApplication.ExtractInputParameters: string;
var
  version: string;
begin
  if ParamCount = 0 then
  begin
    fSilentMode := false;
    writeln('+--------------------------------------------------------+');
    writeln('|   Class Helper Version Bumper                          |');
    writeln('+--------------------------------------------------------+');
    writeln('| Can''t execute - required version string as parameter   |');
    writeln('| Syntax: version_bumper.exe version                     |');
    writeln('| Sample: version_bumper.exe "1.3"                       |');
    writeln('+--------------------------------------------------------+');
    writeln('');
    writeln('New version number is required to update files!');
    writeln('  Type new version ([Enter] exits application):');
    Write('  New version: ');
    readln(version);
    if Trim(version) = '' then
      Halt(2);
    writeln('');
  end
  else
    version := ParamStr(1);
  Result := version;
end;

class procedure TMainApplication.Run;
var
  App: TMainApplication;
begin
  App := TMainApplication.Create;
  try
    App.ExecuteApplication;
  finally
    App.Free;
  end;
end;

end.

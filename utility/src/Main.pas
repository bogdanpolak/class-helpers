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
  Result := TDirectory.GetFiles(fAppConfig.GetHelperSourceDiectory,
    aFilter);
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
  for aPath in  aFiles do
  begin
    aSourceText := TFile.ReadAllText(aPath,TEncoding.UTF8);
    writeln('Updating: '+aPath);
    aNewSource := THelperPascalProcessor.ProcessUnit(aSourceText,aNewVersion);
    if aSourceText <> aNewSource then
      TFile.WriteAllText(aPath,aNewSource,TEncoding.UTF8);
  end;
  readln;
end;

function TMainApplication.ExtractInputParameters: string;
var
  version: string;
begin
  if ParamCount=0 then
  begin
    Writeln('+--------------------------------------------------------+');
    Writeln('|   Class Helper Version Bumper                          |');
    Writeln('+--------------------------------------------------------+');
    Writeln('| Can''t execute - required version string as parameter   |');
    Writeln('| Syntax: version_bumper.exe version                     |');
    Writeln('| Sample: version_bumper.exe "1.3"                       |');
    Writeln('+--------------------------------------------------------+');
    Writeln('');
    Writeln('   Version number is required!');
    Writeln('   * Type new version ([Enter] exits application):');
    Write('   New version: ');
    Readln(version);
    if Trim(version)='' then
      Halt(2)
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

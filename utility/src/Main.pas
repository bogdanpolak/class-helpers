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
    procedure ValidateSourceConfiguration();
    function ExtractInputParameters(): string;
    procedure ProcessReadmeMarkdown(const aNewVersion: string);
    procedure ProcessSourcePasFiles(const aNewVersion: string);
    procedure WriteProcessErrorAndHalt(const AErrorMsg: string);
  public
    constructor Create();
    destructor Destroy; override;
    procedure ExecuteApplication();
    class procedure Run;
  end;

implementation

uses
  Processor.Utils,
  Processor.PascalUnit,
  Processor.ReadmeMarkdown;

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

procedure TMainApplication.ValidateSourceConfiguration();
var
  aSourceDir: string;
begin
  aSourceDir := fAppConfig.HeplersSourceDir;
  if not DirectoryExists(aSourceDir) then
  begin
    writeln(Format
      ('Configured source directory [%s] didnt exists. Please update configuration!',
      [aSourceDir]));
    Halt(1);
  end;
end;

procedure TMainApplication.WriteProcessErrorAndHalt(const AErrorMsg: string);
begin
  writeln('    [Error] Processing error!');
  writeln('    ' + AErrorMsg);
  Halt(3);
end;

procedure TMainApplication.ProcessReadmeMarkdown(const aNewVersion: string);
var
  aFilePath: string;
  aSourceText: string;
  aNewSource: string;
begin
  aFilePath := fAppConfig.ReadmeFilePath;
  writeln('Updating: ' + aFilePath);
  aSourceText := TFile.ReadAllText(aFilePath, TEncoding.UTF8);
  try
    aNewSource := TReadmeMarkdownProcessor.ProcessReadme(aSourceText,
      aNewVersion, fAppConfig.ReadmeSearchPattern);
  except
    on E: Processor.Utils.EProcessError do
      WriteProcessErrorAndHalt(E.Message);
  end;
  TFile.WriteAllText(aFilePath, aNewSource, TEncoding.UTF8);
end;

procedure TMainApplication.ProcessSourcePasFiles(const aNewVersion: string);
var
  aSourceDir: string;
  aFiles: TArray<string>;
  aPath: string;
  aSourceText: string;
  aNewSource: string;
begin
  aSourceDir := fAppConfig.HeplersSourceDir;
  aFiles := TDirectory.GetFiles(aSourceDir, 'Helper.*.pas');
  for aPath in aFiles do
  begin
    aSourceText := TFile.ReadAllText(aPath, TEncoding.UTF8);
    writeln('Updating: ' + aPath);
    try
      aNewSource := TPascalUnitProcessor.ProcessUnit(aSourceText, aNewVersion);
    except
      on E: Processor.Utils.EProcessError do
        WriteProcessErrorAndHalt(E.Message);
    end;
    if aSourceText <> aNewSource then
      TFile.WriteAllText(aPath, aNewSource, TEncoding.UTF8);
  end;
end;

procedure TMainApplication.ExecuteApplication();
var
  aNewVersion: string;
  aFiles: TArray<string>;
  aPath: string;
  aSourceText: string;
  aNewSource: string;
begin
  ValidateSourceConfiguration;
  aNewVersion := ExtractInputParameters;
  if fAppConfig.ReadmeIsUpdate then
    ProcessReadmeMarkdown(aNewVersion);
  ProcessSourcePasFiles(aNewVersion);
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

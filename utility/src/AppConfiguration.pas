unit AppConfiguration;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.IOUtils;

type
  TAppConfiguration = class
  const
    KeyRootDirectory = 'rootDirectory';
    KeyHeplersSrcDir = 'heplersSourceSubdirectory';
    KeyUpdateReadme = 'updateVersionInReadme';
  private
    FRootDirectory: string;
    FHeplersSubDir: string;
    FIsReadmeUpdate: boolean;
  public
    procedure LoadFromFile;
    function GetHelperSourceDiectory: string;
    property RootDirectory: string read FRootDirectory write FRootDirectory;
    property HeplersSubDir: string read FHeplersSubDir write FHeplersSubDir;
    property IsReadmeUpdate: boolean read FIsReadmeUpdate write FIsReadmeUpdate;
  end;

implementation

{ TAppConfiguration }

function TAppConfiguration.GetHelperSourceDiectory: string;
begin
  Result := RootDirectory + HeplersSubDir;
end;

procedure TAppConfiguration.LoadFromFile;
var
  aJsonData: string;
  jsObject: TJSONObject;
  jsTrue: TJSONTrue;
begin
  aJsonData := TFile.ReadAllText('app-config.json');
  jsObject := TJSONObject.ParseJSONValue(aJsonData) as TJSONObject;
  jsTrue := TJSONTrue.Create;
  try
    RootDirectory := jsObject.GetValue(KeyRootDirectory).Value;
    HeplersSubDir := jsObject.GetValue(KeyHeplersSrcDir).Value;
    IsReadmeUpdate := (jsObject.GetValue(KeyUpdateReadme).Value = jsTrue.Value);
  finally
    jsObject.Free;
    jsTrue.Free;
  end;
end;

end.

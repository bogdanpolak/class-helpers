unit AppConfiguration;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.IOUtils;

type
  TAppConfiguration = class
  private const
    KeyHeplersSrcDir = 'heplersUnitsSubdirectory';
    KeyReadmeIsUpdate = 'readmeIsUpdateVersion';
    KeyReadmeFilePath = 'readmeFileName';
    KeyReadmeSearchPattern = 'readmeSearchPattern';
  private
    FRootDirectory: string;
    FHeplersSubDir: string;
    FReadmeIsUpdate: boolean;
    FReadmeFilePath: string;
    FReadmeSearchPattern: string;
  public
    procedure LoadFromFile;
    property HeplersSourceDir: string read FHeplersSubDir write FHeplersSubDir;
    property ReadmeIsUpdate: boolean read FReadmeIsUpdate write FReadmeIsUpdate;
    property ReadmeFilePath: string read FReadmeFilePath write FReadmeFilePath;
    property ReadmeSearchPattern: string read FReadmeSearchPattern write FReadmeSearchPattern;
  end;

implementation

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
    HeplersSourceDir := jsObject.GetValue(KeyHeplersSrcDir).Value;
    ReadmeIsUpdate := (jsObject.GetValue(KeyReadmeIsUpdate).Value = jsTrue.Value);
    ReadmeFilePath := jsObject.GetValue(KeyReadmeFilePath).Value;
    ReadmeSearchPattern := jsObject.GetValue(KeyReadmeSearchPattern).Value;
  finally
    jsObject.Free;
    jsTrue.Free;
  end;
end;

end.

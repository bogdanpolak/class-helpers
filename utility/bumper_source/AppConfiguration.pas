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
    KeySourceUnitsSearch = 'sourceUnitsSearch';
    KeyReadmeIsUpdate = 'readmeIsUpdateVersion';
    KeyReadmeFilePath = 'readmeFileName';
    KeyReadmeSearchPattern = 'readmeSearchPattern';
  private
    FSourceDir: string;
    FSrcSearchPattern: string;
    FReadmeIsUpdate: boolean;
    FReadmeFilePath: string;
    FReadmeSearchPattern: string;
    function PosTrillingBackslash(const aText: string): integer;
  public
    procedure LoadFromFile;
    property SourceDir: string read FSourceDir write FSourceDir;
    property SrcSearchPattern: string read FSrcSearchPattern
      write FSrcSearchPattern;
    property ReadmeIsUpdate: boolean read FReadmeIsUpdate write FReadmeIsUpdate;
    property ReadmeFilePath: string read FReadmeFilePath write FReadmeFilePath;
    property ReadmeSearchPattern: string read FReadmeSearchPattern
      write FReadmeSearchPattern;
  end;

implementation

function TAppConfiguration.PosTrillingBackslash(const aText: string): integer;
begin
  Result := aText.Length;
  while (Result > 0) and (aText[Result] <> '\') do
    Result := Result - 1;
end;

procedure TAppConfiguration.LoadFromFile;
var
  aJsonData: string;
  jsObject: TJSONObject;
  jsTrue: TJSONTrue;
  aSourceUnitsSearch: string;
  i: integer;
begin
  aJsonData := TFile.ReadAllText('app-config.json');
  jsObject := TJSONObject.ParseJSONValue(aJsonData) as TJSONObject;
  jsTrue := TJSONTrue.Create;
  try
    aSourceUnitsSearch := jsObject.GetValue(KeySourceUnitsSearch).Value;
    i := PosTrillingBackslash(aSourceUnitsSearch);
    SourceDir := aSourceUnitsSearch.Substring(0, i);
    SrcSearchPattern := aSourceUnitsSearch.Substring(i);
    ReadmeIsUpdate := (jsObject.GetValue(KeyReadmeIsUpdate)
      .Value = jsTrue.Value);
    ReadmeFilePath := jsObject.GetValue(KeyReadmeFilePath).Value;
    ReadmeSearchPattern := jsObject.GetValue(KeyReadmeSearchPattern).Value;
  finally
    jsObject.Free;
    jsTrue.Free;
  end;
end;

end.

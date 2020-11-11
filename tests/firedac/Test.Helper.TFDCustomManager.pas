unit Test.Helper.TFDCustomManager;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.IOUtils,

  Helper.TFDCustomManager;

{$M+}

type

  [TestFixture]
  TestTFDCustomManagerHelper = class(TObject)
  private
  public
  published
    procedure GetConnectionDefNames;
  end;

implementation

uses
  FireDAC.Comp.Client;

function IsItemOnTheArray(const item: String;
  const arr: TArray<string>): boolean;
var
  i: Integer;
begin
  for i := 0 to High(arr) do
    if arr[i] = item then
      Exit(True);
  Exit(False);
end;

procedure TestTFDCustomManagerHelper.GetConnectionDefNames;
var
  connectionNames: TArray<string>;
  connectionNamesAsString: string;
begin
  connectionNames := FDManager.GetConnectionDefNames();
  connectionNamesAsString := String.Join(', ', connectionNames);
  Assert.IsTrue(IsItemOnTheArray('SQLite_Demo', connectionNames),
    'Expected definition "SQLite_Demo" to be registered in FireDAC Manager');
end;

initialization

TDUnitX.RegisterTestFixture(TestTFDCustomManagerHelper);

end.

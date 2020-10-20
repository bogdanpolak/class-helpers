unit Test.Helper.TFDConnection;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.IOUtils,

  Helper.TFDConnection;

{$M+}

type

  [TestFixture]
  TestTFDConnectionHelper = class(TObject)
  private
    fOwner: TComponent;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure CheckExistingConnectionDefinitions;
    procedure WithConnectionDef_SQLite_Demo;
  end;

implementation

uses
  FireDAC.Stan.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Comp.Client;

procedure TestTFDConnectionHelper.Setup;
begin
  fOwner := TComponent.Create(nil);
end;

procedure TestTFDConnectionHelper.TearDown;
begin
  fOwner.Free;
end;

procedure TestTFDConnectionHelper.CheckExistingConnectionDefinitions;
var
  Def: IFDStanDefinition;
begin
  Def := FDManager.ConnectionDefs.FindDefinition('SQLite_Demo');
  Assert.IsTrue(Def <> nil,
    'Definition "SQLite_Demo" is required to run tests');
end;

procedure TestTFDConnectionHelper.WithConnectionDef_SQLite_Demo;
var
  connection: TFDConnection;
begin
  connection := TFDConnection.Create(fOwner).WithConnectionDef('SQLite_Demo');
  Assert.AreEqual('SQLite_Demo', connection.ConnectionDefName);
  connection.Open();
  Assert.IsTrue(connection.Connected,
    'Not able to connect to SQLite database using "SQLite_Demo" definition');
end;

initialization

TDUnitX.RegisterTestFixture(TestTFDConnectionHelper);

end.

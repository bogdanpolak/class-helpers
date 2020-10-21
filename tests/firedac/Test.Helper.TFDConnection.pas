unit Test.Helper.TFDConnection;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.IOUtils,
  FireDAC.Comp.UI,

  Helper.TFDConnection;

{$M+}

type

  [TestFixture]
  TestTFDConnectionHelper = class(TObject)
  private
    fOwner: TComponent;
    fWaitCursor: TFDGUIxWaitCursor;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure CheckExistingConnectionDefinitions;
    procedure WithConnectionDef_SQLite_Demo;
    procedure GetTableNamesAsArray;
    procedure GetFieldNamesAsArray;
  end;

implementation

uses
  FireDAC.Stan.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Phys,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Async,
  FireDAC.ConsoleUI.Wait,
  FireDAC.UI.Intf,
  FireDAC.Comp.Client;

procedure TestTFDConnectionHelper.Setup;
begin
  fOwner := TComponent.Create(nil);
  fWaitCursor := TFDGUIxWaitCursor.Create(fOwner);
  fWaitCursor.Provider := 'Console';
  fWaitCursor.ScreenCursor := gcrNone;
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

procedure TestTFDConnectionHelper.GetTableNamesAsArray;
var
  connection: TFDConnection;
  tables: TArray<String>;
begin
  connection := TFDConnection.Create(fOwner).WithConnectionDef('SQLite_Demo');
  connection.Open();
  tables := connection.GetTableNamesAsArray();
  Assert.IsTrue(IsItemOnTheArray('Employees', tables),
    'Expected "Employees" table on the list');
  Assert.IsTrue(IsItemOnTheArray('Products', tables),
    'Expected "Suppliers" table on the list');
  Assert.IsTrue(IsItemOnTheArray('Suppliers', tables),
    'Expected "Suppliers" table on the list');
end;

procedure TestTFDConnectionHelper.GetFieldNamesAsArray;
var
  connection: TFDConnection;
  fields: TArray<String>;
  fieldsAsString: string;
begin
  connection := TFDConnection.Create(fOwner).WithConnectionDef('SQLite_Demo');
  connection.Open();
  fields := connection.GetFieldNamesAsArray('Products');
  fieldsAsString := String.Join(', ', fields);
  Assert.AreEqual('ProductID, ProductName, SupplierID, CategoryID, ' +
    'QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ' +
    'ReorderLevel, Discontinued', fieldsAsString);
end;

initialization

TDUnitX.RegisterTestFixture(TestTFDConnectionHelper);

end.

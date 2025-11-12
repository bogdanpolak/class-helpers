unit Form.Main;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Generics.Collections,
  Winapi.Windows,
  Winapi.Messages,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Grids,
  Vcl.DBGrids,
  Data.DB,
  Datasnap.DBClient;

type
  TFormMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    Memo1: TMemo;
    btnLoadData: TButton;
    btnModifyData: TButton;
    btnSaveData: TButton;
    btnReset: TButton;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnLoadDataClick(Sender: TObject);
    procedure btnModifyDataClick(Sender: TObject);
    procedure btnSaveDataClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
  private
    FProducts: TObjectList<TObject>;
    procedure InitializeDataSet;
    procedure Log(const AMessage: string);
  public
    destructor Destroy; override;
  end;

  // Product class for demonstration
  TProduct = class
  private
    FId: Integer;
    FProductName: string;
    FPrice: Double;
    FStockQuantity: Integer;
    FIsChanged: Boolean;
  public
    property Id: Integer read FId write FId;
    property ProductName: string read FProductName write FProductName;
    property Price: Double read FPrice write FPrice;
    property StockQuantity: Integer read FStockQuantity write FStockQuantity;
    property IsChanged: Boolean read FIsChanged write FIsChanged;
  end;

var
  FormMain: TFormMain;

implementation

uses
  Helper.TDataSet,
  Attribute.MappedToDBField;

{$R *.dfm}

// -----------------------------------------------------------------------
// Form Events
// -----------------------------------------------------------------------

procedure TFormMain.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  FProducts := nil;
  
  InitializeDataSet;
  Log('Application started. Click "Load Data" to begin.');
  Log('');
  
  btnModifyData.Enabled := False;
  btnSaveData.Enabled := False;
end;

destructor TFormMain.Destroy;
begin
  if Assigned(FProducts) then
    FProducts.Free;
  inherited;
end;

// -----------------------------------------------------------------------
// Dataset Initialization
// -----------------------------------------------------------------------

procedure TFormMain.InitializeDataSet;
begin
  // Define dataset structure
  with ClientDataSet1 do
  begin
    FieldDefs.Clear;
    FieldDefs.Add('Id', ftInteger);
    FieldDefs.Add('ProductName', ftWideString, 50);
    FieldDefs.Add('Price', ftFloat);
    FieldDefs.Add('StockQuantity', ftInteger);
    
    // Mark Id as primary key using ProviderFlags
    CreateDataSet;
    
    // Set the primary key
    FieldByName('Id').ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
    
    // Insert sample data
    AppendRecord([1, 'Laptop', 999.99, 15]);
    AppendRecord([2, 'Mouse', 25.50, 50]);
    AppendRecord([3, 'Keyboard', 75.00, 30]);
    AppendRecord([4, 'Monitor', 299.99, 20]);
    AppendRecord([5, 'USB Cable', 9.99, 100]);
    
    First;
  end;
  
  DataSource1.DataSet := ClientDataSet1;
end;

// -----------------------------------------------------------------------
// Button Click Handlers
// -----------------------------------------------------------------------

procedure TFormMain.btnLoadDataClick(Sender: TObject);
begin
  Log('--- LoadData Example ---');
  
  try
    // Free previous list if exists
    if Assigned(FProducts) then
      FreeAndNil(FProducts);
    
    // Load data from dataset into object list
    // This demonstrates the LoadData<T> method
    FProducts := ClientDataSet1.LoadData<TProduct>;
    
    Log(Format('Successfully loaded %d products from dataset', [FProducts.Count]));
    Log('');
    
    // Display loaded products
    var idx := 0;
    for var product in FProducts do
    begin
      Log(Format('  [%d] %s - Price: $%.2f, Stock: %d',
        [idx, TProduct(product).ProductName, TProduct(product).Price,
         TProduct(product).StockQuantity]));
      Inc(idx);
    end;
    
    Log('');
    Log('Objects are now loaded in memory. Click "Modify Data" to make changes.');
    
    btnModifyData.Enabled := True;
    btnSaveData.Enabled := False;
    
  except
    on E: Exception do
    begin
      Log('ERROR: ' + E.Message);
      Log('');
    end;
  end;
end;

procedure TFormMain.btnModifyDataClick(Sender: TObject);
begin
  if not Assigned(FProducts) then
  begin
    Log('ERROR: No data loaded. Click "Load Data" first.');
    Exit;
  end;
  
  Log('--- Modifying Data in Memory ---');
  
  // Modify first product
  if FProducts.Count > 0 then
  begin
    var product := TProduct(FProducts[0]);
    product.Price := product.Price * 1.1; // 10% price increase
    product.IsChanged := True; // Mark as changed
    Log(Format('Increased price of "%s" by 10%% to $%.2f',
      [product.ProductName, product.Price]));
  end;
  
  // Modify second product
  if FProducts.Count > 1 then
  begin
    var product := TProduct(FProducts[1]);
    product.StockQuantity := product.StockQuantity + 25;
    product.IsChanged := True; // Mark as changed
    Log(Format('Increased stock of "%s" by 25 units to %d',
      [product.ProductName, product.StockQuantity]));
  end;
  
  // Add a new product
  var newProduct := TProduct.Create;
  newProduct.Id := 6;
  newProduct.ProductName := 'Webcam';
  newProduct.Price := 89.99;
  newProduct.StockQuantity := 15;
  newProduct.IsChanged := True; // Mark as changed for insert
  FProducts.Add(newProduct);
  Log('Added new product: Webcam');
  
  Log('');
  Log('Modified 2 existing products and added 1 new product.');
  Log('Click "Save Data" to persist changes to dataset.');
  
  btnSaveData.Enabled := True;
end;

procedure TFormMain.btnSaveDataClick(Sender: TObject);
begin
  if not Assigned(FProducts) then
  begin
    Log('ERROR: No data loaded. Click "Load Data" first.');
    Exit;
  end;
  
  Log('--- SaveData Example ---');
  
  try
    // Save modified objects back to dataset
    // This demonstrates the SaveData<T> method
    // It will UPDATE existing rows and INSERT new rows
    var savedCount := ClientDataSet1.SaveData<TProduct>(FProducts);
    
    Log(Format('Successfully saved %d modified/new records to dataset', [savedCount]));
    Log('');
    Log('Changes are now visible in the grid above.');
    Log('The SaveData method automatically:');
    Log('  - Updated 2 existing records (based on primary key)');
    Log('  - Inserted 1 new record');
    Log('  - Skipped 3 unchanged records');
    Log('');
    
    btnSaveData.Enabled := False;
    
  except
    on E: Exception do
    begin
      Log('ERROR: ' + E.Message);
      Log('');
      
      // Demonstrate common exceptions
      if E is EDataMapperError then
      begin
        Log('This is a mapping error. Common causes:');
        Log('  - Missing "IsChanged" field in object class');
        Log('  - No primary key defined in dataset (use ProviderFlags)');
        Log('  - Field name mismatch (use MappedToDBField attribute)');
      end;
    end;
  end;
end;

procedure TFormMain.btnResetClick(Sender: TObject);
begin
  // Free products and reinitialize
  if Assigned(FProducts) then
    FreeAndNil(FProducts);
  
  ClientDataSet1.Close;
  InitializeDataSet;
  
  Memo1.Clear;
  Log('Dataset reset to original state.');
  Log('Click "Load Data" to start again.');
  Log('');
  
  btnModifyData.Enabled := False;
  btnSaveData.Enabled := False;
end;

// -----------------------------------------------------------------------
// Utilities
// -----------------------------------------------------------------------

procedure TFormMain.Log(const AMessage: string);
begin
  Memo1.Lines.Add(AMessage);
end;

end.

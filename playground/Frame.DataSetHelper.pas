unit Frame.DataSetHelper;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  Data.DB,
  Datasnap.DBClient,
  MidasLib,
  Winapi.Windows, Winapi.Messages,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls;

type
  TFrameDataSetHelper = class(TFrame)
    TDataSetHelper: TGroupBox;
    Button1: TButton;
    tmrOnReady: TTimer;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure tmrOnReadyTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    fDataSet: TDataSet;
  public
  end;

implementation

{$R *.dfm}

uses
  Helper.TDataSet,
  Helper.TDBGrid;

function CreateDataSet(AOwner: TComponent): TDataSet;
var
  ds: TClientDataSet;
begin
  ds := TClientDataSet.Create(AOwner);
  with ds do
  begin
    FieldDefs.Add('ID', ftInteger);
    FieldDefs.Add('Text1', ftWideString, 100);
    FieldDefs.Add('Date', ftDate);
    FieldDefs.Add('Text2', ftWideString, 150);
    FieldDefs.Add('Saved', ftCurrency);
    CreateDataSet;
  end;
  with ds do
  begin
    Append;
    FieldByName('ID').Value := 1;
    FieldByName('Text1').Value := 'Cedric Diggory';
    FieldByName('Date').Value := EncodeDate(1995, 9, 16);
    FieldByName('Text2').Value := 'Hufflepuff student two years above Harry';
    FieldByName('Saved').Value := 315.10;
    Post;
  end;
  with ds do
  begin
    Append;
    FieldByName('ID').Value := 2;
    FieldByName('Text1').Value := 'Gellert Grindelwald';
    FieldByName('Date').Value := EncodeDate(1938, 02, 21);
    FieldByName('Text2').Value := 'Dark wizard, would be second only to Voldemort';
    FieldByName('Saved').Value := 31500.00;
    Post;
  end;
  with ds do
  begin
    Append;
    FieldByName('ID').Value := 3;
    FieldByName('Text1').Value := 'Bellatrix Lestrange';
    FieldByName('Date').Value := EncodeDate(1980, 10, 07);
    FieldByName('Text2').Value := 'Most faithful member of Voldemort inner circle, paranoid and fanatically devoted to Voldemort';
    FieldByName('Saved').Value := 95000.00;
    Post;
  end;
  ds.First;
  Result := ds;
end;

procedure TFrameDataSetHelper.Button1Click(Sender: TObject);
var
  value: Integer;
begin
  value := fDataSet.GetMaxIntegerValue('ID');
  Button1.Caption := Format('Max value = %d',[value]);
end;

procedure TFrameDataSetHelper.Button2Click(Sender: TObject);
begin
  DBGrid1.AutoSizeColumns();
end;

procedure TFrameDataSetHelper.tmrOnReadyTimer(Sender: TObject);
begin
  tmrOnReady.Enabled := False;
  fDataSet := CreateDataSet(Self);
  DBGrid1.DataSource := fDataSet.CreateDataSource;
end;

end.

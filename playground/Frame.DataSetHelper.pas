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
    btnGetMaxIntegerValue: TButton;
    tmrOnReady: TTimer;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    btnAutoSizeColumns: TButton;
    btnLoadColumnsLayout: TButton;
    btnResetDBGrid: TButton;
    procedure btnGetMaxIntegerValueClick(Sender: TObject);
    procedure tmrOnReadyTimer(Sender: TObject);
    procedure btnAutoSizeColumnsClick(Sender: TObject);
    procedure btnLoadColumnsLayoutClick(Sender: TObject);
    procedure btnResetDBGridClick(Sender: TObject);
  private
    fDataSet: TDataSet;
    procedure OnFrameReady;
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
    FieldByName('Text2').Value :=
      'Dark wizard, would be second only to Voldemort';
    FieldByName('Saved').Value := 31500.00;
    Post;
  end;
  with ds do
  begin
    Append;
    FieldByName('ID').Value := 3;
    FieldByName('Text1').Value := 'Bellatrix Lestrange';
    FieldByName('Date').Value := EncodeDate(1980, 10, 07);
    FieldByName('Text2').Value :=
      'Most faithful member of Voldemort inner circle, paranoid and fanatically devoted to Voldemort';
    FieldByName('Saved').Value := 95000.00;
    Post;
  end;
  ds.First;
  Result := ds;
end;

procedure TFrameDataSetHelper.OnFrameReady;
begin
  fDataSet := CreateDataSet(Self);
  DBGrid1.DataSource := fDataSet.CreateDataSource;
end;

procedure TFrameDataSetHelper.tmrOnReadyTimer(Sender: TObject);
begin
  tmrOnReady.Enabled := False;
  OnFrameReady;
end;

procedure TFrameDataSetHelper.btnLoadColumnsLayoutClick(Sender: TObject);
var
  sColumns: String;
begin
  sColumns := '[' //.
    + '  {"fieldname":"ID", "width":30, "visible":false} ' //.
    + ', {"fieldname":"Text1", "title":"Character name", "width":120}' //.
    + ', {"fieldname":"Date", "title":"Last activity", "width":80, "visible":true} '
    + ', {"fieldname":"Saved", "title":"Current savings", "width":90} ' //.
    + ', {"fieldname":"Text2", "title":"More information", "width":500} ' //.
    + ']';
  DBGrid1.LoadColumnsFromJsonString(sColumns);
end;

procedure TFrameDataSetHelper.btnResetDBGridClick(Sender: TObject);
begin
  fDataSet.Free;
  DBGrid1.Free;
  fDataSet := CreateDataSet(Self);
  DBGrid1 := TDBGrid.Create(Self);
  with DBGrid1 do begin
    Align := alClient;
    AlignWithMargins := True;
    DataSource := fDataSet.CreateDataSource; // aDataSource;
  end;
  DBGrid1.Parent := Self;
end;

procedure TFrameDataSetHelper.btnGetMaxIntegerValueClick(Sender: TObject);
var
  Value: Integer;
begin
  Value := fDataSet.GetMaxIntegerValue('ID');
  (Sender as TButton).Caption := Format('Max value = %d', [Value]);
end;

procedure TFrameDataSetHelper.btnAutoSizeColumnsClick(Sender: TObject);
begin
  DBGrid1.AutoSizeColumns();
end;

end.

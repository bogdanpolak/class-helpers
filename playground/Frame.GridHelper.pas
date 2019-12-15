unit Frame.GridHelper;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,
  Winapi.Windows, Winapi.Messages,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls;

type
  TFrameGridHelper = class(TFrame)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    StringGrid1: TStringGrid;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  Helper.TStringGrid;

procedure TFrameGridHelper.Button1Click(Sender: TObject);
begin
  StringGrid1.ColCount := 5;
  StringGrid1.ColsWidth([30, 200, 70, 120, 60]);
  StringGrid1.Rows[0].CommaText := 'No,"Mesure Name",Acronym,"Unit name",Value'
end;

procedure TFrameGridHelper.Button2Click(Sender: TObject);
begin
  StringGrid1.FillCells([
    (**) ['1', 'Number of DI Containers', 'NDIC', 'n/a', '120'],
    (**) ['2', 'Maximum ctor injection', 'MCTI', 'PCLRecord.pas', '56']]);
end;

procedure TFrameGridHelper.Button3Click(Sender: TObject);
const
  JsonStructureAndData = '{"structure": [' +
    '{"column": "no", "caption": "No.", "width": 30}, ' +
    '{"column": "mesure", "caption": "Mesure description", "width": 200}, ' +
    '{"column": "acronym", "caption": "Acronym", "width": 70}, ' +
    '{"column": "unit", "caption": "Unit name", "width": 120}, ' +
    '{"column": "value", "caption": "Value", "width": 60}' + (**)
    '], "data":[' +
    '{"no": 1, "mesure": "Number of DI Containers", "acronym": "NDIC", "unit": "n/a", "value": 120},'
    + '{"no": 2, "mesure": "Maximum ctor injection", "acronym": "MCTI", "unit": "PCLRecord.pas", "value": 56}'
    + ']} ';
var
  jsData: TJSONObject;
begin
  jsData := TJSONObject.ParseJSONValue(JsonStructureAndData) as TJSONObject;
  StringGrid1.FillWithJson(jsData);
end;

procedure TFrameGridHelper.Button4Click(Sender: TObject);
begin
  StringGrid1.Free;
  StringGrid1 := TStringGrid.Create(Self);
  StringGrid1.Parent := Self;
  StringGrid1.Align := alClient;
  StringGrid1.AlignWithMargins := True;
end;

end.

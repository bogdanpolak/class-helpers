unit Frame.StringGridHelper;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,
  Winapi.Windows, Winapi.Messages,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls;

type
  TFrameStringGridHelper = class(TFrame)
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

procedure TFrameStringGridHelper.Button1Click(Sender: TObject);
begin
  StringGrid1.ColCount := 5;
  StringGrid1.ColsWidth([30, 200, 70, 120, 60]);
  StringGrid1.Rows[0].CommaText := 'No,"Mesure Name",Acronym,"Unit name",Value'
end;

procedure TFrameStringGridHelper.Button2Click(Sender: TObject);
begin
  StringGrid1.FillCells([
    (**) ['1', 'Number of DI Containers', 'NDIC', 'n/a', '120'],
    (**) ['2', 'Maximum ctor injection', 'MCTI', 'PCLRecord.pas', '56']]);
end;

procedure TFrameStringGridHelper.Button3Click(Sender: TObject);
const
  JsonStructureAndData =   //→
    '{"structure": [' //→
    + '  {"column": "id", "caption": "ID.", "width": 30},' //→
    + '  {"column": "fullname", "caption": "Full Name", "width": 140},' //→
    + '  {"column": "spouse", "caption": "Spouse", "width": 110},' //→
    + '  {"column": "born", "caption": "Born", "width": 80},' //→
    + '  {"column": "died", "caption": "Died", "width": 80},' //→
    + '  {"column": "parrents", "caption": "Parrents", "width": 240},' //→
    + '  {"column": "house", "caption": "House", "width": 80}' //→
    + '], "data":[' //→
    + '  {"id":1,"fullname":"Harry James Potter","nickname":"The Boy Who Lived / The Chosen One","parrents":"James Potter & Lily Potter","spouse":"Ginny Weasley","born":"1980-07-31","house":"Gryffindor"},'
    + '  {"id":2,"fullname":"Ronald Bilius Weasley","parrents":"Arthur Weasley & Molly Weasley","brothers":"Bill, Charlie, Percy, Fred and George","sisters":"Ginny","spouse":"Hermione Granger","born":"1980-03-01","house":"Gryffindor"},'
    + '  {"id":3,"fullname":"Hermione Jean Granger","spouse":"Ron Weasley","born":"1979-09-19","house":"Gryffindor"},'
    + '  {"id":4,"fullname":"Draco Malfoy","parrents":"Lucius Malfoy & Narcissa Malfoy","spouse":"Astoria Greengrass","born":"1980-06-05","house":"Slytherin"},'
    + '  {"id":5,"fullname":"Severus Snape","parrents":"Tobias Snape & Eileen Snape","born":"1960-01-09","died":"1998-05-02","house":"Slytherin"},'
    + '  {"id":6,"fullname":"Albus Percival Dumbledore","parrents":"Percival Dumbledore & Kendra Dumbledore","brothers":"Aberforth, Aurelius (alleged brother)","sisters":"Ariana","spouse":"","born":"1881-01-01","died":"1997-06-30","house":"Gryffindor"}'
    + ']} ';
var
  jsData: TJSONObject;
begin
  jsData := TJSONObject.ParseJSONValue(JsonStructureAndData) as TJSONObject;
  StringGrid1.FillWithJson(jsData);
end;

procedure TFrameStringGridHelper.Button4Click(Sender: TObject);
begin
  StringGrid1.Free;
  StringGrid1 := TStringGrid.Create(Self);
  StringGrid1.Parent := Self;
  StringGrid1.Align := alClient;
  StringGrid1.AlignWithMargins := True;
end;

end.

unit Form.Main;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.JSON,
  System.Generics.Collections,
  Winapi.Windows, Winapi.Messages,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFormMain = class(TForm)
    GroupBox1: TGroupBox;
    PageControl1: TPageControl;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonCommandClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    fDemoTabSheets: TDictionary<TButton, TTabSheet>;
    fDemoFrames: TDictionary<TButton, TFrame>;
  public
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  Frame.StringGridHelper,
  Frame.DataSetHelper,
  Frame.ByteAndStreamHelpers;

type
  TFrameType = type of TFrame;

  TPlaygroundItem = record
    caption: string;
    frameType: TFrameType;
  end;

const
  PlaygroudItems = 3;
  PlaygroudDefs: array [0 .. PlaygroudItems - 1] of TPlaygroundItem =
    ((caption: 'TDataSet && TDBGrid'; frameType: TFrameDataSetHelper),
    (caption: 'TBytes && TStream'; frameType: TBytesStreamHelpersFrame),
    (caption: 'TStringGrid'; frameType: TFrameStringGridHelper));
  AutoOpenFrame = 3; // [0 .. Items-1]    other values = do not open

var
  PlaygroudButtons: array [0 .. PlaygroudItems - 1] of TButton;

function BuildButton(const aCaption: string; const aParent: TWinControl;
  const aOnClick: TNotifyEvent): TButton;
begin
  Result := TButton.Create(aParent);
  with Result do
  begin
    Top := 999;
    caption := '   ' + aCaption + '    ';
    OnClick := aOnClick;
    Parent := aParent;
    Align := alTop;
    Height := 32;
    AlignWithMargins := true;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  i: Integer;
  btn: TButton;
begin
  fDemoTabSheets := TDictionary<TButton, TTabSheet>.Create();
  fDemoFrames := TDictionary<TButton, TFrame>.Create();
  for i := 0 to PlaygroudItems - 1 do
  begin
    btn := BuildButton(PlaygroudDefs[i].caption, GroupBox1, ButtonCommandClick);
    PlaygroudButtons[i] := btn;
    btn.Name := Format('btn%.3d', [i + 1]);
    fDemoTabSheets.Add(btn, nil);
    fDemoFrames.Add(btn, PlaygroudDefs[i].frameType.Create(Self));
  end;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
var
  i: Integer;
begin
  Timer1.Enabled := false;
  for i := 0 to PlaygroudItems - 1 do
    if i=AutoOpenFrame then
      PlaygroudButtons[i].Click;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fDemoTabSheets.Free;
  fDemoFrames.Free;
end;

procedure TFormMain.ButtonCommandClick(Sender: TObject);
var
  Frame: TFrame;
  tabsheet: TTabSheet;
  btn: TButton;
begin
  btn := Sender as TButton;
  tabsheet := fDemoTabSheets.Items[btn];
  Frame := fDemoFrames.Items[btn];
  if tabsheet = nil then
  begin
    tabsheet := TTabSheet.Create(PageControl1);
    tabsheet.caption := (Sender as TButton).caption;
    tabsheet.PageControl := PageControl1;
    fDemoTabSheets.Items[btn] := tabsheet;
    Frame.Parent := tabsheet;
    Frame.Visible := true;
    Frame.Align := alClient;
  end;
  PageControl1.ActivePage := fDemoTabSheets[btn];
end;

end.

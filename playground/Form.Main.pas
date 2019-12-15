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
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls;

type
  TFormMain = class(TForm)
    GroupBox1: TGroupBox;
    PageControl1: TPageControl;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonCommandClick(Sender: TObject);
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
  Frame.GridHelper;

type
  TFrameType = type of TFrame;

  TPlaygroundItem = record
    caption: string;
    frameType: TFrameType;
  end;

const
  PlaygroudItems = 1;
  PlaygroudDefs: array [0 .. PlaygroudItems - 1] of TPlaygroundItem =
    ((caption: 'Helper - TStringGrid'; frameType: TFrameGridHelper));

function BuildButton(const aCaption: string; const aParent: TWinControl;
  const aOnClick: TNotifyEvent): TButton;
begin
  Result := TButton.Create(aParent);
  with Result do
  begin
    Top := 999;
    caption := aCaption;
    OnClick := aOnClick;
    Parent := aParent;
    Align := alTop;
    AlignWithMargins := True;
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
    fDemoTabSheets.Add(btn, nil);
    fDemoFrames.Add(btn, PlaygroudDefs[i].frameType.Create(Self));
  end;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fDemoTabSheets.Free;
  fDemoFrames.Free;
end;

procedure TFormMain.ButtonCommandClick(Sender: TObject);
var
  frame: TFrame;
  tabsheet: TTabSheet;
  btn: TButton;
begin
  btn := Sender as TButton;
  tabsheet := fDemoTabSheets.Items[btn];
  frame := fDemoFrames.Items[btn];
  if tabsheet = nil then
  begin
    tabsheet := TTabSheet.Create(PageControl1);
    tabsheet.Caption := (Sender as TButton).Caption;
    tabsheet.PageControl := PageControl1;
    fDemoTabSheets.Items[btn] := tabsheet;
    frame.Parent := tabsheet;
    frame.Visible := True;
    frame.Align := alClient;
  end
  else
    PageControl1.ActivePage := fDemoTabSheets[btn];
end;

end.

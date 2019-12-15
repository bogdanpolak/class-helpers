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
  TFrameType = type of TFrame;

  TPlaygroundItem = class
    Caption: string;
    Frame: TFrame;
    FrameType: TFrameType;
    constructor Create(const aCaption: string; aFrameType: TFrameType);
  end;

  TFormMain = class(TForm)
    GroupBox1: TGroupBox;
    PageControl1: TPageControl;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonCommandClick(Sender: TObject);
  private
    fCatalog: TObjectDictionary<TButton, TPlaygroundItem>;
    procedure FillButtonCaptions;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  Frame.GridHelper;

{ TPlaygroundCatalog }

constructor TPlaygroundItem.Create(const aCaption: string;
  aFrameType: TFrameType);
begin
  Caption := aCaption;
  FrameType := aFrameType;
end;

{ TFormMain }

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fCatalog.Free;
end;

procedure TFormMain.ButtonCommandClick(Sender: TObject);
var
  item: TPlaygroundItem;
  tsh: TTabSheet;
begin
  item := fCatalog.Items[Sender as TButton];
  if item.Frame=nil then
  begin
    (Sender as TButton).Enabled := False;
    tsh := TTabSheet.Create(PageControl1);
    tsh.Caption := item.Caption;
    tsh.PageControl := PageControl1;
    tsh.Tag := NativeInt(Pointer(item));
    item.Frame := item.FrameType.Create(Self);
    item.Frame.Parent := tsh;
    item.Frame.Visible := True;
  end;
end;

procedure TFormMain.FillButtonCaptions;
var
  pair: TPair<TButton,TPlaygroundItem>;
begin
  for pair in fCatalog do
  begin
    pair.Key.Caption := pair.Value.Caption;
    pair.Key.OnClick := ButtonCommandClick;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  fCatalog := TObjectDictionary<TButton, TPlaygroundItem>.Create();
  fCatalog.Add(Button1, TPlaygroundItem.Create('Helper.TStringGrid',
    TFrameGridHelper));
  FillButtonCaptions;
end;

end.

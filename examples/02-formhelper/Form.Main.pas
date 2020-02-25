unit Form.Main;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  Winapi.Windows, Winapi.Messages,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    FlowPanel1: TFlowPanel;
    btnNewInterval: TButton;
    btnNewTimeout: TButton;
    edtInterID: TEdit;
    Label1: TLabel;
    Bevel1: TBevel;
    btnClearMemo: TButton;
    Label2: TLabel;
    Bevel2: TBevel;
    procedure btnNewIntervalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNewTimeoutClick(Sender: TObject);
    procedure edtInterIDKeyPress(Sender: TObject; var Key: Char);
    procedure btnClearMemoClick(Sender: TObject);
  private
    procedure ApplicationReady;
  public
  end;

var
  Form1: TForm1;

implementation

uses
  Helper.TForm;

{$R *.dfm}

procedure TForm1.ApplicationReady;
var
  aIntervID: Integer;
begin
  ReportMemoryLeaksOnShutdown := True;
  Memo1.Clear;
  edtInterID.Text := '';
  Memo1.Lines.Add('OnActivate - executed');
  aIntervID := SetInterval(50,
    procedure
    begin
      Caption := Format('Active timers: %d   -  reporting Interval ID: %d',
        [GetTimersCount, aIntervID]);
    end)
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetOnFormReady(ApplicationReady);
end;

procedure TForm1.btnClearMemoClick(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm1.btnNewIntervalClick(Sender: TObject);
var
  aTimerID: Integer;
begin
  aTimerID := SetInterval(2000,
    procedure
    begin
      Memo1.Lines.Add(Format('  [%d] ... interval ... ', [aTimerID]));
    end);
end;

procedure TForm1.btnNewTimeoutClick(Sender: TObject);
begin
  SetTimeout(5000,
    procedure
    begin
      Memo1.Lines.Add('  (timeout triggered)');
    end);
end;

procedure TForm1.edtInterIDKeyPress(Sender: TObject; var Key: Char);
var
  aIntervalID: Integer;
begin
  if Key = #13 then
  begin
    if TryStrToInt(edtInterID.Text, aIntervalID) then
    begin
      StopInterval(aIntervalID);
      edtInterID.Text := '';
      Key := #0;
    end;
  end;
end;

end.

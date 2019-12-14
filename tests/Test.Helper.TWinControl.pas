unit Test.Helper.TWinControl;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,

  Helper.TWinControl;

{$M+}

type

  [TestFixture]
  TestTWinControlHelper = class(TObject)
  private
    fForm: TForm;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure FindChildControlRecursiveByType;
  end;

implementation

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestTWinControlHelper.Setup;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm, fForm);
  fForm.Name := 'MainForm';
  fForm.Caption := 'Main Form';
  // Application.Run;
end;

procedure TestTWinControlHelper.TearDown;
begin
end;

// -----------------------------------------------------------------------
// Tests section 1
// -----------------------------------------------------------------------

type
  TControlsSet1 = record
    TopPanel: TPanel;
    ClientPanel: TPanel;
    EditTop: TEdit;
    ButtonTop1: TButton;
    ButtonTop2: TButton;
  end;

function Given_TwoPanels_WithEditAndTwoButton (aForm: TForm): TControlsSet1;
begin
end;

procedure TestTWinControlHelper.FindChildControlRecursiveByType;
var
  aTopPanel: TPanel;
begin
  aTopPanel := TPanel.Create(fForm);
  with aTopPanel do
  begin
    Name := 'TopPanel';
    Parent := fForm;
    Align := alTop;
  end;
  with TPanel.Create(fForm) do
  begin
    Name := 'ClientPanel';
    Parent := fForm;
    Align := alClient;
  end;
  with TEdit.Create(fForm) do
  begin
    Name := 'EditTop';
    Text := 'Edit Top';
    Parent := aTopPanel;
    Align := alTop;
  end;
  with TButton.Create(fForm) do
  begin
    Name := 'ButtonTop';
    Caption := 'Button Top';
    Parent := aTopPanel;
    Align := alTop;
  end;
  Assert.IsTrue(fForm.FindChildControlRecursiveByType(TButton) <> nil,
    'expected TButton control, but is nil');
end;

initialization

TDUnitX.RegisterTestFixture(TestTWinControlHelper, 'TForm');

end.

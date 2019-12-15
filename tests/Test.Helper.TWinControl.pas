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

function Given_TwoPanels_WithEditAndTwoButton(aForm: TForm): TControlsSet1;
begin
  with Result do
  begin
    TopPanel := TPanel.Create(aForm);
    ClientPanel := TPanel.Create(aForm);
    EditTop := TEdit.Create(aForm);
    ButtonTop1 := TButton.Create(aForm);
    ButtonTop2 := TButton.Create(aForm);
  end;
  with Result.TopPanel do
  begin
    Name := 'TopPanel';
    Parent := aForm;
    Align := alTop;
  end;
  with Result.ClientPanel do
  begin
    Name := 'ClientPanel';
    Parent := aForm;
    Align := alClient;
  end;
  with Result.EditTop do
  begin
    Name := 'EditTop1';
    Text := 'Edit Top';
    Parent := Result.TopPanel;
    Align := alTop;
    Top := 999;
  end;
  with Result.ButtonTop1 do
  begin
    Name := 'ButtonTop1';
    Caption := 'Button Top One';
    Parent := Result.TopPanel;
    Align := alTop;
    Top := 999;
  end;
end;

procedure TestTWinControlHelper.FindChildControlRecursiveByType;
var
  controls: TControlsSet1;
  aButton: TButton;
begin
  controls := Given_TwoPanels_WithEditAndTwoButton(fForm);

  aButton := fForm.FindChildControlRecursiveByType(TButton) as TButton;

  Assert.AreEqual(controls.ButtonTop1.Name, aButton.Name);
end;

initialization

TDUnitX.RegisterTestFixture(TestTWinControlHelper, 'TForm');

end.

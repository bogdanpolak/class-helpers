unit Test.Helper.TStringGrid;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,

  Vcl.Controls,
  Vcl.Forms,
  Vcl.Grids,

  Helper.TStringGrid;

{$M+}

type

  [TestFixture]
  TestTStringGridHelper = class(TObject)
  private
    fForm: TForm;
    fGrid: TStringGrid;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure OneColumn_ColsWidth;
    procedure TwoColumns_ColsWidth;
    procedure FiveColumns_ColsWidth;
  end;

implementation

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestTStringGridHelper.Setup;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  fForm := TForm.Create(Application);
  with fForm do
  begin
    Name := 'TestFormTStringGridHelper';
    Caption := 'Main Form';
  end;
  fGrid := TStringGrid.Create(fForm);
  with fGrid do
  begin
    Parent := fForm;
    Align := alClient;
  end;
  // Application.Run;
end;

procedure TestTStringGridHelper.TearDown;
begin
  fForm.Close;
  fForm.Free;
end;

// -----------------------------------------------------------------------
// Tests section 1
// -----------------------------------------------------------------------

procedure TestTStringGridHelper.OneColumn_ColsWidth;
begin
  fGrid.FixedCols := 1;
  fGrid.ColCount := 1;
  fGrid.ColsWidth([110]);
  Assert.AreEqual(110, fGrid.ColWidths[0]);
end;

procedure TestTStringGridHelper.TwoColumns_ColsWidth;
begin
  fGrid.ColCount := 2;
  fGrid.ColsWidth([50, 100]);
  Assert.AreEqual(50, fGrid.ColWidths[0]);
  Assert.AreEqual(100, fGrid.ColWidths[1]);
end;

procedure TestTStringGridHelper.FiveColumns_ColsWidth;
begin
  fGrid.ColCount := 5;
  fGrid.ColsWidth([50, 100, 90, 110, 80]);
  Assert.AreEqual(110, fGrid.ColWidths[3]);
  Assert.AreEqual(80, fGrid.ColWidths[4]);
end;

initialization

TDUnitX.RegisterTestFixture(TestTStringGridHelper);

end.

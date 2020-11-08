unit Test.Helper.TPicture;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  Vcl.Graphics,

  Helper.TPicture;

{$M+}

type

  [TestFixture]
  TestTPictureHelper = class(TObject)
  private
    fPicture: TPicture;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure AssignBytes_PNG;
  end;
{$M-}

implementation

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestTPictureHelper.Setup;
begin
  fPicture := TPicture.Create;
end;

procedure TestTPictureHelper.TearDown;
begin
  fPicture.Free;
end;

// -----------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------

procedure TestTPictureHelper.AssignBytes_PNG;
begin
  Assert.Fail();
end;

initialization

TDUnitX.RegisterTestFixture(TestTPictureHelper);

end.

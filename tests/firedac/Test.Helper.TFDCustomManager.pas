unit Test.Helper.TFDCustomManager;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.IOUtils,

  Helper.TFDCustomManager;

{$M+}

type

  [TestFixture]
  TestTFDCustomManagerHelper = class(TObject)
  private
  public
    [Setup]
    procedure Setup;
  published
    procedure T01;
  end;

implementation


procedure TestTFDCustomManagerHelper.Setup;
begin

end;

procedure TestTFDCustomManagerHelper.T01;
begin
  Assert.Fail('WIP');
end;

initialization

TDUnitX.RegisterTestFixture(TestTFDCustomManagerHelper);

end.

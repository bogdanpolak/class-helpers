unit Test.Helper.TFDConnection;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,
  System.IOUtils,

  Helper.TFDConnection;

{$M+}

type

  [TestFixture]
  TestTFDConnectionHelper = class(TObject)
  private
  public
    [Setup]
    procedure Setup;
  published
    procedure T01;
  end;

implementation


procedure TestTFDConnectionHelper.Setup;
begin

end;

procedure TestTFDConnectionHelper.T01;
begin
  Assert.Fail('WIP');
end;

initialization

TDUnitX.RegisterTestFixture(TestTFDConnectionHelper);

end.

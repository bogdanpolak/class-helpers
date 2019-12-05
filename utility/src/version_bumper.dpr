program version_bumper;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Main in 'Main.pas',
  AppConfiguration in 'AppConfiguration.pas',
  HelperPascalProcessor in 'HelperPascalProcessor.pas';

begin
  try
    TMainApplication.Run();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

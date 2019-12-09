program version_bumper;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Main in 'Main.pas',
  AppConfiguration in 'AppConfiguration.pas',
  Processor.PascalUnit in 'Processor.PascalUnit.pas',
  Processor.ReadmeMarkdown in 'Processor.ReadmeMarkdown.pas',
  Processor.Utils in 'Processor.Utils.pas';

begin
  try
    TMainApplication.Run();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

program TestsHeplers;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  Attribute.MappedToField in '..\..\src\rtl\Attribute.MappedToField.pas',
  Helper.TDataSet in '..\..\src\rtl\Helper.TDataSet.pas',
  Helper.TDateTime in '..\..\src\rtl\Helper.TDateTime.pas',
  Helper.TJSONObject in '..\..\src\rtl\Helper.TJSONObject.pas',
  Helper.TStringGrid in '..\..\src\rtl\Helper.TStringGrid.pas',
  Helper.TBytes in '..\..\src\rtl\Helper.TBytes.pas',
  Helper.TStream in '..\..\src\rtl\Helper.TStream.pas',
  Helper.TField in '..\..\src\rtl\Helper.TField.pas',
  Test.Helper.TDateTime in 'Test.Helper.TDateTime.pas',
  Test.Helper.TStringGrid in 'Test.Helper.TStringGrid.pas',
  Test.Helper.TDataSet in 'Test.Helper.TDataSet.pas',
  Test.Helper.TJSONObject in 'Test.Helper.TJSONObject.pas',
  Test.Helper.TBytes in 'Test.Helper.TBytes.pas',
  Test.Helper.TStream in 'Test.Helper.TStream.pas',
  Test.Helper.TField in 'Test.Helper.TField.pas',
  Helper.TDBGrid in '..\..\src\vcl\Helper.TDBGrid.pas',
  Helper.TWinControl in '..\..\src\vcl\Helper.TWinControl.pas',
  Test.Helper.TDBGrid in 'Test.Helper.TDBGrid.pas',
  Test.Helper.TWinControl in 'Test.Helper.TWinControl.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.

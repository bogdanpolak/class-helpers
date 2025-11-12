program DataSetMapperDemo;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {FormMain},
  Attribute.MappedToDBField in '..\..\src\rtl\Attribute.MappedToDBField.pas',
  Helper.TDataSet in '..\..\src\rtl\Helper.TDataSet.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

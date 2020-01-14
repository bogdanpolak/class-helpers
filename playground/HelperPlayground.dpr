program HelperPlayground;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {FormMain},
  Frame.StringGridHelper in 'Frame.StringGridHelper.pas' {FrameStringGridHelper: TFrame},
  Helper.TApplication in '..\src\Helper.TApplication.pas',
  Helper.TDataSet in '..\src\Helper.TDataSet.pas',
  Helper.TDateTime in '..\src\Helper.TDateTime.pas',
  Helper.TDBGrid in '..\src\Helper.TDBGrid.pas',
  Helper.TJSONObject in '..\src\Helper.TJSONObject.pas',
  Helper.TStringGrid in '..\src\Helper.TStringGrid.pas',
  Helper.TWinControl in '..\src\Helper.TWinControl.pas',
  Frame.DataSetHelper in 'Frame.DataSetHelper.pas' {FrameDataSetHelper: TFrame},
  Attribute.MappedToField in '..\src\Attribute.MappedToField.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

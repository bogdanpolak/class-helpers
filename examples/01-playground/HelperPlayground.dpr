program HelperPlayground;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {FormMain},
  Frame.StringGridHelper in 'Frame.StringGridHelper.pas' {FrameStringGridHelper: TFrame},
  Frame.DataSetHelper in 'Frame.DataSetHelper.pas' {FrameDataSetHelper: TFrame},
  Frame.ByteAndStreamHelpers in 'Frame.ByteAndStreamHelpers.pas' {BytesStreamHelpersFrame: TFrame},
  Attribute.MappedToField in '..\..\src\rtl\Attribute.MappedToField.pas',
  Helper.TApplication in '..\..\src\vcl\Helper.TApplication.pas',
  Helper.TDataSet in '..\..\src\rtl\Helper.TDataSet.pas',
  Helper.TDateTime in '..\..\src\rtl\Helper.TDateTime.pas',
  Helper.TDBGrid in '..\..\src\vcl\Helper.TDBGrid.pas',
  Helper.TJSONObject in '..\..\src\rtl\Helper.TJSONObject.pas',
  Helper.TStringGrid in '..\..\src\vcl\Helper.TStringGrid.pas',
  Helper.TWinControl in '..\..\src\vcl\Helper.TWinControl.pas',
  Helper.TBytes in '..\..\src\rtl\Helper.TBytes.pas',
  Helper.TStream in '..\..\src\rtl\Helper.TStream.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.

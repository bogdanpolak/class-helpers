object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'FormMain'
  ClientHeight = 382
  ClientWidth = 758
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 150
    Height = 376
    Align = alLeft
    Caption = 'Helpers:'
    TabOrder = 0
  end
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 159
    Top = 3
    Width = 596
    Height = 376
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 183
    ExplicitWidth = 572
  end
  object Timer1: TTimer
    Interval = 1
    OnTimer = Timer1Timer
    Left = 376
    Top = 200
  end
end

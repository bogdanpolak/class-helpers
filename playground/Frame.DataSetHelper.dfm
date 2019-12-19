object FrameDataSetHelper: TFrameDataSetHelper
  Left = 0
  Top = 0
  Width = 519
  Height = 240
  TabOrder = 0
  object TDataSetHelper: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 513
    Height = 54
    Align = alTop
    Caption = 'TDataSet'
    TabOrder = 0
    object Button1: TButton
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 148
      Height = 31
      Align = alLeft
      Caption = 'GetMaxIntegerValue'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object DBGrid1: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 116
    Width = 513
    Height = 121
    Align = alClient
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 60
    Width = 519
    Height = 53
    Align = alTop
    Caption = 'TDBGrid'
    TabOrder = 2
    object Button2: TButton
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 151
      Height = 30
      Align = alLeft
      Caption = 'AutoSizeColumns'
      TabOrder = 0
      OnClick = Button2Click
      ExplicitLeft = 3
      ExplicitTop = 20
    end
  end
  object tmrOnReady: TTimer
    Interval = 1
    OnTimer = tmrOnReadyTimer
    Left = 48
    Top = 152
  end
end

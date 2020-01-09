object FrameDataSetHelper: TFrameDataSetHelper
  Left = 0
  Top = 0
  Width = 658
  Height = 240
  TabOrder = 0
  object TDataSetHelper: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 652
    Height = 54
    Align = alTop
    Caption = 'TDataSet'
    TabOrder = 0
    object btnGetMaxIntegerValue: TButton
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 148
      Height = 31
      Align = alLeft
      Caption = 'GetMaxIntegerValue'
      TabOrder = 0
      OnClick = btnGetMaxIntegerValueClick
    end
    object btnLoadDataset: TButton
      AlignWithMargins = True
      Left = 159
      Top = 18
      Width = 130
      Height = 31
      Align = alLeft
      Caption = 'Load DataSet'
      TabOrder = 1
      OnClick = btnLoadDatasetClick
    end
  end
  object DBGrid1: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 116
    Width = 652
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
    Width = 658
    Height = 53
    Align = alTop
    Caption = 'TDBGrid'
    TabOrder = 2
    object btnAutoSizeColumns: TButton
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 132
      Height = 30
      Align = alLeft
      Caption = 'AutoSizeColumns'
      TabOrder = 0
      OnClick = btnAutoSizeColumnsClick
    end
    object btnLoadColumnsLayout: TButton
      AlignWithMargins = True
      Left = 143
      Top = 18
      Width = 186
      Height = 30
      Align = alLeft
      Caption = 'LoadColumnsFromJsonString'
      TabOrder = 1
      OnClick = btnLoadColumnsLayoutClick
    end
    object btnResetDBGrid: TButton
      AlignWithMargins = True
      Left = 335
      Top = 18
      Width = 106
      Height = 30
      Align = alLeft
      Caption = 'Reset Grid'
      TabOrder = 2
      OnClick = btnResetDBGridClick
    end
  end
  object tmrOnReady: TTimer
    Interval = 1
    OnTimer = tmrOnReadyTimer
    Left = 48
    Top = 152
  end
end

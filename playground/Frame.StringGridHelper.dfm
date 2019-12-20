object FrameStringGridHelper: TFrameStringGridHelper
  Left = 0
  Top = 0
  Width = 744
  Height = 372
  TabOrder = 0
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 738
    Height = 54
    Align = alTop
    Caption = 'GroupBox1'
    TabOrder = 0
    object Button1: TButton
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 124
      Height = 31
      Align = alLeft
      Caption = 'Set columns width'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      AlignWithMargins = True
      Left = 135
      Top = 18
      Width = 124
      Height = 31
      Align = alLeft
      Caption = 'Fill grid data'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      AlignWithMargins = True
      Left = 265
      Top = 18
      Width = 124
      Height = 31
      Align = alLeft
      Caption = 'Fill with JSON'
      TabOrder = 2
      OnClick = Button3Click
    end
    object Button4: TButton
      AlignWithMargins = True
      Left = 395
      Top = 18
      Width = 118
      Height = 31
      Align = alLeft
      Caption = 'Reset (grid)'
      TabOrder = 3
      OnClick = Button4Click
    end
  end
  object StringGrid1: TStringGrid
    AlignWithMargins = True
    Left = 3
    Top = 63
    Width = 738
    Height = 306
    Align = alClient
    TabOrder = 1
  end
end

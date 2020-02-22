object BytesStreamHelpersFrame: TBytesStreamHelpersFrame
  Left = 0
  Top = 0
  Width = 546
  Height = 240
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 360
    Top = 44
    Width = 5
    Height = 196
    Align = alRight
    ExplicitLeft = 362
  end
  object FlowPanel1: TFlowPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 540
    Height = 38
    Align = alTop
    AutoSize = True
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 0
    object btnShowPngImage: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 133
      Height = 30
      Caption = 'Show PNG Image'
      TabOrder = 0
      OnClick = btnShowPngImageClick
    end
    object btnShowSmaile: TButton
      AlignWithMargins = True
      Left = 143
      Top = 4
      Width = 133
      Height = 30
      Caption = 'Show Smaile'
      TabOrder = 1
      OnClick = btnShowSmaileClick
    end
  end
  object ScrollBox1: TScrollBox
    AlignWithMargins = True
    Left = 365
    Top = 47
    Width = 178
    Height = 190
    Margins.Left = 0
    Align = alRight
    TabOrder = 1
    DesignSize = (
      174
      186)
    object Image1: TImage
      Left = 36
      Top = 37
      Width = 109
      Height = 108
      Anchors = []
    end
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 47
    Width = 357
    Height = 190
    Margins.Right = 0
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
end

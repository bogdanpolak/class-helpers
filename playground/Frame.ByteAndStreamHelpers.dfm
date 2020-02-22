object BytesStreamHelpersFrame: TBytesStreamHelpersFrame
  Left = 0
  Top = 0
  Width = 546
  Height = 240
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 360
    Top = 80
    Width = 5
    Height = 160
    Align = alRight
    ExplicitLeft = 362
    ExplicitTop = 44
    ExplicitHeight = 196
  end
  object FlowPanel1: TFlowPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 540
    Height = 74
    Align = alTop
    AutoSize = True
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 0
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 69
      Height = 30
      BevelOuter = bvNone
      Caption = 'TBytes:'
      Color = 11009788
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 5
    end
    object btnShowPngImage: TButton
      AlignWithMargins = True
      Left = 79
      Top = 4
      Width = 146
      Height = 30
      Caption = 'Show PNG Image'
      TabOrder = 0
      OnClick = btnShowPngImageClick
    end
    object btnShowSmaile: TButton
      AlignWithMargins = True
      Left = 231
      Top = 4
      Width = 146
      Height = 30
      Caption = 'Show Smaile'
      TabOrder = 1
      OnClick = btnShowSmaileClick
    end
    object btnShowJPEG: TButton
      AlignWithMargins = True
      Left = 383
      Top = 4
      Width = 146
      Height = 30
      Caption = 'Show JPEG'
      TabOrder = 2
      OnClick = btnShowJPEGClick
    end
    object Panel2: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 40
      Width = 69
      Height = 30
      BevelOuter = bvNone
      Caption = 'TStream:'
      Color = 11009788
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ParentFont = False
      TabOrder = 6
    end
    object btnSaveAsTempFile: TButton
      AlignWithMargins = True
      Left = 79
      Top = 40
      Width = 146
      Height = 30
      Caption = 'Save As Temporary File'
      TabOrder = 3
      OnClick = btnSaveAsTempFileClick
    end
    object btnWriteTextToStream: TButton
      AlignWithMargins = True
      Left = 231
      Top = 40
      Width = 146
      Height = 30
      Caption = 'Write Text To Stream'
      TabOrder = 4
      OnClick = btnWriteTextToStreamClick
    end
  end
  object ScrollBox1: TScrollBox
    AlignWithMargins = True
    Left = 365
    Top = 83
    Width = 178
    Height = 154
    Margins.Left = 0
    Align = alRight
    TabOrder = 1
    DesignSize = (
      174
      150)
    object Image1: TImage
      Left = 36
      Top = 19
      Width = 109
      Height = 108
      Anchors = []
      ExplicitTop = 37
    end
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 83
    Width = 357
    Height = 154
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
    ExplicitLeft = 0
  end
end

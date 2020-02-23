object Form1: TForm1
  Left = 0
  Top = 0
  ActiveControl = Memo1
  Caption = 'Form1'
  ClientHeight = 350
  ClientWidth = 555
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 77
    Width = 549
    Height = 270
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    ExplicitLeft = -2
    ExplicitTop = 81
    ExplicitWidth = 547
    ExplicitHeight = 266
  end
  object FlowPanel1: TFlowPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 549
    Height = 68
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object btnNewInterval: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 134
      Height = 30
      Caption = 'New Interval - 2 sec.'
      TabOrder = 0
      OnClick = btnNewIntervalClick
    end
    object btnNewTimeout: TButton
      AlignWithMargins = True
      Left = 143
      Top = 3
      Width = 134
      Height = 30
      Align = alLeft
      Caption = 'New Timeout - 5 sec.'
      TabOrder = 1
      OnClick = btnNewTimeoutClick
    end
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 283
      Top = 3
      Width = 30
      Height = 29
      Shape = bsSpacer
    end
    object btnClearMemo: TButton
      AlignWithMargins = True
      Left = 319
      Top = 3
      Width = 134
      Height = 30
      Caption = 'Clear Memo'
      TabOrder = 3
      OnClick = btnClearMemoClick
    end
    object Bevel2: TBevel
      AlignWithMargins = True
      Left = 459
      Top = 3
      Width = 34
      Height = 29
      Shape = bsSpacer
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 6
      Top = 44
      Width = 76
      Height = 18
      Margins.Left = 6
      Margins.Top = 8
      Alignment = taCenter
      Caption = 'Interval ID:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edtInterID: TEdit
      AlignWithMargins = True
      Left = 88
      Top = 39
      Width = 76
      Height = 26
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = 'edtInterID'
      OnKeyPress = edtInterIDKeyPress
    end
    object Label2: TLabel
      Left = 167
      Top = 36
      Width = 82
      Height = 26
      Alignment = taCenter
      Caption = 'To clear Interval type ID + Enter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
      WordWrap = True
    end
  end
end

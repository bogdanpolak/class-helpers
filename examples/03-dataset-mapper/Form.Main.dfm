object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Dataset Mapper Demo - LoadData & SaveData'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 300
    Width = 800
    Height = 4
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 251
    ExplicitWidth = 585
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 232
      Height = 13
      Caption = 'Dataset Mapper Demo (LoadData && SaveData)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 800
    Height = 259
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 800
      Height = 25
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label2: TLabel
        Left = 8
        Top = 6
        Width = 134
        Height = 13
        Caption = 'Dataset Grid (Sample Data)'
      end
    end
    object DBGrid1: TDBGrid
      Left = 0
      Top = 25
      Width = 800
      Height = 234
      Align = alClient
      DataSource = DataSource1
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 304
    Width = 800
    Height = 296
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object Panel5: TPanel
      Left = 0
      Top = 0
      Width = 800
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object btnLoadData: TButton
        Left = 8
        Top = 8
        Width = 120
        Height = 33
        Caption = '1. Load Data'
        TabOrder = 0
        OnClick = btnLoadDataClick
      end
      object btnModifyData: TButton
        Left = 134
        Top = 8
        Width = 120
        Height = 33
        Caption = '2. Modify Data'
        TabOrder = 1
        OnClick = btnModifyDataClick
      end
      object btnSaveData: TButton
        Left = 260
        Top = 8
        Width = 120
        Height = 33
        Caption = '3. Save Data'
        TabOrder = 2
        OnClick = btnSaveDataClick
      end
      object btnReset: TButton
        Left = 408
        Top = 8
        Width = 120
        Height = 33
        Caption = 'Reset'
        TabOrder = 3
        OnClick = btnResetClick
      end
    end
    object Memo1: TMemo
      Left = 0
      Top = 49
      Width = 800
      Height = 247
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
        Width = 120
        Height = 33
        Caption = 'Reset'
        TabOrder = 3
        OnClick = btnResetClick
      end
    end
  end
  object DataSource1: TDataSource
    Left = 344
    Top = 136
  end
  object ClientDataSet1: TClientDataSet
    Left = 272
    Top = 136
  end
end

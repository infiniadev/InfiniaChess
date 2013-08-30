object fCLDemoBoard: TfCLDemoBoard
  Left = 403
  Top = 324
  BorderStyle = bsDialog
  Caption = 'Creating Demo Board'
  ClientHeight = 191
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label7: TLabel
    Left = 11
    Top = 4
    Width = 65
    Height = 29
    Caption = 'Black'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label8: TLabel
    Left = 11
    Top = 152
    Width = 67
    Height = 29
    Caption = 'White'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 192
    Top = 152
    Width = 109
    Height = 33
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 0
      Top = 0
      Width = 109
      Height = 33
      Caption = 'Go!'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = SpeedButton1Click
    end
  end
  object Panel2: TPanel
    Left = 4
    Top = 36
    Width = 297
    Height = 49
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Label4: TLabel
      Left = 4
      Top = 4
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object Label5: TLabel
      Left = 128
      Top = 4
      Width = 20
      Height = 13
      Caption = 'Title'
    end
    object Label6: TLabel
      Left = 204
      Top = 4
      Width = 31
      Height = 13
      Caption = 'Rating'
    end
    object edBlack: TEdit
      Left = 4
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object cmbBlackTitle: TComboBox
      Left = 128
      Top = 20
      Width = 73
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'GM'
        'IM'
        'FGM'
        'FM'
        'WGM'
        'WIM')
    end
    object edBlackRating: TEdit
      Left = 204
      Top = 20
      Width = 85
      Height = 21
      TabOrder = 2
    end
  end
  object Panel3: TPanel
    Left = 4
    Top = 96
    Width = 297
    Height = 49
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label1: TLabel
      Left = 4
      Top = 4
      Width = 28
      Height = 13
      Caption = 'Name'
    end
    object Label3: TLabel
      Left = 128
      Top = 4
      Width = 20
      Height = 13
      Caption = 'Title'
    end
    object Label2: TLabel
      Left = 204
      Top = 4
      Width = 31
      Height = 13
      Caption = 'Rating'
    end
    object edWhite: TEdit
      Left = 4
      Top = 20
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object cmbWhiteTitle: TComboBox
      Left = 128
      Top = 20
      Width = 73
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'GM'
        'IM'
        'FGM'
        'FM'
        'WGM'
        'WIM')
    end
    object edWhiteRating: TEdit
      Left = 204
      Top = 20
      Width = 85
      Height = 21
      TabOrder = 2
    end
  end
end

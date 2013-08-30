object FCLAutoUpdate: TFCLAutoUpdate
  Left = 437
  Top = 362
  BorderStyle = bsDialog
  Caption = 'Autoupdate'
  ClientHeight = 78
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    363
    78)
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 4
    Top = 4
    Width = 295
    Height = 53
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'lbl1'
  end
  object PB1: TProgressBar
    Left = 0
    Top = 62
    Width = 363
    Height = 16
    Align = alBottom
    Max = 3500000
    Step = 1
    TabOrder = 0
  end
  object btnUpdate: TButton
    Left = 306
    Top = 4
    Width = 55
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Update'
    TabOrder = 1
    OnClick = btnUpdateClick
  end
  object btnSkip: TButton
    Left = 306
    Top = 32
    Width = 55
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Skip'
    TabOrder = 2
    OnClick = btnSkipClick
  end
end

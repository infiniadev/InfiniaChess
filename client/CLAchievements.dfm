object fCLAchievements: TfCLAchievements
  Tag = 23
  Left = 417
  Top = 288
  BorderStyle = bsNone
  Caption = 'Achievements'
  ClientHeight = 373
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object sbVer: TScrollBar
    Left = 614
    Top = 19
    Width = 16
    Height = 338
    Align = alRight
    Kind = sbVertical
    LargeChange = 10
    PageSize = 0
    Position = 1
    TabOrder = 0
    Visible = False
    OnChange = sbVerChange
    OnScroll = sbVerScroll
  end
  object pnlFilter: TPanel
    Left = 0
    Top = 19
    Width = 341
    Height = 52
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 1
    Visible = False
    object Label1: TLabel
      Left = 168
      Top = 18
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object cmbFilter: TComboBox
      Left = 14
      Top = 14
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'All achievements'
        'Finished only'
        'In progress only'
        'Disabled only')
    end
    object edName: TEdit
      Left = 206
      Top = 14
      Width = 121
      Height = 21
      TabOrder = 1
    end
  end
  object sbHor: TScrollBar
    Left = 0
    Top = 357
    Width = 630
    Height = 16
    Align = alBottom
    PageSize = 0
    TabOrder = 2
    Visible = False
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 630
    Height = 19
    Align = alTop
    Alignment = taLeftJustify
    Caption = 'Achievements'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
end

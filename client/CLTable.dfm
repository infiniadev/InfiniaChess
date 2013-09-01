object fCLTable: TfCLTable
  Left = 266
  Top = 296
  BorderStyle = bsNone
  Caption = 'fCLTable'
  ClientHeight = 373
  ClientWidth = 630
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnDblClick = FormDblClick
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseWheel = FormMouseWheel
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 630
    Height = 18
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      630
      18)
    object lblGames: TLabel
      Left = 4
      Top = 2
      Width = 57
      Height = 13
      Caption = 'Standings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sbMax: TSpeedButton
      Left = 610
      Top = 2
      Width = 16
      Height = 16
      Hint = 'Maximize / Restore'
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        42030000424D42030000000000003600000028000000110000000F0000000100
        1800000000000C03000000000000000000000000000000000000C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D400
        0000000000000000000000000000000000000000000000000000C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0
        D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
        0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4000000C8D0
        D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000000000000000C8D0D4C8
        D0D4C8D0D400C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D4C8D0D4C8D0D4000000C8D0D4000000C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4
        C8D0D4000000000000000000000000000000000000000000000000000000C8D0
        D4000000C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0
        D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4000000000000000000000000000000000000000000000000000000
        C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0
        D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D400}
      OnClick = sbMaxClick
    end
  end
  object scbHor: TScrollBar
    Left = 0
    Top = 357
    Width = 630
    Height = 16
    Align = alBottom
    LargeChange = 10
    PageSize = 0
    TabOrder = 1
    OnChange = scbHorChange
  end
  object scbVer: TScrollBar
    Left = 614
    Top = 18
    Width = 16
    Height = 339
    Align = alRight
    Kind = sbVertical
    PageSize = 0
    TabOrder = 2
    OnChange = scbHorChange
  end
  object pnlPhoto: TPanel
    Left = 264
    Top = 68
    Width = 100
    Height = 100
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    Visible = False
    object imgPhoto: TImage
      Left = 2
      Top = 2
      Width = 96
      Height = 96
    end
  end
  object pm: TPopupMenu
    OnPopup = pmPopup
    Left = 204
    Top = 124
    object miForfeit: TMenuItem
      Caption = 'Forfeit'
    end
  end
end

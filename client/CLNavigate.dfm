object fCLNavigate: TfCLNavigate
  Left = 431
  Top = 208
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biMaximize]
  BorderStyle = bsNone
  ClientHeight = 324
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnPaint = FormPaint
  DesignSize = (
    590
    324)
  PixelsPerInch = 96
  TextHeight = 13
  object bvlHeader: TBevel
    Left = 0
    Top = 0
    Width = 590
    Height = 19
    Align = alTop
    Style = bsRaised
  end
  object lblFrames: TLabel
    Left = 4
    Top = 3
    Width = 69
    Height = 13
    AutoSize = False
    Caption = 'Frames'
    Transparent = True
  end
  object sbPin: TSpeedButton
    Left = 572
    Top = 1
    Width = 16
    Height = 16
    AllowAllUp = True
    Anchors = [akTop, akRight]
    Flat = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Glyph.Data = {
      C6010000424DC60100000000000036000000280000000D0000000A0000000100
      1800000000009001000000000000000000000000000000000000C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D400C8D0D4C8D0D4000000000000C8D0D4C8D0D4C8D0D4C8D0D4000000000000
      C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D400
      0000000000C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D40000
      00000000000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D400C8D0D4C8D0D4C8D0D4C8D0D4000000000000000000000000C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D400
      0000000000C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4000000C8D0
      D4C8D0D4C8D0D4C8D0D4000000000000C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
      D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
      C8D0D4C8D0D4C8D0D400}
    ParentFont = False
    OnClick = sbPinClick
  end
  object clNavigate: TCLListBox
    Left = 0
    Top = 19
    Width = 590
    Height = 305
    Align = alClient
    BorderStyle = bsNone
    Color = clBtnFace
    CustomDraw = False
    DifferentFonts = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 16
    OnClick = clNavigateClick
    OnDrawItem = clNavigateDrawItem
    SelectedFont.Charset = DEFAULT_CHARSET
    SelectedFont.Color = clWindowText
    SelectedFont.Height = -11
    SelectedFont.Name = 'MS Sans Serif'
    SelectedFont.Style = []
    SmallFontSize = 0
    LargeFontSize = 12
    Style = lbOwnerDrawFixed
    TabOrder = 0
  end
end

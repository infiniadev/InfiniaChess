object fCLGames: TfCLGames
  Tag = 12
  Left = 404
  Top = 365
  BorderStyle = bsNone
  Caption = 'Games'
  ClientHeight = 324
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
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
  object sbMax: TSpeedButton
    Left = 572
    Top = 1
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
  object lblGames: TLabel
    Left = 4
    Top = 2
    Width = 39
    Height = 13
    Caption = 'Games'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblGames2: TLabel
    Left = 46
    Top = 2
    Width = 126
    Height = 13
    Caption = '(begin played or examined)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lvGames: TListView
    Left = 0
    Top = 19
    Width = 590
    Height = 305
    Align = alClient
    BorderStyle = bsNone
    Columns = <
      item
        Caption = '#'
      end
      item
        Caption = 'White'
        Width = 100
      end
      item
        Caption = 'Rating'
      end
      item
        Caption = 'Black'
        Width = 100
      end
      item
        Caption = 'Rating'
      end
      item
        Caption = 'Type'
        Width = 105
      end
      item
        Caption = 'Time Control'
        Width = 75
      end
      item
        Caption = 'Rated'
      end
      item
        Caption = 'Result'
      end
      item
        Caption = 'Locked'
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = pmGames
    SmallImages = fCLMain.ilMain
    SortType = stData
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvGamesClick
    OnColumnClick = lvGamesColumnClick
    OnCompare = lvGamesCompare
    OnDblClick = lvGamesDblClick
    OnSelectItem = lvGamesSelectItem
  end
  object pmGames: TPopupMenu
    Left = 12
    Top = 48
    object miGamesObserve: TMenuItem
      Tag = 1
      Caption = '&Observe Game'
      Enabled = False
      OnClick = miGamesObserveClick
    end
    object miObserveHigh: TMenuItem
      Caption = 'Observe a High-Rated Game'
      OnClick = miObserveHighClick
    end
  end
end

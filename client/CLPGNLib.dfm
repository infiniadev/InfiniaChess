object fCLPGNLib: TfCLPGNLib
  Tag = 4
  Left = 553
  Top = 336
  BorderStyle = bsNone
  Caption = 'Library'
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
  object lblPGNLibrary: TLabel
    Left = 4
    Top = 2
    Width = 39
    Height = 13
    Caption = 'Library'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
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
  object lblPGNFilePath: TLabel
    Left = 155
    Top = 2
    Width = 3
    Height = 13
  end
  object lblPGNLibrary2: TLabel
    Left = 46
    Top = 2
    Width = 100
    Height = 13
    Caption = '(of local PGN games)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lvPGNLib: TListView
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
        Width = 75
      end
      item
        Caption = 'Rating'
      end
      item
        Caption = 'Black'
        Width = 75
      end
      item
        Caption = 'Rating'
      end
      item
        Caption = 'Site'
        Width = 100
      end
      item
        Caption = 'Event'
        Width = 100
      end
      item
        Caption = 'Round'
      end
      item
        Caption = 'Result'
        Width = 75
      end
      item
        Caption = 'ECO'
      end
      item
        Caption = 'Date'
        Width = 75
      end>
    HideSelection = False
    OwnerData = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = pmPGNLib
    SmallImages = fCLMain.ilMain
    SortType = stData
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvPGNLibClick
    OnColumnClick = lvPGNLibColumnClick
    OnData = lvPGNLibData
    OnDblClick = lvPGNLibDblClick
    OnSelectItem = lvPGNLibSelectItem
  end
  object pmPGNLib: TPopupMenu
    Left = 8
    Top = 48
    object miOpen: TMenuItem
      Caption = '&Open...'
      OnClick = miOpenClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miLoadGame: TMenuItem
      Tag = 8
      Caption = '&Load Game'
      Enabled = False
      OnClick = miLoadGameClick
    end
    object miClear: TMenuItem
      Tag = 9
      Caption = '&Clear List'
      OnClick = miClearClick
    end
  end
  object odPGN: TOpenDialog
    DefaultExt = 'pgn'
    Filter = 'Portable Game Notation (*.pgn, *.txt)|*.pgn;*.txt'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 48
    Top = 48
  end
end

object fCLRooms: TfCLRooms
  Tag = 3
  Left = 311
  Top = 157
  BorderStyle = bsNone
  Caption = 'Rooms'
  ClientHeight = 324
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = pmRooms
  OnClose = FormClose
  OnCreate = FormCreate
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
  object lblRooms: TLabel
    Left = 4
    Top = 2
    Width = 39
    Height = 13
    Caption = 'Rooms'
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
  object lblRooms2: TLabel
    Left = 46
    Top = 2
    Width = 151
    Height = 13
    Caption = '(available for chatting or events)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lvRooms: TListView
    Left = 0
    Top = 19
    Width = 590
    Height = 305
    Align = alClient
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Room #'
      end
      item
        Caption = 'Description'
        Width = 200
      end
      item
        Caption = 'Creator'
        Width = 200
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    SmallImages = fCLMain.ilMain
    SortType = stData
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvRoomsClick
    OnColumnClick = lvRoomsColumnClick
    OnCompare = lvRoomsCompare
    OnCustomDrawItem = lvRoomsCustomDrawItem
    OnSelectItem = lvRoomsSelectItem
  end
  object pmRooms: TPopupMenu
    OnPopup = pmRoomsPopup
    Left = 12
    Top = 48
    object miEnterRoom: TMenuItem
      Caption = '&Enter Room'
      Enabled = False
      OnClick = miEnterRoomClick
    end
    object miExitRoom: TMenuItem
      Caption = 'E&xit Room'
      Enabled = False
      OnClick = miExitRoomClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miCreateRoom: TMenuItem
      Caption = '&Create Room...'
      OnClick = miCreateRoomClick
    end
    object miDeleteRoom: TMenuItem
      Caption = 'Delete Room'
      OnClick = miDeleteRoomClick
    end
  end
end

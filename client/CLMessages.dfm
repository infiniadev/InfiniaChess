object fCLMessages: TfCLMessages
  Tag = 7
  Left = 263
  Top = 261
  BorderStyle = bsNone
  Caption = 'Messages'
  ClientHeight = 611
  ClientWidth = 964
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    964
    611)
  PixelsPerInch = 96
  TextHeight = 13
  object bvlMessages: TBevel
    Left = 0
    Top = 0
    Width = 964
    Height = 19
    Align = alTop
    Style = bsRaised
  end
  object lblMessages: TLabel
    Left = 4
    Top = 2
    Width = 57
    Height = 13
    Caption = 'Messages'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object sbMax: TSpeedButton
    Left = 946
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
  object lblMessages2: TLabel
    Left = 64
    Top = 2
    Width = 89
    Height = 13
    Caption = '(from other players)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lvMessages: TListView
    Left = 0
    Top = 113
    Width = 964
    Height = 498
    Align = alClient
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'From'
        Width = 100
      end
      item
        Caption = 'Date'
        Width = 75
      end
      item
        Caption = 'Subject'
        Width = 100
      end
      item
        Caption = 'Message'
        Width = 400
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = pmMessages
    SmallImages = fCLMain.ilMain
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvMessagesClick
    OnColumnClick = lvMessagesColumnClick
    OnCompare = lvMessagesCompare
    OnKeyDown = lvMessagesKeyDown
    OnSelectItem = lvMessagesSelectItem
  end
  object Panel4: TPanel
    Left = 0
    Top = 19
    Width = 964
    Height = 94
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Label7: TLabel
      Left = 8
      Top = 6
      Width = 29
      Height = 13
      Caption = 'Folder'
    end
    object lblSender: TLabel
      Left = 222
      Top = 6
      Width = 34
      Height = 13
      Caption = 'Sender'
    end
    object sbClearSender: TSpeedButton
      Left = 300
      Top = 20
      Width = 23
      Height = 22
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD88DDDDDDDD
        88DDDDFFDDDDDDDDFFDDDD888DDDDDD888DDDDFFFDDDDDDFFFDDDDD888DDDD88
        8DDDDDDFFFDDDDFFFDDDDDDD888DD888DDDDDDDDFFFDDFFFDDDDDDDDD888888D
        DDDDDDDDDFFFFFFDDDDDDDDDDD8888DDDDDDDDDDDDFFFFDDDDDDDDDDDD8888DD
        DDDDDDDDDDFFFFDDDDDDDDDDD888888DDDDDDDDDDFFFFFFDDDDDDDDD888DD888
        DDDDDDDDFFFDDFFFDDDDDDD888DDDD888DDDDDDFFFDDDDFFFDDDDD888DDDDDD8
        88DDDDFFFDDDDDDFFFDDDD88DDDDDDDD88DDDDFFDDDDDDDDFFDDDDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
      NumGlyphs = 2
      OnClick = sbClearSenderClick
    end
    object Label12: TLabel
      Left = 10
      Top = 48
      Width = 70
      Height = 13
      Caption = 'Text to Search'
    end
    object sbClearText: TSpeedButton
      Left = 104
      Top = 64
      Width = 23
      Height = 22
      AllowAllUp = True
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD88DDDDDDDD
        88DDDDFFDDDDDDDDFFDDDD888DDDDDD888DDDDFFFDDDDDDFFFDDDDD888DDDD88
        8DDDDDDFFFDDDDFFFDDDDDDD888DD888DDDDDDDDFFFDDFFFDDDDDDDDD888888D
        DDDDDDDDDFFFFFFDDDDDDDDDDD8888DDDDDDDDDDDDFFFFDDDDDDDDDDDD8888DD
        DDDDDDDDDDFFFFDDDDDDDDDDD888888DDDDDDDDDDFFFFFFDDDDDDDDD888DD888
        DDDDDDDDFFFDDFFFDDDDDDD888DDDD888DDDDDDFFFDDDDFFFDDDDD888DDDDDD8
        88DDDDFFFDDDDDDFFFDDDD88DDDDDDDD88DDDDFFDDDDDDDDFFDDDDDDDDDDDDDD
        DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
      NumGlyphs = 2
      OnClick = sbClearTextClick
    end
    object Label13: TLabel
      Left = 134
      Top = 8
      Width = 49
      Height = 13
      Caption = 'Date From'
    end
    object Label14: TLabel
      Left = 132
      Top = 50
      Width = 39
      Height = 13
      Caption = 'Date To'
    end
    object Label15: TLabel
      Left = 330
      Top = 6
      Width = 25
      Height = 13
      Caption = 'Page'
    end
    object lblPagesCount: TLabel
      Left = 388
      Top = 24
      Width = 45
      Height = 13
      AutoSize = False
      Caption = 'of'
    end
    object cmbFolder: TComboBox
      Left = 8
      Top = 22
      Width = 117
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cmbFolderChange
      Items.Strings = (
        'Inbox'
        'Outbox'
        'Stored'
        'Deleted')
    end
    object edtSender: TEdit
      Left = 222
      Top = 20
      Width = 75
      Height = 21
      TabOrder = 1
      OnChange = dtFilterFromClick
    end
    object edtText: TEdit
      Left = 10
      Top = 64
      Width = 91
      Height = 21
      TabOrder = 2
      OnChange = dtFilterFromClick
    end
    object dtFilterFrom: TDateTimePicker
      Left = 132
      Top = 22
      Width = 87
      Height = 21
      Date = 39409.000000000000000000
      Time = 39409.000000000000000000
      ParseInput = True
      TabOrder = 3
      OnClick = dtFilterFromClick
    end
    object dtFilterTo: TDateTimePicker
      Left = 132
      Top = 64
      Width = 87
      Height = 21
      Date = 39409.000000000000000000
      Time = 39409.000000000000000000
      ParseInput = True
      TabOrder = 4
      OnClick = dtFilterFromClick
    end
    object edPage: TEdit
      Left = 330
      Top = 20
      Width = 39
      Height = 21
      TabOrder = 5
      Text = '1'
    end
    object udPage: TUpDown
      Left = 369
      Top = 20
      Width = 15
      Height = 21
      Associate = edPage
      Min = 1
      Position = 1
      TabOrder = 6
    end
    object pnlClear: TPanel
      Left = 222
      Top = 60
      Width = 100
      Height = 25
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 7
      object sbClear: TSpeedButton
        Left = 0
        Top = 0
        Width = 100
        Height = 25
        AllowAllUp = True
        Caption = 'Clear all'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD88DDDDDDDD
          88DDDDFFDDDDDDDDFFDDDD888DDDDDD888DDDDFFFDDDDDDFFFDDDDD888DDDD88
          8DDDDDDFFFDDDDFFFDDDDDDD888DD888DDDDDDDDFFFDDFFFDDDDDDDDD888888D
          DDDDDDDDDFFFFFFDDDDDDDDDDD8888DDDDDDDDDDDDFFFFDDDDDDDDDDDD8888DD
          DDDDDDDDDDFFFFDDDDDDDDDDD888888DDDDDDDDDDFFFFFFDDDDDDDDD888DD888
          DDDDDDDDFFFDDFFFDDDDDDD888DDDD888DDDDDDFFFDDDDFFFDDDDD888DDDDDD8
          88DDDDFFFDDDDDDFFFDDDD88DDDDDDDD88DDDDFFDDDDDDDDFFDDDDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
        NumGlyphs = 2
        OnClick = sbClearClick
      end
    end
    object pnlSearch: TPanel
      Left = 324
      Top = 60
      Width = 100
      Height = 25
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 8
      object sbMessageSearch: TSpeedButton
        Left = 0
        Top = 0
        Width = 100
        Height = 25
        AllowAllUp = True
        Caption = 'Search'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888888888888888888888888888888888888888888888
          8888888888888888888888888F8F8F8F8F8888888F8F8F8F8F8888F8F8F8F8F8
          F8F888F8F8F8F8F8F8F88F8F800000077F8F8F8F877777777F8FF8F00EEEFFF7
          78F8F8F77FFFFFF778F88F04E400E0007F8F8F77F777F7777F8FF800E000E007
          F8F8F877F777F777F8F88F000000007F8F8F8F777777778F8F8FF87700077778
          F8F8F88877788888F8F88F777777778F8F888F888888888F8F8888F77778F8F8
          F88888F88888F8F8F888888F8F8F8F888888888F8F8F8F888888888888888888
          8888888888888888888888888888888888888888888888888888}
        NumGlyphs = 2
        OnClick = sbMessageSearchClick
      end
    end
  end
  object pmMessages: TPopupMenu
    Left = 528
    Top = 36
    object miNewMessage: TMenuItem
      Caption = '&New Message...'
      OnClick = miNewMessageClick
    end
    object miReply: TMenuItem
      Caption = '&Reply...'
      Enabled = False
      OnClick = miReplyClick
    end
    object miDeleteMessage: TMenuItem
      Caption = '&Delete Message'
      Enabled = False
      OnClick = miDeleteMessageClick
    end
    object miStoreMessage: TMenuItem
      Caption = 'Store Message'
      Enabled = False
      OnClick = miStoreMessageClick
    end
    object miDeletePerm: TMenuItem
      Caption = 'Delete &Permanently'
      Enabled = False
      OnClick = miDeletePermClick
    end
  end
end

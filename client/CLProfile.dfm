object fCLProfile: TfCLProfile
  Tag = 1
  Left = 276
  Top = 149
  BorderStyle = bsNone
  Caption = 'Profile'
  ClientHeight = 668
  ClientWidth = 978
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlChatLog: TPanel
    Left = 0
    Top = 41
    Width = 962
    Height = 611
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    Visible = False
    object Label22: TLabel
      Left = 18
      Top = 84
      Width = 682
      Height = 24
      Caption = 
        'Chat Log is moved to web site: www.infiniachess.com/chat-log.asp' +
        'x'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel1: TPanel
      Left = 2
      Top = 2
      Width = 958
      Height = 67
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 0
      Visible = False
      object Label2: TLabel
        Left = 8
        Top = 12
        Width = 23
        Height = 13
        Caption = 'From'
      end
      object Label4: TLabel
        Left = 16
        Top = 40
        Width = 13
        Height = 13
        Caption = 'To'
      end
      object Label5: TLabel
        Left = 284
        Top = 12
        Width = 59
        Height = 13
        Caption = 'Room Name'
      end
      object Label6: TLabel
        Left = 276
        Top = 40
        Width = 68
        Height = 13
        Caption = 'Text to search'
      end
      object SpeedButton1: TSpeedButton
        Left = 476
        Top = 8
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
        OnClick = SpeedButton1Click
      end
      object SpeedButton2: TSpeedButton
        Left = 476
        Top = 36
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
        OnClick = SpeedButton2Click
      end
      object lblPageCount: TLabel
        Left = 608
        Top = 40
        Width = 49
        Height = 13
        AutoSize = False
        Caption = 'of ???'
      end
      object sbPageLast: TSpeedButton
        Left = 644
        Top = 36
        Width = 23
        Height = 22
        Caption = '>>'
        OnClick = sbPageLastClick
      end
      object sbPageFirst: TSpeedButton
        Left = 512
        Top = 36
        Width = 23
        Height = 22
        Caption = '<<'
        OnClick = sbPageFirstClick
      end
      object Label8: TLabel
        Left = 512
        Top = 12
        Width = 25
        Height = 13
        Caption = 'Page'
      end
      object dtFrom: TDateTimePicker
        Left = 40
        Top = 8
        Width = 89
        Height = 21
        Date = 39302.624060138900000000
        Time = 39302.624060138900000000
        Color = clBtnFace
        ParentColor = True
        TabOrder = 0
        OnChange = dtFromChange
      end
      object dtTo: TDateTimePicker
        Left = 40
        Top = 36
        Width = 89
        Height = 21
        Date = 39302.624060138900000000
        Time = 39302.624060138900000000
        Color = clBtnFace
        ParentColor = True
        TabOrder = 1
        OnChange = edtRoomNameChange
      end
      object rbThisUserOnly: TRadioButton
        Left = 136
        Top = 8
        Width = 145
        Height = 17
        Caption = 'Only this user messages'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = edtRoomNameChange
      end
      object rbFullChat: TRadioButton
        Left = 136
        Top = 36
        Width = 69
        Height = 17
        Caption = 'Full chat'
        TabOrder = 3
        OnClick = edtRoomNameChange
      end
      object edtRoomName: TEdit
        Left = 352
        Top = 8
        Width = 121
        Height = 21
        ParentColor = True
        TabOrder = 4
        OnChange = edtRoomNameChange
      end
      object edtText: TEdit
        Left = 352
        Top = 36
        Width = 121
        Height = 21
        ParentColor = True
        TabOrder = 5
        OnChange = edtRoomNameChange
      end
      object Panel2: TPanel
        Left = 568
        Top = 4
        Width = 101
        Height = 25
        BevelInner = bvRaised
        BevelOuter = bvLowered
        ParentColor = True
        TabOrder = 6
        object sbSearch: TSpeedButton
          Left = 1
          Top = 1
          Width = 100
          Height = 24
          AllowAllUp = True
          Caption = 'Search'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Transparent = False
          OnClick = sbSearchClick
        end
      end
      object edtPage: TEdit
        Left = 536
        Top = 36
        Width = 49
        Height = 21
        ParentColor = True
        TabOrder = 7
        Text = '1'
      end
      object udPage: TUpDown
        Left = 585
        Top = 36
        Width = 15
        Height = 21
        Associate = edtPage
        Position = 1
        TabOrder = 8
      end
    end
    object reChatLog: TRichEdit
      Left = 2
      Top = 490
      Width = 958
      Height = 119
      Align = alBottom
      ParentColor = True
      PopupMenu = pmChatLog
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
      Visible = False
    end
    object btnChatLogURL: TBitBtn
      Left = 136
      Top = 124
      Width = 415
      Height = 25
      Caption = 'Press Here To Open New Chat Log'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnChatLogURLClick
    end
  end
  object pnlGames: TPanel
    Left = 0
    Top = 41
    Width = 962
    Height = 611
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 6
    object pnlFilters: TPanel
      Left = 2
      Top = 2
      Width = 958
      Height = 103
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 0
      object Panel4: TPanel
        Left = 2
        Top = 2
        Width = 954
        Height = 99
        Align = alClient
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object Label7: TLabel
          Left = 8
          Top = 6
          Width = 24
          Height = 13
          Caption = 'Color'
        end
        object Label9: TLabel
          Left = 310
          Top = 6
          Width = 47
          Height = 13
          Caption = 'Opponent'
        end
        object sbClearOpponent: TSpeedButton
          Left = 388
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
          OnClick = sbClearOpponentClick
        end
        object Label10: TLabel
          Left = 118
          Top = 6
          Width = 55
          Height = 13
          Caption = 'Game Type'
        end
        object Label11: TLabel
          Left = 6
          Top = 50
          Width = 30
          Height = 13
          Caption = 'Result'
        end
        object Label12: TLabel
          Left = 118
          Top = 48
          Width = 22
          Height = 13
          Caption = 'ECO'
        end
        object sbClearEco: TSpeedButton
          Left = 192
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
          OnClick = sbClearEcoClick
        end
        object Label13: TLabel
          Left = 222
          Top = 8
          Width = 49
          Height = 13
          Caption = 'Date From'
        end
        object Label14: TLabel
          Left = 220
          Top = 50
          Width = 39
          Height = 13
          Caption = 'Date To'
        end
        object Label15: TLabel
          Left = 418
          Top = 6
          Width = 25
          Height = 13
          Caption = 'Page'
        end
        object lblPagesCount: TLabel
          Left = 476
          Top = 24
          Width = 45
          Height = 13
          AutoSize = False
          Caption = 'of'
        end
        object sbClearResult: TSpeedButton
          Left = 90
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
          OnClick = sbClearResultClick
        end
        object sbClearColor: TSpeedButton
          Left = 88
          Top = 22
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
          OnClick = sbClearColorClick
        end
        object sbClearType: TSpeedButton
          Left = 192
          Top = 22
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
          OnClick = sbClearTypeClick
        end
        object cmbColor: TComboBox
          Left = 8
          Top = 22
          Width = 79
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = FilterChange
          Items.Strings = (
            'White'
            'Black')
        end
        object edtOpponent: TEdit
          Left = 310
          Top = 20
          Width = 75
          Height = 21
          TabOrder = 1
          OnChange = FilterChange
        end
        object cmbType: TComboBox
          Left = 118
          Top = 22
          Width = 73
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = FilterChange
          Items.Strings = (
            'Standard'
            'Blitz'
            'Bullet'
            'Crazy House'
            'Fisher Random'
            'Losers')
        end
        object cmbResult: TComboBox
          Left = 6
          Top = 66
          Width = 81
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 3
          OnChange = FilterChange
          Items.Strings = (
            'White Wins'
            'Black Wins'
            'Draw'
            'Aborted')
        end
        object edtEco: TEdit
          Left = 118
          Top = 64
          Width = 71
          Height = 21
          TabOrder = 4
          OnChange = FilterChange
        end
        object dtFilterFrom: TDateTimePicker
          Left = 220
          Top = 22
          Width = 87
          Height = 21
          Date = 39409.000000000000000000
          Time = 39409.000000000000000000
          ParseInput = True
          PopupMenu = pmDate
          TabOrder = 5
          OnChange = FilterChange
        end
        object dtFilterTo: TDateTimePicker
          Left = 220
          Top = 64
          Width = 87
          Height = 21
          Date = 39409.000000000000000000
          Time = 39409.000000000000000000
          ParseInput = True
          PopupMenu = pmDate
          TabOrder = 6
          OnChange = FilterChange
        end
        object edGamesPage: TEdit
          Left = 418
          Top = 20
          Width = 39
          Height = 21
          TabOrder = 7
          Text = '1'
        end
        object udGamesPage: TUpDown
          Left = 457
          Top = 20
          Width = 15
          Height = 21
          Associate = edGamesPage
          Min = 1
          Position = 1
          TabOrder = 8
        end
        object pnlClear: TPanel
          Left = 310
          Top = 60
          Width = 100
          Height = 25
          BevelInner = bvRaised
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 9
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
          Left = 420
          Top = 60
          Width = 100
          Height = 25
          BevelInner = bvRaised
          BevelOuter = bvLowered
          ParentColor = True
          TabOrder = 10
          object sbGamesSearch: TSpeedButton
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
            OnClick = sbGamesSearchClick
          end
        end
      end
    end
    object lvGames: TListView
      Left = 2
      Top = 105
      Width = 958
      Height = 504
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
          Caption = 'ECO'
        end
        item
          Caption = 'Date'
          Width = 80
        end
        item
          Caption = 'ECO Description'
          Width = 100
        end>
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      ParentColor = True
      PopupMenu = pmProfile
      SmallImages = fCLMain.ilMain
      SortType = stData
      TabOrder = 1
      ViewStyle = vsReport
      OnColumnClick = lvGamesColumnClick
      OnCompare = lvGamesCompare
      OnCustomDrawItem = lvGamesCustomDrawItem
      OnDblClick = lvGamesDblClick
      OnKeyDown = lvGamesKeyDown
      OnSelectItem = lvGamesSelectItem
    end
  end
  object pnlProfile: TPanel
    Left = 0
    Top = 41
    Width = 962
    Height = 611
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    PopupMenu = pm1
    TabOrder = 5
    object reNotes: TRichEdit
      Tag = 432
      Left = 10
      Top = 476
      Width = 473
      Height = 93
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'Notes: ')
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object pnlRatings: TPanel
      Tag = 248
      Left = 8
      Top = 294
      Width = 520
      Height = 179
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 1
      object lblGameType: TLabel
        Left = 8
        Top = 10
        Width = 55
        Height = 13
        Alignment = taCenter
        Caption = 'Game Type'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
      end
      object lblRating: TLabel
        Left = 96
        Top = 10
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Rating'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
      end
      object lblWins: TLabel
        Left = 152
        Top = 10
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Wins'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        WordWrap = True
      end
      object lblLosses: TLabel
        Left = 208
        Top = 10
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Losses'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        WordWrap = True
      end
      object lblDraws: TLabel
        Left = 264
        Top = 10
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Draws'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        WordWrap = True
      end
      object lblBest: TLabel
        Left = 320
        Top = 10
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Best'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        WordWrap = True
      end
      object lblDate: TLabel
        Left = 376
        Top = 10
        Width = 89
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = 'Date'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        WordWrap = True
      end
      object lblGameType0: TLabel
        Left = 8
        Top = 34
        Width = 43
        Height = 13
        Caption = 'Standard'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblRating0: TLabel
        Left = 96
        Top = 34
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblWins0: TLabel
        Left = 152
        Top = 34
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblLosses0: TLabel
        Left = 208
        Top = 34
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDraws0: TLabel
        Left = 264
        Top = 34
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblBest0: TLabel
        Left = 320
        Top = 34
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDate0: TLabel
        Left = 376
        Top = 34
        Width = 89
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0000.00.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblGameType1: TLabel
        Left = 8
        Top = 58
        Width = 19
        Height = 13
        Caption = 'Blitz'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblRating1: TLabel
        Left = 96
        Top = 58
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblWins1: TLabel
        Left = 152
        Top = 58
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblLosses1: TLabel
        Left = 208
        Top = 58
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDraws1: TLabel
        Left = 264
        Top = 58
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblBest1: TLabel
        Left = 320
        Top = 58
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDate1: TLabel
        Left = 376
        Top = 58
        Width = 89
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0000.00.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblGameType2: TLabel
        Left = 8
        Top = 82
        Width = 26
        Height = 13
        Caption = 'Bullet'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblRating2: TLabel
        Left = 96
        Top = 82
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblWins2: TLabel
        Left = 152
        Top = 82
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblLosses2: TLabel
        Left = 208
        Top = 82
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDraws2: TLabel
        Left = 264
        Top = 82
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblBest2: TLabel
        Left = 320
        Top = 82
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDate2: TLabel
        Left = 376
        Top = 82
        Width = 89
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0000.00.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblGameType3: TLabel
        Left = 8
        Top = 106
        Width = 60
        Height = 13
        Caption = 'Crazy House'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblRating3: TLabel
        Left = 96
        Top = 106
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblWins3: TLabel
        Left = 152
        Top = 106
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblLosses3: TLabel
        Left = 208
        Top = 106
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDraws3: TLabel
        Left = 264
        Top = 106
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblBest3: TLabel
        Left = 320
        Top = 106
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDate3: TLabel
        Left = 376
        Top = 106
        Width = 89
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0000.00.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblGameType4: TLabel
        Left = 8
        Top = 130
        Width = 77
        Height = 13
        Caption = 'Fischer Random'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblRating4: TLabel
        Left = 96
        Top = 130
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblWins4: TLabel
        Left = 152
        Top = 130
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblLosses4: TLabel
        Left = 208
        Top = 130
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDraws4: TLabel
        Left = 264
        Top = 130
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblBest4: TLabel
        Left = 320
        Top = 130
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDate4: TLabel
        Left = 376
        Top = 130
        Width = 89
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0000.00.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblGameType5: TLabel
        Left = 8
        Top = 154
        Width = 31
        Height = 13
        Caption = 'Losers'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
      end
      object lblRating5: TLabel
        Left = 96
        Top = 154
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblWins5: TLabel
        Left = 152
        Top = 154
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblLosses5: TLabel
        Left = 208
        Top = 154
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDraws5: TLabel
        Left = 264
        Top = 154
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblBest5: TLabel
        Left = 320
        Top = 154
        Width = 50
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblDate5: TLabel
        Left = 376
        Top = 154
        Width = 89
        Height = 13
        Alignment = taCenter
        AutoSize = False
        Caption = '0000.00.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object bvlStandard: TBevel
        Left = 6
        Top = 52
        Width = 458
        Height = 2
        Shape = bsBottomLine
      end
      object bvlBlitz: TBevel
        Left = 6
        Top = 76
        Width = 458
        Height = 2
        Shape = bsBottomLine
      end
      object bvlBullet: TBevel
        Left = 6
        Top = 100
        Width = 458
        Height = 2
        Shape = bsBottomLine
      end
      object bvlCrazy: TBevel
        Left = 6
        Top = 124
        Width = 458
        Height = 2
        Shape = bsBottomLine
      end
      object bvlFischer: TBevel
        Left = 6
        Top = 148
        Width = 458
        Height = 2
        Shape = bsBottomLine
      end
    end
    object pnlInfo: TPanel
      Tag = 8
      Left = 8
      Top = 8
      Width = 520
      Height = 281
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 2
      DesignSize = (
        520
        281)
      object lblLogin: TLabel
        Left = 8
        Top = 10
        Width = 29
        Height = 13
        Caption = 'Login:'
        Transparent = True
      end
      object lblLoginData: TLabel
        Left = 44
        Top = 10
        Width = 70
        Height = 13
        Caption = 'lblLogindata'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label16: TLabel
        Left = 8
        Top = 42
        Width = 42
        Height = 13
        Caption = 'Country: '
      end
      object lblCountry: TLabel
        Left = 68
        Top = 42
        Width = 57
        Height = 13
        Caption = 'lblCountry'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label17: TLabel
        Left = 8
        Top = 62
        Width = 54
        Height = 13
        Caption = 'Language: '
      end
      object lblLanguage: TLabel
        Left = 68
        Top = 62
        Width = 70
        Height = 13
        Caption = 'lblLanguage'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label18: TLabel
        Left = 8
        Top = 82
        Width = 24
        Height = 13
        Caption = 'Sex: '
      end
      object lblSex: TLabel
        Left = 68
        Top = 82
        Width = 35
        Height = 13
        Caption = 'lblSex'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label19: TLabel
        Left = 8
        Top = 122
        Width = 22
        Height = 13
        Caption = 'Age:'
      end
      object lblAge: TLabel
        Left = 68
        Top = 122
        Width = 36
        Height = 13
        Caption = 'lblAge'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label20: TLabel
        Left = 8
        Top = 142
        Width = 31
        Height = 13
        Caption = 'Email: '
      end
      object lblEmail: TLabel
        Left = 68
        Top = 142
        Width = 44
        Height = 13
        Caption = 'lblEmail'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 6
        Top = 188
        Width = 43
        Height = 13
        Caption = 'Created: '
        Transparent = True
      end
      object lblCreated: TLabel
        Left = 62
        Top = 188
        Width = 125
        Height = 13
        Caption = '1990/01/01 12:00 am'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label3: TLabel
        Left = 6
        Top = 208
        Width = 55
        Height = 13
        Caption = 'Last Login: '
        Transparent = True
      end
      object lblLoginTS: TLabel
        Left = 62
        Top = 208
        Width = 125
        Height = 13
        Caption = '1990/01/01 12:00 am'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lblPing: TLabel
        Left = 6
        Top = 232
        Width = 148
        Height = 13
        Caption = 'Ping (average / samples / idle):'
        Transparent = True
      end
      object lblPingData: TLabel
        Left = 6
        Top = 250
        Width = 103
        Height = 13
        Caption = '000 / 000 / 00:00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object Label21: TLabel
        Left = 8
        Top = 102
        Width = 41
        Height = 13
        Caption = 'Birthday:'
      end
      object lblBirthday: TLabel
        Left = 68
        Top = 102
        Width = 60
        Height = 13
        Caption = 'lblBirthday'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object pnlPhoto: TPanel
        Left = 415
        Top = 8
        Width = 96
        Height = 96
        Anchors = [akTop, akRight]
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'NO PHOTO'
        ParentColor = True
        TabOrder = 0
        object imgPhoto: TImage
          Left = 2
          Top = 2
          Width = 92
          Height = 92
          Align = alClient
          PopupMenu = pm1
        end
      end
      object pnlPayInfo: TPanel
        Left = 240
        Top = 212
        Width = 273
        Height = 63
        BevelInner = bvRaised
        BevelOuter = bvLowered
        ParentColor = True
        TabOrder = 1
        DesignSize = (
          273
          63)
        object lblMembershipType: TLabel
          Left = 10
          Top = 10
          Width = 255
          Height = 16
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lblMembershipType'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblExpireText: TLabel
          Left = 12
          Top = 34
          Width = 58
          Height = 13
          Caption = 'Expire Date:'
        end
        object lblExpireDate: TLabel
          Left = 76
          Top = 34
          Width = 76
          Height = 13
          Caption = 'lblExpireDate'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object pnlRenew: TPanel
          Left = 186
          Top = 32
          Width = 80
          Height = 25
          Anchors = [akRight, akBottom]
          TabOrder = 0
          object sbPayHere: TSpeedButton
            Left = 0
            Top = 0
            Width = 80
            Height = 25
            AllowAllUp = True
            Caption = 'Donate!'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = sbPayHereClick
          end
        end
      end
      object pnlSpecialOffer: TPanel
        Left = 240
        Top = 110
        Width = 273
        Height = 95
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        object imgSpecialOffer: TImage
          Left = 2
          Top = 2
          Width = 269
          Height = 91
        end
      end
    end
  end
  object pnlPayment: TPanel
    Left = 0
    Top = 41
    Width = 962
    Height = 611
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 7
    object lvPayment: TListView
      Left = 2
      Top = 2
      Width = 958
      Height = 607
      Align = alClient
      BorderStyle = bsNone
      Columns = <
        item
          Caption = 'ID'
          Width = 60
        end
        item
          Caption = 'Date'
          Width = 70
        end
        item
          Caption = 'Rights'
          Width = 100
        end
        item
          Caption = 'Web Membership'
          Width = 180
        end
        item
          Caption = 'Source'
          Width = 120
        end
        item
          Caption = 'Expire'
          Width = 80
        end
        item
          Caption = 'Real Amount ($)'
          Width = 90
        end
        item
          Caption = 'Full Amount ($)'
          Width = 90
        end
        item
          Caption = 'Name on Card'
          Width = 100
        end
        item
          Caption = 'Card Type'
          Width = 100
        end
        item
          Caption = 'Card Number'
          Width = 100
        end
        item
          Caption = 'Admin Created'
          Width = 100
        end
        item
          Caption = 'Admin Deleted'
          Width = 100
        end
        item
          Caption = 'Admin Comment'
          Width = 100
        end
        item
          Caption = 'Promo Code'
          Width = 100
        end>
      GridLines = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      ParentColor = True
      PopupMenu = pmPayment
      SmallImages = ilPayment
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = lvPaymentDblClick
    end
  end
  object scbHor: TScrollBar
    Left = 0
    Top = 652
    Width = 978
    Height = 16
    Align = alBottom
    LargeChange = 10
    PageSize = 0
    TabOrder = 4
    OnChange = scbHorChange
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 978
    Height = 19
    Align = alTop
    FullRepaint = False
    TabOrder = 1
    DesignSize = (
      978
      19)
    object sbMax: TSpeedButton
      Left = 936
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
      Transparent = False
      OnClick = sbMaxClick
    end
    object sbClose: TSpeedButton
      Tag = 6
      Left = 958
      Top = 1
      Width = 16
      Height = 16
      Hint = 'Close Profile'
      Anchors = [akTop, akRight]
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
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
      ParentShowHint = False
      ShowHint = True
      OnClick = sbCloseClick
    end
    object lblProfile: TLabel
      Left = 5
      Top = 2
      Width = 52
      Height = 13
      Caption = 'Profile of'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object tcMain: TTabControl
    Left = 0
    Top = 19
    Width = 978
    Height = 22
    Align = alTop
    TabHeight = 17
    TabOrder = 2
    Tabs.Strings = (
      'Profile'
      'Information'
      'Recent'
      'Library'
      'Adjourned'
      'ECO'
      'Chat Log'
      'Achievements'
      'Payments')
    TabIndex = 0
    OnChange = tcMainChange
  end
  object scbVer: TScrollBar
    Left = 962
    Top = 41
    Width = 16
    Height = 611
    Align = alRight
    Kind = sbVertical
    PageSize = 0
    TabOrder = 3
    OnChange = scbHorChange
  end
  object pmProfile: TPopupMenu
    Left = 708
    Top = 62
    object miRefresh: TMenuItem
      Caption = '&Refresh'
      Enabled = False
      OnClick = miRefreshClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miExamine: TMenuItem
      Caption = 'E&xamine'
      Enabled = False
      OnClick = miExamineClick
    end
    object miResume: TMenuItem
      Caption = 'R&esume'
      Enabled = False
      OnClick = miResumeClick
    end
    object miAddLibrary: TMenuItem
      Caption = '&Add to Library'
      Enabled = False
      OnClick = miAddLibraryClick
    end
    object miRemoveLibrary: TMenuItem
      Caption = 'Re&move from Library'
      Enabled = False
      OnClick = miRemoveLibraryClick
    end
  end
  object pmDate: TPopupMenu
    Left = 734
    Top = 139
    object miToday: TMenuItem
      Caption = 'Today'
      OnClick = miTodayClick
    end
    object miYesterday: TMenuItem
      Caption = 'Yesterday'
      OnClick = miYesterdayClick
    end
    object miLastWeek: TMenuItem
      Caption = 'Last Week'
      OnClick = miLastWeekClick
    end
    object miLastMonth: TMenuItem
      Caption = 'Last Month'
      OnClick = miLastMonthClick
    end
    object miLast10Years: TMenuItem
      Caption = 'Last 10 years'
      OnClick = miLast10YearsClick
    end
  end
  object pm1: TPopupMenu
    OnPopup = pm1Popup
    Left = 568
    Top = 65
    object miDeletePhoto: TMenuItem
      Caption = 'Delete Photo'
      OnClick = miDeletePhotoClick
    end
    object miChangeNotes: TMenuItem
      Caption = 'Change Notes'
      OnClick = miChangeNotesClick
    end
  end
  object pmChatLog: TPopupMenu
    Left = 778
    Top = 61
    object Copy1: TMenuItem
      Caption = 'Copy'
      OnClick = Copy1Click
    end
  end
  object pmPayment: TPopupMenu
    Left = 668
    Top = 139
    object Edit1: TMenuItem
      Caption = 'Edit Transaction'
      OnClick = Edit1Click
    end
    object NewTransaction1: TMenuItem
      Caption = 'New Transaction'
      OnClick = NewTransaction1Click
    end
  end
  object ilPayment: TImageList
    Left = 604
    Top = 141
    Bitmap = {
      494C0101020004000C0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008482
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008400
      0000008200000082000084000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      8400000084008482840000000000000000000000000000000000000000000000
      FF00848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000000082
      0000008200000082000000820000840000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      84000000840000008400848284000000000000000000000000000000FF000000
      8400000084008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000008200000082
      0000008200000082000000820000008200008400000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      840000008400000084000000840084828400000000000000FF00000084000000
      8400000084000000840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008400000000820000008200000082
      000000FF00000082000000820000008200000082000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000084000000840000008400000084008482840000008400000084000000
      8400000084000000840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000820000008200000082000000FF
      00000000000000FF000000820000008200000082000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000840000008400000084000000840000008400000084000000
      8400000084008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF00000082000000FF00000000
      0000000000000000000000FF0000008200000082000000820000840000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000008400000084000000840000008400000084000000
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000000000000000
      000000000000000000000000000000FF00000082000000820000008200008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000008400000084008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000820000008200000082
      0000840000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000084000000840000008400000084008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008200000082
      0000008200008400000000000000000000000000000000000000000000000000
      0000000000000000FF0000008400000084000000840000008400000084008482
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF00000082
      0000008200000082000084000000000000000000000000000000000000000000
      00000000FF000000840000008400000084008482840000008400000084000000
      8400848284000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      0000008200000082000000820000840000000000000000000000000000000000
      FF0000008400000084000000840084828400000000000000FF00000084000000
      8400000084008482840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000082000000820000840000000000000000000000000000000000
      FF000000840000008400848284000000000000000000000000000000FF000000
      8400000084000000840084828400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000820000008200000000000000000000000000000000
      00000000FF000000840000000000000000000000000000000000000000000000
      FF00000084000000840000008400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF00000084000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00F3FFE7FF00000000E1FFC3E700000000
      C0FFC1C300000000807FC08100000000003FE00100000000083FF00300000000
      1C1FF80700000000BE0FFC0F00000000FF07FC0F00000000FF83F80F00000000
      FFC1F00700000000FFE0E08300000000FFF0E1C100000000FFF8F3E100000000
      FFFDFFF100000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
end

object fCLOptions: TfCLOptions
  Left = 406
  Top = 179
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 414
  ClientWidth = 589
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000B000000000000BBBBBBB000000BBB888B444BBB00B888888B444444B0B88C
    CC8B4CCCC4B0B8C888CB4C44C4B0B8C8888B4C44C4B0B8C8888B4CCC44B0B8C8
    888B4C44C4B0B8C888CB4C44C4B0B88CCC8B4CCCC4B0B888888B444444B0B8BB
    BBBBBBBBB4B0BB00000B00000BB0B0000BBEBB0000B00000000B00000000FEFF
    0000F01F00008003000000010000000100000001000000010000000100000001
    0000000100000001000000010000000100003EF90000783D0000FEFF0000}
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pgMain: TPageControl
    Left = 4
    Top = 4
    Width = 584
    Height = 375
    ActivePage = tsServer
    TabOrder = 0
    object tsAccounts: TTabSheet
      Caption = 'Accounts'
      ImageIndex = 6
      object lblAccount: TLabel
        Left = 8
        Top = 8
        Width = 79
        Height = 13
        Caption = 'Account settings'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object bvlAccount: TBevel
        Left = 94
        Top = 15
        Width = 472
        Height = 2
        Shape = bsBottomLine
      end
      object lvAccounts: TListView
        Left = 16
        Top = 32
        Width = 549
        Height = 277
        Hint = 'Double click to edit.'
        Columns = <
          item
            Caption = 'Account Name'
            Width = 100
          end
          item
            Caption = 'Handle'
            Width = 100
          end
          item
            Caption = 'Password'
            Width = 100
          end
          item
            Caption = 'Server'
            Width = 100
          end
          item
            Caption = 'Port'
          end
          item
            Caption = 'Post Login Commands'
            Width = 200
          end>
        ColumnClick = False
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowHint = True
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = btnEditAccountClick
        OnSelectItem = lvAccountsSelectItem
      end
      object btnAddAccount: TButton
        Left = 332
        Top = 316
        Width = 75
        Height = 25
        Caption = '&Add...'
        TabOrder = 1
        OnClick = btnAddAccountClick
      end
      object btnEditAccount: TButton
        Left = 412
        Top = 316
        Width = 75
        Height = 25
        Caption = '&Edit...'
        Enabled = False
        TabOrder = 2
        OnClick = btnEditAccountClick
      end
      object btnDeleteAccount: TButton
        Left = 492
        Top = 316
        Width = 75
        Height = 25
        Caption = '&Delete'
        Enabled = False
        TabOrder = 3
        OnClick = btnDeleteAccountClick
      end
    end
    object tsBoard: TTabSheet
      Caption = 'Board'
      ImageIndex = -1
      object Label2: TLabel
        Left = 16
        Top = 204
        Width = 65
        Height = 13
        Caption = 'Select Pieces'
      end
      object SpeedButton1: TSpeedButton
        Tag = -1
        Left = 312
        Top = 198
        Width = 23
        Height = 22
        Caption = '<<'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = SpeedButton2Click
      end
      object SpeedButton2: TSpeedButton
        Tag = 1
        Left = 336
        Top = 198
        Width = 23
        Height = 22
        Caption = '>>'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = SpeedButton2Click
      end
      object pnlPieces: TPanel
        Left = 16
        Top = 224
        Width = 348
        Height = 116
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 12
        Top = 96
        Width = 141
        Height = 93
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object clLegal: TCLColorButton
          Left = 8
          Top = 31
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object lblLegal: TLabel
          Left = 38
          Top = 36
          Width = 87
          Height = 13
          Caption = 'Legal square color'
        end
        object clIllegal: TCLColorButton
          Left = 8
          Top = 59
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object lblIllegal: TLabel
          Left = 37
          Top = 60
          Width = 88
          Height = 13
          Caption = 'Illegal square color'
        end
        object chkMoveSquare: TCheckBox
          Left = 12
          Top = 8
          Width = 89
          Height = 17
          Caption = 'Move Square'
          TabOrder = 0
          OnClick = chkPremoveClick
        end
      end
      object Panel2: TPanel
        Left = 372
        Top = 248
        Width = 197
        Height = 93
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        object Label8: TLabel
          Left = 12
          Top = 8
          Width = 53
          Height = 13
          Caption = 'Move Style'
        end
        object clClick: TCLColorButton
          Left = 11
          Top = 55
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object lblClick: TLabel
          Left = 40
          Top = 56
          Width = 93
          Height = 13
          Caption = 'Click && Click square'
        end
        object cmbMoveStyle: TComboBox
          Left = 12
          Top = 24
          Width = 125
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cmbMoveStyleChange
          OnKeyDown = cmbMoveStyleKeyDown
          OnKeyPress = cmbMoveStyleKeyPress
          Items.Strings = (
            'Drag & Drop'
            'Click & Click')
        end
      end
      object Panel3: TPanel
        Left = 12
        Top = 4
        Width = 285
        Height = 89
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 3
        object chkShowCoordinates: TCheckBox
          Left = 12
          Top = 12
          Width = 135
          Height = 17
          Caption = 'Show &coordinates'
          TabOrder = 0
          OnClick = ControlChanged
        end
        object chkShowLegal: TCheckBox
          Left = 12
          Top = 36
          Width = 125
          Height = 17
          Caption = 'Show &legal moves'
          TabOrder = 1
          OnClick = ControlChanged
        end
        object chkShowArrows: TCheckBox
          Left = 148
          Top = 12
          Width = 128
          Height = 17
          Caption = 'Show &arrows && circles'
          TabOrder = 2
          OnClick = ControlChanged
        end
        object chkSmartMove: TCheckBox
          Left = 148
          Top = 36
          Width = 81
          Height = 17
          Caption = '&Smart move'
          TabOrder = 3
          OnClick = ControlChanged
        end
        object cbDrawBoardLines: TCheckBox
          Left = 148
          Top = 60
          Width = 97
          Height = 17
          Caption = 'Board Lines'
          TabOrder = 4
          OnClick = ControlChanged
        end
        object cmbLastMove: TComboBox
          Left = 12
          Top = 60
          Width = 125
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 5
          OnChange = ControlChanged
          Items.Strings = (
            'Last Move as Squares'
            'Last Move as Arrow'
            'Don'#39't Show Last Move')
        end
      end
      object Panel4: TPanel
        Left = 304
        Top = 4
        Width = 265
        Height = 89
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 4
        object cbHighLight: TCLColorButton
          Left = 12
          Top = 60
          Width = 22
          Height = 22
          Visible = False
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object lblHightLight: TLabel
          Left = 39
          Top = 64
          Width = 138
          Height = 13
          Caption = 'Highlight and arrows && circles'
          Visible = False
        end
        object cbGameClock: TCLColorButton
          Left = 12
          Top = 4
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label6: TLabel
          Left = 40
          Top = 8
          Width = 57
          Height = 13
          Caption = 'Game clock'
        end
        object cbLightPieces: TCLColorButton
          Left = 111
          Top = 4
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object lblLightPieces: TLabel
          Left = 144
          Top = 8
          Width = 57
          Height = 13
          Caption = 'Light pieces'
        end
        object cbDarkPieces: TCLColorButton
          Left = 111
          Top = 28
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object lblDarkPieces: TLabel
          Left = 144
          Top = 32
          Width = 57
          Height = 13
          Caption = 'Dark pieces'
        end
        object Label19: TLabel
          Left = 40
          Top = 32
          Width = 56
          Height = 13
          Caption = 'Board Lines'
        end
        object clBoardLines: TCLColorButton
          Left = 12
          Top = 28
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
      end
      object pnlSquareColor: TPanel
        Left = 160
        Top = 96
        Width = 409
        Height = 93
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 5
        object pnlPlainColor: TPanel
          Left = 2
          Top = 2
          Width = 148
          Height = 89
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 0
          object cbLightSquares: TCLColorButton
            Left = 8
            Top = 7
            Width = 22
            Height = 22
            OnClick = cbColorButtonClick
            AutoSize = False
            Border = 1
            BorderColor = clBtnFace
            ButtonColor = clBtnFace
            Down = False
            Enabled = True
            HighLightColor = clBtnHighlight
            ShadowColor = clBtnShadow
          end
          object lblDarkSquares: TLabel
            Left = 42
            Top = 40
            Width = 63
            Height = 13
            Caption = 'Dark squares'
          end
          object lblLightSquares: TLabel
            Left = 42
            Top = 12
            Width = 63
            Height = 13
            Caption = 'Light squares'
          end
          object cbDarkSquares: TCLColorButton
            Left = 8
            Top = 35
            Width = 22
            Height = 22
            OnClick = cbColorButtonClick
            AutoSize = False
            Border = 1
            BorderColor = clBtnFace
            ButtonColor = clBtnFace
            Down = False
            Enabled = True
            HighLightColor = clBtnHighlight
            ShadowColor = clBtnShadow
          end
        end
        object pnlThemeColor: TPanel
          Left = 150
          Top = 2
          Width = 148
          Height = 89
          Align = alLeft
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 1
          DesignSize = (
            148
            89)
          object imgSquare: TImage
            Left = 28
            Top = 36
            Width = 90
            Height = 45
            Anchors = [akLeft, akTop, akRight]
          end
          object cmbTheme: TComboBox
            Left = 8
            Top = 8
            Width = 133
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 0
            OnChange = cmbThemeChange
          end
        end
        object Panel12: TPanel
          Left = 298
          Top = 2
          Width = 109
          Height = 89
          Align = alClient
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 2
          object rbPlainColor: TRadioButton
            Left = 8
            Top = 8
            Width = 113
            Height = 17
            Caption = 'Plain Color'
            TabOrder = 0
            OnClick = rbPlainColorClick
          end
          object rbThemeColor: TRadioButton
            Left = 8
            Top = 32
            Width = 105
            Height = 17
            Caption = 'Theme Color'
            Checked = True
            TabOrder = 1
            TabStop = True
            OnClick = rbThemeColorClick
          end
        end
      end
    end
    object tsGame: TTabSheet
      Caption = 'Game'
      ImageIndex = 7
      object Panel5: TPanel
        Left = 148
        Top = 4
        Width = 257
        Height = 101
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object lblPGNOptions: TLabel
          Left = 8
          Top = 52
          Width = 142
          Height = 13
          Caption = 'Local &PGN file logging options'
          FocusControl = cmboLogGames
        end
        object chkQueen: TCheckBox
          Left = 8
          Top = 4
          Width = 81
          Height = 17
          Caption = 'Auto q&ueen'
          TabOrder = 0
          OnClick = ControlChanged
        end
        object chkShowCaptured: TCheckBox
          Left = 8
          Top = 28
          Width = 133
          Height = 17
          Caption = 'Show c&aptured pieces'
          TabOrder = 1
          OnClick = ControlChanged
        end
        object cmboLogGames: TComboBox
          Left = 8
          Top = 68
          Width = 237
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = ControlChanged
          Items.Strings = (
            'Log All Games I Play or Observe'
            'Log Only Games I Play'
            'Do Not Log Games')
        end
      end
      object Panel6: TPanel
        Left = 8
        Top = 4
        Width = 137
        Height = 101
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        object clPremove: TCLColorButton
          Left = 8
          Top = 72
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object lblPremove: TLabel
          Left = 36
          Top = 76
          Width = 77
          Height = 13
          Caption = 'Premove square'
        end
        object chkPremove: TCheckBox
          Left = 8
          Top = 4
          Width = 81
          Height = 17
          Caption = '&Premove'
          TabOrder = 0
          OnClick = chkPremoveClick
        end
        object cmbPremoveStyle: TComboBox
          Left = 8
          Top = 44
          Width = 117
          Height = 21
          ItemHeight = 13
          TabOrder = 1
          OnChange = cmbMoveStyleChange
          OnKeyDown = cmbMoveStyleKeyDown
          OnKeyPress = cmbMoveStyleKeyPress
          Items.Strings = (
            'Squares'
            'Arrow'
            'Squares & Arrow')
        end
        object chkAggressive: TCheckBox
          Left = 8
          Top = 24
          Width = 117
          Height = 17
          Caption = '&Aggressive premove'
          TabOrder = 2
          OnClick = ControlChanged
        end
      end
      object Panel13: TPanel
        Left = 8
        Top = 112
        Width = 397
        Height = 35
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        object Label29: TLabel
          Left = 350
          Top = 10
          Width = 17
          Height = 13
          Caption = 'sec'
        end
        object chkTimeEnding: TCheckBox
          Left = 6
          Top = 8
          Width = 271
          Height = 17
          Caption = 'Play "Time Ending" sound when you time is less then'
          TabOrder = 0
          OnClick = chkTimeEndingClick
        end
        object edtTimeEnding: TEdit
          Left = 280
          Top = 6
          Width = 51
          Height = 21
          TabOrder = 1
          Text = '1'
          OnChange = ControlChanged
        end
        object udTimeEnding: TUpDown
          Left = 331
          Top = 6
          Width = 15
          Height = 21
          Associate = edtTimeEnding
          Min = 1
          Max = 1000
          Position = 1
          TabOrder = 2
        end
      end
    end
    object tsCommands: TTabSheet
      Caption = 'Commands'
      ImageIndex = -1
      object lblUser: TLabel
        Left = 8
        Top = 8
        Width = 76
        Height = 13
        Caption = 'User commands'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object bvlUser: TBevel
        Left = 91
        Top = 15
        Width = 475
        Height = 2
        Shape = bsBottomLine
      end
      object lvCommands: TListView
        Left = 16
        Top = 32
        Width = 549
        Height = 277
        Hint = 'Double click to edit.'
        Columns = <
          item
            Caption = 'Menu Caption'
            Width = 200
          end
          item
            Caption = 'Sever Command'
            Width = 300
          end>
        ColumnClick = False
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = lvCommandsDblClick
        OnSelectItem = lvCommandsSelectItem
      end
      object btnMoveDown: TButton
        Tag = 1
        Left = 492
        Top = 316
        Width = 75
        Height = 25
        Caption = '&Move Down'
        Enabled = False
        TabOrder = 4
        OnClick = btnMoveClick
      end
      object btnMoveUp: TButton
        Tag = -1
        Left = 412
        Top = 316
        Width = 75
        Height = 25
        Caption = 'Move &Up'
        Enabled = False
        TabOrder = 3
        OnClick = btnMoveClick
      end
      object btnDeleteCommand: TButton
        Left = 332
        Top = 316
        Width = 75
        Height = 25
        Caption = '&Delete'
        Enabled = False
        TabOrder = 2
        OnClick = btnDeleteCommandClick
      end
      object btnAddCommand: TButton
        Left = 172
        Top = 316
        Width = 75
        Height = 25
        Caption = '&Add...'
        TabOrder = 1
        OnClick = btnAddCommandClick
      end
      object btnEditCommand: TButton
        Left = 252
        Top = 316
        Width = 75
        Height = 25
        Caption = '&Edit...'
        Enabled = False
        TabOrder = 5
        OnClick = btnEditCommandClick
      end
    end
    object tsGeneral: TTabSheet
      Caption = 'General'
      ImageIndex = -1
      object cbRemember: TCheckBox
        Left = 4
        Top = 316
        Width = 125
        Height = 17
        Caption = 'Remember Password'
        TabOrder = 0
        OnClick = ControlChanged
      end
      object Panel15: TPanel
        Left = 0
        Top = 2
        Width = 275
        Height = 99
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        DesignSize = (
          275
          99)
        object lblPGNLocation: TLabel
          Left = 6
          Top = 6
          Width = 152
          Height = 13
          Caption = 'Location of personal PGN library'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblPGNFile: TLabel
          Left = 6
          Top = 48
          Width = 151
          Height = 13
          Caption = 'PGN file name for saving games'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object edtPGNDirectory: TEdit
          Left = 6
          Top = 24
          Width = 235
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          OnChange = ControlChanged
        end
        object btnPGNDirectory: TButton
          Left = 246
          Top = 22
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 1
          OnClick = btnPGNDirectoryClick
        end
        object edtPGNFile: TEdit
          Left = 8
          Top = 66
          Width = 235
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 2
          OnChange = ControlChanged
        end
        object btnPGNFile: TButton
          Left = 248
          Top = 64
          Width = 21
          Height = 21
          Anchors = [akTop, akRight]
          Caption = '...'
          TabOrder = 3
          OnClick = btnPGNFileClick
        end
      end
      object Panel16: TPanel
        Left = 0
        Top = 104
        Width = 189
        Height = 117
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        object Label1: TLabel
          Left = 62
          Top = 4
          Width = 56
          Height = 13
          Caption = 'Player list'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label3: TLabel
          Left = 6
          Top = 28
          Width = 58
          Height = 13
          Caption = 'Rating Type'
        end
        object Label4: TLabel
          Left = 6
          Top = 68
          Width = 36
          Height = 13
          Caption = 'Sort by '
        end
        object Label5: TLabel
          Left = 106
          Top = 68
          Width = 42
          Height = 13
          Caption = 'Direction'
        end
        object cbRatingType: TComboBox
          Left = 6
          Top = 44
          Width = 173
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbOrdTypeChange
          OnKeyPress = cbRatingTypeKeyPress
          Items.Strings = (
            'Standard'
            'Blitz'
            'Bullet'
            'Crazy House'
            'Fisher Random'
            'Losers')
        end
        object cbOrdType: TComboBox
          Left = 6
          Top = 84
          Width = 97
          Height = 21
          ItemHeight = 13
          TabOrder = 1
          OnChange = cbOrdTypeChange
          OnKeyPress = cbRatingTypeKeyPress
          Items.Strings = (
            'Name'
            'Rating')
        end
        object cbOrdDirection: TComboBox
          Left = 104
          Top = 84
          Width = 77
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          OnChange = cbOrdTypeChange
          OnKeyPress = cbRatingTypeKeyPress
          Items.Strings = (
            'Forward'
            'Backward')
        end
      end
      object Panel17: TPanel
        Left = 282
        Top = 2
        Width = 289
        Height = 101
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 3
        object Label31: TLabel
          Left = 92
          Top = 6
          Width = 91
          Height = 13
          Caption = 'Announcements'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label32: TLabel
          Left = 8
          Top = 40
          Width = 130
          Height = 13
          Caption = 'New message blinks (times)'
        end
        object edAnnBlinkCount: TEdit
          Left = 144
          Top = 38
          Width = 61
          Height = 21
          TabOrder = 0
          Text = '0'
          OnChange = cbOrdTypeChange
        end
        object udAnnBlinkCount: TUpDown
          Left = 205
          Top = 38
          Width = 15
          Height = 21
          Associate = edAnnBlinkCount
          TabOrder = 1
        end
        object cbAnnAutoscroll: TCheckBox
          Left = 8
          Top = 64
          Width = 153
          Height = 17
          Caption = 'Autoscroll long messages'
          TabOrder = 2
          OnClick = cbOrdTypeChange
        end
      end
    end
    object tsSounds: TTabSheet
      Caption = 'Sounds'
      ImageIndex = -1
      object lblSound: TLabel
        Left = 8
        Top = 8
        Width = 66
        Height = 13
        Caption = 'Sound events'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object bvlSound: TBevel
        Left = 81
        Top = 15
        Width = 485
        Height = 2
        Shape = bsBottomLine
      end
      object btnClear: TButton
        Left = 492
        Top = 316
        Width = 75
        Height = 25
        Caption = '&Clear Wave'
        Enabled = False
        TabOrder = 1
        OnClick = btnClearClick
      end
      object btnBrowse: TButton
        Left = 412
        Top = 316
        Width = 75
        Height = 25
        Caption = '&Browse...'
        Enabled = False
        TabOrder = 0
        OnClick = btnBrowseClick
      end
      object chkMute: TCheckBox
        Left = 16
        Top = 316
        Width = 89
        Height = 17
        Caption = '&Mute sounds'
        TabOrder = 2
        OnClick = ControlChanged
      end
      object lvSoundEvents: TListView
        Left = 16
        Top = 32
        Width = 549
        Height = 277
        AllocBy = 15
        Columns = <
          item
            Caption = 'Event'
            Width = 100
          end
          item
            Caption = 'Wave File'
            Width = 270
          end>
        ColumnClick = False
        HideSelection = False
        Items.ItemData = {
          01880300001000000000000000FFFFFFFFFFFFFFFF0100000000000000094C00
          6F006700670065006400200049006E00044E006F006E00650000000000FFFFFF
          FFFFFFFFFF01000000000000000C44006900730063006F006E006E0065006300
          740065006400044E006F006E00650000000000FFFFFFFFFFFFFFFF0100000000
          0000000A4300680061006C006C0065006E00670065006400044E006F006E0065
          0000000000FFFFFFFFFFFFFFFF01000000000000000C470061006D0065002000
          5300740061007200740065006400044E006F006E00650000000000FFFFFFFFFF
          FFFFFF01000000000000000543006800650063006B00044E006F006E00650000
          000000FFFFFFFFFFFFFFFF01000000000000000D4F0066006600650072002000
          49006E002000470061006D006500044E006F006E00650000000000FFFFFFFFFF
          FFFFFF01000000000000000C49006C006C006500670061006C0020004D006F00
          76006500044E006F006E00650000000000FFFFFFFFFFFFFFFF01000000000000
          000A4C006500670061006C0020004D006F0076006500044E006F006E00650000
          000000FFFFFFFFFFFFFFFF01000000000000000B470061006D00650020005200
          6500730075006C007400044E006F006E00650000000000FFFFFFFFFFFFFFFF01
          000000000000000E50006500720073006F006E0061006C002000540065006C00
          6C007300044E006F006E00650000000000FFFFFFFFFFFFFFFF01000000000000
          000B4E006500770020004D00650073007300610067006500044E006F006E0065
          0000000000FFFFFFFFFFFFFFFF01000000000000000F49006E00760069007400
          65006400200074006F00200052006F006F006D00044E006F006E006500000000
          00FFFFFFFFFFFFFFFF01000000000000000E4E006F0074006900660079002000
          4100720072006900760065006400044E006F006E00650000000000FFFFFFFFFF
          FFFFFF01000000000000000F4E006F0074006900660079002000440065007000
          61007200740065006400044E006F006E00650000000000FFFFFFFFFFFFFFFF01
          000000000000000E50006C006100790065007200200041007200720069007600
          65006400044E006F006E00650000000000FFFFFFFFFFFFFFFF01000000000000
          000B540069006D006500200045006E00640069006E006700044E006F006E0065
          00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF}
        RowSelect = True
        TabOrder = 3
        ViewStyle = vsReport
        OnDblClick = lvSoundEventsDblClick
        OnEditing = lvSoundEventsEditing
        OnSelectItem = lvSoundEventsSelectItem
      end
    end
    object tsText: TTabSheet
      Caption = 'Text'
      ImageIndex = -1
      object lblText: TLabel
        Left = 8
        Top = 8
        Width = 100
        Height = 13
        Caption = 'Font, styles and color'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object bvlText: TBevel
        Left = 116
        Top = 15
        Width = 450
        Height = 2
        Shape = bsBottomLine
      end
      object lblBaseFont: TLabel
        Left = 16
        Top = 32
        Width = 48
        Height = 13
        Caption = '&Base font:'
        FocusControl = cbFontName
      end
      object lblAttributes: TLabel
        Left = 16
        Top = 76
        Width = 62
        Height = 13
        Caption = '&Attributes for:'
        FocusControl = lstText
      end
      object cbConsoleColor: TCLColorButton
        Left = 292
        Top = 48
        Width = 22
        Height = 22
        OnClick = cbColorButtonClick
        AutoSize = False
        Border = 1
        BorderColor = clBtnFace
        ButtonColor = clBtnFace
        Down = False
        Enabled = True
        HighLightColor = clBtnHighlight
        ShadowColor = clBtnShadow
      end
      object cbConsoleTextColor: TCLColorButton
        Left = 400
        Top = 48
        Width = 22
        Height = 22
        OnClick = cbColorButtonClick
        AutoSize = False
        Border = 1
        BorderColor = clBtnFace
        ButtonColor = clBtnFace
        Down = False
        Enabled = True
        HighLightColor = clBtnHighlight
        ShadowColor = clBtnShadow
      end
      object lbConsoleColor: TLabel
        Left = 320
        Top = 52
        Width = 64
        Height = 13
        Caption = 'Console color'
      end
      object lblConsoleTextColor: TLabel
        Left = 428
        Top = 52
        Width = 84
        Height = 13
        Caption = 'Console text color'
      end
      object chkBold: TCheckBox
        Left = 184
        Top = 208
        Width = 61
        Height = 17
        Caption = 'Bo&ld'
        TabOrder = 5
        OnClick = chkAttributeClick
      end
      object chkItalics: TCheckBox
        Left = 252
        Top = 208
        Width = 61
        Height = 17
        Caption = '&Italic'
        TabOrder = 6
        OnClick = chkAttributeClick
      end
      object cbFontName: TCLFontNamesCombo
        Left = 16
        Top = 48
        Width = 149
        Height = 20
        FontSizesCombo = cbFontSize
        FontName = 'Courier New'
        Options = [foAnsiOnly, foFixedPitchOnly]
        TabOrder = 0
        OnChange = cbFontNameChange
      end
      object cbFontSize: TCLFontSizesCombo
        Left = 172
        Top = 48
        Width = 61
        Height = 21
        FontName = 'Courier New'
        ItemHeight = 13
        TabOrder = 1
        Text = 'cbFontSize'
        OnChange = cbFontSizeChange
      end
      object btnFontColor: TButton
        Left = 16
        Top = 204
        Width = 75
        Height = 25
        Caption = 'F&ont Color...'
        TabOrder = 3
        OnClick = btnFontColorClick
      end
      object btnBackColor: TButton
        Left = 96
        Top = 204
        Width = 75
        Height = 25
        Caption = 'Ba&ck Color...'
        TabOrder = 4
        OnClick = btnBackColorClick
      end
      object lstText: TListBox
        Left = 16
        Top = 96
        Width = 545
        Height = 97
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        Items.Strings = (
          'Announcement from an Administrator'
          'Announcement that a friend has arrived'
          'Announcement that a friend has departed'
          'Communique from another player (Tell)'
          'Communique in a room (Room Tell)'
          'Communique from your opponent of a game (Say)'
          'Communique to all players and observers of a game (Kibitz)'
          'Communique only to observers of a game (Whisper)'
          'Messages'
          'Server message normal'
          'Server message warning'
          'Server message error'
          'Text you type')
        ParentFont = False
        TabOrder = 2
        OnClick = lstTextClick
      end
      object pnlSample: TPanel
        Left = 16
        Top = 240
        Width = 549
        Height = 93
        BevelOuter = bvLowered
        Caption = 'Sample Text'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
      end
      object chkUserColor: TCheckBox
        Left = 448
        Top = 208
        Width = 113
        Height = 17
        Caption = 'User colors in chat'
        Checked = True
        State = cbChecked
        TabOrder = 8
        OnClick = ControlChanged
      end
    end
    object tsServer: TTabSheet
      Caption = 'Server'
      ImageIndex = 6
      OnShow = tsServerShow
      object GroupBox3: TGroupBox
        Left = 4
        Top = 2
        Width = 245
        Height = 167
        Caption = 'Match and Seek General Options'
        TabOrder = 0
        object chkOPen: TCheckBox
          Left = 8
          Top = 16
          Width = 145
          Height = 17
          Caption = '&Open (for match requests)'
          TabOrder = 0
          OnClick = ControlChanged2
        end
        object chkRejectWhilePlaying: TCheckBox
          Left = 8
          Top = 34
          Width = 197
          Height = 17
          Caption = 'Reject match requests while playing'
          TabOrder = 1
          OnClick = ControlChanged2
        end
        object cbCReject: TCheckBox
          Left = 8
          Top = 52
          Width = 153
          Height = 17
          Caption = 'Reject Players with (C) title'
          TabOrder = 2
          OnClick = ControlChanged2
        end
        object cbPReject: TCheckBox
          Left = 8
          Top = 70
          Width = 205
          Height = 17
          Caption = 'Reject Players with provisional rating'
          TabOrder = 3
          OnClick = ControlChanged2
        end
        object chkRemove: TCheckBox
          Left = 8
          Top = 88
          Width = 233
          Height = 17
          Caption = 'Automatically remo&ve Match and Seek offers'
          TabOrder = 4
          OnClick = ControlChanged2
        end
        object chkBadLagRestrict: TCheckBox
          Left = 8
          Top = 106
          Width = 231
          Height = 17
          Caption = 'Don'#39't play if opponent'#39's lag more than 1000'
          TabOrder = 5
          OnClick = ControlChanged2
        end
        object chkLoseOnDisconnect: TCheckBox
          Left = 8
          Top = 124
          Width = 229
          Height = 17
          Caption = 'Players forfeit on disconnect'
          TabOrder = 6
          OnClick = ControlChanged2
        end
        object chkSeekWhilePlaying: TCheckBox
          Left = 8
          Top = 142
          Width = 229
          Height = 17
          Caption = 'Allow seek while playing'
          TabOrder = 7
          OnClick = ControlChanged2
        end
      end
      object GroupBox4: TGroupBox
        Left = 4
        Top = 174
        Width = 571
        Height = 171
        Caption = 'Match and Seek Default Settings'
        TabOrder = 1
        DesignSize = (
          571
          171)
        object lblInital: TLabel
          Left = 8
          Top = 20
          Width = 87
          Height = 13
          Caption = '&Initial game time of'
          FocusControl = edtInitial
        end
        object lblPlus: TLabel
          Left = 230
          Top = 20
          Width = 19
          Height = 13
          Caption = 'plus'
        end
        object lblInc: TLabel
          Left = 308
          Top = 20
          Width = 87
          Height = 13
          Caption = 'seconds per move'
          FocusControl = edtInc
        end
        object lblStyle: TLabel
          Left = 8
          Top = 48
          Width = 96
          Height = 13
          Caption = '&Style of game will be'
          FocusControl = cbGameType
        end
        object lblRated: TLabel
          Left = 8
          Top = 72
          Width = 60
          Height = 13
          Caption = 'Game will be'
        end
        object lblColor: TLabel
          Left = 10
          Top = 96
          Width = 72
          Height = 13
          Caption = 'My color will be'
        end
        object lblMin: TLabel
          Left = 10
          Top = 120
          Width = 133
          Height = 13
          Caption = '&Minimum rating of opponent '
          FocusControl = edtMin
        end
        object lblMax: TLabel
          Left = 10
          Top = 144
          Width = 131
          Height = 13
          Caption = 'Ma&ximun rating of opponent'
          FocusControl = edtMax
        end
        object edtInitial: TEdit
          Left = 116
          Top = 16
          Width = 33
          Height = 21
          MaxLength = 3
          TabOrder = 0
          Text = '20'
          OnChange = ControlChanged2
        end
        object udInitial: TUpDown
          Left = 149
          Top = 16
          Width = 16
          Height = 21
          Max = 999
          Position = 20
          TabOrder = 1
          Thousands = False
        end
        object cbDimension: TComboBox
          Left = 164
          Top = 16
          Width = 61
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          Items.Strings = (
            'minutes'
            'seconds')
        end
        object edtInc: TEdit
          Left = 256
          Top = 16
          Width = 33
          Height = 21
          MaxLength = 3
          TabOrder = 3
          Text = '0'
          OnChange = ControlChanged2
        end
        object cbGameType: TComboBox
          Left = 116
          Top = 44
          Width = 168
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
          OnClick = ControlChanged2
          Items.Strings = (
            'Normal'
            'Crazy House'
            'Fischer Random'
            'Loser'#39's')
        end
        object edtMin: TEdit
          Left = 146
          Top = 116
          Width = 33
          Height = 21
          MaxLength = 5
          TabOrder = 5
          Text = '0'
          OnChange = ControlChanged2
        end
        object udMin: TUpDown
          Left = 179
          Top = 116
          Width = 16
          Height = 21
          Max = 9999
          Increment = 50
          TabOrder = 6
          Thousands = False
        end
        object edtMax: TEdit
          Left = 146
          Top = 140
          Width = 33
          Height = 21
          MaxLength = 5
          TabOrder = 7
          Text = '0'
          OnChange = ControlChanged2
        end
        object udMax: TUpDown
          Left = 179
          Top = 140
          Width = 16
          Height = 21
          Max = 9999
          Increment = 50
          TabOrder = 8
          Thousands = False
        end
        object pnlRated: TPanel
          Left = 92
          Top = 72
          Width = 143
          Height = 17
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 9
          object rbRated: TRadioButton
            Tag = 1
            Left = 0
            Top = 0
            Width = 65
            Height = 17
            Caption = '&Rated'
            TabOrder = 0
            OnClick = rbRatedClick
          end
          object rbUnrated: TRadioButton
            Left = 78
            Top = 0
            Width = 65
            Height = 17
            Caption = '&Unrated'
            TabOrder = 1
            OnClick = rbRatedClick
          end
        end
        object pnlColor: TPanel
          Left = 92
          Top = 92
          Width = 238
          Height = 17
          AutoSize = True
          BevelOuter = bvNone
          TabOrder = 10
          object rbWhite: TRadioButton
            Tag = 1
            Left = 0
            Top = 0
            Width = 65
            Height = 17
            Caption = '&White'
            TabOrder = 0
            OnClick = ControlChanged2
          end
          object rbBlack: TRadioButton
            Tag = -1
            Left = 58
            Top = 0
            Width = 65
            Height = 17
            Caption = '&Black'
            TabOrder = 1
            OnClick = ControlChanged2
          end
          object rbServer: TRadioButton
            Left = 108
            Top = 0
            Width = 130
            Height = 17
            Caption = '&Decided by the server'
            TabOrder = 2
            OnClick = ControlChanged2
          end
        end
        object udInc: TUpDown
          Left = 289
          Top = 16
          Width = 16
          Height = 21
          Max = 999
          TabOrder = 11
          Thousands = False
        end
        object Panel18: TPanel
          Left = 356
          Top = 72
          Width = 211
          Height = 93
          Anchors = [akRight, akBottom]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          TabOrder = 12
          object lblMinAutoMatch: TLabel
            Left = 8
            Top = 38
            Width = 141
            Height = 13
            Caption = 'Minimum rating for auto match'
            FocusControl = edtMinAutoMatch
          end
          object lblMaxAutoMatch: TLabel
            Left = 8
            Top = 62
            Width = 142
            Height = 13
            Caption = 'Ma&ximun rating for auto match'
            FocusControl = edtMaxAutoMatch
          end
          object edtMinAutoMatch: TEdit
            Left = 156
            Top = 34
            Width = 33
            Height = 21
            MaxLength = 5
            TabOrder = 0
            Text = '0'
            OnChange = ControlChanged2
          end
          object udMinAutoMatch: TUpDown
            Left = 189
            Top = 34
            Width = 15
            Height = 21
            Associate = edtMinAutoMatch
            Max = 9999
            Increment = 50
            TabOrder = 1
            Thousands = False
          end
          object edtMaxAutoMatch: TEdit
            Left = 156
            Top = 60
            Width = 33
            Height = 21
            MaxLength = 5
            TabOrder = 2
            Text = '0'
            OnChange = ControlChanged2
          end
          object udMaxAutoMatch: TUpDown
            Left = 189
            Top = 60
            Width = 15
            Height = 21
            Associate = edtMaxAutoMatch
            Max = 9999
            Increment = 50
            TabOrder = 3
            Thousands = False
          end
          object chkAutoMatch: TCheckBox
            Left = 8
            Top = 10
            Width = 157
            Height = 17
            Caption = 'Auto match the same seeks'
            TabOrder = 4
            OnClick = chkAutoMatchClick
          end
        end
      end
      object GroupBox7: TGroupBox
        Left = 255
        Top = 1
        Width = 321
        Height = 167
        Caption = 'Other Options'
        TabOrder = 2
        object chkTourShoutsEveryRound: TCheckBox
          Left = 8
          Top = 20
          Width = 307
          Height = 17
          Caption = 'See Tournament Shouts after Every Round'
          TabOrder = 0
          OnClick = ControlChanged2
        end
        object chkBusyStatus: TCheckBox
          Left = 8
          Top = 40
          Width = 307
          Height = 17
          Caption = 'Don'#39't get chat messages while playing'
          TabOrder = 1
          OnClick = ControlChanged2
        end
        object cbShout: TCheckBox
          Left = 8
          Top = 60
          Width = 97
          Height = 17
          Caption = 'Shouts enabled'
          TabOrder = 2
          OnClick = ControlChanged
        end
        object chkShoutDuringGame: TCheckBox
          Left = 8
          Top = 80
          Width = 117
          Height = 17
          Caption = 'Shouts during game'
          TabOrder = 3
          OnClick = ControlChanged
        end
        object chkAutoFlag: TCheckBox
          Left = 8
          Top = 100
          Width = 65
          Height = 17
          Caption = '&Autoflag'
          TabOrder = 4
          OnClick = ControlChanged2
        end
      end
    end
    object tsColor: TTabSheet
      Caption = 'Environment'
      ImageIndex = 8
      object Label34: TLabel
        Left = 0
        Top = 244
        Width = 65
        Height = 13
        Caption = 'Color Themes'
      end
      object Panel7: TPanel
        Left = 124
        Top = 8
        Width = 153
        Height = 145
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object clFrames: TCLColorButton
          Left = 8
          Top = 8
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label7: TLabel
          Left = 38
          Top = 12
          Width = 60
          Height = 13
          Caption = 'Frames color'
        end
        object clNotify: TCLColorButton
          Left = 8
          Top = 32
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label9: TLabel
          Left = 38
          Top = 36
          Width = 53
          Height = 13
          Caption = 'Notify color'
        end
        object clDefaultBackground: TCLColorButton
          Left = 8
          Top = 88
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label10: TLabel
          Left = 39
          Top = 92
          Width = 94
          Height = 13
          Caption = 'Default background'
        end
        object clBoardBackground: TCLColorButton
          Left = 8
          Top = 112
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label11: TLabel
          Left = 40
          Top = 116
          Width = 86
          Height = 13
          Caption = 'BoardBackground'
        end
        object clEvent: TCLColorButton
          Left = 8
          Top = 56
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label20: TLabel
          Left = 38
          Top = 60
          Width = 54
          Height = 13
          Caption = 'Event color'
        end
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 4
        Width = 117
        Height = 233
        Caption = 'Seek Colors '
        TabOrder = 1
        object clBullet: TCLColorButton
          Left = 8
          Top = 24
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label12: TLabel
          Left = 38
          Top = 28
          Width = 26
          Height = 13
          Caption = 'Bullet'
        end
        object clBlitz: TCLColorButton
          Left = 8
          Top = 48
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label13: TLabel
          Left = 38
          Top = 52
          Width = 19
          Height = 13
          Caption = 'Blitz'
        end
        object clStandard: TCLColorButton
          Left = 8
          Top = 72
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label14: TLabel
          Left = 38
          Top = 76
          Width = 43
          Height = 13
          Caption = 'Standard'
        end
        object clLoosers: TCLColorButton
          Left = 8
          Top = 96
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label15: TLabel
          Left = 38
          Top = 100
          Width = 31
          Height = 13
          Caption = 'Losers'
        end
        object clFisher: TCLColorButton
          Left = 8
          Top = 120
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label16: TLabel
          Left = 38
          Top = 124
          Width = 28
          Height = 13
          Caption = 'Fisher'
        end
        object clCrazy: TCLColorButton
          Left = 8
          Top = 144
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label17: TLabel
          Left = 38
          Top = 148
          Width = 60
          Height = 13
          Caption = 'Crazy House'
        end
        object clTitleC: TCLColorButton
          Left = 8
          Top = 184
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label18: TLabel
          Left = 38
          Top = 188
          Width = 67
          Height = 13
          Caption = 'Title (C) seeks'
        end
      end
      object Panel8: TPanel
        Left = 4
        Top = 316
        Width = 117
        Height = 25
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        object SpeedButton3: TSpeedButton
          Left = 0
          Top = 0
          Width = 117
          Height = 25
          AllowAllUp = True
          Caption = 'Load Defaults'
          Flat = True
          OnClick = SpeedButton3Click
        end
      end
      object GroupBox2: TGroupBox
        Left = 124
        Top = 156
        Width = 153
        Height = 81
        Caption = 'Simul'
        TabOrder = 3
        object clSimulCurrentGame: TCLColorButton
          Left = 8
          Top = 24
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label21: TLabel
          Left = 38
          Top = 28
          Width = 101
          Height = 13
          Caption = 'Current Game Marker'
        end
        object clSimulLeaderGame: TCLColorButton
          Left = 8
          Top = 48
          Width = 22
          Height = 22
          OnClick = cbColorButtonClick
          AutoSize = False
          Border = 1
          BorderColor = clBtnFace
          ButtonColor = clBtnFace
          Down = False
          Enabled = True
          HighLightColor = clBtnHighlight
          ShadowColor = clBtnShadow
        end
        object Label22: TLabel
          Left = 38
          Top = 52
          Width = 100
          Height = 13
          Caption = 'Leader Game Marker'
        end
      end
      object reColors: TRichEdit
        Left = 284
        Top = 6
        Width = 283
        Height = 231
        TabOrder = 4
      end
      object btnShowColors: TBitBtn
        Left = 492
        Top = 242
        Width = 75
        Height = 25
        Caption = 'Show colors'
        TabOrder = 5
        OnClick = btnShowColorsClick
      end
      object cmbColorSchema: TComboBox
        Left = 0
        Top = 262
        Width = 163
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 6
        OnChange = cmbColorSchemaChange
        Items.Strings = (
          'Custom'
          'Light Grey'
          'Warm Sunny'
          'Cold Winter')
      end
    end
    object tbPrivate: TTabSheet
      Caption = 'Profile'
      ImageIndex = 9
      object Panel9: TPanel
        Left = 2
        Top = 0
        Width = 291
        Height = 191
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object lblEmail: TLabel
          Left = 12
          Top = 12
          Width = 25
          Height = 13
          Caption = 'Email'
        end
        object Label23: TLabel
          Left = 14
          Top = 54
          Width = 36
          Height = 13
          Caption = 'Country'
        end
        object Label24: TLabel
          Left = 30
          Top = 114
          Width = 18
          Height = 13
          Caption = 'Sex'
        end
        object Label25: TLabel
          Left = 234
          Top = 143
          Width = 22
          Height = 13
          Caption = 'Age:'
        end
        object Label33: TLabel
          Left = 4
          Top = 84
          Width = 48
          Height = 13
          Caption = 'Language'
        end
        object lblAge: TLabel
          Left = 258
          Top = 144
          Width = 17
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label35: TLabel
          Left = 12
          Top = 142
          Width = 38
          Height = 13
          Caption = 'Birthday'
        end
        object edtEmail: TEdit
          Left = 56
          Top = 8
          Width = 100
          Height = 21
          MaxLength = 100
          TabOrder = 0
          OnChange = ControlChanged2
        end
        object cbCountry: TComboBox
          Left = 58
          Top = 50
          Width = 165
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
          OnChange = ControlChanged2
          Items.Strings = (
            'Afghanistan'
            'Albania'
            'Algeria'
            'American Samoa'
            'Andorra'
            'Angola'
            'Anguilla'
            'Antarctica'
            'Antigua and Barbuda'
            'Argentina'
            'Armenia'
            'Aruba'
            'Asia '
            'Australia'
            'Austria'
            'Azerbaijan'
            'Bahamas'
            'Bahrain'
            'Bangladesh'
            'Barbados'
            'Belarus'
            'Belgium'
            'Belize'
            'Benin'
            'Bermuda'
            'Bhutan'
            'Bolivia'
            'Bosnia and Herzegowina'
            'Botswana'
            'Bouvet Island'
            'Brazil'
            'British Indian Ocean Territory'
            'British Virgin Islands'
            'Brunei Darussalam'
            'Bulgaria'
            'Burkina Faso'
            'Burundi'
            'Cambodia'
            'Cameroon'
            'Canada'
            'Cape Verde'
            'Cayman Islands'
            'Central African Republic'
            'Chad'
            'Chile'
            'China'
            'Christmas Island'
            'Cocos (keeling) Islands'
            'Colombia'
            'Comoros'
            'Congo'
            'Congo - the Democratic Rep of'
            'Cook Islands'
            'Costa Rica'
            'Cote Ivoire'
            'Croatia'
            'Cuba'
            'Cyprus'
            'Czech Republic'
            'Denmark'
            'Djibouti'
            'Dominica'
            'Dominican Republic'
            'East Timor'
            'Ecuador'
            'Egypt'
            'El Salvador'
            'Equatorial Guinea'
            'Eritrea'
            'Estonia'
            'Ethiopia'
            'Europe'
            'Falkland Islands'
            'Faroe Islands'
            'Fiji'
            'Finland'
            'France'
            'French Guiana'
            'French Polynesia'
            'French Southern Territories'
            'Gabon'
            'Gambia'
            'Georgia'
            'Germany'
            'Ghana'
            'Gibraltar'
            'Greece'
            'Greenland'
            'Grenada'
            'Guadeloupe'
            'Guam'
            'Guatemala'
            'Guinea'
            'Guinea-Bissau'
            'Guyana'
            'Haiti'
            'Heard and Mcdonald Islands'
            'Holy See (Vatican City State'
            'Honduras'
            'Hong Kong'
            'Hungary'
            'Iceland'
            'India'
            'Indonesia'
            'Invalid'
            'Iran'
            'Iraq'
            'Ireland'
            'Israel'
            'Italy'
            'Jamaica'
            'Japan'
            'Jordan'
            'Kazakhstan'
            'Kenya'
            'Kiribati'
            'Korea - North'
            'Korea - South'
            'Kuwait'
            'Kyrgyzstan'
            'Lao'
            'Latvia'
            'Lebanon'
            'Lesotho'
            'Liberia'
            'Libyan Arab Jamahiriya'
            'Liechtenstein'
            'Lithuania'
            'Luxembourg'
            'Macau'
            'Macedonia'
            'Madagascar'
            'Malawi'
            'Malaysia'
            'Maldives'
            'Mali'
            'Marshall Islands'
            'Martinique'
            'Mauritania'
            'Mauritius'
            'Mayotte'
            'Mexico'
            'Micronesia'
            'Moldova'
            'Monaco'
            'Mongolia'
            'Montserrat'
            'Morocco'
            'Mozambique'
            'Myanmar'
            'Namibia'
            'Nauru'
            'Nepal'
            'Netherlands'
            'Netherlands Antilles'
            'New Caledonia'
            'New Zealand'
            'Nicaragua'
            'Niger'
            'Nigeria'
            'Niue'
            'Norfolk Island'
            'Northern Mariana Islands'
            'Norway'
            'Oman'
            'Pakistan'
            'Palau'
            'Palestinian territories'
            'Panama'
            'Papua New Guinea'
            'Paraguay'
            'Peru'
            'Philippines'
            'Pitcairn'
            'Poland'
            'Portugal'
            'Puerto Rico'
            'Qatar'
            'Reunion'
            'Romania'
            'Russian Federation'
            'Rwanda'
            'Saint Kitts and Nevis'
            'Saint Lucia'
            'Saint Vincent'
            'Samoa'
            'San Marino'
            'Sao Tome'
            'Saudi Arabia'
            'Senegal'
            'Seychelles'
            'Sierra Leone'
            'Singapore'
            'Slovakia'
            'Slovenia'
            'Solomon Islands'
            'Somalia'
            'South Africa'
            'South Georgia'
            'Spain'
            'Sri Lanka'
            'St. Helena'
            'St. Pierre and Miquelon'
            'Sudan'
            'Suriname'
            'Svalbard Islands'
            'Swaziland'
            'Sweden'
            'Switzerland'
            'Syrian Arab Republic'
            'Taiwan - Province of China'
            'Tajikistan'
            'Tanzania'
            'Thailand'
            'Togo'
            'Tokelau'
            'Tonga'
            'Trinidad and Tobago'
            'Tunisia'
            'Turkey'
            'Turkmenistan'
            'Turks and Caicos Islands'
            'Tuvalu'
            'Uganda'
            'Ukraine'
            'United Arab Emirates'
            'United Kingdom'
            'United States'
            'Uruguay'
            'Us Minor Outlying Islands'
            'Us Virgin Islands'
            'Uzbekistan'
            'Vanuatu'
            'Venezuela'
            'Vietnam'
            'Wallis and Futuna Islands'
            'Western Sahara'
            'Yemen'
            'Yugoslavia'
            'Zambia'
            'Zimbabwe')
        end
        object cbSex: TComboBox
          Left = 58
          Top = 110
          Width = 93
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = ControlChanged2
          Items.Strings = (
            'Male'
            'Female')
        end
        object chkPublicEmail: TCheckBox
          Left = 40
          Top = 30
          Width = 117
          Height = 17
          Caption = 'Show email in profile'
          Checked = True
          State = cbChecked
          TabOrder = 3
          OnClick = ControlChanged2
        end
        object cbLanguage: TComboBox
          Left = 58
          Top = 80
          Width = 165
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 4
          OnChange = ControlChanged2
          Items.Strings = (
            'Arabic'
            'Bengali'
            'Bulgarian'
            'Cambodian'
            'Cantonese'
            'Chinese'
            'Croatian'
            'Czech'
            'Danish'
            'Dutch'
            'English'
            'Farsi'
            'Finnish'
            'French'
            'German'
            'Greek'
            'Gujarati'
            'Hebrew'
            'Hindi'
            'Hungarian'
            'Indonesian'
            'Italian'
            'Japanese'
            'Korean'
            'Latin'
            'Malayalam'
            'Marathi'
            'Norwegian'
            'Persian'
            'Polish'
            'Portuguese'
            'Punjabi'
            'Russian'
            'Serbian'
            'Spanish'
            'Swedish'
            'Tagalog'
            'Tamil'
            'Telugu'
            'Thai'
            'Ukrainian'
            'Urdu'
            'Vietnamese')
        end
        object cbShowBirthday: TCheckBox
          Left = 40
          Top = 166
          Width = 133
          Height = 17
          Caption = 'Show birthday in profile'
          Checked = True
          State = cbChecked
          TabOrder = 5
          OnClick = ControlChanged2
        end
        object cmbDay: TComboBox
          Left = 140
          Top = 140
          Width = 39
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 6
          OnChange = cmbMonthChange
        end
        object cmbMonth: TComboBox
          Left = 58
          Top = 140
          Width = 81
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 7
          OnChange = cmbMonthChange
          Items.Strings = (
            'January'
            'February'
            'March'
            'April'
            'May'
            'June'
            'July'
            'August'
            'September'
            'October'
            'November'
            'December')
        end
        object cmbYear: TComboBox
          Left = 180
          Top = 140
          Width = 50
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 8
          OnChange = cmbMonthChange
        end
      end
      object Panel10: TPanel
        Left = 298
        Top = 4
        Width = 105
        Height = 165
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 1
        DesignSize = (
          105
          165)
        object Label26: TLabel
          Left = 2
          Top = 142
          Width = 101
          Height = 13
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '96x96'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object btnPhoto: TBitBtn
          Left = 20
          Top = 108
          Width = 64
          Height = 25
          Caption = 'Photo'
          TabOrder = 0
          OnClick = btnPhotoClick
        end
        object pnlPhoto: TPanel
          Left = 4
          Top = 4
          Width = 96
          Height = 96
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Caption = 'NO PHOTO'
          TabOrder = 1
          object imgPhoto: TImage
            Left = 2
            Top = 2
            Width = 92
            Height = 92
            Align = alClient
          end
        end
      end
      object Panel14: TPanel
        Left = 4
        Top = 194
        Width = 335
        Height = 91
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 2
        DesignSize = (
          335
          91)
        object Label30: TLabel
          Left = 4
          Top = 4
          Width = 28
          Height = 13
          Caption = 'Notes'
        end
        object lblBanNotes: TLabel
          Left = 56
          Top = 4
          Width = 272
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'You are banned and cannot edit notes in profile'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object reNotes: TRichEdit
          Left = 4
          Top = 20
          Width = 325
          Height = 65
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 0
          OnChange = reNotesChange
        end
      end
      object Panel11: TPanel
        Left = 4
        Top = 286
        Width = 141
        Height = 25
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 3
        object btnPassword: TSpeedButton
          Left = 0
          Top = 0
          Width = 141
          Height = 25
          AllowAllUp = True
          Caption = 'Change Password'
          Flat = True
          OnClick = btnPasswordClick
        end
      end
      object chkPhotoChat: TGroupBox
        Left = 408
        Top = 0
        Width = 153
        Height = 113
        Caption = 'Photo Options'
        TabOrder = 4
        object chkPhotoPlayerList: TCheckBox
          Left = 8
          Top = 20
          Width = 129
          Height = 17
          Caption = 'Photo in Player List'
          TabOrder = 0
          OnClick = ControlChanged
        end
        object chkPhotoTournament: TCheckBox
          Left = 8
          Top = 60
          Width = 129
          Height = 17
          Caption = 'Photo in Tournaments'
          TabOrder = 1
          OnClick = ControlChanged
        end
        object chkPhotoGame: TCheckBox
          Left = 8
          Top = 40
          Width = 129
          Height = 17
          Caption = 'Photo in Game Screen'
          TabOrder = 2
          OnClick = ControlChanged
        end
      end
    end
    object tsMultimedia: TTabSheet
      Caption = 'Multimedia'
      ImageIndex = 10
      TabVisible = False
      DesignSize = (
        576
        347)
      object GroupBox6: TGroupBox
        Left = 164
        Top = 4
        Width = 409
        Height = 113
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Video and Audio'
        TabOrder = 0
        DesignSize = (
          409
          113)
        object Label27: TLabel
          Left = 8
          Top = 20
          Width = 91
          Height = 13
          Caption = 'Video Input Device'
        end
        object Label28: TLabel
          Left = 8
          Top = 64
          Width = 91
          Height = 13
          Caption = 'Video Input Device'
        end
        object cmbVideoDevices: TComboBox
          Left = 8
          Top = 36
          Width = 395
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
          OnChange = ControlChanged
        end
        object cmbAudioDevices: TComboBox
          Left = 8
          Top = 80
          Width = 395
          Height = 21
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 1
          OnChange = ControlChanged
        end
      end
    end
  end
  object btnOK: TButton
    Left = 352
    Top = 384
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 432
    Top = 384
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnApply: TButton
    Left = 512
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Apply'
    Enabled = False
    TabOrder = 3
    OnClick = btnApplyClick
  end
  object ColorDialog1: TColorDialog
    Options = [cdSolidColor]
    Left = 12
    Top = 384
  end
  object OpenDialog1: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 42
    Top = 384
  end
  object odPhoto: TOpenDialog
    Filter = 'BMP files|*.bmp|JPEG files|*.jpg'
    FilterIndex = 2
    Left = 72
    Top = 384
  end
end

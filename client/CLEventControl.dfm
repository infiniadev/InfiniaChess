object fCLEventControl: TfCLEventControl
  Tag = -1
  Left = 754
  Top = 242
  BorderStyle = bsNone
  Caption = 'fCLEvents'
  ClientHeight = 539
  ClientWidth = 223
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClick = FormClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tb: TTabControl
    Left = 0
    Top = 517
    Width = 223
    Height = 22
    Align = alBottom
    TabOrder = 0
    TabPosition = tpBottom
    Tabs.Strings = (
      'Games'
      'Finished')
    TabIndex = 0
    OnChange = tbChange
  end
  object pnlGames: TPanel
    Left = 0
    Top = 88
    Width = 105
    Height = 57
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    OnDblClick = pnlGamesDblClick
    OnResize = pnlGamesResize
    object pnlMyLocation: TPanel
      Left = 8
      Top = 8
      Width = 41
      Height = 41
      BevelOuter = bvNone
      Color = clLime
      TabOrder = 0
      Visible = False
    end
    object pnlLeaderLocation: TPanel
      Left = 52
      Top = 8
      Width = 41
      Height = 41
      BevelOuter = bvNone
      Color = clBlue
      TabOrder = 1
      Visible = False
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 479
    Width = 223
    Height = 38
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 2
    object tbButtons: TToolBar
      Left = 2
      Top = 0
      Width = 217
      Height = 31
      Align = alNone
      AutoSize = True
      ButtonHeight = 31
      ButtonWidth = 31
      Caption = 'tbButtons'
      Images = fCLMain.ilMain24
      TabOrder = 0
      Wrapable = False
      object tbSwitchMode: TToolButton
        Left = 0
        Top = 0
        Caption = 'tbSwitchMode'
        DropdownMenu = pmSwitch
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = tbSwitchModeClick
      end
      object tbPause: TToolButton
        Left = 31
        Top = 0
        Caption = 'tbPause'
        ImageIndex = 10
        OnClick = tbPauseClick
      end
      object tbFollow: TToolButton
        Left = 62
        Top = 0
        Hint = 'Follow Leader'
        AllowAllUp = True
        Caption = 'tbFollow'
        ImageIndex = 4
        Style = tbsCheck
      end
      object tbRotate: TToolButton
        Left = 93
        Top = 0
        Hint = 'Autorotate'
        AllowAllUp = True
        Caption = 'tbRotate'
        Down = True
        ImageIndex = 5
        Style = tbsCheck
      end
      object tbStandings: TToolButton
        Left = 124
        Top = 0
        Hint = 'Standings'
        Caption = 'tbStandings'
        ImageIndex = 11
        ParentShowHint = False
        ShowHint = True
        OnClick = tbStandingsClick
      end
      object tbMyGame: TToolButton
        Left = 155
        Top = 0
        Hint = 'My Game'
        Caption = 'tbMyGame'
        ImageIndex = 12
        ParentShowHint = False
        ShowHint = True
        OnClick = tbMyGameClick
      end
      object tbAbortGame: TToolButton
        Left = 186
        Top = 0
        Hint = 'Abort current game'
        Caption = 'tbAbortGame'
        ImageIndex = 13
        ParentShowHint = False
        ShowHint = True
        OnClick = tbAbortGameClick
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 18
    Width = 223
    Height = 70
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    OnClick = FormClick
    DesignSize = (
      223
      70)
    object lblLeader: TLabel
      Left = 4
      Top = 4
      Width = 53
      Height = 13
      Caption = 'lblLeader'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTimeControl: TLabel
      Left = 145
      Top = 4
      Width = 72
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Time Control'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblScoreCaption: TLabel
      Left = 4
      Top = 24
      Width = 112
      Height = 13
      Caption = 'Current Score (W/L/D):'
    end
    object lblScore: TLabel
      Left = 120
      Top = 24
      Width = 41
      Height = 13
      Caption = 'W/L/D'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblGamesCaption: TLabel
      Left = 4
      Top = 44
      Width = 73
      Height = 13
      Caption = 'Playing Games:'
    end
    object lblGames: TLabel
      Left = 80
      Top = 44
      Width = 52
      Height = 13
      Caption = 'lblGames'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object imgUserState: TImage
      Left = 190
      Top = 36
      Width = 24
      Height = 24
      Anchors = [akTop, akRight]
      PopupMenu = pmJoin
    end
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 223
    Height = 18
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 4
    DesignSize = (
      223
      18)
    object lblNotify: TLabel
      Left = 4
      Top = 2
      Width = 94
      Height = 13
      Caption = 'Event Control Panel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object sbClose: TSpeedButton
      Left = 206
      Top = 1
      Width = 16
      Height = 16
      Hint = 'Close'
      Anchors = [akTop, akRight]
      Flat = True
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
      OnClick = sbCloseClick
    end
  end
  object pnlQueue: TPanel
    Left = 0
    Top = 148
    Width = 173
    Height = 53
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 5
    OnClick = FormClick
    DesignSize = (
      173
      53)
    object Label1: TLabel
      Left = 4
      Top = 8
      Width = 37
      Height = 13
      Caption = 'Current:'
    end
    object lblCurrentGame: TLabel
      Left = 44
      Top = 8
      Width = 55
      Height = 13
      Caption = 'lblCurrent'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblRating: TLabel
      Left = 116
      Top = 8
      Width = 51
      Height = 13
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'lblRating'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lvQueue: TListView
      Left = 2
      Top = 28
      Width = 169
      Height = 23
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <
        item
          Caption = 'Login'
          Width = 100
        end
        item
          Caption = 'Rating'
          Width = 40
        end>
      RowSelect = True
      ParentColor = True
      ShowColumnHeaders = False
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = FormClick
    end
  end
  object pnlFinished: TPanel
    Left = 0
    Top = 204
    Width = 173
    Height = 57
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 6
    OnClick = FormClick
    object lvFinished: TListView
      Left = 2
      Top = 2
      Width = 169
      Height = 53
      Align = alClient
      Columns = <
        item
          Caption = 'Login'
          Width = 100
        end
        item
          Caption = 'Rating'
          Width = 40
        end
        item
          Caption = 'Result'
        end
        item
          Caption = 'GameNum'
          Width = 0
        end>
      GridLines = True
      RowSelect = True
      ParentColor = True
      ShowColumnHeaders = False
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = FormClick
      OnSelectItem = lvFinishedSelectItem
    end
  end
  object pnlKing: TPanel
    Left = 0
    Top = 264
    Width = 173
    Height = 81
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 7
    OnClick = FormClick
    object lvKingQueue: TListView
      Left = 2
      Top = 61
      Width = 169
      Height = 18
      Align = alClient
      Columns = <
        item
          Caption = 'Login'
          Width = 100
        end
        item
          Caption = 'Rating'
          Width = 40
        end>
      RowSelect = True
      ParentColor = True
      ShowColumnHeaders = False
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = FormClick
    end
    object Panel1: TPanel
      Left = 2
      Top = 2
      Width = 169
      Height = 59
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 1
      OnClick = FormClick
      DesignSize = (
        169
        59)
      object Label2: TLabel
        Left = 4
        Top = 8
        Width = 24
        Height = 13
        Caption = 'King:'
      end
      object lblKingName: TLabel
        Left = 32
        Top = 8
        Width = 71
        Height = 13
        Caption = 'lblKingName'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblKingRating: TLabel
        Left = 112
        Top = 8
        Width = 51
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = 'lblRating'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblKilled: TLabel
        Left = 96
        Top = 24
        Width = 45
        Height = 13
        Caption = 'lblKilled'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 4
        Top = 24
        Width = 87
        Height = 13
        Caption = 'Contenders killed: '
      end
      object Label6: TLabel
        Left = 4
        Top = 40
        Width = 32
        Height = 13
        Caption = 'Rank: '
      end
      object lblRank: TLabel
        Left = 36
        Top = 40
        Width = 44
        Height = 13
        Caption = 'lblRank'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object pnlTournament: TPanel
    Left = 4
    Top = 360
    Width = 205
    Height = 117
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 8
    object lvMembers: TListView
      Left = 2
      Top = 2
      Width = 201
      Height = 113
      Align = alClient
      Columns = <
        item
          Caption = '#'
          Width = 25
        end
        item
          Caption = 'Login'
          Width = 100
        end
        item
          Caption = 'Rating'
          Width = 60
        end>
      ReadOnly = True
      RowSelect = True
      ParentColor = True
      ShowColumnHeaders = False
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = FormClick
      OnCustomDrawItem = lvMembersCustomDrawItem
    end
  end
  object pmSwitch: TPopupMenu
    Images = fCLMain.ilMain24
    Left = 44
    Top = 7
    object Byorder1: TMenuItem
      Caption = 'By order'
      ImageIndex = 0
      OnClick = Byorder1Click
    end
    object Bytime1: TMenuItem
      Tag = 1
      Caption = 'By time'
      ImageIndex = 1
      OnClick = Byorder1Click
    end
    object Bymoves1: TMenuItem
      Tag = 2
      Caption = 'By moves'
      ImageIndex = 2
      OnClick = Byorder1Click
    end
    object Noswitching1: TMenuItem
      Tag = 3
      Caption = 'No switching'
      ImageIndex = 3
      OnClick = Byorder1Click
    end
  end
  object pmPause: TPopupMenu
    Images = fCLMain.ilMain24
    Left = 156
    Top = 103
    object Pause1: TMenuItem
      Caption = 'Pause'
      ImageIndex = 10
      OnClick = Pause1Click
    end
    object Resume1: TMenuItem
      Caption = 'Resume'
      ImageIndex = 9
      OnClick = Resume1Click
    end
  end
  object pmJoin: TPopupMenu
    Images = fCLMain.ilMain24
    Left = 88
    Top = 4
    object miJoin: TMenuItem
      Caption = 'Join'
      ImageIndex = 6
      OnClick = miJoinClick
    end
  end
end

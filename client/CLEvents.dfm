object fCLEvents: TfCLEvents
  Tag = 13
  Left = 308
  Top = 308
  BorderStyle = bsNone
  Caption = 'c'
  ClientHeight = 611
  ClientWidth = 964
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    964
    611)
  PixelsPerInch = 96
  TextHeight = 13
  object bvlHeader: TBevel
    Left = 0
    Top = 0
    Width = 964
    Height = 19
    Align = alTop
    Style = bsRaised
  end
  object lblNotify: TLabel
    Left = 4
    Top = 2
    Width = 58
    Height = 13
    Caption = 'Event List'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
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
  object lvEvents: TListView
    Left = 0
    Top = 19
    Width = 964
    Height = 592
    Align = alClient
    BorderStyle = bsNone
    Columns = <
      item
        Caption = '#'
        Width = 30
      end
      item
        Caption = 'Title'
        Width = 150
      end
      item
        Caption = 'Status'
        Width = 80
      end
      item
        Caption = 'Join./Obs.'
        Width = 70
      end
      item
        Caption = 'Start Time'
        Width = 70
      end
      item
        Caption = 'Leader(s)'
        Width = 130
      end
      item
        Caption = 'Type'
        Width = 70
      end
      item
        Caption = 'Description'
        Width = 300
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = pmEvents
    SortType = stData
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvEventsDblClick
    OnMouseMove = lvEventsMouseMove
  end
  object pnlInfo: TPanel
    Left = 0
    Top = 64
    Width = 253
    Height = 373
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Color = clCaptionText
    TabOrder = 1
    Visible = False
    object lblDescription: TLabel
      Left = 2
      Top = 339
      Width = 249
      Height = 32
      Align = alClient
      AutoSize = False
      Caption = 'lblDescription'
      WordWrap = True
    end
    object pnlCommon: TPanel
      Left = 2
      Top = 2
      Width = 249
      Height = 71
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      DesignSize = (
        249
        71)
      object lblNum: TLabel
        Left = 4
        Top = 4
        Width = 30
        Height = 13
        Caption = '#000'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblTitle: TLabel
        Left = 40
        Top = 4
        Width = 205
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lblTitle'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblType: TLabel
        Left = 203
        Top = 4
        Width = 42
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = 'lblType'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblLeaderCaption: TLabel
        Left = 4
        Top = 20
        Width = 44
        Height = 13
        Caption = 'Leaders: '
      end
      object lblLeaders: TLabel
        Left = 48
        Top = 20
        Width = 197
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lblLeaders'
      end
      object Label2: TLabel
        Left = 4
        Top = 36
        Width = 73
        Height = 13
        Caption = 'Rating allowed:'
      end
      object lblRating: TLabel
        Left = 80
        Top = 36
        Width = 41
        Height = 13
        Caption = 'lblRating'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblStartTime: TLabel
        Left = 190
        Top = 36
        Width = 55
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = 'lblStartTime'
      end
      object Label3: TLabel
        Left = 4
        Top = 52
        Width = 37
        Height = 13
        Caption = 'Joined: '
      end
      object lblJoined: TLabel
        Left = 40
        Top = 52
        Width = 37
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
      object Label4: TLabel
        Left = 152
        Top = 52
        Width = 51
        Height = 13
        Caption = 'Observers:'
      end
      object lblObserver: TLabel
        Left = 208
        Top = 52
        Width = 37
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
    end
    object pnlSimul: TPanel
      Left = 2
      Top = 73
      Width = 249
      Height = 80
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 1
      DesignSize = (
        249
        80)
      object Label5: TLabel
        Left = 4
        Top = 4
        Width = 65
        Height = 13
        Caption = 'Time Control: '
      end
      object lblTimeControl: TLabel
        Left = 68
        Top = 4
        Width = 81
        Height = 13
        Caption = 'lblTimeControl'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 4
        Top = 36
        Width = 66
        Height = 13
        Caption = 'Total Games: '
      end
      object lblCurrentGames: TLabel
        Left = 80
        Top = 36
        Width = 15
        Height = 13
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label8: TLabel
        Left = 144
        Top = 36
        Width = 84
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Free Game Slots: '
      end
      object lblFreeGameSlots: TLabel
        Left = 228
        Top = 36
        Width = 15
        Height = 13
        Anchors = [akTop, akRight]
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label9: TLabel
        Left = 4
        Top = 20
        Width = 117
        Height = 13
        Caption = 'Maximum Games Count: '
      end
      object lblMaxGames: TLabel
        Left = 120
        Top = 20
        Width = 15
        Height = 13
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 4
        Top = 56
        Width = 30
        Height = 13
        Caption = 'Wins: '
      end
      object lblWins: TLabel
        Left = 36
        Top = 56
        Width = 15
        Height = 13
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 64
        Top = 56
        Width = 26
        Height = 13
        Caption = 'Lost: '
      end
      object lblLost: TLabel
        Left = 92
        Top = 56
        Width = 15
        Height = 13
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label14: TLabel
        Left = 120
        Top = 56
        Width = 36
        Height = 13
        Caption = 'Draws: '
      end
      object lblDraw: TLabel
        Left = 156
        Top = 56
        Width = 15
        Height = 13
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlTournament: TPanel
      Left = 2
      Top = 257
      Width = 249
      Height = 82
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 2
      DesignSize = (
        249
        82)
      object Label1: TLabel
        Left = 4
        Top = 4
        Width = 30
        Height = 13
        Caption = 'Type: '
      end
      object lblTourType: TLabel
        Left = 48
        Top = 4
        Width = 197
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Round Robin'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblToursCaption: TLabel
        Left = 4
        Top = 24
        Width = 103
        Height = 13
        Caption = 'Games for every pair: '
      end
      object lblENumber: TLabel
        Left = 108
        Top = 24
        Width = 29
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
      object lblTourFreeCaption: TLabel
        Left = 172
        Top = 44
        Width = 53
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Free Slots: '
      end
      object lblTourFree: TLabel
        Left = 226
        Top = 44
        Width = 15
        Height = 13
        Alignment = taRightJustify
        Anchors = [akTop, akRight]
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 4
        Top = 44
        Width = 38
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Invited: '
      end
      object lblTourInvited: TLabel
        Left = 46
        Top = 44
        Width = 15
        Height = 13
        Anchors = [akTop, akRight]
        Caption = '00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlOdds: TPanel
      Left = 2
      Top = 153
      Width = 249
      Height = 104
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvLowered
      ParentColor = True
      TabOrder = 3
      DesignSize = (
        249
        104)
      object Panel3: TPanel
        Tag = 5
        Left = 196
        Top = 4
        Width = 49
        Height = 20
        Anchors = [akTop, akRight]
        BevelInner = bvRaised
        BevelOuter = bvLowered
        Caption = 'ODDS'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object pmEvents: TPopupMenu
    OnPopup = pmEventsPopup
    Left = 312
    Top = 84
    object miJoin: TMenuItem
      Caption = 'Join'
      OnClick = miJoinClick
    end
    object miObserve: TMenuItem
      Caption = 'Observe'
      OnClick = miObserveClick
    end
    object miStart: TMenuItem
      Caption = 'Start'
      OnClick = miStartClick
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
      OnClick = miDeleteClick
    end
    object miLeave: TMenuItem
      Caption = 'Leave'
      OnClick = miLeaveClick
    end
    object miTakePart: TMenuItem
      Caption = 'Take Part'
      OnClick = miTakePartClick
    end
    object miAbandon: TMenuItem
      Caption = 'Abandon'
      OnClick = miAbandonClick
    end
    object miAbort: TMenuItem
      Caption = 'Abort and Delete'
      OnClick = miAbortClick
    end
    object miEdit: TMenuItem
      Caption = 'Edit'
      OnClick = miEditClick
    end
    object miInvitedList: TMenuItem
      Caption = 'Invited List'
      OnClick = miInvitedListClick
    end
  end
end

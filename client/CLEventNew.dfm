object fCLEventNew: TfCLEventNew
  Left = 855
  Top = 403
  BorderStyle = bsDialog
  Caption = 'Event'
  ClientHeight = 497
  ClientWidth = 417
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 417
    Height = 137
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Panel1: TPanel
      Left = 2
      Top = 2
      Width = 165
      Height = 133
      Align = alLeft
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 28
        Height = 13
        Caption = 'Name'
      end
      object Label2: TLabel
        Left = 8
        Top = 48
        Width = 53
        Height = 13
        Caption = 'Description'
      end
      object Label4: TLabel
        Left = 8
        Top = 88
        Width = 66
        Height = 13
        Caption = 'Type of event'
      end
      object edName: TEdit
        Left = 8
        Top = 24
        Width = 145
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Text = 'Simul'
        OnKeyPress = edNameKeyPress
      end
      object edDescription: TEdit
        Left = 8
        Top = 64
        Width = 145
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object cbType: TComboBox
        Left = 7
        Top = 104
        Width = 148
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 2
        OnChange = cbTypeChange
        Items.Strings = (
          'Simul'
          'Challenge'
          'King of the Hill'
          'Tournament')
      end
    end
    object pnlLeader: TPanel
      Left = 293
      Top = 2
      Width = 122
      Height = 133
      Align = alRight
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object lblLeader: TLabel
        Left = 8
        Top = 8
        Width = 44
        Height = 13
        Caption = 'Leader(s)'
      end
      object lblLeaderColor: TLabel
        Left = 8
        Top = 48
        Width = 66
        Height = 13
        Caption = 'Leader'#39's color'
      end
      object edLeader: TEdit
        Left = 8
        Top = 24
        Width = 105
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object cbLeaderColor: TComboBox
        Left = 8
        Top = 64
        Width = 108
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 1
        OnChange = cbTypeChange
        OnKeyDown = cbTypeKeyDown
        Items.Strings = (
          'Black & White by Turn'
          'Black & White by Random'
          'White Only'
          'Black Only')
      end
    end
    object pnlTournament: TPanel
      Left = 67
      Top = 2
      Width = 226
      Height = 133
      Align = alRight
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object Label3: TLabel
        Left = 4
        Top = 6
        Width = 92
        Height = 13
        Caption = 'Type of tournament'
      end
      object Label7: TLabel
        Left = 6
        Top = 46
        Width = 66
        Height = 13
        Caption = 'Rounds Order'
      end
      object lblRounds: TLabel
        Left = 6
        Top = 86
        Width = 91
        Height = 13
        Caption = 'Number Of Rounds'
      end
      object sbRoundWins: TSpeedButton
        Left = 100
        Top = 84
        Width = 20
        Height = 16
        Caption = 'W'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = sbRoundWinsClick
      end
      object Label13: TLabel
        Left = 140
        Top = 4
        Width = 53
        Height = 13
        Caption = 'Min People'
      end
      object Label14: TLabel
        Left = 140
        Top = 46
        Width = 56
        Height = 13
        Caption = 'Max People'
      end
      object cbTourType: TComboBox
        Left = 5
        Top = 22
        Width = 115
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cbTypeChange
        OnKeyDown = cbTypeKeyDown
        Items.Strings = (
          'Round Robin'
          'Elimination'
          'Swiss System'
          'Match')
      end
      object cbRoundsOrder: TComboBox
        Left = 7
        Top = 60
        Width = 115
        Height = 21
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        TabOrder = 1
        OnChange = cbTypeChange
        OnKeyDown = cbTypeKeyDown
        Items.Strings = (
          'One By One'
          'No Order'
          'One Round A Day')
      end
      object edRounds: TEdit
        Left = 7
        Top = 103
        Width = 94
        Height = 21
        MaxLength = 5
        TabOrder = 2
        Text = '1'
      end
      object udRounds: TUpDown
        Left = 101
        Top = 103
        Width = 15
        Height = 21
        Associate = edRounds
        Min = 1
        Max = 2
        Position = 1
        TabOrder = 3
        Thousands = False
        Wrap = False
      end
      object edMinPeople: TEdit
        Left = 141
        Top = 21
        Width = 52
        Height = 21
        MaxLength = 5
        TabOrder = 4
        Text = '2'
      end
      object udMinPeople: TUpDown
        Left = 193
        Top = 21
        Width = 15
        Height = 21
        Associate = edMinPeople
        Min = 0
        Max = 9999
        Position = 2
        TabOrder = 5
        Thousands = False
        Wrap = False
      end
      object edMaxPeople: TEdit
        Left = 141
        Top = 60
        Width = 52
        Height = 21
        MaxLength = 5
        TabOrder = 6
        Text = '1000'
      end
      object udMaxPeople: TUpDown
        Left = 193
        Top = 60
        Width = 15
        Height = 21
        Associate = edMaxPeople
        Min = 0
        Max = 9999
        Position = 1000
        TabOrder = 7
        Thousands = False
        Wrap = False
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 137
    Width = 417
    Height = 151
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Panel6: TPanel
      Left = 2
      Top = 2
      Width = 165
      Height = 147
      Align = alLeft
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object Label5: TLabel
        Left = 8
        Top = 8
        Width = 23
        Height = 13
        Caption = 'Date'
      end
      object Label6: TLabel
        Left = 8
        Top = 52
        Width = 23
        Height = 13
        Caption = 'Time'
      end
      object dtDate: TDateTimePicker
        Left = 8
        Top = 24
        Width = 145
        Height = 21
        CalAlignment = dtaLeft
        Date = 39100.9341147569
        Time = 39100.9341147569
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
      end
      object dtTime: TDateTimePicker
        Left = 8
        Top = 68
        Width = 143
        Height = 21
        CalAlignment = dtaLeft
        Date = 39100.9341147569
        Time = 39100.9341147569
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkTime
        ParseInput = False
        TabOrder = 1
      end
      object cbAdminOnly: TCheckBox
        Left = 8
        Top = 124
        Width = 145
        Height = 17
        Caption = 'Admins and Titled Only'
        TabOrder = 2
      end
      object cbAutoStart: TCheckBox
        Left = 8
        Top = 92
        Width = 69
        Height = 17
        Caption = 'Autostart'
        TabOrder = 3
      end
    end
    object Panel7: TPanel
      Left = 167
      Top = 2
      Width = 248
      Height = 147
      Align = alClient
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object lblGames: TLabel
        Left = 128
        Top = 4
        Width = 54
        Height = 13
        Caption = 'Max games'
      end
      object Label8: TLabel
        Left = 8
        Top = 44
        Width = 66
        Height = 13
        Caption = 'Sec per move'
      end
      object Label9: TLabel
        Left = 8
        Top = 4
        Width = 24
        Height = 13
        Caption = 'Initial'
      end
      object lblStyle: TLabel
        Left = 8
        Top = 84
        Width = 96
        Height = 13
        Caption = '&Style of game will be'
      end
      object edGames: TEdit
        Left = 129
        Top = 21
        Width = 40
        Height = 21
        MaxLength = 5
        TabOrder = 0
        Text = '20'
      end
      object udGames: TUpDown
        Left = 169
        Top = 21
        Width = 15
        Height = 21
        Associate = edGames
        Min = 0
        Max = 9999
        Position = 20
        TabOrder = 1
        Thousands = False
        Wrap = False
      end
      object edSec: TEdit
        Left = 9
        Top = 61
        Width = 52
        Height = 21
        MaxLength = 5
        TabOrder = 2
        Text = '12'
      end
      object udSec: TUpDown
        Left = 61
        Top = 61
        Width = 15
        Height = 21
        Associate = edSec
        Min = 0
        Max = 9999
        Position = 12
        TabOrder = 3
        Thousands = False
        Wrap = False
      end
      object edMin: TEdit
        Left = 9
        Top = 21
        Width = 32
        Height = 21
        MaxLength = 5
        TabOrder = 4
        Text = '2'
      end
      object udMin: TUpDown
        Left = 41
        Top = 21
        Width = 15
        Height = 21
        Associate = edMin
        Min = 0
        Max = 9999
        Position = 2
        TabOrder = 5
        Thousands = False
        Wrap = False
      end
      object cbTimeLimit: TCheckBox
        Left = 80
        Top = 44
        Width = 93
        Height = 17
        Caption = 'Join Time Limit'
        TabOrder = 6
        OnClick = cbTimeLimitClick
      end
      object edTimeLimit: TEdit
        Left = 81
        Top = 61
        Width = 52
        Height = 21
        Hint = 
          'Don'#39't let people join before this number'#13#10'of minutes before even' +
          't start.'
        MaxLength = 5
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        Text = '5'
      end
      object udTimeLimit: TUpDown
        Left = 133
        Top = 61
        Width = 15
        Height = 21
        Associate = edTimeLimit
        Min = 0
        Max = 9999
        Position = 5
        TabOrder = 8
        Thousands = False
        Wrap = False
      end
      object cbRatedType: TComboBox
        Left = 9
        Top = 100
        Width = 164
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 9
        Items.Strings = (
          'Normal'
          'Crazy House'
          'Fischer Random'
          'Loser'#39's')
      end
      object cbRated: TCheckBox
        Left = 8
        Top = 124
        Width = 53
        Height = 17
        Caption = 'Rated'
        TabOrder = 10
      end
      object cbDimension: TComboBox
        Left = 64
        Top = 20
        Width = 61
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 11
        Items.Strings = (
          'minutes'
          'seconds')
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 463
    Width = 417
    Height = 34
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Panel10: TPanel
      Left = 343
      Top = 2
      Width = 69
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object SpeedButton3: TSpeedButton
        Left = 0
        Top = 0
        Width = 69
        Height = 29
        Caption = 'Cancel'
        Flat = True
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        OnClick = SpeedButton3Click
      end
    end
    object Panel11: TPanel
      Left = 283
      Top = 2
      Width = 57
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object sbOk: TSpeedButton
        Left = 0
        Top = 0
        Width = 57
        Height = 29
        AllowAllUp = True
        Caption = 'Ok'
        Flat = True
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        OnClick = sbOkClick
      end
    end
    object pnlOdds: TPanel
      Left = 2
      Top = 2
      Width = 69
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object btnOdds: TSpeedButton
        Left = 0
        Top = 0
        Width = 69
        Height = 29
        AllowAllUp = True
        Caption = 'ODDS'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = btnOddsClick
      end
    end
    object Panel3: TPanel
      Left = 74
      Top = 2
      Width = 69
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 3
      object SpeedButton1: TSpeedButton
        Left = 0
        Top = 0
        Width = 69
        Height = 29
        AllowAllUp = True
        Caption = 'CLUBS'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = SpeedButton1Click
      end
    end
    object pnlTickets: TPanel
      Left = 146
      Top = 2
      Width = 79
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 4
      object sbInvited: TSpeedButton
        Left = 0
        Top = 0
        Width = 79
        Height = 29
        AllowAllUp = True
        Caption = 'INVITED'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = sbInvitedClick
      end
    end
  end
  object Panel8: TPanel
    Left = 0
    Top = 288
    Width = 417
    Height = 175
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    object Panel9: TPanel
      Left = 2
      Top = 2
      Width = 179
      Height = 171
      Align = alLeft
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object Label10: TLabel
        Left = 8
        Top = 4
        Width = 75
        Height = 13
        Caption = 'Minimum Rating'
      end
      object Label11: TLabel
        Left = 92
        Top = 4
        Width = 78
        Height = 13
        Caption = 'Maximum Rating'
      end
      object Label12: TLabel
        Left = 8
        Top = 120
        Width = 134
        Height = 13
        Caption = 'Pause between games (sec)'
      end
      object edMinRating: TEdit
        Left = 8
        Top = 20
        Width = 77
        Height = 21
        TabOrder = 0
        Text = '0'
      end
      object edMaxRating: TEdit
        Left = 92
        Top = 20
        Width = 77
        Height = 21
        TabOrder = 1
        Text = '3000'
      end
      object cbOneGame: TCheckBox
        Left = 8
        Top = 68
        Width = 117
        Height = 17
        Caption = 'One game for player'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object edPause: TEdit
        Left = 9
        Top = 137
        Width = 52
        Height = 21
        MaxLength = 5
        TabOrder = 3
        Text = '60'
      end
      object udPause: TUpDown
        Left = 61
        Top = 137
        Width = 15
        Height = 21
        Associate = edPause
        Min = 0
        Max = 1000
        Increment = 10
        Position = 60
        TabOrder = 4
        Thousands = False
        Wrap = False
      end
      object cbProvisional: TCheckBox
        Left = 8
        Top = 48
        Width = 161
        Height = 17
        Caption = 'Allow Provisional Rating'
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
      object cbLagRestriction: TCheckBox
        Left = 8
        Top = 88
        Width = 159
        Height = 17
        Caption = 'Restrict by Lag (>=1000)'
        Checked = True
        State = cbChecked
        TabOrder = 6
      end
    end
    object Panel12: TPanel
      Left = 181
      Top = 2
      Width = 234
      Height = 171
      Align = alClient
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object lblShoutStart: TLabel
        Left = 6
        Top = 22
        Width = 93
        Height = 13
        Caption = 'Minutes before start'
      end
      object lblShoutInc: TLabel
        Left = 162
        Top = 22
        Width = 64
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Repeat every'
      end
      object lblShoutMsg: TLabel
        Left = 6
        Top = 66
        Width = 74
        Height = 13
        Caption = 'Shout Message'
      end
      object Label15: TLabel
        Left = 6
        Top = 128
        Width = 68
        Height = 13
        Caption = 'Congratulation'
      end
      object cbShout: TCheckBox
        Left = 6
        Top = 4
        Width = 113
        Height = 17
        Caption = 'Shout about event'
        TabOrder = 0
        OnClick = cbTimeLimitClick
      end
      object edShoutStart: TEdit
        Left = 7
        Top = 39
        Width = 52
        Height = 21
        MaxLength = 5
        TabOrder = 1
        Text = '60'
      end
      object udShoutStart: TUpDown
        Left = 59
        Top = 39
        Width = 15
        Height = 21
        Associate = edShoutStart
        Min = 0
        Max = 9999
        Increment = 10
        Position = 60
        TabOrder = 2
        Thousands = False
        Wrap = False
      end
      object edShoutInc: TEdit
        Left = 163
        Top = 39
        Width = 52
        Height = 21
        Anchors = [akTop, akRight]
        MaxLength = 5
        TabOrder = 3
        Text = '5'
      end
      object udShoutInc: TUpDown
        Left = 215
        Top = 39
        Width = 15
        Height = 21
        Anchors = [akTop, akRight]
        Associate = edShoutInc
        Min = 0
        Max = 9999
        Position = 5
        TabOrder = 4
        Thousands = False
        Wrap = False
      end
      object edShoutMsg: TEdit
        Left = 6
        Top = 82
        Width = 223
        Height = 21
        Hint = 'If you don'#39't enter Shout Message, standard message will be used'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object edCongMsg: TEdit
        Left = 6
        Top = 144
        Width = 223
        Height = 21
        Hint = 'If you don'#39't enter Shout Message, standard message will be used'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 6
      end
      object cbShoutEveryRound: TCheckBox
        Left = 8
        Top = 106
        Width = 137
        Height = 17
        Caption = 'Shout Every Round'
        TabOrder = 7
      end
    end
  end
end

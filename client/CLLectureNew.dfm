object fCLLectureNew: TfCLLectureNew
  Left = 416
  Top = 282
  BorderStyle = bsDialog
  Caption = 'Lecture'
  ClientHeight = 338
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 359
    Height = 139
    Align = alTop
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
      Top = 90
      Width = 39
      Height = 13
      Caption = 'Lecturer'
    end
    object Label3: TLabel
      Left = 8
      Top = 48
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object edName: TEdit
      Left = 8
      Top = 24
      Width = 339
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'Lecture'
    end
    object edLecturer: TEdit
      Left = 8
      Top = 106
      Width = 339
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object edDescription: TEdit
      Left = 8
      Top = 64
      Width = 339
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 304
    Width = 359
    Height = 34
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object Panel10: TPanel
      Left = 285
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
      Left = 225
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
    object Panel3: TPanel
      Left = 4
      Top = 4
      Width = 69
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object sbClubs: TSpeedButton
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
        OnClick = sbClubsClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 139
    Width = 359
    Height = 165
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Panel6: TPanel
      Left = 2
      Top = 2
      Width = 165
      Height = 161
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
        Top = 98
        Width = 69
        Height = 17
        Caption = 'Autostart'
        TabOrder = 3
      end
    end
    object Panel12: TPanel
      Left = 167
      Top = 2
      Width = 190
      Height = 161
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
        Left = 118
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
      object cbShout: TCheckBox
        Left = 6
        Top = 4
        Width = 113
        Height = 17
        Caption = 'Shout about event'
        TabOrder = 0
        OnClick = cbShoutClick
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
        Left = 119
        Top = 39
        Width = 52
        Height = 21
        Anchors = [akTop, akRight]
        MaxLength = 5
        TabOrder = 3
        Text = '5'
      end
      object udShoutInc: TUpDown
        Left = 171
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
        Width = 179
        Height = 21
        Hint = 'If you don'#39't enter Shout Message, standard message will be used'
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
    end
  end
end

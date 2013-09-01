object fCLClubMembers: TfCLClubMembers
  Left = 452
  Top = 300
  Caption = 'Club Manager'
  ClientHeight = 459
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lv: TListView
    Left = 0
    Top = 101
    Width = 349
    Height = 324
    Align = alClient
    Color = clWhite
    Columns = <
      item
        AutoSize = True
        Caption = 'Name'
      end
      item
        Caption = 'Title'
        Width = 40
      end
      item
        Caption = 'Status'
        Width = 80
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    GridLines = True
    OwnerDraw = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    PopupMenu = pm
    TabOrder = 0
    ViewStyle = vsReport
    OnDrawItem = lvDrawItem
    OnSelectItem = lvSelectItem
  end
  object Panel5: TPanel
    Left = 0
    Top = 425
    Width = 349
    Height = 34
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      349
      34)
    object pnlOk: TPanel
      Left = 276
      Top = 2
      Width = 68
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object sbOk: TSpeedButton
        Left = 0
        Top = 0
        Width = 68
        Height = 29
        AllowAllUp = True
        Caption = 'Close'
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
        OnClick = sbOkClick
      end
    end
    object pnlCancel: TPanel
      Left = 4
      Top = 2
      Width = 69
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object SpeedButton3: TSpeedButton
        Left = 0
        Top = 0
        Width = 69
        Height = 29
        Caption = 'Options'
        Flat = True
        NumGlyphs = 2
        OnClick = SpeedButton3Click
      end
    end
    object Panel2: TPanel
      Left = 76
      Top = 2
      Width = 69
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object SpeedButton1: TSpeedButton
        Left = 0
        Top = 0
        Width = 69
        Height = 29
        Caption = 'Refresh'
        Flat = True
        NumGlyphs = 2
        OnClick = SpeedButton1Click
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 349
    Height = 101
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    DesignSize = (
      349
      101)
    object lblName: TLabel
      Left = 106
      Top = 8
      Width = 237
      Height = 19
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'club name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pnlPhoto: TPanel
      Left = 4
      Top = 4
      Width = 96
      Height = 96
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Caption = 'NO LOGO'
      TabOrder = 0
      object imgPhoto: TImage
        Left = 2
        Top = 2
        Width = 92
        Height = 92
        Align = alClient
      end
    end
  end
  object pm: TPopupMenu
    Left = 160
    Top = 220
    object miStatus: TMenuItem
      Caption = 'Change Status'
      object Pretendent1: TMenuItem
        Tag = 1
        Caption = 'Candidate'
        OnClick = ChangeStatus
      end
      object Member1: TMenuItem
        Tag = 2
        Caption = 'Member'
        OnClick = ChangeStatus
      end
      object Helper1: TMenuItem
        Tag = 3
        Caption = 'Helper'
        OnClick = ChangeStatus
      end
      object Master1: TMenuItem
        Tag = 4
        Caption = 'Manager'
        OnClick = ChangeStatus
      end
    end
    object miKickOut: TMenuItem
      Caption = 'Kick Out'
      OnClick = ChangeStatus
    end
    object miAccept: TMenuItem
      Tag = 2
      Caption = 'Accept'
      OnClick = ChangeStatus
    end
    object miRefuse: TMenuItem
      Caption = 'Refuse'
      OnClick = ChangeStatus
    end
  end
end

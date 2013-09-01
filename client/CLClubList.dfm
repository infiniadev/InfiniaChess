object fCLClubList: TfCLClubList
  Tag = 22
  Left = 467
  Top = 325
  Caption = 'Clubs'
  ClientHeight = 357
  ClientWidth = 364
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
  object pnlButtons: TPanel
    Left = 0
    Top = 323
    Width = 364
    Height = 34
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      364
      34)
    object Panel11: TPanel
      Left = 302
      Top = 2
      Width = 57
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
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
    object pnlCancel: TPanel
      Left = 231
      Top = 2
      Width = 69
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      Visible = False
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
  end
  object lv: TListView
    Left = 0
    Top = 0
    Width = 364
    Height = 323
    Align = alClient
    Columns = <
      item
        Caption = '#'
        Width = 40
      end
      item
        AutoSize = True
        Caption = 'Name'
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
    TabOrder = 1
    ViewStyle = vsReport
    OnDrawItem = lvDrawItem
    OnMouseMove = lvMouseMove
    OnSelectItem = lvSelectItem
  end
  object pnlInfo: TPanel
    Left = 2
    Top = 46
    Width = 253
    Height = 133
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 2
    Visible = False
    object pnlCommon: TPanel
      Left = 2
      Top = 2
      Width = 249
      Height = 129
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      OnMouseMove = pnlCommonMouseMove
      DesignSize = (
        249
        129)
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
        Left = 42
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
      object lblDescription: TLabel
        Left = 4
        Top = 27
        Width = 137
        Height = 94
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoSize = False
        Caption = 'lblDescription'
        WordWrap = True
      end
      object pnlPhoto: TPanel
        Left = 148
        Top = 26
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
  end
  object pm: TPopupMenu
    Left = 312
    Top = 100
    object miGoToClub: TMenuItem
      Caption = 'Go To Club'
      OnClick = miGoToClubClick
    end
    object miJoinClub: TMenuItem
      Caption = 'Join Club'
      OnClick = miJoinClubClick
    end
    object miManageClub: TMenuItem
      Caption = 'Manage Club'
      OnClick = miManageClubClick
    end
    object miLeaveClub: TMenuItem
      Caption = 'Leave Club'
      OnClick = miLeaveClubClick
    end
    object miInfo: TMenuItem
      Caption = 'Info'
      OnClick = miInfoClick
    end
    object miEditName: TMenuItem
      Caption = 'Edit Name'
      OnClick = miEditNameClick
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
      OnClick = miDeleteClick
    end
  end
end

object fCLNotify: TfCLNotify
  Tag = 1
  Left = 493
  Top = 244
  BorderStyle = bsNone
  Caption = 'Notify'
  ClientHeight = 350
  ClientWidth = 590
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object clNotify: TCLListBox
    Left = 0
    Top = 18
    Width = 590
    Height = 310
    Align = alClient
    BorderStyle = bsNone
    Color = clBtnFace
    CustomDraw = False
    PlainText = True
    ItemHeight = 16
    OnClick = clNotifyClick
    OnDrawItem = clNotifyDrawItem
    OnKeyDown = clNotifyKeyDown
    PopupMenu = pmNotify
    SelectedFont.Charset = DEFAULT_CHARSET
    SelectedFont.Color = clWindowText
    SelectedFont.Height = -11
    SelectedFont.Name = 'MS Sans Serif'
    SelectedFont.Style = [fsBold]
    SmallFontSize = 0
    LargeFontSize = 0
    Style = lbOwnerDrawFixed
    TabOrder = 0
    TextBuff = 36
  end
  object tbNotify: TTabControl
    Left = 0
    Top = 328
    Width = 590
    Height = 22
    Align = alBottom
    Images = fCLMain.ilNotify
    OwnerDraw = True
    TabOrder = 1
    TabPosition = tpBottom
    Tabs.Strings = (
      ''
      ' '
      ''
      '')
    TabIndex = 0
    TabWidth = 24
    OnChange = tbNotifyChange
    OnDrawTab = tbNotifyDrawTab
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 590
    Height = 18
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 2
    DesignSize = (
      590
      18)
    object lblNotify: TLabel
      Left = 4
      Top = 2
      Width = 89
      Height = 13
      Caption = 'Notify List (Friends)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object sbClose: TSpeedButton
      Left = 573
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
  object pmNotify: TPopupMenu
    OnPopup = pmNotifyPopup
    Left = 10
    Top = 24
    object miNotifyAdd: TMenuItem
      Caption = '&Add...'
      Enabled = False
      OnClick = miNotifyAddClick
    end
    object miCensorAdd: TMenuItem
      Caption = 'Add'
      Enabled = False
      object miFullCensored: TMenuItem
        Tag = 2
        Caption = 'Full Censored...'
        OnClick = miNotifyAddClick
      end
      object miNoPlay: TMenuItem
        Tag = 4
        Caption = 'No Play...'
        OnClick = miNotifyAddClick
      end
    end
    object miNotifyRemove: TMenuItem
      Caption = '&Remove'
      Enabled = False
      OnClick = miNotifyRemoveClick
    end
    object miNotifyChange: TMenuItem
      Caption = 'Change to Full Censored'
      Enabled = False
      OnClick = miNotifyChangeClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miInvite: TMenuItem
      Caption = '&Invite...'
      Enabled = False
      OnClick = miInviteClick
    end
    object miMatch: TMenuItem
      Caption = '&Match...'
      Enabled = False
      OnClick = miMatchClick
    end
    object miMessage: TMenuItem
      Caption = 'M&essage...'
      Enabled = False
      OnClick = miMessageClick
    end
    object miProfile: TMenuItem
      Caption = '&Profile'
      Enabled = False
      OnClick = miProfileClick
    end
    object miTell: TMenuItem
      Caption = 'Say "Hi!"'
      Enabled = False
      OnClick = miTellClick
    end
    object miFollow: TMenuItem
      Caption = 'Follow'
      Enabled = False
      OnClick = miFollowClick
    end
    object miObserve: TMenuItem
      Caption = 'Observe'
      Enabled = False
      OnClick = miObserveClick
    end
    object miUnfollow: TMenuItem
      Caption = 'Unfollow'
      Enabled = False
      Visible = False
      OnClick = miUnfollowClick
    end
    object miAdminGreetings: TMenuItem
      Caption = 'Admin Greetings'
      Enabled = False
      Visible = False
      OnClick = miAdminGreetingsClick
    end
  end
end

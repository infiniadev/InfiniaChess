inherited fCLClubs: TfCLClubs
  Tag = 22
  Left = 388
  Top = 300
  BorderStyle = bsNone
  Caption = 'fCLClubs'
  ClientHeight = 400
  ClientWidth = 638
  OldCreateOrder = True
  PopupMenu = pm
  Visible = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sbHor: TScrollBar
    Top = 384
    Width = 638
  end
  inherited sbVer: TScrollBar
    Left = 622
    Top = 19
    Height = 365
    ExplicitTop = 19
    ExplicitHeight = 365
  end
  inherited lvDumb: TListView
    TabOrder = 3
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 638
    Height = 19
    Align = alTop
    Alignment = taLeftJustify
    Caption = 'Clubs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object pm: TPopupMenu
    OnPopup = pmPopup
    Left = 312
    Top = 98
    object miCreateClub: TMenuItem
      Caption = 'Create Club'
      OnClick = miCreateClubClick
    end
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
      Caption = 'Stop Membership'
      OnClick = miLeaveClubClick
    end
    object miInfo: TMenuItem
      Caption = 'Info'
      OnClick = miInfoClick
    end
    object miEditName: TMenuItem
      Caption = 'Edit Name and Type'
      OnClick = miEditNameClick
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
      OnClick = miDeleteClick
    end
  end
end

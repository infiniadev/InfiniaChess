object fCLLectures: TfCLLectures
  Tag = 21
  Left = 410
  Top = 306
  BorderStyle = bsNone
  Caption = 'fCLLectures'
  ClientHeight = 613
  ClientWidth = 862
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lvLectures: TListView
    Left = 0
    Top = 19
    Width = 862
    Height = 594
    Align = alBottom
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
        Caption = 'Students'
        Width = 70
      end
      item
        Caption = 'Start Time'
        Width = 140
      end
      item
        Caption = 'Lecturer'
        Width = 130
      end
      item
        Caption = 'Type'
        Width = 0
      end
      item
        Caption = 'Description'
        Width = 300
      end>
    HideSelection = False
    OwnerDraw = True
    ReadOnly = True
    RowSelect = True
    ParentColor = True
    PopupMenu = pmLectures
    SortType = stData
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvLecturesDblClick
    OnDrawItem = lvLecturesDrawItem
    OnSelectItem = lvLecturesSelectItem
  end
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 862
    Height = 19
    Align = alTop
    Alignment = taLeftJustify
    Caption = ' Lectures'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object pmLectures: TPopupMenu
    OnPopup = pmLecturesPopup
    Left = 316
    Top = 84
    object miStart: TMenuItem
      Caption = 'Start Lecture'
      OnClick = miStartClick
    end
    object miDelete: TMenuItem
      Caption = 'Delete Lecture'
      OnClick = miDeleteClick
    end
    object miJoin: TMenuItem
      Caption = 'Join Lecture'
      OnClick = miJoinClick
    end
    object miLeave: TMenuItem
      Caption = 'Leave Lecture'
      OnClick = miLeaveClick
    end
    object miEdit: TMenuItem
      Caption = 'Edit Lecture'
      OnClick = miEditClick
    end
    object miFinish: TMenuItem
      Caption = 'End Lecture'
      OnClick = miFinishClick
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = pmLecturesPopup
    Left = 316
    Top = 84
    object MenuItem1: TMenuItem
      Caption = 'Start Lecture'
      OnClick = miStartClick
    end
    object MenuItem2: TMenuItem
      Caption = 'Delete Lecture'
      OnClick = miDeleteClick
    end
    object MenuItem3: TMenuItem
      Caption = 'Join Lecture'
      OnClick = miJoinClick
    end
    object MenuItem4: TMenuItem
      Caption = 'Leave Lecture'
      OnClick = miLeaveClick
    end
    object MenuItem5: TMenuItem
      Caption = 'Edit Lecture'
      OnClick = miEditClick
    end
    object MenuItem6: TMenuItem
      Caption = 'End Lecture'
      OnClick = miFinishClick
    end
  end
end

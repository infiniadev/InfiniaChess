object DirectoryListDialog: TDirectoryListDialog
  Left = 206
  Top = 99
  ActiveControl = DirectoryList
  BorderStyle = bsDialog
  Caption = 'Directory list'
  ClientHeight = 191
  ClientWidth = 350
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  PixelsPerInch = 96
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object DirectoryList: TTextListBox
    Left = 8
    Top = 12
    Width = 245
    Height = 165
    DragMode = dmAutomatic
    ItemHeight = 13
    TabOrder = 0
    OnClick = DirectoryListClick
    OnDragDrop = DirectoryListDragDrop
    OnDragOver = DirectoryListDragOver
  end
  object AddBtn: TButton
    Left = 264
    Top = 12
    Width = 75
    Height = 25
    Caption = 'Add...'
    TabOrder = 1
    OnClick = AddBtnClick
  end
  object RemoveBtn: TButton
    Left = 264
    Top = 76
    Width = 75
    Height = 25
    Caption = 'Remove'
    TabOrder = 3
    OnClick = RemoveBtnClick
  end
  object ModifyBtn: TButton
    Left = 264
    Top = 44
    Width = 75
    Height = 25
    Caption = 'Modify'
    TabOrder = 2
    OnClick = ModifyBtnClick
  end
  object OKBtn: TButton
    Left = 264
    Top = 120
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
  end
  object CancelBtn: TButton
    Left = 264
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object Storage: TFormStorage
    IniFileName = 'DELPHI.INI'
    IniSection = 'RX.DirListEditor'
    Left = 4
    Top = 160
  end
end

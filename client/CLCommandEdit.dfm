object fCLCommandEdit: TfCLCommandEdit
  Left = 797
  Top = 560
  BorderStyle = bsDialog
  Caption = 'Command Menu Template'
  ClientHeight = 103
  ClientWidth = 240
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblCaption: TLabel
    Left = 8
    Top = 20
    Width = 39
    Height = 13
    Caption = '&Caption:'
  end
  object lblCommand: TLabel
    Left = 8
    Top = 44
    Width = 50
    Height = 13
    Caption = 'Co&mmand:'
  end
  object btnOK: TButton
    Left = 80
    Top = 73
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 160
    Top = 73
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object edtCaption: TEdit
    Left = 64
    Top = 16
    Width = 169
    Height = 21
    MaxLength = 50
    TabOrder = 0
    OnChange = ContentsChanged
  end
  object edtCommand: TEdit
    Left = 64
    Top = 40
    Width = 169
    Height = 21
    MaxLength = 500
    TabOrder = 1
    OnChange = ContentsChanged
  end
end

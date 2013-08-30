object fCLMoretime: TfCLMoretime
  Left = 477
  Top = 330
  BorderStyle = bsToolWindow
  Caption = 'More Time Request'
  ClientHeight = 193
  ClientWidth = 170
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblRequest: TLabel
    Left = 8
    Top = 8
    Width = 93
    Height = 13
    Caption = 'Request More Time'
    WordWrap = True
  end
  object rbOne: TRadioButton
    Tag = 1
    Left = 8
    Top = 32
    Width = 113
    Height = 17
    Caption = '1 Minute'
    TabOrder = 0
    OnClick = RadioButtonClick
  end
  object rbFive: TRadioButton
    Tag = 2
    Left = 8
    Top = 56
    Width = 113
    Height = 17
    Caption = '5 Minutes'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = RadioButtonClick
  end
  object rbTen: TRadioButton
    Tag = 3
    Left = 8
    Top = 80
    Width = 113
    Height = 17
    Caption = '10 Minutes'
    TabOrder = 2
    OnClick = RadioButtonClick
  end
  object rbTwenty: TRadioButton
    Tag = 4
    Left = 8
    Top = 104
    Width = 113
    Height = 17
    Caption = '20 Minutes'
    TabOrder = 3
    OnClick = RadioButtonClick
  end
  object rbOther: TRadioButton
    Left = 8
    Top = 128
    Width = 65
    Height = 17
    Caption = 'Other...'
    TabOrder = 4
    OnClick = rbOtherClick
  end
  object edtOther: TEdit
    Left = 88
    Top = 128
    Width = 73
    Height = 21
    MaxLength = 2
    TabOrder = 5
    OnChange = edtOtherChange
  end
  object btnOK: TButton
    Left = 8
    Top = 160
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 88
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
end

object fCLAccounts: TfCLAccounts
  Left = 658
  Top = 358
  BorderStyle = bsDialog
  Caption = 'Infinia Chess Accounts'
  ClientHeight = 329
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lblAccounts: TLabel
    Left = 4
    Top = 0
    Width = 412
    Height = 30
    AutoSize = False
    Caption = 
      'A Infinia Chess account is required in order to connect and play' +
      '. Choose if you'#39'd like to register for a new account or edit an ' +
      'existing one.'
    Color = clWhite
    ParentColor = False
    Layout = tlCenter
    WordWrap = True
  end
  object bntNext: TButton
    Left = 256
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Next >'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = bntNextClick
  end
  object btnCancel: TButton
    Left = 338
    Top = 296
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object rbExisting: TRadioButton
    Left = 48
    Top = 160
    Width = 309
    Height = 17
    Caption = 'I have an existing Infinia Chess account that I'#39'd like to use.'
    TabOrder = 1
  end
  object rbNew: TRadioButton
    Left = 48
    Top = 112
    Width = 309
    Height = 17
    Caption = 'I'#39'd like to register for a new Infinia Chess account.'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
end

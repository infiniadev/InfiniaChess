object fCLAccount: TfCLAccount
  Left = 659
  Top = 522
  BorderStyle = bsDialog
  Caption = 'Account Editor'
  ClientHeight = 292
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lblAccountEdit: TLabel
    Left = 4
    Top = 0
    Width = 412
    Height = 30
    AutoSize = False
    Caption = 
      'Add/edit an account for the Infinia Chess server. Connect to the' +
      ' server by choosing File | Connect from the main menu.'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object lblLogin: TLabel
    Left = 16
    Top = 72
    Width = 26
    Height = 13
    Caption = '&Login'
    FocusControl = edtLogin
  end
  object lbPassword: TLabel
    Left = 16
    Top = 104
    Width = 46
    Height = 13
    Caption = '&Password'
    FocusControl = edtPassword
  end
  object lbServer: TLabel
    Left = 16
    Top = 156
    Width = 31
    Height = 13
    Caption = '&Server'
    FocusControl = cbServer
  end
  object lbPort: TLabel
    Left = 16
    Top = 188
    Width = 19
    Height = 13
    Caption = 'P&ort'
    FocusControl = edtPort
  end
  object lbCommands: TLabel
    Left = 16
    Top = 219
    Width = 100
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Post &Login Command'
    FocusControl = edtCommands
  end
  object lblName: TLabel
    Left = 16
    Top = 44
    Width = 28
    Height = 13
    Caption = '&Name'
    FocusControl = edtName
  end
  object edtLogin: TEdit
    Left = 72
    Top = 68
    Width = 145
    Height = 21
    MaxLength = 15
    TabOrder = 1
    OnChange = ControlChanged
  end
  object edtPassword: TEdit
    Left = 72
    Top = 100
    Width = 145
    Height = 21
    MaxLength = 15
    PasswordChar = '*'
    TabOrder = 2
    OnChange = ControlChanged
  end
  object cbServer: TComboBox
    Left = 72
    Top = 152
    Width = 145
    Height = 21
    ItemHeight = 13
    MaxLength = 50
    TabOrder = 3
    Text = '71.133.55.56'
    OnChange = ControlChanged
    Items.Strings = (
      'infiniachess.com')
  end
  object edtPort: TEdit
    Left = 72
    Top = 184
    Width = 132
    Height = 21
    MaxLength = 4
    TabOrder = 4
    Text = '1025'
    OnChange = ControlChanged
  end
  object edtCommands: TEdit
    Left = 16
    Top = 235
    Width = 393
    Height = 21
    Anchors = [akLeft, akBottom]
    MaxLength = 100
    TabOrder = 5
  end
  object btnOK: TButton
    Left = 256
    Top = 261
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 338
    Top = 261
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
    OnClick = btnCancelClick
  end
  object udPort: TUpDown
    Left = 204
    Top = 184
    Width = 13
    Height = 21
    Associate = edtPort
    Min = 1
    Max = 32000
    Position = 1025
    TabOrder = 8
    Thousands = False
    Wrap = False
  end
  object edtName: TEdit
    Left = 72
    Top = 40
    Width = 145
    Height = 21
    MaxLength = 15
    TabOrder = 0
    OnChange = ControlChanged
  end
  object cbRemember: TCheckBox
    Left = 16
    Top = 128
    Width = 129
    Height = 17
    Caption = 'Remember Password'
    Checked = True
    State = cbChecked
    TabOrder = 9
    OnClick = cbRememberClick
  end
end

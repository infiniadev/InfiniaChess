object fCLMessage: TfCLMessage
  Left = 89
  Top = 89
  Caption = 'New Message'
  ClientHeight = 261
  ClientWidth = 510
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
  DesignSize = (
    510
    261)
  PixelsPerInch = 96
  TextHeight = 13
  object lblNewMessage2: TLabel
    Left = 0
    Top = 0
    Width = 510
    Height = 30
    Align = alTop
    AutoSize = False
    Caption = 
      'Use this dialog to send a message to the mailbox of a registered' +
      ' player. To chat with a player use the /tell command ( e.g. /tel' +
      'l brian hello ).'
    Color = clWhite
    ParentColor = False
    WordWrap = True
    ExplicitWidth = 964
  end
  object lblTo: TLabel
    Left = 8
    Top = 36
    Width = 16
    Height = 13
    Caption = '&To:'
    FocusControl = cmbTo
  end
  object lblSubject: TLabel
    Left = 8
    Top = 88
    Width = 39
    Height = 13
    Caption = '&Subject:'
    FocusControl = edtSubject
  end
  object lblMessage: TLabel
    Left = 8
    Top = 134
    Width = 46
    Height = 13
    Caption = '&Message:'
    FocusControl = edtSubject
  end
  object btnCancel: TButton
    Left = 349
    Top = 233
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    ExplicitLeft = 346
    ExplicitTop = 245
  end
  object btnSend: TButton
    Left = 430
    Top = 233
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Send'
    Enabled = False
    TabOrder = 4
    OnClick = btnSendClick
    ExplicitLeft = 427
    ExplicitTop = 245
  end
  object cmbTo: TComboBox
    Left = 8
    Top = 55
    Width = 145
    Height = 22
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    Sorted = True
    TabOrder = 0
    OnKeyPress = cmbToKeyPress
  end
  object edtSubject: TEdit
    Left = 8
    Top = 104
    Width = 497
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 50
    TabOrder = 1
    OnChange = edtMessageChange
    ExplicitWidth = 400
  end
  object memoMessage: TMemo
    Left = 8
    Top = 153
    Width = 497
    Height = 70
    Anchors = [akLeft, akTop, akRight, akBottom]
    MaxLength = 500
    TabOrder = 2
    WantReturns = False
    OnChange = edtMessageChange
    ExplicitWidth = 400
    ExplicitHeight = 83
  end
  object pnlType: TPanel
    Left = 159
    Top = 36
    Width = 77
    Height = 51
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 5
    object rbPerson: TRadioButton
      Left = 8
      Top = 8
      Width = 59
      Height = 17
      Caption = 'Person'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbPersonClick
    end
    object rbGroup: TRadioButton
      Left = 8
      Top = 28
      Width = 57
      Height = 17
      Caption = 'Group'
      TabOrder = 1
      OnClick = rbGroupClick
    end
  end
  object pnlGroups: TPanel
    Left = 242
    Top = 36
    Width = 263
    Height = 62
    Anchors = [akLeft, akTop, akRight]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 6
    Visible = False
    ExplicitWidth = 260
    object CheckBox1: TCheckBox
      Tag = 1
      Left = 6
      Top = 4
      Width = 63
      Height = 17
      Caption = 'Admins 1'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Tag = 2
      Left = 6
      Top = 22
      Width = 69
      Height = 17
      Caption = 'Admins 2'
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Tag = 3
      Left = 6
      Top = 40
      Width = 67
      Height = 17
      Caption = 'Admins 3'
      TabOrder = 2
    end
    object CheckBox4: TCheckBox
      Tag = 4
      Left = 77
      Top = 4
      Width = 63
      Height = 17
      Caption = 'Paid'
      TabOrder = 3
    end
    object CheckBox5: TCheckBox
      Tag = 5
      Left = 77
      Top = 22
      Width = 69
      Height = 17
      Caption = 'Trial'
      TabOrder = 4
    end
    object CheckBox6: TCheckBox
      Tag = 6
      Left = 77
      Top = 40
      Width = 67
      Height = 17
      Caption = 'Non-Paid'
      TabOrder = 5
    end
    object CheckBox7: TCheckBox
      Tag = 7
      Left = 152
      Top = 4
      Width = 99
      Height = 17
      Caption = 'Masters && GMs'
      TabOrder = 6
    end
    object CheckBox8: TCheckBox
      Tag = 8
      Left = 152
      Top = 22
      Width = 93
      Height = 17
      Caption = 'Club Managers'
      TabOrder = 7
    end
  end
end

object fCLSeek: TfCLSeek
  Left = 307
  Top = 274
  BorderStyle = bsDialog
  Caption = 'Seek Dialog'
  ClientHeight = 363
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 133
    Width = 426
    Height = 151
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object lblStyle: TLabel
      Left = 12
      Top = 12
      Width = 96
      Height = 13
      Caption = '&Style of game will be'
    end
    object lblRated: TLabel
      Left = 12
      Top = 40
      Width = 60
      Height = 13
      Caption = 'Game will be'
    end
    object lblColor: TLabel
      Left = 12
      Top = 66
      Width = 72
      Height = 13
      Caption = 'My color will be'
    end
    object lblMin: TLabel
      Left = 12
      Top = 92
      Width = 130
      Height = 13
      Caption = '&Minimum rating of opponent'
      FocusControl = edtMin
    end
    object lblMax: TLabel
      Left = 12
      Top = 120
      Width = 131
      Height = 13
      Caption = 'Ma&ximun rating of opponent'
      FocusControl = edtMax
    end
    object cbGameType: TComboBox
      Left = 120
      Top = 8
      Width = 168
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = TimeControlChange
      Items.Strings = (
        'Normal'
        'Crazy House'
        'Fischer Random'
        'Loser'#39's')
    end
    object pnlColor: TPanel
      Left = 120
      Top = 64
      Width = 264
      Height = 17
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      object rbWhite: TRadioButton
        Tag = 1
        Left = 0
        Top = 0
        Width = 65
        Height = 17
        Caption = '&White'
        TabOrder = 0
      end
      object rbBlack: TRadioButton
        Tag = -1
        Left = 70
        Top = 0
        Width = 49
        Height = 17
        Caption = '&Black'
        TabOrder = 1
      end
      object rbServer: TRadioButton
        Left = 134
        Top = 0
        Width = 130
        Height = 17
        Caption = '&Decided by the server'
        TabOrder = 2
      end
    end
    object edtMin: TEdit
      Left = 148
      Top = 88
      Width = 33
      Height = 21
      MaxLength = 5
      TabOrder = 2
      Text = '0'
      OnKeyPress = ControlKeyPress
    end
    object udMin: TUpDown
      Left = 181
      Top = 88
      Width = 15
      Height = 21
      Associate = edtMin
      Max = 9999
      TabOrder = 3
      Thousands = False
    end
    object edtMax: TEdit
      Left = 148
      Top = 116
      Width = 33
      Height = 21
      MaxLength = 5
      TabOrder = 4
      Text = '0'
      OnKeyPress = ControlKeyPress
    end
    object udMax: TUpDown
      Left = 181
      Top = 116
      Width = 15
      Height = 21
      Associate = edtMax
      Max = 9999
      TabOrder = 5
      Thousands = False
    end
    object pnlRated: TPanel
      Left = 120
      Top = 38
      Width = 135
      Height = 17
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 6
      object rbRated: TRadioButton
        Tag = 1
        Left = 0
        Top = 0
        Width = 55
        Height = 17
        Caption = '&Rated'
        TabOrder = 0
        OnClick = rbRatedClick
      end
      object rbUnrated: TRadioButton
        Left = 70
        Top = 0
        Width = 65
        Height = 17
        Caption = '&Unrated'
        TabOrder = 1
        OnClick = rbRatedClick
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 426
    Height = 133
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object lblAutoTimeOdds: TLabel
      Left = 90
      Top = 72
      Width = 264
      Height = 13
      Caption = '(server will automatically set odds on the base of ratings)'
    end
    object lblSeek: TLabel
      Left = 4
      Top = 2
      Width = 412
      Height = 30
      AutoSize = False
      Caption = 
        'Seeks issued will be displayed in the Seeks frame. When another ' +
        'player clicks your posted seek a game will automatically begin.'
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
    object lblInital: TLabel
      Left = 14
      Top = 44
      Width = 52
      Height = 13
      Caption = 'Initial time: '
      FocusControl = edtInitial
    end
    object lblInc: TLabel
      Left = 249
      Top = 46
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = 'sec plus'
      FocusControl = edtInc
    end
    object Label2: TLabel
      Left = 176
      Top = 46
      Width = 16
      Height = 13
      Caption = 'min'
    end
    object Label6: TLabel
      Left = 348
      Top = 41
      Width = 44
      Height = 26
      Caption = 'seconds '#13#10'per move'
    end
    object sbTimeChange: TSpeedButton
      Left = 388
      Top = 68
      Width = 23
      Height = 22
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333303333
        333333333330333333333333330C033333333333330C03333333333330CCC033
        3333333330CCC033333333330000000333333333330C033333333333330C0333
        33333333000000033333333330CCC0333333333330CCC03333333333330C0333
        33333333330C0333333333333330333333333333333033333333}
      Visible = False
      OnClick = sbTimeChangeClick
    end
    object lblOpponent: TLabel
      Left = 14
      Top = 10
      Width = 47
      Height = 13
      Caption = 'Opponent'
      Visible = False
    end
    object chkTimeOdds: TCheckBox
      Left = 14
      Top = 70
      Width = 73
      Height = 17
      Caption = 'Time Odds'
      TabOrder = 0
      OnClick = chkTimeOddsClick
    end
    object pnlTimeOdds: TPanel
      Left = 6
      Top = 90
      Width = 403
      Height = 33
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object Label1: TLabel
        Left = 6
        Top = 10
        Width = 108
        Height = 13
        Caption = 'Opponent'#39's initial time: '
        FocusControl = edtOddsInitMin
      end
      object Label4: TLabel
        Left = 170
        Top = 10
        Width = 16
        Height = 13
        Caption = 'min'
      end
      object Label5: TLabel
        Left = 242
        Top = 12
        Width = 39
        Height = 13
        Caption = 'sec plus'
      end
      object Label3: TLabel
        Left = 340
        Top = 3
        Width = 44
        Height = 26
        Caption = 'seconds '#13#10'per move'
      end
      object edtOddsInitMin: TEdit
        Left = 118
        Top = 8
        Width = 33
        Height = 21
        Enabled = False
        MaxLength = 3
        TabOrder = 0
        Text = '20'
        OnChange = TimeControlChange
        OnKeyPress = ControlKeyPress
      end
      object udOddsInitMin: TUpDown
        Left = 151
        Top = 8
        Width = 15
        Height = 21
        Associate = edtOddsInitMin
        Enabled = False
        Max = 999
        Position = 20
        TabOrder = 1
        Thousands = False
        OnChanging = TimeControlChanging
      end
      object edtOddsInitSec: TEdit
        Left = 190
        Top = 8
        Width = 33
        Height = 21
        Enabled = False
        MaxLength = 3
        TabOrder = 2
        Text = '0'
        OnChange = TimeControlChange
        OnKeyPress = ControlKeyPress
      end
      object udOddsInitSec: TUpDown
        Left = 223
        Top = 8
        Width = 15
        Height = 21
        Associate = edtOddsInitSec
        Enabled = False
        Max = 59
        TabOrder = 3
        Thousands = False
        OnChanging = TimeControlChanging
      end
      object edtOddsInc: TEdit
        Left = 286
        Top = 8
        Width = 33
        Height = 21
        Enabled = False
        MaxLength = 3
        TabOrder = 4
        Text = '0'
        OnChange = TimeControlChange
        OnKeyPress = ControlKeyPress
      end
      object udOddsInc: TUpDown
        Left = 319
        Top = 8
        Width = 15
        Height = 21
        Associate = edtOddsInc
        Enabled = False
        Max = 999
        TabOrder = 5
        Thousands = False
        OnChanging = TimeControlChanging
      end
    end
    object edtInitial: TEdit
      Left = 124
      Top = 42
      Width = 33
      Height = 21
      MaxLength = 3
      TabOrder = 2
      Text = '20'
      OnChange = TimeControlChange
      OnKeyPress = ControlKeyPress
    end
    object udInitial: TUpDown
      Left = 157
      Top = 42
      Width = 15
      Height = 21
      Associate = edtInitial
      Max = 999
      Position = 20
      TabOrder = 3
      Thousands = False
      OnChanging = TimeControlChanging
    end
    object edtInc: TEdit
      Left = 292
      Top = 44
      Width = 33
      Height = 21
      MaxLength = 3
      TabOrder = 4
      Text = '0'
      OnChange = TimeControlChange
      OnKeyPress = ControlKeyPress
    end
    object udInc: TUpDown
      Left = 325
      Top = 44
      Width = 15
      Height = 21
      Associate = edtInc
      Max = 999
      TabOrder = 5
      Thousands = False
      OnChanging = TimeControlChanging
    end
    object edtInitSec: TEdit
      Left = 196
      Top = 42
      Width = 33
      Height = 21
      MaxLength = 3
      TabOrder = 6
      Text = '0'
      OnChange = TimeControlChange
      OnKeyPress = ControlKeyPress
    end
    object udInitSec: TUpDown
      Left = 229
      Top = 42
      Width = 15
      Height = 21
      Associate = edtInitSec
      Max = 59
      TabOrder = 7
      Thousands = False
      OnChanging = TimeControlChanging
    end
    object edtOpponent: TEdit
      Left = 124
      Top = 6
      Width = 161
      Height = 21
      TabOrder = 8
      Visible = False
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 284
    Width = 426
    Height = 41
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object cmbPieceOdds: TComboBox
      Left = 92
      Top = 10
      Width = 115
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      Items.Strings = (
        'Pawn'
        'Knight'
        'Bishop'
        'Rook'
        'Queen')
    end
    object chkPieceOdds: TCheckBox
      Left = 10
      Top = 12
      Width = 77
      Height = 17
      Caption = 'Piece Odds'
      TabOrder = 1
      OnClick = chkPieceOddsClick
    end
    object pnlPieceOddsDirection: TPanel
      Left = 278
      Top = 4
      Width = 143
      Height = 31
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object rbPieceOddsGive: TRadioButton
        Left = 6
        Top = 8
        Width = 67
        Height = 17
        Caption = 'You give'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object rbPieceOddsAsk: TRadioButton
        Left = 74
        Top = 8
        Width = 60
        Height = 17
        Caption = 'You ask'
        TabOrder = 1
      end
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 325
    Width = 426
    Height = 38
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 3
    DesignSize = (
      426
      38)
    object btnIssue: TButton
      Left = 261
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Issue Seek'
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = btnIssueClick
    end
    object btnCancel: TButton
      Left = 343
      Top = 7
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end

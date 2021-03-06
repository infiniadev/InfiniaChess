object fCLBoard: TfCLBoard
  Tag = 11
  Left = 460
  Top = 225
  BorderStyle = bsNone
  Caption = 'Board'
  ClientHeight = 375
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  PopupMenu = pupGameMenu
  OnClose = FormClose
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnMouseWheel = FormMouseWheel
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDetails: TPanel
    Left = 303
    Top = 0
    Width = 160
    Height = 375
    Align = alRight
    FullRepaint = False
    TabOrder = 0
    DesignSize = (
      160
      375)
    object lblWhtName: TLabel
      Left = 4
      Top = 298
      Width = 153
      Height = 16
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = 'White'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object lblWhtRating: TLabel
      Left = 4
      Top = 317
      Width = 33
      Height = 16
      Anchors = [akLeft, akBottom]
      Caption = '2500'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object WC: TCLClock
      Left = 4
      Top = 337
      Width = 111
      Height = 32
      Anchors = [akLeft, akRight, akBottom]
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Sibling = BC
      SoundEnabled = False
      SoundLimit = 1
    end
    object BC: TCLClock
      Left = 4
      Top = 64
      Width = 111
      Height = 33
      Color = clAqua
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -24
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Sibling = WC
      SoundEnabled = False
      SoundLimit = 1
    end
    object lblBlkName: TLabel
      Left = 4
      Top = 22
      Width = 153
      Height = 16
      AutoSize = False
      Caption = 'Black'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
    end
    object lblBlkRating: TLabel
      Left = 4
      Top = 42
      Width = 33
      Height = 16
      Caption = '2500'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object sbBack10: TSpeedButton
      Tag = -10
      Left = 48
      Top = 273
      Width = 22
      Height = 22
      Hint = 'Back 10'
      Anchors = [akLeft, akBottom]
      Caption = '<<'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = MoveButtonClick
    end
    object sbBack: TSpeedButton
      Tag = -1
      Left = 70
      Top = 273
      Width = 22
      Height = 22
      Hint = 'Back 1'
      Anchors = [akLeft, akBottom]
      Caption = '<'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = MoveButtonClick
    end
    object sbRevert: TSpeedButton
      Left = 92
      Top = 273
      Width = 22
      Height = 22
      Hint = 'Revert'
      Anchors = [akLeft, akBottom]
      Caption = '!'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = MoveButtonClick
    end
    object sbForward: TSpeedButton
      Tag = 1
      Left = 114
      Top = 273
      Width = 22
      Height = 22
      Hint = 'Forward 1'
      Anchors = [akLeft, akBottom]
      Caption = '>'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = MoveButtonClick
    end
    object sbForward10: TSpeedButton
      Tag = 10
      Left = 136
      Top = 273
      Width = 22
      Height = 22
      Hint = 'Forward 10'
      Anchors = [akLeft, akBottom]
      Caption = '>>'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      OnClick = MoveButtonClick
    end
    object sbClose: TSpeedButton
      Tag = 6
      Left = 143
      Top = 1
      Width = 16
      Height = 16
      Hint = 'Close Game'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
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
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = miCloseClick
    end
    object bvlDetail: TBevel
      Left = 4
      Top = 18
      Width = 154
      Height = 2
      Shape = bsTopLine
    end
    object sbMax: TSpeedButton
      Left = 126
      Top = 1
      Width = 16
      Height = 16
      Hint = 'Maximize / Restore'
      Flat = True
      Glyph.Data = {
        42030000424D42030000000000003600000028000000110000000F0000000100
        1800000000000C03000000000000000000000000000000000000C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D400
        0000000000000000000000000000000000000000000000000000C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0
        D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400
        0000C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4000000C8D0
        D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000000000000000C8D0D4C8
        D0D4C8D0D400C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D4C8D0D4C8D0D4000000C8D0D4000000C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4
        C8D0D4000000000000000000000000000000000000000000000000000000C8D0
        D4000000C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000
        C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0
        D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D4C8D0D4
        C8D0D4C8D0D4C8D0D4000000C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4000000000000000000000000000000000000000000000000000000
        C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0
        D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D400C8D0D4C8D0D4C8D0D4C8D0D4C8D0
        D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8D0D4C8
        D0D4C8D0D400}
      OnClick = sbMaxClick
    end
    object lblUpScore: TLabel
      Left = 60
      Top = 42
      Width = 93
      Height = 16
      Hint = 'Your personal score with this player'
      Alignment = taRightJustify
      AutoSize = False
      Caption = '+250 -88 =10'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object lblDownScore: TLabel
      Left = 60
      Top = 316
      Width = 93
      Height = 16
      Hint = 'Your personal score with this player'
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      AutoSize = False
      Caption = '+250 -88 =10'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      Visible = False
    end
    object lvMoves: TListView
      Left = 4
      Top = 100
      Width = 154
      Height = 166
      Anchors = [akLeft, akTop, akBottom]
      Columns = <
        item
          Caption = '#'
          Width = 26
        end
        item
          Caption = 'White'
          Width = 54
        end
        item
          Caption = 'Black'
          Width = 54
        end>
      ColumnClick = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ReadOnly = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      OnKeyDown = lvMovesKeyDown
    end
    object pnlCircle: TPanel
      Left = 2
      Top = 273
      Width = 22
      Height = 22
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      Color = clScrollBar
      TabOrder = 1
      DesignSize = (
        22
        22)
      object sbCircle: TSpeedButton
        Left = 2
        Top = 2
        Width = 18
        Height = 18
        Hint = 'Draw Circle'
        AllowAllUp = True
        Anchors = [akLeft, akBottom]
        GroupIndex = 1
        Caption = 'C'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        PopupMenu = pmColor
        Transparent = False
        OnClick = sbCircleClick
      end
    end
    object pnlArrow: TPanel
      Left = 26
      Top = 273
      Width = 22
      Height = 22
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      Color = clScrollBar
      TabOrder = 2
      DesignSize = (
        22
        22)
      object sbArrow: TSpeedButton
        Left = 2
        Top = 2
        Width = 18
        Height = 18
        Hint = 'Draw Line'
        AllowAllUp = True
        Anchors = [akLeft, akBottom]
        GroupIndex = 1
        Caption = 'L'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        PopupMenu = pmColor
        Transparent = False
        OnClick = sbArrowClick
      end
    end
    object pnlLagWhite: TPanel
      Left = 116
      Top = 337
      Width = 41
      Height = 32
      Anchors = [akRight, akBottom]
      BevelOuter = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      object lblLagWhite: TLabel
        Left = 2
        Top = 2
        Width = 18
        Height = 13
        Caption = 'Lag'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lblLagValueWhite: TLabel
        Left = 2
        Top = 16
        Width = 36
        Height = 13
        AutoSize = False
        Caption = '0'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
    end
    object pnlLagBlack: TPanel
      Left = 116
      Top = 65
      Width = 41
      Height = 32
      Anchors = [akTop, akRight]
      BevelOuter = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      object lblLagBlack: TLabel
        Left = 2
        Top = 2
        Width = 18
        Height = 13
        Caption = 'Lag'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lblLagValueBlack: TLabel
        Left = 2
        Top = 16
        Width = 36
        Height = 13
        AutoSize = False
        Caption = '0'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
    end
  end
  object pnlSetup: TPanel
    Left = 141
    Top = 0
    Width = 162
    Height = 375
    Align = alRight
    FullRepaint = False
    TabOrder = 1
    Visible = False
    object lblColor: TLabel
      Left = 4
      Top = 56
      Width = 65
      Height = 13
      Caption = 'Color to move'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object lblCastle: TLabel
      Left = 4
      Top = 96
      Width = 57
      Height = 13
      Caption = 'Castle rights'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object lblEnpassant: TLabel
      Left = 4
      Top = 196
      Width = 115
      Height = 13
      Caption = 'Enpassant target square'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object sbEnpassant: TSpeedButton
      Left = 8
      Top = 216
      Width = 23
      Height = 22
      AllowAllUp = True
      GroupIndex = 2
      Caption = 'EP'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblEpTarget: TLabel
      Left = 40
      Top = 220
      Width = 69
      Height = 13
      Caption = 'None selected'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblRepetable: TLabel
      Left = 4
      Top = 244
      Width = 114
      Height = 13
      Caption = 'Repeatable move count'
      FocusControl = udPly
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentFont = False
    end
    object sbMax2: TSpeedButton
      Left = 127
      Top = 1
      Width = 16
      Height = 16
      Hint = 'Maximize / Restore'
      Flat = True
      OnClick = sbMaxClick
    end
    object sbClose2: TSpeedButton
      Tag = 6
      Left = 143
      Top = 1
      Width = 16
      Height = 16
      Hint = 'Close Game'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = miCloseClick
    end
    object bvlSetup: TBevel
      Left = 4
      Top = 18
      Width = 154
      Height = 2
      Shape = bsTopLine
    end
    object rbWhite: TRadioButton
      Left = 8
      Top = 76
      Width = 60
      Height = 17
      Caption = 'White'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      TabStop = True
      OnClick = SetSetupRights
    end
    object rbBlack: TRadioButton
      Left = 72
      Top = 76
      Width = 60
      Height = 17
      Caption = 'Black'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      TabStop = True
      OnClick = SetSetupRights
    end
    object cbWKS: TCheckBox
      Tag = 8
      Left = 8
      Top = 116
      Width = 128
      Height = 17
      Caption = 'White king side'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = SetSetupRights
    end
    object cbWQS: TCheckBox
      Tag = 4
      Left = 8
      Top = 136
      Width = 128
      Height = 17
      Caption = 'White queen side'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = SetSetupRights
    end
    object cbBKS: TCheckBox
      Tag = 2
      Left = 8
      Top = 156
      Width = 128
      Height = 17
      Caption = 'Black king side'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      OnClick = SetSetupRights
    end
    object cbBQS: TCheckBox
      Tag = 1
      Left = 8
      Top = 176
      Width = 128
      Height = 17
      Caption = 'Black queen side'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = SetSetupRights
    end
    object edtPly: TEdit
      Left = 8
      Top = 264
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Text = '0'
      OnChange = SetSetupRights
    end
    object udPly: TUpDown
      Left = 49
      Top = 264
      Width = 12
      Height = 21
      Associate = edtPly
      Max = 49
      TabOrder = 8
    end
    object btnCancel: TButton
      Left = 4
      Top = 292
      Width = 75
      Height = 25
      Caption = '&Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = btnCancelClick
    end
    object bntAccept: TButton
      Left = 84
      Top = 292
      Width = 75
      Height = 25
      Caption = '&Accept'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      OnClick = bntAcceptClick
    end
    object btnClear: TButton
      Left = 4
      Top = 24
      Width = 75
      Height = 25
      Caption = 'C&lear board'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnClearClick
    end
    object btnReset: TButton
      Left = 84
      Top = 24
      Width = 75
      Height = 25
      Caption = '&Reset Board'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      OnClick = btnResetClick
    end
  end
  object pupGameMenu: TPopupMenu
    OnPopup = pupGameMenuPopup
    Left = 60
    Top = 59
    object miAbort: TMenuItem
      Caption = 'A&bort'
      Enabled = False
      ShortCut = 49218
      OnClick = miAbortClick
    end
    object miAdjourn: TMenuItem
      Caption = 'Adj&ourn'
      Enabled = False
      ShortCut = 49217
      OnClick = miAdjournClick
    end
    object miDraw: TMenuItem
      Caption = '&Draw'
      Enabled = False
      ShortCut = 49220
      OnClick = miDrawClick
    end
    object miFlag: TMenuItem
      Caption = 'F&lag'
      Enabled = False
      ShortCut = 49222
      OnClick = miFlagClick
    end
    object miResign: TMenuItem
      Caption = 'R&esign'
      Enabled = False
      ShortCut = 49221
      OnClick = miResignClick
    end
    object miTakeback: TMenuItem
      Caption = '&Takeback...'
      Enabled = False
      ShortCut = 49236
      OnClick = miTakebackClick
    end
    object miMoretime: TMenuItem
      Caption = '&Moretime...'
      Enabled = False
      ShortCut = 49229
      OnClick = miMoretimeClick
    end
    object miRematch: TMenuItem
      Caption = 'Rematc&h...'
      Enabled = False
      ShortCut = 49234
      OnClick = miRematchClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miAutoQueen: TMenuItem
      Caption = 'Auto &Queen'
      ShortCut = 16465
      OnClick = miAutoQueenClick
    end
    object miLogGame: TMenuItem
      Caption = '&Log Game'
      Enabled = False
      ShortCut = 16460
      OnClick = miLogGameClick
    end
    object miCaptured: TMenuItem
      Caption = 'Captur&ed Pieces'
      ShortCut = 16453
      OnClick = miCapturedClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miSetup: TMenuItem
      Caption = 'Se&tup Position'
      Enabled = False
      ShortCut = 16468
      OnClick = miSetupClick
    end
    object miPasteFEN: TMenuItem
      Caption = '&Paste FEN'
      Enabled = False
      ShortCut = 16470
      OnClick = miPasteFENClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object miCopy: TMenuItem
      Caption = 'Create &Copy'
      ShortCut = 16451
      OnClick = miCopyClick
    end
    object miRotate: TMenuItem
      Caption = '&Rotate Board'
      ShortCut = 16466
      OnClick = miRotateClick
    end
    object miGameSave: TMenuItem
      Caption = 'Save To PGN'
      Enabled = False
      ShortCut = 16467
      OnClick = miGameSaveClick
    end
    object miLibrary: TMenuItem
      Caption = 'Add to Library'
      Enabled = False
      ShortCut = 16457
      OnClick = miLibraryClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object miClose: TMenuItem
      Caption = '&Close Game'
      ShortCut = 16499
      OnClick = miCloseClick
    end
    object miDetach: TMenuItem
      Caption = '&Detach from Server'
      Enabled = False
      OnClick = miDetachClick
    end
  end
  object pmColor: TPopupMenu
    Images = fCLMain.ilArrowCirleColors
    Left = 144
    Top = 58
  end
end

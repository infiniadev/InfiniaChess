object fCLPaymentEdit: TfCLPaymentEdit
  Left = 433
  Top = 247
  Caption = 'Payment'
  ClientHeight = 387
  ClientWidth = 453
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel5: TPanel
    Left = 0
    Top = 352
    Width = 453
    Height = 35
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      453
      35)
    object Panel10: TPanel
      Left = 381
      Top = 4
      Width = 69
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object SpeedButton3: TSpeedButton
        Left = 0
        Top = 0
        Width = 69
        Height = 29
        Caption = 'Close'
        Flat = True
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        OnClick = SpeedButton3Click
      end
    end
    object Panel11: TPanel
      Left = 321
      Top = 4
      Width = 57
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object sbOk: TSpeedButton
        Left = 0
        Top = 0
        Width = 57
        Height = 29
        AllowAllUp = True
        Caption = 'Ok'
        Flat = True
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000010000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        OnClick = sbOkClick
      end
    end
    object Panel6: TPanel
      Left = 5
      Top = 2
      Width = 80
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object sbState: TSpeedButton
        Left = 0
        Top = 0
        Width = 80
        Height = 29
        AllowAllUp = True
        Caption = 'Delete'
        Flat = True
        NumGlyphs = 2
        OnClick = sbStateClick
      end
    end
  end
  object cmbRights: TPanel
    Left = 0
    Top = 0
    Width = 453
    Height = 352
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      453
      352)
    object Label9: TLabel
      Left = 6
      Top = 204
      Width = 84
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Admin Comments:'
    end
    object reComments: TRichEdit
      Left = 6
      Top = 223
      Width = 438
      Height = 72
      Anchors = [akLeft, akRight, akBottom]
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 6
      Top = 133
      Width = 440
      Height = 67
      Anchors = [akLeft, akRight, akBottom]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      DesignSize = (
        440
        67)
      object Label10: TLabel
        Left = 10
        Top = 8
        Width = 74
        Height = 13
        Caption = 'Name on Card: '
      end
      object lblNameOnCard: TLabel
        Left = 86
        Top = 8
        Width = 134
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lblNameOnCard'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label11: TLabel
        Left = 16
        Top = 26
        Width = 64
        Height = 13
        Caption = 'Type of Card:'
      end
      object lblCardType: TLabel
        Left = 86
        Top = 26
        Width = 68
        Height = 13
        Caption = 'lblCardType'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 16
        Top = 44
        Width = 65
        Height = 13
        Caption = 'Card Number:'
      end
      object lblCardNumber: TLabel
        Left = 86
        Top = 44
        Width = 83
        Height = 13
        Caption = 'lblCardNumber'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label12: TLabel
        Left = 264
        Top = 12
        Width = 61
        Height = 13
        Caption = 'Promo Code:'
      end
      object Label14: TLabel
        Left = 240
        Top = 34
        Width = 84
        Height = 13
        Caption = 'Promo Amount ($)'
      end
      object lblPromoCode: TLabel
        Left = 334
        Top = 12
        Width = 78
        Height = 13
        Caption = 'lblPromoCode'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblPromoAmount: TLabel
        Left = 334
        Top = 34
        Width = 26
        Height = 13
        Caption = '0.00'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlEditableData: TPanel
      Left = 6
      Top = 62
      Width = 440
      Height = 67
      Anchors = [akLeft, akRight, akBottom]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      DesignSize = (
        440
        67)
      object Label7: TLabel
        Left = 289
        Top = 38
        Width = 58
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Full Price ($)'
      end
      object Label8: TLabel
        Left = 277
        Top = 12
        Width = 71
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'Money Paid ($)'
      end
      object Label5: TLabel
        Left = 14
        Top = 12
        Width = 62
        Height = 13
        Caption = 'Rights Level:'
      end
      object lblExpire: TLabel
        Left = 14
        Top = 38
        Width = 58
        Height = 13
        Caption = 'Expire Date:'
      end
      object edtAmountFull: TEdit
        Left = 353
        Top = 34
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 0
      end
      object edtAmount: TEdit
        Left = 353
        Top = 8
        Width = 80
        Height = 21
        Anchors = [akTop, akRight]
        TabOrder = 1
      end
      object cmbRightsLevel: TComboBox
        Left = 82
        Top = 8
        Width = 101
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
        OnChange = cmbRightsLevelChange
      end
      object dtExpire: TDateTimePicker
        Left = 82
        Top = 34
        Width = 101
        Height = 21
        Date = 39981.774281863400000000
        Time = 39981.774281863400000000
        TabOrder = 3
      end
    end
    object Panel3: TPanel
      Left = 6
      Top = 6
      Width = 440
      Height = 51
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 3
      DesignSize = (
        440
        51)
      object lblID: TLabel
        Left = 28
        Top = 8
        Width = 27
        Height = 13
        Caption = 'lblID'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label1: TLabel
        Left = 10
        Top = 8
        Width = 17
        Height = 13
        Caption = 'ID: '
      end
      object Label3: TLabel
        Left = 10
        Top = 26
        Width = 26
        Height = 13
        Caption = 'Date:'
      end
      object lblDate: TLabel
        Left = 40
        Top = 26
        Width = 41
        Height = 13
        Caption = 'lblDate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSubscription_: TLabel
        Left = 262
        Top = 8
        Width = 86
        Height = 13
        Caption = 'Web Membership:'
      end
      object lblSubscription: TLabel
        Left = 351
        Top = 8
        Width = 84
        Height = 13
        Alignment = taRightJustify
        Anchors = [akLeft, akTop, akRight]
        Caption = 'lblSubscription'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSource_: TLabel
        Left = 328
        Top = 26
        Width = 37
        Height = 13
        Caption = 'Source:'
      end
      object lblSource: TLabel
        Left = 379
        Top = 26
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Anchors = [akLeft, akTop, akRight]
        Caption = 'lblSource'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object Panel4: TPanel
      Left = 6
      Top = 300
      Width = 438
      Height = 53
      Anchors = [akLeft, akRight, akBottom]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 4
      DesignSize = (
        438
        53)
      object Label16: TLabel
        Left = 10
        Top = 6
        Width = 72
        Height = 13
        Caption = 'Admin Created:'
      end
      object lblAdminCreated: TLabel
        Left = 86
        Top = 6
        Width = 92
        Height = 13
        Caption = 'lblAdminCreated'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label17: TLabel
        Left = 10
        Top = 28
        Width = 72
        Height = 13
        Caption = 'Admin Deleted:'
      end
      object lblAdminDeleted: TLabel
        Left = 86
        Top = 28
        Width = 92
        Height = 13
        Caption = 'lblAdminDeleted'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblTransactionState: TLabel
        Left = 258
        Top = 18
        Width = 174
        Height = 19
        Alignment = taRightJustify
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'Transaction is actual'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
end

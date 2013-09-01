object fCLCLubOptions: TfCLCLubOptions
  Left = 292
  Top = 155
  Caption = 'Club Options'
  ClientHeight = 345
  ClientWidth = 318
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  DesignSize = (
    318
    345)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 318
    Height = 315
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 0
    OnChange = ControlChanged
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Label1: TLabel
        Left = 4
        Top = 4
        Width = 52
        Height = 13
        Caption = 'Club Name'
      end
      object Label2: TLabel
        Left = 4
        Top = 46
        Width = 39
        Height = 13
        Caption = 'Sponsor'
      end
      object Panel10: TPanel
        Left = 4
        Top = 116
        Width = 105
        Height = 165
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        DesignSize = (
          105
          165)
        object Label26: TLabel
          Left = 2
          Top = 142
          Width = 101
          Height = 13
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = '96x96'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object btnPhoto: TBitBtn
          Left = 18
          Top = 108
          Width = 64
          Height = 25
          Caption = 'Logo'
          TabOrder = 0
          OnClick = btnPhotoClick
        end
        object pnlPhoto: TPanel
          Left = 4
          Top = 4
          Width = 96
          Height = 96
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Caption = 'NO LOGO'
          TabOrder = 1
          object imgPhoto: TImage
            Left = 2
            Top = 2
            Width = 92
            Height = 92
            Align = alClient
          end
        end
      end
      object edtClubName: TEdit
        Left = 4
        Top = 22
        Width = 225
        Height = 21
        ReadOnly = True
        TabOrder = 1
        Text = 'club name'
        OnChange = ControlChanged
      end
      object chkRequests: TCheckBox
        Left = 4
        Top = 96
        Width = 97
        Height = 17
        Caption = 'Allow Requests'
        TabOrder = 2
        OnClick = ControlChanged
      end
      object edtSponsor: TEdit
        Left = 4
        Top = 64
        Width = 223
        Height = 21
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Information'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object reInformation: TRichEdit
        Left = 0
        Top = 0
        Width = 310
        Height = 287
        Align = alClient
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Comic Sans MS'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = reInformationChange
      end
    end
  end
  object btnOK: TButton
    Left = 86
    Top = 322
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 164
    Top = 322
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnApply: TButton
    Left = 240
    Top = 322
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Apply'
    Enabled = False
    TabOrder = 3
    OnClick = btnApplyClick
  end
  object odPhoto: TOpenDialog
    Filter = 'BMP files|*.bmp|JPEG files|*.jpg'
    FilterIndex = 2
    Top = 316
  end
end

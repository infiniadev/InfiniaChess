object fCLVideo: TfCLVideo
  Left = 448
  Top = 340
  Width = 265
  Height = 238
  BorderIcons = [biSystemMenu]
  Caption = 'urise (P)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 257
    Height = 176
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object VideoWindow: TVideoWindow
      Left = 2
      Top = 2
      Width = 253
      Height = 172
      Mode = vmVMR
      FilterGraph = FilterGraph
      VMROptions.Mode = vmrWindowed
      VMROptions.Streams = 1
      Color = clBlack
      Align = alClient
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 176
    Width = 257
    Height = 35
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object chkBroadCast: TCheckBox
      Left = 8
      Top = 8
      Width = 97
      Height = 17
      Caption = 'Broadcast'
      TabOrder = 0
      OnClick = btnPlayClick
    end
    object btnPlay: TBitBtn
      Left = 176
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Play'
      TabOrder = 1
      OnClick = btnPlayClick
    end
    object BitBtn1: TBitBtn
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = 'BitBtn1'
      TabOrder = 2
      OnClick = BitBtn1Click
    end
  end
  object FilterGraph: TFilterGraph
    AutoCreate = True
    Mode = gmCapture
    GraphEdit = False
    LinearVolume = True
    Left = 42
    Top = 22
  end
  object FilterSource: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = FilterGraph
    Left = 126
    Top = 22
  end
  object FilterDivX: TFilter
    BaseFilter.data = {
      8200000037D415438C5BD011BD3B00A0C911CE866E0000004000640065007600
      6900630065003A0063006D003A007B0033003300440039004100370036003000
      2D0039003000430038002D0031003100440030002D0042004400340033002D00
      3000300041003000430039003100310043004500380036007D005C0064006900
      760078000000}
    FilterGraph = FilterGraph
    Left = 42
    Top = 82
  end
  object SampleGrabber: TSampleGrabber
    FilterGraph = FilterGraph
    MediaType.data = {
      7669647300001000800000AA00389B717DEB36E44F52CE119F530020AF0BA770
      FFFFFFFF0000000001000000809F580556C3CE11BF0100AA0055595A00000000
      0000000000000000}
    Left = 130
    Top = 86
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 202
    Top = 18
  end
  object ASFWriter: TASFWriter
    FilterGraph = FilterGraph
    Profile = wmp_V80_56VideoOnly
    FileName = 'd:\tmp.asf'
    Port = 3333
    MaxUsers = 8
    Left = 206
    Top = 86
  end
end

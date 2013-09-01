object fCLOdds: TfCLOdds
  Left = 697
  Top = 265
  Caption = 'Odds'
  ClientHeight = 392
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lv: TListView
    Left = 0
    Top = 0
    Width = 326
    Height = 245
    Align = alClient
    Columns = <
      item
        Caption = 'Rating'
        Width = 70
      end
      item
        Caption = 'Initial Time'
        Width = 70
      end
      item
        Caption = 'IncTime'
      end
      item
        Caption = 'P'
        Width = 0
      end
      item
        Caption = 'R'
        Width = 0
      end
      item
        Caption = 'Pieces'
        Width = 120
      end>
    GridLines = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvClick
    OnKeyUp = lvKeyUp
    ExplicitHeight = 252
  end
  object Panel1: TPanel
    Left = 0
    Top = 245
    Width = 326
    Height = 112
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      326
      112)
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 31
      Height = 13
      Caption = 'Rating'
    end
    object sbAdd: TSpeedButton
      Left = 209
      Top = 24
      Width = 23
      Height = 22
      Anchors = [akRight, akBottom]
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888800008
        88888888888777788888800000009900088887777777FF77788880FFFFF0990F
        088887888887FF78788880FF00009900008887887777FF77778880FF09999999
        908887887FFFFFFFF78880FF09999999908887887FFFFFFFF78880FF00009900
        008887887777FF77778880F0FFF0990F088887878887FF78788880FFFFF0990F
        088887888887FF78788880F0F0F0000F0888878787877778788880FFFFFFFFFF
        0888878888888888788880F000F0FFFF0888878777878888788880FFFFFFF000
        0888878888888777788880F000FFF0808888878777888787888880FFFFFFF008
        8888878888888778888880000000008888888777777777888888}
      NumGlyphs = 2
      OnClick = sbAddClick
    end
    object img: TImage
      Left = 8
      Top = 52
      Width = 201
      Height = 51
      OnMouseDown = imgMouseDown
    end
    object sbDelete: TSpeedButton
      Left = 233
      Top = 24
      Width = 23
      Height = 22
      Anchors = [akRight, akBottom]
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        888888888888888888888000000000000888877777777777788880FFFFFFFFFF
        0888878888888888788880FFFFFFFFFF0888878888888888788880FF00000000
        0088878877777777778880FF09999999908887887FFFFFFFF78880FF09999999
        908887887FFFFFFFF78880FF000000000088878877777777778880FFFFFFFFFF
        0888878888888888788880F0F00F000F0888878787787778788880FFFFFFFFFF
        0888878888888888788880F000F0FFFF0888878777878888788880FFFFFFF000
        0888878888888777788880F000FFF0808888878777888787888880FFFFFFF008
        8888878888888778888880000000008888888777777777888888}
      NumGlyphs = 2
      OnClick = sbDeleteClick
    end
    object sbDimension: TSpeedButton
      Left = 116
      Top = 24
      Width = 23
      Height = 22
      Caption = 'M'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = sbDimensionClick
    end
    object edRating: TEdit
      Left = 8
      Top = 24
      Width = 41
      Height = 21
      TabOrder = 0
      Text = '1,600'
    end
    object edInitTime: TEdit
      Left = 68
      Top = 24
      Width = 29
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '2'
    end
    object edIncTime: TEdit
      Left = 144
      Top = 24
      Width = 45
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = '12'
    end
    object udIncTime: TUpDown
      Left = 189
      Top = 24
      Width = 15
      Height = 21
      Associate = edIncTime
      Enabled = False
      Max = 1000
      Position = 12
      TabOrder = 3
    end
    object udInitTime: TUpDown
      Left = 97
      Top = 24
      Width = 16
      Height = 21
      Associate = edInitTime
      Enabled = False
      Max = 1000
      Position = 2
      TabOrder = 4
    end
    object udRating: TUpDown
      Left = 49
      Top = 24
      Width = 15
      Height = 21
      Associate = edRating
      Max = 3000
      Increment = 100
      Position = 1600
      TabOrder = 5
    end
    object cbInitTime: TCheckBox
      Left = 68
      Top = 8
      Width = 65
      Height = 17
      Caption = 'Init Time'
      TabOrder = 6
      OnClick = cbInitTimeClick
    end
    object cbIncTime: TCheckBox
      Left = 144
      Top = 8
      Width = 65
      Height = 17
      Caption = 'Inc Time'
      TabOrder = 7
      OnClick = cbIncTimeClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 357
    Width = 326
    Height = 35
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    DesignSize = (
      326
      35)
    object Panel3: TPanel
      Left = 195
      Top = 2
      Width = 57
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
      object SpeedButton2: TSpeedButton
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
        OnClick = SpeedButton2Click
      end
    end
    object Panel4: TPanel
      Left = 255
      Top = 2
      Width = 69
      Height = 29
      Anchors = [akTop, akRight]
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 1
      object SpeedButton3: TSpeedButton
        Left = 0
        Top = 0
        Width = 69
        Height = 29
        Caption = 'Cancel'
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
    object Panel5: TPanel
      Left = 3
      Top = 2
      Width = 58
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 2
      object SpeedButton1: TSpeedButton
        Left = 0
        Top = 0
        Width = 58
        Height = 29
        AllowAllUp = True
        Caption = 'Clear'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00500005000555
          555557777F777555F55500000000555055557777777755F75555005500055055
          555577F5777F57555555005550055555555577FF577F5FF55555500550050055
          5555577FF77577FF555555005050110555555577F757777FF555555505099910
          555555FF75777777FF555005550999910555577F5F77777775F5500505509990
          3055577F75F77777575F55005055090B030555775755777575755555555550B0
          B03055555F555757575755550555550B0B335555755555757555555555555550
          BBB35555F55555575F555550555555550BBB55575555555575F5555555555555
          50BB555555555555575F555555555555550B5555555555555575}
        NumGlyphs = 2
        OnClick = SpeedButton1Click
      end
    end
    object Panel6: TPanel
      Left = 63
      Top = 2
      Width = 66
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 3
      object SpeedButton4: TSpeedButton
        Left = -4
        Top = 0
        Width = 64
        Height = 29
        AllowAllUp = True
        Caption = 'Save'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888000000000000088877777777777778803300000088
          0308878877777788787880330000008803088788777777887878803300000088
          0308878877777788787880330000000003088788777777777878803333333333
          3308878888888888887880330000000033088788777777778878803088888888
          0308878788888888787880308888888803088787888888887878803088888888
          0308878788888888787880308888888803088787888888887878803088888888
          0008878788888888777880308888888808088787888888887878800000000000
          0008877777777777777888888888888888888888888888888888}
        NumGlyphs = 2
        OnClick = SpeedButton4Click
      end
    end
    object Panel7: TPanel
      Left = 125
      Top = 2
      Width = 66
      Height = 29
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 4
      object SpeedButton5: TSpeedButton
        Left = 0
        Top = 0
        Width = 64
        Height = 29
        AllowAllUp = True
        Caption = 'Open'
        Flat = True
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD00000000000D
          DDDD77777777777DDDDD003333333330DDDD778888888887DDDD0B0333333333
          0DDD7878888888887DDD0FB03333333330DD78878888888887DD0BFB03333333
          330D788878888888887D0FBFB0000000000778888777777777770BFBFBFBFB0D
          DDDD78888888887DDDDD0FBFBFBFBF0DDDDD78888888887DDDDD0BFB0000000D
          DDDD78887777777DDDDDD000DDDDDDDD000DD777DDDDDDDD777DDDDDDDDDDDDD
          D00DDDDDDDDDDDDDD77DDDDDDDDD0DDD0D0DDDDDDDDD7DDD7D7DDDDDDDDDD000
          DDDDDDDDDDDDD777DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD}
        NumGlyphs = 2
        OnClick = SpeedButton5Click
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'odd'
    Filter = 'Odds Files|*.odd|All Files|*.*'
    Left = 276
    Top = 268
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'odd'
    Filter = 'Odd Files|*.odd|All Files|*.*'
    Left = 276
    Top = 316
  end
end

object fSocket: TfSocket
  Left = 251
  Top = 148
  BorderStyle = bsNone
  Caption = 'Socket'
  ClientHeight = 313
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object csSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Host = 'chessclub.com'
    Port = 23
    OnLookup = csSocketLookup
    OnConnecting = csSocketConnecting
    OnConnect = csSocketConnect
    OnDisconnect = csSocketDisconnect
    OnRead = csSocketRead
    OnError = csSocketError
    Left = 16
    Top = 8
  end
end

unit CLSocketMM;

interface

uses
  Forms, Messages, SysUtils, Classes, Windows, winsock, ScktComp,
  CLGlobal, controls, Dialogs;

type
  TCLSocketMM = class
  private
    FSocket: TClientSocket;
    FAccepted: Boolean;

    procedure FSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure FSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;
    procedure Send(CMD: array of string);
    procedure AddThreadSendCommand(cmd: string); 
    property Accepted: Boolean read FAccepted write FAccepted;

  end;

var
  fCLSocketMM: TCLSocketMM;

implementation

uses CLMain, CLSocket, CLTerminal, CLConst, CLConsole, CLSocketMMThread;

{ TCLSocketMM }
//================================================================
procedure TCLSocketMM.AddThreadSendCommand(cmd: string);
begin
  fCLSocketMMThread.Suspend;
  fCLSocketMMThread.AddSendCommand(cmd);
  fCLSocketMMThread.Resume;
end;
//================================================================
procedure TCLSocketMM.Connect;
begin
  try
    with FSocket do begin
      if Active then Active := False;
      Host := fCLSocket.Account.Server;
      Port := CHESSLINK_PORT_MM;
      Active := True;
    end;
  except
    on E: Exception do
      begin
        fCLTerminal.ccConsole.AddLine(0, E.message, ltServerMsgNormal);
        Disconnect;
      end;
  end;
end;
//================================================================
constructor TCLSocketMM.Create;
begin
  FSocket := TClientSocket.Create(nil);
  FSocket.ClientType := ctBlocking;
  FSocket.OnConnect := FSocketConnect;
  FSocket.OnDisconnect := FSocketDisconnect;
end;
//================================================================
destructor TCLSocketMM.Destroy;
begin
  FSocket.Free;
  inherited;
end;
//================================================================
procedure TCLSocketMM.Disconnect;
begin
  //
end;
//================================================================
procedure TCLSocketMM.FSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  fCLSocketMMThread:=TCLSocketMMThread.Create(true);
  fCLSocketMMThread.SocketMM:=Self;
  fCLSocketMMThread.Socket:=Socket;
  fCLSocketMMThread.Init;
  fCLSocketMMThread.AddSendCommand(CMM_INITIALIZE+' '+fCLSocket.Account.Login);
  fCLSocketMMThread.Resume;
  //Self.Send([CMM_IDENTIFY,fCLSocket.Account.Login]);
end;
//================================================================
procedure TCLSocketMM.FSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin

end;
//================================================================
procedure TCLSocketMM.Send(CMD: array of string);
var
  Index: Integer;
  Data: string;
begin
  if not FSocket.Socket.Connected  then
    begin
      fCLTerminal.ccConsole.AddLine(0, 'Not connected to multimedia port of server', ltServerMsgError);
      fCLTerminal.ccConsole.EndUpdate;
    end
  else
    begin
      { Build the space delimited data to send. }
      Data := '';
      for Index := 0 to High(CMD) do
        Data := Data + CMD[Index] + #32;
      { !!! Don't use the Trim fuction. It strips control characters. }
      Index := Length(Data);
      if Index > 0 then Data[Index] := #10;

      //CLCrypt.Encrypt(Data);

      { Send the data }
      Index := Length(Data);
      if Index > 0 then AddThreadSendCommand(Data);
    end;

end;
//================================================================
end.

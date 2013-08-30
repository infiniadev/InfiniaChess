unit CSSocket2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IdTCPServer, IdThreadMgr, IdThreadMgrDefault, IdThreadMgrPool, IdBaseComponent,
  IdComponent, CSConnection;

type
  TSocket2 = class
    Server: TIdTcpServer;
    IdThreadMgrPool: TIdThreadMgrPool;
  private
    procedure ServerConnect(AThread: TIdPeerThread);
    procedure ServerExecute(AThread: TIdPeerThread);
    procedure ServerDisconnect(AThread: TIdPeerThread);
    procedure Parse(CMD: TStrings);
    procedure Send(AThread: TIdPeerThread; CMD: array of variant);
    procedure MMThreadLog(AThread: TIdPeerThread; Str: string);

    procedure CMD_Initialize(AThread: TIdPeerThread; slCMD: TStrings);
    procedure CMD_GetAllPhoto(AThread: TIdPeerThread; slCMD: TStrings);
    procedure CMD_PhotoSend(AThread: TIdPeerThread; slCMD: TStrings);

    procedure SendAllPhotoToMe(AThread: TIdPeerThread);

  public
    constructor Create;
    procedure SendMyPhotoToAll(myconn: TConnection);

    procedure CMD_MM(Connection: TConnection; slCMD: TStrings);
  end;

var
  fSocket2: TSocket2;

implementation

uses
  CSConst, CSLib, CSConnections, CSSocket;

{ TSocket2 }
//==========================================================================
procedure TSocket2.CMD_Initialize(AThread: TIdPeerThread; slCMD: TStrings);
var
  s,cmd,name: string;
  n,nCMD: integer;
  conn: TConnection;
begin
  if slCMD.Count<2 then exit;
  name:=slCMD[1];
  conn:=fConnections.GetConnection(name);
  AThread.Data:=conn;
  conn.Socket2Thread := AThread;
  Send(AThread, [DPM_INITIALIZED]);
  //SendMyPhotoToAll(conn);
  //s:=DPM_INITIALIZED+DP_END;
  //AThread.Connection.Writeln(s);
  //showmessage('Connected');
  //SendMyPhotoToAll;
  MMThreadLog(AThread, '================================');
  MMThreadLog(AThread, 'Socket initialized');
end;
//==========================================================================
constructor TSocket2.Create;
begin
  Server:=TIdTcpServer.Create(nil);
  IdThreadMgrPool:=TIdThreadMgrPool.Create(Server);
  //IdThreadMgrDefault:=TIdThreadMgrDefault.Create(Server);
  with Server do begin
    DefaultPort := PORT_MM;
    OnConnect := ServerConnect;
    OnDisconnect := ServerDisconnect;
    OnExecute := ServerExecute;
    ThreadMgr := IdThreadMgrPool;
    Active := MM_OPENED;
  end;
end;
//==========================================================================
procedure TSocket2.Parse(CMD: TStrings);
begin
  //
end;
//==========================================================================
procedure TSocket2.ServerConnect(AThread: TIdPeerThread);
begin
  MMThreadLog(AThread, 'Connected');
end;
//==========================================================================
procedure TSocket2.ServerDisconnect(AThread: TIdPeerThread);
var
  conn: TConnection;
begin
  conn:=TConnection(AThread.Data);
  if conn<>nil then begin
    conn.Socket2Thread := nil;
    AThread.Data := nil;
  end;
  MMThreadLog(AThread, 'Disconnected');
end;
//==========================================================================
procedure TSocket2.ServerExecute(AThread: TIdPeerThread);
var
  s,cmd: string;
  slCMD: TStringList;
  nCMD: integer;
begin
  try
    if not AThread.Terminated and AThread.Connection.Connected then begin
      //Sleep(30000);
      cmd:=AThread.Connection.ReadLn;
      if cmd='' then exit;
      MMThreadLog(AThread, '-> '+cmd);
      slCMD:=TStringList.Create;
      Str2StringList(cmd,slCMD,#32);
      try
        s:=slCMD[0];
        if copy(s,1,3)<>'cmm' then exit;
        try
          nCMD:=StrToInt(copy(s,4,length(s)));
        except
          exit;
        end;
        if (AThread.Data=nil) and (nCmd<>CMM_INITIALIZE) then exit;

        case nCMD of
          CMM_INITIALIZE: CMD_Initialize(AThread,slCMD);
          CMM_PHOTO: CMD_PhotoSend(AThread, slCMD);
          CMM_GET_ALL_PHOTO: CMD_GetAllPhoto(AThread,slCMD);
        else
          exit;
        end;
      finally
        slCMD.Free;
      end;
    end;
  except
    on E:Exception do begin
      ErrLog(' ('+IntToHex(integer(ExceptAddr),6)+'): '+cmd+'; '+E.Message,
        TConnection(AThread.Data),'ClientRead');
    end;
  end;
end;
//==========================================================================
procedure TSocket2.SendAllPhotoToMe(AThread: TIdPeerThread);
var
  i: integer;
  conn: TConnection;
  cs: LongWord;
begin
  //MMThreadLog('SendAllPhotoToMe');
  for i:=fConnections.Connections.Count-1 downto 0 do begin
    try
      conn:=TConnection(fConnections.Connections[i]);
    except
      conn:=nil;
    end;
    if conn=nil then continue;
    //MMThreadLog('  photo of '+conn.Handle);
    cs:=ControlSumm(conn.PhotoANSI);
    Send(AThread,[DPM_PHOTO, conn.Handle,'1', cs, conn.PhotoANSI]);
    MMThreadLog(AThread, 'Sending all photos...');
    MMThreadLog(AThread, Format('... %s; CS = %d; length = %d',[conn.Handle,cs,length(conn.PhotoANSI)]));
  end;
end;
//==========================================================================
procedure TSocket2.Send(AThread: TIdPeerThread; CMD: array of variant);
var
  s: string;
begin
  s:=AssembleSendCommand(CMD);
  MMThreadLog(AThread, '<- '+s);
  AThread.Connection.Writeln(s);
end;
//==========================================================================
procedure TSocket2.CMD_GetAllPhoto(AThread: TIdPeerThread; slCMD: TStrings);
begin
  SendAllPhotoToMe(AThread);
end;
//==========================================================================
procedure TSocket2.MMThreadLog(AThread: TIdPeerThread; Str: string);
var
  conn: TConnection;
  F: TextFile;
  s, filename: string;
begin
  if AThread = nil then s:='!!!'
  else begin
    conn:=TConnection(AThread.Data);
    if conn=nil then s:='!!!'
    else s:=conn.Handle;
  end;
  filename:=MAIN_DIR+MM_LOG_DIR+'\'+s+'.log';
  AssignFile(F,filename);
  if FileExists(filename) then Append(F)
  else rewrite(F);

  writeln(F,Str);
  CloseFile(F);
end;
//==========================================================================
procedure TSocket2.CMD_PhotoSend(AThread: TIdPeerThread; slCMD: TStrings);
var
  conn: TConnection;
begin
  conn:=TConnection(AThread.Data);
  fConnections.CMD_PhotoSend(conn, slCMD);
  SendMyPhotoToAll(conn);
end;
//==========================================================================
procedure TSocket2.SendMyPhotoToAll(myconn: TConnection);
var
  conn: TConnection;
  i: integer;
begin
  if myconn.Invisible then exit;
  //MMThreadLog(AThread, 'SendMyPhotoToAll');
  for i:=fConnections.Connections.Count-1 downto 0 do begin
    try
      conn:=TConnection(fConnections.Connections[i]);
    except
      conn:=nil;
    end;

    if (conn.Socket2Thread <> nil) {and (conn<>myconn) } then
      Send(conn.Socket2Thread,
        [DPM_PHOTO, myconn.Handle, '1', ControlSumm(myconn.PhotoANSI), myconn.PhotoANSI]);
  end;
end;
//==========================================================================
procedure TSocket2.CMD_MM(Connection: TConnection; slCMD: TStrings);
var
  b: Boolean;
  i: integer;
  conn: TConnection;
  s, msg, errlevel: string;
begin
  try
    if slCMD.Count<2 then exception.Create(DP_MSG_INCORRECT_PARAM_COUNT);

    if lowercase(slCMD[1])='status' then begin
      if Server.Active then s:='ON'
      else s:='OFF';
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'MM port is '+s]);
      exit;
    end;

    b:=lowercase(slCMD[1])='on';

    if not b then begin
      for i:=fConnections.Connections.Count-1 downto 0 do begin
        conn:=TConnection(fConnections.Connections[i]);
        if conn.Socket2Thread<>nil then begin
          conn.Socket2Thread.Data := nil;
          conn.Socket2Thread := nil;
        end;
      end;
    end;

    if b then s:='on' else s:='off';

    if Server.Active<>b then begin
      Server.Active:=b;
      msg:='successfully';
      errlevel:=DP_ERR_0;
    end else begin
      msg:='already';
      errlevel:=DP_ERR_1;
    end;

    fSocket.Send(Connection, [DP_SERVER_MSG,errlevel,'Multimedia Socket is '+msg+' turned '+s]);
  except
    on E: Exception do
      fSocket.Send(Connection, [DP_SERVER_MSG,DP_ERR_2,E.Message]);
  end;
end;
//==========================================================================
end.

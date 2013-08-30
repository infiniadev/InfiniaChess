{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSSocket;

interface

uses
  Windows, Messages, SysUtils, Classes, Contnrs, Controls, ScktComp,
  CSConnection, winsock, FileCtrl, Variants;

type
  TVersionDirection = (vrdLessThen, vrdStartFrom);

  TSocket = class(TObject)
  private
    { Private declarations }
    FBuffer: Boolean;
    FEncrypt: Boolean;
    FSrvSocket: TServerSocket;
    FModeBuffer: Boolean;
    SLLog: TStringList;
    LogLastNum: integer;

    procedure ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSend(const Connection: TConnection; Data: string);
    procedure ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientWrite(Sender: TObject; Socket: TCustomWinSocket);
    function FindLogFileName: string;
    function GetSocketPort: integer;
    function CanSend(Connection: TConnection; Initiator: TObject): Boolean;

  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    procedure CMD_CloseSocket(var Connection: TConnection; var CMD: TStrings);
    procedure Send(const Connection: TConnection;
      CMDElements: array of string; Initiator: TObject); overload;
    procedure Send(const Connection: TConnection;
      CMDElements: array of string); overload;
    procedure Send(const Connections: TObjectList;
      CMDElements: array of string; Initiator: TObject); overload;
    procedure Send(const Connections: TObjectList;
      CMDElements: array of string; Initiator: TObject; p_AdminTitledOnly: Boolean); overload;
    procedure SendVariants(const Connections: TObjectList;
      CMDElements: array of Variant; Initiator: TObject; p_AdminTitledOnly: Boolean);
    procedure Send(const Connections: TObjectList; Data: string;
      Initiator: TObject; p_AdminTitledOnly: Boolean); overload;
    procedure SendByVersion(const Connections: TObjectList;
      Version: string;
      VersionDirection: TVersionDirection;
      CMDElements: array of string;
      Initiator: TObject);

    procedure SmartSend(const p_Receivers: TObject; // can be TConnection or TObjectList
      const p_Filter: TConnectionFilter;
      CMDElements: array of Variant;
      p_Initiator: TObject);

    procedure AddToLog(Str: string);
    function HandleOfConnection(Connection: TConnection): string;
    procedure FlushLog;

    property SocketPort: integer read GetSocketPort;
    property Buffer: Boolean read FBuffer write FBuffer;
    property ModeBuffer: Boolean read FModeBuffer write FModeBuffer;
    procedure CloseSocket;
  end;

var
  fSocket: TSocket;

implementation

uses
  CSService, CSCommand, CSConst, CSConnections, CSLib, CSTimeStat, CSGame, CSEvent, CSDb;

const
  CIPHER_KEY: Word = 26484;
  CIPHER1: Word = 49574;
  CIPHER2: Word = 19756;

//=====================================================================
procedure TSocket.ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if MAIN_THREAD_ID = 0 then
    MAIN_THREAD_ID := GetCurrentThreadID;

  AssertInMainThread;
  try
    fConnections.Add(Socket);
    AddToLog('@@@ connected '+Socket.RemoteAddress);
  except on E:Exception do
    ErrLog(E.Message,nil,'ClientConnect');
  end;
end;
//=====================================================================
procedure TSocket.ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Connection: TConnection;
  name: string;
begin
  AssertInMainThread;
  { It's been determined that OnDisconnect can be called as a result of a Send
    that errors out. And while not technically a race condition, it can fire
    before the Onsend completes it's loop. So don't log for now. }

  try
    Connection := fConnections.GetConnection(Socket);
    name:='';

    { Only after the call to GetConnection is this safe. }
    Socket.Data := nil;
    if Connection <> nil then
      with Connection do
        begin
          name:=Connection.Handle;
          Connection.Socket := nil;
          Input := '';
          Output := '';
          LastTS := Now;

          { A LoginID of < 0 indicates that a connection has been established
            but the Connection Object has not been added to any lists yet. Just
            Free it.}
          if LoginID < 0 then
            Connection.Free
          else
            begin
              { Do a initial release of the Connection }
              //fConnections.Release(Connection, False);

              { Add to the Disconnections list. To be freed later during a flush }
              Connection.SetOnlineStatus(onlDisconnected);
            end;
        end;

    AddToLog('%%% Disconnected '+name+'; '+Socket.RemoteAddress);
  except on E:Exception do
    ErrLog(E.Message,nil,'ClientDisconnect');
  end;
end;
//=====================================================================
procedure TSocket.ClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  AssertInMainThread;
  try
    { Maybe extreme to just drop them, but oh well. }
    Socket.Close;
    ErrorCode := 0;

  except on E:Exception do
    ErrLog(E.Message,nil,'ClientError');
  end;
end;
//=====================================================================
procedure TSocket.ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Connection: TConnection;
  BytesRead, TotalBytes, Index, msec: Integer;
  Key: Word;
  Data, DecryptedData, operation, initiator, params: string;
  d1,d2: TDateTime;
begin
  AssertInMainThread;
  d1:=Date+Time;
  try
    Connection := fConnections.GetConnection(Socket);
    if Connection = nil then
      begin
        {$IFDEF ServiceBuild}
        CLServerService.LogMessage('Connection nil. Cannot read.',
          EVENTLOG_WARNING_TYPE, 0, 6);
        {$ENDIF}
        Exit;
      end;

    initiator := Connection.Handle;

    { Read from socket }
    TotalBytes := 0;
    repeat
      SetLength(Data, TotalBytes + MAX_LEN);
  {
      BytesRead := Socket.ReceiveLength;
      if BytesRead < 1 then Break;
  }
      BytesRead := Socket.ReceiveBuf(Data[TotalBytes + 1], MAX_LEN);
      if BytesRead > -1 then TotalBytes := TotalBytes + BytesRead;
    until (BytesRead = -1) or (BytesRead < MAX_LEN);

    { Crop off invalid characters }
    SetLength(Data, TotalBytes);

    { Decrypt if necessary }
    if FEncrypt then
      begin
        { Get the correct key }
        if Connection.Input = '' then
          Key := CIPHER_KEY
        else
          Key := Connection.Key;

        SetLength(DecryptedData, TotalBytes);
        for Index := 1 to TotalBytes do
          begin
            DecryptedData[Index] := Char(Byte(Data[Index]) xor (Key shr 8));
            Key := (Byte(Data[Index]) + Key) * CIPHER1 + CIPHER2;
            { Reset the Key }
            if DecryptedData[Index] = #10 then Key := CIPHER_KEY;
          end;
        { Save the key incase more encrypted data is coming }
        Connection.Key := Key;
      end
    else
      DecryptedData := Data;

    { Get previous unfinished DP (if any) for this Connection }
    if Connection.Input <> '' then
      begin
        DecryptedData := Connection.Input + DecryptedData;
        TotalBytes := Length(DecryptedData);
      end;

    { Prepare for the event that only a partial DG is at the end of the buffer.
    Since all sockets utilize a central DG parser we may only send it whole DG's.
    The incomplete DG must be cached with the Connection until it's next read,
    when it might become complete. If the buffer ends in a #10 then clear the
    Connection cache. }
    if DecryptedData = '' then exit;
    
    if not (DecryptedData[TotalBytes] = #10) then
      begin
        { Check for abuse. Hackers from trying to break the server by sending
          continous data w/o a terminator. If excessive data just drop them. }
        if TotalBytes > MAX_LEN * 8 then
          begin
            Connection.Socket.Close;
            Exit;
          end;
        { Try to find a terminator }
        Index := 0;
        for BytesRead := TotalBytes downto 1 do
          if DecryptedData[BytesRead] = #10 then
            begin
              Index := BytesRead;
              Break;
            end;

        Connection.Input := Copy(DecryptedData, Index + 1, TotalBytes - Index);
        SetLength(DecryptedData, Index);
      end
    else
      Connection.Input := '';

    { ??? For testing with MS Telnet.exe only }
    Index := Pos(#13, DecryptedData);
    if Index > 0 then Delete(DecryptedData, Index, 1);

    { Ensure that hackers cannot send enbedded commands }
    if Pos(DP_START, DecryptedData) > 0 then exit;

    { Parse the incoming data }
    if ISSOCKETLOG then
      SocketLog(HandleOfConnection(Connection)+';',DecryptedData,true);
    AddToLog(DateTimeToStr(Date+Time)+' '+HandleOfConnection(Connection)+': '+DecryptedData);
    params := DecryptedData;
    operation:=fCommand.Receive(Connection, DecryptedData, cmtUsual);

    d2:=Date+Time;
    msec:=trunc((d2-d1)*MSecsPerDay);
    fTimeStat.AddTime(operation,msec);
    fDB.SaveLagStat(initiator, operation, params, msec);

  except
    on E:Exception do begin
      ErrLog('========================================');
      ErrLog('Time: ' + DateTimeToStr(Now));
      ErrLog('TSocket.ClientRead: ' + DecryptedData);
      ErrLog('Connection: ' + Connection.Handle);
      ErrLog('Error: ' + E.Message);
      ErrLog('Stack: ');
      ErrLog(GetExceptionStack);
      ErrLog('========================================');
    end;
  end;
end;
//=====================================================================
procedure TSocket.ClientSend(const Connection: TConnection; Data: string);
var
  Index, Len, Count, BytesSent: Integer;
begin
  AssertInMainThread;
  try
    { Check for Connection first }
    if not Assigned(Connection) or not Assigned(Connection.Socket) then Exit;

    with Connection do
      { Buffer the data if necessary. }
      if WaitForOnWrite or FBuffer and FModeBuffer then
        begin
          Output := Output +  Data;
          Exit;
        end
      else
        { Else append new data to (any) buffered data. }
        begin
          if Output <> '' then Data := Output + Data;
          Output := '';
        end;

    { Send as much data as possible. If the winsock buffer fills up, store the
      remaining data in the conncetion input buffer and wait for onwrite. }
    Len := Length(Data);
    Index := 1;
    while Index <= Len do
      try
        Count := Len - Index + 1;
        if Count > MAX_LEN then Count := MAX_LEN;
        BytesSent := Connection.Socket.SendBuf(Data[Index], Count);
        if BytesSent > -1 then
          Index := Index + BytesSent
        else
          begin
            Connection.Output := Copy(Data, Index, Len - Index + 1);
            Connection.WaitForOnWrite := True;
            Break;
          end;
      except
        {$IFDEF ServiceBuild}
        CLServerService.LogMessage('Connection broken while sending data.',
          EVENTLOG_WARNING_TYPE, 0, 4);
        {$ENDIF}
        Break;
      end;
  except
    on E:Exception do begin
      AddToLog('Error ClientSend: '+E.Message+'; '+DateTimeToStr(Date+Time)+' '+E.Message);
    end;
  end;
end;
//=====================================================================
procedure TSocket.ClientWrite(Sender: TObject; Socket: TCustomWinSocket);
var
  Connection: TConnection;
begin
  AssertInMainThread;
  try
    Connection := fConnections.GetConnection(Socket);
    if Connection = nil then
      begin
        {$IFDEF ServiceBuild}
        CLServerService.LogMessage('Connection nil. Cannot write.',
          EVENTLOG_WARNING_TYPE, 0, 5);
        {$ENDIF}
      end
    else
      begin
        Connection.WaitForOnWrite := False;
        ClientSend(Connection, '');
      end;

  except on E:Exception do
    ErrLog(E.Message,Connection,'ClientWrite');
  end;
end;
//=====================================================================
procedure TSocket.CloseSocket;
begin
  FSrvSocket.Close;
end;
//=====================================================================
constructor TSocket.Create;
begin
  FBuffer := False;
  FModeBuffer := False;
  FEncrypt := CONNECTION_ENCRYPTED;
  FSrvSocket := TServerSocket.Create(nil);
  with FSrvSocket do
    begin
      Port := WORKING_PORT;
      ServerType := stNonBlocking;
      OnClientConnect := ClientConnect;
      OnClientDisconnect := ClientDisconnect;
      OnClientError := ClientError;
      OnClientRead := ClientRead;
      OnClientWrite := ClientWrite;
      Open;
    end;
  SLLog:=TStringList.Create;
  LogLastNum:=0;
  SL_DP_CODES:=TStringList.Create;
  if FileExists(MAIN_DIR+'dp_codes.ini') then
    SL_DP_CODES.LoadFromFile(MAIN_DIR+'dp_codes.ini');
end;
//=====================================================================
destructor TSocket.Destroy;
begin
  FSrvSocket.Close;
  FSrvSocket.Free;
  SLLog.Free;
  SL_DP_CODES.Free;
  inherited Destroy;
end;
//=====================================================================
procedure TSocket.CMD_CloseSocket(var Connection: TConnection;
  var CMD: TStrings);
var
  MSec, Idle: Integer;
begin
  AssertInMainThread;
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVALID_COMMAND]);
      Exit;
    end;
  { Verify param}
  try
    MSec := StrToInt(CMD[1]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVALID_COMMAND]);
      Exit;
    end;
  end;

  Idle := Trunc((Now - Connection.LastCmdTS) * MSecsPerDay);

  if (abs(Idle - MSec) < 500) and (Connection.AdminLevel = alSuper) then
    fSocket.FSrvSocket.Close
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVALID_COMMAND]);
end;
//=====================================================================
procedure TSocket.Send(const Connection: TConnection;
  CMDElements: array of string; Initiator: TObject);
var
  Index: Integer;
  Key: Word;
  InitData,Data: string;
begin
  AssertInMainThread;
  { Insert the delimiters }
  try
    if Connection.Socket = nil then exit;

    Data := DP_START;
    for Index := 0 to High(CMDElements) do
      Data := Data + CMDElements[Index] + DP_DELIMITER;
    Data := Data + DP_END;
    InitData:=Data;

    if ISSOCKETLOG then begin
      SocketLog(HandleOfConnection(Connection)+';',Data,false);
    end;

    { Encrypt (keep in sync with overloaded send procedure) }
    if FEncrypt then
      begin
        Key := CIPHER_KEY;
        for Index := 1 to Length(Data) do
          begin
            Data[Index] := Char(Byte(Data[Index]) xor (Key shr 8));
            Key := (Byte(Data[Index]) + Key) * CIPHER1 + CIPHER2;
          end;
      end;

    if CanSend(Connection, Initiator) then
      ClientSend(Connection, Data);
    AddToLog('    > '+DateTimeToStr(Date+Time)+' '+HandleOfConnection(Connection)+': '+GetDPName(CMDElements[0])+InitData);
  except
    on E:Exception do begin
      ErrLog(InitData+'; '+E.Message,Connection,'ClientSend');
      AddToLog('    > Error: '+E.Message+'; '+DateTimeToStr(Date+Time)+' '+HandleOfConnection(Connection)+': '+GetDPName(CMDElements[0])+InitData);
    end;
  end;
end;
//=====================================================================
procedure TSocket.Send(const Connections: TObjectList;
  CMDElements: array of string; Initiator: TObject; p_AdminTitledOnly: Boolean);
var
  Data: string;
  i: integer;
begin
  Data := DP_START;
  for i := 0 to High(CMDElements) do
    Data := Data + CMDElements[i] + DP_DELIMITER;
  Data := Data + DP_END;
  Send(Connections, Data, Initiator, p_AdminTitledOnly);
end;
//=====================================================================
procedure TSocket.Send(const Connections: TObjectList; Data: string;
  Initiator: TObject; p_AdminTitledOnly: Boolean);
var
  Connection: TConnection;
  i,Index: Integer;
  Key: Word;
  s,InitData: string;
begin
  AssertInMainThread;
  try
    InitData:=Data;

    if ISSOCKETLOG then begin
      s:='';
      for i:=0 to Connections.Count-1 do
        s:=s+TConnection(Connections[i]).Handle+';';
      SocketLog(s,Data,false);
    end;

    { Encrypt (keep in sync with overloaded send procedure) }
    if FEncrypt then
      begin
        Key := CIPHER_KEY;
        for Index := 1 to Length(Data) do
          begin
            Data[Index] := Char(Byte(Data[Index]) xor (Key shr 8));
            Key := (Byte(Data[Index]) + Key) * CIPHER1 + CIPHER2;
          end;
      end;

    for Index := 0 to Connections.Count - 1 do
      begin
        Connection := TConnection(Connections[Index]);
        if not Assigned(Connection) or not Assigned(Connection.Socket)
          or p_AdminTitledOnly and (Connection.AdminLevel=alNone) and (trim(Connection.Title)='')
        then
          continue;

        if not Connection.Send then
          begin
            Connection.Send := True; { Reset. Default to sending unless explicity set to false. It's a onetime trip. }
            Continue;
          end;
        if (Connection.LoginID > -1) and CanSend(Connection, Initiator) then
          ClientSend(Connection, Data);
      end;
    if p_AdminTitledOnly then s:='<admins>'
    else s:='<...>';
  except
    on E:Exception do begin
      ErrLog(InitData+'; '+E.Message,nil,'ClientSend');
    end;
  end;
end;
//=====================================================================
procedure TSocket.SendByVersion(const Connections: TObjectList; Version: string;
  VersionDirection: TVersionDirection; CMDElements: array of string;
  Initiator: TObject);
var
  i, CompareResult: integer;
  conn: TConnection;
begin
  AssertInMainThread;
  for i := 0 to Connections.Count - 1 do begin
    conn := TConnection(Connections[i]);
    CompareResult := CompareVersion(conn.Version, Version);
    conn.Send := (CompareResult = -1) and (VersionDirection = vrdLessThen) or
       (CompareResult >= 0) and (VersionDirection = vrdStartFrom);
  end;
  Self.Send(Connections, CMDElements, Initiator);
end;
//=====================================================================
procedure TSocket.SendVariants(const Connections: TObjectList;
  CMDElements: array of Variant; Initiator: TObject;
  p_AdminTitledOnly: Boolean);
var
  Data: string;
  i: integer;
begin
  Data := DP_START;
  for i := 0 to High(CMDElements) do
    Data := Data + VarToStr(CMDElements[i]) + DP_DELIMITER;
  Data := Data + DP_END;
  Send(Connections, Data, Initiator, p_AdminTitledOnly);
end;
//=====================================================================
function SocketVar2Str(V: Variant): string;
begin
  case VarType(V) of
    varDate: result := FloatToStr(V);
    varBoolean: result := BoolTo_(V, '1', '0');
  else
    result := VarToStr(V);
  end;
end;
//=====================================================================
procedure TSocket.SmartSend(const p_Receivers: TObject;
  const p_Filter: TConnectionFilter; CMDElements: array of Variant;
  p_Initiator: TObject);
var
  List: TConnectionList;
  i: integer;
  Receivers: TObject;
  Data: string;
  Key: word;
  //*******************************************************************
  function FilterPassed(p_Conn: TConnection): Boolean;
  begin
    result := not Assigned(p_Filter) or Assigned(p_Filter) and p_Filter(p_Conn);
  end;
  //*******************************************************************
  procedure SendOne(p_Conn: TConnection);
  begin
    if FilterPassed(p_Conn) and CanSend(p_Conn, p_Initiator) then
      ClientSend(p_Conn, Data);
  end;
  //*******************************************************************
begin
  if Assigned(p_Receivers) then Receivers := p_Receivers
  else Receivers := fConnections.Connections;

  Data := DP_START;
  for i := 0 to High(CMDElements) do
    Data := Data + SocketVar2Str(CMDElements[i]) + DP_DELIMITER;
  Data := Data + DP_END;

  if FEncrypt then
  begin
    Key := CIPHER_KEY;
    for i := 1 to Length(Data) do
      begin
        Data[i] := Char(Byte(Data[i]) xor (Key shr 8));
        Key := (Byte(Data[i]) + Key) * CIPHER1 + CIPHER2;
      end;
  end;

  if Receivers is TConnection then SendOne(TConnection(Receivers))
  else if Receivers is TConnectionList then begin
    List := TConnectionList(Receivers);
    for i := 0 to List.Count - 1 do
      SendOne(List[i]);
  end else
    ErrLog('TSocket.SmartSend: wrong argument type "' + p_Receivers.ClassName + '" for p_Receivers', nil);
end;
//=====================================================================
procedure TSocket.Send(const Connections: TObjectList;
  CMDElements: array of string; Initiator: TObject);
var
  Connection: TConnection;
  i,Index: Integer;
  Key: Word;
  s,Data,InitData: string;
begin
  Send(Connections, CMDElements, Initiator, false);
end;
//=====================================================================
procedure TSocket.AddToLog(Str: string);
begin
  if not LOGGING then exit;
  SLLog.Add(Str);
  if SLLog.Count>=LOG_BUFFER_COUNT then
    FlushLog;
end;
//=====================================================================
procedure TSocket.FlushLog;
begin
  if not LOGGING then exit;
  SLLog.SaveToFile(FindLogFileName);
  SLLog.Clear;
end;
//=====================================================================
function TSocket.FindLogFileName: string;
var
  LogDir: string;
begin
  AssertInMainThread;
  LogDir:=MAIN_DIR+'log';
  if not DirectoryExists(LogDir) then
    CreateDir(LogDir);
  repeat
    inc(LogLastNum);
    result:=LogDir+'\'+lpad(IntToStr(LogLastNum),5,'0')+'.log';
  until not FileExists(result);
end;
//=====================================================================
function TSocket.HandleOfConnection(Connection: TConnection): string;
begin
  if Connection=nil then result:='nil'
  else result:=Connection.Handle;
end;
//=====================================================================
function TSocket.GetSocketPort: integer;
begin
  result:=FSrvSocket.Port;
end;
//=====================================================================
procedure TSocket.Send(const Connection: TConnection;
  CMDElements: array of string);
begin
  Send(Connection, CMDElements, nil);
end;
//=====================================================================
function TSocket.CanSend(Connection: TConnection;
  Initiator: TObject): Boolean;
var
  GM: TGame;
begin
  if Initiator = nil then
    result:=true
  else if Initiator is TConnection then
    result:=Connection.ClubId = TConnection(Initiator).ClubId
  else if Initiator is TGame then begin
    GM:=TGame(Initiator);
    if GM.White <> nil then result:=(Connection.ClubId = TGame(Initiator).White.ClubId)
    else if GM.Black <> nil then result:=(Connection.ClubId = TGame(Initiator).Black.ClubId)
    else result:=true
  end else if Initiator is TCSEvent then
    result:=TCSEvent(Initiator).CanSend(Connection);
end;
//=====================================================================
end.

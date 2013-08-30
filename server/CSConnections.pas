{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSConnections;

interface

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

uses
  Classes, Contnrs, ScktComp, SysUtils, CSConnection, FileCtrl, Graphics, JPEG,
  Variants, ADOint;

type
  TLoginActionDone = class
  public
    Login: string;
    DateTime: TDateTime;
  end;

  TLoginActionDoneList = class(TObjectList)
  private
    function GetIndexByLogin(p_Login: string): integer;
    function GetActionByLogin(p_Login: string): TLoginActionDone;
  public
    HoursLimit: real;
    constructor Create(p_HoursLimit: real); virtual;
    function SetActionIfNeed(p_Login: string; p_DateTime: TDateTime): Boolean;
  end;

  TConnectionList = class(TObjectList)
  private
    function GetConnection(Index: integer): TConnection;
  public
    property Connection[Index: integer]: TConnection read GetConnection; default;
  end;

  TConnections = class(TObject)
  private
    { Private declarations }
    FAdminConnections: TObjectList;
    FConnections: TConnectionList;
    FLastUnbanByTime: TDateTime;
    FStartURLSentList : TLoginActionDoneList;
    procedure Release(var Connection: TConnection; FreeConnection: Boolean);
  public
    { Public declarations }
    FollowList: TStringList;
    constructor Create;
    destructor Destroy; override;

    function GetConnection(Handle: string): TConnection; overload;
    function GetConnection(var Socket: TCustomWinSocket): TConnection; overload;
    function GetConnectionMM(Socket: TCustomWinSocket): TConnection;
    function GetLiveConnection(Handle: string): TConnection;
    function GetConnection(const LoginID: Integer): TConnection; overload;

    procedure AddFollow(Connection: TCOnnection; toname: string);
    procedure RemoveFollow(Connection: TConnection); overload;
    procedure RemoveFollow(nameto: string); overload;
    procedure FrozeFollow(Connection: TConnection);
    procedure UnFrozeFollow(Connection: TConnection);
    function  Following(ConnFrom,ConnTo: TConnection): Boolean;
    procedure Add(var Socket: TCustomWinSocket);
    procedure CheckIdleTime;
    procedure CMD_AckPing(var Connection: TConnection);
    procedure CMD_Address(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Bye(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_CensorAdd(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_CensorRemove(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_ChangeTitle(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Disable(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Enable(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Login(var Connection: TConnection; var CMD: TStrings);
    function  CMD_Login2(var Connection: TConnection; var CMD: TStrings): integer;
    procedure CMD_AuthKey(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_MeSuper(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Mute(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_NotifyAdd(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_NotifyRemove(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Nuke(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Register(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Set(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_SetAll(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Shout(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Tell(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Unknown(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_UnMute(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Follow(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Unfollow(var Connection: TConnection; var CMD: TStrings);
    procedure Flush;
    procedure Ping;
    procedure SendILogin(var Connection: TConnection);
    procedure SendILogoff(var Connection: TConnection);
    procedure SendLogins(var Connection: TConnection);
    procedure SendRatings(var Connection: TConnection);
    procedure SendSettings(var Connection: TConnection);
    procedure DoFollows(const Handle1, Handle2: string);
    procedure CMD_ShowFollows(Connection: TConnection; FCMD: TStrings);
    procedure UnbanByTime;
    procedure CMD_EventBan(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_EventUnBan(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_EventKickOut(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_PhotoSend(Connection: TConnection; var CMD: TStrings);
    procedure ShoutIfNeed(Connection: TConnection);
    procedure SendClubList(Connection: TConnection); overload;
    procedure SendClubList(Connections: TObjectList); overload;
    procedure CMD_ChangeClub(Connection: TConnection; var CMD: TStrings);
    procedure SetToSendTSER;
    procedure CMD_DeleteProfilePhoto(Connection: TConnection; var CMD: TStrings);
    procedure CMD_SetProfileNotes(Connection: TConnection; var CMD: TStrings);
    procedure CMD_SetNotes(Connection: TConnection; var CMD: TStrings);
    function FindIdByLogin(Login: string): integer;
    procedure SendTimeOddsLimits(Connection: TConnection); overload;
    procedure SendTimeOddsLimits(Connections: TObjectList); overload;
    function AddEngineUser(p_Login: string; var pp_Err: string): Boolean;
    procedure DoEngineActions;
    procedure SetEnginePingValues;
    procedure CMD_Summon(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Order(var Connection: TConnection; var CMD: TStrings);
    procedure NullifyAllGamesPerDay;
    procedure SendLoginInfo(const p_Receiver: TConnection; const Connection: TConnection);
    function OldLoginTransfer(const Connection: TConnection): Boolean;
    function NewLoginTransfer(const Connection: TConnection): Boolean;
    procedure CMD_RequestUserInfo(var Connection: TConnection; var CMD: TStrings);

    property AdminConnections: TObjectList read FAdminConnections;
    property Connections: TConnectionList read FConnections;
  end;

var
  fConnections: TConnections;

implementation

uses
  CSService, CSConst, CSDB, CSGames, CSGame, CSMessages, CSOffers, CSRooms,
  CSSocket, CSCOmmand,CSLib,CSEvents, CSEvent, CSSocket2, CSClub,
  CLRating, CSAchievements, CSActions, CSEngine, CSBot;

const
  CENSOR_LIMIT = 100;
  NOTIFY_LIMIT = 100;
  OFFLINE = '0';
  ONLINE = '1';
//==============================================================================
constructor TConnections.Create;
begin
  FAdminConnections := TObjectList.Create;
  FAdminConnections.OwnsObjects := False;
  FConnections := TConnectionList.Create;
  FollowList:=TStringList.Create;
  FStartURLSentList := TLoginActionDoneList.Create(URL_START_PERIOD);
end;
//==============================================================================
destructor TConnections.Destroy;
begin
  FAdminConnections.Clear;
  FAdminConnections.Free;
  { TObjectList will destroy any TConnection's for us }
  FConnections.Free;
  FollowList.Free;
  FStartURLSentList.Free;
  inherited Destroy;
end;
//==============================================================================
function TConnections.GetConnection(var Socket: TCustomWinSocket): TConnection;
begin
  if Socket.Data = nil then
    Result := nil
  else
    Result := TConnection(Socket.Data);
end;
//==============================================================================
function TConnections.GetConnection(Handle: string): TConnection;
var
  i: integer;
begin
  Handle := lowercase(Handle);
  for i := fConnections.Count - 1 downto 0 do
    if lowercase(fConnections[i].Handle) = Handle then begin
      result := fConnections[i];
      exit;
    end;
  result := nil;
end;
//==============================================================================
{
function TConnections.GetConnection(const LoginID: Integer): TConnection;
var
  Index: Integer;
begin
  // Get Connection object based upon the unique ID (LoginID). Only valid for
  // registered Logins (guests don't have ID's)
  Result := nil;
  if LoginID < 0 then Exit;
  Index := IndexOf(LoginID);
  if Index > -1 then Result := TConnection(FConnections[Index]);
end;
}
//==============================================================================
procedure TConnections.Add(var Socket: TCustomWinSocket);
var
  Connection: TConnection;
begin
  if FConnections.Count >= CONNECTIONS_ALLOWED then
      Socket.Close
  else begin
    Connection := TConnection.Create(Socket);
    fSocket.Send(Connection, [DP_CONNECTED]);
  end;
end;
//==============================================================================
procedure TConnections.CheckIdleTime;
var
  conn: TConnection;
  i, IdleTimeMinutes: Integer;
begin
  { Set the LastTS for those Connections who's ping TS is zero. }
  for i := FConnections.Count -1 downto 0 do begin
    conn := TConnection(FConnections[i]);
    if (conn.Socket = nil) or (conn.OnlineStatus = onlDisconnected) then Continue;
    IdleTimeMinutes := GetDateDiffMSec(conn.LastCmdTS, Now) div 60000;
    if  IdleTimeMinutes >= AUTOLOGOUT_TIME_MINUTES then begin
      fSocket.Send(conn, [DP_SERVER_MSG, '1', DP_MSG_AUTO_LOGOUT]);
      conn.Socket.Close;
    end else if IdleTimeMinutes >= IDLE_TIME_MINUTES then begin
      conn.SetOnlineStatus(onlIdle);
    end;
  end;
end;
//==============================================================================
procedure TConnections.CMD_AckPing(var Connection: TConnection);
var
  OldPingLast: Integer;
begin
  with Connection do
    begin
      OldPingLast := PingLast;
      if LastTS = 0 then Exit;
      PingLast := Trunc((Now - LastTS) * MSecsPerDay);
      PingCount := PingCount + 1;
      PingAvg := ((PingAvg * PingCount) + PingLast) div PingCount;
      if PingLast <> OldPingLast then begin
        fSocket.Send(Connection, [DP_PING_VALUE, IntToStr(PingLast)]);
        fSocket.Send(Connections,[DP_USER_PING_VALUE, Connection.Handle,IntToStr(PingLast)],Connection);
      end;
      LastTS := 0;
    end;
end;
//==============================================================================
procedure TConnections.CMD_Address(var Connection: TConnection; var CMD: TStrings);
var
  _Connection: TConnection;
  s: string;
begin
{ Verify admin }
  {if Connection.AdminLevel <> alSuper then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_SUPER_ADMIN_ONLY]);
      Exit;
    end;}
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;

  _Connection := GetConnection(CMD[1]);

  if Assigned(_Connection) then
    begin
      s := 'MAC=' + _Connection.MAC + ' : IP=' +  _Connection.Socket.RemoteAddress;
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
    end
  else
    begin
      s := Format(DP_MSG_LOGIN_NOT_LOGGEDIN, [CMD[1]]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
    end;
end;
//==============================================================================
procedure TConnections.CMD_Bye(var Connection: TConnection; var CMD: TStrings);
var
  Socket: TCustomWinSocket;
begin
  if not (Connection is TConnection) then Exit;

  RemoveFollow(Connection);
  RemoveFollow(Connection.Handle);
  { When we relseae a Connection we also lose the pointer to the Socket that
    the Connection was holding. Storing it locally allows us to close it after
    data is sent to the socket that's 'exiting' }
  Socket := Connection.Socket;
  if Connection.LoginID > 0 then Release(Connection, True);
  { Socket.Close will attempt to free the parent Connection object. }
  if Socket<>nil then Socket.Close;
  { Set the procedure parameter to nil to protect the call stack. }
  Connection := nil;
end;
//==============================================================================
procedure TConnections.CMD_CensorAdd(var Connection: TConnection;
  var CMD: TStrings);
var
  LoginID: Integer;
  CensorType: TNotifyType;
  login, title: string;
begin
  { Verify registered lgoin }
  if not Connection.Registered then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_REGISTERED_ONLY]);
    exit;
  end;
  { Check the Censor count of the Connection. }
  if Connection.NotifyCount[ntCensor] > CENSOR_LIMIT then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_CENSOR_LIMIT_MET, [CMD[1]])]);
    exit;
  end;
  { Verify the paramaters }
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  { Verify the requested Censor Login. The fDB process returns the ID of the
    CensorLogin requested or an error code:
    -1=already on list, -2=invalid login, -3 super admin }
  login := Copy(CMD[1], 1, 15);
  title := fDB.GetTitle(login);

  if lowercase(login) = lowercase(Connection.Handle) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'You cannot censor yourself']);
    exit;
  end;

  if CMD.Count >= 3 then CensorType := TNotifyType(StrToInt(CMD[2]))
  else CensorType := ntCensor;

  LoginID := fDB.NotifyAdd(Connection.LoginID, login, CensorType);
  case LoginID of
    DB_ERROR: exit;
    -3:
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
          DP_MSG_NO_CENSOR_ADMIN]);
        Exit;
      end;
    -2:
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_LOGINID_INVALID, [CMD[1]])]);
        Exit;
      end;
    -1:
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_CENSORED_ALREADY, [CMD[1]])]);
        Exit;
      end;
  end;

  Connection.AddNotify(LoginID, Login, Title, CensorType, true, true);
end;
//==============================================================================
procedure TConnections.CMD_CensorRemove(var Connection: TConnection;
  var CMD: TStrings);
var
  _Connection: TConnection;
  Notify: TNotify;
  Index, Return: Integer;
  login, title: string;
begin
  { Verify registered lgoin }
  if not Connection.Registered then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_REGISTERED_ONLY]);
    Exit;
  end;
  { Verify the paramaters }
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    Exit;
  end;

  { Remove the requested Censor Login. The fDB process returns the ID of the
    CensorLogin begin removed or an error code:
    -1=not on list, -2=invalid login }
  login := Copy(CMD[1], 1, 15);
  title := fDB.GetTitle(login);
  Return := fDB.NotifyRemove(Connection.LoginID, login, ntCensor);

  if Return > -1 then begin
    Connection.RemoveNotify(Return, false);
    fSocket.Send(Connection, [DP_NOTIFY_REMOVE, IntToStr(Return), login, title,
      IntToStr(ord(ntCensor))]);
  end;
end;
//==============================================================================
procedure TConnections.CMD_ChangeTitle(var Connection: TConnection;
  var CMD: TStrings);
var
  _Connection: TConnection;
  Return: Integer;
  s, t: string;
begin
  { Verify admin }
  {if Connection.AdminLevel <> alSuper then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_SUPER_ADMIN_ONLY]);
      Exit;
    end;}
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  { Submit db call }
  s := Copy(CMD[1], 1, 15);
  if CMD.COunt > 2 then
    t := rtrim(Copy(CMD[2], 1, 3))
  else
    t := '';
  Return := fDB.ChangeTitle(s, t);

  { Display return }
  case Return of
    -1: // not a valid Login
      begin
        s := Format(DP_MSG_LOGINID_INVALID, [s]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
      end;
    0: //Title changed.
      begin
        _Connection := GetConnection(s);
        if Assigned(_Connection) then _Connection.Title := t;
        s := Format(DP_MSG_TITLE_CHANGED, [s, t]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
      end;
  end;
end;
//==============================================================================
procedure TConnections.CMD_Disable(var Connection: TConnection;
  var CMD: TStrings);
const
  LOGIN_TO_DISABLE = 1;
  ADMIN_REASON = 2;
var
  _Connection: TConnection;
  Return: Integer;
  s: string;
  slDumb: TStrings;
begin
  { Verify admin }
  {if Connection.AdminLevel <> alSuper then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_SUPER_ADMIN_ONLY]);
      Exit;
    end;}
  { Verify param count }
  if CMD.Count < 3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  { Submit db call }
  s := Copy(CMD[LOGIN_TO_DISABLE], 1, 15);
  Return := fDB.Enable(s, 0);

  { Display return }
  case Return of
    -1: // not a valid Login
      begin
        s := Format(DP_MSG_LOGINID_INVALID, [s]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
      end;
    -2:; //can't disable yourself.
        //should supply a message.

    0: //Disabled bit set
      begin
        _Connection := GetConnection(s);
        if assigned(_Connection) then
          begin
            { Inform the person getting disabled. }
            fSocket.Send(_Connection, [DP_SERVER_MSG, DP_ERR_2, CMD[ADMIN_REASON]]);
            { Force the player off }
            CMD_Bye(_Connection, slDumb);
          end;
       { Build a return string for the Admin }
        s := Format(DP_MSG_DISABLED_LOGIN, [CMD[LOGIN_TO_DISABLE]]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
      end;
  end;
end;
//==============================================================================
procedure TConnections.CMD_Enable(var Connection: TConnection;
  var CMD: TStrings);
const
  LOGIN_TO_ENABLE = 1;
var
  Return: Integer;
  s: string;
begin
  { Verify admin }
  {if Connection.AdminLevel <> alSuper then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_SUPER_ADMIN_ONLY]);
      Exit;
    end;}
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  { Submit db call }
  s := Copy(CMD[LOGIN_TO_ENABLE], 1, 15);
  Return := fDB.Enable(s, 1);

  { Display return }
  case Return of
    -1: // not a valid Login
      begin
        s := Format(DP_MSG_LOGINID_INVALID, [s]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
      end;
    0: //Enabled bit set
      begin
       { Build a return string for the Admin }
        s := Format(DP_MSG_ENABLED_LOGIN, [CMD[LOGIN_TO_ENABLE]]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
      end;
  end;
end;
//==============================================================================
function TConnections.CMD_Login2(var Connection: TConnection; var CMD: TStrings): integer;
var
  Index, n: Integer;
  Banned: Boolean;
  Login, Password, Option, Ver, Mac, email,filename,s: string;
  DateUntil: TDateTime;
  Invisible: Boolean;
  conn: TConnection;
  slDumb: TStrings;
  //****************************************************************************
  procedure LoginError(p_Code, p_Msg: string; p_Result: integer);
  begin
    if p_Code <> '' then
      fSocket.Send(Connection, [DP_LOGIN_RESULT, p_Code, p_Msg]);
    if Assigned(Connection.Socket) then Connection.Socket.Close;
    Connection := nil;
    result := p_Result;
  end;
  //****************************************************************************
  function ProcessParams: Boolean;
  begin
    if CMD.Count < 5 then begin
      result := false;
      LoginError(DP_CODE_LOGIN_BADCLIENT, DP_MSG_LOGIN_BADCLIENT, 1);
      exit;
    end;

    try
      Login := CMD[1];
      Invisible := Login[1] = '&';
      if Invisible then
        Login := copy(Login, 2, length(Login));

      Password := CMD[2];
      Option := '15'; // CMD[3] is obsolete parameter
      Ver := CMD[4];
      Mac := CMD[5];
      if CMD.Count < 6 then CMD.Add('');
      Banned:=CMD[6]='1';
      result := true;
    except
      result := false;
    end;
  end;
  //****************************************************************************
  function ProcessInvisible: Boolean;
  var
    AdminLevel: integer;
  begin
    AdminLevel := fDB.ExecProc('dbo.proc_AdminLevel',[Login]);
    result := AdminLevel = ord(alSuper);
    if not result then
      LoginError(DP_CODE_LOGIN_INVALID, DP_MSG_LOGIN_INVALID, 5);
  end;
  //****************************************************************************
  function ProcessBanned: Boolean;
  var
    Status: integer;
  begin
    Status := fDB.ExecProc('dbo.proc_LoginStatus',[Login]);
    result := Status = 2;
    if not result then
      LoginError(DP_CODE_LOGIN_BANNEDCLIENT, DP_MSG_LOGIN_BANNED_CLIENT, 7);
  end;
  //****************************************************************************
  function ProcessAfterDisconnect: Boolean;
  var
    conn: TConnection;
  begin
    conn := GetConnection(Login);
    result := Assigned(conn) and (conn.Socket = nil);
    if not result then exit;

    { Switch to exisiting connection object. one that was
      created when this socket most recently connected. }
    conn.Socket := Connection.Socket;
    conn.Socket.Data := conn;
    conn.LoginAttempts := 0;
    conn.Version := Connection.Version;
    conn.Invisible := Connection.Invisible;

    Connection.Socket := nil;
    Connection.Free;

    Connection := conn;
  end;
  //****************************************************************************
  function ProcessLoginAttempts: Boolean;
  begin
    Connection.LoginAttempts := Connection.LoginAttempts + 1;
    result := Connection.LoginAttempts < 4;
    if not result then LoginError('', '', 3);
  end;
  //****************************************************************************
  function ProcessParamsLength: Boolean;
  begin
    result := (Length(Login) <= MAX_LOGIN_LENGTH);// and (Length(Password) <= MAX_LOGIN_LENGTH);
    if not result then LoginError(DP_CODE_LOGIN_INVALID, DP_MSG_LOGIN_INVALID, 4);
  end;
  //****************************************************************************
  procedure ProcessDBError;
  begin
    case Connection.LoginID of
      -2: LoginError(DP_CODE_LOGIN_INVALID, DP_MSG_LOGIN_INVALID, 5);
      -3: LoginError(DP_CODE_LOGIN_DISABLED, DP_MSG_LOGIN_DISABLED, 6);
      -4: LoginError(DP_CODE_LOGIN_BANNEDCLIENT, DP_MSG_LOGIN_BANNED_CLIENT, 7);
      -5: LoginError(DP_CODE_LOGIN_CLIENT_LOGGEDIN, DP_MSG_LOGIN_CLIENT_LOGGEDIN, 8);
      -9: LoginError(DP_CODE_LOGIN_DBERROR, DP_MSG_DB_ERROR, 9);
    end;
  end;
  //****************************************************************************
  procedure SendRoomsInfo;
  begin
    fRooms.SendRoomDefs(Connection);
    // entering rooms
    if Connection.RoomCount > 0 then begin
      fRooms.ReEnterRoom(Connection)
    end else begin
      if Connection.AdminLevel > alHelper then
        fRooms.EnterRoom(Connection, -1);
      if Connection.AdminLevel > alNone then
        fRooms.EnterRoom(Connection, 0);

      fRooms.EnterRoom(Connection, 1);
      fRooms.EnterRoom(Connection, 2);
    end;
  end;
  //****************************************************************************
  procedure SendPing;
  var
    i: integer;
  begin
    Connection.PingLast := 101 + Random(450);
    fSocket.SmartSend(Connection, nil, [DP_PING_VALUE, Connection.PingLast], nil);
    fSocket.SmartSend(nil, nil, [DP_USER_PING_VALUE, Connection.Handle, Connection.PingLast], nil);

    for i := fConnections.Count - 1 downto 0 do
      fSocket.SmartSend(Connection, nil, [DP_USER_PING_VALUE, fConnections[i].Handle,
        fConnections[i].PingLast], nil);
  end;
  //****************************************************************************
begin
  result:=10; // unknown error

  if not ProcessParams then exit;
  if not ProcessParamsLength then exit;
  if Invisible and not ProcessInvisible then exit;
  if Banned and not ProcessBanned then exit;
  if Connection.LoginID > -1 then exit;
  if not ProcessLoginAttempts then exit;

  conn := GetLiveConnection(Login);

  Connection.Option := StrToInt(Option);
  Connection.Version := Ver;
  Connection.MAC := Mac;
  Connection.Invisible := Invisible;

  if not ProcessAfterDisconnect then begin
    fDB.Login(Connection, Login, Password, Mac);
    if Connection.LoginID < 0 then begin
      ProcessDbError;
      exit;
    end
  end;

  if (conn<>nil) then begin
    fSocket.Send(conn,[DP_SERVER_MSG, DP_ERR_2, 'You are nuked by server because another user with your name logged in.']);
    CMD_Bye(conn, slDumb);
  end;

  SendRoomsInfo;
  fDB.SendVersionLink(Connection);
  Connection.SetOnlineStatus(onlActive);

  Index := fConnections.IndexOf(Connection);
  if Index = -1 then begin
    fConnections.Add(Connection);
    if Connection.AdminLevel in [alNormal, alSuper] then FAdminConnections.Add(Connection);
  end;

  fSocket.Send(Connection, [DP_LOGIN_RESULT, DP_CODE_LOGIN_SUCCESS, '']);

  { Connection handle. Needs to proceede RestoreGames. }
  fSocket.Send(Connection, [DP_LOGIN, Connection.Handle, Connection.Title,
    IntToStr(Ord(Connection.AdminLevel)), InttoStr(Connection.ClubId),
    fClubs.NameById(Connection.ClubId)]);

  SendILogin(Connection);
  SendLogins(Connection);
  SendSettings(Connection);
  SendRatings(Connection);
  fOffers.SendSeeks(Connection);
  fGames.SendGames(Connection);

  Connection.SendNotifyList;

  { Messages. }
  if (CompareVersion(Connection.Version,VERSION_NEW_MESSAGE_SYSTEM)=-1) then
    fMessages.SendMessages(Connection);

  if (CompareVersion(Connection.Version,VERSION_IMAGES)>=0) then
    fDB.SendImages(Connection);

  FileName:=MAIN_DIR+PHOTO_USER_DIR+IntToStr(Connection.LoginId)+'.jpg';
  if FileExists(FileName) then begin
    s:=ReadStrFromFile(FileName);
    Connection.PhotoANSI:=EncryptANSI(s);
    fSocket.Send(Connection,[DP_PHOTO,Connection.Handle,'1',
      IntToStr(ControlSumm(Connection.PhotoANSI)),
      Connection.PhotoANSI]);
  end else
    Connection.PhotoANSI:='';

  fEvents.OnLogin(Connection);

  { Restore games left open because of an un-intentional disconnect. }
  fGames.RestoreGames(Connection);

  { Send welcome message }
  fMessages.SendWelcome(Connection);

  fSocket2.SendMyPhotoToAll(Connection);

  Connection.SendINotify(true);

  fSocket.Send(Connection,[DP_MM_INVITE,IntToStr(PORT_MM)]);
  Connection.LastTS:=Now;
  fDB.SendStatTypes(Connection);
  SendClubList(Connection);
  SendPing;
  ShoutIfNeed(Connection);

  { End buffering, send data. }
  if START_MESSAGE <> '' then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, START_MESSAGE]);

  s := fDB.GetNotes(Connection.LoginId);
  if s <> '' then s:=EncryptANSI(s);
  fSocket.Send(Connection, [DP_NOTES, s]);

  s:=FloatToStr(Date+Time);
  fSocket.Send(Connection, [DP_SERVER_TIME, s]);

  Connection.Rights.SelfProfile := not fDB.IsBanned(Connection.Handle, banProfile, DateUntil);
  Connection.Rights.Achievements := Connection.AchievementAllowed;
  Connection.SendRights;
  Connection.SendRoles;

  if Connection.Invisible then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'You are in stealth mode now. Nobody see you, but you cannot chat or play games.']);

  SendTimeOddsLimits(Connection);

  fAchievements.Send(Connection);
  fAchUserLibrary.OnNewConnection(Connection);
  //Connection.AchUserList.Send(Connection);

  { Messages. }
  n := fDB.CountNewMessages(Connection.LoginID);
  if n > 0 then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'You have '+IntToStr(n)+' new messages']);

  fSocket.Send(Connection, [DP_SPECIAL_OFFER, fDB.GetSpecialOffer]);

  case Connection.MembershipType of
    mmbNone:
      Connection.SendTrialWarning('Your membership has ended. You may only play standard rules games now.');
    mmbTrial:
      Connection.SendTrialWarning('Your free trial membership will end in ' +
        GetDateDiffStrRound(Connection.MembershipExpireDate, Date + Time));
    mmbCore:
      begin
        Connection.SendTrialWarning('You have limited access');
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, 'Click "http://www.infiniachess.com/core-members.html" for details about your limited access']);
      end;
  end;


  fDB.SendMembershipTypes(Connection);

  if FStartURLSentList.SetActionIfNeed(Connection.Handle, Date + Time) then
    if Connection.AdminLevel = alNone then
      fSocket.Send(Connection, [DP_URL_OPEN, URL_START])
    else
      fSocket.Send(Connection, [DP_URL_OPEN, URL_START_ADMIN]);

  //if DebugHook > 0 then fSocket.Send(Connection, [DP_ACH_FINISHED, '117']);

  result:=0;
end;
//==============================================================================
procedure TConnections.CMD_Login(var Connection: TConnection; var CMD: TStrings);
const
  LOGIN = 1;
  PASSWORD = 2;
  OPTION = 3;
  _VERSION = 4;
  MAC = 5;
var
  i,res: integer;
  sLogin,Version,MacAddress,IpAddress: string;
  Invisible: Boolean;
begin
  for i:=CMD.Count to 7 do CMD.Add('');
  sLogin:=CMD[1];
  Invisible := sLogin[1] = '&';
  if Invisible then
    sLogin := copy(sLogin, 2, length(sLogin));

  Version:=CMD[4];
  MacAddress:=CMD[5];
  if Assigned(Connection.Socket) then
    IpAddress:=Connection.Socket.RemoteAddress
  else
    IpAddress := '';

  try
     res:=CMD_Login2(Connection,CMD);
     fDB.ExecProc('dbo.proc_LoginHistory',[sLogin,MacAddress,IpAddress,Version,res,1,BoolTo_(Invisible,1,0)]);
  except
    on E:Exception do
    fDB.ExecProc('dbo.proc_LoginHistory',[sLogin,MacAddress,IpAddress,Version,10,1,BoolTo_(Invisible,1,0),E.Message]);
  end;
end;
//==============================================================================
procedure TConnections.CMD_MeSuper(var Connection: TConnection;
  var CMD: TStrings);
var
  MSec, Idle: Integer;
begin
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
  if abs(Idle - MSec) < 500 then
    begin
      Connection.AdminLevel := alSuper;
      Connection.Registered := True;
    end;
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVALID_COMMAND]);
end;
//==============================================================================
procedure TConnections.CMD_Mute(var Connection: TConnection; var CMD: TStrings);
var
  _Connection: TConnection;
  Return, n, i: Integer;
  Login, s, reason: string;
  Hours: integer;
begin
  { Verify admin }
  {if Connection.AdminLevel in [alNone, alHelper]  then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
      Exit;
    end;}
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  { Submit db call }
  Login := Copy(CMD[1], 1, 15);
  try
    Hours := StrToInt(CMD[2]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number format']);
    Exit;
  end;
  if (Connection.AdminLevel<alSuper) and (Hours>MAX_BAN_TIME) then Hours:=MAX_BAN_TIME;

  reason := '';
  for i := 3 to CMD.Count-1 do
    reason := reason + CMD[i] + ' ';

  Return := fDB.Mute(Login, Connection.Handle, 1, Hours, reason);

  { Display return }
  case Return of
    -1: // not a valid Login
      begin
        Login := Format(DP_MSG_LOGINID_INVALID, [Login]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Login]);
      end;
    0: //Mute bit set
      begin
        _Connection := GetConnection(Login);
        if Assigned(_Connection) then begin
          _Connection.Muted := True;
          _Connection.MutedDateUntil := Date + Hours/24.0;
        end;
        s := Format(DP_MSG_MUTED, [Login]);
        if Hours = UNLIMITED_BAN_TIME then s:=s+' forever'
        else s:=s+' for '+IntToStr(Hours)+' hours';
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
      end;
  end;
end;
//==============================================================================
procedure TConnections.CMD_NotifyAdd(var Connection: TConnection;
  var CMD: TStrings);
var
  _Connection: TConnection;
  Notify: TNotify;
  LoginID: Integer;
  Login: string;
begin
  { Verify registered lgoin }
  if not Connection.Registered then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_REGISTERED_ONLY]);
    exit;
  end;
  { Check the Notify count of the Connection. }
  if Connection.NotifyCount[ntFriend] >= NOTIFY_LIMIT then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_NOTIFY_LIMIT_MET, [CMD[1]])]);
    exit;
  end;
  { Verify the paramaters }
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;
  { Verify the requested Notify Login. The fDB process returns the ID of the
    NotifyLogin requested or an error code:
    -1=already on list,-2=invalid login  }
  Login := Copy(CMD[1], 1, 15);
  LoginID := fDB.NotifyAdd(Connection.LoginID, Login, ntFriend);
  case LoginID of
    DB_ERROR: exit;
    -2:
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_LOGINID_INVALID, [CMD[1]])]);
        exit;
      end;
    -1:
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_NOTIFY_ALREADY, [CMD[1]])]);
        exit;
      end;
  end;
  Connection.AddNotify(LoginID, Login, '', ntFriend, true, true);
end;
//==============================================================================
procedure TConnections.CMD_NotifyRemove(var Connection: TConnection;
  var CMD: TStrings);
var
  _Connection: TConnection;
  Notify: TNotify;
  Index, LoginID: Integer;
  login, title: string;
begin
  { Verify registered lgoin }
  if not Connection.Registered then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_REGISTERED_ONLY]);
    exit;
  end;
  { Verify the paramaters }
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;
  { Remove the requested Notify Login. The fDB process returns the ID of the
    NotifyLogin begin removed or an error code:
    -1=not on list, -2=invalid login, -3=DB error of some sort. }
  login := Copy(CMD[1], 1, 15);
  title := fDB.GetTitle(login);
  LoginID := fDB.NotifyRemove(Connection.LoginID, Login, ntFriend);

  if LoginID > -1 then begin
    Connection.RemoveNotify(LoginID, true);
    fSocket.Send(Connection, [DP_NOTIFY_REMOVE, IntToStr(LoginID), Login, title,
      IntToStr(ord(ntFriend))]);
  end;
end;
//==============================================================================
procedure TConnections.CMD_Nuke(var Connection: TConnection; var CMD: TStrings);
const
  LOGIN_TO_NUKE = 1;
  ADMIN_REASON = 2;
var
  _Connection: TConnection;
  s: string;
  slDumb: TStrings;
begin
  { Force a user off the server. }
  { Check the administrative level of the Connection issuing the command. }
  {if Connection.AdminLevel in [alNone, alHelper] then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
      Exit;
    end;}
  { Check the param count. }
  if CMD.Count < 3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  { Attempt to find the login and nuke it. }
  _Connection := GetConnection(CMD[LOGIN_TO_NUKE]);
  if Assigned(_Connection) then
    begin
      { Can't nuke yourself. }
      if Connection = _Connection then Exit;
      { Inform the person getting nuked. }
      fSocket.Send(_Connection, [DP_SERVER_MSG, DP_ERR_2, CMD[ADMIN_REASON]]);
      { Build a return string for the Admin }
      s := Format(DP_MSG_LOGIN_NUKED, [_Connection.Handle]);
      { Force the player off }
      CMD_Bye(_Connection, slDumb);
      fDB.ExecProc('dbo.proc_BanHistory',
        [CMD[LOGIN_TO_NUKE],Connection.Handle,1,3,null,CMD[ADMIN_REASON]]);
      { Inform the Admin. }
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
    end
  else
    begin
      { Login not found. Inform admin. }
      s := Format(DP_MSG_LOGIN_NOT_LOGGEDIN, [CMD[LOGIN_TO_NUKE]]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
    end;
end;
//==============================================================================
procedure TConnections.CMD_Order(var Connection: TConnection; var CMD: TStrings);
var
  Login: string;
  conn: TConnection;
begin
  if CMD.Count < 3 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login := CMD[1];

  conn := GetConnection(Login);
  if conn = nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,Login + ' is not summoned']);
    exit;
  end;

  if conn.ConnectionType = cntPlayer then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,Login + ' is real player, you cannot order him']);
    exit;
  end;

  conn.Bot.OnOrder(Connection, CMD);
end;
//==============================================================================
procedure TConnections.CMD_Register(var Connection: TConnection;
  var CMD: TStrings);
{var
  Index,CountryId,SexId,Age,n: Integer;
  s,AuthKey,sEmail,sMac,sLanguage: string;
  PublicEmail, ShowBirthday: Boolean;
  Birthday: TDateTime;}
begin
  fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_BAD_CLIENT,
        'For new user registration you need to go to www.infiniachess.com/downloads.aspx', CMD[1], CMD[2]]);
  exit;

  {if Connection.LoginID > -1 then
    begin
      fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_LOGGEDIN,
        DP_MSG_REGISTER_LOGGEDIN, '', '']);
      Exit;
    end;}

  { Parameter check:
    CMD[0] = /Command
    CMD[1] = Login (LOGIN)
    CMD[2] = Password (PASSWORD)
    CMD[3] = Email address (EMAIL)
    CMD[4] = MAC Address (MAC)}

  { Version check }
  { As of ver 7 the client is required to send email .
    Older clients didn't send all 3 paramerters. This is how we'll know until
    ver 7 is reqired }


  {if CMD.Count < 4 then
    begin
      fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_BAD_CLIENT,
        DP_MSG_REGISTER_BAD_CLIENT, CMD[LOGIN], CMD[PASSWORD]]);
      Exit;
    end;

  // Add a default one for mac
  if CMD.Count < 5 then CMD.Add('');

  if CMD.Count < 5 then
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;

  sEmail:=CMD[EMAIL];
  if (trim(sEmail)='') or (pos('@',sEmail)=0) then begin
    fSocket.Send(Connection,
      [DP_SERVER_MSG, DP_ERR_2, 'Incorrect email']);
    Exit;
  end;

  if (Length(CMD[LOGIN]) > MAX_LOGIN_LENGTH)
  or (Length(CMD[PASSWORD]) > MAX_PWD_LENGTH)
  or (Length(CMD[EMAIL]) > MAX_EMAIL_LENGTH)
  or (Length(CMD[MAC]) > MAX_MAC_LENGTH) then
    begin
      fSocket.Send(Connection,
        [DP_REGISTER, DP_CODE_REGISTER_BAD_PARM, DP_MSG_REGISTER_BAD_PARM]);
      Exit;
    end;

  sMac:=CMD[MAC];
  if (sMac <> '') and (Connection.AdminLevel <> alSuper) then begin
    n:=fDB.ExecProc('dbo.proc_GetNumberOfLogins',[sMac]);
    if n>=MAX_NUMBER_OF_LOGINS_PER_MAC then begin
      fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_TOO_MANY,
        DP_MSG_REGISTER_TOO_MANY, CMD[LOGIN], CMD[PASSWORD]]);
      Exit;
    end;
  end;

  if CMD.Count<=5 then begin
    CountryId:=-1;
    SexId:=-1;
    Age:=0;
  end else begin
    Countryid:=StrToInt(CMD[5]);
    SexId:=StrToInt(CMD[6]);
    Age:=StrToInt(CMD[7]);
  end;

  if CMD.Count <= 8 then begin
    sLanguage := 'English';
    PublicEmail := false;
  end else begin
    sLanguage := CMD[8];
    PublicEmail := CMD[9] = '1';
  end;

  if CMD.Count > 10 then Birthday := StrToInt(CMD[10])
  else Birthday := 0;

  ShowBirthday := (Cmd.Count > 11) and (CMD[11] = '1');

  AuthKey:=GenerateAuthKey;
  // Attempt to register.
  Index := fDB.LoginRegister(CMD[LOGIN], CMD[PASSWORD], CMD[EMAIL], CMD[MAC], AuthKey,
    CountryId, SexId, Age, sLanguage, PublicEmail, Birthday, ShowBirthday);

  case Index of
    0: // Success
      begin
        s := Format(DP_MSG_REGISTER_SUCCESS, [CMD[LOGIN]]);
        fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_SUCCESS,
          s, CMD[LOGIN], CMD[PASSWORD]]);
        fDB.SendAuthKey(Connection,CMD,false,'register');
      end;
    -1: // Bad Login
      begin
        s := Format(DP_MSG_REGISTER_BAD_LOGIN, [CMD[LOGIN]]);
        fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_BAD_LOGIN,
          s, CMD[LOGIN], CMD[PASSWORD]]);
      end;
    -2: // Bad Password
      begin
        s := Format(DP_MSG_REGISTER_BAD_PASSWORD, [CMD[PASSWORD]]);
        fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_BAD_PASSWORD,
          s, CMD[LOGIN], CMD[PASSWORD]]);
      end;
    -3: // Login Taken
      begin
        s := Format(DP_MSG_REGISTER_LOGIN_TAKEN, [CMD[LOGIN]]);
        fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_LOGIN_TAKEN,
          s, CMD[LOGIN], CMD[PASSWORD]]);
      end;
    -4: // Inappropriate
      begin
        s := Format(DP_MSG_REGISTER_INAPPROPRIATE, [CMD[LOGIN]]);
        fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_INAPPROPRIATE,
          s, CMD[LOGIN], CMD[PASSWORD]]);
      end;
    -5: // Banned MAC
      begin
        fSocket.Send(Connection, [DP_REGISTER, DP_CODE_REGISTER_CLIENT_BANNED,
          DP_MSG_REGISTER_CLIENT_BANNED, CMD[LOGIN], CMD[PASSWORD]]);
      end;
    DB_ERROR: // DB error. Need to send a message to user.
  end;}
end;
//==============================================================================
procedure TConnections.CMD_RequestUserInfo(var Connection: TConnection; var CMD: TStrings);
var
  s, Login: string;
  LoginID: integer;
  conn: TConnection;
begin
  if CMD.Count < 2  then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  s := CMD[1];
  if s[1] = '#' then begin
    LoginID := StrToInt(copy(s, 2, length(s)));
    conn := GetConnection(LoginID);
  end else begin
    Login := s;
    conn := GetConnection(Login);
  end;
  if Assigned(conn) then
    SendLoginInfo(Connection, conn);
end;
//==============================================================================
procedure TConnections.CMD_Set(var Connection: TConnection; var CMD: TStrings);
const
  SET_NAME = 1;
  SET_VALUE = 2;
  MAX_RATING = 3000;
  { Possible settings }
  CMD_STR_AUTOFLAG = 'autoflag'; { bit }
  CMD_STR_OPEN = 'open'; { bit }
  CMD_STR_RATED = 'rated'; { bit }
  CMD_STR_COLOR = 'color'; { int }
  CMD_STR_INITIAL = 'initial'; { int }
  CMD_STR_INC = 'inc'; { int }
  CMD_STR_MAXRATING = 'maxrating'; { int }
  CMD_STR_MINRATING = 'minrating'; { int }
  CMD_STR_RATEDTYPE = 'ratedtype'; { int }
  CMD_STR_REMOVEOFFERS = 'removeoffers';
var
  Value: Integer;
  s: string;
begin
  { Param count check. }
  if CMD.Count < 3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;

  { Try to find the setting, examine the value for proper range. }
  try
    { Since at this point all settings are numeric types, this call can be made
      once. If string values are expected this will need to change. }
    Value := StrToInt(CMD[SET_VALUE]);
    if CMD[SET_NAME] = CMD_STR_AUTOFLAG then
      begin
        if (Value < 0) or (Value > 1) then
          raise Exception.Create('Invalid Param range');
        Connection.AutoFlag := Boolean(Value);
      end
    else if CMD[SET_NAME] = CMD_STR_OPEN then
      begin
        if (Value < 0) or (Value > 1) then
          raise Exception.Create('Invalid Param range');
        Connection.Open := Boolean(Value);
      end
    else if CMD[SET_NAME] = CMD_STR_RATED then
      begin
        if (Value < 0) or (Value > 1) then
          raise Exception.Create('Invalid Param range');
        Connection.Rated := Boolean(Value);
      end
    else if CMD[SET_NAME] = CMD_STR_COLOR then
      begin
        if (Value < -1) or (Value > 1) then
          raise Exception.Create('Invalid Param range');
        Connection.Color := Value;
      end
    {else if CMD[SET_NAME] = CMD_STR_INITIAL then
      begin
        if (Value < 0) or (Value > MAX_MINUTES) then
          raise Exception.Create('Invalid Param range');
        Connection.InitialTime := Value;
      end}
    else if CMD[SET_NAME] = CMD_STR_INC then
      begin
        if (Value < MIN_SECS) or (Value > MAX_SECS) then
          raise Exception.Create('Invalid Param range');
        Connection.IncTime := Value;
      end
    else if CMD[SET_NAME] = CMD_STR_MAXRATING then
      begin
        if (Value < 0) or (Value > MAX_RATING) then
          raise Exception.Create('Invalid Param range');
        Connection.MaxRating := Value;
      end
    else if CMD[SET_NAME] = CMD_STR_MINRATING then
      begin
        if (Value < 0) or (Value > MAX_RATING) then
          raise Exception.Create('Invalid Param range');
        Connection.MinRating := Value;
      end
    else if CMD[SET_NAME] = CMD_STR_RATEDTYPE then
      begin
        if (Value < 0) or (Value > Ord(High(TRatedType))) then
          raise Exception.Create('Invalid Param range');
        Connection.RatedType := TRatedType(Value);
      end
    else if CMD[SET_NAME] = CMD_STR_REMOVEOFFERS then
      begin
        if (Value < 0) or (Value > 1) then
          raise Exception.Create('Invalid Param range');
        Connection.RemoveOffers := Boolean(Value);
      end
    else
      begin
        s := Format(DP_MSG_NON_EXISTANT_SETTING, [CMD[SET_NAME]]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
        Exit;
      end;
  except
    { Error with a paramater. Not the correct type or out of range. }
    s := Format(DP_MSG_CANNOT_ASSIGN, [CMD[SET_VALUE], CMD[SET_NAME]]);
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
    Exit;
  end;

  { Still in it. Inform the user. }
  s := Format(DP_MSG_SETTING_ASSIGNED, [CMD[SET_VALUE], CMD[SET_NAME]]);
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);

  { Send DP_SETTINGS }
  SendSettings(Connection);
end;
//==============================================================================
procedure TConnections.CMD_SetAll(var Connection: TConnection;
  var CMD: TStrings);
begin
  { Sets user variables. It's a quiet command. No error status sent back. }
  try
    with Connection do
      begin
        AutoFlag := Boolean(StrToInt(CMD[1]));
        Open := Boolean(StrToInt(CMD[2]));
        RemoveOffers := Boolean(StrToInt(CMD[3]));
        InitialTime := CMD[4];
        IncTime := StrToInt(CMD[5]);
        Color := StrToInt(CMD[6]);
        Rated := Boolean(StrToInt(CMD[7]));
        RatedType := TRatedType(StrToInt(CMD[8]));
        if CompareVersion(Connection.Version,'7.7j')>-1 then begin
          MaxRating := StrToInt(CMD[9]);
          MinRating := StrToInt(CMD[10]);
        end else begin
          MaxRating:=3000;
          MinRating:=1;
        end;
        if CMD.Count<12 then CReject:=false
        else CReject:=CMD[11]='1';

        if CMD.Count<13 then PReject:=false
        else PReject:=CMD[12]='1';

        if CMD.Count<14 then Email:=''
        else EMail:=CMD[13];

        if CMD.Count<15 then CountryId:=-1
        else CountryId:=StrToint(CMD[14]);

        if CMD.Count<16 then SexId:=-1
        else SexId:=StrToInt(CMD[15]);

        if CMD.Count<17 then Age:=0
        else Age:=StrToInt(CMD[16]);

        if CMD.Count<18 then RejectWhilePlaying:=true
        else RejectWhilePlaying:=CMD[17]='1';

        if CMD.Count<19 then BadLagRestrict:=false
        else BadLagRestrict:=CMD[18]='1';

        if CMD.Count<20 then LoseOnDisconnect:=false
        else LoseOnDisconnect:=CMD[19]='1';

        if CMD.Count<21 then SeeTourShoutsEveryRound:=true
        else SeeTourShoutsEveryRound:=CMD[20]='1';

        if CMD.Count<22 then BusyStatus:=false
        else BusyStatus:=CMD[21]='1';

        if CMD.Count>=23 then Language:=CMD[22];

        if CMD.Count>=24 then PublicEmail:=CMD[23]='1';

        if CMD.Count >= 25 then Birthday := StrToInt(CMD[24]);

        if CMD.Count >= 26 then ShowBirthday := CMD[25] = '1';

        if CMD.Count >= 27 then begin
          AutoMatch := CMD[26] = '1';
          AutoMatchMinR := StrToInt(CMD[27]);
          AutoMatchMaxR := StrToInt(CMD[28]);
        end else begin
          AutoMatch := true;
          AutoMatchMinR := MinRating;
          AutoMatchMaxR := MaxRating;
        end;

        if CMD.Count >= 30 then
          AllowSeekWhilePlaying := CMD[29] = '1'
        else
          AllowSeekWhilePlaying := false;
      end;
  except
  end;
  fDB.UpdateLoginSettings(Connection);
  SendSettings(Connection);
end;
//==============================================================================
procedure TConnections.CMD_Shout(var Connection: TConnection; var CMD: TStrings);
const
  SHOUT_MSG = 1;
begin
  { Verify login not muted. Even admins may be muted.  }
  if Connection.Invisible then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVISIBLE_CHAT]);
    exit;
  end;

  if Connection.Muted = True then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MUTE]);
      Exit;
    end;

  { Admins only. }
  {if Connection.AdminLevel = alNone then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
      Exit;
    end;}

  if CMD.Count < 2 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
      DP_MSG_INCORRECT_PARAM_COUNT])
  else
    begin
      fSocket.Send(FConnections, [DP_SHOUT, Connection.Handle, Connection.Title,
        CMD[SHOUT_MSG]],Connection);
      Connection.LastCmd := CMD_STR_SHOUT;
      Connection.CmdParam := '';
    end;
end;
//==============================================================================
procedure TConnections.CMD_Tell(var Connection: TConnection; var CMD: TStrings);
var
  conn: TConnection;
  s, place, recepient, msg: string;
  color: TColor;
begin
  { Verify login not muted }
  if Connection.Muted then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MUTE]);
    exit;
  end;

  if CMD.Count=3 then CMD.Insert(1,'-1'); // for very old clients

  if CMD.Count < 4 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  color := StrToInt(CMD[1]);
  recepient := CMD[2];
  msg := CMD[3];

  conn := GetConnection(recepient);

  if not Assigned(conn) or not Assigned(conn.Socket) or conn.Invisible then begin
    s := Format(DP_MSG_LOGIN_NOT_LOGGEDIN, [recepient]);
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
    exit;
  end;

  { Censor check - Can't issue a /tell if I'm being censored. }
  if conn.Censors[Connection] then begin
    s := Format(DP_MSG_CENSORED, [recepient]);
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, s]);
    exit;
  end;

  { Censor check - Can't issue a /tell to somebody I'm censoring. }
  if Connection.Censors[conn] then begin
    s := Format(DP_MSG_CENSORING, [recepient]);
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, s]);
    exit;
  end;

  if conn.BusyStatus and conn.IsPlayingGame then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, conn.Handle+' is playing game now and cannot get your message']);
    exit;
  end;

  if (Connection.MembershipType = mmbNone) and (conn.AdminLevel = alNone) then
    exit;

  fSocket.SmartSend(conn, nil,
   [DP_TELL_LOGIN,
    Connection.LoginID, Connection.Handle, Connection.Title,
    Connection.LoginID, Connection.Handle, Connection.Title,
    msg, Connection.RatingString, color], nil);

  if Connection <> conn then
    fSocket.SmartSend(Connection, nil,
     [DP_TELL_LOGIN,
      IntToStr(Connection.LoginID), Connection.Handle, Connection.Title,
      IntToStr(conn.LoginID), conn.Handle, conn.Title,
      msg, conn.RatingString, color], nil);

  if conn.Handle<Connection.Handle then
    place:=conn.Handle+'/'+Connection.Handle
  else
    place:=Connection.Handle+'/'+conn.Handle;

  fDB.AddChatLog(Date+Time, Connection.Handle, 'T', 'S', place, msg);

  Connection.LastCmd := CMD_STR_TELL;
  Connection.CmdParam := recepient;
end;
//==============================================================================
procedure TConnections.CMD_Unknown(var Connection: TConnection;
  var CMD: TStrings);
begin
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVALID_COMMAND]);
end;
//==============================================================================
procedure TConnections.CMD_UnMute(var Connection: TConnection;
  var CMD: TStrings);
var
  _Connection: TConnection;
  Return: Integer;
  s: string;
begin
  { Verify admin }
  {if Connection.AdminLevel in [alNone, alHelper] then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
      Exit;
    end;}
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  { Submit db call }
  s := Copy(CMD[1], 1, 15);
  Return := fDB.Mute(s, Connection.Handle, 0, 0, '');

  { Display return }
  case Return of
    -1: // not a valid Login
      begin
        s := Format(DP_MSG_LOGINID_INVALID, [s]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
      end;
    0: //Mute bit set
      begin
        _Connection := GetConnection(s);
        if Assigned(_Connection) then _Connection.Muted := False;
        s := Format(DP_MSG_UNMUTED, [s]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
      end;
  end;
end;
//==============================================================================
procedure TConnections.Flush;
var
  conn: TConnection;
  i: Integer;
begin
  for i := fConnections.Count - 1 downto 0 do begin
    conn := fConnections[i];
    if (conn.OnlineStatus = onlDisconnected) and (GetDateDiffMSec(conn.LastTS, Now) > NET_TIMEOUT) then
      Release(conn, true);
  end;
end;
//==============================================================================
procedure TConnections.Ping;
var
  i: integer;
begin
  for i := fConnections.Count - 1 downto 0 do begin
    if fConnections[i].OnlineStatus = onlDisconnected then continue;
    
    fSocket.SmartSend(fConnections[i], nil, [DP_PING], nil);
    fConnections[i].LastTS := Now;
  end;
end;
//==============================================================================
procedure TConnections.Release(var Connection: TConnection;
  FreeConnection: Boolean);
var
  _Connection: TConnection;
  _Notify: TNotify;
  Index: Integer;
begin
  fSocket.Buffer := True;

  fOffers.Release(Connection);
  fGames.Release(Connection, FreeConnection);
  fGames.SetDisconnectionTime(Connection);

  if FreeConnection then fRooms.Release(Connection);

  Connection.SendINotify(false);
  fEvents.OnConnectionRelease(Connection);
  fSocket.Send(Connection, [DP_BYE]);
  SendILogoff(Connection);

  if FreeConnection and (Connection.LoginID > -1) then
    fDB.Logoff(Connection);

  fAchUserLibrary.OnFreeConnection(Connection);

  FAdminConnections.Remove(Connection);
  Index := fConnections.IndexOf(Connection);
  if Index > -1 then FConnections.Delete(Index);
end;
//==============================================================================
procedure TConnections.SendILogin(var Connection: TConnection);
var
  _Connection: TConnection;
  i: integer;
begin
  if Connection.Invisible then exit;
  for i := 0 to FConnections.Count - 1 do
    SendLoginInfo(FConnections[i], Connection);

  {fSocketMM.Send(FConnections, [DPM_PHOTO, Connection.Handle,
    '1', Connection.PhotoANSI]);}
end;
//==============================================================================
procedure TConnections.SendILogoff(var Connection: TConnection);
begin
  { Called when a Connection logs out. Good idea to have fSocket.Buffer set
    to True first. }
  fSocket.Send(FConnections, [DP_LOGOFF, IntToStr(Connection.LoginID),
    Connection.Handle, Connection.Title],Connection);
end;
//==============================================================================
procedure TConnections.SendLoginInfo(const p_Receiver: TConnection; const Connection: TConnection);
var
  ImageIndex: integer;
  VersionImagesVisible: Boolean;
begin
  VersionImagesVisible := (p_Receiver.AdminLevel > alNone) or (p_Receiver = Connection);
  if not VersionImagesVisible then ImageIndex := Connection.ImageIndex
  else
    if CompareVersion(Connection.Version, MIN_SUPPORTED_VER) = -1 then
      ImageIndex := 4
    else if Connection.IsOldVersion then
      ImageIndex := 5
    else
      ImageIndex := Connection.ImageIndex;

  fSocket.SmartSend(p_Receiver, nil,
   [DP_LOGIN2,
    Connection.LoginID,
    Connection.Handle,
    Connection.Title,
    Connection.RatingString,
    ImageIndex,
    Connection.AdminLevel,
    Connection.Master,
    Connection.Created,
    Connection.AdminGreeted,
    Connection.ProvString,
    Connection.MembershipType,
    Connection.OnlineStatus],
   Connection);
end;
//==============================================================================
procedure TConnections.SendLogins(var Connection: TConnection);
var
  conn: TConnection;
  i: Integer;
begin

  fSocket.Send(Connection, [DP_LOGIN_BEGIN]);
  for i := FConnections.Count -1 downto 0 do begin
    conn := TConnection(FConnections[i]);
    if not conn.Invisible then
      SendLoginInfo(Connection, conn);
  end;
  fSocket.Send(Connection, [DP_LOGIN_END]);
end;
//==============================================================================
procedure TConnections.SendRatings(var Connection: TConnection);
var
  Index: Integer;
begin
  for Index := 0 to High(RATED_TYPES) do fSocket.Send(Connection, [DP_RATING,
    IntToStr(Index), IntToStr(Connection.Rating[TRatedType(Index)])]);
end;
//==============================================================================
procedure TConnections.SendSettings(var Connection: TConnection);
begin
  with Connection do
    fSocket.Send(Connection, [DP_SETTINGS,
      IntToStr(Integer(AutoFlag)),
      IntToStr(Integer(Open)),
      IntToStr(Integer(RemoveOffers)),
      InitialTime,
      IntToStr(IncTime),
      IntToStr(Color),
      IntToStr(Integer(Rated)),
      IntToStr(Ord(RatedType)),
      IntToStr(MaxRating),
      IntToStr(MinRating),
      BoolTo_(CReject,'1','0'),
      BoolTo_(PReject,'1','0'),
      Email,
      IntToStr(CountryId),
      IntToStr(SexId),
      IntToStr(Age),
      BoolTo_(RejectWhilePlaying,'1','0'),
      BoolTo_(BadLagRestrict,'1','0'),
      IntToStr(ord(Adult)),
      BoolTo_(LoseOnDisconnect,'1','0'),
      BoolTo_(SeeTourShoutsEveryRound,'1','0'),
      BoolTo_(BusyStatus,'1','0'),
      Language,
      BoolTo_(PublicEmail,'1','0'),
      IntToStr(Trunc(Birthday)),
      BoolTo_(ShowBirthday,'1','0'),
      BoolTo_(AutoMatch,'1','0'),
      IntToStr(AutoMatchMinR),
      IntToStr(AutoMatchMaxR),
      BoolTo_(AllowSeekWhilePlaying,'1','0')]);
end;
//==============================================================================
function TConnections.AddEngineUser(p_Login: string; var pp_Err: string): Boolean;
var
  conn: TConnection;
  EngineInfo: TEngineInfo;
  sl: TStrings;
  res, LoginID: integer;
  Rst: _RecordSet;
  Params: string;
  BotInfo: TBotInfo;
begin
  result := false;
  LoginID := fDB.GetLoginId(p_Login);
  if LoginID = -1 then begin
    pp_Err := 'User ' + p_Login + ' does not exists';
    exit;
  end;

  fDB.OpenRecordSet('dbo.proc_GetBots', [LoginID], Rst);

  if (Rst.State <> adStateOpen) or Rst.BOF then begin
    pp_Err := 'Bot ' + p_Login + ' does not exists';
    exit;
  end;

  EngineInfo := TEngineInfo.Create;
  EngineInfo.DirName := Rst.Fields[7].Value;
  EngineInfo.ExeName := Rst.Fields[8].Value;
  Params := Rst.Fields[9].Value;
  Str2StringList(Params, EngineInfo.Params, '|');
  EngineInfo.OpeningFileName:= nvl(Rst.Fields[13].Value, '');

  BotInfo := TBotInfo.Create;
  BotInfo.GameHiStrings := Rst.Fields[14].Value;
  BotInfo.GameByeStrings := Rst.Fields[15].Value;
  BotInfo.GameByeProb := Rst.Fields[16].Value;
  BotInfo.GameByeResList := Rst.Fields[17].Value;
  BotInfo.GameByeMovesLimit := Rst.Fields[18].Value;
  BotInfo.ResignScore := Rst.Fields[19].Value;
  BotInfo.DrawSuggestMovesLimit := Rst.Fields[20].Value;
  BotInfo.DrawSuggestScore := Rst.Fields[21].Value;
  BotInfo.DrawAcceptScore := Rst.Fields[22].Value;
  BotInfo.SeekTypes := Rst.Fields[23].Value;
  BotInfo.SeeksPerTime := Rst.Fields[24].Value;

  conn := TConnection.Create(EngineInfo, BotInfo);
  sl := TStringList.Create;
  sl.Add('CMD_LOGIN');
  sl.Add(p_Login);
  sl.Add(ENGINE_PASSWORD);
  sl.Add('15');
  sl.Add(MIN_SUPPORTED_VER);
  sl.Add('');
  sl.Add('0');
  try
    res := CMD_Login2(conn, sl);
    fDB.ExecProc('dbo.proc_LoginHistory',[sl[0],'','',sl[3],res,2,0]);
    if res <> 0 then pp_Err := 'CMD_Login2 returns ' + IntToStr(res);
    result := res = 0;
  except
    on E: Exception do
      fDB.ExecProc('dbo.proc_LoginHistory',[sl[0],'','',sl[3],10,2,0,E.Message]);
  end;
  sl.Free;
end;
//==============================================================================
procedure TConnections.AddFollow(Connection: TConnection; toname: string);
var n: integer;
begin
  if Connection=nil then exit;
  FollowList.Values[Connection.Handle]:=toname;
end;
//==============================================================================
procedure TConnections.RemoveFollow(Connection: TConnection);
var n: integer;
begin
  if Connection=nil then exit;
  n:=FollowList.IndexOfName(Connection.Handle);
  if n<>-1 then FollowList.Delete(n);
end;
//==============================================================================
procedure TConnections.RemoveFollow(nameto: string);
var
  i: integer;
begin
  for i:=FollowList.Count-1 downto 0 do
    if FollowList.Values[FollowList.Names[i]]=nameto then
      FollowList.Delete(i);
end;
//==============================================================================
procedure TConnections.CMD_Follow(var Connection: TConnection;
  var CMD: TStrings);
var
  Handle,s: string;
begin
  if CMD.Count<2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
        DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;

  Handle:=CMD[1];
  if GetConnection(Handle)=nil then
    begin
      fSocket.Send(Connection,[DP_SERVER_MSG, DP_ERR_2,
        Format(DP_MSG_LOGIN_NOT_LOGGEDIN,[Handle])]);
      Exit;
    end;

  if Connection.Handle=Handle then
    begin
      fSocket.Send(Connection,[DP_SERVER_MSG, DP_ERR_2,
        DP_MSG_FOLLOW_YOURSELF]);
      Exit;
    end;

  AddFollow(Connection,Handle);
  fSocket.Send(Connection,[DP_FOLLOW_START,Handle]);

  if fGames.IndexOf(Handle)<>-1 then begin
    s:='/observe '+Handle+#10;
    fCommand.Receive(Connection,s, cmtUsual);
  end;
end;
//==============================================================================
procedure TConnections.CMD_Unfollow(var Connection: TConnection;
  var CMD: TStrings);
begin
  RemoveFollow(Connection);
  fSocket.Send(Connection,[DP_FOLLOW_END]);
end;
//==============================================================================
procedure TConnections.DoEngineActions;
var
  i: integer;
  conn: TConnection;
begin
  for i := 0 to fConnections.Count - 1 do begin
    conn := TConnection(fConnections[i]);
    if conn.ConnectionType = cntEngine then
      conn.Bot.DoAction;
  end;
end;
//==============================================================================
procedure TConnections.DoFollows(const Handle1, Handle2: string);
var
  i: integer;
  s,val: string;
  conn: TConnection;
begin
  for i:=FollowList.Count-1 downto 0 do
    begin
      val:=FollowList.Values[FollowList.Names[i]];
      if (lowercase(val)=lowercase(Handle1)) or (lowercase(val)=lowercase(Handle2)) then begin
        conn:=GetConnection(FollowList.Names[i]);
        if conn<>nil then begin
          s:='/observe '+Handle1+#10;
          fCommand.Receive(conn,s,cmtUsual);
        end;
      end;
    end;
end;
//==============================================================================
procedure TConnections.CMD_ShowFollows(Connection: TConnection; FCMD: TStrings);
var
  i,n: integer;
  name,from,_to: string;
begin
  if FCMD.Count>2 then
    begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT]);
      exit;
    end;

  if FCMD.Count=1 then name:=''
  else name:=lowercase(FCMD[1]);

  n:=0;
  for i:=0 to FollowList.Count-1 do
    begin
      from:=FollowList.Names[i];
      _to:=FollowList.Values[from];
      if (name='') or (name=lowercase(from)) or (name=lowercase(_to)) then
        begin
          fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,from+' -> '+_to]);
          inc(n);
        end;
    end;
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'-------------']);
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('%d records',[n])]);
end;
//==============================================================================
procedure TConnections.CMD_Summon(var Connection: TConnection; var CMD: TStrings);
var
  Login, err: string;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login := CMD[1];
  {if lowercase(Login) <> 'gagarin' then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'You can summon only Gagarin']);
    exit;
  end;}

  if GetConnection(Login) <> nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,Login + ' is already summoned']);
    exit;
  end;

  if not AddEngineUser(Login, err) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG, DP_ERR_2, 'Error: ' + err]);
    exit;
  end;
  {AddEngineUser('Gagarin', 'ask14', 'Rybka 2.4', 'Rybkav2.4.w32.exe',
    'setoption name UCI_LimitStrength value true|setoption name UCI_Elo value 1200', true);}
end;
//==============================================================================
procedure TConnections.FrozeFollow(Connection: TConnection);
var
  n: integer;
begin
  if Connection.FollowFrozen then exit;
  n:=FollowList.IndexOfName(Connection.Handle);
  if n=-1 then exit;
  FollowList[n]:='#'+FollowList[n];
  Connection.FollowFrozen:=true;
  fSocket.Send(Connection,[DP_FOLLOW_START,'nobody']);
end;
//==============================================================================
procedure TConnections.UnFrozeFollow(Connection: TConnection);
var
  i,n: integer;
  s,name: string;
begin
  if not Connection.FollowFrozen then exit;
  Connection.FollowFrozen:=false;
  for i:=0 to FollowList.Count-1 do begin
    s:=FollowList[i];
    if s[1]='#' then begin
      n:=pos('=',s);
      name:=copy(s,2,n-2);
      if name=Connection.Handle then begin
        FollowList[i]:=copy(s,2,length(s));
        fSocket.Send(Connection,[DP_FOLLOW_START,copy(s,n+1,length(s))]);
        exit;
      end;
    end;
  end;
end;
//==============================================================================
function TConnections.Following(ConnFrom, ConnTo: TConnection): Boolean;
begin
  result:=FollowList.Values[ConnFrom.Handle]=ConnTo.Handle;
end;
//==============================================================================
procedure TConnections.CMD_AuthKey(var Connection: TConnection; var CMD: TStrings);
var
  login,password,auth_key,real_key,msg: string;
  res,n: integer;
begin
  login:=CMD[1];
  password:=CMD[2];
  auth_key:=CMD[3];
  real_key:=fDB.GetAuthKey(login);
  if auth_key=real_key then begin
    res:=fDB.UpdateLoginPrivate(login,password,'confirmed',1);
    case res of
      5: begin // success
           n:=0;
           msg:='You login is confirmed';
         end;
      -2: begin
            n:=-2;
            msg:='Invalid password';
          end;
    else  begin
            n:=-3;
            msg:='Unknown error during confirm email';
          end;
    end;
  end else begin
    n:=-1;
    msg:='Wrong key entered';
  end;
  fSocket.Send(Connection,[DP_AUTH_KEY_RESULT,IntToStr(n),msg]);
end;
//==============================================================================
procedure TConnections.UnbanByTime;
var
  i: integer;
  conn: TConnection;
begin
  if Date+Time-FLastUnbanByTime<1.0/(60*24) then exit;
  FLastUnbanByTime:=Date+Time;
  for i:=0 to Connections.Count-1 do begin
    conn:=TConnection(Connections[i]);
    if conn.Muted and (conn.MutedDateUntil<Date+Time) then begin
      conn.Muted:=false;
      conn.MutedDateUntil:=0;
      fSocket.Send(conn,[DP_SERVER_MSG,DP_ERR_0,'Your mute is finished by time']);
    end;

    if conn.EVBanned and (conn.EVBannedDateUntil<Date+Time) then begin
      conn.EVBanned:=false;
      conn.EVBannedDateUntil:=0;
      fSocket.Send(conn,[DP_SERVER_MSG,DP_ERR_0,'Your event ban is finished by time']);
    end;
  end;
end;
//==============================================================================
procedure TConnections.CMD_EventBan(var Connection: TConnection;
  var CMD: TStrings);
var
  _Connection: TConnection;
  Return: Integer;
  Login,s: string;
  Hours: integer;
begin
  { Verify admin }
  {if Connection.AdminLevel in [alNone, alHelper]  then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
      Exit;
    end;}
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  { Submit db call }
  Login := Copy(CMD[1], 1, 15);
  if CMD.Count < 3 then Hours:=UNLIMITED_BAN_TIME
  else
    try
      Hours := StrToInt(CMD[2]);
    except
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number format']);
      Exit;
    end;

  if (Connection.AdminLevel<alSuper) and (Hours>MAX_BAN_TIME) then Hours:=MAX_BAN_TIME;

  Return := fDB.EventBan(Login,Connection.Handle,Hours,1);

  { Display return }
  case Return of
    -1: // not a valid Login
      begin
        Login := Format(DP_MSG_LOGINID_INVALID, [Login]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Login]);
      end;
    0: //Mute bit set
      begin
        _Connection := GetConnection(Login);
        if Assigned(_Connection) then begin
          _Connection.EVBanned := True;
          _Connection.EVBannedDateUntil := Date + Hours/24.0;
        end;
        s := Login+' has been banned for events';
        if Hours = UNLIMITED_BAN_TIME then s:=s+' forever'
        else s:=s+' for '+IntToStr(Hours)+' hours';
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
        CMD_EventKickOut(Connection,CMD);
      end;
  end;
end;
//==============================================================================
procedure TConnections.CMD_EventUnBan(var Connection: TConnection;
  var CMD: TStrings);
var
  _Connection: TConnection;
  Return: Integer;
  s: string;
begin
  { Verify admin }
  {if Connection.AdminLevel in [alNone, alHelper] then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
      Exit;
    end;}
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  { Submit db call }
  s := Copy(CMD[1], 1, 15);
  Return := fDB.EventBan(s,Connection.Handle,0,2);

  { Display return }
  case Return of
    -1: // not a valid Login
      begin
        s := Format(DP_MSG_LOGINID_INVALID, [s]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
      end;
    0: //Mute bit set
      begin
        _Connection := GetConnection(s);
        if Assigned(_Connection) then _Connection.EVBanned := False;
        s := 'User '+s+' is unbanned for events';
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
      end;
  end;
end;
//==============================================================================
procedure TConnections.CMD_EventKickOut(var Connection: TConnection;
  var CMD: TStrings);
var
  Login: string;
  conn: TConnection;
  ev: TCSEvent;
begin
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;

  Login:=CMD[1];
  conn:=GetConnection(Login);
  if conn = nil then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, 'User '+Login+' is not connected']);
    Exit;
  end;
  if conn.EventId = 0 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, 'User '+Login+' is not joined to events now']);

    exit;
  end;
  ev:=fEvents.FindEvent(conn.EventId);
  if ev<>nil then ev.UserLeave(conn);
  fSocket.Send(Connection,[DP_SERVER_MSG, DP_ERR_0, 'User '+Login+' kicked out from event #'+IntToStr(conn.EventId)]);
end;
//==============================================================================
procedure TConnections.CMD_PhotoSend(Connection: TConnection;
  var CMD: TStrings);
var
  s,s1,ext,filename,dir,subdir,photoansi: string;
  i,ClubId: integer;
  conn: TConnection;
  st: TStringStream;
  bmp: Graphics.TBitMap;
  jpg: TJpegImage;
  tp: TPhotoType;
begin
  if CMD.Count < 4 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    Exit;
  end;

  if not Connection.Rights.SelfProfile then exit;

  tp:=TPhotoType(StrToInt(CMD[1]));
  ext:=CMD[2];
  s:=CMD[3];
  if (ext<>'bmp') and (ext<>'jpg') then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Wrong image extension']);
    Exit;
  end;

  if tp = phtClub then
    try
      ClubId:=StrToInt(CMD[4]);
    except
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number']);
      Exit;
    end;

  case tp of
    phtUser: subdir:='photo';
    phtClub: subdir:='club';
  end;

  dir:=MAIN_DIR+'img\'+subdir;
  if not DirectoryExists(MAIN_DIR+'img') then CreateDir(MAIN_DIR+'img');
  if not DirectoryExists(dir) then CreateDir(dir);

  case tp of
    phtUser: filename:=dir+'\'+IntToStr(Connection.LoginId)+'.jpg';
    phtClub: filename:=dir+'\'+IntToStr(ClubId)+'.jpg';
  end;
  if s='-' then begin
    if FileExists(filename) then
      DeleteFile(FileName);
    PhotoANSI:='';
  end else begin
    try
      s1:=DecryptANSI(s);
    except
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Wrong format of encrypted string']);
      Exit;
    end;
    if ext='jpg' then
      SaveStrToFile(FileName,s1)
    else begin // if ext='bmp'
      bmp:=TBitMap.Create;
      jpg:=TJpegImage.Create;
      st:=TStringStream.Create(s1);
      try
        bmp.LoadFromStream(st);
        jpg.Assign(bmp);
        jpg.CompressionQuality:=50;
        jpg.SaveToFile(FileName);
      finally
        bmp.Free;
        jpg.Free;
        st.Free;
      end;
    end;
    PhotoANSI:=s;
  end;
  case tp of
    phtUser:
      begin
        Connection.PhotoAnsi:=PhotoANSI;
        fSocket2.SendMyPhotoToAll(Connection);
      end;
    phtClub:
      begin
        fClubs.SetPhotoANSI(ClubId,PhotoANSI);
        fSocket.Send(Connections,[DP_CLUB_PHOTO,IntToStr(ClubId),PhotoANSI],nil);
      end;
  end;

  //fSocket2.Send(FConnections,[DPM_PHOTO,Connection.Handle,'1',ControlSumm(Connection.PhotoANSI),Connection.PhotoANSI]);
end;
//==============================================================================
function TConnections.GetConnectionMM(Socket: TCustomWinSocket): TConnection;
var
  i: integer;
begin
  for i:=0 to FConnections.Count-1 do begin
    result:=TConnection(FConnections[i]);
    if result.SocketMM = Socket then exit;
  end;
  result:=nil;
end;
//==============================================================================
procedure TConnections.ShoutIfNeed(Connection: TConnection);
var
  msg: string;
begin
  if Connection.Invisible or not AUTOSHOUTS then exit;
  msg:=fDB.GetShoutMessage(Connection);
  if msg <> '' then
    fSocket.Send(Self.Connections,[DP_SHOUT,'','',msg],Connection);
end;
//==============================================================================
function TConnections.GetLiveConnection(Handle: string): TConnection;
var
  i: integer;
begin
  for i:=0 to Connections.Count-1 do begin
    result:=TConnection(Connections[i]);
    if (lowercase(result.Handle) = lowercase(Handle)) and (result.Socket <> nil) then
      exit;
  end;
  result:=nil;
end;
//==============================================================================
function TConnections.NewLoginTransfer(const Connection: TConnection): Boolean;
begin
  result := CompareVersion(Connection.Version, VERSION_NEW_LOGIN_TRANSFER) >= 0;
end;
//==============================================================================
procedure TConnections.NullifyAllGamesPerDay;
var
  i: integer;
begin
  for i := fConnections.Count - 1 downto 0 do
    fConnections[i].GamesPerDayList.Nullify;
end;
//==============================================================================
function TConnections.OldLoginTransfer(const Connection: TConnection): Boolean;
begin
  result := not NewLoginTransfer(Connection);
end;
//==============================================================================
procedure TConnections.SendClubList(Connection: TConnection);
var
  i: integer;
  sl, slRes: TStringList;
  err, FileName, s, sID, sName, sStatusID, sInfo, sRequests, sSponsor, sClubType, sMembers: string;
begin
  fSocket.Send(Connection,[DP_CLUB_BEGIN]);
  sl:=TStringList.Create;
  slRes:=TStringList.Create;
  try
    try
      fDB.ReadProcList('dbo.proc_ShowLoginClubs',[Connection.Handle],
        '%d|%d|%s|%s|%d|%s|%d|%d', [0,1,2,3,4,5,6,7], slRes, err);
    except
      on E: Exception do
        exit;
    end;
    for i:=0 to slRes.Count-1 do begin
      Str2StringList(slRes[i],sl,'|');
      sID := sl[0];
      sStatusID := sl[1];
      sName:=sl[2];
      sInfo := sl[3];
      sRequests := sl[4];
      sSponsor := sl[5];
      sClubType := sl[6];
      sMembers := sl[7];

      fSocket.Send(Connection,[DP_CLUB, sID, sName, sStatusID, sRequests, sSponsor, sClubType, sMembers]);
      fSocket.Send(Connection,[DP_CLUB_INFO,sID,sInfo]);

      FileName:=MAIN_DIR+PHOTO_CLUB_DIR+sl[0]+'.jpg';
      if FileExists(FileName) then begin
        s:=ReadStrFromFile(FileName);
        s:=EncryptANSI(s);
        fSocket.Send(Connection,[DP_CLUB_PHOTO,sl[0],s]);
      end;
    end;
    fSocket.Send(Connection,[DP_CLUB_END]);
  finally
    sl.Free;
    slRes.Free;
  end;
end;
//==============================================================================
procedure TConnections.SendClubList(Connections: TObjectList);
var
  i: integer;
begin
  for i:=0 to Connections.Count-1 do
    SendClubList(TConnection(Connections[i]));
end;
//==============================================================================
procedure TConnections.CMD_ChangeClub(Connection: TConnection; var CMD: TStrings);
var
  NewClubId: integer;
  name: string;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    Exit;
  end;

  try
    NewClubID:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number']);
    Exit;
  end;

  if (NewClubID <> 1) and (Connection.MembershipType in [mmbNone, mmbCore]) then begin
    Connection.SendNoMembershipMsg(DP_MSG_NO_CLUBS);
    exit;
  end;

  name:=fClubs.NameById(NewClubId);
  if name = '' then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Club with this number does not exists']);
    Exit;
  end;

  Connection.ClubId := NewClubId;

  { Seeks. }
  fOffers.SendSeeks(Connection);
  fGames.SendGames(Connection);
  SendLogins(Connection);
  SendILogin(Connection);
  fEvents.OnLogin(Connection);
  fRooms.SendRoomSet(Connection);
  SendILogin(Connection);
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'You have successfully come to club '+name]);
  fSocket.Send(Connection,[DP_CLUB_CHANGED,IntToStr(NewClubId),name]);
end;
//==============================================================================
procedure TConnections.SetEnginePingValues;
var
  i: integer;
  conn: TConnection;
begin
  for I := 0 to fConnections.Count - 1 do begin
    conn := TConnection(fConnections[i]);
    if conn.ConnectionType = cntEngine then begin
      conn.PingLast := 101 + Random(450);
      conn.PingCount := conn.PingCount + 1;
      conn.PingAvg := ((conn.PingAvg * conn.PingCount) + conn.PingLast)
        div conn.PingCount;
      fSocket.Send(Connections,[DP_USER_PING_VALUE, conn.Handle,
        IntToStr(conn.PingLast)],conn);
    end;
  end;
end;
//==============================================================================
procedure TConnections.SetToSendTSER;
var
  i: integer;
  conn: TConnection;
begin
  for i:=0 to Connections.Count-1 do begin
    conn:=TConnection(Connections[i]);
    conn.Send:=conn.SeeTourShoutsEveryRound;
  end;
end;
//==============================================================================
procedure TConnections.CMD_DeleteProfilePhoto(Connection: TConnection; var CMD: TStrings);
var
  Login, filename: string;
  LoginId: integer;
begin
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;

  Login := CMD[1];
  LoginId := fDB.GetLoginId(Login);
  if LoginId = -1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Login does not exist']);
    exit;
  end;
  filename := MAIN_DIR+'img\photo\'+IntToStr(LoginId)+'.jpg';
  if FileExists(filename) then
    if DeleteFile(FileName) then fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Photo is successfully deleted'])
    else fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Cannot delete photo. File is busy'])
  else fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Photo does not exist in this profile']);
end;
//==============================================================================
procedure TConnections.CMD_SetProfileNotes(Connection: TConnection; var CMD: TStrings);
var
  Login, notes: string;
  res: Variant;
  i: integer;
begin
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;

  Login := CMD[1];
  if CMD.Count = 2 then notes := ''
  else
    for i:=2 to CMD.Count-1 do
      notes:=notes+CMD[i]+' ';
  res := fDB.ExecProc('dbo.proc_SetProfileNotes',[Login, notes]);
  if res = -1 then fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Login does not exist'])
  else fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Notes for login '+Login+' is successfully set']);
end;
//==============================================================================
procedure TConnections.CMD_SetNotes(Connection: TConnection; var CMD: TStrings);
var
  notes: string;
  i: integer;
begin
  if not Connection.Rights.SelfProfile then exit;
  if CMD.Count = 1 then notes := ''
  else
    try
      notes := DecryptANSI(CMD[1]);
    except
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, '/notes: wrong parameter']);
      Exit;
    end;
  fDB.ExecProc('dbo.proc_SetProfileNotes',[Connection.Handle, notes]);
  fSocket.Send(Connection, [DP_NOTES, CMD[1]]);
end;
//==============================================================================
function TConnections.FindIdByLogin(Login: string): integer;
var
  i: integer;
  conn: TConnection;
begin
  result := -1;
  Login := lowercase(Login);
  for i:=0 to fConnections.Count - 1 do begin
    conn := TConnection(fConnections[i]);
    if lowercase(conn.Handle) = Login then begin
      result := i;
      exit;
    end;
  end;
end;
//==============================================================================
procedure TConnections.SendTimeOddsLimits(Connection: TConnection);
var
  i: integer;
  L: TTimeOddsLimit;
begin
  fSocket.Send(Connection, [DP_TIMEODDSLIMIT_CLEAR]);
  for i := 0 to fTimeOddsLimits.Count - 1 do begin
    L := TTimeOddsLimit(fTimeOddsLimits[i]);
    fSocket.Send(Connection, [DP_TIMEODDSLIMIT,
      IntToStr(L.FInitTime), IntToStr(L.FIncTime),
      IntToStr(L.FMinInitTime), IntToStr(L.FMinIncTime),
      IntToStr(L.FMaxScoreDeviation),
      IntToStr(L.FScoreDeviationStart),
      IntToStr(L.FScoreDeviationEnd)]);
  end;
end;
//==============================================================================
procedure TConnections.SendTimeOddsLimits(Connections: TObjectList);
var
  i: integer;
  conn: TConnection;
begin
  for i := Connections.Count - 1 downto 0 do begin
    conn := TConnection(Connections[i]);
    SendTimeOddsLimits(conn);
  end;
end;
//==============================================================================
function TConnections.GetConnection(const LoginID: Integer): TConnection;
var
  i: Integer;
begin
  { Get Connection object based upon the unique Handle (player name) }
  for i:=0 to fConnections.Count-1 do begin
    result := TConnection(fConnections[i]);
    if result.LoginID = LoginID then exit;
  end;
  result := nil;
end;
//==============================================================================
{ TLoginActionDoneList }

constructor TLoginActionDoneList.Create(p_HoursLimit: real);
begin
  inherited Create;
  HoursLimit := p_HoursLimit;
end;
//==============================================================================
function TLoginActionDoneList.GetActionByLogin(p_Login: string): TLoginActionDone;
var
  index: integer;
begin
  index := GetIndexByLogin(p_Login);
  if index = -1 then result := nil
  else result := TLoginActionDone(Items[index]);
end;
//==============================================================================
function TLoginActionDoneList.GetIndexByLogin(p_Login: string): integer;
var
  i: integer;
begin
  p_Login := lowercase(p_Login);
  result := -1;
  for i := 0 to Count - 1 do
    if lowercase(TLoginActionDone(Items[i]).Login) = p_Login then begin
      result := i;
      exit;
    end;
end;
//==============================================================================
function TLoginActionDoneList.SetActionIfNeed(p_Login: string; p_DateTime: TDateTime): Boolean;
var
  Action: TLoginActionDone;
begin
  Action := GetActionByLogin(p_Login);
  if Action = nil then begin
    Action := TLoginActionDone.Create;
    Action.Login := p_Login;
    Action.DateTime := p_DateTime;
    Add(Action);

    result := true;
  end else begin
    result := (p_DateTime - Action.DateTime) * 24 > HoursLimit;
    Action.DateTime := p_DateTime;
  end;
end;
//==============================================================================
{ TConnectionList }

function TConnectionList.GetConnection(Index: integer): TConnection;
begin
  result := TConnection(Items[Index]);
end;
//==============================================================================
end.

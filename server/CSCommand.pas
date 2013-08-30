{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSCommand;

interface

uses
  Classes, SysUtils, CSConnection, CSOffer, scktcomp, Variants, contnrs, CSTypes;

type
  TCommandType = (cmtUsual, cmtMultiMedia);
  TCommandProcedure = procedure (var Connection: TConnection; var CMD: TStrings) of object;

  TDeferredCommand = class
  public
    Method: TCommandProcedure;
    Connection: TConnection;
    CMD: TStrings;
    TimeToLaunch: TDateTime;
    OnExceptionMethod: TObjectProcedure;

    constructor Create;
    destructor Destroy; override;
  end;

  TDeferredCommands = class(TObjectList)
  end;

  TCommand = class(TObject)
  private
    { Private declarations }
    FCommands: TStringList; { List of legitimet server commands }
    FCMD: TStrings; { Parsed command passed to appropriate functions }
    //F: TextFile;
    FCommandsZero: TStringList;
    FDeferredCommands: TDeferredCommands;

    function HaveRight(Login, Command: string): integer;
    procedure Parse(var Connection: TConnection; var Command: string);
    {procedure ParseMM(var Connection: TConnection; var Command: string;
      Socket: TCustomWinSocket = nil);}
    procedure ParseTell(var Connection: TConnection);
    procedure CMD_SetMode(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_SetStartMessage(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_PmExit(var Connection: TConnection; var CMD: TStrings);
    procedure SendAccessLevels(Connection: TConnection);

  protected
    { Protected declarations }

  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    function Receive(var Connection: TConnection; var Data: string;
      CommandType: TCommandType;
      Socket: TCustomWinSocket = nil): string;
    procedure SendTime(var Connection: TConnection; FCMD: TStrings);
    procedure Launch(p_Method: TCommandProcedure; Connection: TConnection;
      Params: array of Variant);
    procedure AddDeferredCommand(p_Method: TCommandProcedure;
      p_Connection: TConnection; p_Params: array of Variant;
      p_Delay: integer; p_OnExceptionMethod: TObjectProcedure);
    procedure DoDeferredCommands;

    procedure Test(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_SkipUpdate(var Connection: TConnection; var CMD: TStrings);

    property CommandsZero: TStringList read FCommandsZero;


  published
    { Publish declarations }
  end;

var
  fCommand: TCommand;

implementation

uses
  CSConst, CSConnections, CSGames, CSLibrary, CSMessages, CSOffers, CSProfiles,
  CSRooms, CSSocket, CSService, CSDb, CSEvents, CSLib, CSMail, CSTimeStat, CSSocket2,
  CSClub, CSAccessLevels, CSAchievements;

//==============================================================================
{procedure TCommand.ParseMM(var Connection: TConnection; var Command: string;
  Socket: TCustomWinSocket = nil);
var
  slCMD: TStrings;
  s: string;
  cmd: integer;
begin
  slCMD:=TStringList.Create;
  try
    if Command='' then exit;
    if Command[length(Command)]=#$A then
      SetLength(Command,length(Command)-1);

    Str2StringList(Command,slCMD,#32);

    if slCMD.Count=0 then exit;

    s:=slCMD[0];
    if copy(s,1,3)<>'cmm' then exit;

    try
      cmd:=StrToInt(copy(s,4,length(s)));
    except
      exit;
    end;

    if (Connection=nil) and (cmd<>CMM_INITIALIZE) then exit;

    case cmd of
      CMM_INITIALIZE: IdentifySocketMM(Socket,slCMD);
      CMM_PHOTO: fConnections.CMD_PhotoSend(Connection, slCMD);
      CMM_GET_ALL_PHOTO:
    else
      exit;
    end;

  finally
    slCMD.Free;
  end;
end;     }
//==============================================================================
procedure TCommand.AddDeferredCommand(p_Method: TCommandProcedure;
  p_Connection: TConnection; p_Params: array of Variant; p_Delay: integer;
  p_OnExceptionMethod: TObjectProcedure);
var
  dc: TDeferredCommand;
  i: integer;
begin
  dc := TDeferredCommand.Create;
  dc.Method := p_Method;
  dc.Connection := p_Connection;
  dc.CMD.Add(''); // command name, not needed here
  for i := Low(p_Params) to High(p_Params) do
    dc.CMD.Add(VarToStr(p_Params[i]));
  dc.TimeToLaunch := Now + p_Delay * 1.0 / MSecsPerDay;
  dc.OnExceptionMethod := p_OnExceptionMethod;
  FDeferredCommands.Add(dc);
end;
//==============================================================================
procedure TCommand.CMD_PmExit(var Connection: TConnection; var CMD: TStrings);
var
  LoginID: integer;
  conn: TConnection;
begin
  if CMD.Count < 2  then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    LoginID := StrToInt(CMD[1]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number']);
    exit;
  end;

  if Connection.LoginID = LoginID then exit;
  

  conn := fConnections.GetConnection(LoginID);
  if Assigned(conn) then
    fSocket.SmartSend(conn, nil, [DP_PM_EXIT, Connection.LoginID], nil);
end;
//==============================================================================
procedure TCommand.CMD_SetMode(var Connection: TConnection; var CMD: TStrings);
var
  Mode, OnOff: string;
  //***************************************************************************
  procedure SendUsageError;
  begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Usage:'+CMD[0]+' <mode> <on/off>']);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'  mode is one of: NOGAMES,SOCKETBUFFER']);
  end;
  //***************************************************************************
begin
  if CMD.Count = 1 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'NOGAMES = '+BoolTo_(MODE_NOGAMES,'ON','OFF')]);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'SOCKETBUFFER = '+BoolTo_(fSocket.ModeBuffer,'ON','OFF')]);
    exit;
  end;

  if CMD.Count<>3 then begin
    SendUsageError;
    exit;
  end;

  Mode := uppercase(CMD[1]);
  OnOff := Uppercase(CMD[2]);
  if (OnOff<>'ON') and (OnOff<>'OFF') then begin
    SendUsageError;
    exit;
  end;

  if (Mode = 'NOGAMES') then MODE_NOGAMES := OnOff = 'ON'
  else if (Mode = 'SOCKETBUFFER') then fSOcket.ModeBuffer := OnOff = 'ON'
  else begin
    SendUsageError;
    exit;
  end;

  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Mode is successfully set']);
end;
//==============================================================================
procedure TCommand.CMD_SetStartMessage(var Connection: TConnection; var CMD: TStrings);
var
  Msg: string;
  i: integer;
begin
  if CMD.Count = 1 then begin
    START_MESSAGE := '';
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Start message is successfully cleared']);
    exit;
  end;

  Msg:='';
  for i:=1 to CMD.Count-1 do Msg:=Msg+CMD[i]+' ';
  START_MESSAGE := Msg;
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Start message is successfully set']);
end;
//==============================================================================
procedure TCommand.CMD_SkipUpdate(var Connection: TConnection; var CMD: TStrings);
begin
  fSocket.Send(Connection, [DP_AUTOUPDATE, Connection.ProperVersion, LAST_EXE_LINK]);
  fDB.SaveLogUserAction(1, Connection.Handle, Connection.Version);
end;
//==============================================================================
procedure TCommand.Test(var Connection: TConnection; var CMD: TStrings);
begin
  fSocket.CloseSocket;
end;
//==============================================================================
procedure TCommand.Parse(var Connection: TConnection; var Command: string);
var
  Code, Cmd, Len, Value, ParCount, n: Integer;
  PStart, PEnd: TDateTime;
  s, msg: string;
begin
  { Parse and distribute the command }
  PStart := Now;

  FCMD.Clear;
  Cmd := -1;

  { fSocket.TSocket.ClientRead has send a 'command' (ending in #10). Parse the
    Command string and place the individual parameters into a TStringList
    (FCMD). Examine the first (space delimeted) parameter of the Command string
    and determine if the remainder of the Command string is to be treated as a
    series of space delimited parameters or if it should be treated as one large
    parameter (the message of a tell for example)}

  if Command='' then exit;

  if Command[length(Command)]=#$A then
    //if pos(#32,Command)=0 then
    SetLength(Command,length(Command)-1);
  Str2StringList(Command,FCMD,#32);
  {if length(FCMD[FCMD.Count-1])=1 then
    FCMD.Delete(FCMD.Count-1);}
  if not FCommands.Find(FCMD[0],Cmd) then Cmd:=CMD_UNKNOWN
  else Cmd := Integer(FCommands.Objects[Cmd]);

  n:=HaveRight(Connection.Handle,lowercase(FCMD[0]));
  if n<>0 then
    begin
      case n of
        -1: msg:='Illegal command';
        -2: msg:='Illegal login';
        -3: msg:='Access denied';
      end;
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, msg]);
      exit;
    end;

  fDB.SaveCommandsUsage(Connection.Handle, Command);

  if FCMD.Count=1 then ParCount:=1
  else begin
    case Cmd of
      CMD_UNKNOWN: ParCount:=1;
      CMD_SHOUT: ParCount:=2;
      CMD_KIBITZ, CMD_SAY, CMD_WHISPER, CMD_CREATE_ROOM, CMD_FEN,CMD_TELL,CMD_EVENT_TELL:
         begin
           if (FCMD[1]<>'') and (FCMD[1][1]='~') then begin
             FCMD[1]:=copy(FCMD[1],2,length(FCMD[1]));
             ParCount:=4;
           end else begin
             if Cmd=CMD_TELL then ParCount:=3
             else begin
               Val(FCMD[1], Value, Code);
               if Code<>0 then ParCount:=2
               else ParCount:=3;
             end;
           end;
         end;
      CMD_NUKE, CMD_DISABLE, CMD_SET, CMD_MESSAGE:
        ParCount:=3;
    else
      ParCount:=FCMD.Count;
    end;
  end;
  PressStringList(FCMD,ParCount);

  { Command has been parsed. Now distribute it (if paramaters exist) }
  if FCMD.Count = 0 then Exit;

  { If it's an unknown command attempt to utilize the last command issued. }
  if (Cmd = CMD_UNKNOWN) and (FCMD[0]<>'') and (FCMD[0][1] <> '/')
  and (Connection.LastCmd <> '') then
    begin
      FCMD.Insert(0, Connection.LastCmd);
      if Connection.CmdParam <> '' then
        FCMD.Insert(1, Connection.CmdParam);
      if FCommands.Find(FCMD[0], Cmd) then
        Cmd := Integer(FCommands.Objects[Cmd]);
    end;

  case Cmd of
    { These commands may be issued anytime }
    CMD_BYE: fConnections.CMD_Bye(Connection, FCMD);
    CMD_LOGIN: fConnections.CMD_Login(Connection, FCMD);
    CMD_REGISTER: fConnections.CMD_Register(Connection, FCMD);
    CMD_AUTH_KEY: fConnections.CMD_AuthKey(Connection,FCMD);
    CMD_EMAIL_CHANGE: ;
    CMD_AUTH_KEY_REQ: fDB.SendAuthKey(Connection,FCMD,true,'key');
    CMD_PASS_FORGOT: fDB.UserSendPassword(Connection,FCMD);    
  else
      if Connection.LoginID < 0 then
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_LOGIN_REQUIRED])
      else
        { These commands may only be issused after a successful login }
        case CMD of
          CMD_UNKNOWN: fConnections.CMD_Unknown(Connection, FCMD);
          CMD_ME_SUPER: fConnections.CMD_MeSuper(Connection, FCMD);
          CMD_CLOSE_SOCKET: fSocket.CMD_CloseSocket(Connection, FCMD);
          CMD_ACK_PING: fConnections.CMD_AckPing(Connection);
          CMD_NUKE: fConnections.CMD_Nuke(Connection, FCMD);
          CMD_DISABLE: fConnections.CMD_Disable(Connection, FCMD);
          CMD_CHANGE_TITLE: fConnections.CMD_ChangeTitle(Connection, FCMD);
          CMD_ENABLE: fConnections.CMD_Enable(Connection, FCMD);
          CMD_ADDRESS: fConnections.CMD_Address(Connection, FCMD);
          //CMD_LOG: fSocket.CMD_Log(Connection);
          CMD_SET: fConnections.CMD_Set(Connection, FCMD);
          CMD_SET_ALL: fConnections.CMD_SetAll(Connection, FCMD);
          CMD_NOTIFY_ADD: fConnections.CMD_NotifyAdd(Connection, FCMD);
          CMD_NOTIFY_REMOVE: fConnections.CMD_NotifyRemove(Connection, FCMD);
          CMD_CENSOR_ADD: fConnections.CMD_CensorAdd(Connection, FCMD);
          CMD_CENSOR_REMOVE: fConnections.CMD_CensorRemove(Connection, FCMD);
          CMD_DELETE_MESSAGE: fMessages.CMD_DeleteMessage(Connection, FCMD);
          CMD_KIBITZ: fGames.CMD_Kibitz(Connection, FCMD);
          CMD_MESSAGE: fMessages.CMD_Message(Connection, FCMD);
          CMD_SAY: fGames.CMD_Say(Connection, FCMD);
          CMD_SHOUT: fConnections.CMD_Shout(Connection, FCMD);
          CMD_TELL: ParseTell(Connection);
          CMD_WHISPER: fGames.CMD_Whisper(Connection, FCMD);
          CMD_MUTE: fConnections.CMD_Mute(Connection, FCMD);
          CMD_UNMUTE: fConnections.CMD_UnMute(Connection, FCMD);
          CMD_CREATE_ROOM: fRooms.CMD_CreateRoom(Connection, FCMD);
          CMD_ENTER: fRooms.CMD_Enter(Connection, FCMD);
          CMD_EXIT: fRooms.CMD_Exit(Connection, FCMD);
          CMD_INVITE: fRooms.CMD_Invite(Connection, FCMD);
          CMD_ACCEPT: fOffers.CMD_Accept(Connection, FCMD);
          CMD_DECLINE: fOffers.CMD_Decline(Connection, FCMD);
          CMD_MATCH: fOffers.CMD_Match(Connection, FCMD);
          CMD_SEEK: fOffers.CMD_Seek(Connection, FCMD);
          CMD_PROFILE: fProfiles.CMD_Profile(Connection, FCMD);
          CMD_ABORT: fGames.CMD_Abort(Connection, FCMD);
          CMD_ACK_FLAG: fGames.CMD_AckFlag(Connection, FCMD);
          CMD_ADJOURN: fGames.CMD_Adjourn(Connection, FCMD);
          CMD_ARROW: fGames.CMD_Markers(Connection, FCMD, CMD);
          CMD_CIRCLE: fGames.CMD_Markers(Connection, FCMD, CMD);
          CMD_CLEAR_MARKERS: fGames.CMD_Markers(Connection, FCMD, CMD);
          CMD_DRAW: fGames.CMD_Draw(Connection, FCMD);
          CMD_FEN: fGames.CMD_FEN(Connection, FCMD);
          CMD_FORWARD: fGames.CMD_Forward(Connection, FCMD);
          CMD_FLAG: fGames.CMD_Flag(Connection, FCMD);
          CMD_INCLUDE: fGames.CMD_Include(Connection, FCMD);
          CMD_LIBRARY_ADD: fLibrary.CMD_LibraryAdd(Connection, FCMD);
          CMD_LIBRARY_REMOVE: fLibrary.CMD_LibraryRemove(Connection, FCMD);
          CMD_LOAD: fOffers.CMD_Load(Connection, FCMD);
          CMD_LOCK: fGames.CMD_Lock(Connection, FCMD);
          CMD_MORETIME: fGames.CMD_Moretime(Connection, FCMD);
          CMD_MOVE: fGames.CMD_Move(Connection, FCMD);
          CMD_OBSERVE: fGames.CMD_Observe(Connection, FCMD);
          CMD_PRIMARY: fGames.CMD_Primary(Connection, FCMD);
          CMD_QUIT: fGames.CMD_Quit(Connection, FCMD);
          CMD_RESIGN: fGames.CMD_Resign(Connection, FCMD);
          CMD_RESUME: fOffers.CMD_Resume(Connection, FCMD);
          CMD_REVERT: fGames.CMD_Revert(Connection, FCMD);
          CMD_TAKEBACK: fGames.CMD_Takeback(Connection, FCMD);
          CMD_TWINS: fDB.Twins(Connection, FCMD);
          CMD_UNARROW: fGames.CMD_Markers(Connection, FCMD, CMD);
          CMD_UNCIRCLE: fGames.CMD_Markers(Connection, FCMD, CMD);
          CMD_UNLOCK: fGames.CMD_UnLock(Connection, FCMD);
          CMD_UNOFFER: fOffers.CMD_UnOffer(Connection, FCMD);
          CMD_ZERO_TIME: fGames.CMD_ZeroTime(Connection, FCMD);
          CMD_FOLLOW: fConnections.CMD_Follow(Connection, FCMD);
          CMD_UNFOLLOW: fConnections.CMD_Unfollow(Connection, FCMD);
          CMD_BAN: fDB.Ban(Connection, FCMD);
          CMD_UNBAN: fDB.Unban(Connection, FCMD);
          CMD_SETRATING: fDB.SetRating(Connection, FCMD);
          CMD_BANHISTORY: fDB.CMD_ShowBanHistory(Connection, FCMD);
          CMD_LOGINHISTORY: fDB.LoginHistory(Connection, FCMD);
          CMD_LOGINERRORS: fDB.LoginErrors(Connection, FCMD);
          CMD_DEMOBOARD: fGames.CMD_DemoBoard(Connection, FCMD);
          CMD_TIME: SendTime(Connection, FCMD);
          CMD_COMMANDS: fDB.ShowCommands(Connection, FCMD);
          CMD_COMMAND_ADD: fDB.CommandAdd(Connection, FCMD);
          CMD_ROLES: fDB.ShowRoles(Connection, FCMD);
          CMD_ROLE_ADD: fDB.RoleAdd(Connection, FCMD);
          CMD_ROLE_REMOVE: fDB.DeleteRole(Connection, FCMD);
          CMD_ROLE_RELEASE: fDB.RoleRelease(Connection, FCMD);
          CMD_ALLOW: fDB.CMD_Allow(Connection, FCMD);
          CMD_REJECT: fDB.CMD_Reject(Connection, FCMD);
          CMD_EMPLOY: fDB.CMD_Employ(Connection, FCMD);
          CMD_DISMISS: fDB.CMD_Dismiss(Connection, FCMD);
          CMD_MEMBERS: fDB.CMD_Members(Connection, FCMD);
          CMD_VARS: fDB.CMD_ShowVars(Connection, FCMD);
          CMD_SETVAR: fDB.CMD_SetVar(Connection, FCMD);
          CMD_READVARS: fDB.ReadVars;
          CMD_CHEATS: fDB.CMD_ShowCheats(Connection, FCMD);
          CMD_FOLLOWS: fConnections.CMD_ShowFollows(Connection, FCMD);
          CMD_ADDCOMMANDTITLE: fDB.AddTitleCommand(Connection, FCMD);
          CMD_REMOVECOMMANDTITLE: fDB.RemoveTitleCommand(Connection, FCMD);
          CMD_TITLECOMMANDS: fDB.TitleCmmands(Connection, FCMD);
          CMD_FLUSHLOG: fSocket.FlushLog;
          // commands creating and setting events
          CMD_EVENT_CREATE: fEvents.CMD_EventCreate(Connection, FCMD);
          CMD_EVENT_CREATE_END: fEvents.CMD_EventCreateEnd(Connection,FCMD);
          CMD_EVENT_PARAMS: fEvents.CMD_EventParams(Connection, FCMD);
          CMD_ODDS_ADD: fEvents.CMD_OddsAdd(Connection, FCMD);
          CMD_EVENT_SHOUT: fEvents.CMD_EventShout(Connection, FCMD);
          // deleting events
          CMD_EVENT_DELETE: fEvents.CMD_EventDelete(Connection, FCMD);
          // managing events
          CMD_EVENT_START: fEvents.CMD_EventStart(Connection, FCMD);
          CMD_EVENT_PAUSE: fEvents.CMD_EventPause(Connection, FCMD);
          CMD_EVENT_RESUME: fEvents.CMD_EventResume(Connection, FCMD);
          // join/observe/leave events
          CMD_EVENT_JOIN: fEvents.CMD_EventJoin(Connection, FCMD);
          CMD_EVENT_OBSERVE: fEvents.CMD_EventObserve(Connection, FCMD);
          CMD_EVENT_LEAVE: fEvents.CMD_EventLeave(Connection, FCMD);
          CMD_EVENT_MEMBER: fEvents.CMD_EventMember(Connection, FCMD);
          CMD_EVENT_ABANDON: fEvents.CMD_EventAbandon(Connection, FCMD);
          CMD_EVENT_FORFEIT: fEvents.CMD_EventForfeit(Connection, FCMD);

          CMD_EVENT_GAME_ACCEPT: fEvents.CMD_EventGameAccept(Connection, FCMD);
          CMD_EVENT_GAME_ABORT: fEvents.CMD_EventGameAbort(Connection, FCMD);
          CMD_EVENT_CONG: fEvents.CMD_EventCong(Connection, FCMD);
          CMD_EVENT_TELL: fEvents.CMD_EventTell(Connection, FCMD);

          CMD_EMAIL_RECONNECT: UserReconnectMail(Connection);
          CMD_EMAIL_SEND: UserSendMail(Connection,FCMD);

          CMD_KEY_CONFIRM: fDB.KeyConfirm(Connection,FCMD);
          CMD_EVENT_BAN: fConnections.CMD_EventBan(Connection,FCMD);
          CMD_EVENT_UNBAN: fConnections.CMD_EventUnBan(Connection,FCMD);
          CMD_EVENT_KICKOUT: fConnections.CMD_EventKickOut(Connection,FCMD);
          CMD_PHOTO_SEND: fConnections.CMD_PhotoSend(Connection, FCMD);
          CMD_TIMESTAT: fTimeStat.CMD_TimeStat(Connection, FCMD);
          CMD_CLEARTIMESTAT: fTimeStat.CMD_ClearTimeStat(Connection);
          CMD_ADJOURN_ALL: fGames.CMD_AdjournAll(Connection,FCMD);
          CMD_MM: fSocket2.CMD_MM(Connection, FCMD);
          CMD_CHANGE_PASSWORD: fDB.ChangePassword(Connection, FCMD);
          CMD_ADULT: fDB.SetAdult(Connection, FCMD);
          CMD_STAT: fDB.CMD_Stat(Connection, FCMD);
          CMD_READ_STAT_TYPES: fDB.ReadStatTypes;
          CMD_WIN: fGames.CMD_Win(Connection, FCMD);
          CMD_SHOWGREETINGS: fDB.CMD_ShowGreetings(Connection, FCMD);
          CMD_SETGREETINGS: fDB.CMD_SetGreetings(Connection, FCMD);
          CMD_CLUBS: fDB.CMD_Clubs(Connection, FCMD);
          CMD_CLUB: fDB.CMD_Club(Connection, FCMD);
          CMD_CLUB_REMOVE: fDB.CMD_ClubRemove(Connection, FCMD);
          CMD_SETUSERCLUB: fDB.CMD_SetUserClub(Connection, FCMD);
          CMD_EVENT_CLUB: fEvents.CMD_EventClub(Connection, FCMD);
          CMD_CLUB_MEMBERS: fDB.CMD_ClubMembers(Connection, FCMD);
          CMD_USER_CLUB: fDB.CMD_UserClub(Connection, FCMD);
          CMD_GOTOCLUB: fConnections.CMD_ChangeClub(Connection, FCMD);
          CMD_CLUBSTATUS: fDB.CMD_ClubStatus(Connection, FCMD);
          CMD_GETCLUBMEMBERS: fDB.CMD_GetClubMembers(Connection, FCMD);
          CMD_CLUBOPTIONS: fDB.CMD_ClubOptions(Connection, FCMD);
          CMD_CLUBINFO: fDB.CMD_ClubInfo(Connection, FCMD);
          CMD_GAMESEARCH: fDB.CMD_GameSearch(Connection, FCMD);
          CMD_EVENT_TICKETS_BEGIN: fEvents.CMD_EventTicketsBegin(Connection, FCMD);
          CMD_EVENT_TICKET: fEvents.CMD_EventTicket(Connection, FCMD);
          CMD_EVENT_TICKETS_END: fEvents.CMD_EventTicketsEnd(Connection, FCMD);
          CMD_EVENT_GAME_OBSERVE: fEvents.CMD_EventGameObserve(Connection, FCMD);
          CMD_SETADMINLEVEL: fDB.CMD_SetAdminLevel(Connection, FCMD);
          CMD_ADMINLEVEL: fDB.CMD_AdminLevel(Connection, FCMD);
          CMD_ADMINS: fDB.CMD_Admins(Connection, FCMD);
          CMD_SCORE: fDB.CMD_Score(Connection, FCMD);
          CMD_NAMES: fDB.CMD_ShowNames(Connection, FCMD);
          CMD_ADDRESSHISTORY: fDB.CMD_ShowAddressHistory(Connection, FCMD);
          CMD_MODE: CMD_SetMode(Connection, FCMD);
          CMD_STARTMESSAGE: CMD_SetStartMessage(Connection, FCMD);
          CMD_DELETEROOM: fRooms.CMD_DeleteRoom(Connection, FCMD);
          CMD_SETPROFILENOTES: fConnections.CMD_SetProfileNotes(Connection, FCMD);
          CMD_DELETEPROFILEPHOTO: fConnections.CMD_DeleteProfilePhoto(Connection, FCMD);
          CMD_NOTES: fConnections.CMD_SetNotes(Connection, FCMD);
          CMD_BANPROFILE: fDB.CMD_BanProfile(Connection, FCMD, true);
          CMD_UNBANPROFILE: fDB.CMD_BanProfile(Connection, FCMD, false);
          CMD_MESSAGESEARCH: fDB.CMD_MessageSearch(Connection, FCMD);
          CMD_MESSAGESTATE: fDB.CMD_MessageState(Connection, FCMD);
          CMD_MESSAGERETRIEVE: fDB.CMD_MessageRetrieve(Connection, FCMD);
          CMD_SETIMAGE: fDB.CMD_SetImage(Connection, FCMD);
          CMD_CLIENTERROR: fDB.CMD_ClientError(Connection, FCMD);
          CMD_ADMINGREETINGS: fDB.CMD_AdminGreetings(Connection, FCMD);
          CMD_FULLRECORD: fDB.CMD_FullRecord(Connection, FCMD);
          CMD_MESSAGEGROUP: fMessages.CMD_MessageGroup(Connection, FCMD);
          CMD_READTIMEODDSLIMITS: fDB.ReadTimeOddsLimits(Connection);
          CMD_HELP: fDB.CMD_Help(Connection, FCMD);
          CMD_EVENT_FINISH: fEvents.CMD_EventFinish(Connection, FCMD);
          CMD_PROFILE_ACH: fAchUserLibrary.CMD_ProfileAch(Connection, FCMD);
          CMD_TRANSACTION_STATE: fDB.CMD_TransactionState(Connection, FCMD);
          CMD_TRANSACTION: fDB.CMD_Transaction(Connection, FCMD);
          CMD_READACHIEVEMENTS: fAchievements.CMD_ReadAchievements(Connection, FCMD);
          CMD_PLAYENGINEGAME: fOffers.CMD_PlayEngineGame(Connection, FCMD);
          CMD_SUMMON: fConnections.CMD_Summon(Connection, FCMD);
          CMD_ORDER: fConnections.CMD_Order(Connection, FCMD);
          CMD_TEST: Test(Connection, FCMD);
          CMD_PM_EXIT: CMD_PmExit(Connection, FCMD);
          CMD_REQUEST_USER_INFO: fConnections.CMD_RequestUserInfo(Connection, FCMD);
          CMD_SKIP_UPDATE: CMD_SkipUpdate(Connection, FCMD);
          //CMD_DISCONNECT: fGames.CMD_Disconnect(Connection, FCMD);
        end;
  end;

  if Assigned(Connection) and (CMD <> CMD_ACK_PING) and (CMD <> CMD_ACK_FLAG) then begin
    Connection.LastCmdTS := Now;
    Connection.SetOnlineStatus(onlActive);
  end;
end;
//==============================================================================
procedure TCommand.ParseTell(var Connection: TConnection);
var
  Value, Error: Integer;
  n: integer;
begin
  { Depending on the 1st parameter the tell could either be a 'room tell' or
    a 'personal tell' each handled in seperate objects. }
  if Connection.Invisible then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVISIBLE_CHAT]);
    exit;
  end;

  if Connection.MembershipType = mmbNone then
    Connection.WarnAboutNoMembershipChat;

  Error := 0;
  if FCMD.Count > 1 then  Val(FCMD[FCMD.Count-2], Value, Error);
  if Error = 0 then
    fRooms.CMD_Tell(Connection, FCMD)
  else
    fConnections.CMD_Tell(Connection, FCMD);
end;
//==============================================================================
constructor TCommand.Create;
begin
  FCommands := TStringList.Create;
  FDeferredCommands := TDeferredCommands.Create;
  { Add all the commands and a value used to map the command to a function }
  with FCommands do
    begin
      Sorted := True; { For faster searching }
      AddObject(CMD_STR_ACK_PING, TObject(CMD_ACK_PING));
      AddObject(CMD_STR_ZERO_TIME, TObject(CMD_ZERO_TIME));
      AddObject(CMD_STR_ACK_FLAG, TObject(CMD_ACK_FLAG));
      AddObject(CMD_STR_ABORT, TObject(CMD_ABORT));
      AddObject(CMD_STR_ACCEPT, TObject(CMD_ACCEPT));
      AddObject(CMD_STR_ADDRESS, TObject(CMD_ADDRESS));
      AddObject(CMD_STR_BANHISTORY, TObject(CMD_BANHISTORY));
      //AddObject(CMD_STR_LOG, TObject(CMD_LOG));
      AddObject(CMD_STR_ADJOURN, TObject(CMD_ADJOURN));
      AddObject(CMD_STR_ARROW, TObject(CMD_ARROW));
      AddObject(CMD_STR_BACK, TObject(CMD_TAKEBACK));
      AddObject(CMD_STR_BAN, TObject(CMD_BAN));
      AddObject(CMD_STR_BYE, TObject(CMD_BYE));
      AddObject(CMD_STR_CENSOR_ADD, TObject(CMD_CENSOR_ADD));
      AddObject(CMD_STR_CENSOR_REMOVE, TObject(CMD_CENSOR_REMOVE));
      AddObject(CMD_STR_CHANGE_TITLE, TObject(CMD_CHANGE_TITLE));
      AddObject(CMD_STR_CIRCLE, TObject(CMD_CIRCLE));
      AddObject(CMD_STR_CLEAR_MARKERS, TObject(CMD_CLEAR_MARKERS));
      AddObject(CMD_STR_CLOSE_SOCKET, TObject(CMD_CLOSE_SOCKET));
      AddObject(CMD_STR_CREATE_ROOM, TObject(CMD_CREATE_ROOM));
      AddObject(CMD_STR_DECLINE, TObject(CMD_DECLINE));
      AddObject(CMD_STR_DELETE_MESSAGE, TObject(CMD_DELETE_MESSAGE));
      AddObject(CMD_STR_DISABLE, TObject(CMD_DISABLE));
      AddObject(CMD_STR_DRAW, TObject(CMD_DRAW));
      AddObject(CMD_STR_ENABLE, TObject(CMD_ENABLE));
      AddObject(CMD_STR_ENTER, TObject(CMD_ENTER));
      AddObject(CMD_STR_EXIT, TObject(CMD_EXIT));
      AddObject(CMD_STR_FEN, TObject(CMD_FEN));
      AddObject(CMD_STR_FLAG, TObject(CMD_FLAG));
      AddObject(CMD_STR_FORWARD, TObject(CMD_FORWARD));
      AddObject(CMD_STR_INCLUDE, TObject(CMD_INCLUDE));
      AddObject(CMD_STR_INVITE, TObject(CMD_INVITE));
      AddObject(CMD_STR_KIBITZ, TObject(CMD_KIBITZ));
      AddObject(CMD_STR_LIBRARY_ADD, TObject(CMD_LIBRARY_ADD));
      AddObject(CMD_STR_LIBRARY_REMOVE, TObject(CMD_LIBRARY_REMOVE));
      AddObject(CMD_STR_LOAD, TObject(CMD_LOAD));
      AddObject(CMD_STR_LOCK, TObject(CMD_LOCK));
      AddObject(CMD_STR_LOGIN, TObject(CMD_LOGIN));
      AddObject(CMD_STR_LOGINHISTORY, TObject(CMD_LOGINHISTORY));
      AddObject(CMD_STR_LOGINERRORS, TObject(CMD_LOGINERRORS));
      AddObject(CMD_STR_MATCH, TObject(CMD_MATCH));
      AddObject(CMD_STR_MESSAGE, TObject(CMD_MESSAGE));
      AddObject(CMD_STR_MESUPER, TObject(CMD_ME_SUPER));
      AddObject(CMD_STR_MORETIME, TObject(CMD_MORETIME));
      AddObject(CMD_STR_MOVE, TObject(CMD_MOVE));
      AddObject(CMD_STR_MUTE, TObject(CMD_MUTE));
      AddObject(CMD_STR_NOTIFY_ADD, TObject(CMD_NOTIFY_ADD));
      AddObject(CMD_STR_NOTIFY_REMOVE, TObject(CMD_NOTIFY_REMOVE));
      AddObject(CMD_STR_NUKE, TObject(CMD_NUKE));
      AddObject(CMD_STR_OBSERVE, TObject(CMD_OBSERVE));
      AddObject(CMD_STR_PRIMARY, TObject(CMD_PRIMARY));
      AddObject(CMD_STR_PROFILE, TObject(CMD_PROFILE));
      AddObject(CMD_STR_QUIT, TObject(CMD_QUIT));
      AddObject(CMD_STR_REGISTER, TObject(CMD_REGISTER));
      AddObject(CMD_STR_RESIGN, TObject(CMD_RESIGN));
      AddObject(CMD_STR_RESUME, TObject(CMD_RESUME));
      AddObject(CMD_STR_REVERT, TObject(CMD_REVERT));
      AddObject(CMD_STR_SAY, TObject(CMD_SAY));
      AddObject(CMD_STR_SEEK, TObject(CMD_SEEK));
      AddObject(CMD_STR_SET, TObject(CMD_SET));
      AddObject(CMD_STR_SET_ALL, TObject(CMD_SET_ALL));
      AddObject(CMD_STR_SETRATING, TObject(CMD_SETRATING));
      AddObject(CMD_STR_SHOUT, TObject(CMD_SHOUT));
      AddObject(CMD_STR_TAKEBACK, TObject(CMD_TAKEBACK));
      AddObject(CMD_STR_TELL, TObject(CMD_TELL));
      AddObject(CMD_STR_TWINS, TObject(CMD_TWINS));
      AddObject(CMD_STR_UNARROW, TObject(CMD_UNARROW));
      AddObject(CMD_STR_UNCIRCLE, TObject(CMD_UNCIRCLE));
      AddObject(CMD_STR_UNBAN, TObject(CMD_UNBAN));
      AddObject(CMD_STR_UNLOCK, TObject(CMD_UNLOCK));
      AddObject(CMD_STR_UNMUTE, TObject(CMD_UNMUTE));
      AddObject(CMD_STR_UNOFFER, TObject(CMD_UNOFFER));
      AddObject(CMD_STR_WHISPER, TObject(CMD_WHISPER));
      AddObject(CMD_STR_FOLLOW, TObject(CMD_FOLLOW));
      AddObject(CMD_STR_UNFOLLOW, TObject(CMD_UNFOLLOW));
      AddObject(CMD_STR_DEMOBOARD, TObject(CMD_DEMOBOARD));
      AddObject(CMD_STR_TIME, TObject(CMD_TIME));
      AddObject(CMD_STR_COMMANDS, TObject(CMD_COMMANDS));
      AddObject(CMD_STR_COMMAND_ADD, TObject(CMD_COMMAND_ADD));
      AddObject(CMD_STR_COMMAND_CHANGE, TObject(CMD_COMMAND_ADD));
      AddObject(CMD_STR_ROLES, TObject(CMD_ROLES));
      AddObject(CMD_STR_ROLE_ADD, TObject(CMD_ROLE_ADD));
      AddObject(CMD_STR_ROLE_REMOVE, TObject(CMD_ROLE_REMOVE));
      AddObject(CMD_STR_ROLE_RELEASE, TObject(CMD_ROLE_RELEASE));
      AddObject(CMD_STR_ALLOW,TObject(CMD_ALLOW));
      AddObject(CMD_STR_REJECT,TObject(CMD_REJECT));
      AddObject(CMD_STR_EMPLOY,TObject(CMD_EMPLOY));
      AddObject(CMD_STR_DISMISS,TObject(CMD_DISMISS));
      AddObject(CMD_STR_MEMBERS,TObject(CMD_MEMBERS));
      AddObject(CMD_STR_VARS,TObject(CMD_VARS));
      AddObject(CMD_STR_SETVAR,TObject(CMD_SETVAR));
      AddObject(CMD_STR_READVARS,TObject(CMD_READVARS));
      AddObject(CMD_STR_CHEATS,TObject(CMD_CHEATS));
      AddObject(CMD_STR_FOLLOWS,TObject(CMD_FOLLOWS));
      AddObject(CMD_STR_ADDCOMMANDTITLE,TObject(CMD_ADDCOMMANDTITLE));
      AddObject(CMD_STR_REMOVECOMMANDTITLE,TObject(CMD_REMOVECOMMANDTITLE));
      AddObject(CMD_STR_TITLECOMMANDS,TObject(CMD_TITLECOMMANDS));
      AddObject(CMD_STR_EVENT_CREATE,TObject(CMD_EVENT_CREATE));
      AddObject(CMD_STR_EVENT_JOIN,TObject(CMD_EVENT_JOIN));
      AddObject(CMD_STR_EVENT_START,TObject(CMD_EVENT_START));
      AddObject(CMD_STR_EVENT_TELL,TObject(CMD_EVENT_TELL));
      AddObject(CMD_STR_EVENT_LEAVE,TObject(CMD_EVENT_LEAVE));
      AddObject(CMD_STR_EVENT_OBSERVE,TObject(CMD_EVENT_OBSERVE));
      AddObject(CMD_STR_EVENT_DELETE,TObject(CMD_EVENT_DELETE));
      AddObject(CMD_STR_ODDS_ADD,TObject(CMD_ODDS_ADD));
      AddObject(CMD_STR_FLUSHLOG,TObject(CMD_FLUSHLOG));
      AddObject(CMD_STR_EVENT_PARAMS,TObject(CMD_EVENT_PARAMS));
      AddObject(CMD_STR_EVENT_PAUSE,TObject(CMD_EVENT_PAUSE));
      AddObject(CMD_STR_EVENT_RESUME,TObject(CMD_EVENT_RESUME));
      AddObject(CMD_STR_EVENT_SHOUT,TObject(CMD_EVENT_SHOUT));
      AddObject(CMD_STR_EVENT_MEMBER,TObject(CMD_EVENT_MEMBER));
      AddObject(CMD_STR_EVENT_ABANDON,TObject(CMD_EVENT_ABANDON));
      AddObject(CMD_STR_EVENT_FORFEIT,TObject(CMD_EVENT_FORFEIT));
      AddObject(CMD_STR_EVENT_GAME_ACCEPT,TObject(CMD_EVENT_GAME_ACCEPT));
      AddObject(CMD_STR_EVENT_GAME_ABORT,TObject(CMD_EVENT_GAME_ABORT));
      AddObject(CMD_STR_EVENT_CREATE_END,TObject(CMD_EVENT_CREATE_END));
      AddObject(CMD_STR_EVENT_CONG,TObject(CMD_EVENT_CONG));
      AddObject(CMD_STR_AUTH_KEY,TObject(CMD_AUTH_KEY));
      AddObject(CMD_STR_EMAIL_CHANGE,TObject(CMD_EMAIL_CHANGE));
      AddObject(CMD_STR_EMAIL_RECONNECT,TObject(CMD_EMAIL_RECONNECT));
      AddObject(CMD_STR_EMAIL_SEND,TObject(CMD_EMAIL_SEND));
      AddObject(CMD_STR_AUTH_KEY_REQ,TObject(CMD_AUTH_KEY_REQ));
      AddObject(CMD_STR_KEY_CONFIRM,TObject(CMD_KEY_CONFIRM));
      AddObject(CMD_STR_PASS_FORGOT,TObject(CMD_PASS_FORGOT));
      AddObject(CMD_STR_EVENT_BAN,TObject(CMD_EVENT_BAN));
      AddObject(CMD_STR_EVENT_UNBAN,TObject(CMD_EVENT_UNBAN));
      AddObject(CMD_STR_EVENT_KICKOUT,TObject(CMD_EVENT_KICKOUT));
      AddObject(CMD_STR_PHOTO_SEND,TObject(CMD_PHOTO_SEND));
      AddObject(CMD_STR_TIMESTAT,TObject(CMD_TIMESTAT));
      AddObject(CMD_STR_CLEARTIMESTAT,TObject(CMD_CLEARTIMESTAT));
      AddObject(CMD_STR_CHATLOG,TObject(CMD_CHATLOG));
      AddObject(CMD_STR_ADJOURN_ALL,TObject(CMD_ADJOURN_ALL));
      AddObject(CMD_STR_MM,TObject(CMD_MM));
      AddObject(CMD_STR_CHANGE_PASSWORD,TObject(CMD_CHANGE_PASSWORD));
      AddObject(CMD_STR_ADULT,TObject(CMD_ADULT));
      AddObject(CMD_STR_STAT,TObject(CMD_STAT));
      AddObject(CMD_STR_READ_STAT_TYPES,TObject(CMD_READ_STAT_TYPES));
      AddObject(CMD_STR_WIN,TObject(CMD_WIN));
      AddObject(CMD_STR_DISCONNECT,TObject(CMD_DISCONNECT));
      AddObject(CMD_STR_SHOWGREETINGS,TObject(CMD_SHOWGREETINGS));
      AddObject(CMD_STR_SETGREETINGS,TObject(CMD_SETGREETINGS));
      AddObject(CMD_STR_CLUBS,TObject(CMD_CLUBS));
      AddObject(CMD_STR_CLUB,TObject(CMD_CLUB));
      AddObject(CMD_STR_CLUB_REMOVE,TObject(CMD_CLUB_REMOVE));
      AddObject(CMD_STR_SETUSERCLUB,TObject(CMD_SETUSERCLUB));
      AddObject(CMD_STR_EVENT_CLUB,TObject(CMD_EVENT_CLUB));
      AddObject(CMD_STR_CLUB_MEMBERS,TObject(CMD_CLUB_MEMBERS));
      AddObject(CMD_STR_USER_CLUB,TObject(CMD_USER_CLUB));
      AddObject(CMD_STR_GOTOCLUB,TObject(CMD_GOTOCLUB));
      AddObject(CMD_STR_CLUBSTATUS,TObject(CMD_CLUBSTATUS));
      AddObject(CMD_STR_GETCLUBMEMBERS,TObject(CMD_GETCLUBMEMBERS));
      AddObject(CMD_STR_CLUBOPTIONS,TObject(CMD_CLUBOPTIONS));
      AddObject(CMD_STR_CLUBINFO,TObject(CMD_CLUBINFO));
      AddObject(CMD_STR_CLUBPHOTO,TObject(CMD_CLUBPHOTO));
      AddObject(CMD_STR_GAMESEARCH,TObject(CMD_GAMESEARCH));
      AddObject(CMD_STR_EVENT_TICKETS_BEGIN,TObject(CMD_EVENT_TICKETS_BEGIN));
      AddObject(CMD_STR_EVENT_TICKET,TObject(CMD_EVENT_TICKET));
      AddObject(CMD_STR_EVENT_TICKETS_END,TObject(CMD_EVENT_TICKETS_END));
      AddObject(CMD_STR_EVENT_GAME_OBSERVE,TObject(CMD_EVENT_GAME_OBSERVE));
      AddObject(CMD_STR_SETADMINLEVEL,TObject(CMD_SETADMINLEVEL));
      AddObject(CMD_STR_ADMINLEVEL,TObject(CMD_ADMINLEVEL));
      AddObject(CMD_STR_ADMINS,TObject(CMD_ADMINS));
      AddObject(CMD_STR_SCORE,TObject(CMD_SCORE));
      AddObject(CMD_STR_NAMES,TObject(CMD_NAMES));
      AddObject(CMD_STR_ADDRESSHISTORY,TObject(CMD_ADDRESSHISTORY));
      AddObject(CMD_STR_MODE,TObject(CMD_MODE));
      AddObject(CMD_STR_STARTMESSAGE,TObject(CMD_STARTMESSAGE));
      AddObject(CMD_STR_DELETEROOM,TObject(CMD_DELETEROOM));
      AddObject(CMD_STR_DELETEPROFILEPHOTO,TObject(CMD_DELETEPROFILEPHOTO));
      AddObject(CMD_STR_SETPROFILENOTES,TObject(CMD_SETPROFILENOTES));
      AddObject(CMD_STR_NOTES,TObject(CMD_NOTES));
      AddObject(CMD_STR_BANPROFILE,TObject(CMD_BANPROFILE));
      AddObject(CMD_STR_UNBANPROFILE,TObject(CMD_UNBANPROFILE));
      AddObject(CMD_STR_MESSAGESEARCH,TObject(CMD_MESSAGESEARCH));
      AddObject(CMD_STR_MESSAGESTATE,TObject(CMD_MESSAGESTATE));
      AddObject(CMD_STR_MESSAGERETRIEVE,TObject(CMD_MESSAGERETRIEVE));
      AddObject(CMD_STR_SETIMAGE,TObject(CMD_SETIMAGE));
      AddObject(CMD_STR_CLIENTERROR,TObject(CMD_CLIENTERROR));
      AddObject(CMD_STR_ADMINGREETINGS,TObject(CMD_ADMINGREETINGS));
      AddObject(CMD_STR_FULLRECORD,TObject(CMD_FULLRECORD));
      AddObject(CMD_STR_MESSAGEGROUP,TObject(CMD_MESSAGEGROUP));
      AddObject(CMD_STR_READTIMEODDSLIMITS,TObject(CMD_READTIMEODDSLIMITS));
      AddObject(CMD_STR_HELP,TObject(CMD_HELP));
      AddObject(CMD_STR_EVENT_FINISH,TObject(CMD_EVENT_FINISH));
      AddObject(CMD_STR_PROFILE_ACH,TObject(CMD_PROFILE_ACH));
      AddObject(CMD_STR_TRANSACTION_STATE, TObject(CMD_TRANSACTION_STATE));
      AddObject(CMD_STR_TRANSACTION, TObject(CMD_TRANSACTION));
      AddObject(CMD_STR_READACHIEVEMENTS, TObject(CMD_READACHIEVEMENTS));
      AddObject(CMD_STR_PLAYENGINEGAME, TObject(CMD_PLAYENGINEGAME));
      AddObject(CMD_STR_SUMMON, TObject(CMD_SUMMON));
      AddObject(CMD_STR_ORDER, TObject(CMD_ORDER));
      AddObject(CMD_STR_TEST, TObject(CMD_TEST));
      AddObject(CMD_STR_PM_EXIT, TObject(CMD_PM_EXIT));
      AddObject(CMD_STR_REQUEST_USER_INFO, TObject(CMD_REQUEST_USER_INFO));
      AddObject(CMD_STR_SKIP_UPDATE, TObject(CMD_SKIP_UPDATE));
    end;
  FCMD := TStringList.Create;
  {try
    AssignFile(F, GetCurrentDir+'\Log.txt');
    Rewrite(F);
    WriteLn(F, DateTimeToStr(Date+Time)+': log file created');
    Flush(F);
  except
  end;}
  FCommandsZero := TStringList.Create;
  fDB.ReadCommands(FCommandsZero);
end;
//==============================================================================
destructor TCommand.Destroy;
begin
  FCommands.Clear;
  FCommands.Free;
  FCommandsZero.Free;
  FCMD.Clear;
  FCMD.Free;
  FDeferredCommands.Free;
  inherited Destroy;
end;
//==============================================================================
procedure TCommand.DoDeferredCommands;
var
  i: integer;
  dc: TDeferredCommand;
begin
  for i := FDeferredCommands.Count - 1 downto 0 do begin
    dc := TDeferredCommand(FDeferredCommands[i]);
    if dc.TimeToLaunch <= Now then begin
      try
        dc.Method(dc.Connection, dc.CMD);
      except
        on E: Exception do
          if Assigned(dc.OnExceptionMethod) then
            dc.OnExceptionMethod
          else
            raise E;
      end;
      FDeferredCommands.Delete(i);
    end;
  end;
end;
//==============================================================================
function TCommand.Receive(var Connection: TConnection; var Data: string;
  CommandType: TCommandType;
  Socket: TCustomWinSocket = nil): string;
var
  Len,n: Integer;
  Cmd: string;
begin
  result:='Unknown';
  while Data<>'' do begin
    Len := Pos(#10, Data);
    if Len<>0 then begin
      Cmd := Copy(Data, 1, Len);
      case CommandType of
        cmtUsual: Parse(Connection, Cmd);
        //cmtMultiMedia: ParseMM(Connection, Cmd);
      end;
      Delete(Data, 1, Len);
    end else
      Data := '';
  end;
  n:=pos(' ',Cmd);
  if n=0 then result:=CMD
  else result:=copy(CMD,1,n-1);
  if (result<>'') and (result[1]='/') then
    result:=copy(result,2,length(result));
end;
//==============================================================================
procedure TCommand.SendTime(var Connection: TConnection; FCMD: TStrings);
var s: string;
begin
  s:=FormatDateTime('mm"/"dd"/"yyyy hh:mm:ss AM/PM',Date+Time);
  fSocket.Send(Connection,
    [DP_SERVER_MSG, DP_ERR_0, s]);
end;
//==============================================================================
function TCommand.HaveRight(Login, Command: string): integer;
begin
  if (Command = CMD_STR_ACK_FLAG) or (Command = CMD_STR_ACK_PING) or (Command = CMD_STR_ZERO_TIME) then result:=0
  else if (Command = '') or (length(Command) > 127) then result:=-1
  else        
    begin
      if Command[1]='/' then Command:=copy(Command,2,length(Command));
      if FCommandsZero.IndexOf(lowercase(Command))<>-1 then result:=0
      else result:=fDB.ExecProc('dbo.proc_HaveRight',[Login, Command]);
    end;
end;
//==============================================================================
procedure TCommand.Launch(p_Method: TCommandProcedure; Connection: TConnection;
  Params: array of Variant);
var
  sl: TStrings;
  i: integer;
begin
  sl := TStringList.Create;
  sl.Add('');
  try
    for i := Low(Params) to High(Params) do
      sl.Add(VarToStr(Params[i]));
    p_Method(Connection, sl);
  finally
    sl.Free;
  end;
end;
//==============================================================================
procedure TCommand.SendAccessLevels(Connection: TConnection);
var
  i: integer;
begin
  fSocket.Send(Connection,[DP_AL_START]);
  with fAccessLevels do begin
    for i:=0 to LevelsCount-1 do
      fSocket.Send(Connection,[DP_AL_LEVEL,
        IntToStr(Level[i].id),
        Level[i].name,
        Level[i].description]);

    for i:=0 to TypesCount-1 do
      fSocket.Send(Connection,[DP_AL_TYPE,
        IntToStr(type_[i].id),
        type_[i].name,
        type_[i].description]);

    for i:=0 to LinksCount-1 do

  end;
end;
//==============================================================================
{ TDeferredCommand }

constructor TDeferredCommand.Create;
begin
  CMD := TStringList.Create;
end;
//==============================================================================
destructor TDeferredCommand.Destroy;
begin
  CMD.Free;
  inherited;
end;
//==============================================================================
end.



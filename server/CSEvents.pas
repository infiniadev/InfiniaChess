unit CSEvents;

interface

uses Classes,SysUtils,CSEvent,CSTournament,CSConnection, CSConnections, contnrs, CSGame;

type
  TCSEvents=class(TList)
    private
      LastId: integer;
      LastOnTimer: TDateTime;
      function NextId: integer;

      function FindEventIndex(ID: integer): integer;
      procedure RestoreGames(Connection: TConnection);
      procedure CheckEventFinished(ID: integer);
    public
      constructor Create;
      // info functions
      function GetEventUsers(ID: integer): TConnectionList;
      function FindEvent(ID: integer): TCSEvent;
      // commands
      procedure CMD_EventCreate(Connection: TConnection; CMD: TStrings);
      procedure CMD_EventCreateEnd(Connection: TConnection; CMD: TStrings);
      procedure CMD_EventJoin(Connection: TConnection; CMD: TStrings);
      procedure CMD_EventMember(Connection: TConnection; CMD: TStrings);
      procedure CMD_EventAbandon(Connection: TConnection; CMD: TStrings);
      procedure CMD_EventObserve(Connection: TConnection; CMD: TStrings);
      procedure CMD_EventStart(Connection: TConnection; CMD: TStrings);
      procedure CMD_EventTell(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventLeave(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventDelete(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_OddsAdd(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventShout(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventParams(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventPause(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventResume(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventForfeit(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventGameAccept(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventGameAbort(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventCong(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventClub(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventTicketsBegin(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventTicket(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventTicketsEnd(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventGameObserve(var Connection: TConnection; var CMD: TStrings);
      procedure CMD_EventFinish(var Connection: TConnection; var CMD: TStrings);
      // events
      procedure OnTimer;
      procedure OnConnectionRelease(Connection: TConnection);
      procedure OnGameResult(Game: TGame);
      procedure OnPrimary(ID: integer; Connection: TCOnnection; OrdNum: integer);
      procedure SendEventsCreated(Connection: TConnection);
      procedure OnLogin(Connection: TConnection);
  end;

var
  fEvents: TCSEvents;

implementation

uses CSSocket,CSConst,CSLib,CSRoom,CSRooms,CSDb,CSGames,CSLecture;
//===========================================================
{ TCSEvents }
//===========================================================
procedure TCSEvents.CheckEventFinished(ID: integer);
var
  ev: TCSEvent;
begin
  ev:=FindEvent(ID) as TCSEvent;
  if ev = nil then exit;
  ev.CheckEventFinished;
end;
//===========================================================
procedure TCSEvents.CMD_EventCreate(Connection: TConnection; CMD: TStrings);
var
  EV: TCSEvent;
  sName,InitialTime,sType,sDesc,sDate,sTime,sMainUsers,sDateTime,sReserv,sClubList: string;
  dt: TDateTime;
  type_: TCSEventType;
  ID,IncTime,MaxGamesCount,nMinRating,nMaxRating,TimeLimit,ShoutStart,ShoutInc: integer;
  RatedType: TRatedType;
  bRated,bProvisional,bAdminTitleOnly,bAutoStart,bLagRestriction,bShoutEveryRound: Boolean;
  Room: TRoom;
begin
  if CMD.Count<19 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  ID:=StrToInt(CMD[1]);
  sName:=Replace(CMD[2],'_',' ');
  sType:=lowercase(CMD[3]);
  if (sType='simul') or (sType='s') then
    type_:=evtSimul
  else if (sType='challenge') or (sType='c') then
    type_:=evtChallenge
  else if (sType='king') or (sType='k') then
    type_:=evtKing
  else if (sType='tournament') or (sType='t') then
    type_:=evtTournament
  else if (sType = 'lecture') or (sType = 'l') then
    type_:=evtLecture
  else begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Unknown event type: '+sType],nil);
    exit;
  end;

  // two format of date: one float format (CMD[3] must be 'FL'),
  // another is date and time format (CMD[3] and CMD[4])
  if CMD[4]='FL' then begin
    try
      dt:=Str2Float(CMD[5]);
    except
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Unknown number format: '+CMD[5]],nil);
      exit;
    end;
  end else begin
    sDate:=CMD[4];
    sTime:=CMD[5];
    sDateTime:=sDate+' '+sTime;
    try
      dt:=StrToDateTime(sDateTime);
    except
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Unknown date/time format: '+sDateTime],nil);
      exit;
    end;
  end;

  sMainUsers:=CMD[6];
  sDesc:=Replace(CMD[7],'_',' ');

  try
    nMinRating:=StrToInt(CMD[8]);
    nMaxRating:=StrToInt(CMD[9]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number'],nil);
    exit;
  end;

  try
    MaxGamesCount:=StrToInt(CMD[10]);
    InitialTime:=CMD[11];
    IncTime:=StrToInt(CMD[12]);
    TimeLimit:=StrToInt(CMD[13]);
    ShoutStart:=StrToInt(CMD[14]);
    ShoutInc:=StrToInt(CMD[15]);
    RatedType:=TRatedType(StrToInt(CMD[16]));
    bProvisional:=CMD[17]='1';
    bRated:=CMD[18]='1';
    bAdminTitleOnly:=CMD[19]='1';
    if CMD.Count>21 then begin
      bAutoStart:=CMD[20]='1';
      sReserv:=CMD[21]
    end else begin
      bAutoStart:=false;
      sReserv:='';
    end;
    if sReserv='-' then sReserv:='';
    if CMD.Count>22 then sClubList:=CMD[22]
    else sClubList:=IntToStr(Connection.ClubId);

    if CMD.Count>23 then bLagRestriction:=CMD[23]='1'
    else bLagRestriction:=false;

    if CMD.Count>24 then bShoutEveryRound:=CMD[24]='1'
    else bShoutEveryRound:=false;

  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number'],nil);
    exit;
  end;

  if ID=0 then begin
    case type_ of
      evtSimul: EV:=TCSEventSimul.Create;
      evtChallenge: EV:=TCSEventChallenge.Create;
      evtKing: EV:=TCSEventKing.Create;
      evtTournament: EV:=TCSTournament.Create;
      evtLecture: EV:=TCSLecture.Create;
    end;
    fEvents.Add(EV);
    ID:=NextID;
  end else begin
    EV:=FindEvent(ID);
    if EV=nil then begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
      exit;
    end;
  end;

  EV.OddsList.Clear;
  if type_ <> evtLecture then
    Room := TRoom.Create(nil, sName, 1000, ID, 0, false);

  EV.SetMainParams(
    Connection.Handle,
    sName,type_,dt,sMainUsers,
    sDesc,nMinRating,nMaxRating,
    ID,MaxGamesCount,
    InitialTime,IncTime,
    TimeLimit,ShoutStart,ShoutInc,
    RatedType,
    Room,
    bProvisional,
    bRated,
    bAdminTitleOnly,
    bAutoStart,
    sReserv,
    sClubList,
    bLagRestriction,
    bShoutEveryRound);

  //EV.SendEventCreated(fConnections.Connections);
  Connection.LastCreatedEventId:=EV.ID;

  if EV.Room <> nil then
    fRooms.Rooms.Add(EV.Room);
end;
//==========================================================================
procedure TCSEvents.CMD_EventDelete(var Connection: TConnection;
  var CMD: TStrings);
var
  ev: TCSEvent;
  id,index,ngames: integer;
  bAbort: Boolean;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    id:=StrToInt(CMD[1]);
    bAbort:=(CMD.Count>2) and (CMD[2]='abort');
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  ev:=TCSEvent(Items[index]);
  if ev=nil then exit;

  ngames:=ev.CountCurrentGames;

  if (ev.Status <> estFinished) and (ngames>0) and not bAbort then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'This event contains started games. Wait for finish or abort event.'],nil);
    exit;
  end;

  fSocket.Send(fConnections.Connections,[DP_EVENT_DELETED,IntToStr(id)],ev);
  if ev.Status = estWaited then
    fDB.EventDelete(ev.ID);
  ev.Destroy;
  fEvents.Delete(index);

end;
//===========================================================
procedure TCSEvents.CMD_EventJoin(Connection: TConnection; CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  if Connection.MembershipType = mmbNone then begin
    Connection.SendNoMembershipMsg(DP_MSG_NO_EVENTS);
    exit;
  end;

  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  if ev.AdminTitledOnly and (Connection.AdminLevel=alNone) and (Connection.Title='') then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Only admins and titled players have right to join this event'],nil);
    exit;
  end;

  if Connection.EVBanned then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'You are banned and not allowed to join events'],nil);
    exit;
  end;

  ev.Join(Connection,'j');
end;
//===========================================================
procedure TCSEvents.CMD_EventLeave(var Connection: TConnection;
  var CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_EVENT_LEFT,IntToStr(id)],nil);
    exit;
  end;
  ev.UserLeave(Connection);
end;
//===========================================================
procedure TCSEvents.CMD_EventObserve(Connection: TConnection;
  CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  if ev.AdminTitledOnly and (Connection.AdminLevel=alNone) and (Connection.Title='') then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Only admins and titled players have right to observe this event'],nil);
    exit;
  end;

  ev.Join(Connection,'o');
end;
//===========================================================
procedure TCSEvents.CMD_EventParams(var Connection: TConnection;
  var CMD: TStrings);
var
  ev: TCSEvent;
  EventId: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    EventId:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  if EventID = 0 then EventId:=Connection.LastCreatedEventId;
  if EventId = 0 then begin
    //fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'You didn''t create events']);
    exit;
  end;

  ev:=FindEvent(EventId);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;
  ev.Params(Connection,CMD);
end;
//===========================================================
procedure TCSEvents.CMD_EventPause(var Connection: TConnection;
  var CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;
  ev.Pause(Connection);
end;
//===========================================================
procedure TCSEvents.CMD_EventResume(var Connection: TConnection;
  var CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;
  ev.Resume(Connection);
end;
//===========================================================
procedure TCSEvents.CMD_EventShout(var Connection: TConnection;
  var CMD: TStrings);
var
  EventId: integer;
  Msg: string;
  ev: TCSEvent;
  i: integer;
begin
  if CMD.Count<3 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    EventID:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  Msg:=CMD[2];
  for i:=3 to CMD.Count-1 do
    Msg:=Msg+' '+CMD[i];

  if EventID = 0 then EventId:=Connection.LastCreatedEventId;
  if EventId = 0 then begin
    exit;
  end;

  ev:=FindEvent(EventId);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  ev.ShoutMsg:=Msg;
end;
//===========================================================
procedure TCSEvents.CMD_EventStart(Connection: TConnection; CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
  s: string;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  if not ev.AllLeadersHere then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Leader(s) of event must join it first'],nil);
    exit;
  end;

  {if (Connection.Handle<>EV.Creator) and
    ((ev.OneLeaderEvent) and not ev.IsLeader(Connection) or not ev.OneLeaderEvent)
  then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,'You have not got rights to start event']);
    exit;
  end;}



  s:=ev.MainUsersAbsent;
  if s<>'' then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Cannot start event while leaders absent: '+s],nil);
    exit;
  end;

  if ev.Status <> estWaited then begin
    case ev.Status of
      estStarted: s:='already started.';
      estFinished: s:='already finished.';
    end;
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'This event is '+s],nil);
    exit;
  end;

  ev.Start;
end;
//===========================================================
procedure TCSEvents.CMD_EventTell(var Connection: TConnection;
  var CMD: TStrings);
const
  COLOR_NUM = 1;
  EVENT_NUM = 2;
  TELL_MSG = 3;
var
  _Connection: TConnection;
  ev: TCSEvent;
  id, Index, i: Integer;
  s: string;
  leaType: TCSLectureActionType;
begin
  { Verify login not muted }
  if Connection.Muted = True then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MUTE],nil);
      Exit;
    end;

  if Connection.MembershipType = mmbNone then
    Connection.WarnAboutNoMembershipChat;

  if CMD.Count=3 then
    CMD.Insert(1,'-1');

  { Parameter check. }
  if CMD.Count < 4 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
        DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Verify the RoomNumber exists. }
  id := StrToInt(CMD[EVENT_NUM]);
  ev := FindEvent(id);
  if ev = nil then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Event does not exists'],nil);
    Exit;
  end;

  { Verify the Connection is actually in the room. }
  if ev.Users.IndexOf(Connection) = -1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'You are not joined the event'],nil);
    Exit;
  end;

  { Censor filter }
  for Index := ev.Users.Count -1 downto 0 do
    begin
      _Connection := TConnection(ev.Users[Index]);
      _Connection.Send := not _Connection.Censors[Connection];
    end;

  if ev.Type_ = evtLecture then begin
    if ev.IsLeader(Connection) then leaType := leaLecturerChat
    else leaType := leaStudentChat;
    (ev as TCSLecture).AddAction(leaType,StrToInt(CMD[COLOR_NUM]),CMD[TELL_MSG]);
  end;

  { Passed all the checks, say what you have to say. }
  for i := 0 to ev.Users.Count - 1 do begin
    TConnection(ev.Users[i]).Send := (Connection.MembershipType > mmbNone)
      or (TConnection(ev.Users[i]).AdminLevel > alNone);
  end;
  fSocket.Send(ev.Users, [DP_EVENT_TELL, IntToStr(ev.id),
    Connection.Handle, Connection.Title, CMD[TELL_MSG], CMD[COLOR_NUM]],Connection);

  { Save last room tell was used in. }
  Connection.LastCmd := CMD_STR_EVENT_TELL;
  Connection.CmdParam := CMD[EVENT_NUM];
end;
//===========================================================
procedure TCSEvents.CMD_OddsAdd(var Connection: TConnection;
  var CMD: TStrings);
var
  EventId,Rating,IncTime: integer;
  InitTime,Pieces: string;
  ev: TCSEvent;
begin
  try
    EventID:=StrToInt(CMD[1]);
    Rating:=StrToInt(CMD[2]);
    InitTime:=CMD[3];
    IncTime:=StrToInt(CMD[4]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  Pieces:=CMD[5];
  if Pieces='-' then Pieces:='';

  if EventID = 0 then EventId:=Connection.LastCreatedEventId;
  if EventId = 0 then begin
    //fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'You didn''t create events']);
    exit;
  end;

  ev:=FindEvent(EventID);
  if ev = nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,Format('Event with number %d not found',[EventID])],nil);
    exit;
  end;

  ev.AddOdds(Rating,InitTime,IncTime,Pieces);
  fSocket.Send(fConnections.Connections,[DP_EVENT_ODDS_ADD,
    IntToStr(ev.ID), IntToStr(Rating),
    InitTime, IntToStr(IncTime),
    Pieces],ev);
end;
//===========================================================
function TCSEvents.FindEvent(ID: integer): TCSEvent;
var
  i: integer;
begin
  for i:=0 to Count-1 do begin
    result:=TCSEvent(Items[i]);
    if result.ID=ID then exit;
  end;
  result:=nil;
end;
//===========================================================
function TCSEvents.FindEventIndex(ID: integer): integer;
var
  i: integer;
  ev: TCSEvent;
begin
  for i:=0 to Count-1 do begin
    ev:=TCSEvent(Items[i]);
    if ev.ID=ID then begin
      result:=i;
      exit;
    end;
  end;
  result:=-1;
end;
//===========================================================
function TCSEvents.GetEventUsers(ID: integer): TConnectionList;
var
  ev: TCSEvent;
  i: integer;
begin
  ev:=FindEvent(ID);
  if ev=nil then result:=nil
  else result:=ev.Users;
end;
//===========================================================
function TCSEvents.NextId: integer;
begin
  dec(LastId);
  result:=LastId;
end;
//===========================================================
procedure TCSEvents.OnGameResult(Game: TGame);
var
  ev: TCSEvent;
begin
  ev:=FindEvent(Game.EventId);
  if ev = nil then exit;
  ev.OnGameResult(Game.EventOrdNum);
  ev.CheckEventFinished;
end;
//===========================================================
procedure TCSEvents.OnTimer;
var
  i: integer;
  ev: TCSEvent;
begin
  //if Now-EVENT_ON_TIMER_PERIOD/1440<LastOnTimer then exit;
  for i:=0 to Count-1 do begin
    ev:=TCSEvent(Items[i]);
    ev.OnTimer;
  end;
  LastOnTimer:=Now;
end;
//===========================================================
procedure TCSEvents.RestoreGames(Connection: TConnection);
var
  ev: TCSEvent;
  evt: TCSTournament;
  i: integer;
  GM: TGame;
begin
  ev:=FindEvent(Connection.EventId);
  if (ev <> nil) and not (ev is TCSTournament) then ev.RestoreGames(Connection)
  else
    for i:=0 to Count-1 do begin
      ev:=TCSEvent(Items[i]);
      if ev is TCSTournament then begin
        evt:=ev as TCSTournament;
        if (evt.Reglament.MemberList.IndexOfUser(Connection.Handle)<>-1) and (ev.Status<>estFinished) then begin
          evt.Member(Connection);
        end;
      end {else begin
        GM:=TGame(ev.GameOfUser(Connection.Handle));
        if (GM<>nil) and (GM.GameResult = grNone) then
          ev.Join(Connection,'j');

      end};
    end;
end;
//===========================================================
procedure TCSEvents.OnLogin(Connection: TConnection);
begin
  SendEventsCreated(Connection);
  if not Connection.Invisible then
    RestoreGames(Connection);
end;
//===========================================================
procedure TCSEvents.OnPrimary(ID: integer; Connection: TCOnnection;
  OrdNum: integer);
var
  ev: TCSEvent;
begin
  ev:=fEvents.FindEvent(ID);
  if ev<>nil then ev.SetPrimary(Connection,OrdNum);
end;
//===========================================================
procedure TCSEvents.OnConnectionRelease(Connection: TConnection);
var
  i: integer;
  ev: TCSEvent;
begin
  if Connection=nil then exit;
  for i:=0 to Count-1 do begin
    ev:=TCSEvent(Items[i]);
    if ev<>nil then
      ev.UserLeave(Connection);
  end;
end;
//===========================================================
constructor TCSEvents.Create;
begin
  LastId:=0;
  LastOnTimer:=0;
end;
//===========================================================
procedure TCSEvents.CMD_EventAbandon(Connection: TConnection;
  CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;
  ev.Abandon(Connection);
end;
//===========================================================
procedure TCSEvents.CMD_EventMember(Connection: TConnection;
  CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  if ev.AdminTitledOnly and (Connection.AdminLevel=alNone) and (Connection.Title='') then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Only admins and titled players have right to take part this event'],nil);
    exit;
  end;

  if Connection.EVBanned then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'You are banned and not allowed to join events'],nil);
    exit;
  end;

  ev.Member(Connection);
end;
//===========================================================
procedure TCSEvents.CMD_EventForfeit(var Connection: TConnection;
  var CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
  name: string;
begin
  if CMD.Count<3 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
    name:=CMD[2];
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;
  ev.Forfeit(Connection,Name);
end;
//===========================================================
procedure TCSEvents.CMD_EventGameAccept(var Connection: TConnection; var CMD: TStrings);
var
  ev: TCSEvent;
  id,rgame_id: integer;
begin
  if CMD.Count<3 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
    rgame_id:=StrToInt(CMD[2]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number'],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  if ev.Type_ = evtTournament then
    (ev as TCSTournament).GameAccept(Connection,rgame_id);
end;
//===========================================================
procedure TCSEvents.CMD_EventGameAbort(var Connection: TConnection;
  var CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number'],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  ev.AbortGame(Connection);
end;
//===========================================================
procedure TCSEvents.CMD_EventCreateEnd(Connection: TConnection;
  CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number'],nil);
    exit;
  end;

  if id=0 then id:=Connection.LastCreatedEventId;
  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  if not fDB.SaveEvent(ev) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,'Error during saving event in database']);
    fEvents.Delete(fEvents.Count-1);
  end else
    ev.SendEventCreated(fConnections.Connections);
end;
//===========================================================
procedure TCSEvents.CMD_EventCong(var Connection: TConnection;
  var CMD: TStrings);
var
  EventId: integer;
  Msg: string;
  ev: TCSEvent;
  i: integer;
begin
  if CMD.Count<3 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    EventID:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  Msg:=CMD[2];
  for i:=3 to CMD.Count-1 do
    Msg:=Msg+' '+CMD[i];

  if EventID = 0 then EventId:=Connection.LastCreatedEventId;
  if EventId = 0 then begin
    exit;
  end;

  ev:=FindEvent(EventId);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  ev.CongrMsg:=Msg;
end;
//===========================================================
procedure TCSEvents.CMD_EventClub(var Connection: TConnection;
  var CMD: TStrings);
var
  EventId: integer;
  Clubs: string;
  ev: TCSEvent;
begin
  if CMD.Count<3 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    EventID:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;
  Clubs:=CMD[2];
  ev:=FindEvent(EventId);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;
  ev.ClubList:=Clubs;
end;
//===========================================================
procedure TCSEvents.SendEventsCreated(Connection: TConnection);
var
  i: integer;
  ev: TCSEvent;
begin
  fSocket.Send(Connection,[DP_EVENTS_CLEAR]);
  for i:=0 to Count-1 do begin
    ev:=TCSEvent(Items[i]);
    MarkSendOnlyOne(fConnections.Connections, Connection);
    ev.SendEventCreated(fConnections.Connections);
  end;
end;
//===========================================================
procedure TCSEvents.CMD_EventTicket(var Connection: TConnection;
  var CMD: TStrings);
var
  EventId: integer;
  ev: TCSEvent;
  Login,RealLogin,Title: string;
  LoginId,Rating: integer;
begin
  if CMD.Count<3 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    EventID:=StrToInt(CMD[1]);
    Login:=CMD[2];
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;
  if EventID = 0 then EventId:=Connection.LastCreatedEventId;
  ev:=FindEvent(EventId);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;
  if not fDB.GetLoginInfo(Login,ev.RatedType,LoginId,Rating,RealLogin,Title) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Cannot add ticket for '+CMD[2]+': user not found'],nil);
    exit;
  end;
  ev.Tickets.AddTicket(RealLogin,Title,Rating);
end;
//===========================================================
procedure TCSEvents.CMD_EventTicketsBegin(var Connection: TConnection;
  var CMD: TStrings);
var
  EventId: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    EventID:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;
  if EventID = 0 then EventId:=Connection.LastCreatedEventId;
  ev:=FindEvent(EventId);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;
  ev.Tickets.Clear;
end;
//===========================================================
procedure TCSEvents.CMD_EventTicketsEnd(var Connection: TConnection;
  var CMD: TStrings);
var
  EventId: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    EventID:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;
  if EventID = 0 then EventId:=Connection.LastCreatedEventId;
  ev:=FindEvent(EventId);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;
  //ev.SendTicketsInfo(fConnections.Connections);
end;
//===========================================================
procedure TCSEvents.CMD_EventGameObserve(var Connection: TConnection; var CMD: TStrings);
var
  GameID: integer;
  ev: TCSEvent;
  GM: TGame;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    GameId:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number'],nil);
    exit;
  end;

  GM:=fGames.GetGame(GameID);
  if GM.EventID = 0 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'This is not event game'],nil);
    exit;
  end;

  ev:=FindEvent(GM.EventID);
  if ev = nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Event does not exists'],nil);
    exit;
  end;

  //if not GM.Involved(Connection) then begin
    //GM.AddConnection(Connection);
  ev.SendGameMoves(Connection,GM);
  //end;
end;
//===========================================================
procedure TCSEvents.CMD_EventFinish(var Connection: TConnection;
  var CMD: TStrings);
var
  ev: TCSEvent;
  id: integer;
  s: string;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;
  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[1]],nil);
    exit;
  end;

  ev:=FindEvent(id);
  if ev=nil then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There is no event with number'+CMD[1]],nil);
    exit;
  end;

  if (Connection.AdminLevel = alNone) and not ev.IsLeader(Connection) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'You don''t have rights to finish this event'],nil);
    exit;
  end;

  if ev.Status <> estStarted then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Event must be started to finish it'],nil);
    exit;
  end;

  ev.Finish;
end;
//===========================================================
end.


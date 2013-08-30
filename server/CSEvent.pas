unit CSEvent;

interface

uses Classes,CSConnection,SysUtils,CSRoom,CSConnections,Contnrs,CSConst, Variants;

type
  //--------------------------------------------------------------------------
  TCSEventType = (evtSimul,evtChallenge,evtKing,evtTournament,evtLecture);
  //--------------------------------------------------------------------------
  TCSEventStatus = (estWaited,estStarted,estFinished);
  //--------------------------------------------------------------------------
  TCSLeaderColor = (elcTurn,elcRandom,elcWhite,elcBlack);
  //--------------------------------------------------------------------------
  TCSOdds = class
    public
      Rating: integer;
      InitTime: string;
      IncTime: integer;
      Pieces: string;
  end;
  //--------------------------------------------------------------------------
  TCSOddsList = class(TObjectList)
    public
      procedure AddOdds(Rating: integer; InitTime: string; IncTime: integer; Pieces: string);
      function FindOdds(Rating: integer): TCSOdds;
  end;
  //--------------------------------------------------------------------------
  TEventTicket = class
    Login: string;
    Title: string;
    Rating: integer;
  end;
  //--------------------------------------------------------------------------
  TEventTickets = class(TObjectList)
  private
    function GetTicket(Index: integer): TEventTicket;
  public
    property Ticket[Index: integer]: TEventTicket read GetTicket; default;
    procedure AddTicket(Login,Title: string; Rating: integer);
    function HaveTicket(Login: string): Boolean;
  end;
  //--------------------------------------------------------------------------
  TCSEvent = class(TObject)
    private
      FId: integer;
      FName: string;
      FType: TCSEventType;
      FStartTime: TDateTime;
      FLeaders: TStringList;
      FUsers: TConnectionList;
      FDescription: string;
      FMinRating: integer;
      FMaxRating: integer;
      FRoom: TRoom;
      FOddsList: TCSOddsList;
      FMaxGamesCount: integer;
      FInitialTime: string;
      FIncTime: integer;
      FGames: TList;
      FLeaderLocation: integer;
      FConnLeader: TConnection;
      FLeaderColor: TCSLeaderColor;
      FOneGame: Boolean;
      FPaused: Boolean;
      FTimeLimit: integer;
      FShoutStart: integer;
      FShoutInc: integer;
      FLastShout: TDateTime;
      FShoutMsg: string;
      FRatedType: TRatedType;
      FCreator: string;
      FRated: Boolean;
      FProvisionalAllowed: Boolean;
      FAdminTitledOnly: Boolean;
      FCongrMsg: string;
      FClubList: string;
      FTickets: TEventTickets;
      FLagRestriction: Boolean;
      FShoutEveryRound: Boolean;
      function FindConnectionIndex(Connection: TConnection): integer;
      function GetMainUsersAbsent: string;
      procedure SetLeaderLocation(const Value: integer);
      procedure GetUsersStat(var nLeader,nJoined,nObserver: integer);
      function GetOneLeaderEvent: Boolean;
      function UserGameExists(Name: string): Boolean;
      function GetCanBePaused: Boolean;
      procedure SendFinishShout; virtual;
      procedure SetStatus(const Value: TCSEventStatus);
      protected
      FStatus: TCSEventStatus;
      FReserv: TStringList;
      FAutoStart: Boolean;
      FMaxPeople: integer;
      FMinPeople: integer;
      function CountActiveGames: integer;
    public
      constructor Create; virtual;
      destructor Destroy; virtual;
      // read only properties
      property ID: integer read FId write FId;
      property Name: string read FName;
      property Type_: TCSEventType read FType;
      property StartTime: TDateTime read FStartTime;
      property Leaders: TStringList read FLeaders;
      property Users: TConnectionList read FUsers;
      property Description: string read FDescription;
      property MainUsersAbsent: string read GetMainUsersAbsent;
      property MinRating: integer read FMinRating;
      property MaxRating: integer read FMaxRating;
      property Room: TRoom read FRoom;
      property OddsList: TCSOddsList read FOddsList;
      property MaxGamesCount: integer read FMaxGamesCount;
      property InitialTime: string read FInitialTime;
      property IncTime: integer read FIncTime;
      property Games: TList read FGames;
      property LeaderLocation: integer read FLeaderLocation write SetLeaderLocation;
      property ConnLeader: TConnection read FConnLeader;
      property OneLeaderEvent: Boolean read GetOneLeaderEvent;
      property LeaderColor: TCSLeaderColor read FLeaderColor;
      property OneGame: Boolean read FOneGame;
      property Paused: Boolean read FPaused;
      property CanBePaused: Boolean read GetCanBePaused;
      property TimeLimit: integer read FTimeLimit;
      property ShoutStart: integer read FShoutStart;
      property ShoutInc: integer read FShoutInc;
      property Status: TCSEventStatus read FStatus write SetStatus;
      // full access properties
      property ShoutMsg: string read FShoutMsg write FShoutMsg;
      property RatedType: TRatedType read FRatedType;
      property Creator: string read FCreator;
      property Rated: Boolean read FRated;
      property ProvisionalAllowed: Boolean read FProvisionalAllowed;
      property MinPeople: integer read FMinPeople;
      property MaxPeople: integer read FMaxPeople;
      property AdminTitledOnly: Boolean read FAdminTitledOnly;
      property CongrMsg: string read FCongrMsg write FCongrMsg;
      property ClubList: string read FClubList write FClubList;
      property Tickets: TEventTickets read FTickets write FTickets;
      property LagRestriction: Boolean read FLagRestriction write FLagRestriction;
      property ShoutEveryRound: Boolean read FShoutEveryRound write FShoutEveryRound;

      procedure Start; virtual;
      procedure Observe; virtual; abstract;
      procedure CheckEventFinished; virtual; abstract;
      procedure StartGames; virtual; abstract;
      procedure Params(Connection: TConnection; CMD: TStrings); virtual;
      procedure Pause(Connection: TConnection); virtual;
      procedure Resume(Connection: TConnection); virtual;
      procedure OnTimer; virtual;
      procedure SetDefaultMinMaxPeople; virtual;

      procedure SetMainParams(
        p_Creator,p_Name: string;
        p_Type_: TCSEventType;
        p_StartTime: TDateTime;
        p_Leaders,p_Description: string;
        p_MinRating,p_MaxRating,p_Id,p_MaxGamesCount: integer;
        p_InitialTime: string;
        p_IncTime,p_TimeLimit: integer;
        p_ShoutStart,p_ShoutInc: integer;
        p_RatedType: TRatedType;
        p_Room: TRoom;
        p_Provisional,p_Rated,p_AdminTitledOnly,p_AutoStart: Boolean;
        p_Reserv,p_ClubList: string;
        p_LagRestriction,p_ShoutEveryRound: Boolean);

      procedure Join(Connection: TConnection; Mode: string {j - join, o - observe}); virtual;
      function Member(Connection: TConnection): Boolean; virtual;
      procedure Abandon(Connection: TConnection); virtual;
      procedure SendUserJoinMessages(Connection: TConnection); virtual;
      procedure SendObserverList(Connection: TConnection);
      procedure UserLeave(Connection: TConnection); virtual;
      function  CountUsers(State: TCSEventUserState): integer;
      procedure AddOdds(Rating: integer; InitTime: string; IncTime: integer; Pieces: string);
      procedure SendOdds(Connections: TObjectList);
      procedure SendEventCreated(Connections: TObjectList); virtual;
      procedure SendGamesBorn(GameNum: integer=-1);
      procedure SendGameBornObserver(Connection: TConnection);
      procedure SendGameMoves(Connection: TConnection; Game: TObject);
      procedure SendStatistic(Connections: TObjectList);
      procedure SetPrimary(Connection: TConnection; OrdNum: integer);
      procedure DefineLeader; virtual;
      procedure OnGameResult(GameOrdNum: integer); virtual;
      function  IsLeader(Connection: TConnection): Boolean;
      function  NewLeaderGame(UserNum,GameNum: integer; LeaderWhite: Boolean): integer;
      procedure MoveUserToTail(UserNum: integer);
      function  TestTimeLimit: Boolean;
      procedure SendFullQueue(Connection: TConnection=nil); virtual;
      function  FindJoinedUser(Login: string): TConnection;
      procedure Forfeit(Connection: TConnection; Login: string); virtual;
      procedure AbortAllGames;
      function CountCurrentGames: integer;
      function AllLeadersHere: Boolean;
      function IndexOfUser(Connection: TConnection): integer;
      procedure AbortGame(Connection: TConnection);
      function FreeSlots: integer; virtual;
      function InitTimeSeconds: Boolean;
      function UserCanJoin(Connection: TConnection; var pp_ErrMsg: string): Boolean; virtual;
      procedure RestoreGames(Connection: TConnection); virtual;
      procedure ReviveGames(Connection: TConnection);
      function GameOfUser(Login: string): TObject;
      function CanSend(Connection: TConnection): Boolean;
      procedure SendTicketsInfo(Connections: TObjectList);
      function CountMembersNoTicket: integer;
      procedure SaveFinishedToDB; virtual;
      procedure Finish; virtual;
  end;
  //--------------------------------------------------------------------------
  TCSEventSimul = class(TCSEvent)
    private
    public
      procedure StartGames; override;
      procedure CheckEventFinished; override;
      function FreeSlots: integer; override;
      procedure Params(Connection: TConnection; CMD: TStrings); override;
  end;
  //--------------------------------------------------------------------------
  TCSEventChallenge = class(TCSEvent)
    private
      procedure StartGames; override;
      procedure StartNextGame;
      procedure OnGameResult(GameOrdNum: integer); override;
      procedure Params(Connection: TConnection; CMD: TStrings); override;
      procedure CheckEventFinished; override;
      function FreeSlots: integer; override;
      procedure Join(Connection: TConnection; Mode: string {j - join, o - observe}); override;
    public
      procedure Resume(Connection: TConnection); override;
  end;
  //--------------------------------------------------------------------------
  TCSEventKing = class(TCSEvent)
    private
      PlayingUserNum: integer;
      KingColor: TCSLeaderColor;
      function ChangeKing(UserNum: integer): integer;
      function ToChangeKing: Boolean;
    public
      connKing: TConnection;
      KingGamesWon: integer;
      procedure Join(Connection: TConnection; Mode: string {j - join, o - observe}); override;
      procedure StartGames; override;
      procedure StartNextGame;
      procedure OnGameResult(GameOrdNum: integer); override;
      procedure SendKingInfo(Connection: TConnection = nil);
      procedure CheckEventFinished; override;
      procedure Params(Connection: TConnection; CMD: TStrings); override;
      procedure UserLeave(Connection: TConnection); override;
  end;
  //--------------------------------------------------------------------------

implementation

uses CSLib,CSSocket,CSEvents,CSGames,CSRooms,CSOffer,CSGame,CSDb;

//==========================================================================
function NewLeaderColor(LeaderColor: TCSLeaderColor; LeaderWhite: Boolean): Boolean;
// true - white, false - black
begin
  case LeaderColor of
    elcTurn: result:=not LeaderWhite;
    elcWhite: result:=true;
    elcBlack: result:=false;
    elcRandom: result:=random(10)<5;
  end;
end;
//==========================================================================
function EventType2Str(evt: TCSEventType): string;
begin
  case evt of
    evtSimul: result:='simul';
    evtChallenge: result:='challenge';
    evtKing: result:='king';
    evtTournament: result:='tournament';
    evtLecture: result:='lecture';
  end;
end;
//==========================================================================
{ TCSEvent }
//==========================================================================
procedure TCSEvent.AddOdds(Rating: integer; InitTime: string; IncTime: integer; Pieces: string);
begin
  FOddsList.AddOdds(Rating,InitTime,IncTime,Pieces);
  fSocket.Send(fConnections.Connections,
    [DP_EVENT_ODDS_ADD,
     IntToStr(Self.ID),IntToStr(Rating),
     InitTime,IntToStr(IncTime),
     Pieces],Self);
end;
//==========================================================================
function TCSEvent.CountUsers(State: TCSEventUserState): integer;
var
  i: integer;
  conn: TConnection;
begin
  result:=0;
  for i:=0 to FUsers.Count-1 do begin
    conn:=TConnection(FUsers[i]);
    if conn.EventUserState = State then
      inc(result);
  end;
end;
//==========================================================================
constructor TCSEvent.Create;
begin
  FLeaders:=TStringList.Create;
  FReserv:=TStringList.Create;
  FUsers:=TConnectionList.Create;
  FUsers.OwnsObjects:=false;
  FOddsList:=TCSOddsList.Create;
  FTickets:=TEventTickets.Create;
  FGames:=TList.Create;
  FPaused:=false;
  FLastShout:=0;
end;
//==========================================================================
destructor TCSEvent.Destroy;
var
  i,rindex: integer;
  conn: TConnection;
begin
  fSocket.Send(Users,[DP_SERVER_MSG,DP_ERR_0,'Event '+IntToStr(ID)+' is deleted by admin.'],Self);
  AbortAllGames;
  if Assigned(FLeaders) then FLeaders.Free;
  fSocket.Send(Users,[DP_EVENT_LEFT,IntToStr(Self.ID)],Self);

  // destroy room
  if Room<>nil then begin
    fSocket.Send(fConnections.Connections, [DP_ROOM_DESTROYED, IntToStr(Room.RoomNumber)],nil);
    rindex:=fRooms.IndexOf(Room.RoomNumber);
    if rindex<>-1 then
      fRooms.Rooms.Delete(rindex);
  end;

  for i:=0 to FUsers.Count-1 do begin
    conn:=TConnection(FUsers[i]);
    if conn<>nil then begin
      conn.EventId:=0;
      conn.EventUserState:=eusNone;
    end;
  end;
  for i:=0 to fConnections.Connections.Count-1 do begin
    conn:=TConnection(fConnections.Connections[i]);
    if (conn<>nil) and (conn.EventId = Self.ID) then begin
      conn.EventId:=0;
      conn.EventUserState:=eusNone;
    end;
  end;
  if Assigned(FUsers) then FUsers.Free;
  if Assigned(FOddsList) then FOddsList.Free;
  if Assigned(FGames) then FGames.Free;
  if Assigned(FReserv) then FReserv.Free;
  if Assigned(FTickets) then FTickets.Free;
end;
//==========================================================================
function TCSEvent.FindConnectionIndex(Connection: TConnection): integer;
var
  i: integer;
  conn: TConnection;
begin
  for i:=0 to FUsers.Count-1 do
    if Connection=TConnection(FUsers.Items[i]) then begin
      result:=i;
      exit;
    end;
  result:=-1;
end;
//==========================================================================
function TCSEvent.GetMainUsersAbsent: string;
var
  i,n: integer;
  sl: TStringList;
  conn: TConnection;
  name: string;
begin
  sl:=TStringList.Create;
  try
    sl.CommaText:=FLeaders.CommaText;
    for i:=0 to FUsers.Count-1 do begin
      conn:=TConnection(FUsers.Items[i]);
      name:=lowercase(conn.Handle);
      n:=sl.IndexOf(name);
      if n<>-1 then
        sl.Delete(n);
    end;
    result:=sl.CommaText;
  finally
    sl.Free;
  end;
end;
//==========================================================================
procedure TCSEvent.GetUsersStat(var nLeader,nJoined,nObserver: integer);
var
  i: integer;
  conn: TConnection;
begin
  nLeader:=0; nJoined:=0; nObserver:=0;

  for i:=0 to FUsers.Count-1 do begin
    conn:=TConnection(FUsers[i]);
    case conn.EventUserState of
      eusLeader: inc(nLeader);
      eusMember: inc(nJoined);
      eusObserver: inc(nObserver);
    end;
  end;
end;
//==========================================================================
procedure TCSEvent.Join(Connection: TConnection; Mode: string {j - join, o - observe});
var
  index,rt: integer;
  name,s,ErrMsg: string;
  ModeChanging,Rejoining: Boolean;
  GM: TGame;
begin
  if (type_ = evtLecture) and (status = estFinished) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG,DP_ERR_1,'Lecture is finished already and cannot be joined']);
    exit;
  end;

  ModeChanging:=false;
  if (Connection.EventId<>0) then begin
    if (Connection.EventId<>ID) then
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,'You are currently joined to another event number '+
        IntToStr(Connection.EventId)])
    else if (Connection.EventUserState=eusMember) and (Mode='o')
      or (Connection.EventUserState=eusObserver) and (Mode='j')
    then
      ModeChanging:=true
    else
      exit;
  end;

  GM:=TGame(GameOfUser(Connection.Handle));
  Rejoining:=(GM<>nil) and (GM.GameResult = grNone);

  if Rejoining then begin
    if lowercase(GM.WhiteLogin) = lowercase(Connection.Handle) then
      GM.WhiteDisconnectTime:=0
    else if lowercase(GM.BlackLogin) = lowercase(Connection.Handle) then
      GM.BlackDisconnectTime:=0;
    ReviveGames(Connection);
  end;

  if not Rejoining then begin

    if not TestTimeLimit then begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,
        Format('It''s not time to join this event, you can join it %d minutes before start',[TimeLimit])]);
        exit;
    end;

    rt:=Connection.Rating[RatedType];
    if ((rt<MinRating) or (rt>MaxRating)) and (Mode='j') then begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,
        Format('Your rating must be between %d and %d to join the event',[MinRating,MaxRating])]);
      exit;
    end;

    if Connection.Provisional[RatedType] and not ProvisionalAllowed then begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,
        'Provisional rating is not allowed in this event']);
      exit;
    end;

    if LagRestriction and (Connection.PingLast>=1000) and (Mode='j') then begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,
        'Your current lag is too large to join this event']);
      exit;
    end;

    if (Mode='j') and not Tickets.HaveTicket(Connection.Handle) and (CountUsers(eusMember)>=FMaxPeople) then begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There are maximum people joined to event '+IntToStr(ID)+' already']);
      exit;
    end;

    if (FType<>evtTournament) and (Mode='j') and not Tickets.HaveTicket(Connection.Handle) and (FreeSlots = 0) then begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'There are maximum people joined to event '+IntToStr(ID)+' already']);
      exit;
    end;

    if (Mode='j') and not UserCanJoin(Connection,ErrMsg) then begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,ErrMsg]);
      exit;
    end;
  end;

  if Rejoining and (Mode = 'o') then Mode:='j';

  index:=FindConnectionIndex(Connection);
  Connection.EventId:=ID;
  if FLeaders.IndexOf(lowercase(Connection.Handle))>-1 then
    Connection.EventUserState := eusLeader
  else
    if Mode='j' then Connection.EventUserState := eusMember
    else Connection.EventUserState := eusObserver;

  if (Connection.EventUserState=eusMember) and OneGame and UserGameExists(Connection.Handle)
    and (FType <> evtSimul)
  then
    Connection.EventUserState:=eusObserver;

  if index=-1 then
    FUsers.Add(Connection);

  SendUserJoinMessages(Connection);
  if not ModeChanging then begin
    if Room <> nil then
      fRooms.EnterRoom(Connection,Room.RoomNumber);
    SendGameBornObserver(Connection);
  end;

  SendStatistic(fConnections.Connections);
  if (Connection.EventUserState=eusMember) or ModeChanging then SendFullQueue
  else SendFullQueue(Connection);

  if OneLeaderEvent and (Connection.EventUserState=eusLeader) then
    FConnLeader:=Connection;
end;
//==========================================================================
procedure TCSEvent.SendObserverList(connection: TConnection);
var
  i: integer;
  conn: TConnection;
  s: string;
begin
  fSocket.Send(Connection, [DP_OBSERVER_BEGIN, IntToStr(Self.ID),'e']);
  for i := 0 to Users.Count -1 do
    begin
      conn := TConnection(Users[i]);
      fSocket.Send(Connection, [DP_OBSERVER, IntToStr(Self.ID),
        IntToStr(conn.LoginID), conn.Handle, conn.Title, conn.RatingString,'e',IntToStr(ord(conn.EventUserState))]);
    end;
  fSocket.Send(Connection, [DP_OBSERVER_END, IntToStr(Self.ID),'e']);
end;
//==========================================================================
procedure TCSEvent.SendEventCreated(Connections: TObjectList);
var
  conns: TObjectList;
  i: integer;
  sRoomNumber: string;
begin
  if InitTimeSeconds then conns:=FilterByVersion(Connections,'7.7h')
  else conns:=Connections;

  if Room = nil then sRoomNumber := '-1'
  else sRoomNumber := IntToStr(Room.RoomNumber);

  fSocket.Send(conns,
    [DP_EVENT_CREATED,IntToStr(Id),Name,EventType2Str(type_),FloatToStr(StartTime),
     Leaders.CommaText,Description,
     IntToStr(MinRating),IntToStr(MaxRating),
     IntToStr(ord(Status)),
     IntToStr(MaxGamesCount),InitialTime,IntToStr(IncTime),
     IntToStr(Ord(RatedType)),
     sRoomNumber,
     IntToStr(TimeLimit),
     BoolTo_(Rated,'1','0'),
     IntToStr(ord(LeaderColor)),
     BoolTo_(ProvisionalAllowed,'1','0'),
     BoolTo_(AdminTitledOnly,'1','0'),
     BoolTo_(OneGame,'1','0'),
     IntToStr(MinPeople),
     IntToStr(MaxPeople),
     IntToStr(ShoutStart),
     IntToStr(ShoutInc),
     ShoutMsg,
     BoolTo_(FAutoStart,'1','0'),
     FReserv.CommaText,
     CongrMsg,
     ClubList,
     BoolTo_(FLagRestriction,'1','0'),
     BoolTo_(FShoutEveryRound,'1','0')
    ],
    Self, AdminTitledOnly);
  SendStatistic(conns);
  SendOdds(conns);
  SendTicketsInfo(conns);
  if conns<>Connections then conns.Free;
end;
//==========================================================================
procedure TCSEvent.SendOdds(Connections: TObjectList);
var
  i: integer;
  odds: TCSOdds;
begin
  for i:=0 to OddsList.Count-1 do begin
    odds:=TCSOdds(OddsList[i]);
    fSocket.Send(Connections,
      [DP_EVENT_ODDS_ADD,
       IntToStr(ID),
       IntToStr(odds.Rating),odds.InitTime,
       IntToStr(odds.IncTime),odds.Pieces],Self,AdminTitledOnly);
  end;
end;
//==========================================================================
procedure TCSEvent.SendUserJoinMessages(Connection: TConnection);
var s: string;
begin
  case Connection.EventUserState of
    eusLeader: s:='l';
    eusMember: s:='m';
    eusObserver: s:='o';
  end;

  fSocket.Send(Connection,[DP_EVENT_JOINED,IntToStr(ID),s]);
  fSocket.Send(Users, [DP_OBSERVER, IntToStr(Self.ID),
    IntToStr(Connection.LoginID), Connection.Handle, Connection.Title, Connection.RatingString, 'e',
    IntToStr(ord(Connection.EventUserState))],Self);
  SendObserverList(Connection);
end;
//==========================================================================
procedure TCSEvent.UserLeave(Connection: TConnection);
var
  i,n: integer;
  GM: TGame;
begin
  {if FLeaders.IndexOf(Connection.Handle)>-1 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,
      'You are leader of event, you cannot leave it. Finish event first.']);
    exit;
  end;}

  if FUsers=nil then exit;
  n:=IndexOfUser(Connection);
  if n>-1 then FUsers.Delete(n);

  for i:=0 to Games.Count-1 do begin
    GM:=Games[i];
    if GM.GameResult = grNone then
      if GM.White = Connection then GM.GameResult:=grWhiteForfeitsOnNetwork
      else if GM.Black = Connection then GM.GameResult:=grBlackForfeitsOnNetwork;
    GM.RealConnections.Remove(Connection);
    Connection.RemoveGame(GM);
  end;

  Connection.EventId:=0;
  Connection.EventUserState:=eusNone;

  if Room <> nil then
    fRooms.ExitRoom(Connection,Room.RoomNumber);
  fSocket.Send(Users, [DP_UNOBSERVER, IntToStr(Self.ID),
    IntToStr(Connection.LoginID), Connection.Handle, Connection.Title,'e'],Self);

  fSocket.Send(Connection,[DP_EVENT_LEFT,IntToStr(Self.ID)]);

  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,
    'You left event '+Self.Name]);

  SendStatistic(fConnections.Connections);
  CheckEventFinished;
end;
//==========================================================================
procedure TCSEvent.SendGameBornObserver(Connection: TConnection);
var
  i,j: integer;
  GM: TGame;
begin
  fSocket.Buffer:=true;
  try // fSocket.Buffer := false

  fSocket.Send(Connection,[DP_EVENT_GAMES_BEGIN,IntToStr(Self.ID)]);
  for i:=0 to Games.Count-1 do begin
    GM:=TGame(Games[i]);
    if not Assigned(GM) then continue;

    fSocket.Send(Connection,
      [DP_GAME_BORN, IntToStr(GM.GameNumber), GM.Site, GM.Event, IntToStr(GM.Round), GM.Date,
       GM.WhiteLogin,GM.WhiteTitle,IntToStr(GM.WhiteRating),
       GM.BlackLogin,GM.BlackTitle,IntToStr(GM.BlackRating),
       IntToStr(GM.WhiteInitialMSec), IntToStr(GM.WhiteIncMSec), IntToStr(Ord(GM.GameMode)), '1',
       IntToStr(Ord(GM.RatedType)), IntToStr(Integer(GM.Rated)), '0',
       IntToStr(GM.EventId), IntToStr(GM.EventOrdNum),
       IntToStr(GM.BlackInitialMSec), IntToStr(GM.BlackIncMSec)]);

    {with GM.Odds do
      fSocket.Send(Connection,
        [DP_GAME_ODDS, IntToStr(GM.GameNumber),
         BoolTo_(FAutoTimeOdds, '1', '0'),
         IntToStr(FInitMin), IntToStr(FInitSec),
         IntToStr(FInc), IntToStr(FPiece),
         IntToStr(ord(FTimeDirection)), IntToStr(ord(FPieceDirection)),
         IntToStr(ord(FInitiator))]);}

    if GM.Involved(Connection) or (CompareVersion(Connection.Version,'7.9zr')<0)
       or ((FType in [evtChallenge,evtKing]) and (GM.GameResult = grNone))
       or (FType = evtLecture)
    then
      SendGameMoves(Connection,GM);

    {if ((FType in [evtChallenge,evtKing]) and (GM.GameResult = grNone)) then begin
      GM.AddConnection(Connection);
      Connection.Games.Add(GM);
    end;}

    fSocket.Send(Connection, [DP_MSEC, IntToStr(GM.GameNumber),
      IntToStr(GM.WhiteMSec), IntToStr(GM.BlackMSec)]);

    { Send game result if any }
    if not (GM.GameResult = grNone) then
      fSocket.Send(Connection, [DP_GAME_RESULT, IntToStr(GM.GameNumber),
        RESULTCODES[Ord(GM.GameResult)]]);

    GM.SendGameScore(Connection);

    fSocket.Send(Connection, [DP_SHOW_GAME, IntToStr(GM.GameNumber)]);
  end;
  fSocket.Send(Connection,[DP_EVENT_GAMES_END,IntToStr(Self.ID)]);
  finally
    fSocket.Buffer:=false;
    fSocket.Send(Connection,['']);
  end;
end;
//==========================================================================
procedure TCSEvent.SendGamesBorn(GameNum: integer=-1);
var
  i,j,start,finish,k: integer;
  GM: TGame;
  Move: TMove;
  Connection: TConnection;
begin
  for k:=0 to FUsers.Count-1 do begin
    Connection:=TConnection(FUsers[k]);
    fSocket.Buffer:=true;
    try // fSocket.Buffer := false

    fSocket.Send(Connection,[DP_EVENT_GAMES_BEGIN,IntToStr(Self.ID)],Self);
    if GameNum=-1 then begin
      start:=0; finish:=Games.Count-1;
    end else begin
      start:=GameNum-1; finish:=start;
    end;

    for i:=start to finish do begin
      GM:=TGame(Games[i]);

      fSocket.Send(Connection,
        [DP_GAME_BORN, IntToStr(GM.GameNumber), GM.Site, GM.Event, IntToStr(GM.Round), GM.Date,
         GM.WhiteLogin,GM.WhiteTitle,IntToStr(GM.WhiteRating),
         GM.BlackLogin,GM.BlackTitle,IntToStr(GM.BlackRating),
         IntToStr(GM.WhiteInitialMSec), IntToStr(GM.WhiteIncMSec), IntToStr(Ord(GM.GameMode)), '1',
         IntToStr(Ord(GM.RatedType)), IntToStr(Integer(GM.Rated)), '0',
         IntToStr(GM.EventId), IntToStr(GM.EventOrdNum),
         IntToStr(GM.BlackInitialMSec), IntToStr(GM.BlackIncMSec)],Self);

      fSocket.Send(Connection, [DP_FEN, IntToStr(GM.GameNumber), GM.FEN],Self);

      for j:= 1 to GM.Moves.Count-1 do begin
        Move := GM.Moves[j];
        fSocket.Send(Connection, [DP_MOVE, IntToStr(GM.GameNumber),
          IntToStr(Move.FFrom), IntToStr(Move.FTo),
          IntToStr(Move.FPosition[Move.FTo]),
          IntToStr(Ord(Move.FType)), Move.FPGN],Self);
      end;

      { Send game result if any }
      if not (GM.GameResult = grNone) then
        fSocket.Send(Connection, [DP_GAME_RESULT, IntToStr(GM.GameNumber),
          RESULTCODES[Ord(GM.GameResult)]],Self);

      fSocket.Send(Connection, [DP_MSEC, IntToStr(GM.GameNumber),
        IntToStr(GM.WhiteMSec), IntToStr(GM.BlackMSec)],Self);

      if not GM.Score.Defined then GM.SetGameScore;
      GM.SendGameScore(nil);

      fSocket.Send(Connection, [DP_SHOW_GAME, IntToStr(GM.GameNumber)],Self);
    end;
    fSocket.Send(Connection,[DP_EVENT_GAMES_END,IntToStr(Self.ID)],Self);
    finally
      fSocket.Buffer:=false;
      fSocket.Send(Connection,['']);
    end;
  end;
end;
//==========================================================================
procedure TCSEvent.SendStatistic(Connections: TObjectList);
var
  nLeader,nJoined,nObserver: integer;
begin
  GetUsersStat(nLeader,nJoined,nObserver);
  fSocket.Send(Connections,[DP_EVENT_STATISTIC,
    IntToStr(ID),
    IntToStr(nLeader),IntToStr(nJoined),IntToStr(nObserver),IntToStr(FreeSlots)
    ],Self,AdminTitledOnly);
end;
//==========================================================================
procedure TCSEvent.SetPrimary(Connection: TConnection; OrdNum: integer);
begin
  if (Connection.EventId=ID) and (Connection.EventUserState=eusLeader)
    and (FType = evtSimul)
  then
    LeaderLocation:=OrdNum;
end;
//==========================================================================
procedure TCSEvent.SetLeaderLocation(const Value: integer);
begin
  if FLeaderLocation<>Value then begin
    FLeaderLocation := Value;
    fSocket.Send(Users,[DP_EVENT_LEADER_LOCATION,IntToStr(Self.ID),IntToStr(Value)],Self);
  end;
end;
//==========================================================================
function TCSEvent.IsLeader(Connection: TConnection): Boolean;
var
  i: integer;
  name: string;
begin
  result:=true;
  name:=lowercase(Connection.Handle);
  for i:=0 to FLeaders.Count-1 do
    if lowercase(FLeaders[i])=name then
      exit;
  result:=false;
end;
//==========================================================================
procedure TCSEvent.DefineLeader;
var
  i: integer;
  conn: TConnection;
begin
  if not (FType in [evtSimul,evtChallenge,evtLecture]) then exit;
  for i:=0 to FUsers.Count-1 do begin
    conn:=TConnection(FUsers[i]);
    if conn.EventUserState = eusLeader then begin
      FConnLeader:=conn;
      exit;
    end;
  end;
end;
//==========================================================================
procedure TCSEvent.Start;
begin
  DefineLeader;
  StartGames;
  SendGamesBorn;
  Status:=estStarted;
  fDB.ExecProc('dbo.proc_ev_start',[ID]);
  fSocket.Send(fConnections.Connections,[DP_EVENT_STARTED,IntToStr(ID)],Self);
end;
//==========================================================================
{ TCSEventSimul }
//==========================================================================
procedure TCSEventSimul.CheckEventFinished;
var
  i: integer;
  Game: TGame;
begin
  if Status <> estStarted then exit;
  for i:=0 to Games.Count-1 do begin
    Game:=TGame(Games[i]);
    if (Game<>nil) and (Game.GameResult=grNone) then exit;
  end;
  Status:=estFinished;
  fSocket.Send(fConnections.Connections,[DP_EVENT_FINISHED,IntToStr(ID)],Self);
  SendFinishShout;
end;
//==========================================================================
function TCSEventSimul.FreeSlots: integer;
begin
  if Status = estWaited then result:=MaxGamesCount-Tickets.Count-CountMembersNoTicket
  else result:=0;
end;
//==========================================================================
procedure TCSEventSimul.Params(Connection: TConnection; CMD: TStrings);
var
  n: integer;
begin
  inherited;
  if CMD.Count<3 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    n:=StrToInt(CMD[2]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[2]]);
    exit;
  end;

  FLeaderColor:=TCSLeaderColor(n);
end;
//==========================================================================
procedure TCSEventSimul.StartGames;
var
  i,n,cnt,GameNum: integer;
  conn: TConnection;
  LeaderWhite: Boolean;
  Game: TGame;
  odds: TCSOdds;
begin
  cnt:=CountUsers(eusMember);
  n:=MaxGamesCount;
  GameNum:=1;
  FGames.Clear;
  LeaderWhite:=LeaderColor<>elcBlack;
  for i:=0 to FUsers.Count-1 do begin
    conn:=TConnection(FUsers[i]);
    if conn.EventUserState<>eusMember then continue;
    if Dice(n,cnt) then begin
      NewLeaderGame(i,GameNum,LeaderWhite);
      dec(n);
      inc(GameNum);
      LeaderWhite:=NewLeaderColor(LeaderColor,LeaderWhite);
    end;
    dec(cnt);
    if (cnt=0) or (n=0) then exit;
  end;
end;
//==========================================================================
{ TCSOdds }
//==========================================================================
procedure TCSOddsList.AddOdds(Rating: integer; InitTime: string; IncTime: integer; Pieces: string);
var
  odds: TCSOdds;
begin
  odds:=TCSOdds.Create;
  odds.Rating:=Rating;
  odds.InitTime:=InitTime;
  odds.IncTime:=IncTime;
  odds.Pieces:=Pieces;
  Add(odds);
end;
//==========================================================================
function TCSOddsList.FindOdds(Rating: integer): TCSOdds;
var
  i: integer;
begin
  for i:=0 to Count-1 do begin
    result:=TCSOdds(Items[i]);
    if result.Rating>=Rating then exit;
  end;
  result:=nil;
end;
//==========================================================================
function TCSEvent.GetOneLeaderEvent: Boolean;
begin
  result:=FType in [evtSimul,evtChallenge];
end;
//==========================================================================
{ TCSEventChallenge }
//==========================================================================
procedure TCSEventChallenge.CheckEventFinished;
var
  nMember, nLeader: integer;
begin
  if Status <> estStarted then exit;
  if (Games.Count>=MaxGamesCount) then Status:=estFinished
  else begin
    nMember:=CountUsers(eusMember);
    nLeader:=CountUsers(eusLeader);
    if nMember+nLeader = 0 then Status:=estFinished;
  end;

  if Status = estFinished then begin
    fSocket.Send(fConnections.Connections,[DP_EVENT_FINISHED,IntToStr(ID)],Self);
    SendFinishShout;
  end;
end;
//==========================================================================
function TCSEventChallenge.FreeSlots: integer;
begin
  result:=MaxGamesCount-CountMembersNoTicket-Tickets.Count-Games.Count;
  if result<0 then result:=0;
end;
//==========================================================================
procedure TCSEventChallenge.Join(Connection: TConnection; Mode: string);
begin
  inherited;
  if (Status=estStarted) and (CountActiveGames=0) and (Connection.EventUserState=eusMember) then
    StartNextGame;
end;
//==========================================================================
procedure TCSEventChallenge.OnGameResult(GameOrdNum: integer);
var
  game: TGame;
  conn: TConnection;
begin
  if GameOrdNum<Games.Count then exit;
  if OneGame then begin
    game:=TGame(Games[GameOrdNum-1]);
    if game.White = connLeader then conn:=game.Black
    else conn:=game.White;
    conn.EventUserState:=eusObserver;
    SendUserJoinMessages(conn);
  end;
  StartNextGame;
end;
//==========================================================================
procedure TCSEventChallenge.Params(Connection: TConnection; CMD: TStrings);
var
  n: integer;
begin
  inherited;
  if CMD.Count<4 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    n:=StrToInt(CMD[2]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[2]]);
    exit;
  end;

  FLeaderColor:=TCSLeaderColor(n);
  FOneGame:=CMD[3]='1';
end;
//==========================================================================
procedure TCSEventChallenge.Resume(Connection: TConnection);
begin
  inherited;
  StartNextGame;
end;
//==========================================================================
procedure TCSEventChallenge.StartGames;
begin
  StartNextGame;
end;
//==========================================================================
function TCSEvent.NewLeaderGame(UserNum,GameNum: integer;
  LeaderWhite: Boolean): integer;
var
  Game: TGame;
  odds: TCSOdds;
  conn: TConnection;
begin
  if (UserNum<0) or (UserNum>=Users.Count) then exit;
  Game:=TGame.Create(Self,UserNum,LeaderWhite);
  Game.EventOrdNum:=GameNum;
  conn:=TConnection(Users[UserNum]);

  odds:=OddsList.FindOdds(conn.Rating[RatedType]);
  if odds<>nil then begin
    if LeaderWhite then begin
      if odds.InitTime <> '-1' then begin
        Game.WhiteInitialMSec:=TimeToMSec(odds.InitTime);
        Game.WhiteMSec:=Game.WhiteInitialMSec;
      end;
      if odds.IncTime <> -1 then Game.WhiteIncMSec:=odds.Inctime*1000;
      if odds.Pieces <> '' then Game.FEN:=OddsToFen(odds.Pieces,true);
    end else begin
      if odds.InitTime <> '-1' then begin
        Game.BlackInitialMSec:=TimeToMSec(odds.InitTime);
        Game.BlackMSec:=Game.BlackInitialMSec;
      end;
      if odds.IncTime <> -1 then Game.BlackIncMSec:=odds.Inctime*1000;
      if odds.Pieces <> '' then Game.FEN:=OddsToFen(odds.Pieces,false);
    end;
  end;

  Games.Add(Game);
  CSGames.fGames.Games.Add(Game);
end;
//==========================================================================
procedure TCSEventChallenge.StartNextGame;
var
  i,GameNum: integer;
  conn: TConnection;
  LeaderWhite: Boolean;
  Game: TGame;
begin
  if Paused then exit;

  for i:=0 to FUsers.Count-1 do begin
    conn:=TConnection(FUsers[i]);
    if conn.EventUserState=eusMember then break;
  end;

  if Games.Count=0 then LeaderWhite:=LeaderColor<>elcBlack
  else begin
    Game:=TGame(Games[Games.Count-1]);
    LeaderWhite:=Game.White=connLeader;
    LeaderWhite:=NewLeaderColor(LeaderColor,LeaderWhite);
  end;

  if (conn=nil) or (conn.EventUserState<>eusMember) then exit;
  GameNum:=Games.Count+1;
  //conn.EventUserState:=eusObserver;
  NewLeaderGame(i,GameNum,LeaderWhite);
  SendGamesBorn(GameNum);
  for i:=0 to Users.Count-1 do begin
    conn:=TConnection(Users[i]);
    Game.AddConnection(conn);
    conn.AddGame(Game);
  end;
end;
//==========================================================================
procedure TCSEvent.OnGameResult(GameOrdNum: integer);
begin
  SendStatistic(fConnections.Connections);
  // doing nothing
end;
//==========================================================================
{ TCSEventKing }
//==========================================================================
function TCSEventKing.ChangeKing(UserNum: integer): integer;
begin
  result:=IndexOfUser(connKing);
  connKing:=TConnection(FUsers[UserNum]);
  //MoveUserToTail(KingIndex);
  KingGamesWon:=0;
end;
//==========================================================================
procedure TCSEventKing.CheckEventFinished;
begin
  //
end;
//==========================================================================
procedure TCSEventKing.Join(Connection: TConnection; Mode: string);
begin
  inherited;
  if (connKing=nil) and (Connection.EventUserState=eusMember) then begin
    connKing:=Connection;
    SendKingInfo;
  end else begin
    SendKingInfo(Connection);
    if (Status=estStarted) and (Connection.EventUserState=eusMember) and (Games.Count=0) then
      StartNextGame;
  end;
end;
//==========================================================================
procedure TCSEventKing.OnGameResult(GameOrdNum: integer);
var
  n: integer;
begin
  if GameOrdNum<Games.Count then exit;
  if ToChangeKing then begin
    n:=ChangeKing(PlayingUserNum);
    SendKingInfo;
    MoveUserToTail(n);
  end else begin
    MoveUserToTail(PlayingUserNum);
    inc(KingGamesWon);
    SendKingInfo;
  end;

  StartNextGame;
end;
//==========================================================================
procedure TCSEventKing.Params(Connection: TConnection; CMD: TStrings);
var
  n: integer;
begin
  inherited;
  if CMD.Count<3 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    n:=StrToInt(CMD[2]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number: '+CMD[2]]);
    exit;
  end;

  KingColor:=TCSLeaderColor(n);
end;
//==========================================================================
procedure TCSEventKing.SendKingInfo(Connection: TConnection = nil);
var
  Handle, Title: string;
  Rating: integer;
begin
  if connKing=nil then exit;

  if Connection <> nil then
    MarkSendOnlyOne(fConnections.Connections, Connection);

  fSocket.Send(fConnections.Connections,
    [DP_EVENT_KING, IntToStr(Self.ID),
     connKing.Handle,
     connKing.Title,
     IntToStr(connKing.Rating[RatedType]),
     IntToStr(KingGamesWon)],Self);
end;
//==========================================================================
procedure TCSEventKing.StartGames;
begin
  StartNextGame;
end;
//==========================================================================
procedure TCSEventKing.StartNextGame;
var
  i,GameNum,UserNum: integer;
  conn: TConnection;
  LeaderWhite: Boolean;
  Game,LastGame: TGame;
begin
  if connKing = nil then begin
    conn:=nil;
    for i:=0 to FUsers.Count-1 do begin
      conn:=TConnection(FUsers[i]);
      if (conn.EventUserState=eusMember) then break;
    end;
    if conn = nil then exit;
    ChangeKing(i);
    SendKingInfo;
  end;

  for i:=0 to FUsers.Count-1 do begin
    conn:=TConnection(FUsers[i]);
    if (conn.EventUserState=eusMember) and (conn<>connKing) then break;
  end;
  if (conn=nil) or (conn.EventUserState<>eusMember)
    or (conn=connKing)
  then
    exit;

  UserNum:=i;
  GameNum:=Games.Count+1;
  //conn.EventUserState:=eusObserver;

  if Games.Count=0 then LeaderWhite:=KingColor<>elcBlack
  else begin
    LastGame:=TGame(Games[Games.Count-1]);
    LeaderWhite:=LastGame.White=connKing;
  end;
  LeaderWhite:=NewLeaderColor(LeaderColor,LeaderWhite);

  PlayingUserNum:=UserNum;
  Game:=TGame.Create(Self,UserNum,LeaderWhite);
  Game.EventOrdNum:=GameNum;

  Games.Add(Game);
  CSGames.fGames.Games.Add(Game);
  SendGamesBorn(GameNum);

  for i:=0 to Users.Count-1 do begin
    conn:=TConnection(Users[i]);
    Game.AddConnection(conn);
    conn.AddGame(Game);
  end;
end;
//==========================================================================
procedure TCSEvent.MoveUserToTail(UserNum: integer);
var
  conn: TConnection;
begin
  if (UserNum<0) or (UserNum>=Users.Count) then exit;
  conn:=TConnection(Users[UserNum]);
  {fSocket.Send(Users,
    [DP_EVENT_QUEUE_TAIL,IntToStr(Self.ID),conn.Handle,conn.Title]);}

  FUsers.Move(UserNum,FUsers.Count-1);
  SendFullQueue;
end;
//==========================================================================
function TCSEventKing.ToChangeKing: Boolean;
var
  Game: TGame;
  score: TGameScore;
  WhiteWin: Boolean;
begin
  Game:=TGame(Games[Games.Count-1]);
  score:=GameScoreByResult(Game.GameResult);

  if (score=gsNone) and (Game.GameResult=grAborted) then
    if Game.MoveNumber mod 2 = 0 then score:=gsBlackWin
    else score:=gsWhiteWin;

  if score=gsNone then result:=false
  else
    result:=(Game.White=connKing) and (score=gsBlackWin)
      or (Game.Black=connKing) and (score in [gsWhiteWin,gsDraw]);
end;
//==========================================================================
procedure TCSEvent.Params(Connection: TConnection; CMD: TStrings);
begin
  // this is additional parameters
  // nothing to do in the basic event class
end;
//==========================================================================
function TCSEvent.UserGameExists(Name: string): Boolean;
var
  i: integer;
  Game: TGame;
begin
  result:=true;
  for i:=0 to Games.Count-1 do begin
    Game:=TGame(Games[i]);
    if (Game.WhiteLogin=Name) or (Game.BlackLogin=Name) then
      exit;
  end;
  result:=false;
end;
//==========================================================================
procedure TCSEvent.Pause(Connection: TConnection);
var
  s: string;
begin
  if Paused then exit;

  if not CanBePaused then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,'This event type cannot be paused']);
    exit;
  end;

  if (Connection<>connLeader) and (Connection.AdminLevel=alNone) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,'Only leader or admin can pause the event']);
    exit;
  end;

  FPaused:=true;
  if Connection=connLeader then s:='Leader'
  else s:='Admin';
  fSocket.Send(Users,[DP_SERVER_MSG,DP_ERR_0,s+' set pause after current game'],Self);
end;
//==========================================================================
procedure TCSEvent.Resume(Connection: TConnection);
var
  s: string;
begin
  if not Paused then exit;

  if (Connection<>connLeader) and (Connection.AdminLevel=alNone)  then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,'Only leader or admin can resume the event']);
    exit;
  end;
  FPaused:=false;
  if Connection=connLeader then s:='Leader'
  else s:='Admin';
  fSocket.Send(Users,[DP_SERVER_MSG,DP_ERR_0,s+' resumes event'],Self);
end;
//==========================================================================
function TCSEvent.GetCanBePaused: Boolean;
begin
  result:=Type_ in [evtChallenge,evtTournament];
end;
//==========================================================================
procedure TCSEvent.OnTimer;
var
  s,s1,s2,msg,sDesc: string;
  i,rest,nFree: integer;
  conn: TConnection;
begin
  if (ShoutStart<>-1) and (Now>StartTime-ShoutStart/1440) and (Now-ShoutInc/1440>FLastShout) and (Now<StartTime)
    and (Status=estWaited)
  then begin
    nFree:=FreeSlots;
    rest:=trunc((StartTime-Now)*1440);
    if Type_ = evtTournament then s1:='member'
    else s1:='join';

    s2:=Format('Click "/event_%s %d" or "/event_observe %d" for join or observe.',[s1,Self.ID,Self.ID]);

    if Description='' then sDesc:='The event '+Name
    else sDesc:=Description;

    for i:=0 to fConnections.Connections.Count-1 do begin
      conn:=TConnection(fConnections.Connections[i]);
      if (conn.EventUserState = eusMember) then s:=''
      else begin
        if Tickets.HaveTicket(conn.Handle) then
          s:='You are invited to join this event. '+s2
        else if nFree=0 then s:=Format('Click "/event_observe %d" for observe.',[Self.ID])
        else begin
          s:=s2;
          if nFree<>-1 then s:=s+' There are '+IntToStr(nFree)+' slots for join.';
        end;
      end;

      if ShoutMsg='' then Msg:=Format('%s will be started in %d minutes.',[sDesc,rest])
      else Msg:=ReplaceSubstr(ShoutMsg,'%rest%',IntToStr(rest));

      Msg:=Msg+' '+s;

      fSocket.Send(conn,[DP_SHOUT,'Server','',Msg],Self);
    end;
    FLastShout:=Now;
  end;

  if (Now>StartTime) and (Status=estWaited) and FAutoStart then
    Start;
end;
//==========================================================================
function TCSEvent.TestTimeLimit: Boolean;
begin
  result:=(TimeLimit=-1) or (Now>StartTime-TimeLimit/1440);
end;
//==========================================================================
function TCSEvent.CountActiveGames: integer;
var
  i: integer;
  Game: TGame;
begin
  result:=0;
  for i:=0 to Games.Count-1 do begin
    Game:=TGame(Games[i]);
    if Game.GameResult=grNone then
      inc(result);
  end;
end;
//==========================================================================
procedure TCSEvent.SetMainParams(
  p_Creator,p_Name: string;
  p_Type_: TCSEventType;
  p_StartTime: TDateTime;
  p_Leaders,p_Description: string;
  p_MinRating,p_MaxRating,p_Id,p_MaxGamesCount: integer;
  p_InitialTime: string;
  p_IncTime,p_TimeLimit: integer;
  p_ShoutStart,p_ShoutInc: integer;
  p_RatedType: TRatedType;
  p_Room: TRoom;
  p_Provisional,p_Rated,p_AdminTitledOnly,p_AutoStart: Boolean;
  p_Reserv,p_ClubList: string;
  p_LagRestriction,p_ShoutEveryRound: Boolean);
begin
  FCreator:=p_Creator;
  FName:=p_Name;
  FType:=p_Type_;
  FStartTime:=p_StartTime;

  if p_Leaders='-' then FLeaders.Clear
  else FLeaders.CommaText:=p_Leaders;

  FDescription:=p_Description;
  FMinRating:=p_MinRating;
  FMaxRating:=p_MaxRating;
  FId:=p_Id;
  FMaxGamesCount:=p_MaxGamesCount;
  FInitialTime:=p_InitialTime;
  FIncTime:=p_IncTime;
  if p_RatedType=rtStandard then
    FRatedType:=TimeToRatedType(FInitialTime,FIncTime)
  else
    FRatedType:=p_RatedType;
  FTimeLimit:=p_TimeLimit;
  FShoutStart:=p_ShoutStart;
  FShoutInc:=p_ShoutInc;
  FRoom:=p_Room;
  FProvisionalAllowed:=p_Provisional;
  FRated:=p_Rated;
  FAdminTitledOnly:=p_AdminTitledOnly;
  FAutoStart:=p_AutoStart;

  FReserv.CommaText:=lowercase(p_Reserv);
  FClubList:=p_ClubList;
  FLagRestriction:=p_LagRestriction;
  FShoutEveryRound:=p_ShoutEveryRound;

  SetDefaultMinMaxPeople;
end;
//==========================================================================
procedure TCSEvent.Abandon(Connection: TConnection);
begin
  //
end;
//==========================================================================
function TCSEvent.Member(Connection: TConnection): Boolean;
begin
  result:=false;
end;
//==========================================================================
procedure TCSEvent.SendFullQueue(Connection: TConnection);
var
  conn: TConnection;
  i: integer;
begin
  if not (Type_ in [evtChallenge,evtKing]) then exit;

  if Connection <> nil then
    MarkSendOnlyOne(fConnections.Connections, Connection);

  fSocket.Send(fConnections.Connections,[DP_EVENT_QUEUE_CLEAR, IntToStr(Self.ID)],Self);

  for i:=0 to Users.Count-1 do begin
    conn:=TConnection(Users[i]);
    if conn.EventUserState=eusMember then
      fSocket.Send(fConnections.Connections,[DP_EVENT_QUEUE_ADD, IntToStr(Self.ID),
        conn.Handle,conn.Title,IntToStr(conn.Rating[Self.RatedType])],Self);
  end;
end;
//==========================================================================
function TCSEvent.FindJoinedUser(Login: string): TConnection;
var
  i: integer;
begin
  for i:=0 to Users.Count-1 do begin
    result:=TConnection(Users[i]);
    if (result.Handle=Login) and (result.EventUserState=eusMember) then
      exit;
  end;
  result:=nil;
end;
//==========================================================================
procedure TCSEvent.Forfeit(Connection: TConnection; Login: string);
begin
  //
end;
//==========================================================================
procedure TCSEvent.SetDefaultMinMaxPeople;
begin
  if FType=evtSimul then FMinPeople:=3
  else FMinPeople:=1;
  FMaxPeople:=10000;
end;
//==========================================================================
function TCSEvent.CountCurrentGames: integer;
var
  i: integer;
  game: TGame;
begin
  result:=0;
  for i:=0 to Games.Count-1 do begin
    game:=TGame(Games[i]);
    if not Assigned(game) then continue; if (game<>nil) and (game.GameResult=grNone) then
      inc(result);
  end;
end;
//==========================================================================
procedure TCSEvent.AbortAllGames;
var
  i: integer;
  game: TGame;
  msg: string;
begin
  msg:='You game number %d is aborted because of event is deleted by admin';
  for i:=0 to Games.Count-1 do begin
    game:=TGame(Games[i]);
    if game.GameResult=grNone then begin
      fSocket.Send(game.White,[DP_SERVER_MSG,DP_ERR_0,Format(msg,[game.GameNumber])]);
      fSocket.Send(game.Black,[DP_SERVER_MSG,DP_ERR_0,Format(msg,[game.GameNumber])]);
      game.GameResult:=grAborted;
      game.OnResult(game);
    end;
  end;
end;
//==========================================================================
function TCSEvent.AllLeadersHere: Boolean;
var
  i,n: integer;
  conn: TConnection;
begin
  n:=FLeaders.Count;
  result:=true;
  for i:=0 to Users.Count-1 do begin
    conn:=TConnection(Users[i]);
    if (conn.EventUserState=eusLeader) then dec(n);
    if n=0 then exit;
  end;
  result:=false;
end;
//==========================================================================
function TCSEvent.IndexOfUser(Connection: TConnection): integer;
var
  i: integer;
  conn: TConnection;
begin
  result:=-1;
  if Connection=nil then exit;

  for i:=0 to Users.Count-1 do begin
    conn:=TConnection(Users[i]);
    if conn=Connection then begin
      result:=i;
      exit;
    end;
  end;
end;
//==========================================================================
procedure TCSEvent.AbortGame(Connection: TConnection);
var
  game: TGame;
begin
  if not (Type_ in [evtKing,evtChallenge]) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,'Game cannot be aborted in this type of event']);
    exit;
  end;

  if Games.Count = 0 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,'There are no games to abort']);
    exit;
  end;

  game:=Games[Games.Count-1];
  if game.GameResult<>grNone then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,'There are no games to abort']);
    exit;
  end;

  game.GameResult:=grAborted;
  game.OnResult(game);
end;
//==========================================================================
function TCSEvent.FreeSlots: integer;
begin
  result:=-1;
end;
//==========================================================================
function TCSEvent.InitTimeSeconds: Boolean;
var
  i: integer;
  odd: TCSOdds;
begin
  result:=true;
  if pos('.',InitialTime)>0 then exit;
  for i:=0 to OddsList.Count-1 do begin
    odd:=TCSOdds(OddsList[i]);
    if pos('.',odd.InitTime)>0 then exit;
  end;
  result:=false;
end;
//==========================================================================
function TCSEvent.UserCanJoin(Connection: TConnection; var pp_ErrMsg: string): Boolean;
begin
  result:=true;
  pp_ErrMsg:='';
end;
//==========================================================================
procedure TCSEventKing.UserLeave(Connection: TConnection);
begin
  inherited;
  if Connection = connKing then
    connKing:=nil;
end;
//==========================================================================
procedure TCSEvent.RestoreGames(Connection: TConnection);
var
  i: integer;
  Game: TGame;
begin
  SendStatistic(fConnections.Connections);
  {if (Connection.EventUserState=eusMember) then SendFullQueue
  else SendFullQueue(Connection);}
  SendUserJoinMessages(Connection);
  SendGameBornObserver(Connection);
  if type_ = evtLecture then
    for i:=0 to Games.Count do begin
      Game:=TGame(Games[i]);
      if (Game.White <> Connection) and (lowercase(Game.WhiteLogin) = lowercase(Connection.Handle)) then
        Game.White := Connection;
      if (Game.Black <> Connection) and (lowercase(Game.BlackLogin) = lowercase(Connection.Handle)) then
        Game.Black := Connection;
    end;
end;
//==========================================================================
procedure TCSEvent.SendFinishShout;
var
  Leader, WinList, Txt: string;
  game: TGame;
  i, nWin, nLost, nDraw: integer;
begin
  if (Leaders.Count = 0) or (Leaders.Count > 1) then exit;
  Leader:=Leaders[0];

{  TGameResult = (grNone, grAborted, grAdjourned, grDraw,
    grWhiteResigns, grBlackResigns, grWhiteCheckMated, grBlackCheckMated,
    grWhiteStaleMated, grBlackStaleMated,
    grWhiteForfeitsOnTime, grBlackForfeitsOnTime,
    grWhiteForfeitsOnNetwork, grBlackForfeitsOnNetwork);}


  nWin:=0; nLost:=0; nDraw:=0;
  WinList:='';

  for i:=0 to Games.Count-1 do begin
    Game:=TGame(Games[i]);
    if Game.GameResult  in [grAborted, grAdjourned, grNone] then continue;
    if Game.GameResult in [grDraw, grWhiteStaleMated, grBlackStaleMated] then inc(nDraw)
    else if Game.GameResult in [grWhiteResigns, grWhiteCheckMated, grWhiteForfeitsOnTime, grWhiteForfeitsOnNetwork] then begin
      if lowercase(Game.BlackLogin) = lowercase(Leader) then inc(nWin)
      else begin
        inc(nLost);
        WinList:=WinList+Game.BlackLogin+', ';
      end;
    end else begin
      if lowercase(Game.WhiteLogin) = lowercase(Leader) then inc(nWin)
      else begin
        inc(nLost);
        WinList:=WinList+Game.WhiteLogin+', ';
      end;
    end;
  end;

  if WinList <> '' then
    SetLength(WinList, length(WinList)-2);

  Txt:='InfiniaChess thanks %s for the excellent %s!'+#13#10+
       'The Final Score is: %d wins, %d loses, %d draws.';
  if nLost>0 then
    Txt:=Txt+#13#10+
       'Also InfiniaChess congratulates winners of event: %s'
  else
    Txt:=Txt+'%s';

  Txt:=Format(Txt,[Leader, Self.Name, nWin, nLost, nDraw, WinList]);
  ShoutMultiLine(Txt,Self);
end;
//==========================================================================
function TCSEvent.GameOfUser(Login: string): TObject;
var
  i: integer;
  GM: TGame;
begin
  result:=nil;
  for i:=0 to Games.Count-1 do begin
    GM:=TGame(Games[i]);
    if (lowercase(GM.WhiteLogin) = lowercase(Login)) or
       (lowercase(GM.BlackLogin) = lowercase(Login))
    then begin
      result:=GM;
      exit;
    end;
  end;
end;
//==========================================================================
procedure TCSEvent.ReviveGames(Connection: TConnection);
var
  i: integer;
  GM: TGame;
begin
  for i:=0 to Games.Count-1 do begin
    GM:=TGame(Games[i]);
    if (not Assigned(GM.White)) and (lowercase(GM.WhiteLogin) = lowercase(Connection.Handle)) then begin
      GM.White := Connection;
      Connection.Games.Add(GM);
    end else if (not Assigned(GM.Black)) and (lowercase(GM.WhiteLogin) = lowercase(Connection.Handle)) then begin
      GM.Black := Connection;
      Connection.Games.Add(GM);
    end;
  end;
end;
//==========================================================================
function TCSEvent.CanSend(Connection: TConnection): Boolean;
begin
  result:=pos(','+IntToStr(Connection.ClubId)+',',
    ','+ClubLIst+',')>0;
end;
//==========================================================================
{ TEventTickets }

procedure TEventTickets.AddTicket(Login, Title: string; Rating: integer);
var
  t: TEventTicket;
begin
  t:=TEventTicket.Create;
  t.Login := Login;
  t.Title := Title;
  t.Rating := Rating;
  Add(t);
end;
//==========================================================================
function TEventTickets.GetTicket(Index: integer): TEventTicket;
begin
  result:=TEventTicket(Items[Index]);
end;
//==========================================================================
procedure TCSEvent.SendTicketsInfo(Connections: TObjectList);
var
  i: integer;
  ticket: TEventTicket;
begin
  fSocket.Send(Connections,[DP_EVENT_TICKETS_BEGIN,IntToStr(Self.ID)],Self);
  for i:=0 to Tickets.Count-1 do begin
    ticket:=Tickets[i];
    fSocket.Send(Connections,[DP_EVENT_TICKET,IntToStr(Self.ID),ticket.Login,ticket.Title,IntToStr(ticket.Rating)],Self);
  end;
  fSocket.Send(Connections,[DP_EVENT_TICKETS_END,IntToStr(Self.ID)],Self);
end;
//==========================================================================
function TEventTickets.HaveTicket(Login: string): Boolean;
var
  i: integer;
begin
  result:=true;
  for i:=0 to Count-1 do
    if lowercase(Ticket[i].Login) = lowercase(Login) then
      exit;
  result:=false;
end;
//==========================================================================
function TCSEvent.CountMembersNoTicket: integer;
var
  i: integer;
  conn: TConnection;
begin
  result:=0;
  for i:=0 to FUsers.Count-1 do begin
    conn:=TConnection(FUsers[i]);
    if (conn.EventUserState = eusMember) and not Tickets.HaveTicket(conn.Handle) then
      inc(result);
  end;
end;
//==========================================================================
procedure TCSEvent.SendGameMoves(Connection: TConnection; Game: TObject);
var
  j: integer;
  GM: TGame;
  Move: TMove;
begin
  GM:=TGame(Game);
  if (type_ <> evtLecture) and GM.Involved(Connection) then exit;
  fSocket.Send(Connection, [DP_MOVE_BEGIN, IntToStr(GM.GameNumber),IntToStr(GM.Moves.Count)]);
  fSocket.Send(Connection, [DP_FEN, IntToStr(GM.GameNumber), GM.FEN]);
  for j:= 1 to GM.Moves.Count-1 do begin
    Move := GM.Moves[j];
    fSocket.Send(Connection, [DP_MOVE, IntToStr(GM.GameNumber),
      IntToStr(Move.FFrom), IntToStr(Move.FTo),
      IntToStr(Move.FPosition[Move.FTo]),
      IntToStr(Ord(Move.FType)), Move.FPGN]);
  end;
  fSocket.Send(Connection, [DP_MOVE_END, IntToStr(GM.GameNumber)]);
  GM.AddConnection(Connection);
end;
//==========================================================================
procedure TCSEvent.SetStatus(const Value: TCSEventStatus);
begin
  if (FStatus<>estFinished) and (Value=estFinished) then
    SaveFinishedToDB;
  FStatus := Value;
end;
//==========================================================================
procedure TCSEvent.SaveFinishedToDB;
var
  i: integer;
  GM: TGame;
begin
  fDB.ExecProc('dbo.proc_ev_finish',[ID]);
  for i:=0 to Games.Count-1 do begin
    GM:=TGame(Games[i]);
    fDB.ExecProc('dbo.proc_ev_game_links',
      [GM.DBGameId,Self.ID,null]);
  end;
end;
//==========================================================================
procedure TCSEvent.Finish;
begin
  // nothing to do in base event class
end;
//==========================================================================
end.

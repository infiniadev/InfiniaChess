unit CLEvents;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ComCtrls, ExtCtrls, Menus, CLGame, contnrs, CLLib;

type
  //--------------------------------------------------------------------------
  TCSEventUserState = (eusNone,eusLeader,eusMember,eusObserver);
  //--------------------------------------------------------------------------
  TCLLogin = class(TObject)
    FFilter: Integer;
    FLoginID: Integer;
    FLogin: string;
    FTitle: string;
    FRatingString: string;
    FProvString: string;
    FEventState: TCSEventUserState;
    FImageIndex: integer;
    FAdminLevel: integer;
    FMaster: Boolean;
    FCreated: TDateTime;
    FMembershipType: TMembershipType;
  end;
  //--------------------------------------------------------------------------
  TCSEventType = (evtSimul,evtChallenge,evtKing,evtTournament,evtLecture);
  //--------------------------------------------------------------------------
  TCSEventTypes = set of TCSEventType;
  //--------------------------------------------------------------------------
  TCSEventStatus = (estWaited,estStarted,estFinished);
  //--------------------------------------------------------------------------
  TCSEventGameStatus = (egsNone,egsLeaderMove,egsPlayerMove,egsLeaderWin,egsLeaderLost,egsDraw,egsAborted,egsNotDefined);
  //--------------------------------------------------------------------------
  TCSEventSwitchMode = (eswOrder,eswTime,eswMoves,eswNone);
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
  TCSOddsList = class(TList)
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
  end;
  //--------------------------------------------------------------------------
  TCSEvent = class(TObject)
    private
      FId: integer;
      FName: string;
      FType: TCSEventType;
      FStartTime: TDateTime;
      FLeaders: TStringList;
      FDescription: string;
      FState: TCSEventUserState;
      FStatus: TCSEventStatus;
      FIAmLeader: Boolean;
      FMinRating: integer;
      FMaxRating: integer;
      FCountLeader: integer;
      FCountObserver: integer;
      FCountJoined: integer;
      FOdds: TCSOddsList;
      FInitialTime: string;
      FIncTime: integer;
      FMaxGamesCount: integer;
      FActiveGameNum: integer;
      FLeaderLocation: integer;
      FSwitchMode: TCSEventSwitchMode;
      FRoomNumber: integer;
      FRatedType: TRatedType;
      FRated: Boolean;
      FProvisionalAllowed: Boolean;
      FAdminTitledOnly: Boolean;
      FOneGame: Boolean;
      FTimeLimit: integer;
      FMaxPeople: integer;
      FShoutInc: integer;
      FMinPeople: integer;
      FShoutStart: integer;
      FShoutMsg: string;
      FLeaderColor: TCSLeaderColor;
      FAutoStart: Boolean;
      FReserv: string;
      FCongrMsg: string;
      FFreeGameSlots: integer;
      FGamesTransferring: Boolean;
      FClubList: string;
      function GetStatusStr: string;
      function GetLeaderName: string;
      function GetOneLeaderEvent: Boolean;
      procedure SetActiveGameNum(const Value: integer);
      procedure SetLeaderLocation(const Value: integer);
      function GetActiveGame: TCLGame;
      procedure MoveUserToTail(name,title: string);
    public
      Games: TList;
      LoginList: TObjectList;
      Tickets: TEventTickets;
      property LeaderLocation: integer read FLeaderLocation write SetLeaderLocation;
      property MaxGamesCount: integer read FMaxGamesCount write FMaxGamesCount;
      property InitialTime: string read FInitialTime write FInitialTime;
      property IncTime: integer read FIncTime write FIncTime;
      property ActiveGameNum: integer read FActiveGameNum write SetActiveGameNum;
      property ID: integer read FId write FId;
      property Name: string read FName write FName;
      property Type_: TCSEventType read FType write FType;
      property StartTime: TDateTime read FStartTime write FStartTime;
      property Leaders: TStringList read FLeaders;
      property Description: string read FDescription write FDescription;
      property State: TCSEventUserState read FState write FState;
      property Status: TCSEventStatus read FStatus write FStatus;
      property StatusStr: string read GetStatusStr;
      property IAmLeader: Boolean read FIAmLeader;
      property MinRating: integer read FMinRating write FMinRating;
      property SwitchMode: TCSEventSwitchMode read FSwitchMode write FSwitchMode;
      property MaxRating: integer read FMaxRating write FMaxRating;
      property CountLeader: integer read FCountLeader write FCountLeader;
      property CountJoined: integer read FCountJoined write FCountJoined;
      property CountObserver: integer read FCountObserver write FCountObserver;
      property Odds: TCSOddsList read FOdds write FOdds;
      property LeaderName: string read GetLeaderName;
      property OneLeaderEvent: Boolean read GetOneLeaderEvent;
      property ActiveGame: TCLGame read GetActiveGame;
      property RatedType: TRatedType read FRatedType write FRatedType;
      property RoomNumber: integer read FRoomNumber write FRoomNumber;
      property TimeLimit: integer read FTimeLimit write FTimeLimit;
      property Rated: Boolean read FRated write FRated;
      property LeaderColor: TCSLeaderColor read FLeaderColor write FLeaderColor;
      property ProvisionalAllowed: Boolean read FProvisionalAllowed write FProvisionalAllowed;
      property AdminTitledOnly: Boolean read FAdminTitledOnly write FAdminTitledOnly;
      property OneGame: Boolean read FOneGame write FOneGame;
      property MinPeople: integer read FMinPeople write FMinPeople;
      property MaxPeople: integer read FMaxPeople write FMaxPeople;
      property ShoutStart: integer read FShoutStart write FShoutStart;
      property ShoutInc: integer read FShoutInc write FShoutInc;
      property ShoutMsg: string read FShoutMsg write FShoutMsg;
      property AutoStart: Boolean read FAutoStart write FAutoStart;
      property CongrMsg: string read FCongrMsg write FCongrMsg;
      property Reserv: string read FReserv write FReserv;
      property GamesTransferring: Boolean read FGamesTransferring write FGamesTransferring;
      property ClubList: string read FClubList write FClubList;

      procedure SetCurrentGameFilter;
      procedure Leave; { DONE : Сделать расписание уже и чтобы подчеркивались начатые игры }
      function GameStatus(Game: TCLGame): TCSEventGameStatus; overload; virtual;
      function GameStatus(Num: integer): TCSEventGameStatus; overload; virtual;
      procedure GetScore(var Win,Draw,Lost,Progress: integer); virtual;
      function FindCLLogin(LoginID: integer): integer; overload;
      function FindCLLogin(Name: string): integer; overload;
      function UserIsJoined(Name: string): Boolean;
      procedure AddGame(GM: TCLGame);
      procedure GetPlayerAttributes(Game: TCLGame; var Name,Title,Rating: string);
      //function FreeGameSlots: integer; virtual;
      procedure QueueClear; virtual;
      procedure QueueAdd(name,title: string; rating: integer); virtual;
      function  FindGameByNum(Num: integer): TCLGame;
      function  FindGameByGameNumber(GameNum: integer): TCLGame;
      function  MyCurrentGame: TCLGame;

      procedure OnDoTurn(Game: TCLGame); virtual; abstract;
      procedure OnGameBorn(Game: TCLGame); virtual; abstract;
      procedure OnShowGame(Game: TCLGame); virtual;
      procedure OnGameResult(Game: TCLGame); virtual; abstract;
      procedure OnLeaderLocation(GameNum: integer); virtual; abstract;
      procedure OnObserver(
        const LoginID: Integer;
        const LoginName,Title,RatingString: string;
        UserState: TCSEventUserState); virtual;
      procedure OnUnobserver(LoginID: integer); virtual;
      procedure OnMember(Name,Title: string; Rating: integer); virtual;
      procedure OnMemberStart; virtual;
      procedure OnMemberEnd; virtual;
      procedure OnAbandon(Name: string); virtual;
      function UserIsLoggedIn(Name: string): Boolean;
      property FreeGameSlots: integer read FFreeGameSlots write FFreeGameSlots;

      constructor Create; virtual;
      destructor Destroy; virtual;
  end;
  //--------------------------------------------------------------------------
  TCSEventSimul = class(TCSEvent)
    private
    public
      function LeaderTime(Num: integer): integer;
      //function FreeGameSlots: integer; override;
      function MovesCount(Num: integer): integer;
      function GetLeaderGameLessTime: integer;
      function GetLeaderGameLessMoves: integer;
      function GetLeaderGameNextOrder: integer;
      function GetNextCurrentGame(Num: integer): integer;
      procedure OnDoTurn(Game: TCLGame); override;
      procedure OnGameBorn(Game: TCLGame); override;
      procedure OnGameResult(Game: TCLGame); override;
      procedure OnLeaderLocation(Location: integer); override;
  end;
  //--------------------------------------------------------------------------
  TCSEventChallenge = class(TCSEvent)
    private
    public
      //function FreeGameSlots: integer; override;
      procedure OnDoTurn(Game: TCLGame); override;
      procedure OnGameBorn(Game: TCLGame); override;
      procedure OnGameResult(Game: TCLGame); override;
      procedure OnLeaderLocation(GameNum: integer); override;
      procedure OnObserver(
        const LoginID: Integer;
        const LoginName,Title,RatingString: string;
        UserState: TCSEventUserState); override;
      procedure OnUnobserver(LoginID: integer); override;
  end;
  //--------------------------------------------------------------------------
  TCSEventMatch = class(TCSEvent)
    private
    public
  end;
  //--------------------------------------------------------------------------
  TCSEventKing = class(TCSEvent)
    private
    public
      KingName: string;
      KingTitle: string;
      KingRating: integer;
      KingGamesWon: integer;
      PlayerName: string;
      procedure OnDoTurn(Game: TCLGame); override;
      procedure OnGameBorn(Game: TCLGame); override;
      procedure OnGameResult(Game: TCLGame); override;
      procedure OnLeaderLocation(GameNum: integer); override;
      function KingRank: string;
      procedure KingInfo(name,title: string; rating,GamesWon: integer);
  end;
  //--------------------------------------------------------------------------
  TfCLEvents = class(TForm)
    bvlHeader: TBevel;
    lvEvents: TListView;
    lblNotify: TLabel;
    sbMax: TSpeedButton;
    pmEvents: TPopupMenu;
    miJoin: TMenuItem;
    miObserve: TMenuItem;
    miStart: TMenuItem;
    miDelete: TMenuItem;
    pnlInfo: TPanel;
    lblDescription: TLabel;
    pnlCommon: TPanel;
    lblNum: TLabel;
    lblTitle: TLabel;
    lblType: TLabel;
    lblLeaderCaption: TLabel;
    lblLeaders: TLabel;
    Label2: TLabel;
    lblRating: TLabel;
    lblStartTime: TLabel;
    Label3: TLabel;
    lblJoined: TLabel;
    Label4: TLabel;
    lblObserver: TLabel;
    pnlSimul: TPanel;
    Label5: TLabel;
    lblTimeControl: TLabel;
    Label7: TLabel;
    lblCurrentGames: TLabel;
    Label8: TLabel;
    lblFreeGameSlots: TLabel;
    Label9: TLabel;
    lblMaxGames: TLabel;
    Label11: TLabel;
    lblWins: TLabel;
    Label12: TLabel;
    lblLost: TLabel;
    Label14: TLabel;
    lblDraw: TLabel;
    pnlTournament: TPanel;
    miLeave: TMenuItem;
    miTakePart: TMenuItem;
    miAbandon: TMenuItem;
    pnlOdds: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    lblTourType: TLabel;
    lblToursCaption: TLabel;
    lblENumber: TLabel;
    miAbort: TMenuItem;
    miEdit: TMenuItem;
    lblTourFreeCaption: TLabel;
    lblTourFree: TLabel;
    Label13: TLabel;
    lblTourInvited: TLabel;
    miInvitedList: TMenuItem;
    procedure sbMaxClick(Sender: TObject);
    procedure lvEventsDblClick(Sender: TObject);
    procedure miJoinClick(Sender: TObject);
    procedure miStartClick(Sender: TObject);
    procedure miObserveClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure lvEventsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure miLeaveClick(Sender: TObject);
    procedure miTakePartClick(Sender: TObject);
    procedure miAbandonClick(Sender: TObject);
    procedure pmEventsPopup(Sender: TObject);
    procedure miAbortClick(Sender: TObject);
    procedure miEditClick(Sender: TObject);
    procedure miInvitedListClick(Sender: TObject);
  private
    { Private declarations }
    OldX,OldY: integer;
    procedure DisplayInfo(EV: TCSEvent);
    procedure DisplayOddsInfo(ev: TCSEvent);
  public
    { Public declarations }
    function UpdateEvent(EV: TCSEvent): integer;
    function FindEventIndex(id: integer): integer;
    function FindEvent(id: integer): TCSEvent;
    procedure CMD_EventCreate(CMD: TStrings);
    procedure CMD_EventJoined(CMD: TStrings);
    procedure CMD_EventMember(CMD: TStrings);
    procedure CMD_EventAbandon(CMD: TStrings);
    procedure CMD_EventStarted(CMD: TStrings);
    procedure CMD_EventLeaderLocation(CMD: TStrings);
    procedure CMD_EventDeleted(CMD: TStrings);
    procedure CMD_EventFinished(CMD: TStrings);
    procedure CMD_EventStatistic(CMD: TStrings);
    procedure CMD_EventOddsAdd(CMD: TStrings);
    procedure CMD_EventQueueTail(CMD: TStrings);
    procedure CMD_EventKing(CMD: TStrings);
    procedure CMD_EventLeft(CMD: TStrings);
    procedure CMD_EventQueueClear(CMD: TStrings);
    procedure CMD_EventQueueAdd(CMD: TStrings);
    procedure CMD_EventMembersStart(CMD: TStrings);
    procedure CMD_EventMembersEnd(CMD: TStrings);
    procedure CMD_EventReglament(CMD: TStrings);
    procedure CMD_EventReglGamesStart(CMD: TStrings);
    procedure CMD_EventReglGameAdd(CMD: TStrings);
    procedure CMD_EventReglGamesEnd(CMD: TStrings);
    procedure CMD_EventReglGameUpdate(CMD: TStrings);
    procedure CMD_EventAcceptRequest(CMD: TStrings);
    procedure CMD_EventGamesBegin(CMD: TStrings);
    procedure CMD_EventGamesEnd(CMD: TStrings);
    procedure CMD_EventTicketsBegin(CMD: TStrings);
    procedure CMD_EventTicket(CMD: TStrings);
    procedure CMD_EventTicketsEnd(CMD: TStrings);
    procedure OnDoTurn(Game: TCLGame);
    procedure OnGameBorn(Game: TCLGame);
    procedure OnGameResult(Game: TCLGame);
    procedure OnObserver(
      ID,LoginId: integer;
      Login,Title,RatingString: string;
      EventUserState: TCSEventUserState);
    procedure OnUnobserver(ID,LoginID: integer);
    procedure OnShowGame(Game: TCLGame);
    procedure Clear;
    //procedure AdjustGameResult(Game: TCLGame);
  end;

  function EventType2Str(evt: TCSEventType): string;

var
  fCLEvents: TfCLEvents;

  ETLeader: TCSEventTypes = [evtSimul,evtChallenge];
  ETOdds: TCSEventTypes = [evtSimul, evtChallenge];
  ETMaxGames: TCSEventTypes = [evtSimul, evtChallenge];
  ETQueue: TCSEventTypes = [evtChallenge,evtKing];
  ETFinished: TCSEventTypes = [evtChallenge,evtKing];
  ETPause: TCSEventTypes = [evtChallenge,evtTournament];
  ETNoRated: TCSEventTypes = [evtSimul];
  ETAborted: TCSEventTypes = [evtKing,evtChallenge];

implementation

uses CLMain,CLCLS,CLSocket,CLConst,CLTerminal,CLConsole,CLTournament,
     CLEventControl,CLFilterManager, CLBoard, CLGlobal, CSReglament,
     CLEventNew,CLEventTickets, CLLecture, CLLectures, CLNavigate;

{$R *.DFM}
var
  TOURTYPE_STRINGS: array[0..3] of string = ('Round Robin','Elimination','Swiss System','Match');
//==========================================================================
procedure TfCLEvents.CMD_EventCreate(CMD: TStrings);
var
  EV: TCSEvent;
  sName,sType,sDesc,sLeaders,sDateTime,ShoutMsg,InitialTime: string;
  status: TCSEventStatus;
  dt: TDateTime;
  type_: TCSEventType;
  RatedType: TRatedType;
  LeaderColor: TCSLeaderColor;
  Rated,ProvisionalAllowed,AdminTitledOnly,OneGame,AutoStart: Boolean;
  i,id, MaxGamesCount, IncTime, nMinRating, nMaxRating, RoomNumber: integer;
  TimeLimit,MinPeople,MaxPeople,ShoutStart,ShoutInc: integer;
  sReserv,sCongrMsg,sClubList: string;
begin
  id:=StrToInt(CMD[1]);
  sName:=CMD[2];
  sType:=lowercase(CMD[3]);
  if (sType='simul') or (sType='s') then type_:=evtSimul
  else if (sType='challenge') or (sType='c') then type_:=evtChallenge
  else if (sType='king') or (sType='k') then type_:=evtKing
  else if (sType='tournament') or (sType='t') then type_:=evtTournament
  else if (sType='lecture') or (sType='l') then type_:=evtLecture
  else exit;

  sDateTime:=CMD[4];
  dt:=Str2Float(sDateTime);

  sLeaders:=lowercase(CMD[5]);
  sDesc:=CMD[6];

  nMinRating:=StrToInt(CMD[7]);
  nMaxRating:=StrToInt(CMD[8]);

  Status:=TCSEventStatus(StrToInt(CMD[9]));

  MaxGamesCount:=StrToInt(CMD[10]);
  InitialTime:=CMD[11];
  IncTime:=StrToInt(CMD[12]);

  RatedType:=TRatedType(StrToInt(CMD[13]));
  RoomNumber:=StrToInt(CMD[14]);

  TimeLimit:=StrToInt(CMD[15]);
  Rated:=CMD[16]='1';
  LeaderColor:=TCSLeaderColor(StrToInt(CMD[17]));
  ProvisionalAllowed:=CMD[18]='1';
  AdminTitledOnly:=CMD[19]='1';
  OneGame:=CMD[20]='1';
  MinPeople:=StrToInt(CMD[21]);
  MaxPeople:=StrToInt(CMD[22]);
  ShoutStart:=StrToInt(CMD[23]);
  ShoutInc:=StrToInt(CMD[24]);
  ShoutMsg:=CMD[25];

  if CMD.Count>26 then begin
    AutoStart:=CMD[26]='1';
    sReserv:=CMD[27];
    sCongrMsg:=CMD[28];
  end else begin
    AutoStart:=false;
    sReserv:='';
    sCongrMsg:='';
  end;

  if CMD.Count>29 then sClubList:=CMD[29];

  if type_ = evtLecture then EV:=fCLLectures.FindLecture(ID)
  else EV:=FindEvent(ID);

  if EV=nil then
    case type_ of
      evtSimul: EV:=TCSEventSimul.Create;
      evtChallenge: EV:=TCSEventChallenge.Create;
      evtKing: EV:=TCSEventKing.Create;
      evtTournament: EV:=TCSTournament.Create;
      evtLecture: EV:=TCSLecture.Create;
    end;

  EV.Odds.Clear;
  EV.Name:=sName;
  EV.Type_:=type_;
  EV.StartTime:=dt;
  EV.Leaders.CommaText:=sLeaders;
  EV.FIAmLeader:=pos(','+lowercase(fCLSocket.MyName)+',',','+lowercase(sLeaders)+',')>0;
  EV.Description:=sDesc;
  EV.Id:=id;
  EV.MinRating:=nMinRating;
  EV.MaxRating:=nMaxRating;
  EV.Status:=Status;
  EV.MaxGamesCount:=MaxGamesCount;
  EV.InitialTime:=InitialTime;
  EV.IncTime:=IncTime;
  EV.RatedType:=RatedType;
  EV.RoomNumber:=RoomNumber;
  EV.TimeLimit:=TimeLimit;
  EV.Rated:=Rated;
  EV.LeaderColor:=LeaderColor;
  EV.ProvisionalAllowed:=ProvisionalAllowed;
  EV.AdminTitledOnly:=AdminTitledOnly;
  EV.OneGame:=OneGame;
  EV.MinPeople:=MinPeople;
  EV.MaxPeople:=MaxPeople;
  EV.ShoutStart:=ShoutStart;
  EV.ShoutInc:=ShoutInc;
  EV.ShoutMsg:=ShoutMsg;
  EV.AutoStart:=AutoStart;
  EV.Reserv:=sReserv;
  EV.CongrMsg:=sCongrMsg;
  EV.ClubList:=sClubList;

  if type_ = evtLecture then fCLLectures.UpdateLecture(EV)
  else UpdateEvent(EV);

end;
//==========================================================================
function TfCLEvents.FindEventIndex(id: integer): integer;
var
  i: integer;
  ev: TCSEvent;
begin
  for i:=0 to lvEvents.Items.Count-1 do begin
    ev:=TCSEvent(lvEvents.Items[i].Data);
    if ev.ID=id then begin
      result:=i;
      exit;
    end;
  end;
  result:=-1;
end;
//==========================================================================
procedure TfCLEvents.sbMaxClick(Sender: TObject);
begin
  Self.SetFocus;
  fCLMain.miMaximizeTop.Click;
end;
//==========================================================================
{ TCSEvent }
//==========================================================================
constructor TCSEvent.Create;
begin
  FLeaders:=TStringList.Create;
  Odds:=TCSOddsList.Create;
  State:=eusNone;
  Games:=TList.Create;
  ActiveGameNum:=-1;
  LoginList:=TObjectList.Create;
  LoginList.OwnsObjects:=true;
  Tickets:=TEventTickets.Create;
  Tickets.OwnsObjects:=true;
end;
//==========================================================================
destructor TCSEvent.Destroy;
begin
  inherited;
  FLeaders.Free;
  Games.Free;
  LoginList.Free;
end;
//==========================================================================
function TfCLEvents.UpdateEvent(EV: TCSEvent): integer;
var
  i,index: integer;
  item: TListItem;
begin
  index:=fCLEvents.FindEventIndex(EV.ID);
  if index = -1 then item:=lvEvents.Items.Add
  else item:=lvEvents.Items[index];

  item.Caption:=IntToStr(EV.id);
  for i:=item.SubItems.Count to 6 do
    item.SubItems.Add('');
  item.SubItems[0]:=EV.Name;
  item.SubItems[1]:= EV.StatusStr;
  item.SubItems[2]:=Format('%d / %d',[EV.CountJoined,EV.CountObserver]);
  item.SubItems[3]:=DateTimeToStr(EV.StartTime);
  item.SubItems[4]:=EV.FLeaders.CommaText;
  item.SubItems[5]:=EventType2Str(EV.Type_);
  item.SubItems[6]:=EV.Description;
  item.Data:=EV;
  result:=index;
  if pnlInfo.Tag=EV.ID then DisplayInfo(EV);
end;
//==========================================================================
procedure TfCLEvents.lvEventsDblClick(Sender: TObject);
begin
  {fCLCLS.FDatapack.Clear;
  fCLCLS.FDatapack.Add('971');
  fCLCLS.ProcessDatapack;}
  //CMD_EVENTCREATE(nil);
  //UpdateEvent(nil);
  miObserve.Click;
end;
//==========================================================================
procedure TfCLEvents.miJoinClick(Sender: TObject);
begin
  if lvEvents.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_JOIN + #32 + lvEvents.Selected.Caption]);
end;
//==========================================================================
procedure TfCLEvents.CMD_EventJoined(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
  state: TCSEventUserState;
  s: string;
begin
  if CMD.Count<3 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  if CMD[2]='l' then state:=eusLeader
  else if CMD[2]='m' then state:=eusMember
  else if CMD[2]='o' then state:=eusObserver
  else state:=eusObserver;

  index:=FindEventIndex(id);
  if index <> -1 then begin
    ev:=TCSEvent(lvEvents.Items[index].Data);
  end else begin
    index := fCLLectures.FindLectureIndex(id);
    if index = -1 then exit;
    ev := TCSLecture(fCLLectures.lvLectures.Items[index].Data);
  end;
  ev.State:=state;
  
  case state of
    eusMember: s:='joined to';
    eusObserver: s:='observing';
    eusLeader: s:='leader of';
  end;

  ev.FIAmLeader:=pos(','+lowercase(fCLSocket.MyName)+',',','+lowercase(ev.FLeaders.Commatext)+',')>0;

  fCLTerminal.ccConsole.AddLine(-1, Format('You are now %s event %s (%d)',[s,ev.Name,ev.ID]), ltServerMsgNormal);
  fCLTerminal.CreateFilter(ev.Name,fkEvent,ev.ID);
  if ev.Type_ <> evtLecture then begin
    fCLEventControl.EVCurrent:=ev;
    fCLEventControl.DisplayEventInfo;
    fCLEventControl.DisplayUserState;
    fCLEventControl.ArrangeGameButtons;
    fCLMain.EventAttached:=true;
  end;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventStarted(CMD: TStrings);
var
  id: integer;
  ev: TCSEvent;
begin
  log('CMD_EventStarted...');
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;
  log('id='+CMD[1]);
  ev:=FindEvent(id);
  if ev = nil then ev := fCLLectures.FindLecture(id);
  if ev = nil then exit;
  log('event name='+ev.Name);
  ev.Status:=estStarted;
  if fCLEventControl.EVCurrent = ev then begin
    fCLEventControl.EVCurrent:=ev;
    fCLEventControl.DisplayEventInfo;
    log('event info displayed');
    fCLTerminal.ccConsole.AddLine(-1, Format('Event %s (%d) started.',[ev.Name,ev.ID]), ltServerMsgNormal);

    if (ev.Type_=evtSimul) then
      if ev.IAmLeader then fCLEventControl.SetNextLeaderGame(-1)
      else fCLEventControl.SetMyGame;
  end;

  log('current game set');
  if ev.type_ = evtLecture then fCLLectures.UpdateLecture(ev)
  else UpdateEvent(ev);
  log('event updated in event list');
end;
//==========================================================================
procedure TCSEvent.AddGame(GM: TCLGame);
begin
  Games.Add(GM);
  if fCLEventControl.EVCurrent = nil then
    fCLEventControl.EVCurrent:=Self;
end;
//==========================================================================
function TCSEvent.GetLeaderName: string;
begin
  if not OneLeaderEvent or (FLeaders = nil) or (FLeaders.Count=0) then result:=''
  else result:=Leaders[0];
end;
//==========================================================================
procedure TCSEvent.GetScore(var Win, Draw, Lost, Progress: integer);
var
  i: integer;
begin
  Win:=0; Draw:=0; Lost:=0; Progress:=0;
  if not (Type_ in [evtSimul,evtChallenge]) then exit;
  for i:=0 to Games.Count-1 do
    case GameStatus(i) of
      egsLeaderWin: inc(Win);
      egsDraw: inc(Draw);
      egsLeaderLost: inc(Lost);
      egsLeaderMove,egsPlayerMove: inc(Progress);
    end;
end;
//==========================================================================
function TCSEvent.GameStatus(Game: TCLGame): TCSEventGameStatus;
var
  LeaderWhite: Boolean;
begin
  if not OneLeaderEvent then begin
    result:=egsNotDefined;
    exit;
  end;

  if Game.EventId<>ID then result:=egsNone
  else begin
    LeaderWhite:= lowercase(Game.WhiteName) = LeaderName;

    if Game.GameResult = '1/2-1/2' then result:=egsDraw
    else if Game.GameResult = '*' then result:=egsAborted
    else if Game.GameResult = '-' then result:=egsNone
    else if LeaderWhite and (Game.GameResult = '1-0') or not LeaderWhite and (Game.GameResult = '0-1') then
      result:=egsLeaderWin
    else if LeaderWhite and (Game.GameResult = '0-1') or not LeaderWhite and (Game.GameResult = '1-0') then
      result:=egsLeaderLost
    else if Game.GameResult = '' then
      if ((Game.NextColor = 1) or (Game.Moves.Count=0)) and LeaderWhite or not LeaderWhite and (Game.NextColor<>1) then
        result:=egsLeaderMove
      else
        result:=egsPlayerMove
    else
      result:=egsNone;
  end;
end;
//==========================================================================
function TCSEvent.GameStatus(Num: integer): TCSEventGameStatus;
var
  Game: TCLGame;
begin
  Game:=TCLGame(Games[Num]);
  result:=GameStatus(Game);
end;
//==========================================================================
{ TCSEventSimul }
//==========================================================================
procedure TfCLEvents.miStartClick(Sender: TObject);
begin
  if lvEvents.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_START + #32 + lvEvents.Selected.Caption]);
end;
//==========================================================================
function TfCLEvents.FindEvent(id: integer): TCSEvent;
var
  index: integer;
begin
  index:=FindEventIndex(id);
  if index=-1 then result:=nil
  else result:=TCSEvent(lvEvents.Items[index].Data);
end;
//==========================================================================
{procedure TfCLEvents.AdjustGameResult(Game: TCLGame);
var
  ev: TCSEventSimul;
  Game: TCLGame;
begin
  if Game.EventId = 0 then exit;
  ev:=FindEvent(Game.EventId);
  if fCLEventControl.EVSimul = ev then
    fCLEventControl.EVSimul
end;}
//==========================================================================
procedure TCSEvent.Leave;
var
  i: integer;
begin
  for i:=0 to Games.Count-1 do
    fCLBoard.KillGame(Games[i],false);
  Games.Clear;
end;
//==========================================================================
procedure TfCLEvents.miObserveClick(Sender: TObject);
begin
  if lvEvents.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_OBSERVE + #32 + lvEvents.Selected.Caption]);
end;
//==========================================================================
procedure TfCLEvents.CMD_EventLeaderLocation(CMD: TStrings);
var
  EventId,Location: integer;
  ev: TCSEvent;
begin
  if CMD.Count<3 then exit;
  try
    EventId:=StrToInt(CMD[1]);
    Location:=StrToInt(CMD[2]);
  except
    exit;
  end;
  ev:=FindEvent(EventId);
  ev.OnLeaderLocation(Location);
end;
//==========================================================================
procedure TCSEvent.SetActiveGameNum(const Value: integer);
begin
  if FActiveGameNum<>Value then begin
    FActiveGameNum := Value;
    if fCLEventControl.EVCurrent = Self then
      fCLEventControl.ArrangeGameButtons;
    SetCurrentGameFilter;
  end;
end;
//==========================================================================
procedure TCSEvent.SetLeaderLocation(const Value: integer);
begin
  if FLeaderLocation<>Value then begin
    FLeaderLocation := Value;
    if fCLEventControl.EVCurrent = Self then
      fCLEventControl.ArrangeGameButtons;
  end;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventDeleted(CMD: TStrings);
var
  id,index: integer;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index <> -1 then lvEvents.Items.Delete(index)
  else begin
    index := fCLLectures.FindLectureIndex(id);
    if index <> -1 then fCLLectures.lvLectures.Items.Delete(index);
  end;
end;
//==========================================================================
procedure TfCLEvents.miDeleteClick(Sender: TObject);
begin
  if lvEvents.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_DELETE + #32 + lvEvents.Selected.Caption]);
end;
//==========================================================================
function TCSEvent.GetStatusStr: string;
begin
  case Status of
    estWaited: result:='Waiting...';
    estStarted: result:='Started';
    estFinished: result:='Finished';
  end;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventFinished(CMD: TStrings);
var
  id: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  ev:=FindEvent(id);
  if ev = nil then ev := fCLLectures.FindLecture(id);
  if ev = nil then exit;

  ev.Status:=estFinished;

  if ev.type_ = evtLecture then fCLLectures.UpdateLecture(ev)
  else UpdateEvent(ev);
end;
//==========================================================================
function TCSEventSimul.LeaderTime(Num: integer): integer;
var
  Game: TCLGame;
begin
  Game:=TCLGame(Games[Num]);
  if lowercase(Game.WhiteName) = lowercase(LeaderName) then
    result:=Game.WhiteMSec
  else if lowercase(Game.BlackName) = lowercase(LeaderName) then
    result:=Game.BlackMSec
  else
    result:=0;
end;
//==========================================================================
function TCSEventSimul.GetLeaderGameLessTime: integer;
var
  i,min,n: integer;
begin
  result:=-1;
  min:=10000000;
  for i:=0 to Games.Count-1 do begin
    if GameStatus(i)=egsLeaderMove then begin
      n:=LeaderTime(i);
      if n<min then begin
        min:=n;
        result:=i;
      end;
    end;
  end;
  if result = -1 then
    for i:=0 to Games.Count-1 do begin
      if GameStatus(i) in [egsLeaderMove,egsPlayerMove] then begin
        n:=LeaderTime(i);
        if n<min then begin
          min:=n;
          result:=i;
        end;
      end;
    end;
  if result=-1 then result:=GetNextCurrentGame(LeaderLocation);
end;
//==========================================================================
function TCSEventSimul.GetLeaderGameLessMoves: integer;
var
  i,min,n: integer;
begin
  result:=-1;
  min:=10000000;
  for i:=0 to Games.Count-1 do begin
    if GameStatus(i)=egsLeaderMove then begin
      n:=MovesCount(i);
      if n<min then begin
        min:=n;
        result:=i;
      end;
    end;
  end;
  if result = -1 then
    for i:=0 to Games.Count-1 do begin
      if GameStatus(i) in [egsLeaderMove,egsPlayerMove] then begin
        n:=MovesCount(i);
        if n<min then begin
          min:=n;
          result:=i;
        end;
      end;
    end;
  if result=-1 then result:=GetNextCurrentGame(LeaderLocation);
end;
//==========================================================================
function TCSEventSimul.MovesCount(Num: integer): integer;
var
  Game: TCLGame;
begin
  Game:=TCLGame(Games[Num]);
  result:=Game.Moves.Count;
end;
//==========================================================================
function TCSEventSimul.GetLeaderGameNextOrder: integer;
begin
  if Games.Count<2 then result:=LeaderLocation
  else begin
    result:=(LeaderLocation+1) mod Games.Count;
    while result<>LeaderLocation do begin
      if GameStatus(result)=egsLeaderMove then exit;
      result:=(result+1) mod Games.Count;
    end;
  end;
  if result=LeaderLocation then
    result:=GetNextCurrentGame(LeaderLocation);
end;
//==========================================================================
function TCSEventSimul.GetNextCurrentGame(Num: integer): integer;
begin
  result:=(Num+1) mod Games.Count;
  while result<>Num do begin
    if GameStatus(result) in [egsLeaderMove,egsPlayerMove] then exit;
    result:=(result+1) mod Games.Count;
  end;
end;
//==========================================================================
procedure TCSEvent.SetCurrentGameFilter;
var
  game: TCLGame;
  filter: TCLFilter;
begin
  if (ActiveGameNum=-1) or (Type_=evtSimul) then exit;
  game:=TCLGame(Games[ActiveGameNum]);
  filter:=fCLTerminal.FilterMgr.GetFilter(fkGame,Integer(game));
  if filter=nil then exit;
  fCLTerminal.ccConsole.FilterID:=filter.Filter;
end;
//==========================================================================
procedure TfCLEvents.lvEventsMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  i,btm: integer;
  itm: TListItem;
  found: Boolean;
begin
  if (X=OldX) and (Y=OldY) then exit;
  pnlInfo.Parent:=lvEvents;
  found:=false;
  for i:=0 to lvEvents.Items.Count-1 do begin
    itm:=lvEvents.Items[i];
    btm:=itm.Position.Y-trunc(lvEvents.Font.Height*1.2);
    if (y>itm.Position.Y) and (y<btm) then begin
      found:=true; break;
    end;
  end;
  pnlInfo.Visible:=found;
  if Found then begin
    pnlInfo.Top:=btm+2;
    DisplayInfo(TCSEvent(lvEvents.Items[i].Data));
  end else
    pnlInfo.Tag:=0;
  {pnlInfo.Caption:=IntToStr(i);
  pnlInfo.Caption:=pnlInfo.Caption+' '+Format('%d-%d',[x,y]);}
  OldX:=X; OldY:=Y;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventStatistic(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
  state: TCSEventUserState;
  nLeader,nJoined,nObserver,nFreeGameSlots: integer;
begin
  if CMD.Count<6 then exit;
  try
    id:=StrToInt(CMD[1]);
    nLeader:=StrToInt(CMD[2]);
    nJoined:=StrToInt(CMD[3]);
    nObserver:=StrToInt(CMD[4]);
    nFreeGameSlots:=StrToInt(CMD[5]);
  except
    exit;
  end;

  ev := FindEvent(id);
  if ev = nil then ev := fCLLectures.FindLecture(id);
  if ev = nil then exit;
  ev.CountLeader:=nLeader;
  ev.CountJoined:=nJoined;
  ev.CountObserver:=nObserver;
  ev.FreeGameSlots:=nFreeGameSlots;
  if ev.Type_ = evtLecture then fCLLectures.UpdateLecture(ev)
  else UpdateEvent(ev);
  if fCLEventControl.EVCurrent = ev then
    fCLEventControl.DisplayEventInfo;
end;
//==========================================================================
procedure TfCLEvents.DisplayInfo(EV: TCSEvent);
var
  n,win,draw,lost,progress: integer;
begin
  with pnlInfo do begin
    Tag := EV.ID;
    lblNum.Caption := '#'+IntToStr(EV.ID);
    lblTitle.Caption := EV.Name;
    lblType.Caption := EventType2Str(EV.Type_);
    lblLeaders.Caption := EV.Leaders.CommaText;
    if EV.CountLeader = EV.Leaders.Count then begin
      lblLeaders.Font.Style:=[fsBold];
      lblLeaders.Font.Color:=clBlue;
    end else begin
      lblLeaders.Font.Style:=[];
      lblLeaders.Font.Color:=clBlack
    end;

    if (EV.MinRating = 0) and (EV.MaxRating = 3000) then
      lblRating.Caption := 'no restrictions'
    else
      lblRating.Caption := Format('%d-%d',[EV.MinRating,EV.MaxRating]);
    lblJoined.Caption:=IntToStr(EV.CountJoined);
    lblObserver.Caption:=IntToStr(EV.CountObserver);
    lblDescription.Caption := EV.Description;
    lblStartTime.Caption := DateTimeToStr(EV.StartTime);

    pnlSimul.Visible := not (EV.Type_ in [evtKing,evtTournament]);
    pnlOdds.Visible := EV.Type_ in ETOdds;
    pnlTournament.Visible := EV.Type_ = evtTournament;
    if pnlSimul.Visible then begin
      lblTimeControl.Caption:=TimeToStrEventFormat(EV.InitialTime,EV.IncTime);
      lblMaxGames.Caption:=IntToStr(EV.MaxGamesCount);
      n:=EV.Games.Count;
      lblCurrentGames.Caption:=IntToStr(n);
      lblFreeGameSlots.Caption:=IntToStr(EV.FreeGameSlots);
      EV.GetScore(Win,Draw,Lost,Progress);
      lblWins.Caption:=IntToStr(Win);
      lblDraw.Caption:=IntToStr(Lost);
      lblLost.Caption:=IntToStr(Lost);
    end;

    if EV.Type_=evtKing then begin
      lblLeaderCaption.Caption:='King';
      lblLeaders.Caption:=GetNameWithTitle((EV as TCSEventKing).KingName,(EV as TCSEventKing).KingTitle);
    end else
      lblLeaderCaption.Caption:='Leader(s):';

    if EV.Type_ = evtTournament then begin
      lblTourType.Caption:=TOURTYPE_STRINGS[ord((EV as TCSTournament).Reglament.TourType)];
      lblENumber.Caption:=IntToStr((EV as TCSTournament).Reglament.ENumber);
      lblTourInvited.Caption:=IntToStr(EV.Tickets.Count);
      if EV.FreeGameSlots = -1 then
        lblTourFree.Caption:='Unlimited'
      else
        lblTourFree.Caption:=IntToStr(EV.FreeGameSlots);
      lblTourFreeCaption.Left := lblTourFree.Left - lblTourFreeCaption.Width-4;

    end;
  end;
  //lblTitle.
  DisplayOddsInfo(ev);
end;
//==========================================================================
procedure TfCLEvents.CMD_EventOddsAdd(CMD: TStrings);
var
  id,index,Rating,IncTime: integer;
  InitTime,pieces: string;
  ev: TCSEvent;
begin
  if CMD.Count<5 then exit;
  try
    id:=StrToInt(CMD[1]);
    Rating:=StrToInt(CMD[2]);
    InitTime:=CMD[3];
    IncTime:=StrToInt(CMD[4]);
  except
    exit;
  end;

  InitTime:=TimeConvertToS(InitTime);
  Pieces:=CMD[5];
  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEventSimul(lvEvents.Items[index].Data);
  ev.Odds.AddOdds(Rating,InitTime,IncTime,Pieces);
  UpdateEvent(ev);
end;
//==========================================================================
{ TCSEventOddsList }
//==========================================================================
procedure TCSOddsList.AddOdds(Rating: integer; InitTime: string; IncTime: integer;
  Pieces: string);
var
  odds: TCSOdds;
  IsNew: Boolean;
begin
  odds:=FindOdds(Rating);
  IsNew:=odds=nil;
  if IsNew then odds:=TCSOdds.Create;
  odds.Rating:=Rating;
  odds.InitTime:=InitTime;
  odds.IncTime:=IncTime;
  odds.Pieces:=Pieces;
  if IsNew then Add(odds);
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
procedure TfCLEvents.DisplayOddsInfo(ev: TCSEvent);
var
  i,j,nTop,nTopMain,nLeft,OldRating,maxwidth,maxwidth1,NewHeight: integer;
  OddsList: TCSOddsList;
  odds: TCSOdds;
  lbl: TLabel;
  img: TImage;
begin
  pnlInfo.Tag:=ev.ID;
  OddsList:=ev.Odds;
  for i:=pnlOdds.ControlCount-1 downto 0 do
    if pnlOdds.Controls[i].Tag<>5 then
      pnlOdds.RemoveControl(pnlOdds.Controls[i]);

  if OddsList.Count=0 then begin
    AddLabel(pnlOdds,'No odds',4,4,clRed,[fsBold]);
    NewHeight:=30;
    pnlInfo.Height:=pnlInfo.Height+NewHeight-pnlOdds.Height;
    pnlOdds.Height:=NewHeight;
    exit;
  end;

  nTopMain:=25;

  nTop:=nTopMain; OldRating:=1; maxwidth:=0;
  for i:=0 to OddsList.Count-1 do begin
    odds:=TCSOdds(OddsList[i]);
    lbl:=AddLabel(pnlOdds,Format('%d-%d',[OldRating,odds.Rating]),4,nTop,clBlack,[fsBold]);
    lbl.Tag:=1;
    if lbl.Width>maxwidth then maxwidth:=lbl.Width;
    nTop:=nTop+20;
    OldRating:=odds.Rating+1;
  end;

  nTop:=nTopMain; maxwidth1:=0;
  for i:=0 to OddsList.Count-1 do begin
    odds:=TCSOdds(OddsList[i]);
    if (odds.InitTime<>ev.InitialTime) or
      (odds.IncTime<>ev.IncTime)
    then begin
      lbl:=AddLabel(pnlOdds,Format('%s / %d',[odds.InitTime,odds.IncTime]),maxwidth+15,nTop,
        clBlack,[]);
      lbl.Tag:=2;
      if lbl.Width>maxwidth1 then maxwidth1:=lbl.Width;
    end;
    nTop:=nTop+20;
  end;

  nTop:=nTopMain; nLeft:=maxwidth+maxwidth1+25;
  for i:=0 to OddsList.Count-1 do begin
    odds:=TCSOdds(OddsList[i]);
    for j:=1 to length(odds.Pieces) div 2 do begin
      img:=TImage.Create(pnlOdds);
      img.Width:=21;
      img.Height:=21;
      GetLittlePieceImage(odds.Pieces[j*2-1],img.Picture.Bitmap);
      img.Top:=nTop-5;
      img.Left:=nLeft+22*(j-1);
      img.Tag:=3;
      with img.Picture.BitMap.Canvas do begin
        Brush.Color:=pnlOdds.Color;
        FloodFill(1,1,Pixels[1,1],fsSurface);
      end;
      pnlOdds.InsertControl(img);
    end;
    nTop:=nTop+20;
  end;
  NewHeight:=nTop+20;
  pnlInfo.Height:=pnlInfo.Height+NewHeight-pnlOdds.Height;
  pnlOdds.Height:=NewHeight;

  AddLabel(pnlOdds,'Rating',4,4,clBlue,[fsBold]);
  AddLabel(pnlOdds,'Time',maxwidth+15,4,clBlue,[fsBold]);
  AddLabel(pnlOdds,'Pieces',nLeft,4,clBlue,[fsBold]);
end;
//==========================================================================
procedure TfCLEvents.OnDoTurn(Game: TCLGame);
var
  ev: TCSEvent;
begin
  ev:=fCLEvents.FindEvent(Game.EventId);
  if (ev=nil) or (ev.GamesTransferring) then exit;
  ev.OnDoTurn(Game);
end;
//==========================================================================
procedure TCSEventSimul.OnDoTurn(Game: TCLGame);
begin
  if IAmLeader and (GameStatus(ActiveGameNum)<>egsLeaderMove) then
    fCLEventControl.SetNextLeaderGame(ActiveGameNum);
  if not IAmLeader and
    ((Game.WhiteName=fCLSocket.MyName) or (Game.BlackName=fCLSocket.MyName))
  then
    fCLEventControl.SetActiveGame(Game.EventOrdNum-1);
  fCLEventControl.LoadRightImage(Game);
end;
//==========================================================================
procedure TCSEventSimul.OnGameBorn(Game: TCLGame);
begin
  if (Game.WhiteName = fCLSocket.MyName) or (Game.BlackName = fCLSocket.MyName) then
    Game.GameMode:=gmCLSLive
  else
    Game.GameMode:=gmCLSObserve;
  AddGame(Game);
end;
//==========================================================================
procedure TfCLEvents.OnGameBorn(Game: TCLGame);
var
  ev: TCSEvent;
begin
  ev:=fCLEvents.FindEvent(Game.EventId);
  if ev = nil then ev := fCLLectures.FindLEcture(Game.EventID);
  if ev=nil then exit;
  ev.OnGameBorn(Game);
end;
//==========================================================================
procedure TCSEventSimul.OnLeaderLocation(Location: integer);
begin
  LeaderLocation:=Location-1;
  if (State=eusObserver) and not IAmLeader and fCLEventControl.tbFollow.Down
    and (fCLEventControl.EVCUrrent = Self)
  then
    fCLEventControl.ClickGameButton(LeaderLocation);
end;
//==========================================================================
{ TCSEventChallenge }
//==========================================================================
procedure TCSEvent.OnObserver(const LoginID: Integer; const LoginName,
  Title, RatingString: string; UserState: TCSEventUserState);
var
  n: integer;
  LG: TCLLogin;
begin
  CLLib.Log(Format('CSEvent.OnObserver(%d,%d,%s,%s,%d)',[ID,LoginId,LoginName,Title,ord(UserState)]));
  n:=FindCLLogin(LoginID);
  CLLib.Log(Format('n=%d',[n]));
  if n=-1 then begin
    LG:=TCLLogin.Create;
    LoginList.Add(LG);
  end else
    LG:=TCLLogin(LoginList[n]);
  LG.FLoginID:=LoginID;
  LG.FLogin:=LoginName;
  LG.FTitle:=Title;
  LG.FRatingString:=RatingString;
  LG.FEventState:=UserState;


  {if (fCLEventControl.EvCurrent=Self) and (LG.FEventState=eusMember) then
    if Type_=evtChallenge then fCLEventControl.AddToQueue(fCLEventControl.lvQueue,LG)
    else fCLEventControl.AddToQueue(fCLEventControl.lvKingQueue,LG);}
end;
//==========================================================================
procedure TfCLEvents.OnObserver(ID, LoginId: integer; Login, Title,
  RatingString: string; EventUserState: TCSEventUserState);
var
  ev: TCSEvent;
begin
  CLLib.Log(Format('CSEvents.OnObserver(%d,%d,%s,%s,%d)',[ID,LoginId,Login,Title,ord(EventUserState)]));
  ev:=FindEvent(ID);
  if ev=nil then exit;
  ev.OnObserver(LoginId,Login,Title,RatingString,EventUserState);
end;
//==========================================================================
function TCSEvent.FindCLLogin(LoginID: integer): integer;
var
  i: integer;
begin
  result:=-1;
  for i:=0 to LoginList.Count-1 do
    if TCLLogin(LoginList[i]).FLoginID = LoginID then begin
      result:=i;
      exit;
    end;
end;
//==========================================================================
function TCSEvent.FindCLLogin(Name: string): integer;
var
  i: integer;
begin
  result:=-1;
  for i:=0 to LoginList.Count-1 do
    if TCLLogin(LoginList[i]).FLogin = Name then begin
      result:=i;
      exit;
    end;
end;
//==========================================================================
procedure TfCLEvents.OnUnobserver(ID, LoginID: integer);
var
  ev: TCSEvent;
begin
  ev:=FindEvent(ID);
  if ev=nil then exit;
  ev.OnUnobserver(LoginId);
end;
//==========================================================================
procedure TCSEvent.OnUnobserver(LoginID: integer);
var
  n: integer;
begin
  n:=FindCLLogin(LoginID);
  if n=-1 then exit;
  if fCLEventControl.EvCurrent=Self then
    if Type_=evtChallenge then
      fCLEventControl.DeleteFromQueue(fCLEventControl.lvQueue,TCLLogin(LoginList[n]))
    else if Type_=evtKing then
      fCLEventControl.DeleteFromQueue(fCLEventControl.lvKingQueue,TCLLogin(LoginList[n]));
  LoginList.Delete(n);
end;
//==========================================================================
{function TCSEventChallenge.FreeGameSlots: integer;
begin
  result:=MaxGamesCount-Games.Count-CountJoined;
  if result<0 then result:=0;
end;}
//==========================================================================
procedure TCSEventChallenge.OnDoTurn(Game: TCLGame);
begin
  //
end;
//==========================================================================
procedure TCSEventChallenge.OnGameBorn(Game: TCLGame);
begin
  AddGame(Game);
end;
//==========================================================================
procedure TCSEventChallenge.OnGameResult(Game: TCLGame);
begin
  if fCLEventControl.EVCurrent = Self then
    with fCLEventControl do begin
      DisplayScore;
      lblCurrentGame.Caption:='-';
      lblRating.Caption:='';
      AddToFinished(Game);
    end;
end;
//==========================================================================
procedure TCSEventChallenge.OnLeaderLocation(GameNum: integer);
begin
  //
end;
//==========================================================================
function TCSEvent.GetOneLeaderEvent: Boolean;
begin
  result:=FType in [evtSimul,evtChallenge];
end;
//==========================================================================
procedure TCSEventChallenge.OnObserver(const LoginID: Integer;
  const LoginName, Title, RatingString: string;
  UserState: TCSEventUserState);
begin
  inherited;
  //
end;
//==========================================================================
procedure TCSEventChallenge.OnUnobserver(LoginID: integer);
begin
  inherited;
  //
end;
//==========================================================================
procedure TCSEventSimul.OnGameResult(Game: TCLGame);
begin
  if fCLEventControl.EVCurrent<>Self then exit;
  fCLEventControl.LoadRightImage(Game);
  fCLEventControl.DisplayScore;

  if (Game.EventId<>0) and ((Game.WhiteName=fCLSocket.MyName) or (Game.BlackName=fCLSocket.MyName))
    and (fCLEventControl.EVCurrent<>nil) and not fCLEventControl.EVCurrent.IAmLeader
  then
    fCLEventControl.EVCurrent.State:=eusObserver;

  if fCLEventControl.EVCurrent.IAmLeader and (fCLBoard.GM = Game) then
    fCLEventControl.SetNextLeaderGame(Game.EventOrdNum);
end;
//==========================================================================
procedure TfCLEvents.OnGameResult(Game: TCLGame);
var
  ev: TCSEvent;
begin
  ev:=fCLEvents.FindEvent(Game.EventId);
  if ev=nil then exit;
  ev.OnGameResult(Game);
end;
//==========================================================================
procedure TCSEvent.GetPlayerAttributes(Game: TCLGame; var Name, Title,
  Rating: string);
begin
  if not OneLeaderEvent then begin
    Name:=''; Title:=''; Rating:='';
    exit;
  end;

  if lowercase(Game.WhiteName) = lowercase(LeaderName) then begin
    name:=GetNameWithTitle(Game.BlackName,Game.BlackTitle);
    rating:=Game.BlackRating;
  end else if lowercase(Game.BlackName) = lowercase(LeaderName) then begin
    name:=GetNameWithTitle(Game.WhiteName,Game.WhiteTitle);
    rating:=Game.WhiteRating;
  end else
    exit;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventKing(CMD: TStrings);
var
  id,index,rating,GamesWon: integer;
  name,title: string;
  ev: TCSEvent;
begin
  if CMD.Count<6 then exit;
  try
    id:=StrToInt(CMD[1]);
    name:=CMD[2];
    title:=CMD[3];
    rating:=StrToInt(CMD[4]);
    GamesWon:=StrToInt(CMD[5]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEventSimul(lvEvents.Items[index].Data);
  if ev.Type_<>evtKing then exit;
  (ev as TCSEventKing).KingInfo(name,title,rating,GamesWon);
end;
//==========================================================================
procedure TfCLEvents.CMD_EventQueueTail(CMD: TStrings);
var
  id,index,rating,GamesWon: integer;
  name,title: string;
  ev: TCSEvent;
begin
  if CMD.Count<4 then exit;
  try
    id:=StrToInt(CMD[1]);
    name:=CMD[2];
    title:=CMD[3];
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  if not (ev.Type_ in ETQueue) then exit;
  ev.MoveUserToTail(name,title);
end;
//==========================================================================
{ TCSEventKing }
//==========================================================================
procedure TCSEventKing.KingInfo(name,title: string; rating, GamesWon: integer);
begin
  KingName:=name;
  KingTitle:=title;
  KingRating:=rating;
  KingGamesWon:=GamesWon;
  fCLEventControl.DisplayEventInfo;
end;
//==========================================================================
function TCSEventKing.KingRank: string;
begin
  if KingGamesWon=0 then result:='Chicken'
  else if KingGamesWon<3 then result:='Chiefman'
  else if KingGamesWon<5 then result:='Lord'
  else if KingGamesWon<8 then result:='Prince'
  else if KingGamesWon<12 then result:='King'
  else if KingGamesWon<20 then result:='Emperor'
  else result:='Deity';
end;
//==========================================================================
procedure TCSEventKing.OnDoTurn(Game: TCLGame);
begin
  //
end;
//==========================================================================
procedure TCSEventKing.OnGameBorn(Game: TCLGame);
begin
  AddGame(Game);
end;
//==========================================================================
procedure TCSEventKing.OnGameResult(Game: TCLGame);
begin
  if fCLEventControl.EVCurrent <> Self then exit;
  fCLEventControl.AddToFinished(Game);
end;
//==========================================================================
procedure TCSEventKing.OnLeaderLocation(GameNum: integer);
begin
  //
end;
//==========================================================================
procedure TCSEvent.MoveUserToTail(name, title: string);
begin
  if fCLEventControl.EVCurrent <> Self then exit;
  fCLEventControl.MoveUserToTail(name,title);
end;
//==========================================================================
procedure TCSEvent.OnShowGame(Game: TCLGame);
begin
  if fCLEventControl.EVCurrent <> Self then exit;
  fCLEventControl.AddGame(Game);
  fCLTerminal.CreateChildFilter(fkGame,Integer(Game),fkEvent,Self.ID,Self.Name+'(games)');
end;
//==========================================================================
procedure TfCLEvents.OnShowGame(Game: TCLGame);
var
  ev: TCSEvent;
begin
  ev:=FindEvent(Game.EventId);
  if ev=nil then exit;
  ev.OnShowGame(Game);
end;
//==========================================================================
function TCSEvent.GetActiveGame: TCLGame;
begin
  if (ActiveGameNum>=0) and (ActiveGameNum<Games.Count) then
    result:=TCLGame(Games[ActiveGameNum])
  else
    result:=nil;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventLeft(CMD: TStrings);
var
  EventID: integer;
  ev: TCSEvent;
begin
  try
    EventID:=StrToInt(CMD[1]);
  except
    exit;
  end;

  ev := fCLLectures.FindLecture(EventID);
  if ev = nil then begin
    with fCLEventControl do
      if (EVCurrent<>nil) and (EVCurrent.ID=EventID) then
        CloseEventControl
  end else begin
    ev.Leave;
    ev.State := eusNone;
    fCLLectures.UpdateLecture(ev);
    fCLTerminal.EventExit(EventID);
    fCLNavigate.clNavigate.ItemIndex:=5;
    fCLNavigate.clNavigateClick(nil);
    {if ev.Games.Count > 0 then
     fCLBoard.RemoveGame(TCLGame(ev.Games[0]));}
  end;
end;
//==========================================================================
procedure TfCLEvents.miLeaveClick(Sender: TObject);
begin
  if lvEvents.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_LEAVE,lvEvents.Selected.Caption]);
end;
//==========================================================================
{function TCSEvent.FreeGameSlots: integer;
begin
  result:=-1;
end;}
//==========================================================================
{function TCSEventSimul.FreeGameSlots: integer;
begin
  result:=MaxGamesCount-Games.Count;
end;}
//==========================================================================
procedure TfCLEvents.CMD_EventAbandon(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
  name,title: string;
  rating: integer;
begin
  if CMD.Count<3 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  name:=CMD[2];

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEventSimul(lvEvents.Items[index].Data);
  ev.OnAbandon(name);
end;
//==========================================================================
procedure TfCLEvents.CMD_EventMember(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
  name,title: string;
  rating: integer;
begin
  if CMD.Count<5 then exit;
  try
    id:=StrToInt(CMD[1]);
    rating:=StrToInt(CMD[4]);
  except
    exit;
  end;

  name:=CMD[2];
  title:=CMD[3];

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEventSimul(lvEvents.Items[index].Data);
  ev.OnMember(name,title,rating);
end;
//==========================================================================
procedure TCSEvent.OnAbandon(Name: string);
begin
  //
end;
//==========================================================================
procedure TCSEvent.OnMember(Name, Title: string; Rating: integer);
begin
  //
end;
//==========================================================================
procedure TfCLEvents.miTakePartClick(Sender: TObject);
begin
  if lvEvents.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_MEMBER + #32 + lvEvents.Selected.Caption]);
end;
//==========================================================================
procedure TfCLEvents.miAbandonClick(Sender: TObject);
begin
  if lvEvents.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_ABANDON + #32 + lvEvents.Selected.Caption]);
end;
//==========================================================================
procedure TfCLEvents.CMD_EventQueueAdd(CMD: TStrings);
var
  id,index,rating,GamesWon: integer;
  name,title: string;
  ev: TCSEvent;
begin
  if CMD.Count<5 then exit;
  try
    id:=StrToInt(CMD[1]);
    name:=CMD[2];
    title:=CMD[3];
    rating:=StrToInt(CMD[4]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  if not (ev.Type_ in ETQueue) then exit;
  ev.QueueAdd(name,title,rating);
end;
//==========================================================================
procedure TfCLEvents.CMD_EventQueueClear(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  if not (ev.Type_ in ETQueue) then exit;
  ev.QueueClear;
end;
//==========================================================================
procedure TCSEvent.QueueAdd(name, title: string; rating: integer);
begin
  if fCLEventControl.EvCurrent=Self then
    fCLEventControl.AddToQueue(nil,name,title,rating);
end;
//==========================================================================
procedure TCSEvent.QueueClear;
begin
  if fCLEventControl.EvCurrent=Self then
    fCLEventControl.QueueClear;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventMembersEnd(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  ev.OnMemberEnd;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventMembersStart(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  ev.OnMemberStart;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventReglGameAdd(CMD: TStrings);
var
  id,index,gameid,whitenum,blacknum,inctime,gamenum,roundnum,addnum: integer;
  inittime: string;
  ev: TCSEvent;
  GameResult: TCSReglGameResult;
begin
  if CMD.Count<11 then exit;
  try
    id:=StrToInt(CMD[1]);
    gameid:=StrToInt(CMD[2]);
    whitenum:=StrToInt(CMD[3]);
    blacknum:=StrToInt(CMD[4]);
    inittime:=CMD[5];
    inctime:=StrToInt(CMD[6]);
    gamenum:=StrToInt(CMD[7]);
    roundnum:=StrToInt(CMD[8]);
    addnum:=StrToInt(CMD[9]);
    gameresult:=TCSReglGameResult(StrToInt(CMD[10]));
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  if ev.Type_<>evtTournament then exit;
  (ev as TCSTournament).Reglament.InsOrUpdGame(
    gameid,whitenum,blacknum,inittime,inctime,gamenum,roundnum,addnum,gameresult);
end;
//==========================================================================
procedure TfCLEvents.CMD_EventReglGamesEnd(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);

  if fCLEventControl.EVCurrent=ev then
    fCLEventControl.RepaintActiveTable;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventReglGamesStart(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  if ev.Type_<>evtTournament then exit;
  (ev as TCSTournament).Reglament.ClearGames;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventReglGameUpdate(CMD: TStrings);
var
  id,index,gameid,gamenum: integer;
  ev: TCSEvent;
  gameresult: TCSReglGameResult;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
    gameid:=StrToInt(CMD[2]);
    gamenum:=StrToInt(CMD[3]);
    gameresult:=TCSReglGameResult(StrToInt(CMD[4]));
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  if ev.Type_<>evtTournament then exit;
  (ev as TCSTournament).Reglament.UpdateGame(gameid,gamenum,gameresult);
  if fCLEventControl.EVCurrent=ev then
    fCLEventControl.RepaintActiveTable;
end;
//==========================================================================
procedure TCSEvent.OnMemberStart;
begin
  // empty
end;
//==========================================================================
function TCSEvent.FindGameByNum(Num: integer): TCLGame;
var
  i: integer;
begin
  for i:=0 to Games.Count-1 do begin
    result:=TCLGame(Games[i]);
    if result.EventOrdNum=Num then exit;
  end;
  result:=nil;
end;
//==========================================================================
function TCSEvent.FindGameByGameNumber(GameNum: integer): TCLGame;
var
  i: integer;
begin
  for i:=0 to Games.Count-1 do begin
    result:=TCLGame(Games[i]);
    if result.GameNumber=GameNum then exit;
  end;
  result:=nil;
end;
//==========================================================================
procedure TfCLEvents.pmEventsPopup(Sender: TObject);
var
  i: integer;
  mi: TMenuItem;
  tp: TCSEventType;
  ev: TCSEvent;
  IsMember,IsTournament: Boolean;
begin
  if lvEvents.Selected = nil then begin
    for i:=0 to pmEvents.Items.Count-1 do begin
      mi:=pmEvents.Items[i];
      mi.Visible:=false;
    end;
  end else begin
    ev:=TCSEvent(lvEvents.Selected.Data);
    IsTournament:=ev.Type_=evtTournament;
    if IsTournament then
      IsMember:=(ev as TCSTournament).Reglament.MemberList.IndexOfUser(fCLSocket.MyName)>-1;

    miJoin.Visible:=(ev.State=eusNone) and not IsTournament or IsTournament and IsMember;
    miObserve.Visible:=true;
    miStart.Visible:=(ev.Status<>estStarted) and (fCLSocket.MyAdminLevel>0);
    miDelete.Visible:=fCLSocket.MyAdminLevel>0;
    miEdit.Visible:=fCLSocket.MyAdminLevel>0;
    miAbort.Visible:=fCLSocket.MyAdminLevel>0;
    miLeave.Visible:=ev.State<>eusNone;
    miTakePart.Visible:=IsTournament and not IsMember;
    miAbandon.Visible:=IsTournament and IsMember;
    miInvitedList.Visible:=ev.Tickets.Count>0;
  end;
end;
//==========================================================================
function TCSEvent.MyCurrentGame: TCLGame;
var
  i: integer;
begin
  for i:=0 to Games.Count-1 do begin
    result:=TCLGame(Games[i]);
    if (result.GameResult='') and
      ((result.WhiteName=fCLSocket.MyName) or (result.BlackName=fCLSocket.MyName))
    then
      exit;
  end;
  result:=nil;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventReglament(CMD: TStrings);
var
  id,index,ENumber,NumberOfRounds,AcceptTime: integer;
  ev: TCSEvent;
  TourType: TCSTournamentType;
  RoundOrder: TCSRoundOrder;
begin
  if CMD.Count<6 then exit;
  try
    id:=StrToInt(CMD[1]);
    TourType:=TCSTournamentType(StrToInt(CMD[2]));
    RoundOrder:=TCSRoundOrder(StrToInt(CMD[3]));
    ENumber:=StrToInt(CMD[4]);
    NumberOfRounds:=StrToInt(CMD[5]);
    AcceptTime:=StrToInt(CMD[6]);
  except
    exit;
  end;
  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  if ev.Type_<>evtTournament then exit;
  with (ev as TCSTournament) do begin
    Reglament.TourType:=TourType;
    Reglament.RoundOrder:=RoundOrder;
    Reglament.ENumber:=ENumber;
    Reglament.NumberOfRounds:=NumberOfRounds;
    Reglament.AcceptTime:=AcceptTime;
  end;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventAcceptRequest(CMD: TStrings);
var
  id,index,rgame_id,sec: integer;
  ev: TCSEvent;
  partner: string;
begin
  if CMD.Count<4 then exit;
  try
    id:=StrToInt(CMD[1]);
    rgame_id:=StrToInt(CMD[2]);
    sec:=StrToInt(CMD[3]);
    partner:=CMD[4];
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  if ev.Type_<>evtTournament then exit;
  (ev as TCSTournament).AcceptRequest(rgame_id,sec,partner);
end;
//==========================================================================
procedure TCSEvent.OnMemberEnd;
begin
  // no code here
end;
//==========================================================================
procedure TfCLEvents.miAbortClick(Sender: TObject);
begin
  if lvEvents.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_DELETE + #32 + lvEvents.Selected.Caption+' abort']);
end;
//==========================================================================
procedure TfCLEvents.miEditClick(Sender: TObject);
var
  F: TfCLEventNew;
  ev: TCSEvent;
begin
  if lvEvents.Selected = nil then exit;

  ev:=TCSEvent(lvEvents.Selected.Data);
  F:=TfCLEventNew.Create(Application);
  F.Init(ev);
  if F.ShowModal=mrOk then
    fCLMain.SendEventCreate(F);
  F.Free;
end;
//==========================================================================
function TCSEvent.UserIsLoggedIn(Name: string): Boolean;
var
  i: integer;
  LG: TCLLogin;
begin
  result:=true;
  for i:=0 to LoginList.Count-1 do begin
    LG:=TCLLogin(LoginList[i]);
    if GetNameWithTitle(LG.FLogin,LG.FTitle) = Name then exit; 
  end;
  result:=false;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventGamesBegin(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;
  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  ev.GamesTransferring:=true;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventGamesEnd(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;
  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  ev.GamesTransferring:=false;
end;
//==========================================================================
procedure TfCLEvents.Clear;
begin
  lvEvents.Items.Clear;
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
procedure TfCLEvents.CMD_EventTicket(CMD: TStrings);
var
  id,index,rating: integer;
  Login, Title: string;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
    Login:=CMD[2];
    Title:=CMD[3];
    Rating:=StrToInt(CMD[4]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  ev.Tickets.AddTicket(Login,Title,Rating);
end;
//==========================================================================
procedure TfCLEvents.CMD_EventTicketsBegin(CMD: TStrings);
var
  id,index: integer;
  ev: TCSEvent;
begin
  if CMD.Count<2 then exit;
  try
    id:=StrToInt(CMD[1]);
  except
    exit;
  end;

  index:=FindEventIndex(id);
  if index=-1 then exit;
  ev:=TCSEvent(lvEvents.Items[index].Data);
  ev.Tickets.Clear;
end;
//==========================================================================
procedure TfCLEvents.CMD_EventTicketsEnd(CMD: TStrings);
begin
  //
end;
//==========================================================================
procedure TfCLEvents.miInvitedListClick(Sender: TObject);
var
  F: TfCLEventTickets;
  ev: TCSEvent;
begin
  F:=TfCLEventTickets.Create(Application);
  ev:=TCSEvent(lvEvents.Selected.Data);
  F.Init(ev,false);
  F.ShowModal;
  F.Free;
end;
//==========================================================================
function TCSEvent.UserIsJoined(Name: string): Boolean;
var
  i: integer;
begin
  result:=true;
  for i:=0 to LoginList.Count-1 do
    if (TCLLogin(LoginList[i]).FLogin = Name) and
      (TCLLogin(LoginList[i]).FEventState = eusMember)
    then
      exit;
  result:=false;
end;
//==========================================================================
var
  EVT_STRINGS: array[0..4] of string = ('Simul','Challenge','King','Tournament','Lecture');

function EventType2Str(evt: TCSEventType): string;
begin
  result:=EVT_STRINGS[ord(evt)];
end;
//==========================================================================
end.

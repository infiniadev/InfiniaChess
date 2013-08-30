unit CSTournament;

interface

uses CSEvent,Classes,CSReglament,CSConnection,SysUtils,contnrs, Variants;

type
  TCSTournament = class(TCSEvent)
  private
    FReglament: TCSReglament;
    FLastRoundShouted: integer;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Start; override;
    procedure AddTournamentGame(connWhite,connBlack: TConnection; rgame: TCSReglGame);
    procedure StartGames; override;
    procedure Params(Connection: TConnection; CMD: TStrings); override;
    function Member(Connection: TConnection): Boolean; override;
    procedure Abandon(Connection: TConnection); override;
    procedure SendReglGame(rgame: TCSReglGame; Connection: TConnection = nil);
    procedure SendReglGames(Connection: TConnection = nil);
    procedure SendMemberList(Connection: TConnection = nil);
    procedure SendReglament(Connection: TConnection = nil);
    procedure SendReglGameUpdate(rgame: TCSReglGame);
    procedure OnGameResult(GameOrdNum: integer); override;
    procedure StartNextRoundIfNeed;
    procedure CheckEventFinished; override;
    procedure Join(Connection: TConnection; Mode: string); override;
    procedure SendJoinMessages(Connection: TConnection);
    procedure FinishTournament;
    procedure SendEventCreated(Connections: TObjectList); override;
    procedure Forfeit(Connection: TConnection; Login: string); override;
    procedure GameAccept(Connection: TConnection; rgame_id: integer);
    procedure SendAcceptRequests(Connection: TConnection = nil; p_Repeat: Boolean = false);
    procedure GetRGameNames(rgame: TCSReglGame; var pp_WhiteName,pp_BlackName: string);
    procedure GetRGameFullNames(rgame: TCSReglGame; var pp_WhiteName,pp_BlackName: string);
    procedure OnTimer; override;
    procedure SetDefaultMinMaxPeople; virtual;
    procedure UserLeave(Connection: TConnection); override;
    function FreeSlots: integer; override;
    procedure Resume(Connection: TConnection); override;
    function UserCanJoin(Connection: TConnection; var pp_ErrMsg: string): Boolean; override;
    procedure RestoreGames(Connection: TConnection); override;
    function CountReglMembersNoTicket: integer;
    procedure ShoutRound;
    procedure SaveFinishedToDB; override;

    property Reglament: TCSReglament read FReglament;
  end;
  //----------------------------------------------------------------------------

implementation

uses CSSocket, CSConst, CSConnections, CSLib, CSGame, CSGames, CSDb, CSAchievements;
//==============================================================================
{ TCSTournament }
//==============================================================================
procedure TCSTournament.Abandon(Connection: TConnection);
begin
  inherited;
  Reglament.MemberList.DeleteUser(Connection.Handle);
  fSocket.Send(Users,[DP_EVENT_ABANDON,IntToStr(Self.ID),Connection.Handle],Self);
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'You have abandoned tournament '+IntToStr(Self.ID)],nil);
end;
//==============================================================================
procedure TCSTournament.AddTournamentGame(connWhite,connBlack: TConnection; rgame: TCSReglGame);
var
  game: TGame;
begin
  game:=TGame.Create(connWhite,connBlack);

  game.EventId := Self.ID;
  game.RatedType := Self.RatedType;
  game.WhiteRating := game.White.Rating[RatedType];
  game.BlackRating := game.Black.Rating[RatedType];


  game.WhiteInitialMSec := TimeToMSec(Self.InitialTime);
  if game.WhiteInitialMSec < MSecs * 10 then game.WhiteInitialMSec := MSecs * 10;
  game.BlackInitialMSec := TimeToMSec(Self.InitialTime);
  if game.BlackInitialMSec < MSecs * 10 then game.BlackInitialMSec := MSecs * 10;
  game.WhiteIncMSec := Self.IncTime * 1000;
  game.BlackIncMSec := Self.IncTime * 1000;
  game.WhiteMSec:=game.WhiteInitialMSec;
  game.BlackMSec:=game.BlackInitialMSec;
  game.CanAbort:=false;
  game.OnResult := fGames.GameResult;
  game.Rated := Self.Rated;

  Games.Add(Game);
  Game.EventOrdNum:=Games.Count;
  CSGames.fGames.Games.Add(Game);

  rgame.GameNum:=game.GameNumber;

  SendReglGameUpdate(rgame);

  //if Reglament.CurRound>1 then
  SendGamesBorn(game.EventOrdNum);
end;
//==============================================================================
procedure TCSTournament.CheckEventFinished;
begin
  //
end;
//==============================================================================
constructor TCSTournament.Create;
begin
  inherited;
  FReglament:=TCSReglament.Create;
end;
//==============================================================================
destructor TCSTournament.Destroy;
begin
  inherited;
  FReglament.Free;
end;
//==============================================================================
procedure TCSTournament.FinishTournament;
var
  i: integer;
  sl: TStringList;
  user: TCSUser;
  msg: string;
begin
  Status:=estFinished;
  Reglament.CountRanks;
  sl:=TStringList.Create;

  if CongrMsg='' then msg:='Infiniachess congratulate winners of tournament '+Name+'!!!'
  else msg:=CongrMsg;

  fSocket.Send(fConnections.Connections,[DP_SHOUT,'','',msg],Self);

  for i:=0 to Reglament.MemberList.count-1 do begin
    user:=Reglament.MemberList[i];
    if user.RankMin=1 then sl.Add(GetNameWithTitle(user.Login,user.Title));
  end;
  if sl.Count=1 then
    fSocket.Send(fConnections.Connections,[DP_SHOUT,'','','Winner: '+sl[0]],Self)
  else begin
    fSocket.Send(fConnections.Connections,[DP_SHOUT,'','','Winners:'],Self);
    for i:=0 to sl.Count-1 do
      fSocket.Send(fConnections.Connections,[DP_SHOUT,'','',sl[i]],Self)
  end;
  fSocket.Send(fConnections.Connections,[DP_EVENT_FINISHED,IntToStr(ID)],Self);
  fAchievements.OnAchEvent(Self);
  sl.Free;
end;
//==============================================================================
procedure TCSTournament.Forfeit(Connection: TConnection; Login: string);
var
  n: integer;
begin
  inherited;
  if Reglament.GamesCount>0 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'The tournament is already started, you cannot fofreit players'],nil);
    exit;
  end;

  if ord(Connection.AdminLevel)<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'The tournament is already started, you cannot fofreit players'],nil);
    exit;
  end;

  n:=Reglament.MemberList.IndexOfUser(Login);
  if n<>-1 then
    Reglament.MemberList.DeleteUser(Login);
end;
//==============================================================================
procedure TCSTournament.GameAccept(Connection: TConnection; rgame_id: integer);
var
  rgame: TCSReglGame;
  whitename,blackname: string;
begin
  rgame:=Reglament.ReglGames[rgame_id];
  whitename:=Reglament.MemberList[rgame.WhiteNum].Login;
  blackname:=Reglament.MemberList[rgame.blackNum].Login;
  if (Connection.Handle<>whitename) and (Connection.Handle<>blackname) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,DP_MSG_NOT_INVOLVED],nil);
    exit;
  end;
  if (Connection.Handle=whitename) then rgame.WhiteAccept:=true
  else rgame.BlackAccept:=true;

  if rgame.CanStart then
    StartGames;
end;
//==============================================================================
procedure TCSTournament.GetRGameNames(rgame: TCSReglGame; var pp_WhiteName,
  pp_BlackName: string);
begin
  pp_WhiteName:=Reglament.MemberList[rgame.WhiteNum].Login;
  pp_BlackName:=Reglament.MemberList[rgame.blackNum].Login;
end;
//==============================================================================
procedure TCSTournament.SendJoinMessages(Connection: TConnection);
begin
  SendReglament(Connection);
  SendMemberList(Connection);
  SendReglGames(Connection);
  SendAcceptRequests(Connection,true);
end;
//==============================================================================
procedure TCSTournament.Join(Connection: TConnection; Mode: string);
var
  ErrMsg: string;
begin
  {if (Mode='j') and (Reglament.MemberList.IndexOfUser(Connection.Handle)=-1) then
    Member(Connection);
  exit;}
  if (Mode='j') and not UserCanJoin(Connection,ErrMsg) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,ErrMsg],nil);
    exit;
  end;

  if (Mode='j') then begin
    if (Reglament.MemberList.IndexOfUser(Connection.Handle)=-1) then
      if not Member(Connection) then
        exit;
  end else begin
    inherited;
    SendJoinMessages(Connection);
  end;
end;
//==============================================================================
function TCSTournament.Member(Connection: TConnection): Boolean;
var
  ErrMsg: string;
  rt: integer;
begin
  //inherited;
  if not UserCanJoin(Connection,ErrMsg) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,ErrMsg],nil);
    exit;
  end;

  result:=false;
  if not Tickets.HaveTicket(Connection.Handle) and (CountReglMembersNoTicket+Tickets.Count>=FMaxPeople) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Tournament '+IntToStr(ID)+' already has maximum number of members'],nil);
    exit;
  end;

  if (Status<>estWaited) and (Reglament.MemberList.IndexOfUser(Connection.Handle)=-1) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Tournament '+IntToStr(ID)+' is already started, you cannot take part in it'],nil);
    exit;
  end;

  rt:=Connection.Rating[RatedType];
  if ((rt<MinRating) or (rt>MaxRating)) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,
      Format('Your rating must be between %d and %d to join the event',[MinRating,MaxRating])],nil);
    exit;
  end;

  Reglament.MemberList.InsOrUpdUser(Connection.Handle,Connection.Title,Connection.Rating[Self.RatedType]);
  fSocket.Send(Users,[DP_EVENT_MEMBER,IntToStr(Self.ID),
    Connection.Handle,Connection.Title,IntToStr(Connection.Rating[Self.RatedType])],Self);
  inherited Join(Connection,'j');
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'You are now member of tournament '+IntToStr(Self.ID)],nil);
  SendJoinMessages(Connection);
  result:=true;
end;
//==============================================================================
procedure TCSTournament.OnGameResult(GameOrdNum: integer);
var
  game: TGame;
  rgame,newrgame: TCSReglGame;
begin
  game:=TGame(Games[GameOrdNum-1]);
  rgame:=Reglament.FindGameByNum(game.GameNumber);
  rgame.Result:=GameResult2ReglGameResult(game.RatedType,game.GameResult);
  if rgame.Result<>rgrNone then begin
    SendReglGameUpdate(rgame);
    newrgame:=Reglament.OnReglGameResult(rgame);
    if newrgame<>nil then begin
      SendReglGame(newrgame);
      StartGames;
      //SendGamesBorn(newrgame.ID);
      SendReglGameUpdate(newrgame);
      SendAcceptRequests;
    end;
    if Reglament.TournamentCompleted then
      FinishTournament
    else
      StartNextRoundIfNeed;
  end;
end;
//==============================================================================
procedure TCSTournament.Params(Connection: TConnection; CMD: TStrings);
var
  n: integer;
begin
  inherited;
  if CMD.Count<9 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    Reglament.TourType:=TCSTournamentType(StrToInt(CMD[2]));
    Reglament.RoundOrder:=TCSRoundOrder(StrToInt(CMD[3]));
    Reglament.ENumber:=StrToInt(CMD[4]);
    Reglament.AcceptTime:=StrToInt(CMD[5]);
    Reglament.NumberOfRounds:=StrToInt(CMD[6]);
    FMinPeople:=StrToInt(CMD[7]);
    FMaxPeople:=StrToInt(CMD[8]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid params'],nil);
    exit;
  end;

  //if FTourType=trtRound then

end;
//==============================================================================
procedure TCSTournament.SendEventCreated(Connections: TObjectList);
begin
  inherited;
  SendReglament;
end;
//==============================================================================
procedure TCSTournament.SendMemberList(Connection: TConnection);
var
  user: TCSUser;
  i: integer;
begin
  if Connection <> nil then MarkSendOnlyOne(Users, Connection);

  fSocket.Send(Users,[DP_EVENT_MEMBERS_START,IntToStr(Self.ID)],Self);

  for i:=0 to Reglament.MemberList.Count-1 do begin
    user:=Reglament.MemberList[i];
    if Connection <> nil then MarkSendOnlyOne(Users, Connection);
    fSocket.Send(Users,[DP_EVENT_MEMBER,IntToStr(Self.ID),
      user.Login,user.Title,IntToStr(user.Rating)],Self);
  end;

  if Connection <> nil then MarkSendOnlyOne(Users, Connection);
  fSocket.Send(Users,[DP_EVENT_MEMBERS_END,IntToStr(Self.ID)],Self);
end;
//==============================================================================
procedure TCSTournament.SendReglament(Connection: TConnection);
var
  conns: TObjectList;
begin
  if Connection <> nil then MarkSendOnlyOne(fConnections.Connections, Connection);

  fSocket.Send(fConnections.Connections,[DP_EVENT_REGLAMENT,
    IntToStr(Self.ID),
    IntToStr(ord(Reglament.TourType)),
    IntToStr(ord(Reglament.RoundOrder)),
    IntToStr(Reglament.ENumber),
    IntToStr(Reglament.NumberOfRounds),
    IntToStr(Reglament.AcceptTime)],Self);
end;
//==============================================================================
procedure TCSTournament.SendReglGame(rgame: TCSReglGame; Connection: TConnection);
var
  conns: TObjectList;
begin
  if Connection <> nil then MarkSendOnlyOne(Users, Connection);

  fSocket.Send(Users,[DP_EVENT_REGLGAME_ADD,
    IntToStr(Self.ID),
    IntToStr(rgame.ID),
    IntToStr(rgame.WhiteNum),
    IntToStr(rgame.BlackNum),
    rgame.InitTime,
    IntToStr(rgame.IncTime),
    IntToStr(rgame.GameNum),
    IntToStr(rgame.RoundNum),
    IntToStr(rgame.AddNum),
    IntToStr(ord(rgame.Result))],Self);
end;
//==============================================================================
procedure TCSTournament.SendReglGames(Connection: TConnection = nil);
var
  rgame: TCSReglGame;
  i: integer;
  conns: TObjectList;
begin
  if Connection <> nil then MarkSendOnlyOne(Users, Connection);

  fSocket.Send(Users,[DP_EVENT_REGLGAMES_START,IntToStr(Self.ID)],Self);

  for i:=0 to Reglament.GamesCount-1 do begin
    rgame:=Reglament[i];
    SendReglGame(rgame,Connection);
  end;
  if Connection <> nil then MarkSendOnlyOne(Users, Connection);
  fSocket.Send(Users,[DP_EVENT_REGLGAMES_END,IntToStr(Self.ID)],Self);
  SendAcceptRequests;
end;
//==============================================================================
procedure TCSTournament.SendReglGameUpdate(rgame: TCSReglGame);
begin
  fSocket.Send(Users,[DP_EVENT_REGLGAME_UPDATE,
    IntToStr(Self.ID),
    IntToStr(rgame.ID),
    IntToStr(rgame.GameNum),
    IntToStr(ord(rgame.Result))],Self);
end;
//==============================================================================
procedure TCSTournament.SendAcceptRequests(Connection: TConnection = nil; p_Repeat: Boolean = false);
var
  i,sec: integer;
  rgame: TCSReglGame;
  msg,whitename,blackname,fullwhitename,fullblackname: string;
  //****************************************************************************
  procedure SendRequestIfNeed(name: string; rgame_id,sec: integer; partner: string);
  var
    conn: TConnection;
  begin
    conn:=FindJoinedUser(name);
    if (conn<>nil) and ((conn=Connection) or (Connection=nil)) then
      fSocket.Send(conn,[DP_EVENT_ACCEPT_REQUEST,
        IntToStr(Self.ID),
        IntToStr(rgame_id),
        IntToStr(sec),
        partner],Self);
  end;
  //****************************************************************************
begin
  if Status<>estStarted then exit;
  for i:=0 to Reglament.GamesCount-1 do begin
    rgame:=Reglament[i];
    if not rgame.IsByeGame and (rgame.RoundNum=Reglament.CurRound)
      and not rgame.CanStart and (not rgame.RequestSent or p_Repeat)
    then begin
      sec:=trunc((rgame.StartTime-now)*24*60*60);
      GetRGameNames(rgame,whitename,blackname);
      GetRGameFullNames(rgame,fullwhitename,fullblackname);
      SendRequestIfNeed(whitename,rgame.ID,sec,fullblackname);
      SendRequestIfNeed(blackname,rgame.ID,sec,fullwhitename);
      rgame.RequestSent:=true;
    end;
  end;
end;
//==============================================================================
procedure TCSTournament.Start;
begin
  Status:=estStarted;
  Reglament.InitTime:=InitialTime;
  Reglament.IncTime:=IncTime;
  Reglament.MakeStartReglament;
  SendMemberList;
  SendReglGames;
  StartGames;
  //SendGamesBorn;
  fSocket.Send(fConnections.Connections,[DP_EVENT_STARTED,IntToStr(ID)],Self);
end;
//==============================================================================
procedure TCSTournament.StartGames;
var
  i: integer;
  connWhite,connBlack: TConnection;
  rgame,newrgame: TCSReglGame;
  whitename,blackname: string;
  Game: TGame;
begin
  i:=0;
  while i<Reglament.GamesCount do begin
    rgame:=Reglament[i];
    if (rgame.RoundNum<>Reglament.CurRound) // game of another round
      or (rgame.GameNum<>-1) // or game already started
      or (rgame.Result<>rgrNone) // or game is finished
      or not rgame.CanStart // or game cannot start (not accepted)
    then begin
      inc(i);
      continue;
    end;

    whitename:=Reglament.MemberList[rgame.WhiteNum].Login;
    blackname:=Reglament.MemberList[rgame.blackNum].Login;

    connWhite:=FindJoinedUser(whitename);
    connBlack:=FindJoinedUser(blackname);

    if (connWhite=nil) or (connBlack=nil) then begin
      if (connWhite=nil) and (connBlack=nil) then begin
        if Reglament.TourType = trtElim then
          rgame.Result:=rgrBlackWin
        else
          rgame.Result:=rgrDraw
      end else if connWhite=nil then rgame.result:=rgrBlackWin
      else rgame.Result:=rgrWhiteWin;

      Reglament.OnReglGameResult(rgame);
      SendReglGameUpdate(rgame);
      newrgame:=Reglament.OnReglGameResult(rgame);
      if newrgame<>nil then
        SendReglGame(newrgame);
      continue;
    end;

    AddTournamentGame(connWhite,connBlack,rgame);
    inc(i);
  end;

  if Reglament.TournamentCompleted then
    FinishTournament
  else
    StartNextRoundIfNeed;
end;
//==============================================================================
procedure TCSTournament.StartNextRoundIfNeed;
begin
  if (Reglament.CurRoundCompleted) then begin
    if ShoutEveryRound and (FLastRoundShouted < Reglament.CurRound) and (Reglament.CurRound>0) then
      ShoutRound;
    if not Paused then begin
      Reglament.NextRound;
      fSocket.Send(Users,[DP_SERVER_MSG,DP_ERR_0,Format('Round %d started',[Reglament.CurRound])],Self);
      SendReglGames;
      StartGames;
    end;
  end;
end;
//==============================================================================
procedure TCSTournament.OnTimer;
begin
  inherited;
  if Status=estStarted then
    StartGames;
end;
//==============================================================================
procedure TCSTournament.GetRGameFullNames(rgame: TCSReglGame;
  var pp_WhiteName, pp_BlackName: string);
var
  user: TCSUser;
begin
  user:=Reglament.MemberList[rgame.WhiteNum];
  pp_WhiteName:=Format('%s %d',[GetNameWithTitle(user.Login,user.Title),user.Rating]);
  user:=Reglament.MemberList[rgame.BlackNum];
  pp_BlackName:=Format('%s %d',[GetNameWithTitle(user.Login,user.Title),user.Rating]);
end;
//==============================================================================
procedure TCSTournament.SetDefaultMinMaxPeople;
begin
  FMinPeople:=2;
  case Reglament.TourType of
    trtMatch: FMaxPeople:=2;
    trtRound: FMaxPeople:=6;
  else
    FMaxPeople:=1000;
  end;
end;
//==============================================================================
procedure TCSTournament.UserLeave(Connection: TConnection);
begin
  inherited;
  if Status=estWaited then
    Abandon(Connection);
end;
//==============================================================================
function TCSTournament.FreeSlots: integer;
begin
  if MaxPeople>=1000 then result:=-1
  else result:=MaxPeople-Tickets.Count-CountReglMembersNoTicket;
end;
//==============================================================================
procedure TCSTournament.Resume(Connection: TConnection);
begin
  inherited;
  if not Paused then StartNextRoundIfNeed;
end;
//==============================================================================
function TCSTournament.UserCanJoin(Connection: TConnection; var pp_ErrMsg: string): Boolean;
begin
  result:=true;
  pp_ErrMsg:='';
  if Reglament.TourType = trtMatch then begin
    if (FReserv.Count>0) and (FReserv.IndexOf(lowercase(Connection.Handle))=-1) then begin
      result:=false;
      pp_ErrMsg:='You are not authorized to join this event';
    end;
  end;
end;
//==============================================================================
procedure TCSTournament.RestoreGames(Connection: TConnection);
begin
  inherited;
  SendUserJoinMessages(Connection);
end;
//==============================================================================
function TCSTournament.CountReglMembersNoTicket: integer;
var
  i: integer;
begin
  result:=0;
  for i:=0 to Reglament.MemberList.Count-1 do
    if not Tickets.HaveTicket(Reglament.MemberList[i].Login) then
      inc(result);
end;
//==============================================================================
procedure TCSTournament.ShoutRound;
var
  msg,s,s1: string;
  i,j,n: integer;
  user: TCSUser;
begin
  if not (Reglament.TourType in [trtRound,trtSwiss]) then exit;
  FLastRoundShouted:=Reglament.CurRound;
  Reglament.CountRanks;

  if CongrMsg='' then msg:='News of tournament '+Name+': Round '+IntToStr(Reglament.CurRound)+'is finished!';

  fConnections.SetToSendTSER;
  fSocket.Send(fConnections.Connections,[DP_SHOUT,'','',msg],Self);
  fConnections.SetToSendTSER;
  fSocket.Send(fConnections.Connections,[DP_SHOUT,'','','Current Standing (first five places)'],Self);

  for i:=1 to 5 do begin
    s:=''; n:=0;
    for j:=0 to Reglament.MemberList.Count-1 do begin
      user:=Reglament.MemberList[j];
      if user.RankMin = i then begin
        s:=s+GetNameWithTitle(user.Login,user.Title)+', ';
        inc(n);
      end;
    end;

    if n=0 then continue;
    SetLength(s,length(s)-2);
    if n=1 then s1:=IntToStr(i)
    else s1:=Format('%d-%d',[i,i+n-1]);

    s1:=lpad(s1,8,' ');
    msg:=s1+': '+s;
    fConnections.SetToSendTSER;
    fSocket.Send(fConnections.Connections,[DP_SHOUT,'','',msg],Self);
  end;
end;
//==============================================================================
procedure TCSTournament.SaveFinishedToDB;
var
  i,rgame_id: integer;
  GM: TGame;
  RG: TCSReglGame;
  GameId: Variant;
begin
  fDB.ExecProc('dbo.proc_ev_finish',[ID]);
  Reglament.DBReglID:=fDB.ExecProc('dbo.proc_tour_reglament',
    [ID,
     Reglament.InitTime,
     Reglament.IncTime,
     ord(Reglament.RoundOrder),
     ord(Reglament.TourType),
     Reglament.NumberOfRounds,
     Reglament.ENumber,
     Reglament.AcceptTime]);

  for i:=0 to Reglament.MemberList.Count-1 do
    fDB.ExecProc('dbo.proc_tour_users',
      [Reglament.DBReglId,
       i,
       Reglament.MemberList[i].Login]);

  for i:=0 to Reglament.ReglGames.Count-1 do begin
    RG:=Reglament.ReglGames[i];
    if RG.IsByeGame then GameId:=null
    else begin
      GM:=fGames.GetGame(RG.GameNum);
      if GM = nil then GameId:=null
      else GameId:=GM.DbGameId;
    end;
    RG.DB_Id:=fDB.ExecProc('dbo.proc_tour_games',
      [Reglament.DBReglId,
       Reglament.MemberList[RG.WhiteNum].Login,
       Reglament.MemberList[RG.BlackNum].Login,
       RG.WhiteNum,
       RG.BlackNum,
       RG.InitTime,
       RG.IncTime,
       RG.GameNum,
       RG.RoundNum,
       RG.AddNum,
       ord(RG.Result),
       RG.StartTime,
       BoolTo_(RG.IsByeGame,1,0)]);

    fDB.ExecProc('dbo.proc_ev_game_links',
      [GameId, Self.ID, RG.DB_Id]);
  end;
end;
//==============================================================================
end.

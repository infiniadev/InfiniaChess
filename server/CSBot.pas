unit CSBot;

interface

uses CSEngine, SysUtils, classes, CSTypes, Graphics;

type
  TBotInfo = class
  public
    GameHiStrings: string;
    GameByeStrings: string;
    GameByeProb: real;
    GameByeResList: string;
    GameByeMovesLimit: integer;
    ResignScore: real;
    DrawSuggestMovesLimit: integer;
    DrawSuggestScore: real;
    DrawAcceptScore: real;
    SeekTypes: string;
    SeeksPerTime: integer;
  end;

  TBot = class
  private
    LastMoveTime: TDateTime;
    Connection: TObject;
    Game: TObject;
    slGameHiSent: TStrings;
    IllegalMovesCount: integer;
    FEngineInfo: TEngineInfo;
    FBotInfo: TBotInfo;
    Engine: TEngine;
    RealThinkTime: integer; // real time for engine to think
    PublicThinkTime: integer; // public time to show to users
    PlayingGamesAllowed: Boolean;
    SeekPostedTime: TDateTime;
    SeeksPostedCnt: integer;
    LongMatch: record
      Opponent: string;
      GamesCount: integer;
      GamesRest: integer;
      InitTIme: string;
      IncTime: integer;
    end;

    procedure SetEngineInfo(const Value: TEngineInfo);
    procedure SendMove(p_Move: TEngineMove; p_Delay, p_TimeToThink: integer);
    procedure SendRandomGameString(p_GameNumber: integer;
      p_Strings: array of string; p_Delay: integer);
    function GetOpponent: string;
    procedure Resign;
    procedure StartEngine;
    procedure OnEngineTerminate(Sender: TObject);
    procedure SetThinkTimes;
    procedure OnMoveDone;
    procedure OnNewEngineMove(Sender: TObject; p_Move: TEngineMove);
    procedure SetBotInfo(const Value: TBotInfo);
  public
    constructor Create(p_Connection: TObject);
    destructor Destroy; override;
    procedure DoAction;
    procedure OnGameStarted(p_Game: TObject);
    procedure OnGameResult(p_Game: TObject);
    procedure OnOpponentMove(p_Move: TEngineMove);
    procedure OnIllegalMove;
    procedure OnMatch(p_Offer: TObject);
    procedure OnOpponentDisconnect;
    procedure OnOrder(p_AdminConnection: TObject; CMD: TStrings);
    procedure SendRandomSeek;

    property EngineInfo: TEngineInfo write SetEngineInfo;
    property BotInfo: TBotInfo write SetBotInfo;
  end;

implementation

uses CSGame, CSConnection, CSConnections, CSGames, CSCommand, CSLib, CSConst,
  CSOffer, CSOffers, CSSocket;

const
  ILLEGAL_MOVES_LIMIT = 3;
  MOVES_FIRST_LIMIT = 40;
  TIME_SPENT_FIRST_LIMIT = 0.9;
  RANDOM_DEVIATION = 0.2;
  MIN_THINK_TIME = 1000;
  REAL_TIME_KOEF = 0.25;
  REAL_TIME_MAX = 5000;
  OPENING_MOVES_COUNT = 4;

var
  GAME_HI_STRINGS: array [1..4] of string =
    ('hi', 'hi, gl', 'Hi gl', 'Hi');
  GAME_BYE_STRINGS: array [1..1] of string =
    ('gg');
//==============================================================================
{ TCSBot }

constructor TBot.Create(p_Connection: TObject);
begin
  Connection := p_Connection;
  slGameHiSent := TStringList.Create;
  IllegalMovesCount := 0;
  PlayingGamesAllowed := true;
  SeeksPostedCnt := 0;
  SeekPostedTime := Date + Time;
end;
//==============================================================================
destructor TBot.Destroy;
begin
  slGameHiSent.Free;
  FEngineInfo.Free;
  FBotInfo.Free;
  inherited;
end;
//==============================================================================
procedure TBot.DoAction;
var
  sl: TStringlist;
begin
  if (LongMatch.GamesRest > 0) and (Game = nil) then begin
    fCommand.AddDeferredCommand(fOffers.CMD_Match, TConnection(Connection),
      [LongMatch.Opponent, LongMatch.InitTime, LongMatch.IncTime], 1000, nil);
    dec(LongMatch.GamesRest);
  end;

  if PlayingGamesAllowed and not Assigned(Game) and (SeeksPostedCnt < FBotInfo.SeeksPerTime) then
    SendRandomSeek;
    {fCommand.AddDeferredCommand(fOffers.CMD_Seek, TConnection(Connection),
      [1, 0, 1], 3000, nil);
    fCommand.AddDeferredCommand(fOffers.CMD_Seek, TConnection(Connection),
      [3, 0, 1], 4000, nil);
    fCommand.AddDeferredCommand(fOffers.CMD_Seek, TConnection(Connection),
      [5, 0, 1], 5000, nil);
    fCommand.AddDeferredCommand(fOffers.CMD_Seek, TConnection(Connection),
      [15, 0, 1], 6000, nil);}
end;
//==============================================================================
function TBot.GetOpponent: string;
var
  GM: TGame;
  MyLogin: string;
begin
  if Assigned(Game) then begin
    GM := TGame(Game);
    MyLogin := TConnection(Connection).Handle;
    if GM.WhiteLogin = MyLogin then result := GM.BlackLogin
    else result := GM.WhiteLogin;
  end else
    result := '';
end;
//==============================================================================
procedure TBot.SetThinkTimes;
var
  InitTime, TimeRest, IncTime: integer; // miliseconds
  MovesDone, TimeAfterFirstLimit, Deviation: integer;
  GM: TGame;
begin
  if not Assigned(Game) then exit;
  GM := TGame(Game);

  MovesDone := (GM.Moves.Count - 1) div 2;
  if GM.White = Connection then begin
    InitTime := GM.WhiteInitialMSec;
    TimeRest := GM.WhiteMSec;
    IncTime := GM.WhiteIncMSec;
    MovesDone := MovesDone + GM.Moves.Count mod 2;
  end else begin
    InitTime := GM.BlackInitialMSec;
    TimeRest := GM.BlackMSec;
    IncTime := GM.BlackIncMSec;
  end;
  TimeAfterFirstLimit := Trunc(InitTime * (1 - TIME_SPENT_FIRST_LIMIT));

  if (MovesDone < MOVES_FIRST_LIMIT) then
    if TimeRest < TimeAfterFirstLimit then
      PublicThinkTime := 1000 + IncTime
    else
      PublicThinkTime := trunc((TimeRest - TimeAfterFirstLimit) * 1.0 / (MOVES_FIRST_LIMIT - MovesDone)) + IncTime
  else
    if IncTime > 0 then
      PublicThinkTime := IncTime
    else
      PublicThinkTime := trunc(TimeAfterFirstLimit / 40.0);

  Deviation := trunc(PublicThinkTime * RANDOM_DEVIATION);
  PublicThinkTime := PublicThinkTime - Deviation + Random(2 * Deviation);
  if PublicThinkTime < MIN_THINK_TIME then PublicThinkTime := MIN_THINK_TIME;

  RealThinkTime := trunc(PublicThinkTime * REAL_TIME_KOEF);
  if RealThinkTime > REAL_TIME_MAX  then RealThinkTime := REAL_TIME_MAX;

  if MovesDone <= OPENING_MOVES_COUNT then
    PublicThinkTime := MIN_THINK_TIME;
end;
//==============================================================================
procedure TBot.OnEngineTerminate(Sender: TObject);
begin
  if Assigned(Game) then OnIllegalMove;
  Engine.Free;
end;
//==============================================================================
procedure TBot.OnGameResult(p_Game: TObject);
begin
  if TGame(p_Game).GameResult = grNone then exit;
  if not (TGame(p_Game).GameResult in [grAborted, grAdjourned]) and
    (TGame(p_Game).Moves.Count >= 60)
  then
    SendRandomGameString(TGame(Game).GameNumber, GAME_BYE_STRINGS, 3000);
  fCommand.AddDeferredCommand(fGames.CMD_Quit, TConnection(Connection),
    [TGame(p_Game).GameNumber], 4000, nil);
  Game := nil;
  Engine.Terminate;
end;
//==============================================================================
procedure TBot.OnGameStarted(p_Game: TObject);
var
  Opponent: string;
begin
  if Assigned(Game) then
    raise exception.Create(
      Format('TBot.OnGameStarted: game #%d is already started, but game #%d try to be started too',
        [TGame(Game).GameNumber, TGame(p_Game).GameNumber]));
  Game := p_Game;
  StartEngine;

  Opponent := GetOpponent;
  if slGameHiSent.IndexOf(Opponent) = -1 then begin
    SendRandomGameString(TGame(Game).GameNumber, GAME_HI_STRINGS, 4000);
    slGameHiSent.Add(Opponent);
  end;
  SeeksPostedCnt := 0;
end;
//==============================================================================
procedure TBot.OnIllegalMove;
begin
  Resign;
  inc(IllegalMovesCount);
  if IllegalMovesCount >= ILLEGAL_MOVES_LIMIT then begin
    PlayingGamesAllowed := false;
    fCommand.AddDeferredCommand(fConnections.CMD_Bye,
      TConnection(Connection), [], 5000, nil);
  end;
end;
//==============================================================================
procedure TBot.OnMatch(p_Offer: TObject);
var
  offer: TOffer;
  TimeFor40Moves: integer;
  err: string;
begin
  offer := TOffer(p_Offer);
  TimeFor40Moves := TimeToMSec(offer.InitialTime) + 40 * offer.IncTime * 1000;
  if (offer.RatedType in [rtStandard, rtBlitz, rtBullet])
    and (TimeFor40Moves >= 60000) and (TimeFor40Moves <= 30 * 60000)
    and fOffers.CanAccept(offer, TConnection(Connection), err)
    and (Game = nil) and PlayingGamesAllowed
  then
      fCommand.AddDeferredCommand(fOffers.CMD_Accept,
        TConnection(Connection), [offer.OfferNumber], 3000, nil)
  else
    fCommand.AddDeferredCommand(fOffers.CMD_Decline,
      TConnection(Connection), [offer.OfferNumber], 3000, nil);
end;
//==============================================================================
procedure TBot.OnMoveDone;
begin
  LastMoveTime := Now;
end;
//==============================================================================
procedure TBot.OnNewEngineMove(Sender: TObject; p_Move: TEngineMove);
var
  MSecFromLastMove, Delay: integer;
begin
  if LastMoveTime = 0 then MSecFromLastMove := 0
  else MSecFromLastMove := GetDateDiffMSec(LastMoveTime, Now);

  Delay := PublicThinkTime - MSecFromLastMove;

  SendMove(p_Move, Delay, PublicThinkTime);
  OnMoveDone;
end;
//==============================================================================
procedure TBot.OnOpponentDisconnect;
begin
  if not Assigned(Game) then exit;
  fCommand.AddDeferredCommand(fGames.CMD_Win, TConnection(Connection),
    [TGame(Game).GameNumber], 3000, nil);
end;
//==============================================================================
procedure TBot.OnOpponentMove(p_Move: TEngineMove);
begin
  OnMoveDone;
  SetThinkTimes;
  Engine.TimeToThink := RealThinkTime;
  Engine.Move(p_Move);
end;
//==============================================================================
procedure TBot.OnOrder(p_AdminConnection: TObject; CMD: TStrings);
var
  order: string;
begin
  order := lowercase(CMD[2]);
  if order = 'die' then begin
    fCommand.AddDeferredCommand(fConnections.CMD_Bye,
      TConnection(Connection), [], 5000, nil);
    fSocket.Send(TConnection(p_AdminConnection), [DP_SERVER_MSG, DP_ERR_0,
      CMD[1] + ' is dying now...']);
  end else if order = 'longmatch' then begin
    try
      LongMatch.Opponent := CMD[3];
      LongMatch.GamesRest := StrToInt(CMD[4]);
      LongMatch.GamesCount := LongMatch.GamesRest;
      LongMatch.InitTime := CMD[5];
      LongMatch.IncTime := StrToInt(CMD[6]);
    except
      fSocket.Send(TConnection(p_AdminConnection), [DP_SERVER_MSG, DP_ERR_2,
        'Wrong argument list']);
    end;
  end else if order = 'startgames' then
    PlayingGamesAllowed := true
  else if order = 'stopgames' then
    PlayingGamesAllowed := false
  else if order = 'resign' then
    Resign
  else
    fSocket.Send(TConnection(p_AdminConnection), [DP_SERVER_MSG, DP_ERR_1,
      CMD[1] + ' does not understand your order']);
end;
//==============================================================================
procedure TBot.Resign;
begin
  if not Assigned(Game) then exit;
  fCommand.AddDeferredCommand(fGames.CMD_Resign, TConnection(Connection),
    [TGame(Game).GameNumber], 1000, nil);
end;
//==============================================================================
procedure TBot.SendMove(p_Move: TEngineMove; p_Delay, p_TimeToThink: integer);
var
  conn: TConnection;
  GM: TGame;
  len, ColorKoef, FromSqr, ToSqr, Promo: integer;
  Position: TPosition;
  MoveType: TMoveType;
begin
  if not Assigned(Game) then exit;
  
  conn := TConnection(Connection);
  GM := TGame(Game);

  if GM.GameMode <> gmLive then exit;
  if pos('@', p_Move) > 0 then exit;


  try
    if conn = GM.White then ColorKoef := 1
      else ColorKoef := -1;
    
      len := length(p_Move);
      if not len in [4,5] then
        raise exception.create('TGame.OnNewEngineMove: wrong move ''' + p_Move + '''');
    
      FromSqr := TMove.CoordStr2Num(copy(p_Move, 1, 2));
      ToSqr := TMove.CoordStr2Num(copy(p_Move, 3, 2));
      if GM.Moves.Count = 0 then Position := STARTING_POSITION
      else Position := TMove(GM.Moves[GM.Moves.Count - 1]).FPosition;
      MoveType := TMove.GetMoveType(Position, FromSqr, ToSqr);
    
      if len = 4 then Promo := 0
      else Promo := ColorKoef * TMove.PromoStr2Num(p_Move[5]);
    
      fCommand.AddDeferredCommand(fGames.CMD_Move, conn,
        [GM.GameNumber, FromSqr, ToSqr, Promo, MoveType, '',
         p_TimeToThink, 0],
         p_Delay, OnIllegalMove);
  except
    on E: Exception do
      OnIllegalMove;
  end;
end;
//==============================================================================
procedure TBot.SendRandomGameString(p_GameNumber: integer;
  p_Strings: array of string; p_Delay: integer);
var
  n: integer;
begin
  n := Random(High(p_Strings) + 1);
  if n > 0 then begin// if n = 0, skip saying
    fCommand.AddDeferredCommand(fGames.CMD_Say, TConnection(Connection),
      [clYellow, p_GameNumber, p_Strings[n]], p_Delay, nil);;
  end;
end;
//==============================================================================
procedure TBot.SetEngineInfo(const Value: TEngineInfo);
begin
  FEngineInfo := Value;
end;
//==============================================================================
procedure TBot.SetBotInfo(const Value: TBotInfo);
begin
  FBotInfo := Value;
end;
//==============================================================================
procedure TBot.StartEngine;
var
  ExeNameWithDir, LogFileName: string;
begin
  ExeNameWithDir := MAIN_DIR + 'engines\' + FEngineInfo.DirName + '\' +
    FEngineInfo.ExeName;
  LogFileName := MAIN_DIR + 'engines\!logs\' +
    FormatDateTime('yyyy-mm-dd (hh-nn-ss-zzz)', SysUtils.Date+SysUtils.Time) + ' ' +
    TGame(Game).WhiteLogin + '-' + TGame(Game).BlackLogin + '.log';

  Engine := TEngine.Create(ExeNameWithDir, LogFileName, FEngineInfo.OpeningFileName);
  Engine.OnNewEngineMove := Self.OnNewEngineMove;
  Engine.SetStartParams(FEngineInfo.Params);
  Engine.UseOpenings:= FEngineInfo.OpeningFileName <> '';
  Engine.Connection := Connection;
  Engine.Game := Self;
  Engine.Execute;

  Engine.StartNewGame;

  if TGame(Game).White = Connection then begin
    SetThinkTimes;
    Engine.TimeToThink := RealThinkTime;
    Engine.MakeFirstMove;
  end;
end;
//==============================================================================
procedure TBot.SendRandomSeek;
var
  sl: TStringList;
  n, IncTime: integer;
  s, InitTime: string;
begin
  if GetDateDiffMSec(SeekPostedTime, Now) < 2000 then exit;

  sl := TStringList.Create;
  try
    Str2StringList(FBotInfo.SeekTypes, sl, ';');
    if sl.Count = 0 then exit;
    s := sl[Random(sl.Count)];
    n := pos('-', s);
    InitTime := copy(s, 1, n-1);
    IncTime := StrToInt(copy(s, n+1, 255));
    if fOffers.OfferExistsByTime(InitTime, IncTime) then exit;

    fCommand.AddDeferredCommand(fOffers.CMD_Seek, TConnection(Connection),
      [InitTime, IncTime, 1], 1000 + Random(6000), nil);

    SeekPostedTime := Now;
    inc(SeeksPostedCnt);
  finally
    sl.Free;
  end;
end;
//==============================================================================
end.

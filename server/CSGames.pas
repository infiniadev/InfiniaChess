{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSGames;

interface

uses
  Classes, Contnrs, CSConnection, CSGame, CSOffer, SysUtils, CSConst;

const
  { Make sure that these arrays are in alignment with the TGameResult type
    found in CSGame }
  RESULTCODES: array [0..13] of string =
    (DP_CODE_NO_RESULT, DP_CODE_ABORTED, DP_CODE_ADJOURNED, DP_CODE_DRAW,
    DP_CODE_WHITE_RESIGNS, DP_CODE_BLACK_RESIGNS,
    DP_CODE_WHITE_CHECKMATED, DP_CODE_BLACK_CHECKMATED,
    DP_CODE_WHITE_STALEMATED, DP_CODE_BLACK_STALEMATED,
    DP_CODE_WHITE_FORFEITS_TIME, DP_CODE_BLACK_FORFEITS_TIME,
    DP_CODE_WHITE_FORFEITS_NETWORK, DP_CODE_BLACK_FORFEITS_NETWORK);

type
  TGames = class(TObject)
  private
    { Private declarations }
    FGames: TObjectList;

    function ValidFEN(const Value: string): Boolean;

  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    procedure GameResult(Sender: TObject);
    function IndexOf(const GameNumber: Integer): Integer; overload;
    function IndexOf(const Player: string): Integer; overload;
    function GetGame(const GameNumber: Integer): TGame; overload;
    function GetGame(const Player: string): TGame; overload;
    procedure SaveGame(GM: TGame);

    procedure CMD_Abort(var Connection: TConnection; const CMD: TStrings);
    procedure CMD_AckFlag(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Adjourn(var Connection: TConnection; const CMD: TStrings);
    procedure CMD_AdjournAll(var Connection: TConnection; const CMD: TStrings);
    procedure CMD_DemoBoard(var Connection: TConnection; const CMD: TStrings);
    procedure CMD_Draw(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_FEN(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Flag(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Forward(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Include(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Kibitz(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Lock(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Markers(var Connection: TConnection; var CMD: TStrings;
      const MarkerType: Integer);
    procedure CMD_Moretime(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Move(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Observe(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Primary(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Quit(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Resign(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Revert(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Say(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Takeback(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_UnLock(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Whisper(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_ZeroTime(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Win(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Disconnect(var Connection: TConnection; const CMD: TStrings);
    procedure CreateGame(
      var Offer: TOffer;
      WL: string = '';
      WT: string = '';
      WR: integer = 0;
      BL: string = '';
      BT: string = '';
      BR: integer = 0);
    procedure LaunchGame(var Connection: TConnection; var Game: TGame);
    procedure Release(var Connection: TConnection; FreeAll: Boolean);
    procedure RestoreGames(var Connection: TConnection);
    procedure SendGames(var Connection: TConnection);
    function UserIsPlaying(Connection: TConnection): Boolean;
    procedure SetFlagEventResults;
    procedure SetDisconnectionTime(Connection: TConnection);
    procedure CheckTimeForfeits;
    procedure Quit(var Game: TGame; var Connection: TConnection);

    property Games: TObjectList read FGames;

  published
    { Published declarations }
  end;

var
  fGames: TGames;

implementation

uses
  CSService, CSConnections, CSDb, CSSocket, CSOffers, CSGameSaveThread, CSEvents,
  CSLib, CSEvent, CSLecture, CSAchievements;

const
  { Position of DG element inside a CMD. Make sure to verify these before
    using as not all CMD's are the same. }
  GAME_NUM = 1; { All Commands }
  ACK_MSEC = 2; { AckFlag }
  FROM_SQR = 2; { Move }
  TO_SQR = 3; { Move }
  MOVE_PROMO = 4; { Move }
  MOVE_TYPE = 5; { Move }
  MOVE_PGN = 6; { Move }
  MOVE_MSEC = 7; { Move }
  GAME_MSG = 2; { Kibitz, Whisper, Say }
  TAKEBACK_COUNT = 2; { Takeback, Back }
  FORWARD_COUNT = 2; { Forward }
  INCLUDE_PLAYER = 2; { /Inclue }

//______________________________________________________________________________
function TGames.GetGame(const GameNumber: Integer): TGame;
var
  Index: Integer;
begin
  Result := nil;
  Index := IndexOf(GameNumber);
  if Index > -1 then Result := TGame(FGames[Index]);
end;
//______________________________________________________________________________
function TGames.GetGame(const Player: string): TGame;
var
  Index: Integer;
begin
  Result := nil;
  Index := IndexOf(Player);
  if Index > -1 then Result := TGame(FGames[Index]);
end;
//______________________________________________________________________________
function TGames.IndexOf(const GameNumber: Integer): Integer;
var
  //L, H, I, C: Integer;
  i: integer;
begin
  { Binary search of the FGames list. Finds the index of the GameNumber
    param. -1 if not found. This only works because GameNumbers are added to
    FGames serially !!!}

  for i:=FGames.Count-1 downto 0 do begin
    result:=i;
    if TGame(FGames[i]).GameNumber = GameNumber then exit;
  end;
  result:=-1;
  {Result := -1;
  L := 0;
  H := FGames.Count - 1;
  while L <= H do
    begin
      I := (L + H) shr 1;
      C := TGame(FGames[I]).GameNumber - GameNumber;
      if C < 0 then
        L := I + 1
      else
        begin
          H := I - 1;
          if C = 0 then
            begin
              Result := I;
              Break;
            end;
        end;
    end;}
end;
//______________________________________________________________________________
function TGames.IndexOf(const Player: string): Integer;
var
  i: integer;
  Game: TGame;
  sPlayer: string;
begin
  result:=-1;
  sPlayer:=lowercase(Player);
  for i:=FGames.Count-1 downto 0 do begin
    Game:=TGame(FGames[i]);
    if Assigned(Game) and (sPlayer=lowercase(Game.WhiteLogin)) or (sPlayer=lowercase(Game.BlackLogin)) then begin
      result:=i;
      exit;
    end;
  end;
end;
//______________________________________________________________________________
function TGames.ValidFEN(const Value: string): Boolean;
var
  Index, Section, Total: Integer;
  FEN: TStringList;
label CleanUp;
begin
  { Checks the FORMAT of a FEN string. Not the legitimacy of caslte rights,
    etc..}

  { Must prove true }
  Result := False;

  { Break apart the FEN string }
  FEN := TStringList.Create;
  FEN.CommaText := Value;

  { FEN must contain six sections }
  if FEN.Count <> 6 then goto CleanUp;

  Section := 0;
  Total := 0;
  { Examine the first paramter. Each subsection must total 8. The whole section
  must total 64.}
  for Index := 1 to Length(FEN[0]) do
    begin
      case FEN[0][Index] of
        'K', 'Q', 'B', 'N', 'R', 'P', 'k', 'q', 'b', 'n', 'r', 'p': Inc(Section);
        '/': if Section = 8 then Section := 0 else goto CleanUp;
        '1'..'8': Section := Section + StrToInt(Value[Index]);
      else
        { Invalid character }
        goto CleanUp;
      end; { Case Of }
      Inc(Total);
      if (Section > 8) or (Total > 64) then goto CleanUp;
    end;
  if Section < 8 then goto CleanUp;

  { Color }
  case FEN[1][1] of
    'w', 'b': { Correct. Do Nothing };
  else
    goto CleanUp;
  end;

  { Castle rights }
  for Index := 1 to Length(FEN[2]) -1 do
    case FEN[2][Index] of
      'K', 'Q', 'k', 'q', '-': { Correct. Do Noting };
    else
      goto CleanUp;
    end;

  { Enpassent }
  case Length(FEN[3]) of
    1: if FEN[3][1] <> '-' then goto CleanUp;
    2: if not (FEN[3][1] in ['a'..'h']) or not (FEN[3][2] in ['3', '6']) then
        goto CleanUp;
  else
    goto CleanUp;
  end;

  { Repeatable move count, do nothing }
  Val(FEN[4][1], Total, Index);
  if Index <> 0 then goto CleanUp;

  { Full move number, do nothing }
  Val(FEN[5][1], Total, Index);
  if Index <> 0 then goto CleanUp;

  Result := True;

CleanUp:
  if Assigned(FEN) then
    begin
      FEN.Clear;
      FEN.Free;
    end;
end;
//______________________________________________________________________________
procedure TGames.GameResult(Sender: TObject);
var
  Connection: TConnection;
  Game: TGame;
  Result, _WhiteRating, _BlackRating,n: Integer;
  _WhiteProvisional, _BlackProvisional: Boolean;
  s: string;
  th: TGameSaveThread;
begin
  Game := TGame(Sender);
  { Announce the GameResult to the players/observers. }
  with Game do fSocket.Send(Connections, [DP_GAME_RESULT, IntToStr(GameNumber),
    RESULTCODES[Ord(GameResult)]],Game);

  { Adjust the ratings. }
  with Game do
    if not (GameResult in [grNone, grAborted, grAdjourned])
    and ((White.LoginID > 0) or (Black.LoginID > 0)) then
      begin
        { DB call calculates, adjusts and stores ratings on the server. }
        Result := fDB.AdjustRating(Game, _WhiteRating, _BlackRating,
          _WhiteProvisional, _BlackProvisional);
        case Result of
          { -2 No rating change }
          { -3 Overused Opponent for provisional rating. }
          { -4 Logins match. }
          { DB_ERROR DB call failure. }
          DB_ERROR, -5, -4, -3, -2:
            s := DP_MSG_NO_RATING_ADJUSTMENTS;
        else
          begin
            { Adjust the local ratings. }
            White.Rating[RatedType] := _WhiteRating;
            Black.Rating[RatedType] := _BlackRating;
            White.Provisional[RatedType] := _WhiteProvisional;
            Black.Provisional[RatedType] := _BlackProvisional;

            if RealGameResult=1 then begin
              White.Stats[ord(RatedType),0]:=White.Stats[ord(RatedType),0]+1;
              Black.Stats[ord(RatedType),1]:=Black.Stats[ord(RatedType),0]+1;
            end else if RealGameresult=-1 then begin
              Black.Stats[ord(RatedType),0]:=Black.Stats[ord(RatedType),0]+1;
              White.Stats[ord(RatedType),1]:=White.Stats[ord(RatedType),0]+1;
            end;

            fSocket.SmartSend(fConnections.Connections, fConnections.OldLoginTransfer,
              [DP_RATING2, White.Handle, White.RatingString, White.ProvString], White);
            fSocket.SmartSend(fConnections.Connections, fConnections.OldLoginTransfer,
              [DP_RATING2, Black.Handle, Black.RatingString, Black.ProvString], Black);
            fSocket.SmartSend(fConnections.Connections, fConnections.NewLoginTransfer,
              [DP_RATING2, White.LoginID, White.RatingString, White.ProvString], White);
            fSocket.SmartSend(fConnections.Connections, fConnections.NewLoginTransfer,
              [DP_RATING2, Black.LoginID, Black.RatingString, Black.ProvString], Black);

            s := Format(DP_MSG_RATING_ADJUSTMENTS, [WhiteLogin, _WhiteRating,
              BlackLogin, _BlackRating]);
          end;
        end;
        fSocket.Send(Connections, [DP_GAME_MSG, IntToStr(GameNumber),
          DP_ERR_0, s],Game);
      end;

  { Send the GameResult to all connections. }
  with Game do fSocket.Send(fConnections.Connections,
    [DP_GAME_RESULT, IntToStr(GameNumber), RESULTCODES[Ord(GameResult)]],Game);

  SaveGame(Game);

  if Game.EventId<>0 then
    fEvents.OnGameResult(Game);

  fConnections.UnFrozeFollow(Game.White);
  fConnections.UnFrozeFollow(Game.Black);

  { Save the Game }
  //Game:=nil;
end;
//______________________________________________________________________________
procedure TGames.Quit(var Game: TGame; var Connection: TConnection);
var
  _Connection: TConnection;
  Index: Integer;
begin
  { Check to see the connection leaving is a player in a live game, if so assign
    a game result }
  with Game do
    begin
      if ((White = Connection) or (Black = Connection))
      and (GameMode = gmLive) then
        begin
          { Determine who's leaving and assign blame (GameResult) }
          if CanAbort then
            GameResult := grAborted
          else
            begin
              if White = Connection then
                begin
                  if not Assigned(Connection.Socket) then
                    //GameResult := grWhiteForfeitsOnNetwork
                    MakeDisconnectChoise(Black)
                  else
                    GameResult := grWhiteResigns;
                end
              else
                { Must be the black player }
                begin
                  if not Assigned(Connection.Socket) then
                    //GameResult := grBlackForfeitsOnNetwork
                    MakeDisconnectChoise(White)
                  else
                    GameResult := grBlackResigns;
                end;
            end;
        end;

      { Now remove the player from the game }
      if White = Connection then White := nil;
      if Black = Connection then Black := nil;

      { Since both player variables must be assigned, have the remaining player
        assume both roles }
      if Assigned(White) and (Black = nil) then
        Black := White;
      if (White = nil) and Assigned(Black) then
        White := Black;

      { If no players (or examiners) are left kill the game for all players/
        observers }
      if (White = nil) and (Black = nil) then
        begin
          if Game.EventId=0 then begin
            { Send Perish to to all game observers. }
            fSocket.Send(Connections, [DP_GAME_PERISH, IntToStr(GameNumber)],Game);

            { Send the Perish2 message to all filtered Connections. }
            { ??? fSocket.Buffer := True; }
            fSocket.Send(fConnections.Connections, [DP_GAME_PERISH2,
              IntToStr(GameNumber)],Game);
            { ??? fSocket.Buffer := False; }

            { Finally Remove / Destroy objects. Make sure this is last. }
            for Index := 0 to Connections.Count -1 do
              TConnection(Connections[Index]).RemoveGame(Game);
            Index := IndexOf(Game.GameNumber);
            FGames.Delete(Index);
          end;
        end
      else
        { Remove just the passed Connection  }
        begin
          { Remove Connection from the list }
          Connections.Remove(Connection);
          { Remove game fom Connection }
          Connection.RemoveGame(Game);
          fSocket.Send(Connection, [DP_GAME_PERISH, IntToStr(GameNumber)],Game);
          { Inform other observers this Connection has left. }
          fSocket.SmartSend(Connections, nil,
            [DP_UNOBSERVER, GameNumber, Connection.LoginID,
             Connection.Handle, Connection.Title, 'g'], Game);
        end;
    end; { with Game }
end;
//______________________________________________________________________________
constructor TGames.Create;
begin
  FGames := TObjectList.Create;
end;
//______________________________________________________________________________
destructor TGames.Destroy;
begin
  FGames.Free; { TObjectList will destroy any TGames for us }
  inherited Destroy;
end;
//______________________________________________________________________________
procedure TGames.CMD_Abort(var Connection: TConnection; const CMD: TStrings);
var
  _Game: TGame;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));

  if _Game.EventId<>0 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Cannot abort event game'],nil);
      Exit;
    end;

  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a live game (not examined) }
  if _Game.GameMode = gmExamined then Exit;

  with _Game do
    begin
      if CanAbort and not PlayerDisconnected and (Connection = Black) then
        Connection.AbortedGameByBlack := true;

      if (not (Connection = CRAbort) and not (CRAbort = nil))
        or CanAbort or PlayerDisconnected
        or (Connection = White) and (BlackCheatMode = chmRed)
        or (Connection = Black) and (WhiteCheatMode = chmRed)
      then
        GameResult := grAborted
      else if (CRAbort = nil) then
        begin
          CRAbort := Connection;
          if Connection = White then
            fSocket.Send(Black, [DP_ABORT, CMD[GAME_NUM], White.Handle, White.Title],nil)
          else
            fSocket.Send(White, [DP_ABORT, CMD[GAME_NUM], Black.Handle, Black.Title],nil);
          { Send message to the requester. }
          fSocket.Send(CRAbort, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_0,
            DP_MSG_ABORT_REQ_SENT],nil);
        end;
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_AckFlag(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  ElapsedMSec: Integer;
begin
  { The 'ackflag' command needs to be sent by a client in response to a DP_FLAG.
    This server must receive a response from the client within the FLAG_TIMEOUT
    limit or risk losing on network lag. }

  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM)
    CMD[2] = MSecRemaining (MSEC) }
  if CMD.Count < 3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
    StrToInt(CMD[ACK_MSEC]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;
  { Restrict flagging to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a live game (not examined) and FlagTS must not have been reset.
    AckFlag must only come from player on them move. }
  with _Game do if (GameMode = gmExamined) or (FlagTS = 0) or
    (((Color = WHT) and not (Connection = White)) or
    ((Color = BLK) and not (Connection = Black))) then Exit;

  { Get elapsed time from the last flag call for this game }
  ElapsedMSec := 0;
  with _Game do if FlagTS > 0 then
    ElapsedMSec := Trunc((Now - FlagTS) * MSecsPerDay);

  { If the Connection has time remaining, announce this to the players }
  if (ElapsedMSec < NET_TIMEOUT) and (StrToInt(CMD[ACK_MSEC]) > 0) then
    with _Game do
      begin
        FlagTS := 0;
        fSocket.Send(White, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_TIME_REMAINING],nil);
        fSocket.Send(Black, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_TIME_REMAINING],nil);
        Exit;
      end;

  { The conneciton has either lagged out or is below zero time. Determine
    which for game result }
  with _Game do
    begin
      { Did the player run out of time? }
      if (StrToInt(Cmd[ACK_MSEC]) <= 0) then
        begin
          if Color = WHT then
            begin
              WhiteMSec := StrToInt(Cmd[ACK_MSEC]);
              GameResult := grWhiteForfeitsOnTime;
            end
          else
            begin
              BlackMSec := StrToInt(Cmd[ACK_MSEC]);
              GameResult := grBlackForfeitsOnTime;
            end;
        end;
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Adjourn(var Connection: TConnection; const CMD: TStrings);
var
  _Game: TGame;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));

  if _Game.EventId<>0 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Cannot adjourn event game'],nil);
      Exit;
    end;

  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a live game (not examined) }
  if _Game.GameMode = gmExamined then Exit;

  with _Game do
    begin
      if ((Connection <> CRAdjourn) and (CRAdjourn <> nil)) or PlayerDisconnected
        then GameResult := grAdjourned
      else if (CRAdjourn = nil) then
        begin
          CRAdjourn := Connection;
          if Connection = White then
            fSocket.Send(Black, [DP_ADJOURN, CMD[GAME_NUM], White.Handle, White.Title],nil)
          else
            fSocket.Send(White, [DP_ADJOURN, CMD[GAME_NUM], Black.Handle, Black.Title],nil);
        end;
        { Send message to the requester. }
        fSocket.Send(CRAdjourn, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_0,
          DP_MSG_ADJOURN_REQ_SENT],nil);
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Draw(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
begin
  { 'draw' is a dual purpose command. It either requests a draw from your
    oppoenent or it accepts a draw that has been offered. }

  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a live game (not examined) }
  if _Game.GameMode = gmExamined then Exit;

  with _Game do
    begin
      { Is this a response to a draw request... }
      if not (Connection = CRDraw) and not (CRDraw = nil) then
        GameResult := grDraw
      { ...or a request for a draw }
      else if (CRDraw = nil) then
        begin
          CRDraw := Connection;
          if Connection = White then
            fSocket.Send(Black, [DP_DRAW, CMD[GAME_NUM], White.Handle, White.Title],nil)
          else
            fSocket.Send(White, [DP_DRAW, CMD[GAME_NUM], Black.Handle, Black.Title],nil);
        end;
        { Send message to the requester. }
        fSocket.Send(CRDraw, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_0,
          DP_MSG_DRAW_REQ_SENT],nil);
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_FEN(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
const
  FEN = 2;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing
    CMD[2] = FEN (FEN) }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 2 then
    if Connection.Primary <> nil then
      CMD.Insert(1, IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  if CMD.Count < 3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Attempt to get game. Verify game actually exists. }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Can only set FEN in examined games }
  if _Game.GameMode = gmLive then Exit;

  { Restrict 'resign' to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;
  { Validate the FEN }
  if not ValidFEN(CMD[FEN]) then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVALID_FEN],nil)
  else
    begin
      _Game.FEN := CMD[FEN];
      fSocket.Send(_Game.Connections, [DP_FEN, CMD[GAME_NUM], CMD[FEN]],_Game);
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Flag(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  ElapsedMSec: Integer;
begin
  { 'flag' is a dual purpose command. It calls the game if either clock is below
    zero or if (Now-FlagTS) exceeds the FLAG_TIMEOUT. If clocks are greater than
    zero then it sends a DP_FLAG to the player on the move and sets the FlagTS. }

  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict flagging to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a live game (not examined) }
  if _Game.GameMode = gmExamined then Exit;

  { Get elapsed time from the last flag call for this game }
  ElapsedMSec := 0;
  with _Game do if FlagTS > 0 then
    ElapsedMSec := Trunc((Now - FlagTS) * MSecsPerDay);

  { Check clocks & FlagTS }
  with _Game do
    begin
      { Check for either side with time below zero }
      if (WhiteMSec <= 0) or (BlackMSec <= 0) then
        begin
          if WhiteMSec < BlackMSec then
            GameResult := grWhiteForfeitsOnTime
          else
            GameResult := grBlackForfeitsOnTime;
        end
      { Check for flag timeout }
      else if (ElapsedMSec >= NET_TIMEOUT) then
        begin
          if Color = WHT then
            //GameResult := grWhiteForfeitsOnNetwork
            MakeDisconnectChoise(Black)
          else
            //GameResult := grBlackForfeitsOnNetwork;
            MakeDisconnectChoise(White)
        end
      { If no game result and flag request not already sent, send flag request }
      else if (ElapsedMSec = 0) then
        begin
          FlagTS := Now;
          if Color = WHT then
            fSocket.Send(White, [DP_FLAG, CMD[GAME_NUM]],nil)
          else
            fSocket.Send(Black, [DP_FLAG, CMD[GAME_NUM]],nil);
        end;

      { Annouce the game result if there is one }
      if not (GameResult = grNone) then FlagTS := 0;
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Forward(var Connection: TConnection;  var CMD: TStrings);
var
  _Game: TGame;
  _Move: TMove;
  Index, _MoveTotal, ForwardCount: Integer;
  ev: TCSEvent;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM)
    CMD[2] = ForwardCount (FORWARD_COUNT) optional 1 is the default }

  { If no game number passed with command then attempt to get one from the
     Primary property of the Connection Object }
  if CMD.Count < 3 then
    if Connection.Primary <> nil then
      CMD.Insert(1, IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Add the optional parameter with default value (just in case the client
    did not) }
  CMD.Add('1');

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
    ForwardCount := StrToInt(CMD[FORWARD_COUNT]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to examiners of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a examined game (not live) }
  if _Game.GameMode = gmLive then Exit;

  with _Game do
    begin
      { Send DP_MOVES }
      fSocket.Send(Connections, [DP_MOVE_BEGIN, CMD[GAME_NUM]],_Game);
      _MoveTotal := MoveNumber + ForwardCount;
      if _MoveTotal >= Moves.Count -1 then _MoveTotal := Moves.Count -1;
      for Index := MoveNumber + 1 to _MoveTotal do
        begin
          _Move := Moves[Index];
          fSocket.Send(Connections, [DP_MOVE, CMD[GAME_NUM],
            IntToStr(_Move.FFrom), IntToStr(_Move.FTo),
            IntToStr(_Move.FPosition[_Move.FTo]),
            IntToStr(Ord(_Move.FType)), _Move.FPGN],_Game);
        end;
      fSocket.Send(Connections, [DP_MOVE_END, CMD[GAME_NUM]],_Game);
      {}
      GoForward(ForwardCount);
      if _Game.EventID <> 0 then begin
        ev := fEvents.FindEvent(_Game.EventID);
        if (ev <> nil) and (ev.Type_ = evtLecture) then
          (ev as TCSLecture).AddAction(leaForward, ForwardCount, '');
      end;
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Include(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  _Connection: TConnection;
  s: string;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing
    CMD[2] = Player }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count < 3  then
    if Connection.Primary <> nil then
      CMD.Insert(1, IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  if CMD.Count < 3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Is Connection in control of the game (must be both white and black) }
  with _Game do
    if not (Connection = White) or not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_2,
          DP_MSG_NOT_EXCLUSIVE_OWNER],nil);
        Exit;
      end;

  { Is Player logged in }
  _Connection := fConnections.GetConnection(CMD[INCLUDE_PLAYER]);
  if not Assigned(_Connection) then
    begin
      s := Format(DP_MSG_LOGIN_NOT_LOGGEDIN, [CMD[INCLUDE_PLAYER]]);
      fSocket.Send(Connection, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_2, s],nil);
      Exit;
    end;

  { Is Player observing the game }
    if _Game.Connections.IndexOf(_Connection) = -1 then
    begin
      s := Format(DP_MSG_PLAYER_NOT_OBSERVING, [CMD[INCLUDE_PLAYER]]);
      fSocket.Send(Connection, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_2, s],nil);
      Exit;
    end;

  { All go }
  { Assign Player to Black }
  _Game.Black := _Connection;

  { Tell the Player client he/she is now an examiner }
  fSocket.Send(_Connection, [DP_INCLUDED, CMD[GAME_NUM], '0'],nil);

  { Send text message to playes / observers }
  s := Format(DP_MSG_PLAYER_NOW_EXAMINER, [CMD[INCLUDE_PLAYER], CMD[GAME_NUM]]);
  with _Game do fSocket.Send(Connections, [DP_GAME_MSG, CMD[GAME_NUM],
    DP_ERR_0, s], _Game);
end;
//______________________________________________________________________________
procedure TGames.CMD_Kibitz(var Connection: TConnection; var CMD: TStrings);
var
  _Connection: TConnection;
  _Game: TGame;
  Index: Integer;
  conns: TObjectList;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = Color
    CMD[2] = GameNumber (GAME_NUM) optional, use Primary if missing
    CMD[3] = Kibitz (GAME_MSG) }

  if Connection.Invisible then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVISIBLE_CHAT]);
    exit;
  end;
    
  { Verify login not muted }
  if Connection.Muted = True then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MUTE],nil);
      Exit;
    end;

  if CMD.Count=3 then
    CMD.Insert(1,'-1');

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count < 4  then
    if Connection.Primary <> nil then
      CMD.Insert(1, IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  if CMD.Count < 3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check paramater values }
  try
    StrToInt(CMD[2]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  if Connection.MembershipType = mmbNone then
    Connection.WarnAboutNoMembershipChat;


  { Find the game }
  _Game := GetGame(StrToInt(CMD[2]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Determine if Connection is even associated with the game in ? }
  if (_Game.EventId=0) and (Connection.Games.IndexOf(_Game) = -1) or
     (_Game.EventId<>0) and (_Game.EventId<>Connection.EventId)
  then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_INVOLVED],nil);
      Exit;
    end;

  if _Game.EventId = 0 then conns:=_Game.Connections
  else begin
    conns:=fEvents.GetEventUsers(_Game.EventId);
    if conns=nil then conns:=_Game.Connections;
  end;

  { Filter out those who are censoring me. }
  for Index := conns.Count -1 downto 0 do
    begin
      _Connection := TConnection(conns[Index]);
      _Connection.Send := ((Connection.MembershipType > mmbNone) or (_Connection.AdminLevel > alNone))
        and not _Connection.Censors[Connection];
    end;

  { Send the message }
  with _Game do fSocket.Send(Connections, [DP_KIBITZ, IntToStr(GameNumber),
    Connection.Handle, Connection.Title, CMD[3], CMD[1]],_Game);

  fDB.AddChatLog(Date+Time,Connection.Handle,'G','K',_Game.White.Handle+'/'+_Game.Black.Handle,CMD[3]);

  { Set last command used for this connection. }
  Connection.LastCmd := CMD_STR_KIBITZ;
  Connection.CmdParam := CMD[2];
end;
//______________________________________________________________________________
procedure TGames.CMD_Lock(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  Index: Integer;
begin
  { Check param count:
  CMD[0] = /Command
  CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Must be superadmin, or titled player in the game. }
  if (_Game.White = Connection) or (_Game.Black = Connection) or (Connection.AdminLevel >= alNormal) then
    begin
      _Game.Locked := True;

      { Send game to all connections. }
      { ??? fSocket.Buffer := True; }
      fSocket.Send(fConnections.Connections, [DP_GAME_LOCK, CMD[GAME_NUM], '1'],_Game);
      { ??? fSocket.Buffer := False; }

      fSocket.Send(_Game.Connections, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_0, DP_MSG_GAME_LOCKED],_Game);
    end
  else
    begin
      { inform user they cannot lock the game. }
      { actually just tell them it's an invalid command. }
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVALID_COMMAND],nil);
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Markers(var Connection: TConnection; var CMD: TStrings;
  const MarkerType: Integer);
var
  _Game: TGame;
  ParamCount: Integer;
  col: string;
  ev: TCSEvent;
begin
  case MarkerType of
    CMD_ARROW, CMD_UNARROW: ParamCount := 4;
    CMD_CIRCLE, CMD_UNCIRCLE: ParamCount := 3;
    CMD_CLEAR_MARKERS: ParamCount := 2;
  else
    ParamCount := High(Integer);
  end;

  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing
    CMD[2] = FromSqr (FROM_SQR)
    CMD[3] = ToSqr (TO_SQR) }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if (MarkerType = CMD_CLEAR_MARKERS) and (CMD.Count = 1) then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  if CMD.Count < ParamCount then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  if CMD.Count>ParamCount then col:=CMD[ParamCount]
  else col:='blue';

  { Just add two strings to CMD, it's easier than checking if a param should/
    should not exist. At worst they're never used. }
  {CMD.Add('0');
  CMD.Add('0');
  // Check paramater values
  try
    StrToInt(CMD[GAME_NUM]);
    StrToInt(CMD[FROM_SQR]);
    StrToInt(CMD[TO_SQR]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE]);
      Exit;
    end;
  end;}

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Must be an examined game (not live) }
  if _Game.GameMode = gmLive then Exit;

  { Restrict move input to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Send out the DG }
  with _Game do
    case MarkerType of
      CMD_ARROW:
          fSocket.Send(Connections,
            [DP_ARROW, CMD[GAME_NUM], CMD[FROM_SQR], CMD[TO_SQR],col],_Game);
      CMD_UNARROW:
        fSocket.Send(Connections,
          [DP_UNARROW, CMD[GAME_NUM], CMD[FROM_SQR], CMD[TO_SQR],col],_Game);
      CMD_CIRCLE:
        fSocket.Send(Connections, [DP_CIRCLE, CMD[GAME_NUM], CMD[FROM_SQR], col],_Game);
      CMD_UNCIRCLE:
        fSocket.Send(Connections, [DP_UNCIRCLE, CMD[GAME_NUM], CMD[FROM_SQR], col],_Game);
      CMD_CLEAR_MARKERS:
        fSocket.Send(Connections, [DP_CLEAR_MARKERS, CMD[GAME_NUM], col],_Game);
    end;

  if _Game.EventID <> 0 then begin
    ev := fEvents.FindEvent(_Game.EventID);
    if (ev <> nil) and (ev.Type_ = evtLecture) then begin
      case MarkerType of
        CMD_ARROW: (ev as TCSLecture).AddAction(leaArrow, 0, CMD[FROM_SQR]+';'+CMD[TO_SQR]+';'+col);
        CMD_CIRCLE: (ev as TCSLecture).AddAction(leaCircle, 0, CMD[FROM_SQR]+';'+col);
      end;
    end;
  end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Moretime(var Connection: TConnection; var CMD: TStrings);
const
  MORE_TIME = 2;
var
  _Game: TGame;
  Index, _WhiteMSec, _BlackMSec: Integer;
begin
  { Moretime is a dual purpose command. It either issues a request or accepts
    a request issued (or removes a request if called again by the issuer). }

  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if mising
    CMD[2] = Secs (MORE_TIME) optional, use 1/5 etime secs if missing if missing }

  { If no game number passed with command then attempt to get one from the
     Primary property of the Connection Object }
  if CMD.Count < 3 then
    if Connection.Primary <> nil then
      CMD.Insert(1, IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
    if CMD.Count >= 3 then
      begin
        StrToInt(CMD[MORE_TIME]);
        { Set the limits of the request }
        if StrToInt(CMD[MORE_TIME]) > MAX_SECS then
          CMD[MORE_TIME] := IntToStr(MAX_SECS);
        if StrToInt(CMD[MORE_TIME]) < 0 then
          CMD[MORE_TIME] := '10';
      end;
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a live game (not examined) }
  with _Game do
    if GameMode = gmLive then
      { Remove, Accept or Issue a Moretime request to the opponent }
      begin
        { If the MSecs requested parameter was not sent. Use 1/5 the ETime.
          But only if requesting and not agreeing to moretime. }
        if (CMD.Count = 2) and (CRMoretime = nil) then
          begin
            { Get the etime in minutes }
            Index := ((WhiteIncMSec div MSECS) div 3) * 2 + (WhiteInitialMSec div MSECS_PER_MINUTE);
            { Convert it to seconds }
            Index := (Index * 60) div 5;
            if Index > MAX_SECS then Index := MAX_SECS;
            if Index < 0 then Index := 10;
            CMD.Add(IntToStr(Index));
          end;

        { Accept }
        if (Connection <> CRMoretime) and (CRMoretime <> nil) then
          begin
            { The property procedure will ensure that the lowest moretime value
              assigned will be returned }
            if CMD.Count >= 3 then MoreTime := StrToInt(CMD[MORE_TIME]);
            BlackMSec := BlackMSec + MoreTime;
            WhiteMSec := WhiteMSec + MoreTime;
            { Issue the DG }
            GetMSec(_WhiteMSec, _BlackMSec);
            fSocket.Send(Connections, [DP_MSEC, CMD[GAME_NUM],
              IntToStr(_WhiteMSec), IntToStr(_BlackMSec)],_Game);
            { Clear the flag }
            CRMoretime := nil
          end
        { Issue a request to opponent }
        else if (Connection <> CRMoretime) and (CRMoretime = nil) then
          begin
            { Setting TackbackCount needs to preceed setting CRMoretime }
            MoreTime := StrToInt(CMD[MORE_TIME]);
            CRMoretime := Connection;

            if Connection = White then
              fSocket.Send(Black, [DP_MORETIME_REQUEST, CMD[GAME_NUM],
                  CMD[MORE_TIME], White.Handle, White.Title],nil)
            else
               fSocket.Send(White, [DP_MORETIME_REQUEST, CMD[GAME_NUM],
                CMD[MORE_TIME], Black.Handle, Black.Title],nil);

            { Send message to the requester. }
            fSocket.Send(CRMoretime, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_0,
              DP_MSG_MORETIME_REQ_SENT],nil);
          end;
      end
    else
      { Must be Examined game, send a message that you can't add time. }
      begin
        { ??? Send message. }
      end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Move(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  _Move: TMove;
  _WhiteMSec, _BlackMSec, MSec, Switched: Integer;
  MSecSent: Boolean;
  i: integer;
  conns: TObjectList;
  ev: TCSEvent;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM)
    CMD[2] = FromSqr (FROM_SQR)
    CMD[3] = ToSqr (TO_SQR)
    CMD[4] = Promotion (MOVE_PROMO)
    CMD[5] = MoveType (MOVE_TYPE)
    CMD[6] = PGN
    CMD[7] = MSec (MOVE_MSEC) optional
    CMD[8] = Switched (0/1)}
  if CMD.Count < 7 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Add the optional parameter with default values (just in case the client
    did not) }
  if CMD.Count = 7 then CMD.Add('0');
  MSec := StrToInt(CMD[MOVE_MSEC]);
  MSecSent := (MSec > 0);

  if CMD.Count = 8 then CMD.Add('0');
  Switched := StrToInt(CMD[8]);

  { Check paramater values }
  { Check the game number param separately because a DP_ILLEGAL_MOVE should only
    be sent if that param is actually a number. }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  try
    StrToInt(CMD[FROM_SQR]);
    StrToInt(CMD[TO_SQR]);
    StrToInt(CMD[MOVE_PROMO]);
    StrToInt(CMD[MOVE_TYPE]);
    StrToInt(CMD[MOVE_MSEC]);
    if (StrToInt(CMD[MOVE_PROMO]) < BK) or (StrToInt(CMD[MOVE_PROMO]) > WK) then
      raise Exception.Create('Invalid Param');
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      fSocket.Send(Connection, [DP_ILLEGAL_MOVE, CMD[GAME_NUM],
        DP_MSG_ILLEGAL_MOVE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Check for correct color to move if it's a real game }
  with _Game do
    if (GameMode = gmLive) and
    (((Color = WHT) and not (Connection = White)) or
    ((Color = BLK) and not (Connection = Black))) then
      begin
        fSocket.Send(Connection, [DP_ILLEGAL_MOVE, CMD[GAME_NUM],
          DP_MSG_NOT_YOUR_MOVE],nil);
        Exit;
      end;

  { If FlagTS > 0 or if AutoFlag then check for losers. }
  with _Game do
    begin
      { Get the players estimated times }
      GetMSec(_WhiteMSec, _BlackMSec);
      if MSecSent then
        begin
          { Use the TS that was sent with move }
//          MSec := StrToInt(CMD[MOVE_MSEC]);
          { Correct the estimated times }
          if Connection = White then
            _WhiteMSec := WhiteMSec - MSec
          else
            _BlackMSec := BlackMSec - MSec;
        end
      else
        { Else calculate the MSec and accecpt the estimated times }
        if Connection = White then
          MSec := WhiteMSec - _WhiteMSec
        else
          MSec := BlackMSec - _BlackMSec;

      { Check for out of time }
      if (GameMode = gmLive)
      and ((FlagTS > 0) or White.AutoFlag or Black.AutoFlag) then
        begin
          { if either are < 0 figure out game result }
          if (_WhiteMSec <= 0) or (_BlackMSec <= 0) then
            if _WhiteMSec < _BlackMSec then
              GameResult := grWhiteForfeitsOnTime
            else
              GameResult := grBlackForfeitsOnTime;
          if FlagTS > 0 then
            if Trunc((Now - FlagTS) * MSecsPerDay) >= NET_TIMEOUT then
              if Color = WHT then
                //GameResult := grWhiteForfeitsOnNetwork
                MakeDisconnectChoise(Black)
              else
                //GameResult := grBlackForfeitsOnNetwork;
                MakeDisconnectChoise(White)
        end;
    end;

  with _Game do
    if (GameMode = gmLive) then
      if Connection = White then begin
        WhiteSwitched := WhiteSwitched + Switched;
        WhiteJustSwitched := Switched=1;
        if WhiteCheatMode = chmRed then SaveWhiteCheat;
        //CLServerService.re.Lines.Add(Format('White: %d, %d',[Switched,WhiteSwitched]));
      end else if Connection = Black then begin
        BlackSwitched := BlackSwitched + Switched;
        BlackJustSwitched := Switched=1;
        if BlackCheatMode = chmRed then SaveBlackCheat;
        //CLServerService.re.Lines.Add(Format('Black: %d, %d',[Switched,BlackSwitched]));
      end;


  with _Game do
    begin
      { Notify that offers are no longer valid. }
      if CRAbort <> nil then
        begin
          fSocket.Send(White, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_ABORT_REQ_INVALID],nil);
          fSocket.Send(Black, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_ABORT_REQ_INVALID],nil);
        end;
      if CRAdjourn <> nil then
        begin
          fSocket.Send(White, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_ADJOURN_REQ_INVALID],nil);
          fSocket.Send(Black, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_ADJOURN_REQ_INVALID],nil);
        end;
      if CRDraw <> nil then
        begin
          fSocket.Send(White, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_DRAW_REQ_INVALID],nil);
          fSocket.Send(Black, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_DRAW_REQ_INVALID],nil);
        end;
      if CRMoretime <> nil then
        begin
          fSocket.Send(White, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_MORETIME_REQ_INVALID],nil);
          fSocket.Send(Black, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_MORETIME_REQ_INVALID],nil);
        end;
      if CRTakeback <> nil then
        begin
          fSocket.Send(White, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_TAKEBACK_REQ_INVALID],nil);
          fSocket.Send(Black, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_1, DP_MSG_TAKEBACK_REQ_INVALID],nil);
        end;

      _Move := AddMove(StrToInt(CMD[FROM_SQR]), StrToInt(CMD[TO_SQR]),
        StrToInt(CMD[MOVE_PROMO]), TMoveType(StrToInt(CMD[MOVE_TYPE])), '', MSec);
      if Assigned(_Move) then
        begin
          { Send DP_MOVE to players and observers }
          if _Game.EventID <> 0 then begin
            ev := fEvents.FindEvent(_Game.EventID);
            if (ev <> nil) and (ev.Type_ = evtLecture) then
              (ev as TCSLecture).AddAction(leaMove,0,
                CMD[FROM_SQR]+';'+CMD[TO_SQR]+';'+CMD[MOVE_PROMO]+';'+CMD[MOVE_TYPE]);
          end;

          conns:=_Game.RealConnections;

          fSocket.Send(conns, [DP_MOVE, CMD[GAME_NUM], CMD[FROM_SQR],
            CMD[TO_SQR], CMD[MOVE_PROMO], CMD[MOVE_TYPE], _Move.FPGN,
            IntToStr(Integer(_Game.WhiteCheatMode)), IntToStr(Integer(_Game.BlackCheatMode))],_Game);

          _Game.SendMoveToEngine(_Move);
          

          { Send DP_TIME to players and observers }
          if GameMode = gmLive then fSocket.Send(conns,
            [DP_MSEC, CMD[GAME_NUM], IntToStr(WhiteMSec), IntToStr(BlackMSec)],_Game);

          { Examine game status and report results if necessary }
          if (GameMode = gmLive) and (GameResult <> grNone) then
            GameResult := GameResult;
        end
      else begin
        { Illegal move }
        if Connection.ConnectionType = cntPlayer then
          fSocket.Send(Connection, [DP_ILLEGAL_MOVE, CMD[GAME_NUM],
            DP_MSG_ILLEGAL_MOVE],_Game)
        else
          Connection.Bot.OnIllegalMove;
      end;
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Observe(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  s: string;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
    _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  except
    try
      _Game := GetGame(CMD[GAME_NUM]);
    except
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
        Exit;
      end;
    end;
  end;

  { Attempt to get game. Verify game actually exists. }

  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Check to see if already involved (watching or playing) }
  if _Game.Connections.IndexOf(Connection) > -1 then
    begin
      s := Format(DP_MSG_ALREADY_OBSERVING, [_Game.GameNumber, _Game.WhiteLogin,
        _Game.BlackLogin]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Check to see if it's locked. }
  if _Game.Locked and (Connection.AdminLevel < alNormal) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ERR_GAME_LOCKED],nil);
      Exit;
    end;

  { Add this connection to those that the game object recognizes }
  _Game.AddConnection(Connection);
  { Add this game to the list of games that the connection is somehow involved }
  Connection.AddGame(_Game);

  { All go }
  LaunchGame(Connection, _Game);
end;
//______________________________________________________________________________
procedure TGames.CMD_Primary(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Attempt to get game. Verify game actually exists. }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Determine if Connection is even associated with the game in question }
  if (Connection.Games.IndexOf(_Game) = -1) and
      not ((_Game.EventId<>0) and (_Game.EventID = Connection.EventId)) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_INVOLVED],nil);
      Exit;
    end;

  { Set & Send DP_PRIMARY }
  TConnection(Connection).Primary := _Game;
  fSocket.Send(Connection, [DP_PRIMARY, CMD[GAME_NUM]],nil);

  if _Game.EventId<>0 then
    fEvents.OnPrimary(_Game.EventId,Connection,_Game.EventOrdNum);
end;
//______________________________________________________________________________
procedure TGames.CMD_Quit(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  index: integer;
  th: TGameSaveThread;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  index:=Connection.Games.IndexOf(_Game);
  { Determine if Connection is even associated with the game in ? }
  if (_Game.EventId=0) and (index = -1) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_INVOLVED],nil);
      Exit;
    end;

  if (_Game.EventId<>0) and (_Game.EventId<>Connection.EventId) then
    exit;

  if ((_Game.White=Connection) or (_Game.Black=Connection)) then
    SaveGame(_Game);

  { Made it past the checks. Quit game. }
  Quit(_Game, Connection);
end;
//______________________________________________________________________________
procedure TGames.CMD_Resign(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Attempt to get game. Verify game actually exists. }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Cant resign if it's not a live game eh? }
  if _Game.GameMode = gmExamined then Exit;

  { Restrict 'resign' to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { ok so quit the game then loser }
  with _Game do
    if Connection = White then
      GameResult := grWhiteResigns
    else
      GameResult := grBlackResigns;
end;
//______________________________________________________________________________
procedure TGames.CMD_Revert(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  _Move: TMove;
  Index: Integer;
  ev: TCSEvent;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to examiners of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a examined game (not live) }
  if _Game.GameMode = gmLive then Exit;

  { Check if we're even off the mainline }
  with _Game do
    if MainLineMoveNumber = -1 then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ON_MAINLINE],nil);
        Exit;
      end;

  { All go for revert }
  with _Game do
    begin
      { Issue a DP_TAKEBACK to let the client know we're rolling back moves }
      fSocket.Send(Connections,
        [DP_TAKEBACK, CMD[GAME_NUM], IntToStr(MoveNumber)],_Game);
      { Revert the Game object back to the mainline }
      Revert;
      { Send DP_MOVE's to bring the client into sync }
      for Index := 1 to MoveNumber do
        begin
          _Move := Moves[Index];
          fSocket.Send(Connections,
            [DP_MOVE, CMD[GAME_NUM], IntToStr(_Move.FFrom),
            IntToStr(_Move.FTo), IntToStr(_Move.FPosition[_Move.FTo]),
            IntToStr(Ord(_Move.FType)), _Move.FPGN],_Game);
        end;
      if _Game.EventID <> 0 then begin
        ev := fEvents.FindEvent(_Game.EventID);
        if (ev <> nil) and (ev.Type_ = evtLecture) then
          (ev as TCSLecture).AddAction(leaRevert, TakeBackCount, '');
      end;
    end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Say(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  Index: Integer;
  opConnection: TConnection;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = Color
    CMD[2] = GameNumber (GAME_NUM) optional, use Primary if missing
    CMD[3] = Message }

  { Verify login not muted }
  if Connection.Invisible then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVISIBLE_CHAT]);
    exit;
  end;

  if Connection.Muted = True then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MUTE],nil);
      Exit;
    end;

  if CMD.Count=3 then
    CMD.Insert(1,'-1');

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count < 4  then
    if Connection.Primary <> nil then
      CMD.Insert(1, IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check the param count. }
  if CMD.Count < 4 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check paramater values }
  try
    Index := StrToInt(CMD[2]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  _Game := GetGame(Index);
  if _Game = nil then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
        DP_MSG_NO_PRIMARY_GAME],nil);
      Exit;
    end
  else
    with _Game do
      begin
        { Is the Connection a owner of the game }
        if true {EventId=0} then begin
          if (White = Connection) or (Black = Connection) then begin
            fSocket.Send(Black, [DP_SAY, CMD[2], Connection.Handle,
              Connection.Title, CMD[3], CMD[1]],nil);
            if Black <> White then fSocket.Send(White, [DP_SAY, CMD[2],
              Connection.Handle, Connection.Title, CMD[3], CMD[1]],nil);

            fDB.AddChatLog(SysUtils.Date+Time,Connection.Handle,'G','S',White.Handle+'/'+Black.Handle,CMD[3]);

            Connection.LastCmd := CMD_STR_SAY;
            Connection.CmdParam := '';
          end else
            fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
              DP_MSG_NOT_GAME_PLAYER],nil);
        end;
      end;
end;
//______________________________________________________________________________
procedure TGames.CMD_Takeback(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  ev: TCSEvent;
begin
  { Takeback is a dual purpose command. It either issues a request or accepts
    a request issued (or removes a request if called again by the issuer).
    'back' is mapped to this procedure making it esentially the same command. }

  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if mising
    CMD[2] = TakebackCount (TAKEBACK_COUNT) optional, use 1 if missing }

  { If no game number passed with command then attempt to get one from the
     Primary property of the Connection Object }
  if CMD.Count < 3 then
    if Connection.Primary <> nil then
      CMD.Insert(1, IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Add the optional parameter with default values (just in case the client
    did not) }
  CMD.Add('1');

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
    StrToInt(CMD[TAKEBACK_COUNT]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a live game (not examined) }
  with _Game do
    if GameMode = gmLive then
      { Remove, Accept or Issue a Takeback request to the opponent }
      begin
        { Accept }
        if (Connection <> CRTakeback) and (CRTakeback <> nil) then
          begin
            { The property procedure will ensure that the lowest takeback count
              assigned will be returned }
            TakeBackCount := StrToInt(CMD[TAKEBACK_COUNT]);
            Takeback(TakeBackCount);
            { Issue the DG }
            fSocket.Send(Connections,
              [DP_TAKEBACK, CMD[GAME_NUM], IntToStr(TakebackCount)],_Game);
            { Clear the flag }
            CRTakeback := nil
          end
        { Issue a request to opponent }
        else if (Connection <> CRTakeback) and (CRTakeback = nil) then
          begin
            { Setting TackbackCount needs to preceed setting CRTakeback }
            TakebackCount := StrToInt(CMD[TAKEBACK_COUNT]);
            CRTakeback := Connection;
            if Connection = White then
              fSocket.Send(Black, [DP_TAKEBACK_REQUEST, CMD[GAME_NUM],
                CMD[TAKEBACK_COUNT], White.Handle, White.Title],nil)
            else
              fSocket.Send(White, [DP_TAKEBACK_REQUEST, CMD[GAME_NUM],
                CMD[TAKEBACK_COUNT], Black.Handle, BlackTitle],nil);
            { Send message to the requester. }
            fSocket.Send(CRTakeback, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_0,
              DP_MSG_TAKEBACK_REQ_SENT],nil);
          end;
      end
    else
      { Must be Examined game so just do it }
      begin
        TakeBackCount := StrToInt(CMD[TAKEBACK_COUNT]);
        if _Game.EventID <> 0 then begin
          ev := fEvents.FindEvent(_Game.EventID);
          if (ev <> nil) and (ev.Type_ = evtLecture) then
            (ev as TCSLecture).AddAction(leaBack, TakeBackCount, '');
        end;
        GoBackward(TakeBackCount);
        { Issue the DG }
        fSocket.Send(Connections,
          [DP_TAKEBACK, CMD[GAME_NUM], IntToStr(TakeBackCount)],_Game);
      end;
end;
//______________________________________________________________________________
procedure TGames.CMD_UnLock(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
  Index: Integer;
begin
  { Check param count:
  CMD[0] = /Command
  CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Must be superadmin, or titled player in the game. }
  if ((Length(Connection.Title) >=2) and
    ((_Game.White = Connection) or (_Game.Black = Connection))) then
    begin
      _Game.Locked := False;

      { Send game to all connections. }
      fSocket.Send(fConnections.Connections, [DP_GAME_LOCK, CMD[GAME_NUM], '0'],_Game);

      fSocket.Send(_Game.Connections, [DP_GAME_MSG, CMD[GAME_NUM], DP_ERR_0, DP_MSG_GAME_UNLOCKED],_Game);
    end
  else
    begin
      { inform user they cannot lock the game. }
    end;

end;
//______________________________________________________________________________
procedure TGames.CMD_Whisper(var Connection: TConnection; var CMD: TStrings);
var
  _Connection: TConnection;
  _Game: TGame;
  Index: Integer;
  conns: TObjectList;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = Color
    CMD[2] = GameNumber (GAME_NUM) optional, use Primary if missing
    CMD[3] = Whisper (GAME_MSG) }

  { Verify login not muted }
  if Connection.Invisible then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INVISIBLE_CHAT]);
    exit;
  end;

  if Connection.Muted = True then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MUTE],nil);
      Exit;
    end;

  if CMD.Count=3 then
    CMD.Insert(1,'-1');

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count < 4  then
    if Connection.Primary <> nil then
      CMD.Insert(1, IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  if CMD.Count < 3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check paramater values }
  try
    StrToInt(CMD[2]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[2]));
  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Determine if Connection is even associated with the game in ? }
  if (_Game.EventId=0) and (Connection.Games.IndexOf(_Game) = -1) or
     (_Game.EventId<>0) and (_Game.EventId<>Connection.EventId)
  then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_INVOLVED],nil);
      Exit;
    end;

  if _Game.EventId = 0 then conns:=_Game.Connections
  else begin
    conns:=fEvents.GetEventUsers(_Game.EventId);
    if conns=nil then conns:=_Game.Connections;
  end;
  { Filter out Players by setting Send Filter to true.
    At the same time filter out those who are censoring me. }
  for Index := conns.Count -1 downto 0 do
    begin
      _Connection := TConnection(conns[Index]);
      _Connection.Send := ((Connection.MembershipType > mmbNone) or (_Connection.AdminLevel > alNone))
        and not _Connection.Censors[Connection]
        and not (_Connection = _Game.White)
        and not (_Connection = _Game.Black);
    end;

  { send }
  fSocket.Send(conns, [DP_WHISPER, CMD[2], Connection.Handle,
    Connection.Title, CMD[3], CMD[1]],_Game);

  fDB.AddChatLog(Date+Time,Connection.Handle,'G','W',_Game.White.Handle+'/'+_Game.Black.Handle,CMD[3]);

  { Set last command used for this connection. }
  Connection.LastCmd := CMD_STR_WHISPER;
  Connection.CmdParam := CMD[2];
end;
//______________________________________________________________________________
procedure TGames.CMD_ZeroTime(var Connection: TConnection;
  var CMD: TStrings);
var
  Game: TGame;
begin
  { The CMD_STR_ZERO_TIME command needs to be sent by a client when a live game
    owned by it hit's zero time. It's not a command that would normally be sent
    by a user so it lacks error information. }

  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) }
  if CMD.Count < 2 then Exit;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    Exit;
  end;

  { Find the game }
  Game := GetGame(StrToInt(CMD[GAME_NUM]));
  if not Assigned(Game) then Exit;

  { Must be a live game (not examined). It must only come from the player on
    the move. And one of the players must have AutoFlag on. }
  if not (Game.GameMode = gmLive) then Exit;

  with Game do
    if ((Color = WHT) and not (Connection = White))
    or ((Color = BLK) and not (Connection = Black)) then Exit;

  if not Game.White.AutoFlag and not Game.Black.AutoFlag then Exit;

  { All go. Determine game result }
  with Game do
    begin
      if Color = WHT then
        begin
          WhiteMSec := 0;
          GameResult := grWhiteForfeitsOnTime;
        end
      else
        begin
          BlackMSec := 0;
          GameResult := grBlackForfeitsOnTime;
        end;
    end;
end;
//______________________________________________________________________________
procedure TGames.CreateGame(
  var Offer: TOffer;
  WL: string = '';
  WT: string = '';
  WR: integer = 0;
  BL: string = '';
  BT: string = '';
  BR: integer = 0);
var
  Connection: TConnection;
  Game: TGame;
  Move: TMove;
  Index: Integer;
begin
  { Create the actual Game object. }
  Game := TGame.Create(Offer);

  { Load the game if necessary from the DB. }
  if Offer.GameID > -1 then begin
    case Offer.OfferType of
      otMatch:
        begin
          fDB.LoadGame(Offer.GameID, Game, False);
          Game.SavedInDb:=true;
        end;
      otResume: fDB.LoadGame(Offer.GameID, Game, True);
    end;
  end;
  { fDB.LoadGame will FreeAndNil Game if for some reason it cannot load it,
    in which case stop execution of procedure. }
  if Assigned(Game) then
    FGames.Add(Game)
  else
    Exit;
  { Must be AFTER fDB.LoadGame!!! }
  Game.OnResult := GameResult;

  { Add the game object to the Connection(s) object }
  Offer.White.AddGame(Game);
  if Offer.White <> Offer.Black then Offer.Black.AddGame(Game);

  { Assign last colors }
  if Game.GameMode = gmLive then
    begin
      Game.White.LastColor := WHT;
      Game.Black.LastColor := BLK;
    end;

  { Release all offers from the Connection in question if it's Games.Count is
    about to exceed it's limit. }
  with Game do begin
    if (White.CountNotEventGames >= White.GameLimit) or White.RemoveOffers then
      fOffers.RemoveOffers(White, Offer);
    if White <> Black then
      if (Black.CountNotEventGames >= Black.GameLimit) or Black.RemoveOffers then
        fOffers.RemoveOffers(Black, Offer);
  end;

  if fConnections.Following(Game.White,Game.Black) then fConnections.FrozeFollow(Game.White);
  if fConnections.Following(Game.Black,Game.White) then fConnections.FrozeFollow(Game.Black);

  if WL='' then
    begin
      if WL='' then WL:=Game.White.Handle;
      if WT='' then WT:=Game.White.Title;
      if WR=0 then WR:=Game.WhiteRating;

      if BL='' then BL:=Game.Black.Handle;
      if BT='' then BT:=Game.Black.Title;
      if BR=0 then BR:=Game.BlackRating;
    end;

  with Game do
    begin
      WhiteLogin:=WL;
      WhiteTitle:=WT;
      WhiteRating:=WR;
      BlackLogin:=BL;
      BlackTitle:=BT;
      BlackRating:=BR;
    end;

  { Game info to the players. }
  { Buffer it up. }
  fSocket.Buffer := True;
  try // fSocket.Buffer := False

  with Game do
    begin
      { Send DP_GAME_STARTED }
      fSocket.Send(Connections,
        [DP_GAME_BORN, IntToStr(GameNumber), Site, Event, IntToStr(Round), Date,
        WL, WT, IntToStr(WR),
        BL, BT, IntToStr(BR),
        IntToStr(WhiteInitialMSec), IntToStr(WhiteIncMSec), IntToStr(Ord(GameMode)), '1',
        IntToStr(Ord(RatedType)), IntToStr(Integer(Rated)), '0',
        IntToStr(EventId), IntToStr(EventOrdNum),
        IntToStr(BlackInitialMSec), IntToStr(BlackIncMSec)],Game);

      with Game.Odds do
        fSocket.Send(Connections,
          [DP_GAME_ODDS, IntToStr(GameNumber),
           BoolTo_(FAutoTimeOdds, '1', '0'),
           IntToStr(FInitMin), IntToStr(FInitSec),
           IntToStr(FInc), IntToStr(FPiece),
           IntToStr(ord(FTimeDirection)), IntToStr(ord(FPieceDirection)),
           IntToStr(ord(FInitiator))],Game);

      { Send DP_FEN if necessary }
      if FEN <> '' then
        fSocket.Send(Connections, [DP_FEN, IntToStr(GameNumber), FEN],Game);

      { Send Moves if necessary. }
      if MoveNumber > 0 then
        for Index := 1 to MoveNumber do
          begin
            Move := Moves[Index];
            fSocket.Send(Connections,
              [DP_MOVE, IntToStr(GameNumber), IntToStr(Move.FFrom),
              IntToStr(Move.FTo), IntToStr(Move.FPosition[Move.FTo]),
              IntToStr(Ord(Move.FType)), Move.FPGN],Game);
          end;

      { Send game result if any }
      if not (GameResult = grNone) then
        fSocket.Send(Connections, [DP_GAME_RESULT, IntToStr(GameNumber),
          RESULTCODES[Ord(GameResult)]],Game);

      { Send DP_MSec }
      fSocket.Send(Connections, [DP_MSEC, IntToStr(GameNumber),
        IntToStr(WhiteMSec), IntToStr(BlackMSec)],Game);

      { Tell the client to show the board }
      fSocket.Send(Connections, [DP_SHOW_GAME, IntToStr(GameNumber)],Game);

      { Send players as observers }
      fSocket.Send(Connections, [DP_OBSERVER, IntToStr(GameNumber),
        IntToStr(White.LoginID), White.Handle, White.Title, White.RatingString],Game);
      if White <> Black then
        fSocket.Send(Connections, [DP_OBSERVER, IntToStr(GameNumber),
          IntToStr(Black.LoginID), Black.Handle, Black.Title, Black.RatingString],Game);
    end;

  finally
    {Send the buffer. }
    fSocket.Buffer := False;
    fSocket.Send(Game.Connections, [''],Game);
  end;

  { Send game to all connections. }

  { ??? fSocket.Buffer := True; }
  with Game do fSocket.Send(fConnections.Connections,
    [DP_GAME, IntToStr(GameNumber),
    WL, WT, IntToStr(WR{White.Rating[RatedType]}),
    BL, BT, IntToStr(BR{Black.Rating[RatedType]}),
    IntToStr(Ord(RatedType)), IntToStr(WhiteInitialMSec), IntToStr(WhiteIncMSec),
    IntToStr(Integer(Rated)), RESULTCODES[Ord(GameResult)], IntToStr(Integer(Locked)),
    IntToStr(BlackInitialMSec), IntToStr(BlackIncMSec)],Game);

  if Game.GameMode = gmLive then begin
    Game.SetGameScore;
    Game.SendGameScore(nil);
    if Game.White.ConnectionType = cntEngine then
      Game.White.Bot.OnGameStarted(Game);
    if Game.Black.ConnectionType = cntEngine then
      Game.Black.Bot.OnGameStarted(Game);
  end;
  { ??? fSocket.Buffer := False; }
  fConnections.DoFollows(Game.White.Handle,Game.Black.Handle);
  Game.ShoutIfTitled;

  // starting engines
  
  
end;
//______________________________________________________________________________
procedure DevideLoginTitle(Str: string; var Login,Title: string);
var
  n,n1: integer;
begin
  n:=pos('(',Str);
  if n=0 then begin
    Login:=Str; Title:='';
  end else begin
    Login:=trim(copy(Str,1,n-1));
    Str:=copy(Str,n+1,length(Str));
    n:=pos(')',Str);
    if n=0 then Title:=trim(Str)
    else Title:=trim(copy(Str,1,n-1));
  end;
end;
//______________________________________________________________________________
procedure TGames.CMD_DemoBoard(var Connection: TConnection; const CMD: TStrings);
var
  i, Index: integer;
  WL,WT,BL,BT: string;
  WR,BR: integer;
  Game: TGame;
begin
  {if not (Connection.AdminLevel in [alHelper,alNormal,alSuper]) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
      Exit;
    end;}

  if CMD.Count<3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;
  for i:=CMD.Count to 5 do CMD.Add('2000');
  DevideLoginTitle(CMD[1],WL,WT);
  DevideLoginTitle(CMD[2],BL,BT);

  try
    if CMD[3]='' then WR:=2000
    else WR:=StrToInt(CMD[3]);

    if CMD[4]='' then BR:=2000
    else BR:=StrToInt(CMD[4]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Rating must be the number'],nil);
    Exit;
  end;

  fOffers.New(Connection.Color, '120', 0, 0, 0, 0, 0, -1, Connection, Connection,
    otMatch, 0, false, nil,
    WL,WT,WR,BL,BT,BR);
end;
//______________________________________________________________________________
procedure TGames.LaunchGame(var Connection: TConnection; var Game: TGame);
var
  _Connection: TConnection;
  _Move: TMove;
  _WhiteMSec, _BlackMSec, Index: Integer;
  _PlayerInGame: string;
begin
  { Lots to send, buffer it up. }
  if Game.EventID <> 0 then exit;
  fSocket.Buffer := True;
  try // fSocket.Buffer := False

  with Game do
    begin
      if (White = Connection) or (Black = Connection) then
        _PlayerInGame := '1'
      else
        _PlayerInGame := '0';

      { Send DP_GAME_BORN }
      fSocket.Send(Connection,
        [DP_GAME_BORN, IntToStr(GameNumber), Site, Event, IntToStr(Round), Date,
        WhiteLogin, WhiteTitle, IntToStr(WhiteRating),
        BlackLogin, BlackTitle, IntToStr(BlackRating),
        IntToStr(WhiteInitialMSec), IntToStr(WhiteIncMSec), IntToStr(Ord(GameMode)),
        _PlayerInGame, IntToStr(Ord(RatedType)), IntToStr(Integer(Rated)), '0',
        IntToStr(EventId), IntToStr(EventOrdNum),
        IntToStr(BlackInitialMSec), IntToStr(BlackIncMSec)],nil);

      with Odds do
        fSocket.Send(Connection,
          [DP_GAME_ODDS, IntToStr(GameNumber),
           BoolTo_(FAutoTimeOdds, '1', '0'),
           IntToStr(FInitMin), IntToStr(FInitSec),
           IntToStr(FInc), IntToStr(FPiece),
           IntToStr(ord(FTimeDirection)), IntToStr(ord(FPieceDirection)),
           IntToStr(ord(FInitiator))],Game);


      { Send DP_FEN if necessary }
      if FEN <> '' then fSocket.Send(Connection,
        [DP_FEN, IntToStr(GameNumber), FEN],nil);

      { Send moves up to the current position }
      for Index := 1 to MoveNumber do
        begin
          _Move := Moves[Index];
          fSocket.Send(Connection, [DP_MOVE, IntToStr(GameNumber),
            IntToStr(_Move.FFrom), IntToStr(_Move.FTo),
            IntToStr(_Move.FPosition[_Move.FTo]),
            IntToStr(Ord(_Move.FType)), _Move.FPGN],nil);
        end;

      { Send game result if any }
      if not (GameResult = grNone) then
        fSocket.Send(Connection, [DP_GAME_RESULT, IntToStr(GameNumber),
          RESULTCODES[Ord(GameResult)]],nil);

      { Send DP_MSec }
      GetMSec(_WhiteMSec, _BlackMSec);
      fSocket.Send(Connection, [DP_MSEC, IntToStr(GameNumber),
        IntToStr(_WhiteMSec), IntToStr(_BlackMSec)],nil);

      { Send show board }
      fSocket.Send(Connection, [DP_SHOW_GAME, IntToStr(GameNumber)],nil);

      { Send list of observers & players to Connection. }
      fSocket.Send(Connection, [DP_OBSERVER_BEGIN, IntToStr(GameNumber)],nil);
      for Index := 0 to Connections.Count -1 do
        begin
          _Connection := TConnection(Connections[Index]);
          if not _Connection.Invisible then
            fSocket.Send(Connection, [DP_OBSERVER, IntToStr(GameNumber),
              IntToStr(_Connection.LoginID), _Connection.Handle, _Connection.Title, _Connection.RatingString],_Connection);
        end;
      fSocket.Send(Connection, [DP_OBSERVER_END, IntToStr(GameNumber)],nil);
      SendGameScore(Connection);
    end;

  finally
    fSocket.Buffer := False;
    fSocket.Send(Connection, [''],nil);
  end;

   { Send this observer to all other players/observers (not itself) }
  with Game do
    begin
      if (Connection = White) or (Connection = Black) or Connection.Invisible then Exit;
      for Index := 0 to Connections.Count -1 do
        TConnection(Connections[Index]).Send := True;
      Connection.Send := False;
      fSocket.Send(Connections, [DP_OBSERVER, IntToStr(GameNumber),
        IntToStr(Connection.LoginID), Connection.Handle, Connection.Title, Connection.RatingString],Connection);
    end;
end;
//______________________________________________________________________________
procedure TGames.Release(var Connection: TConnection; FreeAll: Boolean);
var
  Game: TGame;
  Index: Integer;
begin
  { If this connection is leaving (via the exit command or a disconnection)
    then iterate though all it's games and quit the game. Do not free live
    games the Connection is playing if FreeAll is false, they might be
    reconnecting. }
  for Index := Connection.Games.Count -1 downto  0 do
    begin
      Game := TGame(Connection.Games[Index]);

      if Game=nil then continue;
      //if Game.EventId<>0 then continue;

      if (Game.GameMode = gmLive) and (Game.Rated) and (not FreeAll)
      and ((Game.White = Connection) or (Game.Black = Connection)) then
        Continue
      else begin
        if Game.EventID=0 then Quit(Game, Connection);
      end;
    end;
end;
//______________________________________________________________________________
procedure TGames.RestoreGames(var Connection: TConnection);
var
  _Game: TGame;
  Index: Integer;
begin
  if Connection.Invisible then exit;
  { Resends all info needed to create a game for all games owned by a
    Connection. Indended to be called upon re-connection. }
  for Index := 0 to Connection.Games.Count -1 do
    begin
      _Game := TGame(Connection.Games[Index]);
      LaunchGame(Connection, _Game);
      { ??? retore draw, abort, adjourn offers too? }
    end;
end;
//______________________________________________________________________________
procedure TGames.SaveGame(GM: TGame);
var
  th: TGameSaveThread;
begin
  if GM.SavedInDB then exit;

  if DB_SAVEGAME_THREAD then begin
    th:=TGameSaveThread.Create(GM);
    if GM.EventId<>0 then th.WaitFor;
  end else
    fDB.SaveGame(GM);

  GM.SavedInDb:=true;
  fAchievements.OnAchEvent(GM);
end;

procedure TGames.SendGames(var Connection: TConnection);
var
  _Game: TGame;
  Index: Integer;
begin
  fSocket.Send(Connection, [DP_GAME_BEGIN],nil);

  for Index := FGames.Count -1 downto 0 do begin
    _Game := TGame(FGames[Index]);
    if _Game = nil then begin
      FGames.Delete(Index);
      continue;
    end;
    if _Game.EventId<>0 then continue;
    if (_Game.WhiteLogin='') or (_Game.BlackLogin='') then begin
      FGames.Delete(Index);
      continue;
    end;

    with _Game do fSocket.Send(Connection, [DP_GAME, IntToStr(GameNumber),
        WhiteLogin, WhiteTitle, IntToStr(WhiteRating),
        BlackLogin, BlackTitle, IntToStr(BlackRating),
        IntToStr(Ord(RatedType)), IntToStr(WhiteInitialMSec), IntToStr(WhiteIncMSec),
        IntToStr(Integer(Rated)), RESULTCODES[Ord(GameResult)], IntToStr(Integer(Locked)),
        IntToStr(BlackInitialMSec), IntToStr(BlackIncMSec)],_Game);
  end;

  fSocket.Send(Connection, [DP_GAME_END],nil);
end;
//______________________________________________________________________________
function TGames.UserIsPlaying(Connection: TConnection): Boolean;
var
  i: integer;
  game: TGame;
begin
  result:=true;
  for i:=0 to Games.Count-1 do begin
    game:=TGame(Games[i]);
    if ((game.White = Connection) or (game.Black = Connection)) and
      (game.GameMode = gmLive) and (game.GameResult = grNone)
    then
      exit;
  end;
  result:=false;
end;
//______________________________________________________________________________
procedure TGames.CMD_AdjournAll(var Connection: TConnection;
  const CMD: TStrings);
var
  i,cnt: integer;
  _Game: TGame;
  msg: string;
begin

  cnt:=0;
  for i:=FGames.Count-1 downto 0 do begin
    _Game := TGame(FGames[i]);
    if _Game.EventId<>0 then continue;
    if _Game.GameMode<>gmLive then continue;
    msg:='Game adjourned by '+Connection.Handle+' because of administration purposes. You can continue later.';
    fSocket.Send(_Game.White,[DP_GAME_MSG, IntToStr(_Game.GameNumber), DP_ERR_0, msg],nil);
    fSocket.Send(_Game.Black,[DP_GAME_MSG, IntToStr(_Game.GameNumber), DP_ERR_0, msg],nil);
    _Game.GameResult:=grAdjourned;
    inc(cnt);
  end;
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0, IntToStr(cnt)+' games adjourned'],nil);
end;
//______________________________________________________________________________
procedure TGames.CMD_Win(var Connection: TConnection; var CMD: TStrings);
var
  _Game: TGame;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));

  if _Game.EventId<>0 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Cannot abort event game'],nil);
      Exit;
    end;

  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a live game (not examined) }
  if _Game.GameMode = gmExamined then Exit;

  if not _Game.PlayerDisconnected then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'You cannot promote youself winner while your opponent is connected.'],nil);
    exit;
  end;

  if lowercase(Connection.Handle) = lowercase(_Game.WhiteLogin) then _Game.GameResult := grBlackForfeitsOnNetwork
  else if lowercase(Connection.Handle) = lowercase(_Game.BlackLogin) then _Game.GameResult := grWhiteForfeitsOnNetwork;
end;
//______________________________________________________________________________
procedure TGames.CMD_Disconnect(var Connection: TConnection;
  const CMD: TStrings);
var
  _Game: TGame;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameNumber (GAME_NUM) optional, use Primary if missing }

  { If no game number passed with command then attempt to get one from the
    Primary property of the Connection Object }
  if CMD.Count = 1 then
    if Connection.Primary <> nil then
      CMD.Add(IntToStr(TGame(Connection.Primary).GameNumber))
    else
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_PRIMARY_GAME],nil);
        Exit;
      end;

  { Check paramater values }
  try
    StrToInt(CMD[GAME_NUM]);
  except
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
      Exit;
    end;
  end;

  { Find the game }
  _Game := GetGame(StrToInt(CMD[GAME_NUM]));

  if _Game.EventId<>0 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Cannot abort event game'],nil);
      Exit;
    end;

  if not Assigned(_Game) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Restrict move input to players of the game only }
  with _Game do
    if not (Connection = White) and not (Connection = Black) then
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_GAME_PLAYER],nil);
        Exit;
      end;

  { Must be a live game (not examined) }
  if _Game.GameMode = gmExamined then Exit;

  _Game.MakeDisconnectChoise(Connection);
end;
//______________________________________________________________________________

//______________________________________________________________________________
procedure TGames.SetFlagEventResults;
var
  GM: TGame;
  i: integer;
begin
  for i:=0 to Games.Count-1 do begin
    GM:=TGame(Games[i]);
    if (GM.EventId = 0) or (GM.GameResult <> grNone) then continue;

    if (GM.WhiteDisconnectTime <> 0) and ((Now - Gm.WhiteDisconnectTime)*MSecsPerDay>EVENT_TIMEOUT) then
      GM.GameResult:=grWhiteForfeitsOnNetwork
    else if (GM.BlackDisconnectTime <> 0) and ((Now - Gm.WhiteDisconnectTime)*MSecsPerDay>EVENT_TIMEOUT) then
      GM.GameResult:=grBlackForfeitsOnNetwork;
  end;
end;
//______________________________________________________________________________
procedure TGames.SetDisconnectionTime(Connection: TConnection);
var
  GM: TGame;
  i: integer;
begin
  for i:=0 to Games.Count-1 do begin
    GM:=TGame(Games[i]);
    if (GM.EventId = 0) or (GM.GameResult <> grNone) then continue;

    if lowercase(GM.WhiteLogin) = lowercase(Connection.Handle) then
      GM.WhiteDisconnectTime:=Now
    else if lowercase(GM.BlackLogin) = lowercase(Connection.Handle) then
      GM.BlackDisconnectTime:=Now;
  end;
end;
//______________________________________________________________________________
procedure TGames.CheckTimeForfeits;
var
  i, msec, color: integer;
  game: TGame;
  move: TMove;
begin
  if not AUTO_FORFEITS_TIME then exit;
  for i := fGames.Count - 1 downto 0 do begin
    game := TGame(fGames[i]);
    if game.GameResult <> grNone then continue;

    move := TMove(game.Moves[game.MoveTotal]);
    color := -1 * move.FColor;

    if color = 1 then begin // white
      msec := Trunc((Now - game.LastMoveTS) * MSecsPerDay);
      if game.WhiteMSec - msec < 0 then begin
        if not Assigned(game.White.Socket) then
           game.MakeDisconnectChoise(game.Black)
        else
           game.GameResult := grWhiteForfeitsOnTime;
      end;
    end else begin // black
      msec := Trunc((Now - game.LastMoveTS) * MSecsPerDay);
      if game.BlackMSec - msec < 0 then begin
        if not Assigned(game.Black.Socket) then
           game.MakeDisconnectChoise(game.White)
        else
           game.GameResult := grBlackForfeitsOnTime;
      end;
    end;
    //if game.WhiteMSec
  end;
end;
//______________________________________________________________________________
end.

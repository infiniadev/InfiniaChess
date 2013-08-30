{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLCLS;

interface

uses
  Classes, SysUtils, Forms, Graphics, Dialogs, Controls, ShellAPI, Windows;

type
  TCLCLS = class(TObject)
  private
    { Private declarations }
    FDatapack: TStrings;
    FDataString: string;
    FAchCongratulated: TStringList;
    FUpdating: Boolean;

    procedure _Abort;
    procedure Adjourn;
    procedure Connected;
    procedure _Draw;
    procedure Fen;
    procedure Flag;
    procedure GameBorn;
    procedure GameMessage;
    procedure GameResult;
    procedure GamePerish;
    procedure IllegalMove;
    procedure Included;
    procedure Kibitz;
    procedure Login;
    procedure LoginResult;
    procedure Markers;
    procedure MoretimeRequest;
    procedure _Move;
    procedure MoveList;
    procedure _MSec;
    procedure RegisterResult;
    procedure Say;
    procedure ServerMessage;
    procedure Settings;
    procedure Shout;
    procedure ShowGame;
    procedure Takeback;
    procedure TakebackRequest;
    procedure TellLogin;
    procedure TellRoom;
    procedure TellEvent;
    procedure Whisper;
    procedure Log(Datapack: TStrings);
    procedure ProcessDatapack;
    procedure AuthKeyResult(Datapack: TStrings);
    procedure CMD_ClubBegin(Datapack: TStrings);
    procedure CMD_Club(Datapack: TStrings);
    procedure CMD_ClubEnd(Datapack: TStrings);
    procedure CMD_GameScore(Datapack: TStrings);
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    procedure Receive(const ReceivedData: string; TotalBytes: Integer);
    procedure CMD_Photo(Datapack: TStrings);
    procedure CMD_Notes(Datapack: TStrings);
    procedure CMD_ClubChanged(CMD: TStrings);
    procedure CMD_UserPing(CMD: TStrings);
    procedure CMD_Rights(CMD: TStrings);
    procedure CMD_ClearTimeOddsLimits(CMD: TStrings);
    procedure CMD_AddTimeOddsLimit(CMD: TStrings);
    procedure CMD_GameOdds(CMD: TStrings);
    procedure CMD_ClientUpdate(CMD: TStrings);
    procedure CMD_AchUser(CMD: TStrings);
    procedure CMD_AchUserInfo(CMD: TStrings);
    procedure CMD_AchUserInfoClear(CMD: TStrings);
    procedure CMD_AchFinished(CMD: TStrings);
    procedure CMD_AchSendEnd(CMD: TStrings);
    procedure CMD_UrlOpen(CMD: TStrings);
    procedure CMD_AchClear(CMD: TStrings);
    procedure CMD_Roles(CMD: TStrings);
    procedure CMD_SpecialOffer(CMD: TStrings);
    procedure ProcessRights;
    procedure CMD_Login2(CMD: TStrings);
    procedure CMD_AutoUpdate(CMD: TStrings);
  end;

var
  fCLCLS: TCLCLS;

implementation

uses
  CLBoard, CLConst, CLGame, CLGames, CLGlobal, CLLogin, CLMain, CLMessages,
  CLNavigate, CLNotify, CLPgn, CLRooms, CLSocket, CLTerminal,
  CLRegister, CLConsole, CLFilterManager, CLProfile, CLBan, CLEvents,
  CLEventControl,CLLib, CLImageLib, CLSocket2, CLStat, CSClub, CLRating, CLOfferOdds,
  CLAutoUpdate, CLClubList, CLAchievementClass, CLClubs, CLAchList, CLWarning,
  CLMembershipType, CLSeeks, CLLogins, CLAutoUpdateThread;

//==============================================================================
{ DP_ABORT: DG#, GameNumber, PlayerRequestingDraw, Title }
procedure TCLCLS._Abort;
var
  Game: TCLGame;
  s: string;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  s:=FDatapack[2] + ' requests the game be aborted. Click "/abort ' + FDatapack[1] + '" to agree.';
  fCLTerminal.AddLine(fkGame, Integer(Game), s, ltServerMsgNormal);
  if Game.GameMode = gmCLSLive then fGL.PlayCLSound(SI_OFFER);
end;
//==============================================================================
{ DP_ADJOURN: DG#, GameNumber, PlayerRequestingAdjourn, Title}
procedure TCLCLS.Adjourn;
var
  Game: TCLGame;
  s: string;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  s:=FDatapack[2] + ' requests the game be adjourned. Click "/adjourn ' + FDatapack[1] + '" to agree.';
  fCLTerminal.AddLine(fkGame, Integer(Game), s,ltServerMsgNormal);
  if Game.GameMode = gmCLSLive then fGL.PlayCLSound(SI_OFFER);
end;
//==============================================================================
procedure TCLCLS.Connected;
begin
  { Received one time from the server after a successful connection has been
    established. Either login or send registration request. }
  if (fCLLogin = nil) or (fCLLogin.ButtonPressed = 0) then // login
    fCLSocket.InitState := isBeginLogin
  else
    fCLSocket.InitState := isForgotPassword;
end;
//==============================================================================
{ DP_DRAW: DG#, GameNumber, PlayerRequestingDraw, Title }
procedure TCLCLS._Draw;
var
  Game: TCLGame;
  s: string;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  s:=FDatapack[2] + ' offers you a draw. Click "/draw ' + FDatapack[1] + '" to accept.';
  fCLTerminal.AddLine(fkGame, Integer(Game), s, ltServerMsgNormal);

  if Game.GameMode = gmCLSLive then fGL.PlayCLSound(SI_OFFER);
end;
//==============================================================================
{ DP_FEN: DG#, GameNumber, FEN }
procedure TCLCLS.Fen;
var
  Game: TCLGame;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;

  with Game do if not Lag then FEN := FDatapack[2] else Lag := False;
  { ??? fCLBoard.UpdateMoveList(Game, True); }
end;
//==============================================================================
{ DP_FLAG: DG#, GameNumber }
procedure TCLCLS.Flag;
var
  Game: TCLGame;
  s: string;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  with Game do
    begin
      if MyColor = WHITE then
        s := IntToStr(WhiteMSec)
      else
        s := IntToStr(BlackMSec);

      fCLSocket.InitialSend([CMD_STR_ACK_FLAG, FDatapack[1], s]);
    end;
end;
//==============================================================================
{ DP_GAME_BORN: DP#, GameNumber, Site, Event, Round, Date,
  WhiteName, WhiteTitle, WhiteRating,
  BlackName, BlackTitle, BlackRating,
  InitialMSec, IncMSec, GameMode (0=gmLive, 1=gmExamine),
  PlayerInGame (0=no 1=yes), RatedType, Rated }
procedure TCLCLS.GameBorn;
var
  Game: TCLGame;
  index: integer;
begin
  { If this game number already exists, we cannot create a duplicate }
  CLLib.log('GameBorn');
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game <> nil then Exit;

  Game := fCLBoard.CreateGame;
  CLLib.log('Game created');

  with Game do
    begin
      GameNumber := StrToInt(FDatapack[1]);
      Site := FDatapack[2];
      Event := FDatapack[3];
      Round := FDatapack[4];
      Date := FDatapack[5];
      WhiteName := FDatapack[6];
      WhiteTItle := FDatapack[7];
      WhiteRating := FDatapack[8];
      BlackName := FDatapack[9];
      BlackTitle :=  FDatapack[10];
      BlackRating := FDatapack[11];
      if BlackName = fCLSocket.MyName then MyColor := BLACK;
      if WhiteName = fCLSocket.MyName then MyColor := WHITE;
      WhiteInitialTime := StrToInt(FDatapack[12]) div MSecsPerMinute;
      WhiteIncTime := StrToInt(FDatapack[13]) div MSecs;
      WhiteMSec := StrToInt(FDatapack[12]);
      WhiteInitialMSec := WhiteMSec;

      if FDatapack.Count>22 then begin
        BlackInitialTime := StrToInt(FDatapack[21]) div MSecsPerMinute;
        BlackIncTime := StrToInt(FDatapack[22]) div MSecs;
        BlackMSec := StrToInt(FDatapack[21]);
      end else begin
        BlackInitialTime := WhiteInitialTime;
        BlackIncTime := WhiteIncTime;
        BlackMSec := WhiteMSec;
      end;
      BlackInitialMSec:=BlackMSec;

      if FDatapack[15] = '1' then
        if FDatapack[14] = '0' then
          GameMode := gmCLSLive
        else
          GameMode := gmCLSExamine
      else
        if FDatapack[14] = '0' then
          GameMode := gmCLSObserve
        else
          GameMode := gmCLSObEx;

      if (GameMode = gmCLSLive) and (MyColor = BLACK) then Inverted := True;

      LogGame := (fGL.LogGames = lgAll)
      or ((fGL.LogGames = lgMine) and (GameMode = gmCLSLive));

      RatingType := TRatedType(Ord(StrToInt(FDatapack[16])));
      Rated := Boolean(StrToInt(FDatapack[17]));

      if FDatapack[17] = '1' then
        GameStyle := GameStyle + 'Rated' + #32
      else
        GameStyle := GameStyle + 'Unrated' + #32;

      GameStyle := GameStyle + RATED_TYPES[Ord(RatingType)] + #32;
      GameStyle := GameStyle + IntToStr(WhiteInitialTime) + #32;
      GameStyle := GameStyle + IntToStr(WhiteIncTime) + #32;

      if FDatapack.Count>19 then EventId:=StrToInt(FDatapack[19])
      else EventId:=0;

      if FDatapack.Count>20 then EventOrdNum:=StrToInt(FDatapack[20])
      else EventOrdNum:=0;


      if EventId<>0 then begin
        if Game.UserColor(fCLSocket.MyName)=uscNone then GameMode:=gmCLSObserve
        else GameMode:=gmCLSLive;
        fCLEvents.OnGameBorn(Game);
      end;

      if GameMode = gmCLSLive then fGL.PlayCLSound(SI_GAMESTART);
    end;
    CLLib.log('Gameborn finished');
end;
//==============================================================================
{ DP_GAME_MSG: DP#, GameNumber, ErrorLevel, Message }
procedure TCLCLS.GameMessage;
var
  Game: TCLGame;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game <> nil then
    fCLTerminal.AddLine(fkGame, Integer(Game), FDatapack[3],
      TLineTrait(ord(ltServerMsgNormal) + StrToInt(FDatapack[2])));
end;
//==============================================================================
{ DP_GAME_RESULT: DG#, GameNumber, ResultCode, ResultMessage }
procedure TCLCLS.GameResult;
var
  Game: TCLGame;
  PGN: TCLPgn;
  Index: Integer;
begin
  { Board }
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game <> nil then begin
    with Game do
      begin
        { This DP might come twice (once if you're playing/observing and once
          to update the game window for all players). Wouldn't hurt anything
          to let it through both times, but we'll cut it off at one time using
          the GameResult field. }
        if GameResult <> '' then Exit;

        { Sound Event }
        if (GameMode in [gmCLSLive, gmCLSObserve]) and (fCLBoard.GM = Game) then
          fGL.PlayCLSound(SI_GAMERESULT);

        { Adjust Game Results }
        Index := StrToInt(FDatapack[2]);
        GameResult := RESULTCODES[Index];
        GameResultDesc := RESULTMSGS[Index];
        fCLMain.SetGameInfo;

        { Send the result string to the game window. }
        fCLTerminal.AddLine(fkGame, Integer(Game), GameResultDesc,
          ltServerMsgNormal);

        { Log game }
        if LogGame and (GameMode in [gmCLSLive, gmCLSObserve, gmCLSExamine])
        and (fGL.PGNFile <> '') and fCLSocket.Rights.SavingGames{and not NO_IO} then
          begin
            try
              PGN := TCLPgn.Create(fGL.PGNFile, pmWrite);
              PGN.LogGame(Game);
              PGN.Free;
            except
              MessageDlg('Cannot save game. Check PGN file name in options, page "General"',
                mtError,[mbOk],0);
            end;
          end;

        { Adjusts Game Mode }
        if GameMode = gmCLSLive then
          GameMode := gmCLSExamine
        else if GameMode = gmCLSObserve then
          GameMode := gmCLSObEx;
      end;

    if Game.EventId<>0 then fCLEvents.OnGameResult(Game)
    else fCLGames.GameResult(FDatapack);

  end;
  { Update the Games window }
end;
//==============================================================================
{ DP_GAME_PERISH: DG#, GameNumber }
procedure TCLCLS.GamePerish;
var
  Game: TCLGame;
begin
  { Board }
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game <> nil then Game.GameMode := gmNone;
  fCLTerminal.ClearObservers(Integer(Game));
end;
//==============================================================================
{ DP_ILLEGAL_MOVE: DG#, GameNumber, ReasonMessage }
procedure TCLCLS.IllegalMove;
var
  Game: TCLGame;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  with Game do
    if Lag then
      begin
        Lag := False;
        Takeback(1)
      end;

  fCLTerminal.AddLine(fkGame, Integer(Game), FDatapack[2], ltServerMsgError);
end;
//==============================================================================
{ DP_INCLUDED: DP#, GameNumber, Color }
{ Sent when the an /include command has been successfully issued. Must tell the
client that it's ok for the user to move pieces on the board. }
procedure TCLCLS.Included;
var
  Game: TCLGame;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  Game.GameMode := gmCLSExamine;
end;
//==============================================================================
{ DP_KIBITZ: DP#, GameNumber, From, Title, Message }
procedure TCLCLS.Kibitz;
var
  Game: TCLGame;
  name: string;
begin
  name:=FDatapack[2];
  if trim(FDatapack[3])<>'' then name:=name+' ('+FDatapack[3]+')';
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  fCLTerminal.AddLine(fkGame, Integer(Game),
    name + ': ' + FDatapack[4], ltKibitz, StrToInt(FDatapack[5]));
end;
//==============================================================================
{ DP_LOGIN: DP#, Login, Title, AdminLevel }
procedure TCLCLS.Login;
var
  L: TCLLogin;
begin
  fCLSocket.MyName := FDatapack[1];
  fCLSocket.MyTitle := FDatapack[2];
  fCLSocket.MyAdminLevel := StrToInt(FDatapack[3]);
  fCLTerminal.AddLine(fkConsole, 0, 'Welcome ' + FDatapack[1], ltServerMsgNormal);
  fCLSocket.InitState := isLoginComplete;
  if fCLSocket.Account.Command <> '' then
    fCLSocket.InitialSend([fCLSocket.Account.Command]);
  fGL.PlayCLSound (SI_SIGNEDIN);
  fCLMain.SetToolButtonState(3);
  fCLMain.SetActivePane(3, fCLNavigate.clNavigate.Items.Objects[3]);
  fCLMain.ArrangeMenu;
  if fLoginImages.Photo[fCLSocket.MyName]<>nil then
    CopyBitmap(fLoginImages.Photo[fCLSocket.MyName],fGL.Photo64);

  if FDatapack.Count>5 then fCLSocket.ClubId := StrToInt(FDatapack[4]);
  if FDatapack.Count>6 then fCLSocket.ClubName := FDatapack[5]
  else fCLSocket.ClubName:=fClubs.NameById(fCLSocket.ClubId);
  fCLMain.SetClubName(fCLSocket.ClubName);

  if fClubs.Count>0 then
    if fCLSocket.ClubId = 1 then fClubs[0].status := clsMember
    else fClubs[0].status := clsNone;

  fCLNotify.ArrangeTabs;

  {if not fCLSocket.RatingInitialized then begin
    L := fCLTerminal.GetCLLogin(fCLSocket.MyName);
    if L <> nil then
      fCLSocket.SetMyRating(L.FRatingString, L.FProvString);
  end;}

end;
//==============================================================================
{ DP_LOGIN_ERROR: DP#, ErrorNumber, ErrorDescription }
procedure TCLCLS.LoginResult;
var
  n: integer;
  email: string;
begin
  {if StrToInt(FDatapack[1]) = DP_CODE_LOGIN_SUCCESS then
    fCLSocket.InitState := isFinishLogin
  else if Assigned(fCLLogin) then
    fCLLogin.lblInfo.Caption := FDatapack[2];}
  n:=StrToInt(FDatapack[1]);
  if (n = DP_CODE_LOGIN_UNBANNEDCLIENT) and IS_BANNED then
    begin
      IS_BANNED:=false;
      Unban;
    end
  else if (n = DP_CODE_LOGIN_BANNEDCLIENT) and not IS_BANNED then
    begin
      Ban;
      IS_BANNED := true;
      FDatapack[1]:='-5';
      n:=-5;
    end;

  if ((n=DP_CODE_LOGIN_SUCCESS) or (n=DP_CODE_LOGIN_UNBANNEDCLIENT)) and not IS_BANNED then
    fCLSocket.InitState := isFinishLogin
  else if Assigned(fCLLogin) then
    if n = DP_CODE_LOGIN_AUTH_KEY then begin
      email:=FDatapack[3];
      fCLLogin.AskAuthKey(email);
    end else
      fCLLogin.lblInfo.Caption := FDatapack[2];
end;
//==============================================================================
{ DP_ARROW: DG#, GameNumber, FromSqr, ToSqr }
procedure TCLCLS.Markers;
var
  Game: TCLGame;
  sCol: string;
  cmd: integer;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;

  cmd:=StrToInt(FDatapack[0]);
  if (cmd=DP_ARROW) and (FDatapack.Count>4) then sCol:=FDatapack[4]
  else if (cmd=DP_CIRCLE) and (FDatapack.Count>3) then sCol:=FDatapack[3]
  else sCol:='blue';

  case cmd of
    DP_ARROW:
      Game.AddMarker(StrToInt(FDatapack[2]), StrToInt(FDatapack[3]),sCol);
    DP_UNARROW:
      Game.AddMarker(StrToInt(FDatapack[2]), StrToInt(FDatapack[3]),sCol);
    DP_CIRCLE:
      Game.AddMarker(StrToInt(FDatapack[2]), -1, sCol);
    DP_UNCIRCLE:
      Game.AddMarker(StrToInt(FDatapack[2]), -1, sCol);
    DP_CLEAR_MARKERS:
      Game.ClearMarkers;
  end;
end;
//==============================================================================
{ DP_MORETIME_REQUEST: DP# GameNumber, Secs, PlayerRequestingMoreTime, Title }
procedure TCLCLS.MoretimeRequest;
var
  Game: TCLGame;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  with Game do
    begin
      fCLTerminal.AddLine(fkGame, Integer(Game),
        FDatapack[3] + ' requests that ' +
        FDatapack[2] + ' seconds be added to each clock. Click "/moretime ' +
        FDatapack[1] + #32 + FDatapack[2] + '" to accept.', ltServerMsgNormal);
      if GameMode = gmCLSLive then fGL.PlayCLSound(SI_OFFER);
    end;
end;
//==============================================================================
{ DP_MOVE: DG#, GameNumber, FromSqr, ToSqr, Promo, MoveTyep, PGN }
procedure TCLCLS._Move;
var
  Game: TCLGame;
  GameNumber: integer;
  i,From,_To: integer;
begin
  GameNumber := StrToInt(FDatapack[1]);
  Game := fCLBoard.Game(GameNumber);
  if Game = nil then Exit;

  From:=StrToInt(FDatapack[2]);
  _To:=StrToInt(FDataPack[3]);

  {if (From=Game.LastReceivedFrom) and (_To=Game.LastReceivedTo) then
    exit;}

  with Game do
    begin
      AddMove(From, _To,
        StrToInt(FDatapack[4]), TMoveType(StrToInt(FDatapack[5])), FDatapack[6]);
      //Game.LastReceivedFrom:=From;
      //Game.LastReceivedTo:=_To;

      for i:=FDatapack.Count to 9 do
        FDatapack.Add('0');
      WhiteCheatMode:=TCheatMode(StrToInt(FDatapack[7]));
      BlackCheatMode:=TCheatMode(StrToInt(FDatapack[8]));

      Lag := False;
      { ??? fix so it doesn't play when first loading a game. }
      if (MoveStatus = msCheck) and (fCLBoard.GM = Game) then fGL.PlayCLSound(SI_CHECK);
      fCLBoard.DoPremove(Game);
      fCLBoard.ShowCheatLights;
      if (fGL.ShowLastMoveType = 1) and (fCLBoard.GM = Game) then begin
        fCLBoard.DrawBoardFull;
        //fCLBoard.DrawBoard2(0, Game.MoveNumber, daNone);
      end;
    end;

  fCLBoard.SetClockEnabled(Game);
  {if fCLBoard.GM = Game then
    fCLBoard.DrawBoardFull;}
  if (Game.EventId<>0) then fCLEvents.OnDoTurn(Game);
end;
//==============================================================================
procedure TCLCLS.MoveList;
var
  Game: TCLGame;
  i: integer;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  {if StrToInt(FDatapack[0]) = DP_MOVE_BEGIN then begin
    for i:=Game.Moves.Count-1 downto 1 do
      Game.Moves.Delete(i);
  end;}
  Game.Render := StrToInt(FDatapack[0]) = DP_MOVE_END;
end;
//==============================================================================
{ DP_MSEC: DG#, GameNumber, WhiteMSec, BlackMSec }
procedure TCLCLS._MSec;
var
  Game: TCLGame;
begin
  CLLib.Log('_Msec');
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;

  with Game do
    begin
      WhiteMSec := StrToInt(FDatapack[2]);
      BlackMSec := StrToInt(FDatapack[3]);
    end;
  CLLib.Log('_Msec finished');
end;
//==============================================================================
{ DP_REGISTER: DP# ResultCode, ResultMSG, Login, Password }
procedure TCLCLS.RegisterResult;
var
  Account: TAccount;
begin
  { Successful registration. Automatically add an Account. It's here instead of
    in fCLRegister so a command line registration works as well. }
  if StrToInt(FDatapack[1]) = DP_CODE_REGISTER_SUCCESS then
    begin
      Account := TAccount.Create;
      Account.Server := CHESSLINK_SERVER;
      Account.Port := CHESSLINK_PORT;
      Account.Name := FDatapack[3];
      Account.Login := FDatapack[3];
      Account.Password := FDatapack[4];
      fGL.Accounts.Add(Account);
      fGL.Save;
    end;

  if fCLRegister <> nil then
    fCLRegister.RegisterResult(FDatapack)
  else
    fCLTerminal.AddLine(fkConsole, 0, FDatapack[2], ltServerMsgWarning);
end;
//==============================================================================
{ DP_SAY: DP#, GameNumber, From, Title, Message }
procedure TCLCLS.Say;
var
  Game: TCLGame;
  name: string;
begin
  name:=FDatapack[2];
  if trim(FDatapack[3])<>'' then name:=name+' ('+FDatapack[3]+')';

  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  fCLTerminal.AddLine(fkGame, Integer(Game),
    name + ': ' + FDatapack[4], ltSays, StrToInt(FDatapack[5]));
  fGL.PlayCLSound(SI_TELL);
end;
//==============================================================================
{ DP_SERVER_MESSAGE: DP#, ErrorLevel, Message }
procedure TCLCLS.ServerMessage;
begin
  if FDatapack[1] = '0' then
    fCLTerminal.AddLine(fkConsole, 0, FDatapack[2], ltServerMsgNormal)
  else if FDatapack[1] = '1' then
    fCLTerminal.AddLine(fkConsole, 0, FDatapack[2], ltServerMsgWarning)
  else fCLTerminal.AddLine(fkConsole, 0, FDatapack[2], ltServerMsgError);
  fCLTerminal.FocusConsoleFilter;
end;
//==============================================================================
{ DP_SETTINGS: DP# Autoflag, Open, RemoveOffers, InitialTime, IncTime, Color,
  Rated, RatedType, MaxRating, MinRating }
procedure TCLCLS.Settings;
var s: string;
begin
  fGL.AutoFlag := Boolean(StrToInt(FDatapack[1]));
  fGL.Open := Boolean(StrToInt(FDatapack[2]));
  fGL.RemoveOffers := Boolean(StrToInt(FDatapack[3]));
  fGL.SeekInitial := FDatapack[4];
  fGL.SeekInc := StrToInt(FDatapack[5]);
  fGL.SeekColor := StrToInt(FDatapack[6]);
  fGL.SeekRated := Boolean(StrToInt(FDatapack[7]));
  fGL.SeekType := StrToInt(FDatapack[8]);
  fGL.SeekMaximum := StrToInt(FDatapack[9]);
  fGL.SeekMinimum := StrToInt(FDatapack[10]);
  if FDatapack.Count>=13 then begin
    fGL.CReject := FDatapack[11]='1';
    fGL.PReject := FDatapack[12]='1';
  end;
  fGL.Email:=FDatapack[13];
  fGL.CountryId:=StrToInt(FDatapack[14]);
  fGL.SexId:=StrToInt(FDatapack[15]);
  fGL.Age:=StrToInt(FDatapack[16]);
  if FDatapack.Count<18 then fGL.RejectWhilePlaying:=true
  else fGL.RejectWhilePlaying:=FDatapack[17]='1';
  if FDatapack.Count<19 then fGL.BadLagRestrict:=false
  else fGL.BadLagRestrict:=FDatapack[18]='1';

  if FDatapack.Count<20 then ADULT:=adtNone
  else ADULT:=TAdultType(StrToInt(FDatapack[19]));

  if FDatapack.Count<21 then fGL.LoseOnDisconnect:=false
  else fGL.LoseOnDisconnect:=FDatapack[20]='1';

  if FDatapack.Count<22 then fGL.SeeTourShoutsEveryRound:=true
  else fGL.SeeTourShoutsEveryRound:=FDatapack[21]='1';

  if FDatapack.Count<23 then fGL.BusyStatus:=true
  else fGL.BusyStatus:=FDatapack[22]='1';

  if FDatapack.Count<24 then fGL.Language:='English'
  else fGL.Language:=FDatapack[23];

  if FDatapack.Count<25 then fGL.PublicEmail:=false
  else fGL.PublicEmail:=FDatapack[24]='1';

  if FDatapack.Count<26 then fGL.Birthday := 0
  else fGL.Birthday := StrToInt(FDatapack[25]);

  if FDatapack.Count<27 then fGL.ShowBirthday := false
  else fGL.ShowBirthday := FDatapack[26] = '1';

  if FDatapack.Count<28 then fGL.AutoMatch := true
  else fGL.AutoMatch := FDatapack[27] = '1';

  if FDatapack.Count<29 then fGL.AutoMatchMinR := 0
  else fGL.AutoMatchMinR := StrToInt(FDatapack[28]);

  if FDatapack.Count<30 then fGL.AutoMatchMaxR := 3000
  else fGL.AutoMatchMaxR := StrToInt(FDatapack[29]);

  if FDatapack.Count<31 then fGL.AllowSeekWhilePlaying := false
  else fGL.AllowSeekWhilePlaying := FDatapack[30] = '1';
end;
//==============================================================================
{ DP_SHOUT: DP#, From, Title, Message }
procedure TCLCLS.Shout;
var
  name: string;
begin
  name:=GetNameWithTitle(FDatapack[1],FDatapack[2]);
  if name<>'' then name:=name+': ';
  fCLTerminal.AddAnnounce(name+FDatapack[3]);
  {if fGL.Shout and not (not fGL.ShoutDuringGame and (fCLBoard.GM<>nil) and (fCLBoard.GM.GameMode=gmCLSLive))  then
    fCLTerminal.ccConsole.AddLine(-1, name + FDatapack[3], ltShout);}
end;
//==============================================================================
{ DP_SHOW_GAME: DP#, GameNumber }
procedure TCLCLS.ShowGame;
var
  Game: TCLGame;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;

  if Game.EventID=0 then begin
    fCLNavigate.AddGame(Game);
    fCLTerminal.CreateFilter(Game.WhiteName + '/' + Game.BlackName, fkGame,
      Integer(Game));
  end else
    fCLEvents.OnShowGame(Game);
end;
//==============================================================================
{ DP_TAKEBACK: DG#, GameNumber, TakebackCount }
procedure TCLCLS.Takeback;
var
  Game: TCLGame;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  Game.TakeBack(StrToInt(FDatapack[2]));
  fCLBoard.SetClockEnabled(Game);
end;
//==============================================================================
{ DP_TAKEBACK_REQUEST: DG#, GameNumber TakebackCount, PlayerRequestingTakeback, Title }
procedure TCLCLS.TakebackRequest;
var
  Game: TCLGame;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  with Game do
    begin
      fCLTerminal.AddLine(fkGame, Integer(Game),
        FDatapack[3] + ' requests a takeback of ' +
        FDatapack[2] + ' moves. Click "/takeback ' + FDatapack[1] + #32 +
        FDatapack[2] + '" to accept.', ltServerMsgNormal);
        if GameMode = gmCLSLive then fGL.PlayCLSound(SI_OFFER);
    end;
end;
//==============================================================================
{DP_TELL_LOGIN: DP#, (from)LoginID, (from)Login, (from) Title,
(reciprocate)LoginID, (reciprocate)Login, (reciprocate)Title, Message }
procedure TCLCLS.TellLogin;
begin
  fCLTerminal.Tell(FDatapack);
  fGL.PlayCLSound(SI_TELL);
end;
//==============================================================================
{ DP_TELL_ROOM: DP#, RoomNumber, From, Title, Message }
procedure TCLCLS.TellRoom;
var name: string;
begin
  name:=FDatapack[2];
  if trim(FDatapack[3])<>'' then name:=name+' ('+FDatapack[3]+')';
  fCLTerminal.AddLine(fkRoom, StrToInt(FDatapack[1]),
    name + ': ' + FDatapack[4], ltTellRoom, StrToInt(FDatapack[5]));
end;
//==============================================================================
{ DP_WHISPER: DP#, GameNumber, From, Title, Message }
procedure TCLCLS.Whisper;
var
  Game: TCLGame;
  name: string;
begin
  name:=FDatapack[2];
  if trim(FDatapack[3])<>'' then name:=name+' ('+FDatapack[3]+')';

  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;
  fCLTerminal.AddLine(fkGame, Integer(Game),
    name + ': ' + FDatapack[4], ltWhisper, StrToInt(FDatapack[5]));
end;
//==============================================================================
{ DP_ADULT: adulttype }
procedure SetAdult(Datapack: TStrings);
begin
  if Datapack.Count<2 then exit;
  ADULT:=TAdultType(StrToInt(Datapack[1]));
end;
//==============================================================================
procedure TCLCLS.CMD_Photo(Datapack: TStrings);
var
  Login,s: string;
  bmp: Graphics.TBitMap;
  CS,CS1: LongWord;
begin
  fCLSocket2.MMThreadLog('CMD_Photo');
  if Datapack.Count<5 then exit;
  Login:=Datapack[1];
  CS:=StrToInt(Datapack[3]);
  s:=Datapack[4];
  CS1:=ControlSumm(s);
  fCLSocket2.MMThreadLog(Format('... %s; CS_Get = %d; CS_Counted = %d; length = %d',
    [Login, CS, CS1, length(s)]));
  if CS<>CS1 then
    fCLSocket2.MMThreadLog('ControlSumm is not equal');
    //showmessage('CMD_PHOTO: ControlSumm is not equal');
  if (s='') or (s='@!001!0') then fLoginImages.DeleteImage(Login)
  else begin
    bmp:=Graphics.TBitMap.Create;
    if not ANSIStringToBitMap(s,bmp) then exit;
    fLoginImages.Photo[Login]:=bmp;
    if Login = fCLSocket.MyName then
      CopyBitmap(bmp,fGL.Photo64);
    bmp.Free;
  end;
end;
//==============================================================================
procedure TCLCLS.CMD_Notes(Datapack: TStrings);
var
  notes: string;
begin
  if Datapack.Count < 2 then exit;
  if Datapack[1] = '' then notes := ''
  else
    try
      notes := DecryptANSI(Datapack[1]);
    except
      exit;
    end;
  fCLSocket.MyNotes := notes;
end;
//==============================================================================
procedure TCLCLS.Log(Datapack: TStrings);
var
  LogName: string;
  F: TextFile;
  i: integer;
begin
  if DebugHook = 0 then exit;
  LogName:=ExtractFileDir(Application.ExeName)+'\socket.log';
  AssignFile(F,LogName);
  if FileExists(LogName) then Append(F)
  else Rewrite(F);
  try
    writeln(F,'<<<<<< '+SL_DP_CODES.Values[Datapack[0]]+' ('+Datapack[0]+')');
    for i:=1 to Datapack.Count-1 do
      writeln(F,Datapack[i]);
  finally
    Close(F);
  end;
end;
//==============================================================================
procedure TCLCLS.ProcessDatapack;
var
  Index, Code: Integer;
begin
  Val(FDatapack[0], Index, Code);
  if Code = 0 then
    try
      log(FDatapack);                                                  
      case Index of
        DP_SERVER_MSG: ServerMessage;
        DP_PING: fCLSocket.AckPing;
        DP_DIALOG: fCLMain.ShowDialog(FDatapack[2]);
        DP_CONNECTED: Connected;
        DP_LOGIN: Login;
        DP_LOGIN_RESULT: LoginResult;
        DP_REGISTER: RegisterResult;
        DP_LOGOFF: fCLTerminal.LogOff(FDatapack);
        DP_LOGIN_BEGIN: fCLTerminal.LoginBegin;
        DP_LOGIN2: CMD_Login2(FDatapack);
        DP_LOGIN_END: fCLTerminal.LoginEnd;
        DP_SETTINGS: Settings;
        DP_NOTIFY_REMOVE: fCLNotify.NotifyRemove(FDatapack);
        DP_NOTIFY: fCLNotify.Notify(FDatapack);
        DP_NOTIFY_BEGIN: fCLNotify.NotifyBegin;
        DP_NOTIFY_END: fCLNotify.NotifyEnd;
        DP_MESSAGE: fCLMessages.MessageAdd(FDatapack);
        DP_MESSAGE_DELETE: fCLMessages.MessageDelete(FDatapack);
        DP_KIBITZ: Kibitz;
        DP_SAY: Say;
        DP_SHOUT: Shout;
        DP_TELL_LOGIN: TellLogin;
        DP_TELL_ROOM: TellRoom;
        DP_EVENT_TELL: TellEvent;
        DP_WHISPER: Whisper;
        DP_ROOM_DEF: fCLRooms.RoomDef(FDatapack);
        DP_ROOM_DESTROYED: fCLRooms.RoomDestroyed(FDatapack);
        DP_ROOM_I_ENTER: fCLRooms.RoomIEnter(FDatapack);
        DP_ROOM_I_EXIT: fCLRooms.RoomIExit(FDatapack);
        DP_ROOM_DEF_BEGIN: fCLRooms.RoomDefBegin;
        DP_ROOM_DEF_END: fCLRooms.RoomDefEnd;
        DP_ROOM_EXIT: fCLTerminal.RoomExit(FDatapack);
        DP_ROOM_ENTER: fCLTerminal.RoomEnter(FDatapack);
        DP_ROOM_SET_BEGIN: fCLTerminal.RoomSetBegin(FDatapack);
        DP_ROOM_SET_END: fCLTerminal.RoomSetEnd(FDatapack);
        DP_RATING2: fCLTerminal.ReceiveRating2(FDatapack);
        DP_MATCH, DP_SEEK: fCLSeeks.CMD_ReceiveOffer(FDatapack);
        DP_UNOFFER: fCLSeeks.CMD_RemoveOffer(FDatapack);
        DP_PROFILE_GAME: fCLProfile.ProfileGame(FDatapack);
        DP_PROFILE_NOTE: fCLProfile.ProfileNote(FDatapack);
        DP_PROFILE_RATING: FCLProfile.ProfileRating(FDatapack);
        DP_PROFILE_PING: fCLProfile.ProfilePing(FDatapack);
        DP_PROFILE_DATA: fCLProfile.ProfileData(FDatapack);
        DP_PROFILE_BEGIN: fCLProfile.ProfileBegin(FDatapack);
        DP_PROFILE_END: fCLProfile.ProfileEnd(FDatapack);
        DP_GAME_MSG: GameMessage;
        DP_SHOW_GAME: ShowGame;
        DP_GAME_BORN: GameBorn;
        DP_FEN: Fen;
        DP_GAME_RESULT: GameResult;
        DP_GAME_PERISH: GamePerish;
        DP_MOVE: _Move;
        DP_MOVE_BEGIN, DP_MOVE_END: MoveList;
        DP_ILLEGAL_MOVE: IllegalMove;
        DP_MSEC: _MSec;
        DP_FLAG: Flag;
        DP_DRAW: _Draw;
        DP_ABORT: _Abort;
        DP_ADJOURN: Adjourn;
        DP_ARROW, DP_UNARROW, DP_CIRCLE, DP_UNCIRCLE, DP_CLEAR_MARKERS: Markers;
        DP_TAKEBACK_REQUEST: TakebackRequest;
        DP_TAKEBACK: Takeback;
        DP_GAME_PERISH2: fCLGames.GamePerish(FDatapack);
        DP_GAME_BEGIN: fCLGames.GamesBegin;
        DP_GAME: fCLGames.Games(FDatapack);
        DP_GAME_END: fCLGames.GamesEnd;
        DP_GAME_LOCK: fCLGames.GameLock(FDatapack);
        DP_UNOBSERVER: fCLTerminal.UnObserver(FDatapack);
        DP_OBSERVER: fCLTerminal.Observer(FDatapack);
        DP_OBSERVER_BEGIN: fCLTerminal.ObserverBegin(FDatapack);
        DP_OBSERVER_END: fCLTerminal.ObserverEnd(FDatapack);
        DP_MORETIME_REQUEST: MoretimeRequest;
        DP_INCLUDED: Included;
        DP_FOLLOW_START: fCLTerminal.FollowStart(FDatapack);
        DP_FOLLOW_END: fCLTerminal.FollowEnd(FDatapack);

        DP_EVENT_CREATED: fCLEvents.CMD_EventCreate(FDatapack);
        DP_EVENT_ODDS_ADD: fCLEvents.CMD_EventOddsAdd(FDatapack);

        DP_EVENT_STARTED: fCLEvents.CMD_EventStarted(FDatapack);
        DP_EVENT_FINISHED: fCLEvents.CMD_EventFinished(FDatapack);
        DP_EVENT_DELETED: fCLEvents.CMD_EventDeleted(FDatapack);

        DP_EVENT_JOINED: fCLEvents.CMD_EventJoined(FDatapack);
        DP_EVENT_LEADER_LOCATION: fCLEvents.CMD_EventLeaderLocation(FDatapack);
        DP_EVENT_LEFT: fCLEvents.CMD_EventLeft(FDatapack);
        DP_EVENT_MEMBER: fCLEvents.CMD_EventMember(FDatapack);
        DP_EVENT_MEMBERS_START: fCLEvents.CMD_EventMembersStart(FDatapack);
        DP_EVENT_MEMBERS_END: fCLEvents.CMD_EventMembersEnd(FDatapack);
        DP_EVENT_ABANDON: fCLEvents.CMD_EventAbandon(FDatapack);

        DP_EVENT_STATISTIC: fCLEvents.CMD_EventStatistic(FDatapack);
        DP_EVENT_KING: fCLEvents.CMD_EventKing(FDatapack);
        DP_EVENT_QUEUE_TAIL: fCLEvents.CMD_EventQueueTail(FDatapack);
        DP_EVENT_QUEUE_CLEAR: fCLEvents.CMD_EventQueueClear(FDatapack);
        DP_EVENT_QUEUE_ADD: fCLEvents.CMD_EventQueueAdd(FDatapack);

        DP_EVENT_REGLAMENT: fCLEvents.CMD_EventReglament(FDatapack);
        DP_EVENT_REGLGAMES_START: fCLEvents.CMD_EventReglGamesStart(FDatapack);
        DP_EVENT_REGLGAME_ADD: fCLEvents.CMD_EventReglGameAdd(FDatapack);
        DP_EVENT_REGLGAMES_END: fCLEvents.CMD_EventReglGamesEnd(FDatapack);
        DP_EVENT_REGLGAME_UPDATE: fCLEvents.CMD_EventReglGameUpdate(FDatapack);
        DP_EVENT_ACCEPT_REQUEST: fCLEvents.CMD_EventAcceptRequest(FDatapack);
        DP_EVENT_GAMES_BEGIN: fCLEvents.CMD_EventGamesBegin(FDatapack);
        DP_EVENT_GAMES_END: fCLEvents.CMD_EventGamesEnd(FDatapack);

        DP_AUTH_KEY_RESULT: AuthKeyResult(FDatapack);
        DP_AUTH_KEY_REQ_RESULT: AuthKeyResult(FDatapack);
        DP_PASS_FORGOT_RES: AuthKeyResult(FDatapack);
        DP_PHOTO: CMD_Photo(FDatapack);
        DP_BEGINNING_STAT: fCLProfile.BeginningStat(FDatapack);
        DP_CHATLOG_START: fCLProfile.ProfileChatLogStart(FDatapack);
        DP_CHATLOG: fCLProfile.ProfileChatLog(FDatapack);
        DP_CHATLOG_END: fCLProfile.ProfileChatLogEnd(FDatapack);
        DP_CHATLOG_PAGE: fCLProfile.ProfileChatLogPage(FDatapack);
        DP_MM_INVITE: fCLSocket2.CMD_Invite(FDatapack);
        DP_PING_VALUE: fCLMain.PingValue(FDatapack);
        DP_ADULT: SetAdult(FDatapack);
        DP_STATTYPE_BEGIN: fCLStat.CMD_StatTypeBegin(FDatapack);
        DP_STATTYPE: fCLStat.CMD_StatType(FDatapack);
        DP_STATTYPE_END: fCLStat.CMD_StatTypeEnd(FDatapack);
        DP_STAT_BEGIN: fCLStat.CMD_StatBegin(FDatapack);
        DP_STAT: fCLStat.CMD_Stat(FDatapack);
        DP_STAT_END: fCLStat.CMD_StatEnd(FDatapack);
        DP_CLUB_BEGIN: CMD_ClubBegin(FDatapack);
        DP_CLUB: CMD_Club(FDatapack);
        DP_CLUB_END: CMD_ClubEnd(FDatapack);
        DP_SEEKS_CLEAR: fCLSeeks.Clear;
        DP_EVENTS_CLEAR: fCLEvents.Clear;
        DP_CLUB_MEMBERS_BEGIN: fClubs.CMD_MembersBegin(FDatapack);
        DP_CLUB_MEMBER: fClubs.CMD_Member(FDatapack);
        DP_CLUB_MEMBERS_END: fClubs.CMD_MembersEnd(FDatapack);
        DP_CLUB_CHANGED: CMD_ClubChanged(FDatapack);
        DP_CLUB_STATUS: fClubs.CMD_ClubStatus(FDatapack);
        DP_CLUB_INFO: fClubs.CMD_ClubInfo(FDatapack);
        DP_CLUB_PHOTO: fClubs.CMD_ClubPhoto(FDatapack);
        DP_CLUB_OPTIONS: fClubs.CMD_ClubOptions(FDatapack);
        DP_USER_PING_VALUE: CMD_UserPing(FDatapack);
        DP_PROFILE_PAGES: fCLProfile.ProfilePages(FDatapack);
        DP_PROFILE_RECENT_CLEAR: fCLProfile.RecentClear(FDatapack);
        DP_EVENT_TICKETS_BEGIN: fCLEvents.CMD_EventTicketsBegin(FDatapack);
        DP_EVENT_TICKET: fCLEvents.CMD_EventTicket(FDatapack);
        DP_EVENT_TICKETS_END: fCLEvents.CMD_EventTicketsEnd(FDatapack);
        DP_GAME_SCORE: CMD_GameScore(FDatapack);
        DP_PROFILE_CHATREADER: fCLProfile.ProfileChatReader(FDatapack);
        DP_NOTES: CMD_Notes(FDatapack);
        DP_RIGHTS: CMD_Rights(FDatapack);
        DP_SERVER_TIME: fCLMain.CMD_ServerTime(FDatapack);
        DP_MESSAGE_CLEAR: fCLMessages.CMD_MessageClear;
        DP_MESSAGE_PAGES: fCLMessages.CMD_MessagePages(FDatapack);
        DP_MESSAGE2: fCLMessages.CMD_Message2(FDatapack);
        DP_NEWUSER_GREATED: fCLNotify.NewUserGreated(FDatapack);
        DP_TIMEODDSLIMIT_CLEAR: CMD_ClearTimeOddsLimits(FDatapack);
        DP_TIMEODDSLIMIT: CMD_AddTimeOddsLimit(FDatapack);
        DP_GAME_ODDS: CMD_GameOdds(FDatapack);
        DP_CLIENT_UPDATE: CMD_ClientUpdate(FDatapack);
        DP_ACH_CLEAR: CMD_AchClear(FDatapack);
        DP_ACH_GROUP: AchList.CMD_AchGroup(FDatapack);
        DP_ACHIEVEMENT: AchList.CMD_Achievement(FDatapack);
        DP_ACH_USER: CMD_AchUser(FDatapack);
        DP_ACH_USER_INFO: CMD_AchUserInfo(FDatapack);
        DP_ACH_USER_INFO_CLEAR: CMD_AchUserInfoClear(FDatapack);
        DP_ACH_FINISHED: CMD_AchFinished(FDatapack);
        DP_ACH_SEND_END: CMD_AchSendEnd(FDatapack);
        DP_SERVER_WARNING: ShowServerWarning(FDatapack);
        DP_MEMBERSHIPTYPE_BEGIN: fCLMembershipTypes.CMD_MembershipTypeBegin(FDatapack);
        DP_MEMBERSHIPTYPE: fCLMembershipTypes.CMD_MembershipType(FDatapack);
        DP_PROFILE_PAYMENT_BEGIN: fCLProfile.CMD_PaymentBegin(FDatapack);
        DP_PROFILE_PAYMENT: fCLProfile.CMD_Payment(FDatapack);
        DP_PROFILE_PAYMENT_END: fCLProfile.CMD_PaymentEnd(FDatapack);
        DP_URL_OPEN: CMD_UrlOpen(FDatapack);
        DP_ROLES: CMD_Roles(FDatapack);
        DP_PROFILE_PAY_DATA: fCLProfile.CMD_ProfilePayData(FDatapack);
        DP_SPECIAL_OFFER: CMD_SpecialOffer(FDatapack);
        DP_ONLINE_STATUS: fCLTerminal.CMD_OnlineStatus(FDatapack);
        DP_PM_EXIT: fCLTerminal.CMD_PmExit(FDatapack);
        DP_AUTOUPDATE: CMD_AutoUpdate(FDatapack);
        DP_GAME_QUIT: fCLBoard.CMD_GameQuit(FDatapack);
        //DP_EVENT_ODDS_ADD: fCLEvents.
      end;
    finally
      if Index <> DP_PASS_FORGOT_RES then
        FDatapack.Clear;
    end;
end;
//==============================================================================
constructor TCLCLS.Create;
begin
  inherited;
  FDataString := '';
  FDatapack := TStringList.Create;
  FUpdating := false;
  FAchCongratulated := TStringList.Create;
end;
//==============================================================================
destructor TCLCLS.Destroy;
begin
  FDatapack.Clear;
  FAchCongratulated.Free;
  FreeAndNil(FDatapack);
  fCLCLS := nil;
  inherited;
end;
//==============================================================================
procedure TCLCLS.Receive(const ReceivedData: string; TotalBytes: Integer);
var
  Index: Integer;
begin
  if TotalBytes = 0 then Exit;
  TotalBytes := TotalBytes + Length(FDataString);

  FDataString := FDataString + ReceivedData;
  SetLength(FDataString, TotalBytes);

  while Length(FDataString) > 0 do
    case FDataString[1] of
      DP_START:
        begin
          FDatapack.Clear;
          Delete(FDataString, 1, 1);
        end;
      DP_END:
        begin
          if FDatapack.Count > 0 then ProcessDatapack;
          try
            Delete(FDataString, 1, 1);
          except
            break;
          end;
        end;
      else
        begin
          Index := Pos(DP_DELIMITER ,FDataString);
          if Index = 0 then Break;
          FDatapack.Add(Copy(FDataString, 1, Index -1));
          Delete(FDataString, 1, Index);
        end;
    end;

  if FDataString = '' then
    begin
      fCLSocket.InitState := isRequestComplete;
      fCLTerminal.ccConsole.EndUpdate;
    end
  else
    fCLSocket.InitState := isReceivingData
end;
//==============================================================================
procedure TCLCLS.TellEvent;
var name: string;
begin
  name:=FDatapack[2];
  if trim(FDatapack[3])<>'' then name:=name+' ('+FDatapack[3]+')';
  fCLTerminal.AddLine(fkEvent, StrToInt(FDatapack[1]),
    name + ': ' + FDatapack[4], ltTellRoom, StrToInt(FDatapack[5]));
end;
//==============================================================================
procedure TCLCLS.AuthKeyResult(Datapack: TStrings);
var
  res: integer;
  msg: string;
begin
  res:=StrToInt(Datapack[1]);
  msg:=Datapack[2];
  if Assigned(fCLLogin) then
    fCLLogin.AuthKeyResult(res,msg);
end;
//==============================================================================
procedure TCLCLS.CMD_Club(Datapack: TStrings);
var
  id, members: integer;
  name, sponsor: string;
  status: TClubStatus;
  requests: Boolean;
  cl: TClub;
  ClubType: TClubType;
begin
  if Datapack.Count<5 then exit;
  try
    id:=StrToInt(Datapack[1]);
  except
    exit;
  end;
  name:=Datapack[2];

  if Datapack.Count < 4 then status := clsNone
  else status := TClubStatus(StrToInt(Datapack[3]));

  requests := Datapack[4]='1';

  if Datapack.Count < 6 then begin
    sponsor := '';
    ClubType := cltClub;
    members := 0;
  end else begin
    sponsor := Datapack[5];
    ClubType := TClubType(StrToInt(Datapack[6]));
    members := StrToInt(Datapack[7]);
  end;

  cl:=fClubs.ClubById(id);
  if cl = nil then begin
    cl:=TClub.Create;
    fClubs.Add(cl);
  end;
  cl.id := id;
  cl.name := name;
  cl.status := status;
  cl.requests := requests;
  cl.sponsor := sponsor;
  cl.clubtype := ClubType;
  cl.memberscount := members;
end;
//==============================================================================
procedure TCLCLS.CMD_ClubBegin(Datapack: TStrings);
begin
  fClubs.Clear;
end;
//==============================================================================
procedure TCLCLS.CMD_ClubChanged(CMD: TStrings);
var
  id: integer;
  name: string;
begin
  if CMD.Count<3 then exit;
  try id:=StrToInt(CMD[1]); except exit end;
  name:=CMD[2];
  fCLSocket.ClubId:=id;
  fCLSocket.ClubName:=Name;
  fCLMain.SetClubName(fCLSocket.ClubName);
  if fCLClubs.Visible then fCLClubs.Repaint;
  if fCLSchools.Visible then fCLSchools.Repaint;
end;
//==============================================================================
procedure TCLCLS.CMD_ClubEnd(Datapack: TStrings);
begin
  fCLMain.SetClubName(fClubs.NameById(fCLSocket.ClubId));
  fCLClubs.LoadClubs;
  if fCLClubs.Visible then fCLClubs.Repaint;
end;
//==============================================================================
procedure TCLCLS.CMD_UserPing(CMD: TStrings);
var
  name: string;
  lag: integer;
begin
  if CMD.Count<3 then exit;
  try
    name:=CMD[1];
    lag:=StrToInt(CMD[2]);
  except
    exit;
  end;
  fPingValues[name]:=lag;
end;
//==============================================================================
procedure TCLCLS.CMD_GameScore(Datapack: TStrings);
var
  Game: TCLGame;
  GameNumber: integer;
  Win,Lost,Draw: integer;
begin
  GameNumber := StrToInt(FDatapack[1]);
  Game := fCLBoard.Game(GameNumber);
  if Game = nil then Exit;
  Win:=StrToInt(FDatapack[2]);
  Lost:=StrToInt(FDatapack[3]);
  Draw:=StrToInt(FDatapack[4]);
  Game.SetScore(Win,Lost,Draw);

end;
//==============================================================================
procedure TCLCLS.CMD_Login2(CMD: TStrings);
var
  InsertedNew: Boolean;
  L: TLogin;
begin
  L := fLoginList.Login2(CMD, InsertedNew);

  fCLTerminal.OnNewLogin(L);
  fCLNotify.OnNewLogin(L);

  if L.Login = fCLSocket.MyName then begin
    fCLSocket.SetMyRating(L.RatingString, L.ProvString);
    fCLSocket.MyLoginID := L.LoginID;
  end;

  if not fCLTerminal.LoginsUpdating then fGL.PlayCLSound(SI_PLAYER_ARRIVED);
end;
//==============================================================================
procedure TCLCLS.CMD_Rights(CMD: TStrings);
begin
  if CMD.Count < 3 then exit;
  fCLSocket.Rights.SelfProfile := CMD[1] = '1';
  fCLSocket.Rights.AchievementsVisible := CMD[2] = '1';
  if CMD.Count < 4 then begin
    fCLSocket.Rights.Messages := true;
    fCLSocket.Rights.PGNLibrary := true;
    fCLSocket.Rights.AchievementsActive := true;
    fCLSocket.Rights.SavingGames := true;
  end else begin
    fCLSocket.Rights.Messages := CMD[3] = '1';
    fCLSocket.Rights.PGNLibrary := CMD[4] = '1';
    fCLSocket.Rights.AchievementsActive := CMD[5] = '1';
    fCLSocket.Rights.SavingGames := CMD[6] = '1';
  end;
  ProcessRights;
end;
//==============================================================================
procedure TCLCLS.CMD_AddTimeOddsLimit(CMD: TStrings);
var
  InitTime, IncTime, MinInitTime, MinIncTime: integer;
  MaxScoreDeviation, ScoreDeviationStart, ScoreDeviationEnd: integer;
begin
  if CMD.Count < 5 then exit;
  InitTime := StrToInt(CMD[1]);
  IncTime := StrToInt(CMD[2]);
  MinInitTime := StrToInt(CMD[3]);
  MinIncTime := StrToInt(CMD[4]);
  if CMD.Count > 5 then begin
    MaxScoreDeviation := StrToInt(CMD[5]);
    ScoreDeviationStart := StrToInt(CMD[6]);
    ScoreDeviationEnd := StrToInt(CMD[7]);
  end;
  fTimeOddsLimits.AddLimit(InitTime, IncTime, MinInitTime, MinIncTime, MaxScoreDeviation,
    ScoreDeviationStart, ScoreDeviationEnd);
end;
//==============================================================================
procedure TCLCLS.CMD_AutoUpdate(CMD: TStrings);
var
  version, url: string;
  th: TAutoUpdateThread;
begin
  version := CMD[1];
  url := CMD[2];
  th := TAutoUpdateThread.Create(true);
  th.FreeOnTerminate := true;
  th.URL := url;
  th.FileName := MAIN_DIR + 'upd' + version + '.exe';
  th.Resume;
end;
//==============================================================================
procedure TCLCLS.CMD_ClearTimeOddsLimits(CMD: TStrings);
begin
  fTimeOddsLimits.Clear;
end;
//==============================================================================
procedure TCLCLS.CMD_GameOdds(CMD: TStrings);
var
  Game: TCLGame;
begin
  Game := fCLBoard.Game(StrToInt(FDatapack[1]));
  if Game = nil then Exit;

  with Game.Odds do begin
    FAutoTimeOdds := FDatapack[2] = '1';
    FInitMin := StrToInt(FDatapack[3]);
    FInitSec := StrToInt(FDatapack[4]);
    FInc := StrToInt(FDatapack[5]);
    FPiece := StrToInt(FDatapack[6]);
    FTimeDirection := TOfferOddsDirection(StrToInt(FDatapack[7]));
    FPieceDirection := TOfferOddsDirection(StrToInt(FDatapack[8]));
    FInitiator := TOfferOddsInitiator(StrToInt(FDatapack[9]));
  end;
end;
//==============================================================================
procedure TCLCLS.CMD_ClientUpdate(CMD: TStrings);
var
  version, url: string;
  F: TFCLAutoUpdate;
begin
  if (CMD.Count < 3) or FUpdating then exit;
  FUpdating := true;
  version := CMD[1];
  url := CMD[2];
  F := TFCLAutoUpdate.Create(Application);
  F.lbl1.Caption := 'The new version ' + version + ' is available.' + #13#10 +
    'Do you want to download and update now?';
  F.URL := url;
  if F.ShowModal = mrCancel then begin
    fCLSocket.InitialSend([CMD_STR_SKIP_UPDATE]);
    fCLTerminal.FocusConsoleFilter;
  end;
  F.Free;
  FUpdating := false;
end;
//==============================================================================
procedure TCLCLS.CMD_AchUser(CMD: TStrings);
var
  Login: string;
  AUL: TCLAchUserList;
begin
  if CMD.Count < 5 then exit;
  Login := CMD[1];
  AUL := nil;
  if Login = fCLSocket.MyName then AUL := MyAchUserList;
  if AUL <> nil then
    AUL.CMD_AchUser(CMD);

  AUL := fCLProfile.GetAchUserList(Login);
  if AUL <> nil then
    AUL.CMD_AchUser(CMD);
end;
//==============================================================================
procedure TCLCLS.CMD_AchUserInfo(CMD: TStrings);
var
  Login: string;
  AUL: TCLAchUserList;
begin
  if CMD.Count < 5 then exit;
  Login := CMD[1];
  AUL := nil;
  if Login = fCLSocket.MyName then AUL := MyAchUserList;
  if AUL <> nil then
    AUL.CMD_AchUserInfo(CMD);

  AUL := fCLProfile.GetAchUserList(Login);
  if AUL <> nil then
    AUL.CMD_AchUserInfo(CMD);
end;
//==============================================================================
procedure TCLCLS.CMD_AchUserInfoClear(CMD: TStrings);
var
  Login: string;
  AUL: TCLAchUserList;
begin
  if CMD.Count < 2 then exit;
  Login := CMD[1];
  AUL := nil;
  if Login = fCLSocket.MyName then AUL := MyAchUserList;
  if AUL <> nil then
    AUL.CMD_AchUserInfoClear(CMD);

  AUL := fCLProfile.GetAchUserList(Login);
  if AUL <> nil then
    AUL.CMD_AchUserInfoClear(CMD);
end;
//==============================================================================
procedure TCLCLS.CMD_AchFinished(CMD: TStrings);
var
  AchID: integer;
  Ach: TCLAchievement;
  fAchList: TfCLAchList;
begin
  if CMD.Count < 2 then exit;
  AchID := StrToInt(CMD[1]);

  if AchList.AchIndexByID(AchID) = -1 then begin
    SendErrorToServer('Socket', 'TCLCLS.CMD_AchFinished', 0,
      Format('AchID = %d is not found', [AchID]), 'DP_ACH_FINISHED');
    exit;
  end;
  MyAchUserList.CreateGroupStatistics;
  if FAchCongratulated.IndexOf(IntToStr(AchID)) <> -1 then exit;
  FAchCongratulated.Add(IntToStr(AchID));

  fAchList := TfCLAchList.Create(Application);
  try
    fAchList.SetCongratulationParams(AchID);
    fAchList.ShowModal;
  except
    on E:Exception do
      SendErrorToServer('Interface', 'TfCLBaseDraw.FormPaint', 0, E.Message, '');
  end;
  fAchList.Free;
end;
//==============================================================================
procedure TCLCLS.CMD_AchSendEnd(CMD: TStrings);
var
  Login: string;
  AUL: TCLAchUserList;
begin
  if CMD.Count < 2 then exit;
  Login := CMD[1];
  AUL := nil;
  if Login = fCLSocket.MyName then AUL := MyAchUserList;
  if AUL <> nil then
    AUL.CMD_AchSendEnd(CMD);

  AUL := fCLProfile.GetAchUserList(Login);
  if AUL <> nil then begin
    AUL.CMD_AchSendEnd(CMD);
    fCLProfile.CMD_AchSendEnd(CMD);
  end;
end;
//==============================================================================
procedure TCLCLS.CMD_UrlOpen(CMD: TStrings);
var
  url: string;
begin
  if (CMD.Count < 2) {or MultiKeyExists }then exit;
  url := CMD[1];
  ShellExecute(0, 'open', PChar(url), '', '', SW_SHOWNORMAL);
end;
//==============================================================================
procedure TCLCLS.ProcessRights;
begin
  fCLNavigate.SetAchievements(fCLSocket.Rights.AchievementsVisible);
end;
//==============================================================================
procedure TCLCLS.CMD_AchClear(CMD: TStrings);
begin
  AchList.CMD_AchClear;
  MyAchUserList.Clear;
end;
//==============================================================================
procedure TCLCLS.CMD_Roles(CMD: TStrings);
begin
  if CMD.Count < 2 then exit;
  fCLSocket.MyRoles := CMD[1];
end;
//==============================================================================
procedure TCLCLS.CMD_SpecialOffer(CMD: TStrings);
begin
  if CMD.Count < 2 then exit;
  SPECIAL_OFFER := CMD[1];
end;
//==============================================================================
end.


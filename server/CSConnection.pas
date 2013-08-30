{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSConnection;

interface

uses
  Classes, Sysutils, Contnrs, ScktComp, CSConst, IdTCPServer, CSEngine, CSBot;

type
  TOnlineStatus = (onlActive, onlIdle, onlDisconnected);

  TConnectionType = (cntPlayer, cntEngine);

  TUserRights = record
    SelfProfile: Boolean; // rights to edit photo and notes of himself
    Achievements: Boolean;
  end;

  TAdminLevel = (alNone, alHelper, alNormal, alSuper);
  TNotifyType = (ntFriend, ntIFriend, ntCensor, ntICensor, ntNoPlay, ntINoPlay);

  TNotify = class(TObject)
    FLoginID: Integer;
    FLogin: string;
    FTitle: string;
    FNotifyType: TNotifyType;
  end;

  TAdultType = (adtNone, adtChild, adtAdult);

  TCSEventUserState = (eusNone,eusLeader,eusMember,eusObserver);

  TStats = array[0..5,0..2] of integer;

  TMembershipType = (mmbNone, mmbTrial, mmbPaid, mmbEmployee, mmbVIP, mmbCore);

  TGamesPerDay = class
  private
    RatedType: TRatedType;
    GamesCnt: integer;
  end;

  TGamesPerDayList = class(TObjectList)
  private
    function GetGamesCnt(p_RatedType: TRatedType): integer;
  public
    procedure AddRecord(p_RatedType: TRatedType; p_GamesCnt: integer);
    procedure AddCounter(p_RatedType: TRatedType);
    procedure Nullify;
    property GamesCnt[RatedType: TRatedType]: integer read GetGamesCnt; default;
  end;

  TConnection = class(TObject)
  private
    { Private declarations }
    FAdminLevel: TAdminLevel;
    FAutoFlag: Boolean;
    FCmdParam: string;
    FColor: Integer; { Default param for a seek/match command }
    FGameLimit: Integer;
    FGames: TList;
    FHandle: string;
    FLoginID: Integer; { LoginID of Connection. -1 indicates not yet logged in. }
    FIncTime: Integer; { Default param for a seek/match command }
    FInitialTime: string; { Default param for a seek/match command }
    FInput: string;
    FKey: Word;
    FLastColor: Integer;
    FLastCmd: string;
    FLastCmdTS: TDateTime;
    FLastTS: TDateTime;
    FLoginAttempts: Integer;
    FMAC: string;
    FMaxRating: Integer; { Default param for a seek command }
    FMinRating: Integer; { Default param for a seek command }
    FMuted: Boolean;
    FOfferCount: Integer;
    FOfferLimit: Integer;
    FOpen: Boolean; { Open to receive matches }
    FOption: Integer; { Set of option bits; 1=Seeks 2=Games 4=Who }
    FOutput: string;
    FNotify: TObjectList;
    FPingAvg: Integer;
    FPingCount: Integer;
    FPrimary: TObject; { Which game is current }
    FProvisional: array[0..5] of Boolean; { Provisional status for each TRatedType }
    FRated: Boolean; { Default param for a seek/match command }
    FRating: array[0..5] of Integer; { Rating for each TRatedType }
    //FStats: TStats; { Results fo each TRatedType, 0 - Wins, 1 - Loses, 2 - Draws}
    FRatedType: TRatedType; { Default param for a seek/match command }
    FRegistered: Boolean; { Paying member?? }
    FRemoveOffers: Boolean; { Remove all offers if Connection becomes involved in a game. }
    FRoomCount: Integer; { Number of rooms currently in. }
    FRoomCreated: Integer; { Room number the Connection created }
    FRoomLimit: Integer; { Maxmimun number of rooms the connection is allowed in }
    FSend: Boolean; { Send data to this connection? }
    FSocket: TCustomWinSocket;
    FTitle: string;
    FWaitForOnWrite: Boolean;
    FVersion: string; { Client version connection is using. }
    FUnbanned: Boolean;
    FEventId: integer;
    FEventUserState: TCSEventUserState;
    FLastCreatedEventId: integer;
    FFollowFrozen: Boolean;
    FCReject: Boolean;
    FPReject: Boolean;
    FSexId: integer;
    FAge: integer;
    FCountryId: integer;
    FEmail: string;
    FMutedDateUntil: TDateTime;
    FEVBanned: Boolean;
    FEVBannedDateUntil: TDateTime;
    FPhotoANSI: string;
    FInputMM: string;
    FSocketMM: TCustomWinSocket;
    FSocket2Thread: TIdPeerThread;
    FRejectWhilePlaying: Boolean;
    FBadLagRestrict: Boolean;
    FPingLast: Integer;
    FAdult: TAdultType;
    FClubId: integer;
    FLoseOnDisconnect: Boolean;
    FSeeTourShoutsEveryRound: Boolean;
    FHiddenCompAccount: Boolean;
    FBusyStatus: Boolean;
    FPublicEmail: Boolean;
    FLanguage: string;
    FImageIndex: integer;
    FAbortedGameByBlack: Boolean;
    FMaster: Boolean;
    FCreated: TDateTime;
    FAdminGreeted: Boolean;
    FInvisible: Boolean;
    FBirthday: TDateTime;
    FShowBirthday: Boolean;
    FAutoMatch: Boolean;
    FAutoMatchMaxR: integer;
    FAutoMatchMinR: integer;
    //FAchUserList: TAchUserList;
    FMembershipType: TMembershipType;
    FMembershipExpireDate: TDateTime;
    FRoles: string;
    FNoMembershipChatWarned: Boolean;
    FBot: TBot;
    FConnectionType: TConnectionType;
    FOnlineStatus: TOnlineStatus;
    FGamesPerDayList: TGamesPerDayList;
    FAllowSeekWhilePlaying: Boolean;
    FOldVersion: Boolean;
    FProperVersion: string;

    constructor Create; overload;
    function GetCensor(const Value: TConnection): Boolean;
    function GetNotifyCount(const Value: TNotifyType): Integer;
    function GetProvisional(const Value: TRatedType): Boolean;
    procedure SetProvisional(const Index: TRatedType; const Value: Boolean);
    function GetRating(const Value: TRatedType): Integer;
    procedure SetRating(const Index: TRatedType; const Value: Integer);
    function GetRatingString: string;
    function GetProvString: string;
    function GetNoPlay(const Value: TConnection): Boolean;
  public
    Rights: TUserRights;
    Stats: TStats; { Results fo each TRatedType, 0 - Wins, 1 - Loses, 2 - Draws}
    { Public declarations }
    constructor Create(var Socket: TCustomWinSocket); overload;
    constructor Create(p_EngineInfo: TEngineInfo; p_BotInfo: TBotInfo); overload;
    destructor Destroy; override;

    procedure AddGame(const Game: TObject);
    procedure RemoveGame(const Game: TObject);
    procedure SendRights;
    procedure SendRoles;
    function IsPlayingGame: Boolean;
    procedure AddNotify(LoginID: integer; Login, Title: string; NotifyType: TNotifyType; SendNotify,CreateMirror: Boolean);
    procedure RemoveNotify(LoginID: integer; NotifyCensor: Boolean);
    procedure SendINotify(Online: Boolean);
    procedure SendNotifyList;
    function AchievementAllowed: Boolean;
    procedure SendNoMembershipMsg(p_Msg: string);
    procedure WarnAboutNoMembershipChat;
    function GamesLimit(p_RatedType: TRatedType): integer;
    function GamesLimitReached(p_RatedType: TRatedType): Boolean;
    procedure SendTrialWarning(p_Message: string);
    function CountNotEventGames: integer;
    function CountLiveNotEventGames: integer;
    procedure SetOnlineStatus(p_Status: TOnlineStatus);
    procedure QuitFinishedGameIfNeed;    

    property AdminLevel: TAdminLevel read FAdminLevel write FAdminLevel;
    property AutoFlag: Boolean read FAutoFlag write FAutoFlag;
    property Censors[const Connection: TConnection]: Boolean read GetCensor;
    property NoPlay[const Connection: TConnection]: Boolean read GetNoPlay;
    property CmdParam: string read FCmdParam write FCmdParam;
    property Color: Integer read FColor write FColor;
    property GameLimit: Integer read FGameLimit write FGameLimit;
    property Games: TList read FGames;
    property Handle: string read FHandle write FHandle;
    property LoginID: Integer read FLoginID write FLoginID;
    property IncTime: Integer read FIncTime write FIncTime;
    property InitialTime: string read FInitialTime write FinitialTime;
    property Input: string read FInput write FInput;
    property InputMM: string read FInputMM write FInputMM;
    property Key: Word read FKey write FKey;
    property LastCmd: string read FLastCmd write FLastCmd;
    property LastCmdTS: TDateTime read FLastCmdTS write FLastCmdTS;
    property LastColor: Integer read FLastColor write FLastColor;
    property LastTS: TDateTime read FLastTS write FLastTS;
    property LoginAttempts: Integer read FLoginAttempts write FLoginAttempts;
    property MAC: string read FMAC write FMAC;
    property MaxRating: Integer read FMaxRating write FMaxRating;
    property MinRating: Integer read FMinRating write FMinRating;
    property Muted: Boolean read FMuted write FMuted;
    property MutedDateUntil: TDateTime read FMutedDateUntil write FMutedDateUntil;
    //property Notify: TObjectList read FNotify;
    property NotifyCount[const LoginType: TNotifyType]: Integer read GetNotifyCount;
    property OfferCount: Integer read FOfferCount write FOfferCount;
    property OfferLimit: Integer read FOfferLimit write FOfferLimit;
    property Open: Boolean read FOpen write FOpen;
    property Option: Integer read FOption write FOption;
    property Output: string read FOutput write FOutput;
    property PingAvg: Integer read FPingAvg write FPingAvg;
    property PingCount: Integer read FPingCount write FPingCount;
    property PingLast: Integer read FPingLast write FPingLast;
    property Primary: TObject read FPrimary write FPrimary;
    property Provisional[const Value: TRatedType]: Boolean
      read GetProvisional write SetProvisional;
    property Rated: Boolean read FRated write FRated;
    property Rating[const Value: TRatedType]: Integer
      read GetRating write SetRating;
    //property Stats[const Ind: TRatedType;: TStats read  write FStats;
    property RatedType: TRatedType read FRatedType write FRatedType;
    property Registered: Boolean read FRegistered write FRegistered;
    property RemoveOffers: Boolean read FRemoveOffers write FRemoveOffers;
    property RoomCount: Integer read FRoomCount write FRoomCount;
    property RoomCreated: Integer read FRoomCreated write FRoomCreated;
    property RoomLimit: Integer read FRoomLimit write FRoomLimit;
    property Send: Boolean read FSend write FSend;
    property Socket: TCustomWinSocket read FSocket write FSocket;
    property SocketMM: TCustomWinSocket read FSocketMM write FSocketMM;
    property Title: string read FTitle write FTitle;
    property Unbanned: Boolean read FUnbanned write FUnbanned;
    property WaitForOnWrite: Boolean read FWaitForOnWrite write FWaitForOnWrite;
    property Version: string read FVersion write FVersion;
    property RatingString: string read GetRatingString;
    property ProvString: string read GetProvString;
    property EventId: integer read FEventId write FEventId;
    property EventUserState: TCSEventUserState read FEventUserState write FEventUserState;
    property LastCreatedEventId: integer read FLastCreatedEventId write FLastCreatedEventId;
    property FollowFrozen: Boolean read FFollowFrozen write FFollowFrozen;
    property CReject: Boolean read FCReject write FCReject;
    property PReject: Boolean read FPReject write FPReject;
    property Email: string read FEmail write FEmail;
    property CountryId: integer read FCountryId write FCountryId;
    property SexId: integer read FSexId write FSexId;
    property Age: integer read FAge write FAge;
    property EVBanned: Boolean read FEVBanned write FEVBanned;
    property EVBannedDateUntil: TDateTime read FEVBannedDateUntil write FEVBannedDateUntil;
    property PhotoANSI: string read FPhotoANSI write FPhotoANSI;
    property RejectWhilePlaying: Boolean read FRejectWhilePlaying write FRejectWhilePlaying;
    property Socket2Thread: TIdPeerThread read FSocket2Thread write FSocket2Thread;
    property BadLagRestrict: Boolean read FBadLagRestrict write FBadLagRestrict;
    property Adult: TAdultType read FAdult write FAdult;
    property ClubId: integer read FClubId write FClubId;
    property LoseOnDisconnect: Boolean read FLoseOnDisconnect write FLoseOnDisconnect;
    property SeeTourShoutsEveryRound: Boolean read FSeeTourShoutsEveryRound write FSeeTourShoutsEveryRound;
    property HiddenCompAccount: Boolean read FHiddenCompAccount write FHiddenCompAccount;
    property BusyStatus: Boolean read FBusyStatus write FBusyStatus;
    property Language: string read FLanguage write FLanguage;
    property PublicEmail: Boolean read FPublicEmail write FPublicEmail;
    property ImageIndex: integer read FImageIndex write FImageIndex;
    property AbortedGameByBlack: Boolean read FAbortedGameByBlack write FAbortedGameByBlack;
    property Master: Boolean read FMaster write FMaster;
    property Created: TDateTime read FCreated write FCreated;
    property AdminGreeted: Boolean read FAdminGreeted write FAdminGreeted;
    property Invisible: Boolean read FInvisible write FInvisible;
    property Birthday: TDateTime read FBirthday write FBirthday;
    property ShowBirthday: Boolean read FShowBirthday write FShowBirthday;
    property AutoMatch: Boolean read FAutoMatch write FAutoMatch;
    property AutoMatchMinR: integer read FAutoMatchMinR write FAutoMatchMinR;
    property AutoMatchMaxR: integer read FAutoMatchMaxR write FAutoMatchMaxR;
    //property AchUserList: TAchUserList read FAchUserList write FAchUserList;
    property MembershipType: TMembershipType read FMembershipType write FMembershipType;
    property MembershipExpireDate: TDateTime read FMembershipExpireDate write FMembershipExpireDate;
    property Roles: string read FRoles write FRoles;
    property ConnectionType: TConnectionType read FConnectionType;
    property Bot: TBot read FBot;
    property OnlineStatus: TOnlineStatus read FOnlineStatus;
    property GamesPerDayList: TGamesPerDayList read FGamesPerDayList write FGamesPerDayList;
    property AllowSeekWhilePlaying: Boolean read FAllowSeekWhilePlaying write FAllowSeekWhilePlaying;
    property IsOldVersion: Boolean read FOldVersion write FOldVersion;
    property ProperVersion: string read FProperVersion write FProperVersion;
  end;

  TConnectionFilter = function (const Connection: TConnection): Boolean of object;

implementation

uses CSGame,CSLib, CSSocket, CSConnections, CSGames;

//==============================================================================
function TConnection.GamesLimit(p_RatedType: TRatedType): integer;
begin
  if MembershipType in [mmbNone, mmbCore] then
    case p_RatedType of
      rtStandard: result := 10;
      rtBlitz: result := 20;
      rtBullet: result := 30;
      rtCrazy: result := 10;
      rtFischer: result := 10;
      rtLoser: result := 10;
    end
  else
    result := 9999;
end;
//==============================================================================
function TConnection.GamesLimitReached(p_RatedType: TRatedType): Boolean;
begin
  result := FGamesPerDayList[p_RatedType] >= GamesLimit(p_RatedType);
end;
//==============================================================================
function TConnection.GetCensor(const Value: TConnection): Boolean;
var
  Notify: TNotify;
  Index: Integer;
begin
  Result := false;
  for Index := FNotify.Count -1 downto 0 do
    begin
      Notify := TNotify(FNotify[Index]);
      if (Notify.FNotifyType = ntCensor) and (Notify.FLogin = Value.Handle) then
        begin
          Result := True;
          Break;
        end;
    end
end;
//==============================================================================
function TConnection.GetNotifyCount(const Value: TNotifyType): Integer;
var
  Index: Integer;
begin
  result := 0;
  for Index := 0 to FNotify.Count -1 do
    if TNotify(FNotify[Index]).FNotifyType = Value then Inc(result);
end;
//==============================================================================
function TConnection.GetProvisional(const Value: TRatedType): Boolean;
begin
  Result := FProvisional[Ord(Value)];
end;
//==============================================================================
procedure TConnection.SetOnlineStatus(p_Status: TOnlineStatus);
begin
  if p_Status = FOnlineStatus then exit;
  FOnlineStatus := p_Status;
  CSSocket.fSocket.SmartSend(fConnections.Connections, nil,
    [DP_ONLINE_STATUS, LoginID, OnlineStatus], Self);
end;
//==============================================================================
procedure TConnection.SetProvisional(const Index: TRatedType;
  const Value: Boolean);
begin
  FProvisional[Ord(Index)] := Value
end;
//==============================================================================
function TConnection.GetRating(const Value: TRatedType): Integer;
begin
  Result := FRating[Ord(Value)];
end;
//==============================================================================
procedure TConnection.SetRating(const Index: TRatedType; const Value: Integer);
begin
  FRating[Ord(Index)] := Value;
end;
//==============================================================================
procedure TConnection.WarnAboutNoMembershipChat;
begin
  if not FNoMembershipChatWarned then begin
    SendNoMembershipMsg(DP_MSG_CHAT_WITH_ADMIN_ONLY);
    FNoMembershipChatWarned := True;
  end;
end;
//==============================================================================
constructor TConnection.Create(var Socket: TCustomWinSocket);
begin
  Create;
  FGameLimit := MAX_GAMES;
  FSocket := Socket;
  Socket.Data := Self;
  FConnectionType := cntPlayer;
end;
//==============================================================================
destructor TConnection.Destroy;
begin
  if Assigned(FSocket) then
    begin
      FSocket.Data := nil;
      FSocket := nil;
    end;
  FGames.Clear;
  FGames.Free;
  FNotify.Clear;
  FNotify.Free;
  FBot.Free;
  FGamesPerDayList.Free;
  inherited Destroy;
end;
//==============================================================================
procedure TConnection.AddGame(const Game: TObject);
begin
  FGames.Add(Game);
  FPrimary := Game;
end;
//==============================================================================
procedure TConnection.RemoveGame(const Game: TObject);
begin
  if Game=nil then exit;
  if FPrimary = Game then FPrimary := nil;
  FGames.Remove(Game);
end;
//==============================================================================
function TConnection.GetRatingString: string;
var i,j: integer;
begin
  result:='';
  for i:=0 to 5 do
    begin
      result:=result+IntToStr(Rating[TRatedType(i)]);
      for j:=0 to 2 do
        result:=result+','+IntToStr(Stats[i,j]);
      result:=result+';';
    end;
end;
//==============================================================================
function TConnection.CountLiveNotEventGames: integer;
var
  i: integer;
  game: TGame;
begin
  result:=0;
  for i:=0 to Games.Count-1 do begin
    game:=TGame(Games[i]);
    if (game<>nil) and (game.EventId=0) and (game.GameMode = gmLive) then
      inc(result);
  end;
end;
//==============================================================================
function TConnection.CountNotEventGames: integer;
var
  i: integer;
  game: TGame;
begin
  result:=0;
  for i:=0 to Games.Count-1 do begin
    game:=TGame(Games[i]);
    if (game<>nil) and (game.EventId=0) then
      inc(result);
  end;
end;
//==============================================================================
constructor TConnection.Create(p_EngineInfo: TEngineInfo; p_BotInfo: TBotInfo);
begin
  Create;
  FGameLimit := MAX_GAMES_ENGINE;
  FSocket := nil;
  Bot.EngineInfo := p_EngineInfo;
  Bot.BotInfo := p_BotInfo;
  FConnectionType := cntEngine;
end;
//==============================================================================
constructor TConnection.Create;
var
  i: integer;
begin
  inherited Create;
  SetLength(FInput, 0);
  SetLength(FOutput, 0);
  FAdminLevel := alNone;
  FAutoFlag := False;
  FColor := 1;
  FGames := TList.Create;
  FHandle := '';
  FLastColor := 0;
  FLastCmd := '';
  FLastCmdTS := Now;
  FLastTS := 0;
  FLoginID := -1;
  FInitialTime := '5';
  FIncTime := 0;
  FInput := '';
  FLoginAttempts := 0;
  FMaxRating := 9999;
  FMinRating := 0;
  FMuted := False;
  FNotify := TObjectList.Create;
  FOfferCount := 0;
  FOfferLimit := 5;
  FOpen := True;
  FOption := 1;
  FOutput := '';
  FPingAvg := 0;
  FPingLast := 0;
  FPingCount := 0;
  FPrimary := nil;
  FRated := False;
  FRatedType := rtBlitz;
  for i := Low(FRating) to High(FRating) do begin
    FRating[i] := 0;
    FProvisional[i] := True;
  end;
  FRegistered := False;
  FRoomCount := 0;
  FRoomCreated := -1;
  FRoomLimit := 10;
  FSend := False;
  FTitle := '';
  FWaitForOnWrite := False;
  FVersion := '';
  FEventId := 0;
  FEventUserState := eusNone;
  FLastCreatedEventId := 0;
  FFollowFrozen:=false;
  FBadLagRestrict:=false;
  FImageIndex := 0;
  FAbortedGameByBlack := false;
  FMaster := false;
  FCreated := 0;
  FNoMembershipChatWarned := false;
  FBot := TBot.Create(Self);
  FGamesPerDayList := TGamesPerDayList.Create;
end;
//==============================================================================
function TConnection.GetProvString: string;
var
  i: integer;
begin
  result:='';
  for i:=0 to 5 do
    result:=result+BoolTo_(Provisional[TRatedType(i)],'1','0');
end;
//==============================================================================
procedure TConnection.SendRights;
var
  s: string;
begin
  s := BoolTo_(MembershipType > mmbNone, '1', '0');
  CSSocket.fSocket.Send(Self, [DP_RIGHTS,
    BoolTo_(Rights.SelfProfile,'1','0'),
    BoolTo_(Rights.Achievements,'1','0'),
    s, // message sending
    s, // library usage
    s, // achievements
    s  // saving games
    ]);
end;
//==============================================================================
function TConnection.IsPlayingGame: Boolean;
var
  i: integer;
  game: TGame;
begin
  result:=true;
  for i:=0 to Games.Count-1 do begin
    game:=TGame(Games[i]);
    if (game<>nil) and (game.GameMode=gmLive) and (game.GameResult=grNone)
      and (FLoginID in [game.WhiteID, game.BlackID])
    then
      exit;
  end;
  result:=false;
end;
//==============================================================================
procedure TConnection.QuitFinishedGameIfNeed;
var
  i, cnt: integer;
  GM, GameToQuit: TGame;
begin
  cnt := 0;
  GameToQuit := nil;

  for i := 0 to Games.Count - 1 do begin
    GM := Games[i];
    if GM.EventID <> 0 then continue;
    if (GM.GameMode <> gmLive) and (GameToQuit = nil) then
      GameToQuit := GM;
    inc(cnt);
  end;
  if cnt >= Self.GameLimit then begin
    CSGames.fGames.Quit(GameToQuit, Self);
    CSSocket.fSocket.SmartSend(Self, nil, [DP_GAME_QUIT, GameToQuit.GameNumber], nil);
  end;
end;
//==============================================================================
procedure TConnection.AddNotify(LoginID: integer; Login, Title: string;
  NotifyType: TNotifyType; SendNotify, CreateMirror: Boolean);
var
  nt: TNotify;
  conn: TConnection;
  Visible: string;
begin
  conn := nil;
  if NotifyType in [ntCensor, ntNoPlay] then
    RemoveNotify(LoginID, false);

  { Add the Notify person to my local list. }
  nt := TNotify.Create;
  nt.FLoginID := LoginID;
  nt.FLogin := Login;
  nt.FTitle := Title;
  nt.FNotifyType := NotifyType;
  FNotify.Add(nt);

  { Add this Connection to the list of Connections for which the
    Censor Connection is resposnible. }
  if CreateMirror then begin
    conn := fConnections.GetConnection(login);
    if Assigned(conn) then begin
      nt := TNotify.Create;
      nt.FLoginID := Self.LoginID;
      nt.FLogin := Self.Handle;
      nt.FTitle := Self.Title;
      nt.FNotifyType := TNotifyType(ord(NotifyType)+1);
      conn.FNotify.Add(nt);
    end;
  end;

  if Assigned(conn) and not conn.Invisible then Visible := '1'
  else Visible := '0';

  if SendNotify then
    CSSocket.fSocket.Send(Self, [DP_NOTIFY, IntToStr(LoginID), login, Title,
      IntToStr(ord(NotifyType)),
      Visible]);
end;
//==============================================================================
procedure TConnection.RemoveNotify(LoginID: integer;
  NotifyCensor: Boolean // true - Notify, false - Censor
);
var
  i: integer;
  nt: TNotify;
  conn: TConnection;
begin
  // Remove the Notify person from this Connections NotifyList.
  for i := FNotify.Count - 1 downto 0 do begin
    nt := TNotify(FNotify[i]);
    if (nt.FLoginID = LoginID) and
      (NotifyCensor and (nt.FNotifyType = ntFriend) or not NotifyCensor and (nt.FNotifyType in [ntCensor, ntNoPlay]))
    then begin
      FNotify.Delete(i);
      break;
    end;
  end;

  // Remove this Connection to the list of Connections for which the
  //  Notify Connection is resposnible.
  conn := fConnections.GetConnection(LoginID);
  if Assigned(conn) then
    for i := conn.FNotify.Count - 1 downto 0 do begin
      nt := TNotify(conn.FNotify[i]);
      if (nt.FLoginID = LoginID)
        and (NotifyCensor and (nt.FNotifyType = ntIFriend) or not NotifyCensor and (nt.FNotifyType in [ntICensor, ntINoPlay]))
      then begin
        conn.FNotify.Delete(i);
        break;
      end;
    end;

end;
//==============================================================================
procedure TConnection.SendINotify(Online: Boolean);
var
  i: integer;
  conn: TConnection;
  nt: TNotify;
begin
  if Invisible then exit;
  for i := 0 to FNotify.Count -1 do begin
    nt := TNotify(FNotify[i]);
    if nt.FNotifyType in [ntIFriend, ntICensor, ntINoPlay] then begin
      conn := fConnections.GetConnection(nt.FLogin);
      if Assigned(conn) then
          CSSocket.fSocket.Send(conn, [DP_NOTIFY,
            IntToStr(Self.LoginID), Self.Handle, Self.Title,
            IntToStr(ord(nt.FNotifyType)-1),
            BoolTo_(Online, '1', '0')]);
    end;
  end;
end;
//==============================================================================
procedure TConnection.SendNoMembershipMsg(p_Msg: string);
begin
  CSSocket.fSocket.Send(Self, [DP_SERVER_MSG, DP_ERR_1, DP_MSG_MEMBERSHIP_END + p_Msg]);
end;
//==============================================================================
procedure TConnection.SendNotifyList;
var
  conn: TConnection;
  nt: TNotify;
  i: Integer;
begin
  CSSocket.fSocket.Send(Self, [DP_NOTIFY_BEGIN]);
  { Send DPnt for each player in my list. }
  for i := 0 to FNotify.Count -1 do begin
    nt := TNotify(FNotify[i]);
    if nt.FNotifyType in [ntFriend, ntCensor, ntNoPlay] then begin
      conn := fConnections.GetConnection(nt.FLogin);
      CSSocket.fSocket.Send(Self, [DP_NOTIFY, IntToStr(FLoginID), nt.FLogin,
        nt.FTitle, IntToStr(ord(nt.FNotifyType)),
        BoolTo_(Assigned(conn) and not conn.Invisible, '1', '0')])
    end
  end;
  { Send DPnt_LIST_END }
  CSSocket.fSocket.Send(Self, [DP_NOTIFY_END]);
end;
//==============================================================================
function TConnection.GetNoPlay(const Value: TConnection): Boolean;
var
  Notify: TNotify;
  Index: Integer;
begin
  Result := false;
  for Index := FNotify.Count -1 downto 0 do
    begin
      Notify := TNotify(FNotify[Index]);
      if (Notify.FNotifyType in [ntCensor,ntNoPlay]) and (Notify.FLogin = Value.Handle) then
        begin
          Result := True;
          Break;
        end;
    end
end;
//==============================================================================
function TConnection.AchievementAllowed: Boolean;
begin
  result := (CompareVersion(Version, '8.0ba') = 0) and (adminlevel = alSuper)
    or (CompareVersion(Version, '8.0bb') >= 0) and
      ((ord(adminlevel) >= ACH_ADMIN_LEVEL) or InCommaString(Roles, 'AchievementUser'))
end;
//==============================================================================
procedure TConnection.SendRoles;
begin
  CSSocket.fSocket.Send(Self, [DP_ROLES, Roles]);
end;
//==============================================================================
procedure TConnection.SendTrialWarning(p_Message: string);
var
  Param, link: string;
begin
  if MembershipType = mmbNone then Param := SW_END_MEMBERSHIP
  else Param := SW_TRIAL_MEMBERSHIP;

  if MembershipType = mmbCore then link := 'http://www.infiniachess.com/core-members.html'
  else link := '';

  CSSocket.fSocket.Send(Self, [DP_SERVER_WARNING, Param, p_Message, link]);
end;
//==============================================================================
{ TGamesPerDayList }

procedure TGamesPerDayList.AddCounter(p_RatedType: TRatedType);
var
  i: integer;
  G: TGamesPerDay;
begin
  for i := 0 to Count - 1 do begin
    G := TGamesPerDay(Items[i]);
    if G.RatedType = p_RatedType then begin
      G.GamesCnt := G.GamesCnt + 1;
      exit;
    end;
  end;
end;
//==============================================================================
procedure TGamesPerDayList.AddRecord(p_RatedType: TRatedType; p_GamesCnt: integer);
var
  G: TGamesPerDay;
begin
  G := TGamesPerDay.Create;
  G.RatedType := p_RatedType;
  G.GamesCnt := p_GamesCnt;
  Add(G);
end;
//==============================================================================
function TGamesPerDayList.GetGamesCnt(p_RatedType: TRatedType): integer;
var
  i: integer;
  G: TGamesPerDay;
begin
  for i := 0 to Count - 1 do begin
    G := TGamesPerDay(Items[i]);
    if G.RatedType = p_RatedType then begin
      result := G.GamesCnt;
      exit;
    end;
  end;
  result := 0;
end;
//==============================================================================
procedure TGamesPerDayList.Nullify;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    TGamesPerDay(List[i]).GamesCnt := 0;
end;
//==============================================================================
end.

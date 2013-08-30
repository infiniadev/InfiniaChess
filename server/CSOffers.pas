{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSOffers;

interface

uses
  Classes, Contnrs, SysUtils, CSOffer, CSConnection, CSConst, CLOfferOdds;

type
  TOffers = class(TObject)
  private
    { Private declarations }
    FOffers: TObjectList;

    function GetOffer(const OfferNumber: Integer; var Index: Integer): TOffer;
    function CanAutoMatch(Offer1, Offer2: TOffer): Boolean;
    function GetAutoMatchOffer(Offer: TOffer): TOffer;
    function IndexOf(const OfferNumber: Integer): Integer;
    procedure Remove(const Offer: TOffer; const Index: Integer);

  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    function CanAccept(Offer: TOffer; Connection: TConnection; var err: string): Boolean;
    function OfferColor(Offer: TOffer; Connection: TConnection): integer;
    procedure Accept(Offer: TOffer; Connection: TConnection);
    procedure CMD_Accept(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Decline(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Load(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Match(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Resume(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Seek(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_UnOffer(var Connection: TConnection; var CMD: TStrings);
    procedure New(const Color: integer; InitialTime: string; IncTime, MaxRating, MinRating,
      Rated, RatedType, GameID: Integer; var Issuer, Issuee: TConnection;
      const OfferType: TOfferType;
      const cReject: integer;
      const PReject: Boolean;
      const Odds: TOfferOdds;
      WL: string = '';
      WT: string = '';
      WR: integer = 0;
      BL: string = '';
      BT: string = '';
      BR: integer = 0);
    procedure Release(const Connection: TConnection);
    procedure RemoveOffers(const Connection: TConnection;
      const Excluding: TOffer);
    procedure SendSeeks(var Connection: TConnection);
    function OfferExists(Offer: TOffer): Boolean;
    procedure CMD_PlayEngineGame(Connection: TConnection; CMD: TStrings);
    function OfferExistsByTime(p_InitTime: string; p_IncTime: integer): Boolean;

  published
    { Published declarations }
  end;

var
  fOffers: TOffers;

implementation

uses
  CSDb, CSSocket, CSConnections, CSGames, CSGame, CSLib, CLRating;

const
  OFFER_NUM = 1;

//______________________________________________________________________________
procedure TOffers.New(const Color: integer; InitialTime: string; IncTime, MaxRating, MinRating,
  Rated, RatedType, GameID: Integer; var Issuer, Issuee: TConnection;
  const OfferType: TOfferType;
  const cReject: integer;
  const PReject: Boolean;
  const Odds: TOfferOdds;
  WL: string = '';
  WT: string = '';
  WR: integer = 0;
  BL: string = '';
  BT: string = '';
  BR: integer = 0);
var
  Connection: TConnection;
  Offer, OfferAutoMatch: TOffer;
  Index: Integer;
  s: string;
begin
  Offer := TOffer.Create(Color, InitialTime, IncTime, MaxRating, MinRating,
    Rated, GameID, TRatedType(RatedType), Issuer, Issuee, OfferType,
    cReject=1, PReject, Odds);

  if OfferExists(Offer) then begin
    Offer.Free;
    exit;
  end;
  FOffers.Add(Offer);
  Index := FOffers.Count -1;
  Issuer.OfferCount := Issuer.OfferCount + 1;

  if OfferType in [otMatch, otResume] then begin
    if Issuer = Issuee then begin
      fGames.CreateGame(Offer,WL,WT,WR,BL,BT,BR);
      FOffers.Remove(Offer);
    end else begin
      { Check Censoring; Is Issuer being censored? }
      if Issuee.NoPlay[Issuer] then begin
        Issuer.OfferCount := Issuer.OfferCount - 1;
        FOffers.Delete(Index);
        s := Format(DP_MSG_CENSORED, [Issuee.Handle]);
        fSocket.Send(Issuer, [DP_SERVER_MSG, DP_ERR_2, s], Issuer);
        exit;
      end;

      { Check Censoring; Is Issuer censoring Issuee? }
      if Issuer.NoPlay[Issuee] then begin
        Issuer.OfferCount := Issuer.OfferCount - 1;
        FOffers.Delete(Index);
        s := Format(DP_MSG_CENSORING, [Issuee.Handle]);
        fSocket.Send(Issuer, [DP_SERVER_MSG, DP_ERR_2, s], Issuer);
        exit;
      end;

      Offer.SendOffer(Offer.Issuee);
      Offer.SendOffer(Offer.Issuer);

      if Offer.Issuee.ConnectionType = cntEngine then
        Issuee.Bot.OnMatch(Offer);
    end
  end else begin
    if Issuer.AutoMatch then OfferAutoMatch := GetAutoMatchOffer(Offer)
    else OfferAutoMatch := nil;

    if OfferAutoMatch <> nil then begin
      FOffers.Delete(Index);
      Accept(OfferAutoMatch, Offer.Issuer);
      //Offer.Free;
    end else
      Offer.SendOffer(nil);
  end;
end;
//______________________________________________________________________________
function TOffers.GetOffer(const OfferNumber: Integer; var Index: Integer): TOffer;
begin
  { Sets the Index var to index position the TOffer in FOffers. }
  Result := nil;
  Index := IndexOf(OfferNumber);
  if Index > -1 then Result := TOffer(FOffers[Index]);
end;
//______________________________________________________________________________
function TOffers.IndexOf(const OfferNumber: Integer): Integer;
var
  L, H, I, C: Integer;
begin
  { Binary search of the FGames list. Finds the index of the GameNumber
    param. -1 if not found. This only works because GameNumbers are added to
    FGames in a serially !!!}
  Result := -1;
  L := 0;
  H := FOffers.Count - 1;
  while L <= H do
    begin
      I := (L + H) shr 1;
      C := TOffer(FOffers[I]).OfferNumber - OfferNumber;
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
    end;
end;
//______________________________________________________________________________
function TOffers.CanAutoMatch(Offer1, Offer2: TOffer): Boolean;
var
  err: string;
  rating: integer;
begin
  result := false;

  if Offer1.Issuer = Offer2.Issuer then exit;

  if (Offer1.OfferType <> otSeek) or (Offer2.OfferType <> otSeek) then exit;

  if not CanAccept(Offer1, Offer2.Issuer, err) then exit;

  rating := Offer1.Issuer.Rating[Offer1.RatedType];
  if (rating < Offer2.Issuer.AutoMatchMinR) or (rating > Offer2.Issuer.AutoMatchMaxR) then
    exit; 

  if (Offer1.InitialTime <> Offer2.InitialTime) or (Offer1.IncTime <> Offer2.IncTime)
    or (Offer1.RatedType <> Offer2.RatedType) or (Offer1.Rated <> Offer2.Rated)
    or Offer1.Odds.FAutoTimeOdds <> Offer2.Odds.FAutoTimeOdds
    or Offer1.Odds.Defined or Offer2.Odds.Defined
  then
    exit;

  result := true;
end;
//______________________________________________________________________________
function TOffers.GetAutoMatchOffer(Offer: TOffer): TOffer;
var
  i: integer;
begin
  for i := 0 to FOffers.Count - 1 do begin
    result := TOffer(FOffers[i]);
    if CanAutoMatch(result, offer) then exit;
  end;
  result := nil;
end;
//______________________________________________________________________________
procedure TOffers.Remove(const Offer: TOffer; const Index: Integer);
begin
  if Offer.OfferType in [otMatch, otResume] then
    begin
      fSocket.Send(Offer.Issuer, [DP_UNOFFER, IntToStr(Offer.OfferNumber)],Offer.Issuer);
      fSocket.Send(Offer.Issuee, [DP_UNOFFER, IntToStr(Offer.OfferNumber)],Offer.Issuer);
    end
  else
    begin
      fSocket.Send(fConnections.Connections,
        [DP_UNOFFER, IntToStr(Offer.OfferNumber)],Offer.Issuer);
    end;
  if Index > -1 then FOffers.Delete(Index);
end;
//______________________________________________________________________________
constructor TOffers.Create;
begin
  Randomize;
  FOffers := TObjectList.Create;
  FCreatedCount := 0;
end;
//______________________________________________________________________________
destructor TOffers.Destroy;
begin
  FOffers.Free; { TObjectList will destroy any TOffers for us }
  inherited Destroy;
end;
//______________________________________________________________________________
function TOffers.CanAccept(Offer: TOffer; Connection: TConnection; var err: string): Boolean;
begin
  if Connection.Invisible then err := 'Invisible user cannot accept game'
  else if MODE_NOGAMES then err := DP_MSG_MODE_NOGAMES
  else if (Connection.CountLiveNotEventGames >= Connection.GameLimit) then err := DP_MSG_GAME_LIMIT_MET
  else if (Offer.Issuer.CountLiveNotEventGames >= Offer.Issuer.GameLimit) then err := 'Your opponent has reached his game limit. Leave a game and try again.'
  else if (Offer.OfferType in [otMatch, otResume]) and not (Offer.Issuee = Connection) then
    err := DP_MSG_NOT_OFFER_RECEPIENT
  else if (Offer.OfferType = otSeek) and not Offer.Qualifies(Connection) then
    err := Format(DP_MSG_RATING_RANGE, [Offer.Issuee.Handle])
  else if Offer.Issuer.NoPlay[Connection] then
    err := Format(DP_MSG_CENSORED, [Offer.Issuer.Handle])
  else if Connection.NoPlay[Offer.Issuer] then
    err := Format(DP_MSG_CENSORING, [Offer.Issuer.Handle])
  else if (Connection.Title='C') and Offer.CReject then err := DP_MSG_CREJECT
  else if Connection.Provisional[Offer.RatedType] and Offer.PReject then err := DP_MSG_PREJECT
  else if Connection.BadLagRestrict and (Offer.Issuer.PingLast>BAD_LAG_LIMIT) then
    err := Offer.Issuer.Handle+' has too big lag to play this game'
  else if Offer.Issuer.BadLagRestrict and (Connection.PingLast>BAD_LAG_LIMIT) then
    err := 'You have too big lag to play this game'
  else if Offer.Issuer.LoseOnDisconnect and not Connection.LoseOnDisconnect then
    err := 'You must have option ''Players lose if disconnect'' checked to accept this game'
  else if Offer.Odds.FAutoTimeOdds and Offer.Rated and Connection.Provisional[Offer.RatedType] then
    err := 'You have provisional rating and cannot accept rated game with time odds'
  else err := '';

  result := err = '';
end;
//______________________________________________________________________________
function TOffers.OfferColor(Offer: TOffer; Connection: TConnection): integer;
begin
  { When Offers are created the creator is both black and white. Set the
  accepting connection to White or Black depending on the Requested Color. }
  with Offer do
    if Issuer <> Connection then begin { If Random Color... }
      if Color = 0 then begin
        { Adjust LastColor property if necessary. }
        if Issuer.LastColor = 0 then
          Issuer.LastColor := Connection.LastColor * REVERSE_COLOR;
        if Connection.LastColor = 0 then
          Connection.LastColor := Issuer.LastColor * REVERSE_COLOR;

        if Issuer.AbortedGameByBlack = Connection.AbortedGameByBlack then begin
          Color := Random(2);
          if Color = 0 then Color := WHT
          else Color := BLK;
          { Override random. Keeps #of times playing a Color more even. }
          if Issuer.LastColor <> Connection.LastColor then
            Color := Issuer.LastColor * REVERSE_COLOR;
        end else begin
          if Issuer.AbortedGameByBlack then Color := BLK
          else Color := WHT;
        end;

        if Color = WHT then Connection.AbortedGameByBlack := false
        else Issuer.AbortedGameByBlack := false;
      end;
      result := Color;
    end;
end;
//______________________________________________________________________________
procedure TOffers.Accept(Offer: TOffer; Connection: TConnection);
var
  OfferNumber, Index: integer;
begin
  OfferNumber := Offer.OfferNumber;

  with Offer do begin
    Color := OfferColor(Offer, Connection);
    if Color = WHT then begin
      White := Issuer;
      Black := Connection;
    end else begin
      White := Connection;
      Black := Issuer;
    end;
  end;

  { Create the game }
  fGames.CreateGame(Offer);

  { CreateGame has the potential to reindex the offer (due to releasing of
    other offers). Get the index again. }
  Offer := GetOffer(OfferNumber, Index);
  Remove(Offer, Index);
end;
//______________________________________________________________________________
procedure TOffers.CMD_Accept(var Connection: TConnection; var CMD: TStrings);
var
  _Offer: TOffer;
  Index, OfferNumber, n: Integer;
  s, err: string;
  rt: TRatedType;
  msg: string;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = OfferNumber (OFFER_NUM) }

  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  try
    OfferNumber := StrToInt(CMD[OFFER_NUM]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
    exit;
  end;

  _Offer := GetOffer(OfferNumber, Index);

  if (not Assigned(_Offer)) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_OFFER],nil);
    exit;
  end;

  if CompareVersion(Connection.Version, MIN_SUPPORTED_VER)=-1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, 'You use old version of infinia client and cannot play games.']);
    fDB.SendVersionLink(Connection, false);
    exit;
  end;

  if (Connection.MembershipType = mmbNone) and not IsStandardRules(_Offer.RatedType) then begin
    Connection.SendNoMembershipMsg(DP_MSG_STANDARD_RULES_ONLY);
    exit;
  end;

  if (Connection.MembershipType in [mmbNone, mmbCore]) and _Offer.Odds.FAutoTimeOdds or _Offer.Odds.Defined then begin
    Connection.SendNoMembershipMsg(DP_MSG_NO_ODDS);
    exit;
  end;

  if Connection.GamesLimitReached(TRatedType(_Offer.RatedType)) then begin
    msg := 'You have reached ' + RatedType2Str(TRatedType(_Offer.RatedType)) + ' games limit per day';
    if CompareVersion(Connection.Version, '8.1ah') = -1 then
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, msg + ' Click here "http://www.infiniachess.com/customer-profile.aspx" to become full access member"'])
    else
      Connection.SendTrialWarning(msg);
    exit;
  end;

  Connection.QuitFinishedGameIfNeed;
  _Offer.Issuer.QuitFinishedGameIfNeed;

  if not CanAccept(_Offer, Connection, err) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, err],nil);
    exit;
  end;

  Accept(_Offer, Connection);
end;
//______________________________________________________________________________
procedure TOffers.CMD_Decline(var Connection: TConnection; var CMD: TStrings);
var
  _Offer: TOffer;
  OfferNumber, Index: Integer;
  s: string;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = OfferNumber (OFFER_NUM) }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Verify the integrity of the paramater }
  try
    OfferNumber := StrToInt(CMD[OFFER_NUM]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
    Exit;
  end;

  { Attempt to get the Offer }
  _Offer := GetOffer(OfferNumber, Index);

  { Offer number does not exist }
  if not Assigned(_Offer) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_OFFER],nil);
      Exit;
    end;

  { Cannot decline a match offer that was not directed to the Connection sending
    this command. Cannot decline a seek }
  if (_Offer.OfferType = otSeek) or not (_Offer.Issuee = Connection) then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_OFFER_RECEPIENT],nil)
  else
    begin
      s := Format(DP_MSG_DECLINE_OFFER, [_Offer.Issuee.Handle]);
      fSocket.Send(_Offer.Issuer, [DP_SERVER_MSG, DP_ERR_0, s],nil);
      Remove(_Offer, Index);
    end;
end;
//______________________________________________________________________________
procedure TOffers.CMD_Load(var Connection: TConnection; var CMD: TStrings);
const
  GAME_ID = 1;
var
  GameID, BlackID, WhiteID, Inc, Rated, RatedType: Integer;
  BlackLogin, WhiteLogin, Int, BlackTitle, WhiteTitle: string;
  BlackRating, WhiteRating: integer;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameID (GAMEID) }
  if CMD.Count <= 1 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check the Issuers Game and Offer limits }
  if Connection.CountLiveNotEventGames >= Connection.GameLimit then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_GAME_LIMIT_MET],nil);
      Exit;
    end;

  { Verify the integrity of the paramater }
  try
    GameID := StrToInt(CMD[GAME_ID]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
    Exit;
  end;

  { Validate the GameID as a saved game in the DB. Assigns GameHeader info
    to the passed params. -1 assigned to BlackID or WhiteID indicates a
    non-existant GameID. }
  fDB.VerifyGame(Connection.LoginID, GameID, False, BlackID,
    WhiteID, Int, Inc, Rated, RatedType, BlackLogin, WhiteLogin, BlackTitle, WhiteTitle, BlackRating, WhiteRating);

  { Not a valid game. }
  if (WhiteID = -1) or (BlackID = -1) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_GAME],nil);
      Exit;
    end;

  { Valid game. Create a Offer of type otMatch.}
  New(WHT, Int, Inc, 0, 0, Rated, RatedType, GameID, Connection, Connection,
    otMatch,0, false, nil, WhiteLogin, WhiteTitle, WhiteRating, BlackLogin, BlackTitle, BlackRating);
end;
//______________________________________________________________________________
procedure TOffers.CMD_Match(var Connection: TConnection; var CMD: TStrings);
const
  OFFER_ISSUEE = 1;
  OFFER_INITIAL = 2;
  OFFER_INC = 3;
  OFFER_RATED = 4;
  RATING_TYPE = 5;
  OFFER_COLOR = 6;
  AUTO_TIME_ODDS = 7;
  ODDS_INITMIN = 8;
  ODDS_INITSEC = 9;
  ODDS_INC = 10;
  ODDS_PIECE = 11;
  ODDS_TIME_DIRECTION = 12;
  ODDS_PIECE_DIRECTION = 13;
var
  Opponent: TConnection;
  Color, Inc, Rated, IntSec, IssuerRating, OpponentRating: Integer;
  Odds: TOfferOdds;
  Int, s, msg: string;
  PReject: Boolean;
  RatedType: TRatedType;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = Issuee (OFFER_ISSUEE)
    CMD[2] = InitialTime (OFFER_INITIAL)
    CMD[3] = IncTime (OFFER_INC)
    CMD[4] = Rated (OFFER_RATED) optional
    CMD[5] = RatedType (RATING_TYPE) optional
    CMD[6] = Color (OFFER_COLOR optional }

  if Connection.Invisible then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invisible user cannot match']);
    exit;
  end;

  if MODE_NOGAMES then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MODE_NOGAMES],nil);
    exit;
  end;

  if CMD.Count <= 1 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check the Issuers Game and Offer limits }
  if (Connection.OfferCount >= Connection.OfferLimit)
  or (Connection.CountLiveNotEventGames >= Connection.GameLimit) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_OFFER_LIMIT_MET],nil);
      Exit;
    end;

  {if (Connection.Title = 'C') then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_C_NO_SEEK]);
      Exit;
    end;}

  { Defaults }
  Color := Connection.Color;
  Int := Connection.InitialTime;
  Inc := Connection.IncTime;
  Rated := Integer(Connection.Rated);
  RatedType := Connection.RatedType;
  PReject := Connection.PReject;
  Odds := TOfferOdds.Create;

  { Verify that the opponent is actually connected. }
  Opponent := fConnections.GetConnection(CMD[1]);
  if not Assigned(Opponent) or Opponent.Invisible or
    (Opponent.ConnectionType = cntPlayer) and not Assigned(Opponent.Socket)
  then begin
    s := Format(DP_MSG_LOGIN_NOT_LOGGEDIN, [CMD[1]]);
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
    Exit;
  end;

  { Veify the oppoenent is open for matches }
  if not (Opponent.Open) and (Connection <> Opponent) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1,
        Opponent.Handle + #32 + DP_MSG_NOT_OPEN],nil);
      Exit;
    end;

  if Opponent.RejectWhilePlaying and fGames.UserIsPlaying(Opponent) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1,
      Opponent.Handle+' is playing a game now and cannot accept your request. Please, try later.'],nil);
    exit;
  end;

  { Verify the integrity of the parameters override the defaults as necessary. }
  try
    if CMD.Count > OFFER_INITIAL then Int := CMD[OFFER_INITIAL];
    if CMD.Count > OFFER_INC then Inc := StrToInt(CMD[OFFER_INC]);
    if CMD.Count > OFFER_COLOR then Color := StrToInt(CMD[OFFER_COLOR]);
    if CMD.Count > OFFER_RATED then Rated := StrToInt(CMD[OFFER_RATED]);
    if CMD.Count > RATING_TYPE then RatedType := TRatedType(StrToInt(CMD[RATING_TYPE]));
    if CMD.Count > AUTO_TIME_ODDS then Odds.FAutoTimeOdds := CMD[AUTO_TIME_ODDS] = '1';
    if CMD.Count > ODDS_INITMIN then Odds.FInitMin := StrToInt(CMD[ODDS_INITMIN]);
    if CMD.Count > ODDS_INITSEC then Odds.FInitSec := StrToInt(CMD[ODDS_INITSEC]);
    if CMD.Count > ODDS_INC then Odds.FInc := StrToInt(CMD[ODDS_INC]);
    if CMD.Count > ODDS_PIECE then Odds.FPiece := StrToInt(CMD[ODDS_PIECE]);
    if CMD.Count > ODDS_TIME_DIRECTION then Odds.FTimeDirection := TOfferOddsDirection(StrToInt(CMD[ODDS_TIME_DIRECTION]));
    if CMD.Count > ODDS_PIECE_DIRECTION then Odds.FPieceDirection := TOfferOddsDirection(StrToInt(CMD[ODDS_PIECE_DIRECTION]));
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
    Exit;
  end;

  if RatedType in [rtStandard, rtBlitz, rtBullet] then
    RatedType := TimeToRatedType(Int, Inc);

  IntSec := TimeToMSEc(Int) div 1000;

  { Guests cannot offer Rated games nor can they be matched rated games. }
  if (Rated = 1) and ((not Connection.Registered) or (not Opponent.Registered)) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_GUEST_NO_RATED],nil);
      Exit;
    end;

  if IntSec < 10 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_SMALL_TIME2],nil);
      exit;
    end;

  if (Inc=0) and (IntSec < 30) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_SMALL_TIME],nil);
      exit;
    end;

  if Connection.BadLagRestrict and (Opponent.PingLast>BAD_LAG_LIMIT) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG, DP_ERR_2, Opponent.Handle+' has too big lag to play this game'],nil);
    exit;
  end else if Opponent.BadLagRestrict and (Connection.PingLast>BAD_LAG_LIMIT) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG, DP_ERR_2, 'You have too big lag to play this game'],nil);
    exit;
  end;

  if Odds.FAutoTimeOdds and (Rated = 1) and (fTimeOddsLimits.GetLimit(IntSec, Inc) = nil) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'You cannot play nonstandard rated game with time odds'],nil);
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Available game types: '+fTimeOddsLimits.GetMessageList],nil);
    exit;
  end;

  if (CompareVersion(Opponent.Version, VERSION_ODDS) = -1) and (Odds.Defined or Odds.FAutoTimeOdds) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Your opponent does not have proper version to play odds game'],nil);
    exit;
  end;

  if (Connection.MembershipType = mmbNone) and not IsStandardRules(RatedType) then begin
    Connection.SendNoMembershipMsg(DP_MSG_STANDARD_RULES_ONLY);
    exit;
  end;

  if (Connection.MembershipType in [mmbNone, mmbCore]) and Odds.FAutoTimeOdds or Odds.Defined then begin
    Connection.SendNoMembershipMsg(DP_MSG_NO_ODDS);
    exit;
  end;

  if (Opponent <> Connection) and Connection.GamesLimitReached(RatedType) then begin
    msg := 'You have reached ' + RatedType2Str(RatedType) + ' games limit per day';
    if CompareVersion(Connection.Version, '8.1ah') = -1 then
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, msg + ' Click here "http://www.infiniachess.com/customer-profile.aspx" to become full access member"'])
    else
      Connection.SendTrialWarning(msg);
    exit;
  end;

  if CompareVersion(Connection.Version, MIN_SUPPORTED_VER)=-1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, 'You use old version of infinia client and cannot play games.']);
    fDB.SendVersionLink(Connection, false);
    exit;
  end;

  if Odds.FAutoTimeOdds and
    (Connection.Provisional[RatedType] or Opponent.Provisional[RatedType])
  then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, DP_MSG_PROV_ODDS],nil);
    exit;
  end;

  IssuerRating := Connection.Rating[RatedType];
  OpponentRating := Opponent.Rating[RatedType];
  if Odds.FAutoTimeOdds and
    ((OpponentRating  < IssuerRating - AUTOTIMEODDS_RATING_DIFF) or
     (OpponentRating  > IssuerRating + AUTOTIMEODDS_RATING_DIFF))
  then begin
    s := lowercase(RatedType2Str(TRatedType(RatedType)));
    msg := Format('%s''s %s rating differs by more then %d from your %s rating. You cannot play odds rating game with this player.',
      [Opponent.Handle, s, AUTOTIMEODDS_RATING_DIFF, s]);
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, msg]);
    exit;
  end;


  { Don't allow negative int or inc times }
  {if (StrToInt(Int) < 0) or (Inc < 0) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_NEG_TIME]);
      if StrToInt(Int) < 0 then Int := '0';
      if Inc < 0 then Inc := 0;
    end;}

  { Adjust to minimum time if necessary }
  if (Int = '0') and (Inc = 0) then Int := '1';

  New(Color, Int, Inc, 0, 0, Rated, ord(RatedType), -1, Connection, Opponent, otMatch, 0, pReject, Odds);
end;
//______________________________________________________________________________
procedure TOffers.CMD_PlayEngineGame(Connection: TConnection; CMD: TStrings);
var
  Login1, Login2, InitTime: string;
  IncTime: integer;
  Issuer: TConnection;
  sl: TStrings;
begin
  if CMD.Count < 5 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
    exit;
  end;

  Login1 := CMD[1];
  Login2 := CMD[2];
  InitTime := CMD[3];

  try
    IncTime := StrToInt(CMD[4]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number'],nil);
    exit;
  end;

  Issuer := fConnections.GetConnection(Login1);
  if Issuer = nil then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Connection does not exists:' + Login1],nil);
    exit;
  end;

  if fConnections.GetConnection(Login2) = nil then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Connection does not exists:' + Login2],nil);
    exit;
  end;

  sl := TStringList.Create;
  try
    sl.Add('/match');
    sl.Add(login2);
    sl.Add(InitTIme);
    sl.Add(IntToStr(IncTime));
    CMD_Match(Issuer, sl);
  finally
    sl.Free;
  end;
end;
//______________________________________________________________________________
procedure TOffers.CMD_Resume(var Connection: TConnection; var CMD: TStrings);
const
  GAME_ID = 1;
var
  Opponent: TConnection;
  GameID, BlackID, WhiteID, Color, Inc, Rated, RatedType: Integer;
  BlackLogin, WhiteLogin, BlackTitle, WhiteTitle, s, Int: string;
  BlackRating, WhiteRating: integer;
begin
  { Check param count:
    CMD[0] = /Command
    CMD[1] = GameID (GAMEID) }
  if CMD.Count <= 1 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check the Issuers Game and Offer limits }
  if (Connection.OfferCount >= Connection.OfferLimit)
  or (Connection.CountLiveNotEventGames >= Connection.GameLimit) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_OFFER_LIMIT_MET],nil);
      Exit;
    end;

  { Verify the integrity of the paramater }
  try
    GameID := StrToInt(CMD[GAME_ID]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
    Exit;
  end;

  { Validate the GameID as a Adjourned game for this Connection.
    Assigns GameHeader info to the passed params. -1 assigned to BlackID or
    WhiteID indicates a invalid Adjourned GameID for this Connection. }
  fDB.VerifyGame(Connection.LoginID, GameID, True, BlackID, WhiteID, Int, Inc,
    Rated, RatedType, BlackLogin, WhiteLogin, BlackTitle, WhiteTitle, BlackRating, WhiteRating);

  { Not a valid adjourned game. }
  if (WhiteID = -1) or (BlackID = -1) then
    begin
      s := Format(DP_MSG_INVALID_ADJOURN, [CMD[GAME_ID]]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Valid adjounred game. Now verify that the opponent is actually connected. }
  if Connection.LoginID = BlackID then
    begin
      Opponent := fConnections.GetConnection(WhiteLogin);
      s := WhiteLogin;
      Color := BLK;
    end
  else
    begin
      Opponent := fConnections.GetConnection(BlackLogin);
      s := BlackLogin;
      Color := WHT;
    end;

  if not Assigned(Opponent) or not Assigned(Opponent.Socket) then
    begin
      s := Format(DP_MSG_LOGIN_NOT_LOGGEDIN, [s]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { ??? Check to see if a offer with this gameID is already present. }

  { Valid game and the opponent is logged in. Create a Offer of type otResume.}
  New(Color, Int, Inc, 0, 0, Rated, RatedType, GAMEID, Connection, Opponent,
    otResume, 0, false, nil, WhiteLogin, WhiteTitle, WhiteRating, BlackLogin, BlackTitle, BlackRating);
end;
//______________________________________________________________________________
procedure TOffers.CMD_Seek(var Connection: TConnection; var CMD: TStrings);
const
  OFFER_INITIAL = 1;
  OFFER_INC = 2;
  OFFER_RATED = 3;
  RATING_TYPE = 4;
  OFFER_COLOR = 5;
  MIN_RATING = 6;
  MAX_RATING = 7;
  C_REJECT = 8;
  AUTO_TIME_ODDS = 9;
  ODDS_INITMIN = 10;
  ODDS_INITSEC = 11;
  ODDS_INC = 12;
  ODDS_PIECE = 13;
  ODDS_TIME_DIRECTION = 14;
  ODDS_PIECE_DIRECTION = 15;
var
  Color, Inc, MaxRating, MinRating, Rated, RatedType, cReject, IntSec: Integer;
  Int, msg: string;
  PReject: Boolean;
  rt: TRatedType;
  Odds: TOfferOdds;
begin
  if Connection.Invisible then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invisible user cannot seek']);
    exit;
  end;

  { Check param count:
    CMD[0] = /Command
    CMD[1] = InitialTime (OFFER_INITIAL)
    CMD[2] = IncTime (OFFER_INC)
    CMD[3] = Rated (OFFER_RATED) optional
    CMD[4] = RatedType (RATING_TYPE) optional
    CMD[5] = RequestedColor (OFFER_COLOR) optional
    CMD[6] = MinRating (MIN_RATING) optional
    CMD[7] = MaxRating (MAX_RATING) optional
    CMD[8] = 0 - accept title C, 1 - reject }

  { Check the Issuers Game and Offer limits }
  if MODE_NOGAMES then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MODE_NOGAMES],nil);
    exit;
  end;

  if (Connection.OfferCount >= Connection.OfferLimit)
  or (Connection.CountLiveNotEventGames >= Connection.GameLimit) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_OFFER_LIMIT_MET],nil);
      Exit;
    end;

  {if (Connection.Title = 'C') then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_C_NO_SEEK]);
      Exit;
    end;}

  { Defaults }
  Color := Connection.Color;
  Int := Connection.InitialTime;
  Inc := Connection.IncTime;
  MaxRating := Connection.MaxRating;
  MinRating := Connection.MinRating;
  Rated := Integer(Connection.Rated);
  RatedType := Ord(Connection.RatedType);
  PReject := Connection.PReject;
  Odds := TOfferOdds.Create;

  { Verify the parameter integrity }
  try
    if CMD.Count > OFFER_INITIAL then Int := CMD[OFFER_INITIAL];
    if CMD.Count > OFFER_INC then Inc := StrToInt(CMD[OFFER_INC]);
    if CMD.Count > OFFER_COLOR then Color := StrToInt(CMD[OFFER_COLOR]);
    if CMD.Count > OFFER_RATED then Rated := StrToInt(CMD[OFFER_RATED]);
    if CMD.Count > RATING_TYPE then RatedType := StrToInt(CMD[RATING_TYPE]);
    if CMD.Count > MIN_RATING then MinRating := StrToInt(CMD[MIN_RATING]);
    if CMD.Count > MAX_RATING then MaxRating := StrToInt(CMD[MAX_RATING]);
    if CMD.Count > C_REJECT then cReject := StrToInt(CMD[C_REJECT])
    else cReject:=0;
    if CMD.Count > AUTO_TIME_ODDS then Odds.FAutoTimeOdds := CMD[AUTO_TIME_ODDS] = '1';
    if CMD.Count > ODDS_INITMIN then Odds.FInitMin := StrToInt(CMD[ODDS_INITMIN]);
    if CMD.Count > ODDS_INITSEC then Odds.FInitSec := StrToInt(CMD[ODDS_INITSEC]);
    if CMD.Count > ODDS_INC then Odds.FInc := StrToInt(CMD[ODDS_INC]);
    if CMD.Count > ODDS_PIECE then Odds.FPiece := StrToInt(CMD[ODDS_PIECE]);
    if CMD.Count > ODDS_TIME_DIRECTION then Odds.FTimeDirection := TOfferOddsDirection(StrToInt(CMD[ODDS_TIME_DIRECTION]));
    if CMD.Count > ODDS_PIECE_DIRECTION then Odds.FPieceDirection := TOfferOddsDirection(StrToInt(CMD[ODDS_PIECE_DIRECTION]));
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
    Exit;
  end;

  IntSec := TimeToMSec(Int) div 1000;

  if CompareVersion(Connection.Version,'7.7j')=-1 then begin
    MaxRating := 3000;
    MinRating := 0;
  end;

  { Guests are not allowed to play rated games. }
  if (Rated = 1) and (not Connection.Registered) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_GUEST_NO_RATED],nil);
    Exit;
  end;

  if IntSec < 10 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_SMALL_TIME2],nil);
    exit;
  end;

  if (Inc=0) and (TimeToMSec(Int) div 1000 < 30) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_SMALL_TIME],nil);
    exit;
  end;

  if Odds.FAutoTimeOdds and (Rated = 1) and (fTimeOddsLimits.GetLimit(IntSec, Inc) = nil) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'You cannot play nonstandard rated game with time odds'],nil);
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Available game types: '+fTimeOddsLimits.GetMessageList],nil);
    exit;
  end;

  if TRatedType(RatedType) in [rtStandard, rtBlitz, rtBullet] then
    rt := TimeToRatedType(Int, Inc)
  else
    rt := TRatedType(RatedType);

  if Odds.FAutoTimeOdds and (Rated = 1) and Connection.Provisional[rt] then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_PROV_ODDS],nil);
    exit;
  end;

  if not Connection.AllowSeekWhilePlaying and fGames.UserIsPlaying(Connection) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'You are playing game already and cannot seek for new game'],nil);
    exit;
  end;

  if CompareVersion(Connection.Version, MIN_SUPPORTED_VER)=-1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, 'You use old version of infinia client and cannot play games.']);
    fDB.SendVersionLink(Connection, false);
    exit;
  end;

  if (Connection.MembershipType = mmbNone) and not IsStandardRules(TRatedType(RatedType)) then begin
    Connection.SendNoMembershipMsg(DP_MSG_STANDARD_RULES_ONLY);
    exit;
  end;

  if (Connection.MembershipType in [mmbNone, mmbCore]) and Odds.FAutoTimeOdds or Odds.Defined then begin
    Connection.SendNoMembershipMsg(DP_MSG_NO_ODDS);
    exit;
  end;

  if Connection.GamesLimitReached(TRatedType(RatedType)) then begin
    msg := 'You have reached ' + RatedType2Str(TRatedType(RatedType)) + ' games limit per day';
    if CompareVersion(Connection.Version, '8.1ah') = -1 then
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, msg + ' Click here "http://www.infiniachess.com/customer-profile.aspx" to become full access member"'])
    else
      Connection.SendTrialWarning(msg);
    exit;
  end;

  {rt:=TimeToRatedType(Int,Inc);
  if (rt=rtBullet) and (Connection.PingAvg>BAD_LAG_LIMIT) and Connection.BadLagRestrict then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Your lag is too big for playing bullet games. Check your options or improve your connection.']);
    exit;
  end;}

  { Don't allow negative int or inc times }
  {if (StrToInt(Int) < 0) or (Inc < 0) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_NEG_TIME]);
      if StrToInt(Int) < 0 then Int := '0';
      if Inc < 0 then Inc := 0;
    end;}

  { Adjust to minimum time if necessary }
  if (Int = '0') and (Inc = 0) then Int := '1';

  New(Color, Int, Inc, MaxRating, MinRating, Rated, RatedType, -1,
    Connection, Connection, otSeek, cReject, PReject, Odds);
end;
//______________________________________________________________________________
procedure TOffers.CMD_UnOffer(var Connection: TConnection; var CMD: TStrings);
var
  _Offer: TOffer;
  Index, OfferNumber: Integer;
begin
  { Check param count:
  CMD[0] = /Command
  CMD[1] = OfferNumber (OFFER_NUM) }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Verify the parameter integrity }
  try
    OfferNumber := StrToInt(CMD[OFFER_NUM]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
    Exit;
  end;

  { Attempt to get the Offer }
  _Offer := GetOffer(OfferNumber, Index);

  { Offer number does not exist }
  if not Assigned(_Offer) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NON_EXISTANT_OFFER],nil);
      Exit;
    end
  else
    begin
      if not (_Offer.Issuer = Connection) then
        begin
          fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NOT_OFFER_OWNER],nil);
          Exit;
        end;
      { All go. Remove match/seek }
      Remove(_Offer, Index);
    end;
end;
//______________________________________________________________________________
procedure TOffers.Release(const Connection: TConnection);
var
  Offer: TOffer;
  Index: Integer;
begin
  for Index := FOffers.Count -1 downto 0 do
    begin
      Offer := TOffer(FOffers[Index]);
      if (Offer.Issuer = Connection)  or (Offer.Issuee = Connection) then
         Remove(Offer, Index);
    end;
end;
//______________________________________________________________________________
procedure TOffers.RemoveOffers(const Connection: TConnection;
  const Excluding: TOffer);
var                                                                  
  Offer: TOffer;
  Index: Integer;
begin
  { Procedure to remove all the Offers that were issued by Connection.
    The Excluded Offer will is not included as it will die a different death.
    Used to remove Offers of a Connection that has reached it's Game limit via
    accepting an offer. }
  for Index := FOffers.Count -1 downto 0 do
    begin
      Offer := TOffer(FOffers[Index]);
      if (Offer.Issuer = Connection) and not (Offer = Excluding) then
        Remove(Offer, Index);
    end;
end;
//______________________________________________________________________________
procedure TOffers.SendSeeks(var Connection: TConnection);
var
  i: Integer;
  Offer: TOffer;
begin
  fSocket.Send(Connection,[DP_SEEKS_CLEAR]);
  for i := 0 to FOffers.Count -1 do begin
    Offer := TOffer(FOffers[i]);
    if Offer.OfferType = otSeek then
      Offer.SendOffer(Connection);
  end;
end;
//______________________________________________________________________________
function TOffers.OfferExists(Offer: TOffer): Boolean;
var
  i: integer;
begin
  result:=true;
  for i:=0 to FOffers.Count-1 do
    if TOffer(FOffers[i]).Equal(Offer) then
      exit;
  result:=false;
end;
//______________________________________________________________________________
function TOffers.OfferExistsByTime(p_InitTime: string; p_IncTime: integer): Boolean;
var
  i: integer;
begin
  result:=true;
  for i:=0 to FOffers.Count-1 do
    if (TOffer(FOffers[i]).InitialTime = p_InitTime) and
      (TOffer(FOffers[i]).IncTime = p_IncTime)
    then
      exit;
  result:=false;
end;
//______________________________________________________________________________
end.

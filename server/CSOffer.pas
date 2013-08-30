{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSOffer;

interface

uses
  SysUtils, CSConnection, CSConst, CLOfferOdds;

type
  TOffer = class(TObject)
  private
    { Private declarations }
    FBlack: TConnection;
    FColor: Integer;
    FGameID: Integer;
    FInitialTime: string;
    FIncTime: Integer;
    FIssuer: TConnection;
    FIssuee: TConnection;
    FMaxRating: Integer;
    FMinRating: Integer;
    FOfferNumber: Integer;
    FOfferType: TOfferType;
    FProvisional: Boolean;
    FRated: Boolean;
    FRatedType: TRatedType;
    FWhite: TConnection;
    FCReject: Boolean;
    FPReject: Boolean;
    FOdds: TOfferOdds;

  protected
    { Protected declarations }

  public
    { Public declarations }
    constructor Create(const Color: integer; InitialTime: string; IncTime, MaxRating,
      MinRating, Rated, GameID: Integer; const RatedType: TRatedType;
      var Issuer, Issuee: TConnection; const OfferType: TOfferType;
      const CReject, PReject: Boolean;
      const Odds: TOfferOdds);

    destructor Destroy; override;

    function Equal(Offer: TOffer): Boolean;
    function IsOddsGame: Boolean;
    procedure SendOffer(const p_Connection: TConnection);
    function Qualifies(const Connection: TConnection): Boolean;

    property Black: TConnection read FBlack write FBlack;
    property Color: Integer read FColor write FColor;
    property GameID: Integer read FGameID write FGameID;
    property InitialTime: string read FInitialTime;
    property IncTime: Integer read FIncTime;
    property Issuer: TConnection read FIssuer;
    property Issuee: TConnection read FIssuee;
    property MaxRating: Integer read FMaxRating;
    property MinRating: Integer read FMinRating;
    property OfferNumber: Integer read FOfferNumber;
    property OfferType: TOfferType read FOfferType;
    property Rated: Boolean read FRated;
    property RatedType: TRatedType read FRatedType;
    property Provisional: Boolean read FProvisional;
    property White: TConnection read FWhite write FWhite;
    property CReject: Boolean read FCReject write FCReject;
    property PReject: Boolean read FPReject write FPReject;
    property Odds: TOfferOdds read FOdds write FOdds;

  published
    { Published declarations }
  end;

var
  FCreatedCount: Integer;

implementation

uses CSLib, CSSocket;

//______________________________________________________________________________
constructor TOffer.Create(const Color: integer; InitialTime: string; IncTime,
  MaxRating, MinRating, Rated, GameID: Integer; const RatedType: TRatedType;
  var Issuer, Issuee: TConnection; const OfferType: TOfferType;
  const CReject, PReject: Boolean;
  const Odds: TOfferOdds);
begin
  Inc(FCreatedCount);
  FColor := Color;
  FGameID := GameID;
  FInitialTime := InitialTime;
  FIncTime := IncTime;
  FIssuer := Issuer;
  FIssuee := Issuee;
  FOfferNumber := FCreatedCount;
  FOfferType := OfferType;
  FRated := Boolean(Rated);
  if RatedType in [rtStandard, rtBlitz, rtBullet] then
    FRatedType := TimeToRatedType(InitialTime, IncTime)
  else
    FRatedType := RatedType;
  { Client sends rating difference. Server adjusts based on Issuers rating.
    Must come after the FRatedType is corrected. }
  FMaxRating := MaxRating;
  FMinRating := MinRating;
  FProvisional := Issuer.Provisional[FRatedType];
  FBlack := Issuer;
  FWhite := Issuer;
  FCReject := CReject;
  FPReject := PReject;
  if Odds = nil then FOdds := TOfferOdds.Create
  else FOdds := Odds;
end;
//______________________________________________________________________________
destructor TOffer.Destroy;
var
  Connection: TConnection;
begin
  Connection := TConnection(FIssuer);
  Connection.OfferCount := Connection.OfferCount -1;
  if Assigned(FOdds) then FOdds.Free;
  inherited Destroy;
end;
//______________________________________________________________________________
function TOffer.Equal(Offer: TOffer): Boolean;
begin
  result:=
    (FColor = Offer. Color) and
    (FGameID = Offer. GameID) and
    (FInitialTime = Offer. InitialTime) and
    (FIncTime = Offer. IncTime) and
    (FIssuer = Offer. Issuer) and
    (FIssuee = Offer. Issuee) and
    (FOfferType = Offer. OfferType) and
    (FRated = Offer.Rated) and
    (FRatedType = Offer.RatedType) and
    (FMaxRating = Offer.MaxRating) and
    (FMinRating = Offer.MinRating) and
    (FProvisional = Offer.Provisional) and
    (FBlack = Offer.Issuer) and
    (FWhite = Offer.Issuer) and
    (FCReject = Offer.CReject) and
    (FPReject = Offer.PReject) and
    FOdds.Equal(Offer.FOdds);
end;
//______________________________________________________________________________
function TOffer.IsOddsGame: Boolean;
begin
  result := FOdds.FAutoTimeOdds or FOdds.Defined;
end;
//______________________________________________________________________________
procedure TOffer.SendOffer(const p_Connection: TConnection); // nil means full list
var
  Receivers: TObject;
  Filter: TConnectionFilter;
  Command: string;
  Rating: integer;
begin
  if OfferType = otSeek then begin
    Command := DP_SEEK;
    Filter := Self.Qualifies;
  end else begin
    Command := DP_MATCH;
    Filter := nil;
  end;

  Rating := Issuer.Rating[RatedType];
  fSocket.SmartSend(p_Connection, Filter,
   [Command, IntToStr(OfferNumber),
    IntToStr(Color), InitialTime, IntToStr(IncTime),
    Issuer.Handle, Issuer.Title, IntToStr(Integer(Provisional)),
    BoolTo_(Rated, '1', '0'), IntToStr(Rating),
    IntToStr(Ord(RatedType)),
    BoolTo_(Issuer.LoseOnDisconnect,'1','0'),
    BoolTo_(Odds.FAutoTimeOdds,'1','0'),
    IntToStr(Odds.FInitMin), IntToStr(Odds.FInitSec),
    IntToStr(Odds.FInc), IntToStr(Odds.FPiece),
    IntToStr(ord(Odds.FTimeDirection)),
    IntToStr(ord(Odds.FPieceDirection))], Issuer);
end;
//______________________________________________________________________________
function TOffer.Qualifies(const Connection: TConnection): Boolean;
var
  Rating, IssuerRating: Integer;
begin
  { Checks to see if a Connection qualifies for a Seek. Matches do not apply. }
  { Initialize the result to true. Must prove otherwise. }
  Result := True;
  if (Connection = Issuer) or (Connection = Issuee) then exit;

  Rating := Connection.Rating[RatedType];
  IssuerRating := Issuer.Rating[RatedType];
  { Must fall within issuers parameters }
  if (Rating < MinRating) or (Rating > MaxRating)  then
    Result := False;
  if Odds.FAutoTimeOdds and
    ((Rating < IssuerRating - AUTOTIMEODDS_RATING_DIFF) or
     (Rating > IssuerRating + AUTOTIMEODDS_RATING_DIFF))
  then
    result := False;
  
  { Must be a member for rated games. }
  if (Rated) and (not Connection.Registered) then Result := False;

  { Send only to those whom are not censoring the Issuer }
  if Connection.NoPlay[Issuer] then result := False;
  { Send only to those that the Issuer does not censor }
  if Issuer.NoPlay[Connection] then result := False;

  if (pos('.',InitialTime)>0) and (CompareVersion(Connection.Version,'7.7h')=-1) then
    result := False;

  if (OfferType = otSeek) and IsOddsGame and (CompareVersion(Connection.Version,VERSION_ODDS)=-1) then
    result := false;
end;
//______________________________________________________________________________
initialization
begin
  FCreatedCount := 0;
end;
//______________________________________________________________________________
end.

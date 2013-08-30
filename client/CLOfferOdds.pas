unit CLOfferOdds;

interface

uses SysUtils;

type
  TOfferOddsDirection = (oodGive, oodAsk);
  TOfferOddsInitiator = (ooiNone, ooiWhite, ooiBlack);

  TOfferOdds = class
  public
    FAutoTimeOdds: Boolean;
    FInitMin: integer;
    FInitSec: integer;
    FInc: integer;
    FPiece: integer;
    FTimeDirection: TOfferOddsDirection;
    FPieceDirection: TOfferOddsDirection;
    FInitiator: TOfferOddsInitiator;
    constructor Create;
    function TimeDefined: Boolean;
    function PieceDefined: Boolean;
    function Defined: Boolean;
    function InitSec: integer;
    function InitMSec: integer;
    function IncMSec: integer;
    function InitTimeToMinSec: string;
    function FullTimeToMinSec: string;
    function Equal(Odds: TOfferOdds): Boolean;
    procedure CopyFrom(Odds: TOfferOdds);
  end;


implementation

{ TOfferOdds }
//==============================================================================
procedure TOfferOdds.CopyFrom(Odds: TOfferOdds);
begin
  FAutoTimeOdds := Odds.FAutoTimeOdds;
  FInitMin := Odds.FInitMin;
  FInitSec := Odds.FInitSec;
  FInc := Odds.FInc;
  FPiece := Odds.FPiece;
  FTimeDirection := Odds.FTimeDirection;
  FPieceDirection := Odds.FPieceDirection;
  FInitiator := Odds.FInitiator;
end;
//==============================================================================
constructor TOfferOdds.Create;
begin
  FAutoTimeOdds := false;
  FInitMin := -1;
  FInitSec := -1;
  FInc := -1;
  FPiece := -1;
  FTimeDirection := oodGive;
  FPieceDirection := oodGive;
  FInitiator := ooiNone;
end;
//==============================================================================
function TOfferOdds.Defined: Boolean;
begin
  result := TimeDefined or PieceDefined;
end;
//==============================================================================
function TOfferOdds.Equal(Odds: TOfferOdds): Boolean;
begin
  result := (FInitMin = Odds.FInitMin)
    and (FInitSec = Odds.FInitSec)
    and (FInc = Odds.FInc)
    and (FPiece = Odds.FPiece)
    and (FTimeDirection = Odds.FTimeDirection)
    and (FPieceDirection = Odds.FPieceDirection);
end;
//==============================================================================
function TOfferOdds.FullTimeToMinSec: string;
begin
  result := InitTimeToMinSec + ' + ' + IntToStr(FInc) + ' sec per move';
end;
//==============================================================================
function TOfferOdds.IncMSec: integer;
begin
  result := FInc * 1000;
end;
//==============================================================================
function TOfferOdds.InitMSec: integer;
begin
  result := 1000 * InitSec;
end;
//==============================================================================
function TOfferOdds.InitSec: integer;
begin
  result := (FInitMin * 60 + FInitSec);
end;
//==============================================================================
function TOfferOdds.InitTimeToMinSec: string;
begin
  if FInitMin = -1 then result := ''
  else begin
    result := IntToStr(FInitMin)+' min';
    if FInitSec <> 0 then
      result := result + ' ' + IntToStr(FInitSec) + ' sec';
  end;
end;
//==============================================================================
function TOfferOdds.PieceDefined: Boolean;
begin
  result := FPiece <> -1;
end;
//==============================================================================
function TOfferOdds.TimeDefined: Boolean;
begin
  result := FInitMin <> -1;
end;
//==============================================================================

end.

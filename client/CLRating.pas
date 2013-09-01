{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}


unit CLRating;

interface

uses Math, contnrs, SysUtils;

type
  TTimeOddsLimit = class
    FInitTime: integer; // all time in seconds
    FIncTime: integer;
    FMinInitTime: integer;
    FMinIncTime: integer;
    FMaxScoreDeviation: integer;
    FScoreDeviationStart: integer;
    FScoreDeviationEnd: integer;
  end;

  TTimeOddsLimits = class(TObjectList)
  public
    procedure AddLimit(InitTime, IncTime, MinInitTime, MinIncTime,
      MaxScoreDeviation,ScoreDeviationStart,ScoreDeviationEnd: integer);
    function GetLimit(InitTime, IncTime: integer): TTimeOddsLimit;
    function GetMessageList: string;
  end;

procedure CountNotProvRatingICC(R1, R2, G2: integer; P2: Boolean; var W, D, L: integer);
procedure CountProvRatingICC(R1, G1, R2: integer; var W, D, L: integer);
procedure CountRatingsICC(
  R1, R2, G1, G2: integer; // ratings and number of games played by 1 and 2 players
  P1, P2: Boolean; // provisional factors of 1 and 2 players
  var pp_Win1, pp_Draw1, pp_Lost1: integer; // rating changes for 1 player if 1 player wins, draws or losses
  var pp_Win2, pp_Draw2, pp_Lost2: integer // rating changes for 2 player if 1 player wins, draws or losses
);
procedure CountTimeOdds(InitTime {seconds}, IncTime, R1, R2: integer;
  var pp_InitTime, pp_IncTime, pp_ScoreDeviation: integer
);

var
  fTimeOddsLimits: TTimeOddsLimits;

implementation

//============================================================================
procedure CountProvRatingICC(R1, G1, R2: integer; var W, D, L: integer);
  //**************************************************************************
  function f(N: integer): integer;
  begin
    result := Round((R1*G1*1.0+R2+N)/(G1+1)) - R1;
  end;
  //**************************************************************************
begin
  W := f(400);
  D := f(0);
  L := f(-400);
end;
//============================================================================
procedure CountNotProvRatingICC(R1, R2, G2: integer; P2: Boolean; var W, D, L: integer);
var
  K: real;
  //**************************************************************************
  function f(N: real): integer;
  begin
    result := Round( K * (N - (1 / (1 + power(10, (R2 - R1)/400)))));
  end;
  //**************************************************************************
begin
  if P2 then K := 32 * G2 / 20.0
  else K := 32.0;

  W := f(1);
  D := f(0.5);
  L := f(0);
end;
//============================================================================
procedure CountRatingsICC(
  R1, R2, G1, G2: integer; // ratings and number of games played by 1 and 2 players
  P1, P2: Boolean; // provisional factors of 1 and 2 players
  var pp_Win1, pp_Draw1, pp_Lost1: integer; // rating changes for 1 player if 1 player wins, draws or losses
  var pp_Win2, pp_Draw2, pp_Lost2: integer // rating changes for 2 player if 1 player wins, draws or losses
);
var
  W, D, L: integer;
begin
  if P1 then CountProvRatingICC(R1, G1, R2, pp_Win1, pp_Draw1, pp_Lost1)
  else CountNotProvRatingICC(R1, R2, G2, P2, pp_Win1, pp_Draw1, pp_Lost1);

  if P2 then CountProvRatingICC(R2, G2, R1, pp_Win2, pp_Draw2, pp_Lost2)
  else CountNotProvRatingICC(R2, R1, G1, P1, pp_Win2, pp_Draw2, pp_Lost2);
end;
//============================================================================
{ TTimeOddsLimits }

procedure TTimeOddsLimits.AddLimit(InitTime, IncTime, MinInitTime, MinIncTime,
  MaxScoreDeviation,ScoreDeviationStart,ScoreDeviationEnd: integer);
var
  L: TTimeOddsLimit;
begin
  L := TTimeOddsLimit.Create;
  L.FInitTime := InitTime;
  L.FIncTime := IncTime;
  L.FMinInitTime := MinInitTime;
  L.FMinIncTime := MinIncTime;
  L.FMaxScoreDeviation := MaxScoreDeviation;
  L.FScoreDeviationStart := ScoreDeviationStart;
  L.FScoreDeviationEnd := ScoreDeviationEnd;
  Add(L);
end;
//============================================================================
function TTimeOddsLimits.GetLimit(InitTime, IncTime: integer): TTimeOddsLimit;
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := TTimeOddsLimit(Items[i]);
    if (result.FInitTime = InitTime) and (result.FIncTime = IncTime) then
      exit;
  end;
  result := nil;
end;
//============================================================================
function TTimeOddsLimits.GetMessageList: string;
var
  i: integer;
  L: TTimeOddsLimit;
begin
  result := '';
  for i := 0 to Count - 1 do begin
    L := TTimeOddsLimit(Items[i]);
    result := result + Format('%d+%d; ',[L.FInitTime div 60, L.FIncTime]);
  end;
end;
//============================================================================
procedure CountTimeOdds(InitTime {seconds}, IncTime, R1, R2: integer;
  var pp_InitTime, pp_IncTime, pp_ScoreDeviation: integer
);
var
  W, D, L, factor, diff: integer;
  Limit: TTimeOddsLimit;
begin
  CountNotProvRatingICC(R1, R2, 20, false, W, D, L);
  Limit := fTimeOddsLimits.GetLimit(InitTime, IncTime);
  if Limit = nil then raise exception.create('CLRating.CountTimeOdds: unknown game type '+
    IntToStr(InitTime)+'-'+IntToStr(IncTime));

  factor := abs(W-16);

  pp_InitTime :=  InitTime - Round(factor * (InitTime - Limit.FMinInitTime) / 16.0);
  pp_IncTime := IncTime - Round(factor * (IncTime - Limit.FMinIncTIme) / 16.0);

  diff := abs(R1-R2);
  if diff < Limit.FScoreDeviationStart then pp_ScoreDeviation := 0
  else if diff > Limit.FScoreDeviationEnd then pp_ScoreDeviation := Limit.FMaxScoreDeviation
  else pp_ScoreDeviation := Round(1.0 * Limit.FMaxScoreDeviation * diff / (Limit.FScoreDeviationEnd - Limit.FScoreDeviationStart));
end;
//============================================================================

initialization
  fTimeOddsLimits := TTimeOddsLimits.Create;

finalization
  fTimeOddsLimits.Free;

end.

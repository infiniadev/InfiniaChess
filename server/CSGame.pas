{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSGame;

interface

uses
  SysUtils, Classes, contnrs, ExtCtrls, CSConnection, CSConnections, CSOffer, CSConst, CSEvent, CLOfferOdds;

type
  TCheatMode = (chmGreen, chmYellow, chmRed);
  TGameMode = (gmLive, gmExamined);
  TGameRule = (grLoser, grPlunk);
  { Any changes to the the TGameResult type must be reflected in the
    GameResultTypes table of the CLServer DB. }
  TGameResult = (grNone, grAborted, grAdjourned, grDraw,
    grWhiteResigns, grBlackResigns, grWhiteCheckMated, grBlackCheckMated,
    grWhiteStaleMated, grBlackStaleMated,
    grWhiteForfeitsOnTime, grBlackForfeitsOnTime,
    grWhiteForfeitsOnNetwork, grBlackForfeitsOnNetwork);
{
00: grNone,
01: grAborted,
02: grAdjourned,
03: grDraw,
04: grWhiteResigns,
05: grBlackResigns,
06: grWhiteCheckMated,
07: grBlackCheckMated,
08: grWhiteStaleMated,
09: grBlackStaleMated,
10: grWhiteForfeitsOnTime,
11: grBlackForfeitsOnTime,
12: grWhiteForfeitsOnNetwork,
13: grBlackForfeitsOnNetwork
}
  TGameScore = (gsWhiteWin,gsBlackWin,gsDraw,gsNone);
  TMoveStatus = (msNone, msCheck, msCheckMate, msDraw, msStaleMate);
  TMoveType = (mtIllegal, mtNormal, mtCastleK, mtCastleQ, mtEnpassant,
    mtPawnPush, mtPlunk, mtPromotion);
  TPosition = array[0..78] of ShortInt; { Position 0..63, Enpassant 64, Castling 65(1+2+4+8), Captured 66..77,	Color 78, NRM 79, Repeated 80 }

  TMove = class
    FPosition: TPosition;
    FColor: ShortInt;
    FRM: Byte;
    FRP: Byte;
    FFrom: Byte;
    FTo: Byte;
    FType: TMoveType;
    FMSec: Integer; { MSecs of time remaining after clock adjustment }
    FMSec2: Integer; { MSecs used to make the move }
    FPGN: string;
  private
    FEngineFormat: string;
    function GetPromo: integer;
    function GetEngineFormat: string;
  public
    class function CoordNum2Str(p_NumMove: integer): string;
    class function CoordStr2Num(p_StrMove: string): Byte;
    class function PromoNum2Str(p_NumPromo: integer): string;
    class function PromoStr2Num(p_StrPromo: char): Byte;
    class function GetMoveType(p_Position: TPosition; p_From, p_To: Byte): TMoveType;

    procedure Assign(const Move: TMove);
    property EngineFormat: string read GetEngineFormat;
    property Promo: integer read GetPromo;
  end;

  TRooks = record
    BKS: Integer;
    BQS: Integer;
    WKS: Integer;
    WQS: Integer;
  end;

  TLegalMove = class
    FFrom: Integer;
    FTo: Integer;
    FType: TMoveType;
  end;

  TCustList = class(TList)
    procedure DeleteFrom(const Value: Integer);
    procedure DeleteOnly(const Value: Integer);
    procedure Free;
  end;

  TPersonalScore = record
    Win,Lost,Draw: integer;
    Defined: Boolean;
  end;

  {TGameOdds = class
    WhiteInitTime,WhiteIncTime: integer;
    BlackInitTime,BlackIncTime: integer;
    FEN: string;
  end;}

  TGame = class(TObject)
    private
      { Private declarations }
      FAlliedMM: Boolean; { Sufficent mating material for the color to move? }
      FAttacked: TList; { All squares between the king and attacker (inclusive of the attacker) }
      FBlack: TConnection;
      FBlackLogin: string;
      FBlackMSec: Integer;
      FBlackRating: Integer;
      FBlackTitle: string;
      FCanAbort: Boolean;
      FColor: Integer; { Color of side to move; 1 = white -1 = black }
      FConnections: TConnectionList;
      FCRAbort: TConnection;
      FCRAdjourn: TConnection;
      FCRDraw: TConnection;
      FCRMoretime: TConnection;
      FCRTakeback: TConnection;
      FDate: string;
      FEnemyMM: Boolean; { Sufficent mating material for the color not moving? }
      FEvent: string;
      FFEN: string;
      FFlagTS: TDateTime;
      FGameNumber: Integer; { CLS game number }
      FGameMode: TGameMode;
      FGameResult: TGameResult;
      FGameRules: set of TGameRule;
      //FIncMSec: Integer;
      //FInitialMSec: Integer;
      FWhiteIncMSec: integer;
      FWhiteInitialMSec: integer;
      FBlackIncMSec: integer;
      FBlackInitialMSec: integer;
      FLastMoveTS: TDateTime;
      FWhiteLastMoveTS: TDateTime;
      FBlackLastMoveTS: TDateTime;
      FLegalMoves: TCustList; { List of TLegalMove(s) for move number requested }
      FLocked: Boolean;
      FMainLine: TCustList;
      FMainLineMoveNumber: Integer;
      FMoreTime: Integer;
      FMoves: TCustList;
      FMoveNumber: Integer; { Move number for the current position }
      FMoveStatus: TMoveStatus;
      FMoveTotal: Integer; { Number of half moves in a game }
      FOnResult: TNotifyEvent;
      FPGMN: Integer;
      FRated: Boolean;
      FRatedType: TRatedType;
      FRooks: TRooks;
      FRound: Integer;
      FSite: string;
      FTakebackCount: Integer;
      FWhite: TConnection;
      FWhiteLogin: string;
      FWhiteMSec: Integer;
      FWhiteRating: Integer;
      FWhiteTitle: string;
      FBlackSwitched: integer;
      FWhiteSwitched: integer;
      FWhiteCheatSaved: Boolean;
      FBlackCheatSaved: Boolean;
      FWhiteJustSwitched: Boolean;
      FBlackJustSwitched: Boolean;
      FEventId: integer;
      FEventOrdNum: integer;
      FSavedInDb: Boolean;
      FPlayerDisconnected: Boolean;
      FWhiteId: integer;
      FBlackId: integer;
      FBlackDisconnectTime: TDateTime;
      FWhiteDisconnectTime: TDateTime;
      FScore: TPersonalScore;
      FDbGameId: integer;
      FOdds: TOfferOdds;
      FEndTime: TDateTime;
      FStartTime: TDateTime;
      FTimeOddsScoreDeviation: integer;
      FDisconnectChoiseSuggested: Boolean;

      class function PieceValue(const Piece: Char): Integer;

      procedure AddAttacked(const King, Dirc, Dist: Integer);
      procedure AddMove(const From, _To: Integer;
        const MoveType: TMoveType); overload;
      procedure BuildFEN(const Move: TMove);
      procedure CopyMoves(var Src, Dest: TCustList);
      procedure CopyMainLine;
      procedure FischerRandomize;
      procedure GenerateMoves(const MoveNumber: Integer);
      procedure GeneratePGN(const MoveNumber: Integer);
      function  GetKing(const Position: TPosition;
        const Color: Integer): Integer;
      function  InCheck(const Position: TPosition; const Color, King: Integer;
        const BuildAttackList: Boolean): Integer;
      function  IsLegal(const From, _To: Integer;
        const MoveType: TMoveType): Boolean;
      procedure Reset;
      procedure SetFEN(const Value: string);
      procedure SetGameResult(const Value: TGameResult);
      procedure SetMoreTime(const Value: Integer);
      procedure SetTakeBackCount(const Value: Integer);
      function GetRealGameResult: integer;
      function CountCheatMode(Switched: integer; Title: string; JustSwitched,HiddenCompAccount: Boolean): TCheatMode;
      function GetWhiteCheatMode: TCheatMode;
      function GetBlackCheatMode: TCheatMode;
      function GetConnections: TConnectionList;
      procedure SetRatedType(const Value: TRatedType);
    public
      { Public declarations }
      constructor Create(var Offer: TOffer); overload;
      constructor Create(Connection: TConnection; WL,WT: string; WR: integer; BL,BT: string; BR: integer); overload;
      constructor Create; overload;
      constructor Create(connWhite,connBlack: TConnection); overload;
      constructor Create(EV: TCSEvent; Num: integer; LeaderWhite: Boolean); overload;
      destructor Destroy; override;

      procedure DefineGameTime(Offer: TOffer);
      function AddMove(const From, _To, Promotion: Integer;
        const MoveType: TMoveType; const PGN: string;
        const MSEC: Integer): TMove; overload;
      {procedure AddPGN(const PGN: string);}
      procedure GetMSec(var _WhiteMSec, _BlackMSec: Integer);
      procedure GoBackward(const Value: Integer);
      procedure GoForward(const Value: Integer);
      procedure MoveTo(MoveNumber: Integer);
      procedure Revert;
      procedure TakeBack(Value: Integer);
      procedure ShoutIfTitled;
      procedure MakeDisconnectChoise(Connection: TConnection);
      function Involved(Connection: TConnection): Boolean;
      procedure AddConnection(Connection: TConnection);
      procedure SendGameScore(Connection: TConnection);
      procedure SetGameScore;
      procedure SendMoveToEngine(p_Move: TMove);

      property Black: TConnection read FBlack write FBlack;
      property BlackCheatMode: TCheatMode read GetBlackCheatMode;
      property BlackCheatSaved: Boolean read FBlackCheatSaved write FBlackCheatSaved;
      property BlackId: integer read FBlackId write FBlackId;
      property BlackLogin: string read FBlackLogin write FBlackLogin;
      property BlackMSec: Integer read FBlackMSec write FBlackMSec;
      property BlackRating: Integer read FBlackRating write FBlackRating;
      property BlackSwitched: integer read FBlackSwitched write FBlackSwitched;
      property BlackTitle: string read FBlackTitle write FBlackTitle;
      property CanAbort: Boolean read FCanAbort write FCanAbort;
      property Color: Integer read FColor;
      property Connections: TConnectionList read GetConnections;
      property RealConnections: TConnectionList read FConnections;
      property CRAbort: TConnection read FCRAbort write FCRAbort;
      property CRAdjourn: TConnection read FCRAdjourn write FCRAdjourn;
      property CRDraw: TConnection read FCRDraw write FCRDraw;
      property CRMoretime: TConnection read FCRMoretime write FCRMoretime;
      property CRTakeback: TConnection read FCRTakeback write FCRTakeback;
      property Date: string read FDate write FDate;
      property FEN: string read FFEN write SetFEN;
      property Event: string read FEvent write FEvent;
      property FlagTS: TDateTime read FFlagTS write FFlagTS;
      property GameMode: TGameMode read FGameMode write FGameMode;
      property GameNumber: Integer read FGameNumber;
      property GameResult: TGameResult read FGameResult write SetGameResult;
      property RealGameResult: integer read GetRealGameResult;
      property Moves: TCustList read FMoves;
      //property IncMSec: Integer read FIncMSec write FIncMSec;
      //property InitialMSec: Integer read FInitialMSec write FInitialMSec;
      property WhiteIncMSec: integer read FWhiteIncMSec write FWhiteIncMSec;
      property WhiteInitialMSec: integer read FWhiteInitialMSec write FWhiteInitialMSec;
      property BlackIncMSec: integer read FBlackIncMSec write FBlackIncMSec;
      property BlackInitialMSec: integer read FBlackInitialMSec write FBlackInitialMSec;
      property Locked: Boolean read FLocked write FLocked;
      property MainLineMoveNumber: Integer read FMainLineMoveNumber;
      property MoreTime: Integer read FMoreTime write SetMoreTime;
      property MoveNumber: Integer read FMoveNumber;
      property Rated: Boolean read FRated write FRated;
      property RatedType: TRatedType read FRatedType write SetRatedType;
      property Round: Integer read FRound write FRound;
      procedure SaveWhiteCheat;
      procedure SaveBlackCheat;
      property Site: string read FSite write FSite;
      property TakebackCount: Integer read FTakebackCount write SetTakebackCount;
      property White: TConnection read FWhite write FWhite;
      property WhiteCheatMode: TCheatMode read GetWhiteCheatMode;
      property WhiteCheatSaved: Boolean read FWhiteCheatSaved write FWhiteCheatSaved;
      property WhiteId: integer read FWhiteId write FWhiteId;
      property WhiteLogin: string read FWhiteLogin write FWhiteLogin;
      property WhiteMSec: Integer read FWhiteMSec write FWhiteMSec;
      property WhiteRating: Integer read FWhiteRating write FWhiteRating;
      property WhiteSwitched: integer read FWhiteSwitched write FWhiteSwitched;
      property WhiteTitle: string read FWhiteTitle write FWhiteTitle;
      property WhiteJustSwitched: Boolean read FWhiteJustSwitched write FWhiteJustSwitched;
      property BlackJustSwitched: Boolean read FBlackJustSwitched write FBlackJustSwitched;
      property EventID: integer read FEventId write FEventId;
      property EventOrdNum: integer read FEventOrdNum write FEventOrdNum;
      property SavedInDb: Boolean read FSavedInDb write FSavedInDb;
      property WhiteDisconnectTime: TDateTime read FWhiteDisconnectTime write FWhiteDisconnectTime;
      property BlackDisconnectTime: TDateTime read FBlackDisconnectTime write FBlackDisconnectTime;
      //property Odds: TGameOdds read FOdds write FOdds;

      property OnResult: TNotifyEvent read FOnResult write FOnResult;
      property PlayerDisconnected: Boolean read FPlayerDisconnected write FPlayerDisconnected;
      property Score: TPersonalScore read FScore write FScore;
      property DbGameId: integer read FDbGameId write FDbGameId;
      property Odds: TOfferOdds read FOdds write FOdds;
      property StartTime: TDateTime read FStartTime write FStartTime;
      property EndTime: TDateTime read FEndTime write FEndTime;
      property TimeOddsScoreDeviation: integer read FTimeOddsScoreDeviation;
      property LastMoveTS: TDateTime read FLastMoveTS;
      property WhiteLastMoveTS: TDateTime read FWhiteLastMoveTS;
      property BlackLastMoveTS: TDateTime read FBlackLastMoveTS;
      property MoveTotal: integer read FMoveTotal;
      property DisconnectChoiseSuggested: Boolean read FDisconnectChoiseSuggested write FDisconnectChoiseSuggested;
    end;

function FRToSqr(const _File, Rank: Char): Integer;
function SqrToFR(const Square: Integer): string; overload
function XYToSqr(const X, Y: Integer): Integer;
procedure SqrToFR(const Square: Integer; var _File, Rank: Char); overload
procedure SqrToXY(const Square: Integer; var X, Y: Integer);

const
  { Black (in some cases 'enemy', even if I'm black) pieces }
  BLK = -1; BK = -6; BQ = -5; BR = -4; BB = -3; BN = -2; BP = -1;
   { White (in some cases 'friendly', even if I'm black) pieces }
  WHT = 1; WK = 6; WQ = 5; WR = 4; WB = 3; WN = 2; WP = 1;

  BOARD_MAX = 63; { Upper bound of the TPosition array for the actual board }
  DETACHED_GAME: Integer = -1;
  FILES: array[0..7] of char = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h');
  RANKS: array[0..7] of char = ('1', '2', '3', '4', '5', '6', '7', '8');
  EMPTY = 0;
  PIECE_SYMBOL: array[-6..6] of char = ('k', 'q', 'r', 'b', 'n', 'p', 'X', 'P', 'N', 'B', 'R', 'Q', 'K');
  REVERSE_COLOR = -1;
  SPR = 8; { Squares Per Row of a chessboard }

  { The KEY to it all. Understand this array before attempting understand any
    of the code!! It was designed as such so that MemoryCompares could be used
    to determine repeating postions for draws.
    Position 0..63; Each position is a square on the board. The value is the piece value.
    Enpassant 64; This position holds the square that had a double pawn push for the move. -1 if none.
    Castling Rights 65; 4 bits(bq=1 + bk=2 + wq=4 + wk=8 ).
    Black Pieces Captured 66..71 [-6,-5,-4,-3,-2,-1]; The POSITION is the PIECE. The VALUE is how MANY pieces.
    Empty (used for X@?) 72; Empty for now. Used in some calcs.
    White Pieces Captured 73..78 [ 1, 2, 3, 4, 5, 6]; The POSITION is the PIECE. The Value is how MANY pieces. }
  STARTING_POSITION: TPosition = (
    -4, -2, -3, -5, -6, -3, -2, -4,
    -1, -1, -1, -1, -1, -1, -1, -1,
    0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,
    1,  1,  1,  1,  1,  1,  1,  1,
    4,  2,  3,  5,  6,  3,  2,  4,
    -1,
    15,
    0, 0, 0, 0, 0, 0,
    0,
    0, 0, 0, 0, 0, 0);

  { Absolute piece value relates to VECTOR_A, VECTOR_B and VECTOR_SCOPE
    positions. These array values are the array position of VECTOR, VECTOR_X
    and VECTOR_Y. Example: piece value 3 (Bishop) moves in directions -7 to -9
    and a distance of 8 squares in each direction. These are all used in looping
    though possible moves. }
  VECTOR_A: array[1..6] of Integer = (0, 9, 5, 1, 1, 1);
  VECTOR_B: array[1..6] of Integer = (0, 16, 8, 4, 8, 8);
  VECTOR_SCOPE: array[1..6] of Integer = (0, 1, 8, 8, 8, 1);
  { Three sets of 4 vectors. N, E, S, W, NE, SE, SW, NW, and Knight directions }
  VECTOR: array[1..16] of Integer = (-8, 1, 8, -1, -7, 9, 7, -9,
    -15, -6, 10, 17, 15, 6, -10, -17);
  VECTOR_X: array[1..16] of Integer = (0, 1, 0, -1, 1, 1, -1, -1,
    1, 2, 2, 1, -1, -2, -2, -1  );
  VECTOR_Y: array[1..16] of Integer = (-1, 0, 1, 0, -1, 1, 1, -1,
    -2, -1, 1, 2, 2, 1, -1, -2);
  { Number of 1/2 moves that may be made and still automatically abort }
  ABORT_LIMIT = 5;

  function GameScoreByResult(GameResult: TGameResult): TGameScore;

implementation

uses CSDb,CSEvents,CSGames,CSLib, CSSocket, CLRating;

var
  FCreatedCount: Integer;

//______________________________________________________________________________
function FRToSqr(const _File, Rank: Char): Integer;
var
  E: Integer;
begin
  Val(Rank, Result, E);
  if E = 0 then
    Result := (SPR - Result) * SPR + (Ord(_File) - 97)
  else
    Result := -1;
end;
//______________________________________________________________________________
function SqrToFR(const Square: Integer): string; overload
var
  X, Y: Integer;
begin
  Result := '-';
  SqrToXY(Square, X, Y);
  if (X > -1) then
    begin
      Y := 7 - Y; { Convert to a1 based (see SqrToXY) }
      Result := FILES[X] + RANKS[Y];
    end;
end;
//______________________________________________________________________________
function XYToSqr(const X, Y: Integer): Integer;
begin
  Result := Y * SPR + X;
end;
//______________________________________________________________________________
procedure SqrToFR(const Square: Integer; var _File, Rank: Char);
var
  X, Y: Integer;
begin
  SqrToXY(Square, X, Y);
  Y := 7 - Y; { Convert to a1 based (see SqrToXY) }
  _File := FILES[X];
  Rank := RANKS[Y];
end;
//______________________________________________________________________________
procedure SqrToXY(const Square: Integer; var X, Y: Integer);
begin
  { Given an TPosition array position (square param), calculate the X & Y
    square. X & Y are zero based and referenced from a8 }
  if Square <= BOARD_MAX then
    begin
      Y := Square div SPR;
      X := Square - (Y * SPR);
    end
  else
    { If square is in the captured part of the Position array, then X & Y
      are in reference to the "capture" area, not the "chessboard". }
    begin
      if Square > 72 then X := 0 else X := 1;
      Y := Abs(Square - 72);
    end;
end;
//______________________________________________________________________________
procedure TMove.Assign(const Move: TMove);
begin
  { Copies a move }
  with Self do
    begin
      FPosition := Move.FPosition;
      FColor:= Move.FColor;
      FRM := Move.FRM;
      FRP := Move.FRP;
      FFrom := Move.FFrom;
      FTo := Move.FTo;
      FType := Move.FType;
      FMSec := Move.FMSec;
      FMSec2 := Move.FMSec2;
      FPGN := Move.FPGN;
    end;
end;
//______________________________________________________________________________
procedure TCustList.DeleteFrom(const Value: Integer);
begin
  while Self.Count > Value do
    begin
      TObject(Self[Value]).Free;
      Self.Delete(Value);
    end;
end;
//______________________________________________________________________________
procedure TCustList.DeleteOnly(const Value: Integer);
begin
  if (Value > -1) and (Value <= Self.Count) then
    begin
      TObject(Self[Value]).Free;
      Self.Delete(Value);
    end;
end;
//______________________________________________________________________________
procedure TCustList.Free;
begin
  if Assigned(Self) then Self.DeleteFrom(0);
  inherited;
end;
//______________________________________________________________________________
class function TGame.PieceValue(const Piece: Char): Integer;
begin
  case Piece of
    'K': Result := WK;
    'Q': Result := WQ;
    'B': Result := WB;
    'N': Result := WN;
    'R': Result := WR;
    'P': Result := WP;
    'k': Result := BK;
    'q': Result := BQ;
    'b': Result := BB;
    'n': Result := BN;
    'r': Result := BR;
    'p': Result := BP;
    '-': Result := EMPTY;
    'X': Result := EMPTY;
  else
    Result := EMPTY;
  end;
end;
//______________________________________________________________________________
procedure TGame.AddAttacked(const King, Dirc, Dist: Integer);
begin
  FAttacked.Add(Pointer(King + VECTOR[Dirc] * Dist));
end;
//______________________________________________________________________________
procedure TGame.AddMove(const From, _To: Integer; const MoveType: TMoveType);
var
  Move: TLegalMove;
begin
  { Add move to list of possible but not necessarily legal moves }
  Move := TLegalMove.Create;
  with Move do
    begin
      FFrom := From;
      FTo := _To;
      FType := MoveType;
    end;
  FLegalMoves.Add(Move);
end;
//______________________________________________________________________________
procedure TGame.BuildFEN(const Move: TMove);
var
  Index, Spaces: Integer;
begin
  FFEN := '';
  Spaces := 0;
  { The board portion }
  for Index := Low(Move.FPosition) to BOARD_MAX do
    begin
      { Row contents }
      case Move.FPosition[Index] of
        EMPTY:
          Inc(Spaces);
        BK..BP, WP..WK:
          begin
            if Spaces > 0 then FFEN := FFEN + IntToStr(Spaces);
            Spaces := 0;
            FFEN := FFEN + PIECE_SYMBOL[Move.FPosition[Index]];
          end;
      end;
      { End of row. }
      if ((Index + 1) mod SPR) = 0 then
        begin
          if Spaces > 0 then FFEN := FFEN + IntToStr(Spaces);
          Spaces := 0;
          if Index < BOARD_MAX then FFEN := FFEN + '/';
        end;
    end;
   FFEN := FFEN + #32;

   if Move.FColor = WHT then
    FFEN := FFEN + 'b'
   else
    FFEN := FFEN + 'w';
   FFEN := FFEN + #32;
  { Castle rights }
  if Move.FPosition[65] and 8 = 8 then FFEN := FFEN + PIECE_SYMBOL[WK];
  if Move.FPosition[65] and 4 = 4 then FFEN := FFEN + PIECE_SYMBOL[WQ];
  if Move.FPosition[65] and 2 = 2 then FFEN := FFEN + PIECE_SYMBOL[BK];
  if Move.FPosition[65] and 1 = 1 then FFEN := FFEN + PIECE_SYMBOL[BQ];
  if Move.FPosition[65] = 0 then FFEN := FFEN + '-';
  FFEN := FFEN + #32;
  { Enpassant }
  FFEN := FFEN + SqrToFR(Move.FPosition[64]);
  FFEN := FFEN + #32;
  { Half Moves }
  FFEN := FFEN + IntToStr(Move.FRM);
  FFEN := FFEN + #32;
  { Move Number }
  FFEN := FFEN + '1';
end;
//______________________________________________________________________________
procedure TGame.CopyMainLine;
begin
  { Can only have one main line }
  if Assigned(FMainLine) then Exit;
  FMainLine := TCustList.Create;
  CopyMoves(FMoves, FMainLine);
  FMainLineMoveNumber := FMoveNumber;
end;
//______________________________________________________________________________
procedure TGame.CopyMoves(var Src, Dest: TCustList);
var
  SrcMove, DestMove: TMove;
  Index: Integer;
begin
  { Copies all the TMoves from the Src list to the Dest list.
    Used to copy to/from a MainLine or make a copy of the game. }
  Dest.DeleteFrom(0);
  for Index := 0 to Src.Count - 1 do
    begin
      SrcMove := TMove(Src[Index]);
      DestMove := TMove.Create;
      DestMove.Assign(SrcMove);
      Dest.Add(DestMove);
    end;
end;
//______________________________________________________________________________
procedure TGame.FischerRandomize;
var
  Position: ^TPosition;
  Index, Piece: Integer;
begin
  { Only call in CreateGame before GenerateMoves!!! }
  Position := @TMove(FMoves[0]).FPosition;
  { Clear the back row }
  for Index := 0 to 7 do Position[Index] := 0;
  Randomize;
  { Set the king }
  repeat Piece := Random(7); until Piece > 0;
  Position[Piece] := BK;
  { Set the Queenside rook }
  Index := Random(Piece);
  Position[Index] := BR;
  FRooks.BQS := Index;
  { Set the Kingside rook }
  repeat Index := Random(8); until Index > Piece;
  Position[Index] := BR;
  FRooks.BKS := Index;
  { Set a bishop }
  repeat Piece := Random(8); until Position[Piece] = 0;
  Position[Piece] := BB;
  { Set the other bishop on an opposite color }
  if Odd(Piece) then
    repeat Index := Random(8); until (Position[Index] = 0) and not Odd(Index)
  else
    repeat Index := Random(8); until (Position[Index] = 0) and Odd(Index);
  Position[Index] := BB;
  { Set the Queen }
  repeat Index := Random(8); until (Position[Index] = 0);
  Position[Index] := BQ;
  { The last two positions are for knights. }
  for Index := 0 to 7 do if Position[Index] = 0 then Position[Index] := BN;
  { Mirror the Position for White }
  for Index := 0 to 7 do Position[Index +56] := Position[Index] * REVERSE_COLOR;
  FRooks.WQS := FRooks.BQS + 56;
  FRooks.WKS := FRooks.BKS + 56;

  BuildFEN(FMoves[0]);
end;
//______________________________________________________________________________
procedure TGame.GenerateMoves(const MoveNumber: Integer);
var
  LegalMove: TLegalMove;
  Move: TMove;
  MoveType: TMoveType;
  Position: TPosition;
  AMM, EMM, Color, Enpassant, NumberOfChecks: Integer;
  X, Y, Dirc, Dist, From, _To, King: Integer;
label
  KingSide, Plunks;
begin
  { Note that the constants for white represent allies and black represent
    enemies, regardless of which color we're generating moves. }

  { Safety check to ensure that this routine is not executed uneccessarily. }
  if (MoveNumber = FPGMN) and not (MoveNumber = 0) then Exit;
  FPGMN := MoveNumber;

  Move := TMove(FMoves[MoveNumber]);
  Position := Move.FPosition;
  Color := Move.FColor * REVERSE_COLOR;
  Enpassant := Position[64];
  King := GetKing(Position, Color);

  { Clear previous legal moves. }
  FLegalMoves.DeleteFrom(0);

  { Build the Attacked List. }
  NumberOfChecks := InCheck(Position, Color, King, True);

  { Must prove sufficent mating material }
  FAlliedMM := False;
  FEnemyMM := False;
  { These hold the first knight or bishop found. Additional finds determine
    if a side has sufficent mating material. }
  AMM := 0;
  EMM := 0;

  { Generate the Move List }
  for From := Low(Position) to BOARD_MAX do
    case Position[From] * Color of
      WP:
        begin
          FAlliedMM := True;
          { ??? if NumberOfChecks >= 2 Continue - Seems like overkill. }
          { Get Rank and File }
          SqrToXY(From, X, Y);
          if ((Color = WHT) and (Y = 1)) or ((Color = BLK) and (Y = 6)) then
            MoveType := mtPromotion else MoveType := mtNormal;
          { Single and double pawn pushes }
          if Position[From - (SPR * Color)] = 0 then
            begin
              AddMove(From, From - (SPR * Color), MoveType);
              if (((Color = WHT) and (Y = 6)) or ((Color = BLK) and (Y = 1)))
              and (Position[From - (16 * Color)] = 0) then
                AddMove(From, From - (16 * Color), mtPawnPush);
            end;

          { Pawn captures }
          if (X - 1 > -1)
          and (Position[From - (8 * Color) - 1] * Color < EMPTY) then
            AddMove(From, From - (8 * Color) - 1, MoveType);
          if (X + 1 < 8)
          and (Position[From - (8 * Color) + 1] * Color < EMPTY) then
            AddMove(From, From - (8 * Color) + 1, MoveType);

          { Enpassant }
          if Enpassant > -1 then
            begin
              if (X - 1 > -1) and (From - (8 * Color) -1 = EnPassant) then
                AddMove(From, From - (8 * Color) - 1, mtEnpassant);
              if (X + 1 < 8) and (From - (8 * Color) + 1 = EnPassant) then
                AddMove(From, From - (8 * Color) + 1, mtEnpassant);
            end;
        end;
      WN..WK:
        begin
          { Check for allied (meaning color to move) mating material.
            Minimum is 2 bishops or 1 bishop and 1 knight. }
          case Position[From] * Color of
            WN:
              begin
                if AMM = WB then FAlliedMM := True;
                AMM := WN;
              end;
            WB:
              begin
                if (AMM = WB) or (AMM = WN) then FAlliedMM := True;
                AMM := WB;
              end;
            WR, WQ: FAlliedMM := True;
          end;
          { if (NumberOfChecks >= 2) and (From <> King) then Continue }
          { Get Rank and File }
          SqrToXY(From, X, Y);
          for Dirc := VECTOR_A[Abs(Position[From])]
          to VECTOR_B[Abs(Position[From])] do
            for Dist := 1 to VECTOR_SCOPE[Abs(Position[From])] do
              begin
                { Check the boundries. }
                if (X + VECTOR_X[Dirc] * Dist > 7)
                or (X + VECTOR_X[Dirc] * Dist < 0)
                or (Y + VECTOR_Y[Dirc] * Dist > 7)
                or (Y + VECTOR_Y[Dirc] * Dist < 0) then Break;
                case Position[From + VECTOR[Dirc] * Dist] * Color of
                  BK..BP:
                    begin
                      AddMove(From, From + (VECTOR[Dirc] * Dist), mtNormal);
                      Break;
                    end;
                  EMPTY:
                    AddMove(From, From + (VECTOR[Dirc] * Dist), mtNormal);
                  WP..WK:
                    Break;
                end;
              end;
        end;
      BQ..BP:
        { Check for Enemy (meaning color to move) mating material.
          Minimum is 2 bishops or 1 bishop and 1 knight. }
        case Position[From] * Color of
          BN:
            begin
              if EMM = BB then FEnemyMM := True;
              EMM := BN;
            end;
          BB:
            begin
              if (EMM = BB) or (EMM = BN) then FEnemyMM := True;
              EMM := BB;
            end;
          BP, BR, BQ: FEnemyMM := True;
        end;
    end;

  { If the king is in check twice the king must move.
    Simply remove all moves that are not king moves. }
  if NumberOfChecks >= 2 then
    for X := FLegalMoves.Count -1 downto 0 do
      if not TLegalMove(FLegalMoves[X]).FFrom = King then
        FLegalMoves.DeleteOnly(X);

  { If the king is in check once, any non-king move must land on an attacked
    square. }
  if NumberOfChecks = 1 then
    for X := FLegalMoves.Count -1 downto 0 do
      begin
        LegalMove := TLegalMove(FLegalMoves[X]);
        if (LegalMove.FFrom = King) or (LegalMove.FType = mtEnpassant) then Continue;
        Dirc := 0; { Used as a flag }
        _To := LegalMove.FTo;
        for Y := 0 to FAttacked.Count -1 do
          if Integer(FAttacked[Y]) = _To then
            begin
              Dirc := 1;
              Break;
            end;
        if Dirc = 0 then FLegalMoves.DeleteOnly(X);
      end;

  { Remove the moves that would result in the king being/remaining in check }
  for X := FLegalMoves.Count -1 downto 0 do
    begin
      LegalMove := TLegalMove(FLegalMoves[X]);
      From := LegalMove.FFrom;
      _To := LegalMove.FTo;
      MoveType := LegalMove.FType;

      if From = King then
        begin
          { Alternitively a check against FAttacked would work here. 6 of 1...}
          if InCheck(Position, Color, _To, False) > 0 then
            FLegalMoves.DeleteOnly(X);
        end
      else
        begin
          { Make the position changes in the Position array.... }
          Dirc := Position[_To];
          Position[_To] := Position[From];
          Position[From] := EMPTY;
          if MoveType = mtEnpassant then Position[Enpassant + SPR * Color] := 0;

          { ...check for check...}
          if InCheck(Position, Color, King, False) > 0 then
            FLegalMoves.DeleteOnly(X);

          { ...Restore the position. }
          Position[From]  := Position[_To];
          Position[_To] := Dirc;
          if MoveType = mtEnpassant then Position[Enpassant + SPR * Color] := -Color;
        end;
    end;

  { Check the castle bit. Check the spaces between king and dest for EMPTY
    (except rook or king of same color). Use InCheck to ensure squres between
    king and dest are not attacked. If the king moves less than 2 places, force
    the rook move to be the valid move (expection would be a 1 sqare king move
    that lands on the rook). This supports fischer-random castling. }
  { Queenside }
  if (((Position[65] and 1 = 1) and (Color = BLK))
  or ((Position[65] and 4 = 4) and (Color = WHT)))
  and (NumberOfChecks = 0) then
    begin
      SqrToXY(King, X, Y);
      _To := Y * SPR + 2;
      if Color = WHT then Dirc := FRooks.WQS else Dirc := FRooks.BQS;

      { Check for vacancy of squares between king and _To }
      if _To <= King then
        begin X := _To; Y := King; end
      else
        begin X := King; Y := _To; end;
      for Dist := X to Y do
        if (Position[Dist] <> 0) and (Dist <> King) and (Dist <> Dirc) then
          goto KingSide;
      { Check for attack state of squares }
      for Dist := X to Y do if InCheck(Position, Color, Dist, False) > 0 then
        goto KingSide;
      { Check for vacancy of squares Rook and _To + 1 }
      if Dirc <= _To then
        begin X := Dirc + 1; Y := _To + 1; end
      else
        begin X := _To + 1; Y := Dirc - 1; end;
      for Dist := X to Y do
        if (Position[Dist] <> 0) and (Dist <> King) and (Dist <> Dirc) then
          goto KingSide;
      { Check distance king has to move }
      if (Abs(King - _To) > 1) or (_To = Dirc) then
        AddMove(King, _To, mtCastleQ)
      else
        AddMove(Dirc, _To + 1, mtCastleQ);
    end;

KingSide:
  { Kingside }
  if (((Position[65] and 2 = 2) and (Color = BLK))
  or ((Position[65] and 8 = 8) and (Color = WHT)))
  and (NumberOfChecks = 0) then
    begin
      SqrToXY(King, X, Y);
      _To := Y * SPR + 6;
      if Color = WHT then Dirc := FRooks.WKS else Dirc := FRooks.BKS;

      { Check for vacancy of squares between king and _To }
      if _To <= King then
        begin X := _To; Y := King; end
      else
        begin X := King; Y := _To; end;
      for Dist := X to Y  do
        if (Position[Dist] <> 0) and (Dist <> King) and (Dist <> Dirc) then
          goto Plunks;
      { Check for attack state of squares }
      for Dist := X to Y do if InCheck(Position, Color, Dist, False) > 0 then
        goto Plunks;
      { Check for vacancy of squares Rook and _To - 1 }
      if Dirc < _To then
        begin X := Dirc + 1; Y := _To -1; end
      else
        begin X := _To; Y := Dirc - 1; end;
      for Dist := X to Y do
        if (Position[Dist] <> 0) and (Dist <> King) and (Dist <> Dirc) then
          goto Plunks;
      { Check distance king has to move }
      if (Abs(King - _To) > 1) or (_To = Dirc) then
        AddMove(King, _To, mtCastleK)
      else
        AddMove(Dirc, _To - 1, mtCastleK);
    end;

Plunks:
  if grPlunk in FGameRules then
    begin
      if Color = WHT then X := 73 else X := 66;
      { Add a legal move from each array position representing captured pieces
        to each EMPTY square...or....}
      if NumberOfChecks = 0 then for _To := Low(Position) to 63 do
        if Position[_To] = EMPTY then for From := X to X + 6 do
          if (Position[From] > 0)
          and ((((From = 71) or (From = 73)) and ((_To > 7) and (_To < 56)))
          or ((From <> 71) and (From <> 73))) then AddMove(From, _To, mtPlunk);

      { ...Add a legal move from each array position representing captured
        pieces to each Square that would interupt a check.}
      if (grPlunk in FGameRules) and (NumberOfChecks = 1) then
        for Dist := 0 to FAttacked.Count -1 do
          begin
            _To := Integer(FAttacked[Dist]);
            if Position[_To] = EMPTY then for From := X to X + 5 do
              if (Position[From] > 0)
              and ((((From = 71) or (From = 73)) and ((_To > 7) and (_To < 56)))
              or ((From <> 71) and (From <> 73))) then
                AddMove(From, _To, mtPlunk);
          end;

      { Check for allied material to win }
      if (Position[72 + WP * Color] >0) or (Position[72 + WR * Color] >0)
      or (Position[72 + WQ * Color] >0) or (Position[72 + WB * Color] >=2)
      or ((Position[72 + WB * Color] >=1) and (Position[72 + WN * Color] >= 1))
      or ((Position[72 + WB * Color] >=1) and (AMM <> 0))
      or ((Position[72 + WN * Color] >=1) and (AMM = WB)) then
        FAlliedMM := True;
      { Check for enemy material to win }
      if (Position[72 + BP * Color] >0) or (Position[72 + BR * Color] >0)
      or (Position[72 + BQ * Color] >0) or (Position[72 + BB * Color] >=2)
      or ((Position[72 + BB * Color] >=1) and (Position[72 + BN * Color] >= 1))
      or ((Position[72 + BB * Color] >=1) and (EMM <> 0))
      or ((Position[72 + BN * Color] >=1) and (EMM = BB)) then
        FEnemyMM := True;
    end;

  { If the game rules allow for 'losers' then remove any move that is not a
    capturing move (if no such moves exists then all moves are valid). A player
    who runs out of pieces or is checkmated 'wins'.}
  if grLoser in FGameRules then
    begin
      { Try to find any capture move. Dirc is a reused Integer.  }
      Dirc := 0;
      for X := 0 to FLegalMoves.Count -1 do
        begin
          LegalMove := TLegalMove(FLegalMoves[X]);
          if (Position[LegalMove.FTo] <> 0)
          or (LegalMove.FType = mtEnpassant) then
            begin
              Dirc := 1;
              Break;
            end;
        end;
      if Dirc = 1 then
        for X := FLegalMoves.Count -1 downto 0 do
          begin
            LegalMove := TLegalMove(FLegalMoves[X]);
            if (Position[LegalMove.FTo] = 0)
            and (LegalMove.FType <> mtEnpassant) then FLegalMoves.DeleteOnly(X);
          end;

      { Now find if color to move has any non king pieces left. If not then
        that color is considered checkmated (which is a win in 'losers') }
      Dirc := 0;
      for X := 0 to BOARD_MAX do
        case Position[X] * Color of
          WP..WQ:
            begin
              Inc(Dirc);
              Break;
            end;
        end;
      if grPlunk in FGameRules then
        for X := 66 to 78 do
          if (Position[X] <> 0) and ((X - 72) * Color > 0) then
            begin
              Inc(Dirc);
              Break;
            end;

      if Dirc = 0 then
        begin
          Inc(NumberOfChecks);
          FLegalMoves.DeleteFrom(0);
        end;
    end;

  { All legal moves have been generated. Check the status of the position. }
  FMoveStatus := msNone;
  if (Move.FRM >= 100) or (Move.FRP >= 2) or (not FAlliedMM and not FEnemyMM) then
    FMoveStatus := msDraw
  else if (FLegalMoves.Count > 0) and (NumberOfChecks > 0) then
    FMoveStatus := msCheck
  else if (FLegalMoves.Count = 0) and (NumberOfChecks = 0) then
    FMoveStatus := msStaleMate
  else if (FLegalMoves.Count = 0) and (NumberOfChecks > 0) then
    FMoveStatus := msCheckMate;
end;
//______________________________________________________________________________
procedure TGame.GeneratePGN(const MoveNumber: Integer);
var
  LegalMove: TLegalMove;
  Move, Move2: TMove;
  F, R: Boolean;  { Rank and File ambiguity flags }
  Index, Color: Integer;
  FR: string;
begin
  { Notice there's no range checking here. Be sure that the MoveNumber param is
    always at least 1! Also this can only be called AFTER a move has been added
    to FMoves. }
  Move := TMove(FMoves[MoveNumber]);
  Move2 := TMove(FMoves[MoveNumber -1]);
  Color := Move.FColor;
  F := False;
  R := False;

  { To determine ambiguity a list of legal moves is needed from the previous
    position }
  GenerateMoves(MoveNumber -1);

  with Move do
    if FType = mtCastleK then FPGN := 'O-O'
    else if FType = mtCastleQ then FPGN := 'O-O-O'
    else if FType = mtPlunk then
      FPGN := PIECE_SYMBOL[FPosition[FTo] * Color] + '@' + SqrToFR(FTo)
    { Pawn Move }
    else if (FType in [mtEnpassant, mtPawnPush, mtPromotion])
    or (FPosition[FTo] * Color = WP) then
      begin
        if (FFrom - FTo) mod 8 = 0 then
          FPGN := SqrToFR(FTo) { Non capture }
        else
          FPGN := SqrToFR(FFrom)[1] + 'x' + SqrToFR(FTo); { Capture }
      end
    { Piece move }
    else
      begin
        for Index := 0 to FLegalMoves.Count -1 do
          begin
            LegalMove := TLegalMove(FLegalMoves[Index]);
            { Check for ambiguity }
            if (Move2.FPosition[FFrom] <> Move2.FPosition[LegalMove.FFrom]) or
            (LegalMove.FFrom = FFrom) or (LegalMove.FTo <> FTo) then Continue;
            if Abs(LegalMove.FFrom - FFrom) < SPR then F := True
            else if (LegalMove.FFrom - FFrom) mod SPR = 0 then R := True
            else if Abs(LegalMove.FFrom - FFrom) > SPR then F := True;
          end;
        FR := SqrToFR(FFrom);
        FPGN := PIECE_SYMBOL[Abs(FPosition[FTo])];
        if F then FPGN := FPGN + FR[1];
        if R then FPGN := FPGN + FR[2];
        if not (Move2.FPosition[FTo] = EMPTY) then FPGN := FPGN + 'x';
        FPGN := FPGN + SqrToFR(FTo);
      end;

    { Required to get the check/stale/mate status }
    GenerateMoves(MoveNumber);

    { Check for enpassant, promotion }
    with Move do
      begin
        if FType = mtEnpassant then FPGN := FPGN + 'ep';
        if FType = mtPromotion then
          FPGN := FPGN + '=' + PIECE_SYMBOL[Abs(FPosition[FTo])];
        { Check for Move/Game result }
        case FMoveStatus of
          msCheck: FPGN := FPGN + '+';
          msCheckMate: FPGN := FPGN + '#';
          msStaleMate, msDraw: FPGN := FPGN + '=';
        end;
      end;
end;
//______________________________________________________________________________
function TGame.GetKing(const Position: TPosition; const Color: Integer): Integer;
var
  Index: Integer;
begin
  { Function to find the king square. It's not effecient but doesn't get called
    often. }
  Result := -1;
  for Index := 0 to 63 do { Loop through the FPosition array }
    if Position[Index] = WK * Color then
      begin
        Result := Index;
        Break;
      end;
end;
//______________________________________________________________________________
function TGame.InCheck(const Position: TPosition; const Color, King: Integer;
  const BuildAttackList: Boolean): Integer;
var
  Dirc, Dist, Index, MaxChecks, X, Y: Integer;
begin
  { Black constants represent enemies, white represents allies. Returns the
    number of times the king is under attack (max of 2). Optionally adds
    squares that comprise a line that attacks the king to FAttacked for use
    in GenerateMoves. }
  Result := 0;

  if BuildAttackList then
    begin
      FAttacked.Clear;
      MaxChecks := 2;
    end
  else
    MaxChecks := 1;

  { Get the rank and file (rank is reversed from chess norm) }
  SqrToXY(King, X, Y);

  { Loop through the non-knight vectors }
  for Dirc := 1 to 8 do
    for Dist := 1 to 8 do
      begin
        { No point continuing on if the answer has been found. }
        if Result >= MaxChecks then Exit;
        { Check the boundries .}
        if (X + VECTOR_X[Dirc] * Dist > 7) or (X + VECTOR_X[Dirc] * Dist < 0)
        or (Y + VECTOR_Y[Dirc] * Dist > 7) or (Y + VECTOR_Y[Dirc] * Dist < 0)
        then Break;
        { Now examine the piece. }
        case Position[King + (VECTOR[Dirc] * Dist)] * Color of
          BK:
            if Dist = 1 then
              begin
                Inc(Result);
                if BuildAttackList then for Index := 1 to Dist do
                  AddAttacked(King, Dirc, Index);
              end
            else Break;
          BQ:
            begin
              Inc(Result);
              if BuildAttackList then for Index := 1 to Dist do
                AddAttacked(King, Dirc, Index);
            end;
          BR:
            if Dirc < 5 then
              begin
                Inc(Result);
                if BuildAttackList then for Index := 1 to Dist do
                  AddAttacked(King, Dirc, Index);
              end
            else Break;
          BB:
            if Dirc > 4 then
              begin
                Inc(Result);
                if BuildAttackList then for Index := 1 to Dist do
                  AddAttacked(King, Dirc, Index);
              end
            else Break;
          BN:
            Break;
          BP:
            begin
              if (Dist = 1) and (VECTOR[Dirc] * Color = -9) then
                begin
                  Inc(Result);
                  if BuildAttackList then for Index := 1 to Dist do
                    AddAttacked(King, Dirc, Index);
                end;
              if (Dist = 1) and (VECTOR[Dirc] * Color = -7) then
                begin
                  Inc(Result);
                  if BuildAttackList then for Index := 1 to Dist do
                    AddAttacked(King, Dirc, Index);
                end;
              Break;
            end;
        EMPTY, WK:
          Continue;
        WP..WQ:
          Break;
        end; { case of }
      end;
  { Loop though the knight vectors }
  for Dirc := 9 to 16 do
    begin
      if Result >= MaxChecks then Exit;
      if (X + VECTOR_X[Dirc] > 7) or (X + VECTOR_X[Dirc] < 0)
      or (Y + VECTOR_Y[Dirc] > 7) or (Y + VECTOR_Y[Dirc] < 0) then
        Continue;
      case Position[King + VECTOR[Dirc]] * Color of
        BN:
          begin
            Inc(Result);
            if BuildAttackList then AddAttacked(King, Dirc, 1);
          end;
      end;
    end;
end;
//______________________________________________________________________________
function TGame.IsLegal(const From, _To: Integer;
  const MoveType: TMoveType): Boolean;
var
  LegalMove: TLegalMove;
  Index: Integer;
begin
  { Query FMove to see if the passed squares are in the list }
  Result := False;
  for Index := 0 to FLegalMoves.Count - 1 do
    begin
      LegalMove := TLegalMove(FLegalMoves[Index]);
      if (LegalMove.FFrom = From) and (LegalMove.FTo = _To)
      and (LegalMove.FType = MoveType) then
        begin
          Result := True;
          Break;
        end;
    end;
end;
//______________________________________________________________________________
procedure TGame.Reset;
var
  Move: TMove;
begin
  { Set the game to the standard chess beginning position }
  FLegalMoves.DeleteFrom(0);
  FMoves.DeleteFrom(0);
  if Assigned(FMainLine) then FMainLine.DeleteFrom(0);
  FMainLine.Free;
  FMainLine := nil;

  { Add a starting position }
  Move := TMove.Create;
  Move.FPosition := STARTING_POSITION;
  Move.FColor := BLK; { Must be the opposite of the color to move. }
  Move.FRM := 0;
  Move.FRP := 0;
  Move.FFrom := 0;
  Move.FTo := 0;
  FMoves.Add(Move);

  FColor := WHT;
  FCRAbort := nil;
  FCRAdjourn := nil;
  FCRDraw := nil;
  FCRMoretime := nil;
  FCRTakeback := nil;
  FFEN := '';
  FFlagTS := 0;
  FMainLineMoveNumber := -1;
  FMoveNumber := 0;
  FMoveTotal := 0;
  FPGMN := -1;
  FRooks.BQS := 0;
  FRooks.BKS := 7;
  FRooks.WQS := 56;
  FRooks.WKS := 63;

  FLastMoveTS := Now;
  FWhiteLastMoveTS := FLastMoveTS;
  FBlackLastMoveTS := FLastMoveTS;
end;
//______________________________________________________________________________
procedure TGame.SetFEN(const Value: string);
var
  Move: TMove;
  Position: ^TPosition;
  FEN: TStringList;
  Error, Index, King, Spaces, XY: Integer;
begin
  if Value = '' then Exit;

  Reset;
  Move := TMove(FMoves[0]);
  Position := @Move.FPosition;

  { If it's the starting position, do nothing }
//  if (Value = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1') then  Exit;

  FFEN := Value;
  { Break apart the FEN string }
  FEN := TStringList.Create;
  FEN.CommaText := Value;

  XY := 0;
  for Index := 1 to Length(FEN[0]) do
    begin
      case FEN[0][Index] of
        'K', 'Q', 'B', 'N', 'R', 'P', 'k', 'q', 'b', 'n', 'r', 'p':
          begin
            Position[XY] := PieceValue(FEN[0][Index]);
            Inc(XY);
          end;
        else
          begin
            { Test for a number, if so skip ahead that many squares }
            Val(FEN[0][Index], Spaces, Error);
            if Error = 0 then
              begin
                for Error := XY to XY + Spaces -1 do Position[Error] := 0;
                XY := Error;
              end;
          end;
      end; { Case Of }
    end;

  { Color }
  if FEN[1] = 'w' then Move.FColor := BLK else Move.FColor := WHT;
  FColor := -Move.FColor;

  { Castle rights }
  { Assume no castling }
  FRooks.BKS := -1;
  FRooks.BQS := -1;
  FRooks.WKS := -1;
  FRooks.WQS := -1;
  Position[65] := 0;
  { Get Black FRooks - finds the rooks closest to the king }
  King := GetKing(Move.FPosition, BLK);
  XY := (King div SPR) * SPR;
  for Index := XY to King -1 do if Position[Index] = BR then
    FRooks.BQS := Index;
  for Index := XY + SPR -1 downto King +1 do if Position[Index] = BR then
    FRooks.BKS := Index;
  { Get White FRooks - finds the rooks closest to the king }
  King := GetKing(Move.FPosition, WHT);
  XY := (King div SPR) * SPR;
  for Index := XY to King -1 do if Position[Index] = WR then
    FRooks.WQS := Index;
  for Index := (XY + SPR -1) downto (King + 1) do if Position[Index] = WR then
    FRooks.WKS := Index;
  { Set the castle bits if for valid casting situations }
  if (Pos('K', FEN[2]) > 0) and (FRooks.WKS > -1) then
    Position[65] := Position[65] + 8;
  if (Pos('Q', FEN[2]) > 0) and (FRooks.WQS > -1) then
    Position[65] := Position[65] + 4;
  if (Pos('k', FEN[2]) > 0) and (FRooks.BKS > -1) then
    Position[65] := Position[65] + 2;
  if (Pos('q', FEN[2]) > 0) and (FRooks.BQS > -1) then
    Position[65] := Position[65] + 1;

  { Set the Enpassent square from the FEN string }
  if FEN[3] <> '-' then Position[64] := FRToSqr(FEN[3][1], FEN[3][2]);
  { Check the validity of the Enpassant target. Remove if invalid. }
  Index := Position[64];
  XY := Index div SPR;
  if (Move.FColor = BLK) and ((XY <> 2)
  or (Position[Index + SPR] <> BLK)) then Position[64] := -1;
  if (Move.FColor = WHT) and ((XY <> 5)
  or (Position[Index - SPR] <> WHT)) then Position[64] := -1;

  { Repeatable move count }
  Val(FEN[4], XY, Error);
  if Error = 0 then Move.FRM := XY else Move.FRM := 0;

  { Full move number, do nothing }

  if Assigned(FEN) then
    begin
      FEN.Clear;
      FEN.Free;
    end;
  GenerateMoves(0);
end;
//______________________________________________________________________________
procedure TGame.SetGameResult(const Value: TGameResult);
begin
  try
    if (FGameMode = gmLive) and not (FGameResult in [grAborted, grAdjourned])
    then begin
      if Assigned(White) then White.GamesPerDayList.AddCounter(RatedType);
      if Assigned(Black) then Black.GamesPerDayList.AddCounter(RatedType);
    end;

    { GameResult may only be set once! }
    if (FGameMode = gmExamined) and (FGameResult <> grNone) then Exit;

    FEndTime := SysUtils.Date + SysUtils.Time;

    if (Value in [grWhiteForfeitsOnTime,grWhiteForfeitsOnNetwork,
      grBlackForfeitsOnTime,grBlackForfeitsOnNetwork]) and (FMoves.Count<=5)
      and (FGameMode = gmLive)
    then begin
      FGameResult:=grAborted;
      exit;
    end;

    FGameMode := gmExamined;
    FGameResult := Value;

    { if it's losers rules and a side resigns the resignation must be reveresed.
      a better way would be to have a game result type for resigning in losers.
      this is just a quick fix to prevent "winning" a losers game by resigning. }
    if (grLoser in FGameRules) then
      begin
        case Value of
          grWhiteResigns: FGameResult := grBlackResigns;
          grBlackResigns: FGameResult := grWhiteResigns;
          grWhiteForfeitsOnTime: FGameResult := grBlackForfeitsOnTime;
          grBlackForfeitsOnTime: FGameResult := grWhiteForfeitsOnTime;
          grWhiteForfeitsOnNetwork: FGameResult := grBlackForfeitsOnNetwork;
          grBlackForfeitsOnNetwork: FGameResult := grWhiteForfeitsOnNetwork;
        end;

        { Override the loss on time if the opponent does not have mating material. }
        case Value of
          grWhiteForfeitsOnTime, grWhiteForfeitsOnNetwork:
            begin
              if ((FColor = WHT) and not FAlliedMM)
              or ((FColor = BLK) and not FEnemyMM) then
                FGameResult := grDraw;
            end;
          grBlackForfeitsOnTime, grBlackForfeitsOnNetwork:
            begin
              if ((FColor = BLK) and not FAlliedMM)
              or ((FColor = WHT) and not FEnemyMM) then
                FGameResult := grDraw;
            end;
        end;
      end
    else
      begin
        { Override the loss on time if the opponent does not have mating material. }
        case Value of
          grWhiteForfeitsOnTime, grWhiteForfeitsOnNetwork:
            begin
              if ((FColor = WHT) and not FEnemyMM)
              or ((FColor = BLK) and not FAlliedMM) then
                FGameResult := grDraw;
            end;
          grBlackForfeitsOnTime, grBlackForfeitsOnNetwork:
            begin
              if ((FColor = BLK) and not FEnemyMM)
              or ((FColor = WHT) and not FAlliedMM) then
                FGameResult := grDraw;
            end;
        end;
      end;

    { Non-Move results mean the final time for the color on the move must be
      adjusted.}
    if not (Value in [grWhiteCheckMated..grBlackStaleMated]) then
      case FColor of
        BLK: FBlackMSec := FBlackMSec - Trunc((Now -FLastMoveTS) * MSecsPerDay);
        WHT: FWhiteMSec := FWhiteMSec - Trunc((Now -FLastMoveTS) * MSecsPerDay);
      end;
  finally
    if White.ConnectionType = cntEngine then White.Bot.OnGameResult(Self);
    if Black.ConnectionType = cntEngine then Black.Bot.OnGameResult(Self);

    if Assigned(FOnResult) then FOnResult(Self);
  end;
end;
//______________________________________________________________________________
procedure TGame.SetMoreTime(const Value: Integer);
begin
  { Ensures that after the MoreTime amount has been set the first time (during
    a request) that it not be exceeded by the accepting request. }
  if Assigned(FCRMoretime) and (Value * MSECS > FMoreTime) then Exit;
  FMoreTime := Value * MSECS;
end;
//______________________________________________________________________________
procedure TGame.SetTakeBackCount(const Value: Integer);
begin
  { Ensures that after the Tackback amount has been set the first time (during
    a request) that it not be exceeded by the accepting request. }
  if Assigned(FCRTakeback) and (Value > FTakeBackCount) then Exit;
  FTakeBackCount := Value;
  if FTakeBackCount > FMoveNumber then FTakeBackCount := FMoveNumber;
end;
//______________________________________________________________________________
constructor TGame.Create(var Offer: TOffer);
var
  slDummy: TStrings;
  n, shift: integer;
  sFen: string;
begin
  { Initialize }
  FAttacked := TList.Create;
  FConnections := TConnectionList.Create;
  FConnections.OwnsObjects := False;
  FMoves := TCustList.Create;
  FLegalMoves := TCustList.Create;
  { Non-Offer paramater dependent }
  FCanAbort := True;
  FDate := FormatDateTime('yyyy.mm.dd', sysutils.Date);
  FEvent := RATED_TYPES[Ord(Offer.RatedType)];
  Inc(FCreatedCount);
  FGameNumber := FCreatedCount;
  FGameResult := grNone;
  FRound := 0;
  FSite := CHESSLINK_SERVER;
  { Offer parameter depenedent }
  FBlack := Offer.Black;
  FBlackId := Offer.Black.LoginId;
  FBlackLogin := Offer.Black.Handle;
  FBlackRating := Black.Rating[Offer.RatedType];
  FBlackSwitched := 0;
  FBlackTitle := Offer.Black.Title;
  FWhite := Offer.White;
  FWhiteId := Offer.White.LoginId;
  FWhiteLogin := Offer.White.Handle;
  FWhiteRating := White.Rating[Offer.RatedType];
  FWhiteSwitched := 0;
  FWhiteTitle := Offer.White.Title;
  FWhiteCheatSaved := false;
  FBlackCheatSaved := false;
  FStartTime := SysUtils.Date + SysUtils.Time;
  FEndTime := 0;
  FTimeOddsScoreDeviation := 0;

  DefineGameTime(Offer);

  { First one or two FConnection positions are the players }
  FConnections.Add(FWhite);
  if FWhite <> FBlack then FConnections.Add(FBlack);
  { Set game mode }
  if FBlack = FWhite then
    FGameMode := gmExamined
  else
    FGameMode := gmLive;

 { Initialize the board arrays }
  Reset;

  if Offer.Odds.FPiece = -1 then FFEN := ''
  else begin
    if (Offer.Issuer = Black) and (Offer.Odds.FPieceDirection = oodGive)
      or (Offer.Issuer = White) and (Offer.Odds.FPieceDirection = oodAsk)
    then
      shift := 0
    else
      shift := pos('R',START_POSITION) - 1;

    case Offer.Odds.FPiece of
      0: if Offer.Issuer = Black then n := 15 // pawn f2
         else n := 32; // pawn f7
      1: n := 2 + shift; // knight b1 / b8
      2: n := 3 + shift; // bishop c1 / c8
      3: n := 1 + shift; // rock a1 / a8
      4: n := 4 + shift; // queen d1 / d8
    end;

    sFen := START_POSITION;
    sFen[n] := '1';
    FEN := sFen;
  end;

  { Set the game rules. }
  RatedType := Offer.RatedType;

  FRated := Offer.Rated;

  GenerateMoves(0);
  if FGameMode = gmLive then begin
    slDummy:=TStrings.Create;
    if CSConnections.fConnections.FollowList.IndexOfName(FWhiteLogin)>-1 then
      CSConnections.fConnections.CMD_Unfollow(FWhite, slDummy);
    if CSConnections.fConnections.FollowList.IndexOfName(FBlackLogin)>-1 then
      CSConnections.fConnections.CMD_Unfollow(FBlack, slDummy);
  end;

  FOdds := TOfferOdds.Create;
  FOdds.CopyFrom(Offer.Odds);
  if (White = Offer.Issuer) and (FOdds.Defined or FOdds.FAutoTimeOdds) then
    FOdds.FInitiator := ooiWhite
  else
    FOdds.FInitiator := ooiBlack;
end;
//______________________________________________________________________________
destructor TGame.Destroy;
begin
  FAttacked.Clear;
  FAttacked.Free;
  FLegalMoves.Free; { CustList frees the objects }
  FConnections.Free;
  FMainLine.Free;
  FMoves.Free;
  FOdds.Free;

  inherited Destroy;
end;
//______________________________________________________________________________
function TGame.AddMove(const From, _To, Promotion: Integer;
  const MoveType: TMoveType; const PGN: string; const MSEC: Integer): TMove;
var
  Move, Move2: TMove;
  Color, Index, King, Rook, Offset: Integer;
begin
  Result := nil;
  FCRAbort := nil;
  FCRAdjourn := nil;
  FCRDraw := nil;
  FCRMoretime := nil;
  FCRTakeback := nil;

  if IsLegal(From, _To, MoveType) then
    begin
      { Very important that moves added are at the end of FHistory.
      If necessary copy mainline and erase history so that it reflects the
      game up to the current position. }
      if FMoveNumber < FMoveTotal then
        begin
          CopyMainLine;
          Takeback(FMoveTotal - FMoveNumber);
        end;

      { Create a starting point }
      Move2 := TMove(FMoves[FMoveTotal]);
      Move := TMove.Create;
      with Move do
        begin
          FPosition := Move2.FPosition;
          FColor := Move2.FColor * REVERSE_COLOR;
          FRM := Move2.FRM;
          FRP := 0;
          FFrom := From;
          FTo := _To;
          FType := MoveType;
          FPGN := PGN;
      end;

      Color := Move.FColor;

      { Modify the FPosition based on the params passed and the rules of chess. }
      { Register captured pieces. Reverse for grPlunk games. }
      if MoveType in [mtNormal, mtEnpassant, mtPawnPush, mtPromotion] then
        begin
          { This is temporary as the _To position always is rewritten.
            Helps with capture logic. }
          if MoveType = mtEnpassant then
            begin
              Move.FPosition[_To + SPR * Color] := 0;
              Move.FPosition[_To] := -Color;
            end;

          { Register captured piece if any. }
          if not (Move.FPosition[_To] = 0) then
            if grPlunk in FGameRules then
              { Add as a plunk for me to use }
              Inc(Move.FPosition[72 + (Move.FPosition[_To] * REVERSE_COLOR)])
            else
              { Add as a lost piece for opponent }
              Inc(Move.FPosition[72 + Move.FPosition[_To]]);

          { Adjust the From and To positions }
          if MoveType = mtPromotion then
            Move.FPosition[_To] := Promotion
          else
           Move.FPosition[_To] := Move.FPosition[From];
          Move.FPosition[From] := 0;
        end;

      { Castling }
      if MoveType in [mtCastleK, mtCastleQ] then
        begin
          { Get king and rook positions. }
          Rook := 0;
          King := GetKing(Move.FPosition, Color);
          if (MoveType = mtCastleK) and (Color = WHT) then Rook := FRooks.WKS
          else if (MoveType = mtCastleK) and (Color = BLK) then Rook := FRooks.BKS
          else if (MoveType = mtCastleQ) and (Color = WHT) then Rook := FRooks.WQS
          else if (MoveType = mtCastleQ) and (Color = BLK) then Rook := FRooks.BQS;
          if Move.FPosition[From] * Color = WK then
            OffSet := _To
          else
            if MoveType = mtCastleK then OffSet := _To + 1 else OffSet := _To - 1;

          { Adjust the array positions }
          with Move do
            begin
              FFrom := King;
              FTo := Offset;
              FPosition[King] := 0;
              FPosition[Rook] := 0;
              FPosition[Offset] := WK * Color;
              if MoveType = mtCastleK then
                FPosition[Offset -1] := WR * Color
              else
                FPosition[Offset +1] := WR * Color;
            end;
        end;

      { Plunk Move }
      if MoveType = mtPlunk then
        begin
          Move.FPosition[_To] := -6 + (From - 66);
          { Must Dec (as opposed to simpy setting to 0) because From might be a
            plunk position count }
          Dec(Move.FPosition[From]);
          if Move.FPosition[From] < 0 then Move.FPosition[From] := 0;
        end;

      { Adjust the castle bit if necessary }
      Index := Move.FPosition[65];
      if ((Move.FPosition[_To] = WK) or (From = FRooks.WKS) or (_To = FRooks.WKS))
      and (Index and 8 = 8) then Index := Index xor 8;
      if ((Move.FPosition[_To] = WK) or (From = FRooks.WQS) or (_To = FRooks.WQS))
      and (Index and 4 = 4) then Index := Index xor 4;
      if ((Move.FPosition[_To] = BK) or (From = FRooks.BKS) or (_To = FRooks.BKS))
      and (Index and 2 = 2) then Index := Index xor 2;
      if ((Move.FPosition[_To] = BK) or (From = FRooks.BQS) or (_To = FRooks.BQS))
      and (Index and 1 = 1) then Index := Index xor 1;
      Move.FPosition[65] := Index;

      { If it's a double pawn push, make a note of that. }
      if MoveType = mtPawnPush then
        Move.FPosition[64] := _To + (8 * Color)
      else
        Move.FPosition[64] := -1;

      { Track NRM (Non Reversable Moves) for the 50 move rule and 3 fold draw logic }
      if (Move2.FPosition[_To] = 0) and not (Abs(Move.FPosition[_To]) = 1)
      and (MoveType = mtNormal) then
        Inc(Move.FRM)
      else
        Move.FRM := 0;

      { Track Repeating positions }
      Offset := FMoveTotal - Move.FRM - 1;
      if Offset < 0 then Offset := 0;
      for Index := FMoveTotal downto Offset do
        if CompareMem(@Move.FPosition, @TMove(FMoves[Index]).FPosition, 65) then
          begin
            Move.FRP := TMove(FMoves[Index]).FRP + 1;
            Break;
          end;

      { Add to TList, adjust MoveTotal }
      FMoves.Add(Move);
      FMoveTotal := FMoves.Count -1;

      { Build a PGN string if necessary. Order is important here. By calling
       GeneratePGN before GenerateMoves, an additional call to GenerateMoves
       is avoided.}
      if PGN = '' then GeneratePGN(FMoveTotal);

      { Must do this to test for game result after the move (checkmate, stalemate).
        3 position and 50 move draw is already stored in the TMove record. }
      GenerateMoves(FMoveTotal);

      if FColor = WHT then
        case FMoveStatus of
          msCheckMate: FGameResult := grBlackCheckMated;
          msDraw: FGameResult := grDraw;
          msStaleMate: FGameResult := grBlackStaleMated;
        end
      else
        case FMoveStatus of
          msCheckMate: FGameResult := grWhiteCheckMated;
          msDraw: FGameResult := grDraw;
          msStaleMate: FGameResult := grWhiteStaleMated;
        end;

      if FMoveTotal >= ABORT_LIMIT then FCanAbort := False;

      { Set the time }
      { ??? different time control support would require a rewrite }
      if FColor = WHT then
        begin
          FWhiteMSec := FWhiteMSec - MSec;
          if FGameMode = gmLive then FWhiteMSec := FWhiteMSec + FWhiteIncMSec;
          Move.FMSec := FWhiteMSec;
        end
      else
        begin
          FBlackMSec := FBlackMSec - MSec;
          if FGameMode = gmLive then FBlackMSec := FBlackMSec + FBlackIncMSec;
          Move.FMSec := FBlackMSec;
        end;
      Move.FMSec2 := MSec;

      { Reverse the Color }
      FColor := FColor * REVERSE_COLOR;

      { }
      MoveTo(FMoveTotal);

      FlagTS := 0;
      FLastMoveTS := Now;
      if Move.FColor = 1 then FWhiteLastMoveTS := FLastMoveTS
      else FBlackLastMoveTS := FLastMoveTS;

      Result := Move;
    end;
end;
//______________________________________________________________________________
(*
procedure TGame.AddPGN(const PGN: string);
var
  Move: TLegalMove;
  MoveType: TMoveType;
  Position: TPosition;
  Color, From, Index, MoveNumber, _To, Promotion, Piece: Integer;
  Ambigious1, Ambigious2, Rank, _File: Char;
  PGN2: string;
begin
  { Decodes a PGN string and calls AddMove. Assumes the PGN is legal.
   Uses FMoveTotal if it's a server game, FMoveNumber if it's a local game. }
  MoveNumber := FMoveTotal;

  From := 0;
  _To := 0;
  Promotion := 0;
  MoveType := mtNormal;
  Position := TMove(FMoves[MoveNumber]).FPosition;

  Ambigious1 := #0;
  Ambigious2 := #0;

  GenerateMoves(MoveNumber);
  Color := TMove(FMoves[MoveNumber]).FColor * REVERSE_COLOR;

  { X's are meaningless in PGN unless it's a plunk X@d4. As are +'s }
  PGN2 := PGN;
  Index := Pos('x', PGN2);
  if Index > 1 then Delete(PGN2, Index, 1);
  if PGN2[Length(PGN2)] = '+' then Delete(PGN2, Length(PGN2), 1);

  { ??? Untested for fischer random, but should work. }
  { Special Moves }
  if PGN2 = 'O-O' then { Kingside Castle }
    begin
      From := GetKing(Position, Color);
      { Get the rank, then add 6. }
      _To := (From div SPR) * SPR + 6;
      MoveType := mtCastleK;
    end
  else if PGN2 = 'O-O-O' then { Queenside Castle }
    begin
      From := GetKing(Position, Color);
      { Get the rank, then add 2. }
      _To := (From div SPR) * SPR + 2;
      MoveType := mtCastleQ;
    end
  else if Pos('@', PGN2) > 0 then { Plunk on or off the board }
    begin
      Piece := PieceValue(PGN2[1]);
      Piece := Piece * Color;
      if Piece = EMPTY then { ie 'X@d4' - removing the piece from play }
        From := 72 { Empty space in the TPosition }
      else
        begin
          From := 72 + Piece;
          _To := FRToSqr(PGN2[3], PGN2[4]);
        end;
      MoveType := mtPlunk;
    end
  else { Normal move }
    begin
      { Get piece value. Pawn if it starts with a lower case value }
      if PGN2[1] in ['a'..'h'] then
        Piece := WP * Color
      else
        Piece := PieceValue(PGN2[1]) * Color;

      { Find Promo piece }
      Index := Pos('=', PGN2);
      if Index > 0 then
        begin
          Promotion := PieceValue(PGN2[Index + 1]) * Color;
          MoveType := mtPromotion;
        end;

      { Enpassant }
      if Pos('ep', PGN2) > 0 then MoveType := mtEnpassant;

      { Find the Rank value }
      for Index := Length(PGN2) downto 1 do if PGN2[Index] in ['1'..'8'] then
        Break;

      { Find ambigious indicators }
      if (Index = 3) and (Piece = WP * Color) then Ambigious1 := PGN2[1];
      if Index >= 4 then Ambigious1 := PGN2[2];
      if Index = 5 then Ambigious2 := PGN2[3];

      { Find From and _To square}
      _To := FRToSqr(PGN2[Index-1], PGN2[Index]);
      for Index := 0 to FLegalMoves.Count -1 do
        begin
          Move := TLegalMove(FLegalMoves[Index]);
          if (Move.FTo = _To) and (Position[Move.FFrom] = Piece) then
            if not (Ambigious1 = '') then
              begin
                SqrToFR(Move.FFrom, _File, Rank);
                if (Ambigious1 = Rank) or (Ambigious1 = _File) then
                  if ((Ambigious2 = Rank) or (Ambigious2 = _File)) or
                  (Ambigious2 = '') then
                    begin
                      From := Move.FFrom;
                      Break;
                    end;
              end
            else
              begin
                From := Move.FFrom;
                Break;
              end;
        end;
      { Double pawn push ? }
      if (Abs(From - _To) = 16) and (Position[From] = Color) then
        MoveType := mtPawnPush;
    end;
  { Assumes the PGN was a legal move. If that's not the case a test of the
    leagl moves should be inserted here. }
    AddMove(From, _To, Promotion, MoveType, PGN);
end;
*)
//______________________________________________________________________________
procedure TGame.GetMSec(var _WhiteMSec, _BlackMSec: Integer);
begin
  _WhiteMSec := FWhiteMSec;
  _BlackMSec := FBlackMSec;
  { If the game has ticking clocks then get estimated times. }
  if FGameMode = gmLive then
    case FColor of
      BLK: _BlackMSec := FBlackMSec - Trunc((Now -FLastMoveTS) * MSecsPerDay);
      WHT: _WhiteMSec := FWhiteMSec - Trunc((Now -FLastMoveTS) * MSecsPerDay);
    end;
end;
//______________________________________________________________________________
procedure TGame.GoBackward(const Value: Integer);
begin
  MoveTo(FMoveNumber - Value);
end;
//______________________________________________________________________________
procedure TGame.GoForward(const Value: Integer);
begin
  MoveTo(FMoveNumber + Value);
end;
//______________________________________________________________________________
procedure TGame.MoveTo(MoveNumber: Integer);
begin
  { Moves to a specific position as indicated by the MoveNumber param, from
    the previous position. }
  if MoveNumber > FMoveTotal then MoveNumber := FMoveTotal;
  if MoveNumber < 0 then MoveNumber := 0;
  FMoveNumber := MoveNumber;
  GenerateMoves(FMoveNumber);
end;
//______________________________________________________________________________
procedure TGame.Revert;
begin
  if FMainLineMoveNumber = -1 then Exit;
  MoveTo(FMainLineMoveNumber);
  CopyMoves(FMainLine, FMoves);
  FMoveTotal := FMoves.Count -1;
  FColor := TMove(FMoves[FMoveTotal]).FColor * REVERSE_COLOR;
  FMainLineMoveNumber := -1;
  FMainLine.DeleteFrom(0);
  FMainLine.Free;
  FMainLine := nil;
end;
//______________________________________________________________________________
procedure TGame.Takeback(Value: Integer);
begin
  if Value > FMoveTotal then Value := FMoveTotal;
  if FMoveTotal - Value < FMoveNumber then MoveTo(FMoveTotal - Value);
  FMoves.DeleteFrom((FMoveTotal - Value) + 1);
  FMoveTotal := FMoves.Count -1;
  FColor := TMove(FMoves[FMoveTotal]).FColor * REVERSE_COLOR;
end;
//______________________________________________________________________________
function TGame.GetRealGameResult: integer; // 0 - draw, 1 - white wins, -1 - black wins
begin
  case FGameResult of
    grBlackResigns, grBlackCheckmated,
      grBlackForfeitsOnTime, grBlackForfeitsOnNetwork: result:=1;
    grWhiteResigns, grWhiteCheckmated,
      grWhiteForfeitsOnTime, grWhiteForfeitsOnNetwork: result:=-1;
  else
    result:=0;
  end;
end;
//______________________________________________________________________________
function TGame.CountCheatMode(Switched: integer; Title: string; JustSwitched,HiddenCompAccount: Boolean): TCheatMode;
begin
  if (Title='C') or HiddenCompAccount then result:=chmGreen
  else if (Switched>trunc((FMoveTotal div 2)*CHEAT_RED_KOEF)) and (FMoveTotal div 2 > CHEAT_RED_MIN_MOVES) then result:=chmRed
  else if JustSwitched then result:=chmYellow
  else result:=chmGreen;
end;
//______________________________________________________________________________
function TGame.GetWhiteCheatMode: TCheatMode;
begin
  result:=CountCheatMode(WhiteSwitched,WhiteTitle,WhiteJustSwitched,White.HiddenCompAccount);
end;
//______________________________________________________________________________
function TGame.GetBlackCheatMode: TCheatMode;
begin
  result:=CountCheatMode(BlackSwitched,BlackTitle,BlackJustSwitched,Black.HiddenCompAccount);
end;
//______________________________________________________________________________
procedure TGame.SaveBlackCheat;
begin
  if BlackCheatSaved then exit;
  fDB.ExecProc('dbo.proc_CheatHistory',[FBlack.LoginID, FWhite.LoginID]);
  BlackCheatSaved := true;
end;
//______________________________________________________________________________
procedure TGame.SaveWhiteCheat;
begin
  if WhiteCheatSaved then exit;
  fDB.ExecProc('dbo.proc_CheatHistory',[FWhite.LoginID, FBlack.LoginID]);
  WhiteCheatSaved := true;
end;
//______________________________________________________________________________
constructor TGame.Create(Connection: TConnection; WL, WT: string; WR: integer; BL, BT: string;
  BR: integer);
begin
  { Initialize }
  FAttacked := TList.Create;
  FConnections := TConnectionList.Create;
  FConnections.OwnsObjects := False;
  FMoves := TCustList.Create;
  FLegalMoves := TCustList.Create;
  { Non-Offer paramater dependent }
  FCanAbort := True;
  FDate := FormatDateTime('yyyy.mm.dd', sysutils.Date);
  FEvent := RATED_TYPES[0];
  FFEN := '';
  Inc(FCreatedCount);
  FGameNumber := FCreatedCount;
  FGameResult := grNone;
  FRound := 0;
  FSite := CHESSLINK_SERVER;
  { Offer parameter depenedent }
  FWhiteInitialMSec := 120 * MSECS_PER_MINUTE;
  if FWhiteInitialMSec < MSecs * 10 then FWhiteInitialMSec := MSecs * 10;
  FWhiteIncMSec := 0 * 1000;
  FBlackInitialMSec := 120 * MSECS_PER_MINUTE;
  if FBlackInitialMSec < MSecs * 10 then FWhiteInitialMSec := MSecs * 10;
  FBlackIncMSec := 0 * 1000;
  FBlack := Connection;
  FBlackId := Connection.LoginId;
  FBlackLogin := BL;
  FBlackMSec := FBlackInitialMSec;
  FBlackRating := BR;
  FBlackSwitched := 0;
  FBlackTitle := BT;
  FWhiteId := Connection.LoginId;
  FWhite := Connection;
  FWhiteLogin := WL;
  FWhiteMSec := FWhiteInitialMSec;
  FWhiteRating := WR;
  FWhiteSwitched := 0;
  FWhiteTitle := WT;
  FWhiteCheatSaved := false;
  FBlackCheatSaved := false;
  FStartTime := SysUtils.Date + SysUtils.Time;
  FEndTime := 0;
  FTimeOddsScoreDeviation := 0;

  { First one or two FConnection positions are the players }
  FConnections.Add(FWhite);
  if FWhite <> FBlack then FConnections.Add(FBlack);
  { Set game mode }
  if FBlack = FWhite then
    FGameMode := gmExamined
  else
    FGameMode := gmLive;

  { Initialize the board arrays }
  Reset;

  { Set the game rules. }
  FRatedType := rtStandard;
  FRated := false;
  GenerateMoves(0);
  FOdds := TOfferOdds.Create;
end;
//______________________________________________________________________________
constructor TGame.Create;
begin
  FAttacked := TList.Create;
  FConnections := TConnectionList.Create;
  FConnections.OwnsObjects := False;
  FMoves := TCustList.Create;
  FLegalMoves := TCustList.Create;
  { Non-Offer paramater dependent }
  FCanAbort := True;
  FDate := FormatDateTime('yyyy.mm.dd', sysutils.Date);
  FEvent := RATED_TYPES[0];
  FFEN := '';
  Inc(FCreatedCount);
  FGameNumber := FCreatedCount;
  FGameResult := grNone;
  FRound := 0;
  FSite := CHESSLINK_SERVER;
  FWhiteInitialMSec := 0;
  FWhiteIncMSec := 0;
  FBlackInitialMSec := 0;
  FBlackIncMSec := 0;
  FBlackMSec := FBlackInitialMSec;
  FBlackRating := 0;
  FBlackSwitched := 0;
  FWhiteMSec := FWhiteInitialMSec;
  FWhiteRating := 0;
  FWhiteSwitched := 0;
  FWhiteCheatSaved := false;
  FBlackCheatSaved := false;
  Reset;
  FRatedType := rtStandard;
  FRated := false;
  FSavedInDb:=false;
  FPlayerDisconnected:=false;
  GenerateMoves(0);
  FOdds := TOfferOdds.Create;
  FStartTime := SysUtils.Date + SysUtils.Time;
  FEndTime := 0;
  FTimeOddsScoreDeviation := 0;
end;
//______________________________________________________________________________
constructor TGame.Create(connWhite, connBlack: TConnection);
begin
  Create;
  FBlack := connBlack;
  FBlackId := connBlack.LoginId;
  FBlackLogin := connBlack.Handle;
  FBlackTitle := connBlack.Title;
  FWhite := connWhite;
  FWhiteId := connWhite.LoginId;
  FWhiteLogin := connWhite.Handle;
  FWhiteTitle := connWhite.Title;
  FWhiteRating := connWhite.Rating[connWhite.RatedType];
  FBlackRating := connBlack.Rating[connBlack.RatedType];
  FTimeOddsScoreDeviation := 0;

  FWhiteInitialMSec := 120 * MSECS_PER_MINUTE;
  if FWhiteInitialMSec < MSecs * 10 then FWhiteInitialMSec := MSecs * 10;
  FWhiteIncMSec := 0 * 1000;
  FBlackInitialMSec := 120 * MSECS_PER_MINUTE;
  if FBlackInitialMSec < MSecs * 10 then FWhiteInitialMSec := MSecs * 10;
  FBlackIncMSec := 0 * 1000;
  FWhiteMSec := FWhiteInitialMSec;
  FBlackMSec := FBlackInitialMSec;

  { First one or two FConnection positions are the players }
  FConnections.Add(FWhite);
  if FWhite <> FBlack then FConnections.Add(FBlack);
  { Set game mode }
  if FBlack = FWhite then
    FGameMode := gmExamined
  else
    FGameMode := gmLive;

  connWhite.Games.Add(Self);
  connBlack.Games.Add(Self);
  FStartTime := SysUtils.Date + SysUtils.Time;
  FEndTime := 0;
end;
//______________________________________________________________________________
constructor TGame.Create(EV: TCSEvent; Num: integer; LeaderWhite: Boolean);
var
  conn,connLeader: TConnection;
begin
  if EV.OneLeaderEvent then connLeader:=EV.ConnLeader
  else if EV.Type_ = evtKing then connLeader:=(EV as TCSEventKing).connKing
  else connLeader:=nil;

  if connLeader = nil then exit;
  conn:=TConnection(EV.Users[Num]);
  if LeaderWhite then
    Create(connLeader,conn)
  else
    Create(conn,connLeader);
  FEventId := EV.ID;
  RatedType := EV.RatedType;
  Rated := EV.Rated;
  FWhiteRating := White.Rating[RatedType];
  FBlackRating := Black.Rating[RatedType];

  FTimeOddsScoreDeviation := 0;
  FWhiteInitialMSec := TimeToMSec(EV.InitialTime);
  if FWhiteInitialMSec < MSecs * 10 then FWhiteInitialMSec := MSecs * 10;
  FBlackInitialMSec := TimeToMSec(EV.InitialTime);
  if FBlackInitialMSec < MSecs * 10 then FBlackInitialMSec := MSecs * 10;
  FWhiteIncMSec := EV.IncTime * 1000;
  FBlackIncMSec := EV.IncTime * 1000;
  FWhiteMSec:=FWhiteInitialMSec;
  FBlackMSec:=FBlackInitialMSec;
  FCanAbort:=false;
  FStartTime := SysUtils.Date + SysUtils.Time;
  FEndTime := 0;
  {if GameMode = gmLive then begin
    SetGameScore;
    SendGameScore(nil);
  end;}
  OnResult := fGames.GameResult;
end;
//______________________________________________________________________________
function TGame.GetConnections: TConnectionList;
begin
  if EventId = 0 then result:=FConnections
  else begin
    result:=fEvents.GetEventUsers(EventId);
    if result = nil then result:=FConnections;
  end;
end;
//______________________________________________________________________________
function GameScoreByResult(GameResult: TGameResult): TGameScore;
begin
  case GameResult of
    grNone,grAborted,gradjourned: result:=gsNone;
    grDraw,grWhiteStaleMated,grBlackStaleMated: result:=gsDraw;
    grWhiteResigns,grWhiteCheckMated,
      grWhiteForfeitsOnTime,
      grWhiteForfeitsOnNetwork: result:=gsBlackWin;
    grBlackResigns,grBlackCheckMated,
      grBlackForfeitsOnTime,
      grBlackForfeitsOnNetwork: result:=gsWhiteWin;
  end;
end;
//______________________________________________________________________________
procedure TGame.SetRatedType(const Value: TRatedType);
begin
  FRatedType := Value;
  case FRatedType of
    rtCrazy: FGameRules := [grPlunk];
    rtFischer: FischerRandomize;
    rtLoser: FGameRules := [grLoser];
  end;
end;
//______________________________________________________________________________
procedure TGame.ShoutIfTitled;
var
  MainTitle, MainLogin, MainWord, SecondLogin, SecondTitle, Txt: string;
begin
  if GameMode <> gmLive then exit;
  
  if (WhiteTitle = 'WGM') or (WhiteTitle = 'GM') then begin
    MainWord:='Grandmaster';
    MainTitle:=WhiteTitle;
    MainLogin:=WhiteLogin;
    SecondTitle:=BlackTitle;
    SecondLogin:=BlackLogin;
  end else if (BlackTitle = 'WGM') or (BlackTitle = 'GM') then begin
    MainWord:='Grandmaster';
    MainTitle:=BlackTitle;
    MainLogin:=BlackLogin;
    SecondTitle:=WhiteTitle;
    SecondLogin:=WhiteLogin;
  end else if (WhiteTitle = 'FM') or (WhiteTitle = 'IM') or (WhiteTitle = 'WFM') or (WhiteTitle = 'WIM') then begin
    MainWord:='Master';
    MainTitle:=WhiteTitle;
    MainLogin:=WhiteLogin;
    SecondTitle:=BlackTitle;
    SecondLogin:=BlackLogin;
  end else if (BlackTitle = 'FM') or (BlackTitle = 'IM') or (BlackTitle = 'WFM') or (BlackTitle = 'WIM') then begin
    MainWord:='Master';
    MainTitle:=BlackTitle;
    MainLogin:=BlackLogin;
    SecondTitle:=WhiteTitle;
    SecondLogin:=WhiteLogin;
  end else
    exit;

  if SecondTitle<>'' then SecondTitle:='('+SecondTitle+') ';

  Txt:=Format('%s Game!!! (%s) %s vs %s%s! Click "/observe %s" to observe the game.',
    [MainWord, MainTitle, MainLogin, SecondTitle, SecondLogin, MainLogin]);

  fSocket.Send(CSConnections.fConnections.Connections,[DP_SHOUT,'Server','',Txt],Self);
end;
//______________________________________________________________________________
procedure TGame.MakeDisconnectChoise(Connection: TConnection);
begin
  if DisconnectChoiseSuggested then exit;
  if (Connection = nil) or (Connection.Socket = nil) then begin
    if ((White = nil) or (White.Socket = nil)) and
       ((Black = nil) or (Black.Socket = nil))
    then
      GameResult:=grAdjourned
    else if (White <> nil) and (White.Socket <> nil)
      and (Black <> nil) and (Black.Socket<>nil)
    then
      exit
    else if (White <> nil) and (White.Socket<>nil) then
      GameResult:=grBlackForfeitsOnNetwork
    else
      GameResult:=grWhiteForfeitsOnNetwork
  end else begin
    PlayerDisconnected:=true;
    DisconnectChoiseSuggested := true;
    if Connection.ConnectionType = cntPlayer then
      fSocket.Send(Connection,[DP_GAME_MSG,IntToStr(GameNumber),DP_ERR_0,
        'You opponent seems to be disconnected. You can "/abort", "/adjourn" or "/win".'])
    else
      Connection.Bot.OnOpponentDisconnect;
  end;
end;
//______________________________________________________________________________
function TGame.Involved(Connection: TConnection): Boolean;
var
  i: integer;
begin
  result:=true;
  for i:=0 to FConnections.Count-1 do
    if Connection = TConnection(FConnections[i]) then
      exit;
  result:=false;
end;
//______________________________________________________________________________
procedure TGame.AddConnection(Connection: TConnection);
begin
  if not Involved(Connection) then
    FConnections.Add(Connection);
end;
//______________________________________________________________________________
procedure TGame.SendGameScore(Connection: TConnection);
begin
  if Connection <> nil then MarkSendOnlyOne(Connections, Connection);

  fSocket.Send(Connections,[DP_GAME_SCORE,IntToStr(GameNumber),
    IntToStr(Score.Win),IntToStr(Score.Lost),IntToStr(Score.Draw)],Self);
end;
//______________________________________________________________________________
procedure TGame.SendMoveToEngine(p_Move: TMove);
var
  conn: TConnection;
begin
  if p_Move.FColor = 1 then conn := Black
  else conn := White;

  if conn.ConnectionType = cntEngine then
    conn.Bot.OnOpponentMove(p_Move.EngineFormat);
end;
//______________________________________________________________________________
procedure TGame.SetGameScore;
begin
  fDB.GetGameScore(WhiteId,BlackId,RatedType,FScore);
end;
//______________________________________________________________________________
procedure TGame.DefineGameTime(Offer: TOffer);
var
  OddsInitTime, OddsIncTime, OddsScoreDeviation: integer;
begin
  // determining initial and inc time
  if Offer.Odds.FAutoTimeOdds then begin // auto time odds
    CountTimeOdds(TimeToMSec(Offer.InitialTime) div 1000, Offer.IncTime,
      FWhiteRating, FBlackRating,
      OddsInitTime, OddsIncTime, OddsScoreDeviation);
    FTimeOddsScoreDeviation := OddsScoreDeviation;
    if FWhiteRating < FBlackRating then begin
      FWhiteInitialMSec := TimeToMSec(Offer.InitialTime);
      FWhiteIncMSec := Offer.IncTime * 1000;
      FBlackInitialMSec := OddsInitTime * 1000;
      FBlackIncMSec := OddsIncTime * 1000;
    end else begin
      FBlackInitialMSec := TimeToMSec(Offer.InitialTime);
      FBlackIncMSec := Offer.IncTime * 1000;
      FWhiteInitialMSec := OddsInitTime * 1000;
      FWhiteIncMSec := OddsIncTime * 1000;
    end
  end else if Offer.Odds.TimeDefined then begin // predefined time odds
    if (Offer.Issuer = Offer.White) and (Offer.Odds.FTimeDirection = oodGive) or
      (Offer.Issuer = Offer.Black) and (Offer.Odds.FTimeDirection = oodAsk)
    then begin
       FWhiteInitialMSec := Offer.Odds.InitMSec;
       FWhiteIncMSec := Offer.Odds.IncMSec;
       FBlackInitialMSec := TimeToMSec(Offer.InitialTime);
       FBlackIncMSec := Offer.IncTime * 1000;
    end else begin
       FBlackInitialMSec := Offer.Odds.InitMSec;
       FBlackIncMSec := Offer.Odds.IncMSec;
       FWhiteInitialMSec := TimeToMSec(Offer.InitialTime);
       FWhiteIncMSec := Offer.IncTime * 1000;
    end
  end else begin // usual game without odds
    FWhiteInitialMSec := TimeToMSec(Offer.InitialTime);
    FWhiteIncMSec := Offer.IncTime * 1000;
    FBlackInitialMSec := TimeToMSec(Offer.InitialTime);
    FBlackIncMSec := Offer.IncTime * 1000;
  end;

  FWhiteMSec := FWhiteInitialMSec;
  FBlackMSec := FBlackInitialMSec;
end;
//______________________________________________________________________________
class function TMove.CoordNum2Str(p_NumMove: integer): string;
const COORDS = 'abcdefgh';
begin
  result := COORDS[p_NumMove mod 8 + 1] + IntToStr(8 - p_NumMove div 8);
end;
//______________________________________________________________________________
class function TMove.CoordStr2Num(p_StrMove: string): Byte;
const COORDS = 'abcdefgh';
var
  col, row: integer;
begin
  if length(p_StrMove) <> 2 then
    raise exception.create('TMove.CoordStr2Num: wrong argument ''' + p_StrMove + '''');
  col := pos(p_StrMove[1], COORDS);
  row := StrToInt(p_StrMove[2]);
  result := (8 - row) * 8 + col - 1;
end;
//______________________________________________________________________________
function TMove.GetEngineFormat: string;
begin
  result := TMove.CoordNum2Str(FFrom) + TMove.CoordNum2Str(FTo);
  if FType = mtPromotion then
    result := result + TMove.PromoNum2Str(FPosition[FTo]);
end;
//______________________________________________________________________________
class function TMove.GetMoveType(p_Position: TPosition; p_From, p_To: Byte): TMoveType;
var
  Piece: integer;
  RowFrom, RowTo, ColFrom, ColTo: integer;
begin
  Piece := p_Position[p_From];
  RowFrom := 8 - p_From div 8;
  RowTo := 8 - p_To div 8;
  ColFrom := p_From mod 8 + 1;
  ColTo := p_To mod 8 + 1;

  if (Piece = WK) and (p_From = 60) and (p_To = 62)
       or (Piece = BK) and (p_From = 4) and (p_To = 6)
  then
    result := mtCastleK
  else if (Piece = WK) and (p_From = 60) and (p_To = 58)
       or (Piece = BK) and (p_From = 4) and (p_To = 2)
  then
    result := mtCastleQ
  else if (Piece = WP) and (RowFrom = 2) and (RowTo = 4)
       or (Piece = BP) and (RowFrom = 7) and (RowTo = 5)
  then
    result := mtPawnPush
  else if ((Piece = WP) or (Piece = BP)) and (ColFrom <> ColTo) and (p_Position[p_To] = 0) then
    result := mtEnpassant
  else if (Piece = WP) and (RowTo = 8) or (Piece = BP) and (RowTo = 1) then
    result := mtPromotion
  else
    result := mtNormal;
end;
//______________________________________________________________________________
function TMove.GetPromo: integer;
begin
  if FType = mtPromotion then
    result := FPosition[FTo]
  else
    result := 0;
end;
//______________________________________________________________________________
class function TMove.PromoNum2Str(p_NumPromo: integer): string;
begin
  case abs(p_NumPromo) of
    2: result := 'n';
    3: result := 'b';
    4: result := 'r';
    5: result := 'q';
  else
    raise exception.create('TMove.PromoNum2Str: wrong argument ' + IntToStr(p_NumPromo));
  end;
end;
//______________________________________________________________________________
class function TMove.PromoStr2Num(p_StrPromo: char): Byte;
begin
  case p_StrPromo of
    'n': result := WN;
    'b': result := WB;
    'r': result := WR;
    'q': result := WQ;
  else
    raise exception.create('TMove.PromoStr2Num: wrong argument ' + p_StrPromo);
  end;
end;
//______________________________________________________________________________
initialization;
begin
  FCreatedCount := 0;
end;
//______________________________________________________________________________
end.


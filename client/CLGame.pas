{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLGame;

interface

uses
  SysUtils, Classes, ExtCtrls, CLConst, Graphics, CLOfferOdds;

type
  TUserColor = (uscWhite,uscBlack,uscNone);
  TCheatMode = (chmGreen, chmYellow, chmRed);
  TDrawAction = (daNone, daPaintDiff, daPaintSameBoard, daPaintNewBoard);
  TGameMode = (gmNone, gmCLSExamine, gmCLSLive, gmCLSObserve, gmCLSObEx);
  TGameRule = (grLoser, grPlunk);
  TMoveStatus = (msNone, msCheck, msCheckMate, msDraw, msStaleMate);
  TMoveType = (mtIllegal, mtNormal, mtCastleK, mtCastleQ, mtEnpassant,
    mtPawnPush, mtPlunk, mtPromotion);
  TPosition = array[0..78] of ShortInt; { Position 0..63, Enpassant 64, Castling 65(1+2+4+8), Captured 66..77,	Color 78, NRM 79, Repeated 80 }
  TRatedType = (rtStandard, rtBlitz, rtBullet, rtCrazy, rtFischer, rtLoser);

  TPersonalScore = record
    Win,Lost,Draw: integer;
    Defined: Boolean;
  end;

  TMove = class
    FPosition: TPosition;
    FColor: ShortInt;
    FRM: Byte;
    FRP: Byte;
    FFrom: Byte;
    FTo: Byte;
    FType: TMoveType;
    //FWhiteMSec: Integer;
    //FBlackMSec: Integer;
    FPGN: string;

    private
      procedure Assign(const Move: TMove);
  end;

  TGameOverEvent = procedure(Sender: TObject;
    const Result: TMoveStatus) of object;
  TDrawBoardEvent = procedure(Sender: TObject;
    const Pos1, Pos2: Integer; const Action: TDrawAction) of object;

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

  TMarker = class
    FFrom: Integer;
    FTo: Integer;
    FColor: TColor;
  end;

  TCustList = class(TList)
    procedure DeleteFrom(const Value: Integer);
    procedure DeleteOnly(const Value: Integer);
    procedure Free;
  end;

  TCLGame = class(TObject)
    private
      { Private declarations }
      FAlliedMM: Boolean; { Sufficent mating material for the color to move? }
      FAttacked: TList; { All squares between the king and attacker (inclusive of the attacker) }
      FAutoQueen: Boolean;
      FBlackName: string;
      FBlackRating: string;
      FBlackMSec: Integer;
      FBlackScore: Integer;
      FBlackTitle: string;
      FColor: Integer; { Color of side to move (think MoveTotal not MoveNumber) ; 1 = white -1 = black }
      FDate: string;
      FEnemyMM: Boolean; { Sufficent mating material for the color not moving? }
      FEvent: string;
      FFEN: string;
      FGameID: Integer;
      FGameMode: TGameMode;
      FGameNumber: Integer; { Game number }
      FGameResult: string; { Score: *, 0-1, 1-0, 1/2-1/2 }
      FGameResultDesc: string; { Score plus description: 0-1 White Resigns }
      FGameRules: set of TGameRule;
      FGameStyle: string; { Time + Rating Type (2-12 Blitz Rated) }
      //FIncTime: Integer;
      //FInitialTime: Integer;
      FWhiteIncTime: integer;
      FWhiteInitialTime: Integer;
      FBlackIncTime: integer;
      FBlackInitialTime: integer;
      FInverted: Boolean;
      FLag: Boolean; { True from the time a move made with the mouse is sent to the server until the server responds to that move }
      FLagMSec: Integer; { Time FLag is true }
      FLegalMoves: TCustList; { List of TLegalMove(s) for move number requested }
      FLogGame: Boolean;
      FMainLine: TCustList;
      FMainLineMoveNumber: Integer; { Move number from which the main line was departed }
      FMarkers: TCustList;
      FMoves: TCustList; { History of TMove }
      FMoveNumber: Integer; { Move number for the current position. Zero is the starting position }
      FMoveStatus: TMoveStatus; { Check, Mate, Draw, Stalemate, etc. What the move resulted in. }
      FMoveTotal: Integer; { Number of half moves in a game }
      FMoveTS: TDateTime;
      FMyColor: Integer; { 1 = White, -1 = Black, 0 = Not assigned }
      FPGMN: Integer;
      FRound: string;
      FSetup: Boolean;
      FSetupMove: TMove;
      FShowCaptured: Boolean;
      FSite: string;
      FRated: Boolean;
      FRatedType: TRatedType;
      FRender: Boolean; { Set to false if the server is going to send a lot of moves }
      FRooks: TRooks;  { Original position of rooks (necessary for fischer random) }
      FTimer: TTimer;
      FTS: TDateTime;
      FWhiteName: string;
      FWhiteRating: string;
      FWhiteMSec: Integer;
      FWhiteScore: Integer;
      FWhiteTitle: string;
      //FPremove: TMove;
      FPremoves: array [1..PREMOVE_MAX_COUNT] of TMove;

      FOnDrawBoard: TDrawBoardEvent;
      FOnInvertBoard: TNotifyEvent;
      FOnMarkerAdded: TNotifyEvent;
      FOnMarkerRemoved: TNotifyEvent;
      FOnGameOver: TGameOverEvent;
      FOnModeChanged: TNotifyEvent;
      FOnTimer: TNotifyEvent;
      FOnZeroTime: TNotifyEvent;
      FSayMode: integer;
      FSwitched: Boolean;
      FWhiteCheatMode: TCheatMode;
      FBlackCheatMode: TCheatMode;
      FLastreceivedTo: integer;
      FLastreceivedFrom: integer;
      FEventId: integer;
      FEventOrdNum: integer;
      FWhiteInitialMSec: Integer;
      FBlackInitialMSec: Integer;
      FScore: TPersonalScore;
      FOdds: TOfferOdds;

      class function PieceValue(const Piece: Char): Integer;

      procedure AddAttacked(const King, Dirc, Dist: Integer);
      procedure AddMove(const From, _To: Integer;
        const MoveType: TMoveType); overload;
      procedure BuildFEN(const Move: TMove);
      procedure CopyMoves(var Src, Dest: TCustList);
      procedure CopyMainLine;
      procedure GenerateMoves(const MoveNumber: Integer);
      procedure GeneratePGN(const MoveNumber: Integer);
      procedure GenerateScore(const Position: TPosition);
      function  GetGameModeString: string;
      function  GetKing(const Position: TPosition; const Color: Integer): Integer;
      function  InCheck(const Position: TPosition; const Color, King: Integer;
        const BuildAttackList: Boolean): Integer;
      procedure OnFTimer(Sender: TObject);
      function  PremovesMaxCount: integer;
      procedure SetBlackMSec(const MSec: Integer);
      procedure SetGameMode(const Mode: TGameMode);
      procedure SetFEN(const Value: string);
      procedure SetInverted(const IsInverted: Boolean);
      procedure SetRatedType(const Value: TRatedType);
      procedure SetRender(const Value: Boolean);
      procedure SetSetup(const Value: Boolean);
      procedure SetWhiteMSec(const MSec: Integer);
      function GetPremove(Index: integer): TMove;
      function GetNextColor: Integer;
      function GetPremoveColor: Integer;
      procedure SetSwitched(const Value: Boolean);

    public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;

      procedure AddMarker(const From, _To: Integer; sCol: string);
      function  AddMove(const From, _To, Promotion: Integer;
        const MoveType: TMoveType; const PGN: string): TMove; overload;
      procedure AddPGN(const PGN: string);
      procedure AddSetupMove(const From, _To: Integer);
      procedure Assign(const MG: TCLGame);
      procedure AssignSetupMove;
      procedure ClearBadPremoves(const Color: integer);
      procedure ClearBoard;
      procedure ClearMarkers;
      procedure ClearPremove(const From: integer);
      procedure MovePremoves(const Num: integer); overload;
      procedure ClearPremoves; overload;
      function  PremoveIndex(const From: integer; _To: integer = -1): integer;
      function  GetPGN(const MoveNumber: Integer): string;
      function  IsLegal(const From, _To: Integer): TLegalMove;
      function  GetColor(const Position: TPosition; const From: integer): shortint;
      procedure MoveTo(MoveNumber: Integer);
      function  OneLegal(const From: Integer): Integer;
      function  PremovesCount: integer;
      procedure RemoveMarker(const From, _To: Integer);
      procedure Reset;
      procedure ResetBoard;
      procedure Revert;
      procedure SetPremove(const From, _To: integer);
      function  SquareIsPremove(const Square: integer): Boolean;
      procedure TakeBack(Value: Integer);
      function  UserColor(Name: string): TUserColor;
      procedure SetScore(Win,Lost,Draw: integer);
      function MyGame: Boolean;

      property AutoQueen: Boolean read FAutoQueen write FAutoQueen;
      property BlackCheatMode: TCheatMode read FBlackCheatMode write FBlackCheatMode;
      property BlackName: string read FBlackName write FBlackName;
      property BlackRating: string read FBlackRating write FBlackRating;
      property BlackMSec: Integer read FBlackMSec write SetBlackMSec;
      property BlackScore: Integer read FBlackScore;
      property BlackTitle: string read FBlackTitle write FBlackTitle;
      property Color: Integer read FColor;
      property Date: string read FDate write FDate;
      property GameID: Integer read FGameID write FGameID;
      property GameMode: TGameMode read FGameMode write SetGameMode;
      property GameModeString: string read GetGameModeString;
      property GameNumber: Integer read FGameNumber write FGameNumber;
      property GameResult: string read FGameResult write FGameResult;
      property GameResultDesc: string read FGameResultDesc write FGameResultDesc;
      property GameStyle: string read FGameStyle write FGameStyle;
      property FEN: string read FFEN write SetFEN;
      property Event: string read FEvent write FEvent;
      property Inverted: Boolean read FInverted write SetInverted;
      //property InitialTime: Integer read FInitialTime write FInitialTime;
      //property IncTime: Integer read FIncTime write FIncTime;
      property WhiteInitialTime: Integer read FWhiteInitialTime write FWhiteInitialTime;
      property WhiteIncTime: Integer read FWhiteIncTime write FWhiteIncTime;
      property WhiteInitialMSec: Integer read FWhiteInitialMSec write FWhiteInitialMSec;
      property BlackInitialTime: Integer read FBlackInitialTime write FBlackInitialTime;
      property BlackIncTime: Integer read FBlackIncTime write FBlackIncTime;
      property BlackInitialMSec: Integer read FBlackInitialMSec write FBlackInitialMSec;
      property Lag: Boolean read FLag write FLag;
      property LastReceivedFrom: integer read FLastreceivedFrom write FLastReceivedFrom;
      property LastReceivedTo: integer read FLastreceivedTo write FLastReceivedTo;
      property LegalMoves: TCustList read FLegalMoves;
      property LogGame: Boolean read FLogGame write FLogGame;
      property Markers: TCustList read FMarkers;
      property MoveNumber: Integer read FMoveNumber;
      property Moves: TCustList read FMoves;
      property MoveStatus: TMoveStatus read FMoveStatus;
      property MoveTotal: Integer read FMoveTotal;
      property MoveTS: TDateTime read FMoveTS;
      property MyColor: Integer read FMyColor write FMyColor;
      property NextColor: Integer read GetNextColor;
      property Premove[Index: integer]: TMove read GetPremove;
      property PremoveColor: Integer read GetPremoveColor;
      property Rated: Boolean read FRated write FRated;
      property RatingType: TRatedType read FRatedType write SetRatedType;
      property Render: Boolean read FRender write SetRender;
      property Round: string read FRound write FRound;
      property SayMode: integer read FSayMode write FSayMode;
      property Setup: Boolean read FSetup write SetSetup;
      property SetupMove: TMove read FSetupMove;
      property ShowCaptured: Boolean read FShowCaptured write FShowCaptured;
      property Site: string read FSite write FSite;
      property Switched: Boolean read FSwitched write SetSwitched;
      property Timer: TTimer read FTimer write FTimer;
      property WhiteCheatMode: TCheatMode read FWhiteCheatMode write FWhiteCheatMode;
      property WhiteName: string read FWhiteName write FWhiteName;
      property WhiteRating: string read FWhiteRating write FWhiteRating;
      property WhiteMSec: Integer read FWhiteMSec write SetWhiteMSec;
      property WhiteScore: Integer read FWhiteScore;
      property WhiteTitle: string read FWhiteTitle write FWhiteTitle;
      property EventId: integer read FEventId write FEventId;
      property EventOrdNum: integer read FEventOrdNum write FEventOrdNum;
      property Score: TPersonalScore read FScore;
      //property Premove: TMove read FPremove write FPremove;

      property OnDrawBoard: TDrawBoardEvent read FOnDrawBoard write FOnDrawBoard;
      property OnGameOver: TGameOverEvent read FOnGameOver write FOnGameOver;
      property OnInvertBoard: TNotifyEvent read FOnInvertBoard write FOnInvertBoard;
      property OnMarkerAdded: TNotifyEvent read FOnMarkerAdded write FOnMarkerAdded;
      property OnMarkerRemoved: TNotifyEvent read FOnMarkerRemoved write FOnMarkerRemoved;
      property OnModeChanged: TNotifyEvent read FOnModeChanged write FOnModeChanged;
      property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
      property OnZeroTime: TNotifyEvent read FOnZeroTime write FOnZeroTime;
      property Odds: TOfferOdds read FOdds write FOdds;
  end;

function FRToSqr(const _File, Rank: Char): Integer;
function SqrToFR(const Square: Integer): string; overload
function XYToFR(const X, Y: Integer): string;
function XYToSqr(const X, Y: Integer): Integer;
procedure SqrToFR(const Square: Integer; var _File, Rank: Char); overload
procedure SqrToXY(const Square: Integer; var X, Y: Integer);

const
  { Black (in some cases 'enemy', even if I'm black) pieces }
  BLACK = -1; BK = -6; BQ = -5; BR = -4; BB = -3; BN = -2; BP = -1;
   { White (in some cases 'friendly', even if I'm black) pieces }
  WHITE = 1; WK = 6; WQ = 5; WR = 4; WB = 3; WN = 2; WP = 1;

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
    White Pieces Captured 73..78 [ 1, 2, 3, 4, 5, 6]; The POSITION is the PIECE. The VALUE is how MANY pieces. }
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
  VECTOR_A: array[1..6] of integer = (0, 9, 5, 1, 1, 1);
  VECTOR_B: array[1..6] of integer = (0, 16, 8, 4, 8, 8);
  VECTOR_SCOPE: array[1..6] of integer = (0, 1, 8, 8, 8, 1);
  { Three sets of 4 vectors. N, E, S, W, NE, SE, SW, NW, and Knight directions }
  VECTOR: array[1..16] of integer = (-8, 1, 8, -1, -7, 9, 7, -9,
    -15, -6, 10, 17, 15, 6, -10, -17);
  VECTOR_X: array[1..16] of integer = (0, 1, 0, -1, 1, 1, -1, -1,
    1, 2, 2, 1, -1, -2, -2, -1  );
  VECTOR_Y: array[1..16] of integer = (-1, 0, 1, 0, -1, 1, 1, -1,
    -2, -1, 1, 2, 2, 1, -1, -2);

implementation

uses CLGlobal,CLLib,CLBoard,CLMain,CLSocket;

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
function XYToFR(const X, Y: Integer): string;
begin
  Result := FILES[X] + RANKS[7 - Y]; { 7 - Y convert to a1 based (see SqrToXY) }
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
  { Converts a Square number to a Rank and File }
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
  if (Square >= 0) and (Square <= BOARD_MAX) then
    begin
      Y := Square div SPR;
      X := Square - (Y * SPR);
    end
  else if (Square >= 66) and (Square <= 78) then
    { If square is in the captured part of the Position array, then X & Y
      are in reference to the "capture" area, not the "chessboard". }
    begin
      if Square > 72 then X := 0 else X := 1;
      Y := Abs(Square - 72);
    end
  else
    begin
      X := -1;
      Y := -1;
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
      //FWhiteMSec := Move.FWhiteMSec;
      //FBlackMSec := Move.FBlackMSec;
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
class function TCLGame.PieceValue(const Piece: Char): Integer;
begin
  { LoadFEN & AddPGN make use of this. Convert alpha representation to numeric }
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
procedure TCLGame.AddAttacked(const King, Dirc, Dist: Integer);
begin
  FAttacked.Add(Pointer(King + VECTOR[Dirc] * Dist));
end;
//______________________________________________________________________________
procedure TCLGame.AddMove(const From, _To: Integer; const MoveType: TMoveType);
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
procedure TCLGame.BuildFEN(const Move: TMove);
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

   if Move.FColor = WHITE then
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
procedure TCLGame.CopyMainLine;
begin
  { Can only have one main line }
  if Assigned(FMainLine) then Exit;
  FMainLine := TCustList.Create;
  CopyMoves(FMoves, FMainLine);
  FMainLineMoveNumber := FMoveNumber;
end;
//______________________________________________________________________________
procedure TCLGame.CopyMoves(var Src, Dest: TCustList);
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
procedure TCLGame.GenerateMoves(const MoveNumber: Integer);
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
  if (MoveNumber = FPGMN) { and not (MoveNumber = 0) } then Exit;
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
          if ((Color = WHITE) and (Y = 1)) or ((Color = BLACK) and (Y = 6)) then
            MoveType := mtPromotion else MoveType := mtNormal;
          { Single and double pawn pushes }
          if Position[From - (SPR * Color)] = 0 then
            begin
              AddMove(From, From - (SPR * Color), MoveType);
              if (((Color = WHITE) and (Y = 6)) or ((Color = BLACK) and (Y = 1)))
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
          { ??? if (NumberOfChecks >= 2) and (From <> King) then Continue }
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
  if (((Position[65] and 1 = 1) and (Color = BLACK))
  or ((Position[65] and 4 = 4) and (Color = WHITE)))
  and (NumberOfChecks = 0) then
    begin
      SqrToXY(King, X, Y);
      _To := Y * SPR + 2;
      if Color = WHITE then Dirc := FRooks.WQS else Dirc := FRooks.BQS;

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
  if (((Position[65] and 2 = 2) and (Color = BLACK))
  or ((Position[65] and 8 = 8) and (Color = WHITE)))
  and (NumberOfChecks = 0) then
    begin
      SqrToXY(King, X, Y);
      _To := Y * SPR + 6;
      if Color = WHITE then Dirc := FRooks.WKS else Dirc := FRooks.BKS;

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
      if Color = WHITE then X := 73 else X := 66;
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
      { Try to find any capture move. Dirc is a reused integer.  }
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

  GenerateScore(Position);

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

  if not (FMoveStatus = msNone) and Assigned (FOnGameOver) then
    FOnGameOver(Self, FMoveStatus);
end;
//______________________________________________________________________________
procedure TCLGame.GeneratePGN(const MoveNumber: Integer);
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
procedure TCLGame.GenerateScore(const Position: TPosition);
var
  Index: Integer;
begin
  { Calcuate Score }
  FBlackScore := 0;
  FWhiteScore := 0;
  for Index := Low(Position) to BOARD_MAX do
    case Position[Index] of
      //BK: FBlackScore := FBlackScore + 99;
      BQ: FBlackScore := FBlackScore + 9;
      BR: FBlackScore := FBlackScore + 5;
      BB: FBlackScore := FBlackScore + 3;
      BN: FBlackScore := FBlackScore + 3;
      BP: FBlackScore := FBlackScore + 1;
      WP: FWhiteScore := FWhiteScore + 1;
      WN: FWhiteScore := FWhiteScore + 3;
      WB: FWhiteScore := FWhiteScore + 3;
      WR: FWhiteScore := FWhiteScore + 5;
      WQ: FWhiteScore := FWhiteScore + 9;
      //WK: FWhiteScore := FWhiteScore + 99;
    end;
end;
//______________________________________________________________________________
function TCLGame.GetGameModeString: string;
begin
  Result := '';
  case FGameMode of
    gmNone:
      begin
        if GameNumber = DETACHED_GAME then
          Result := 'Local copy of...'
        else
          Result := 'Expired...';
        end;
    gmCLSExamine: Result := 'Examining...';
    gmCLSLive: Result := 'Playing!';
    gmCLSObserve, gmCLSObEx: Result := 'Observing...';
  end;
  Result := Result + #10 + FWhiteName + ' vs ' + FBlackName;
end;
//______________________________________________________________________________
function TCLGame.GetKing(const Position: TPosition; const Color: Integer): Integer;
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
function TCLGame.InCheck(const Position: TPosition; const Color, King: Integer;
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
procedure TCLGame.OnFTimer(Sender: TObject);
var
  sColor: string;
  OldWhiteMSec,OldBlackMSec: integer;
begin
  { Inc LagMSec or Dec White or Black time }
  if FLag then
    begin
      FLagMSec := FLagMSec + System.Round((Now - FTS) * MSecsPerDay);
    end
  else {??? if FGameMode in [gmCLSLive, gmCLSExamine, gmCLSObserve] then }
    begin
      FLagMSec := 0;
      if FColor=BLACK then sColor:='Black'
      else sColor:='White';

      OldBlackMSec:=FBlackMSec;
      OldWhiteMSec:=FWhiteMSec;

      if FColor = BLACK then
        FBlackMSec := FBlackMSec - Trunc((Now - FTS) * MSecsPerDay)
      else
        FWhiteMSec := FWhiteMSec - Trunc((Now - FTS) * MSecsPerDay);

      {CLLib.log(
        Format('OnFTimer: %s; %d->%d; %d->%d',
          [sColor,OldWhiteMSec,FWhiteMSec,OldBlackMSec,FBlackMSec]),
        'socket.log');}
    end;

  { Test for zero time. Fire OnZeroTime Event }
  if FGameMode = gmCLSLive then
    if ((FWhiteMSec <= 0) and (FMyColor = 1))
    or ((FBlackMSec <= 0) and (FMyColor = -1)) then
      begin
        if Assigned(FOnZeroTime) then FOnZeroTime(Self);
        { Fire only one time! }
        FOnZeroTime := nil;
      end;

  { Fire OnTimer Event }
  { ??? if FGameMode in [gmCLSLive, gmCLSExamine, gmCLSObserve] then }
  if Assigned(FOnTimer) then FOnTimer(Self);

  FTS := Now;
end;
//______________________________________________________________________________
procedure TCLGame.SetBlackMSec(const MSec: Integer);
begin
  if MSec = FBlackMSec then Exit;
  FBlackMSec := MSec;
  FTS := Now;
  if Assigned(FOnTimer) then FOnTimer(Self);
end;
//______________________________________________________________________________
procedure TCLGame.SetGameMode(const Mode: TGameMode);
begin
  if Mode = FGameMode then Exit;
  FGameMode := Mode;
  if Assigned(FOnModeChanged) then FOnModeChanged(Self);
  FTimer.Enabled := FGameMode in [gmCLSLive, gmCLSObserve];
end;
//______________________________________________________________________________
procedure TCLGame.SetFEN(const Value: string);
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
  //if (Value = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1') or (Value = '') then Exit;

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
  if FEN[1] = 'w' then Move.FColor := BLACK else Move.FColor := WHITE;
  FColor := -Move.FColor;

  { Castle rights }
  { Assume no castling }
  FRooks.BKS := -1;
  FRooks.BQS := -1;
  FRooks.WKS := -1;
  FRooks.WQS := -1;
  Position[65] := 0;
  { Get Black FRooks - finds the rooks closest to the king }
  King := GetKing(Move.FPosition, BLACK);
  XY := (King div SPR) * SPR;
  for Index := XY to King -1 do if Position[Index] = BR then
    FRooks.BQS := Index;
  for Index := XY + SPR -1 downto King +1 do if Position[Index] = BR then
    FRooks.BKS := Index;
  { Get White FRooks - finds the rooks closest to the king }
  King := GetKing(Move.FPosition, WHITE);
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
  if (Move.FColor = BLACK) and ((XY <> 2)
  or (Position[Index + SPR] <> BLACK)) then Position[64] := -1;
  if (Move.FColor = WHITE) and ((XY <> 5)
  or (Position[Index - SPR] <> WHITE)) then Position[64] := -1;

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
  if Assigned(FOnDrawBoard) then
    FOnDrawBoard(Self, 0, FMoveNumber, daPaintNewBoard);
end;
//______________________________________________________________________________
procedure TCLGame.SetInverted(const IsInverted: Boolean);
begin
  if IsInverted = FInverted then Exit;
  FInverted := IsInverted;
  if Assigned(FOnInvertBoard) then FOnInvertBoard(Self);
end;
//______________________________________________________________________________
procedure TCLGame.SetRatedType(const Value: TRatedType);
begin
  { Should really only be called once right after the game is born }
  FRatedType := Value;
  case FRatedType of
    rtCrazy: FGameRules := [grPlunk];
    rtLoser: FGameRules := [grLoser];
  end;
  GenerateMoves(FMoveNumber);
end;
//______________________________________________________________________________
procedure TCLGame.SetRender(const Value: Boolean);
begin
  FRender := Value;
  if FRender = False then Exit;
  GenerateMoves(FMoveNumber);
  if Assigned(FOnDrawBoard) then
    FOnDrawBoard(Self, 0, FMoveNumber, daPaintNewBoard);
end;
//______________________________________________________________________________
procedure TCLGame.SetSetup(const Value: Boolean);
begin
  if Value = FSetup then Exit;
  FSetup := Value;

  if FSetup then
    begin
      FSetupMove := TMove.Create;
      FSetupMove.Assign(FMoves[FMoveNumber]);
    end
  else
    begin
      { Clear the move list, mainline, set the movenumbers, FRooks etc. }
      GenerateScore(TMove(FMoves[FMoveNumber]).FPosition);
      FSetupMove.Free;
      FSetupMove := nil;
    end;
end;
//______________________________________________________________________________
procedure TCLGame.SetWhiteMSec(const MSec: Integer);
begin
  if MSec = FWhiteMSec then Exit;
  FWhiteMSec := MSec;
  FTS := Now;
  if Assigned(FOnTimer) then FOnTimer(Self);
end;
//______________________________________________________________________________
constructor TCLGame.Create;
var
  i: integer;
begin
  FAttacked := TList.Create;
  FBlackName := 'Black';
  FGameNumber := DETACHED_GAME;
  FGameResult := '';
  FGameResultDesc := '';
  FGameRules := [];
  FLegalMoves := TCustList.Create;
  FMarkers := TCustList.Create;
  FMoves := TCustList.Create;
  FRender := True;
  FSetup := False;
  FSwitched := false;
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 100;
  FTimer.Enabled := False;
  FTimer.OnTimer := OnFTimer;
  FWhiteName := 'White';
  FLag := False;
  FLagMSec := 0;
  FMyColor := 0;
  FSayMode := -1;
  //FPremove := TMove.Create;
  for i:=1 to PREMOVE_MAX_COUNT do
    begin
      FPremoves[i]:=TMove.Create;
      FPremoves[i].FType:=mtIllegal;
    end;

  Reset;
  GenerateMoves(0);
  FScore.Defined:=false;
  FOdds := TOfferOdds.Create;
end;
//______________________________________________________________________________
destructor TCLGame.Destroy;
var
  i: integer;
begin
  FSetupMove.Free;
  FAttacked.Clear;
  FAttacked.Free;
  FLegalMoves.Free; { CustList frees the objects }
  FMarkers.Free;
  FMainLine.Free;
  FMoves.Free;
  FTimer.Free;
  for i:=1 to PREMOVE_MAX_COUNT do
    begin
      FPremoves[i].Free;
    end;
end;
//______________________________________________________________________________
procedure TCLGame.AddMarker(const From, _To: Integer; sCol: string);
var
  Marker: TMarker;
  col: TColor;
  desc: string;
begin
  { Markers are Circles and Lines to draw on the board }
  ColorDescByName(sCol,col,desc);
  Marker := TMarker.Create;
  with Marker do
    begin
      FFrom := From;
      FTo := _To;
      FColor:=col;
    end;
  FMarkers.Add(Marker);

  if Assigned(FOnMarkerAdded) then FOnMarkerAdded(Self);
end;
//______________________________________________________________________________
function TCLGame.AddMove(const From, _To, Promotion: Integer;
  const MoveType: TMoveType; const PGN: string): TMove;
var
  Move, Move2: TMove;
  Color, Index, King, Rook, Offset: Integer;
begin
  Result := nil;
  { Add a move to the game history. If FLag is true then the move has already
    been added by the Board unit, possible additions may come from the server.
    If FLag is false then create and record the move. }
  if FLag then
    begin
      // Possible additions from the server
      Exit;
    end;

  { Make sure FBoard is at the current displayed position. Store main line if
    necessary. Applys only to local games. Server games must always be in sync }
  if (FGameMode = gmNone) and (FMoveNumber < FMoveTotal) then
    begin
      CopyMainLine;
      Takeback(FMoveTotal - FMoveNumber);
    end;

  { Create a starting point }
  Move2 := TMove(FMoves[FMoveTotal]);
  if (Move2.FFrom=From) and (Move2.FTo=_To) then exit;
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
      FBlackMSec := Self.FBlackMSec;
      FWhiteMSec := Self.FWhiteMSec;
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
      King := GetKing(Move.FPosition, Color);
      if (MoveType = mtCastleK) and (Color = WHITE) then Rook := FRooks.WKS
      else if (MoveType = mtCastleK) and (Color = BLACK) then Rook := FRooks.BKS
      else if (MoveType = mtCastleQ) and (Color = WHITE) then Rook := FRooks.WQS
      else if (MoveType = mtCastleQ) and (Color = BLACK) then Rook := FRooks.BQS;
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

  { Track FRM (Reversable Moves) for the 50 move rule and 3 fold draw logic }
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
  Result := Move;
  FMoves.Add(Move);
  FMoveTotal := FMoves.Count -1;

  { Build a PGN string if necessary. Order is important here. By calling
   GeneratePGN before GenerateMoves, an additional call to GenerateMoves
   is avoided.}
  if PGN = '' then GeneratePGN(FMoveTotal);

  { Must do this to test for game result after the move (checkmate, stalemate).
    3 position and 50 move draw is already stored in the TMove record. }
  GenerateMoves(FMoveTotal);

  FColor := FColor * REVERSE_COLOR;

  { Display the "just added" move if necessary. }
  if FMoveNumber = FMoveTotal - 1 then
    MoveTo(FMoveTotal)
  else
    GenerateMoves(FMoveNumber);

  ClearMarkers;

  FMoveTS := Now;

  fCLBoard.PGNPlaySound:=Move.FPGN;
end;
//______________________________________________________________________________
procedure TCLGame.AddPGN(const PGN: string);
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
  if FGameMode = gmNone then
    MoveNumber := FMoveNumber
  else
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
//______________________________________________________________________________
procedure TCLGame.AddSetupMove(const From, _To: Integer);
var
  Position: ^TPosition;
begin
  { Setup position becomes the beginning position. }
  Position := @FSetupMove.FPosition;

  if From > BOARD_MAX then Position[_To] := From - 72;
  { ...or... }
  if (From <= BOARD_MAX) and (_To <= BOARD_MAX) then
    Position[_To] := Position[From];
  if From <= BOARD_MAX then Position[From] := 0;

  GenerateScore(Position^);

  if Assigned(FOnDrawBoard) then
    FOnDrawBoard(Self, 0, FMoveNumber, daPaintNewBoard);
end;
//______________________________________________________________________________
procedure TCLGame.Assign(const MG: TCLGame);
begin
  { Assign all our values to those of a GLGame passed as the param. Used
    when creating a game copy. }
  FAutoQueen := MG.FAutoQueen;
  FBlackName := MG.FBlackName;
  FBlackRating := MG.FBlackRating;
  FBlackMSec := MG.FBlackMSec;
  FBlackScore := MG.BlackScore;
  FColor := MG.FColor;
  FGameStyle := MG.GameStyle;
  FInverted := MG.FInverted;
  FMoveNumber := MG.FMovenumber;
  FMoveTotal := MG.FMoveTotal;
  FWhiteName := MG.FWhiteName;
  FWhiteRating := MG.FWhiteRating;
  FWhiteMSec := MG.WhiteMSec;
  FWhiteScore := MG.WhiteScore;

  CopyMoves(MG.FMoves, FMoves);

  GenerateMoves(FMoveNumber);
end;
//______________________________________________________________________________
procedure TCLGame.AssignSetupMove;
var
  Position: ^TPosition;
  XY, Index, King: Integer;
begin
  { Validate the castle and enpassant rights from the position that was
    submitted. Set the FRook flags for castling. }
  Position := @FSetupMove.FPosition;
  { Assume no castling }
  FRooks.BKS := -1;
  FRooks.BQS := -1;
  FRooks.WKS := -1;
  FRooks.WQS := -1;
  { Get Black FRooks - finds the rooks closest to the king }
  King := GetKing(FSetupMove.FPosition, BLACK);
  XY := (King div SPR) * SPR;
  for Index := XY to King -1 do if Position[Index] = BR then
    FRooks.BQS := Index;
  for Index := XY + SPR -1 downto King +1 do if Position[Index] = BR then
    FRooks.BKS := Index;
  { Get White FRooks - finds the rooks closest to the king }
  King := GetKing(FSetupMove.FPosition, WHITE);
  XY := (King div SPR) * SPR;
  for Index := XY to King -1 do if Position[Index] = WR then
    FRooks.WQS := Index;
  for Index := (XY + SPR -1) downto (King + 1) do if Position[Index] = WR then
    FRooks.WKS := Index;

  { Validate the Castle rights }
  if (FRooks.WKS = -1) and (Position[65] and 8 = 8) then
    Position[65] := Position[65] -8;
  if (FRooks.WQS = -1) and (Position[65] and 4 = 4) then
    Position[65] := Position[65] - 4;
  if (FRooks.BKS = -1) and (Position[65] and 2 = 2) then
    Position[65] := Position[65] - 2;
  if (FRooks.BQS = -1) and (Position[65] and 1 = 1) then
    Position[65] := Position[65] - 1;

  { Check the validity of the Enpassant target. Remove if invalid. }
  Index := Position[64];
  XY := Index div SPR;
  if (FSetupMove.FColor = BLACK) and ((XY <> 2)
  or (Position[Index + SPR] <> BLACK)) then Position[64] := -1;
  if (FSetupMove.FColor = WHITE) and ((XY <> 5)
  or (Position[Index - SPR] <> WHITE)) then Position[64] := -1;

  { Clear the move lists and set the position. }
  FMoveNumber := 0;
  FPGMN := -1;
  FMoveTotal := 0;
  FMainLineMoveNumber := -1;
  FMainLine.Free;
  FMainLine := nil;
  FMoves.DeleteFrom(1);
  TMove(FMoves[0]).Assign(FSetupMove);
  GenerateMoves(0);
  BuildFEN(FSetupMove);
  if Assigned(FOnDrawBoard) then
    FOnDrawBoard(Self, 0, FMoveNumber, daPaintNewBoard);
end;
//______________________________________________________________________________
procedure TCLGame.ClearBoard;
var
  Position: ^TPosition;
  Index: Integer;
begin
  { Clears the FSetupMove.FPosition }
  Position := @FSetupMove.FPosition;
  for Index := Low(TPosition) to High(TPosition) do Position[Index] := 0;

  FBlackScore := 0;
  FWhiteScore := 0;

  if Assigned(FOnDrawBoard) then
    FOnDrawBoard(Self, 0, FMoveNumber, daPaintNewBoard);
end;
//______________________________________________________________________________
procedure TCLGame.ClearMarkers;
begin
  if FMarkers.Count > 0 then
    begin
      FMarkers.DeleteFrom(0);
      if Assigned(FOnMarkerRemoved) then FOnMarkerRemoved(Self);
    end;
end;
//______________________________________________________________________________
function TCLGame.GetPGN(const MoveNumber: Integer): string;
begin
  Result := '';
  if (MoveNumber > 0) and (MoveNumber <= FMoveTotal) then
    Result := TMove(FMoves[MoveNumber]).FPGN;
end;
//______________________________________________________________________________
function TCLGame.IsLegal(const From, _To: Integer): TLegalMove;
var
  Move: TLegalMove;
  Index: Integer;
begin
  { Query FLegalMoves to see if the passed squares are in the list }
  Result := nil;
  for Index := 0 to FLegalMoves.Count - 1 do
    begin
      Move := TLegalMove(FLegalMoves[Index]);
      if (Move.FFrom = From) and ((Move.FTo = _To) or (_To=-1)) then
        begin
          Result := Move;
          Break;
        end;
    end;
end;
//______________________________________________________________________________
procedure TCLGame.MoveTo(MoveNumber: Integer);
var
  Index: Integer;
begin
  { Moves to a specific position as indicated by the MoveNumber param, from
    the previous position. }
  if MoveNumber > FMoveTotal then MoveNumber := FMoveTotal;
  Index := FMoveNumber;
  FMoveNumber := MoveNumber;
  if FMoveNumber < 0 then FMoveNumber := 0;
  if FRender then
    begin
      GenerateMoves(FMoveNumber);
      if Assigned(FOnDrawBoard) then
        FOnDrawBoard(Self, Index, FMoveNumber, daPaintDiff);
    end;
end;
//______________________________________________________________________________
function TCLGame.OneLegal(const From: Integer): Integer;
var
  Index: Integer;
begin
  { Return -1 if there are multiple _To squares for the From square parameter.
    Return the _To square if there is only one. Use for SmartMove. }
  Result := -1;
  for Index := 0 to FLegalMoves.Count - 1 do
    if TLegalMove(FLegalMoves[Index]).FFrom = From then
      if Result > -1 then
        begin
          Result := -1;
          Exit;
        end
      else
        Result := TLegalMove(FLegalMoves[Index]).FTo;
end;
//______________________________________________________________________________
procedure TCLGame.RemoveMarker(const From, _To: Integer);
var
  _Index: Integer;
begin
  for _Index := FMarkers.Count -1 downto 0 do
    if (TMove(FMarkers[_Index]).FFrom = From) and
    (TMove(FMarkers[_Index]).FTo = _To) then
      FMarkers.Delete(_Index);

  if Assigned(FOnMarkerRemoved) then FOnMarkerRemoved(Self);
end;
//______________________________________________________________________________
procedure TCLGame.Reset;
var
  Move: TMove;
begin
  { Set the game to the standard chess beginning position }
  FLegalMoves.DeleteFrom(0);
  FMarkers.DeleteFrom(0);
  FMoves.DeleteFrom(0);
  if Assigned(FMainLine) then FMainLine.DeleteFrom(0);
  FMainLine.Free;
  FMainLine := nil;

  { Add a starting position }
  Move := TMove.Create;
  Move.FPosition := STARTING_POSITION;
  Move.FColor := BLACK; { Must be the opposite of the color to move. }
  Move.FRM := 0;
  Move.FRP := 0;
  Move.FFrom := 0;
  Move.FTo := 0;
  FMoves.Add(Move);
  {FBlackMSec := 0;}
  FColor := WHITE;
  FMainLineMoveNumber := -1;
  FMoveNumber := 0;
  FMoveTotal := 0;
  FMoveTS := Now;
  FPGMN := -1;
  FRooks.BQS := 0;
  FRooks.BKS := 7;
  FRooks.WQS := 56;
  FRooks.WKS := 63;
  {FWhiteMSec := 0;}
end;
//______________________________________________________________________________
procedure TCLGame.ResetBoard;
var
  Position: ^TPosition;
  Index: Integer;
begin
  { Clears the FSetupMove.FPosition }
  Position := @FSetupMove.FPosition;
  Position^ := STARTING_POSITION;

  FBlackScore := 39;
  FWhiteScore := 39;

  if Assigned(FOnDrawBoard) then
    FOnDrawBoard(Self, 0, FMoveNumber, daPaintNewBoard);
end;
//______________________________________________________________________________
procedure TCLGame.Revert;
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
procedure TCLGame.Takeback(Value: Integer);
begin
  if Value > FMoveTotal then Value := FMoveTotal;
  if FMoveTotal - Value < FMoveNumber then MoveTo(FMoveTotal - Value);
  FMoves.DeleteFrom((FMoveTotal - Value) + 1);
  FMoveTotal := FMoves.Count -1;
  FColor := TMove(FMoves[FMoveTotal]).FColor * REVERSE_COLOR;
  FMoveTS := Now;
end;
//______________________________________________________________________________
function TCLGame.GetColor(const Position: TPosition; const From: integer): shortint;
begin
  if Position[From]>0 then result:=1
  else if Position[From]<0 then result:=-1
  else result:=0;
end;
//______________________________________________________________________________
procedure TCLGame.SetPremove(const From, _To: integer);
var
  n: integer;
begin
  if PremoveIndex(From,_To)<>-1 then exit;
  n:=PremovesCount;
  if n<PremovesMaxCount then inc(n);
  FPremoves[n].FFrom:=From;
  FPremoves[n].FTo:=_To;
  FPremoves[n].FType:=mtNormal;
end;
//______________________________________________________________________________
procedure TCLGame.ClearPremoves;
var
  i: integer;
begin
  for i:=1 to PREMOVE_MAX_COUNT do
    FPremoves[i].FType:=mtIllegal;
end;
//______________________________________________________________________________
function TCLGame.GetPremove(Index: integer): TMove;
begin
  result:=FPremoves[Index];
end;
//______________________________________________________________________________
function TCLGame.PremoveIndex(const From: integer; _To: integer): integer;
var
  i: integer;
begin
  for i:=PREMOVE_MAX_COUNT downto 1 do
    if (FPremoves[i] <> nil) and (FPremoves[i].FType=mtNormal) and (FPremoves[i].FFrom=From)
      and ((FPremoves[i].FTo=_To) or (_To=-1))
    then
      begin
        result:=i;
        exit;
      end;
  result:=-1;
end;
//______________________________________________________________________________
function TCLGame.PremovesMaxCount: integer;
begin
  if fGL.AggressivePremove then result:=PREMOVE_MAX_COUNT
  else result:=1;
end;
//______________________________________________________________________________
function TCLGame.PremovesCount: integer;
begin
  result:=PremovesMaxCount;
  while (result>0) and (FPremoves[result].FType=mtIllegal) do
    dec(result);
end;
//______________________________________________________________________________
function TCLGame.SquareIsPremove(const Square: integer): Boolean;
var
  i: integer;
begin
  for i:=1 to PremovesCount do
    if (Square=FPremoves[i].FFrom) or (Square=FPremoves[i].FTo) then
      begin
        result:=true;
        exit;
      end;
  result:=false;
end;
//______________________________________________________________________________
procedure TCLGame.ClearPremove(const From: integer);
var
  n: integer;
begin
  n:=PremoveIndex(From);
  if n=-1 then exit;
  MovePremoves(n);
end;
//______________________________________________________________________________
procedure TCLGame.MovePremoves(const Num: integer);
var i,cnt: integer;
begin
  cnt:=PremovesCount;
  for i:=Num+1 to cnt do
    begin
      FPremoves[i-1].FFrom:=FPremoves[i].FFrom;
      FPremoves[i-1].FTo:=FPremoves[i].FTo;
    end;
  if cnt<>0 then FPremoves[cnt].FType:=mtIllegal;
end;
//______________________________________________________________________________
function TCLGame.GetNextColor: Integer;
begin
  if MoveNumber=0 then result:=1
  else result:= - TMove(Moves[MoveNumber]).FColor;
end;
//______________________________________________________________________________
function TCLGame.GetPremoveColor: Integer;
var Move: TMove;
begin
  if FPremoves[1].FType=mtIllegal then result:=0
  else begin
    Move := TMove(Moves[MoveNumber]);
    result:=GetColor(Move.FPosition,FPremoves[1].FFrom);
  end;
end;
//______________________________________________________________________________
procedure TCLGame.ClearBadPremoves(const Color: integer);
var
  i: integer;
  Move: TMove;
begin
  for i:=PremovesCount downto 1 do
    if GetColor(TMove(Moves[MoveNumber]).FPosition,FPremoves[i].FFrom)<>Color then
      MovePremoves(i);
end;
//______________________________________________________________________________
procedure TCLGame.SetSwitched(const Value: Boolean);
begin
  if GameMode = gmCLSLive then
    FSwitched := Value;
end;
//______________________________________________________________________________
function TCLGame.UserColor(Name: string): TUserColor;
begin
  if lowercase(Name)=lowercase(WhiteName) then result:=uscWhite
  else if lowercase(Name)=lowercase(BlackName) then result:=uscBlack
  else result:=uscNone;
end;
//______________________________________________________________________________
procedure TCLGame.SetScore(Win, Lost, Draw: integer);
begin
  FScore.Win:=Win;
  FScore.Lost:=Lost;
  FScore.Draw:=Draw;
  FScore.Defined:=true;
  if fCLBoard.GM = Self then
    fCLBoard.ShowGameScore;
end;
//______________________________________________________________________________
function TCLGame.MyGame: Boolean;
begin
  result:= (lowercase(WhiteName) = lowercase(fCLSocket.MyName))
    or (lowercase(BlackName) = lowercase(fCLSocket.MyName));
end;
//______________________________________________________________________________
end.


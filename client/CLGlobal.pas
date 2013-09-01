{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLGlobal;

interface

uses
  Windows, Classes, Forms, Graphics, SysUtils, Dialogs, MMSystem, CLGame, CLConsole, Math, extctrls,
  CLFileLib, CLConst, contnrs;

const
  COLORS_COUNT = 14;

type
  TLogGame = (lgAll, lgMine, lgNone);

  TAdultType = (adtNone, adtChild, adtAdult);

  TColorSchema = class
  public
    Name: string;
    Colors: array [1..COLORS_COUNT] of TColor;
  end;

  TAccount = class(TObject)
  private
    { Private declarations }
    FName: string;
    FLogin: string;
    FPassword: string;
    FServer: string;
    FPort: Integer;
    FProxy: string;
    FCommand: string;

  public
    { Public declarations }
    constructor Create;

    procedure Assign(Source: TObject);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);

  published
    { Published declarations }
    property Name: string read FName write FName;
    property Login: string read FLogin write FLogin;
    property Password: string read FPassword write FPassword;
    property Server: string read FServer write FServer;
    property Port: Integer read FPort write FPort;
    property Proxy: string read FProxy write FProxy;
    property Command: string read FCommand write FCommand;
  end;

  TCommand = class(TObject)
  private
    { Private declarations }
    FCaption: string;
    FCommand: string;
    function GetCommand: string;

  public
    { Public declarations }
    procedure Assign(Source: TObject);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);

  published
    { Published declarations }
    property Caption: string read FCaption write FCaption;
    property Command: string read GetCommand write FCommand;
  end;

  { TCLFont }
  TCLFont = class(TFont)
  private
    { Private declarations }

  public
    { Public declarations }
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);

  published
    { Published declarations }
  end;

type
  TCLGlobal = class(TObject)
  private
    { Private declarations }
    FAccounts: TList;
    FAutoFlag: Boolean;
    FAutoQueen: Boolean;
    FBufferLimit: Integer;
    FClockColor: TColor;
    FConsoleColor: TColor;
    FConsoleTextColor: TColor;
    FConsoleFont: TCLFont;
    FCommands: TList;
    FDarkPiece: TColor;
    FDarkSquare: TColor;
    FDivCenter: Integer;
    FDivLeft: Integer;
    FFilterBlitz: Boolean;
    FFilterBughouse: Boolean;
    FFilterBullet: Boolean;
    FFilterComputer: Boolean;
    FFilterCrazyHouse: Boolean;
    FFilterLoser: Boolean;
    FFilterRated: Boolean;
    FFilterRating: Integer;
    FFilterStandard: Boolean;
    FFilterUnrated: Boolean;
    FFilterWild: Boolean;
    FFrameAttached: Boolean;
    FHighLight: TColor;
    FLightPiece: TColor;
    FLightSquare: TColor;
    FLogGames: TLogGame;
    FMainLeft: Integer;
    FMainHeight: Integer;
    FMainTop: Integer;
    FMainWidth: Integer;
    FMainState: Integer;
    FMuteSounds: Boolean;
    FNotifyAttached: Boolean;
    FEventAttached: Boolean;
    FOpen: Boolean;
    FPGNDirectory: string;
    FPGNFile: string;
    FRemoveOffers: Boolean;
    FSeekColor: Integer;
    FSeekFormula: Boolean;
    FSeekInc: Integer;
    FSeekInitial: string;
    FSeekManual: Boolean;
    FSeekMaximum: Integer;
    FSeekMinimum: Integer;
    FSeekRated: Boolean;
    FSeekType: Integer;
    FSeeksEnabled: Boolean;
    FShowArrows: Boolean;
    FShowCaptured: Boolean;
    FShowCoordinates: Boolean;
    FShowGameDetails: Boolean;
    FShowGameMessages: Boolean;
    FShowLastMove: Boolean;
    FShowLegal: Boolean;
    FSmartMove: Boolean;
    FVersion: Integer;
    FRatingType: integer;
    FUserColorChat: Boolean;
    FSeekRatingAbs: Boolean;
    FPieceSetNumber: integer;
    FMaxPieceSetNumber: integer;
    FCReject: Boolean;
    FShout: Boolean;
    FOrdType: integer;
    FOrdDirection: integer;
    FPremove: Boolean;
    FMoveStyle: integer;
    FPremoveColor: TColor;
    FClickColor: TColor;
    FPremoveStyle: integer;
    FIllegalMoveColor: TColor;
    FLegalMoveColor: TColor;
    FMoveSquare: Boolean;
    FAggressivePremove: Boolean;
    FNotifyColor: TColor;
    FFramesColor: TColor;
    FSeekBlitzColor: TColor;
    FSeekTitleCColor: TColor;
    FSeekStandardColor: TColor;
    FSeekBulletColor: TColor;
    FBoardBackgroundColor: TColor;
    FSeekCrazyColor: TColor;
    FSeekLoosersColor: TColor;
    FSeekFisherColor: TColor;
    FDefaultBackgroundColor: TColor;
    FDrawBoardLines: Boolean;
    FBoardLinesColor: TColor;
    FDivLeft2: Integer;
    FEventColor: TColor;
    FSimulCurrentGameColor: TColor;
    FSimulLeaderGameColor: TColor;
    FRememberPassword: Boolean;
    FPReject: Boolean;
    FSexId: integer;
    FCountryId: integer;
    FAge: integer;
    FEmail: string;
    FThemeSquareIndex: integer;
    FShowLastMoveType: integer;
    FShoutDuringGame: Boolean;
    FRejectWhilePlaying: Boolean;
    FPhotoPlayerList: Boolean;
    FPhotoTournament: Boolean;
    FPhotoGame: Boolean;
    FAudioInputDevice: string;
    FVideoInputDevice: string;
    FBadLagRestrict: Boolean;
    FLoseOnDisconnect: Boolean;
    FTimeEndingLimit: integer;
    FTimeEndingEnabled: Boolean;
    FSeeTourShoutsEveryRound: Boolean;
    FBusyStatus: Boolean;
    FAnnouncementAutoscroll: Boolean;
    FAnnouncementBlinkCount: integer;
    FPublicEmail: Boolean;
    FLanguage: string;
    FColorSchemas: TObjectList;
    FSchemaIndex: integer;
    FBirthday: TDateTime;
    FShowBirthday: Boolean;
    FAutoMatch: Boolean;
    FAutoMatchMaxR: integer;
    FAutoMatchMinR: integer;
    FAllowSeekWhilePlaying: Boolean;

    procedure Clear;

  public
    { Public declarations }
    DivRight: array[0..9] of Integer;
    FontTraits: array[0..12] of TFontTrait;
    Sounds: array[0..SOUND_COUNT-1] of string;
    bmpPieces: TBitMap;
    bmpDarkSquare: TBitMap;
    bmpLightSquare: TBitMap;
    Photo64: TBitMap;

    constructor Create;
    destructor Destroy; override;

    procedure Load;
    procedure PlayCLSound(const ID: Integer);
    procedure Save;
    procedure SaveColorSchemas(F: TFileStream);

    property Accounts: TList read FAccounts;
    property AutoFlag: Boolean read FAutoFlag write FAutoFlag;
    property AutoQueen: Boolean read FAutoQueen write FAutoQueen;
    property BufferLimit: Integer read FBufferLimit write FBufferLimit;
    property ClickColor: TColor read FClickColor write FClickColor;
    property ClockColor: TColor read FClockColor write FClockColor;
    property ConsoleColor: TColor read FConsoleColor write FConsoleColor;
    property ConsoleTextColor: TColor read FConsoleTextColor
      write FConsoleTextColor;
    property ConsoleFont: TCLFont read FConsoleFont write FConsoleFont;
    property Commands: TList read FCommands;
    property CReject: Boolean read FCReject write FCReject;
    property DarkPiece: TColor read FDarkPiece write FDarkPiece;
    property DarkSquare: TColor read FDarkSquare write FDarkSquare;
    property DivCenter: Integer read FDivCenter write FDivCenter;
    property DivLeft: Integer read FDivLeft write FDivLeft;
    property DivLeft2: Integer read FDivLeft2 write FDivLeft2;
    property FilterBlitz: Boolean read FFilterBlitz write FFilterBlitz;
    property FilterBughouse: Boolean read FFilterBughouse write FFilterBughouse;
    property FilterBullet: Boolean read FFilterBullet write FFilterBullet;
    property FilterComputer: Boolean read FFilterComputer write FFilterComputer;
    property FilterCrazyHouse: Boolean read FFilterCrazyHouse write FFilterCrazyHouse;
    property FilterLoser: Boolean read FFilterLoser write FFilterLoser;
    property FilterRated: Boolean read FFilterRated write FFilterRated;
    property FilterRating: Integer read FFilterRating write FFilterRating;
    property FilterStandard: Boolean read FFilterStandard write FFilterStandard;
    property FilterUnrated: Boolean read FFilterUnrated write FFilterUnrated;
    property FilterWild: Boolean read FFilterWild write FFilterWild;
    property FrameAttached: Boolean read FFrameAttached write FFrameAttached;
    property FramesColor: TColor read FFramesColor write FFramesColor;
    property HighLight: TColor read FHighlight write FHighLight;
    property LightPiece: TColor read FLightPiece write FLightPiece;
    property LightSquare: TColor read FLightSquare write FLightSquare;
    property LogGames: TLogGame read FLogGames write FLogGames;
    property MaxPieceSetNumber: integer read FMaxPieceSetNumber write FMaxPieceSetNumber;
    property MuteSounds: Boolean read FMuteSounds write FMuteSounds;
    property MainLeft: Integer read FMainLeft write FMainLeft;
    property MainHeight: Integer read FMainHeight write FMainHeight;
    property MainTop: Integer read FMainTop write FMainTop;
    property MainWidth: Integer read FMainWidth write FMainWidth;
    property MainState: Integer read FMainState write FMainState;
    property MoveStyle: integer read FMoveStyle write FMoveStyle;
    property NotifyAttached: Boolean read FNotifyAttached write FNotifyAttached;
    property EventAttached: Boolean read FEventAttached write FEventAttached;
    property NotifyColor: TColor read FNotifyColor write FNotifyColor;
    property Open: Boolean read FOpen write FOpen;
    property OrdDirection: integer read FOrdDirection write FOrdDirection;
    property OrdType: integer read FOrdType write FOrdType;
    property PieceSetNumber: integer read FPieceSetNumber write FPieceSetNumber;
    property PGNDirectory: string read FPGNDirectory write FPGNDirectory;
    property PGNFile: string read FPGNFile write FPGNFile;
    property Premove: Boolean read FPremove write FPremove;
    property PremoveColor: TColor read FPremoveColor write FPremoveColor;
    property RemoveOffers: Boolean read FRemoveOffers write FRemoveOffers;
    property SeekColor: Integer read FSeekColor write FSeekColor;
    property SeekFormula: Boolean read FSeekFormula write FSeekFormula;
    property SeekInitial: string read FSeekInitial write FSeekInitial;
    property SeekInc: Integer read FSeekInc write FSeekInc;
    property SeekManual: Boolean read FSeekManual write FSeekManual;
    property SeekMaximum: Integer read FSeekMaximum write FSeekMaximum;
    property SeekMinimum: Integer read FSeekMinimum write FSeekMinimum;
    property SeekRated: Boolean read FSeekRated write FSeekRated;
    property SeekType: Integer read FSeekType write FSeekType;
    property SeeksEnabled: Boolean read FSeeksEnabled write FSeeksEnabled;
    property SeekRatingAbs: Boolean read FSeekRatingAbs write FSeekRatingAbs;
    property Shout: Boolean read FShout write FShout;
    property ShowArrows: Boolean read FShowArrows write FShowArrows;
    property ShowCaptured: Boolean read FShowCaptured write FShowCaptured;
    property ShowCoordinates: Boolean
      read FShowCoordinates write FShowCoordinates;
    property ShowGameDetails: Boolean
      read FShowGameDetails write FShowGameDetails;
    property ShowGameMessages: Boolean
      read FShowGameMessages write FShowGameMessages;
    property ShowLastMove: Boolean read FShowLastMove write FShowLastMove;
    property ShowLegal: Boolean read FShowLegal write FShowLegal;
    property SmartMove: Boolean read FSmartMove write FSmartMove;
    property RatingType: integer read FRatingType write FRatingType;
    property UserColorChat: Boolean read FUserColorChat write FUserColorChat;
    property PremoveStyle: integer read FPremoveStyle write FPremoveStyle;
    property MoveSquare: Boolean read FMoveSquare write FMoveSquare;
    property LegalMoveColor: TColor read FLegalMoveColor write FIllegalMoveColor;
    property IllegalMoveColor: TColor read FIllegalMoveColor write FIllegalMoveColor;
    property AggressivePremove: Boolean read FAggressivePremove write FAggressivePremove;
    property DefaultBackgroundColor: TColor read FDefaultBackgroundColor write FDefaultBackgroundColor;
    property BoardBackgroundColor: TColor read FBoardBackgroundColor write FBoardBackgroundColor;
    property SeekBulletColor: TColor read FSeekBulletColor write FSeekBulletColor;
    property SeekBlitzColor: TColor read FSeekBlitzColor write FSeekBlitzColor;
    property SeekStandardColor: TColor read FSeekStandardColor write FSeekStandardColor;
    property SeekLoosersColor: TColor read FSeekLoosersColor write FSeekLoosersColor;
    property SeekFisherColor: TColor read FSeekFisherColor write FSeekFisherColor;
    property SeekCrazyColor: TColor read FSeekCrazyColor write FSeekCrazyColor;
    property SeekTitleCColor: TColor read FSeekTitleCColor write FSeekTitleCColor;
    property DrawBoardLines: Boolean read FDrawBoardLines write FDrawBoardLines;
    property BoardLinesColor: TColor read FBoardLinesColor write FBoardLinesColor;
    property EventColor: TColor read FEventColor write FEventColor;
    property SimulCurrentGameColor: TColor read FSimulCurrentGameColor write FSimulCurrentGameColor;
    property SimulLeaderGameColor: TColor read FSimulLeaderGameColor write FSimulLeaderGameColor;
    property RememberPassword: Boolean read FRememberPassword write FRememberPassword;
    property PReject: Boolean read FPReject write FPReject;
    property Email: string read FEmail write FEmail;
    property CountryId: integer read FCountryId write FCountryId;
    property SexId: integer read FSexId write FSexId;
    property Age: integer read FAge write FAge;
    property ThemeSquareIndex: integer read FThemeSquareIndex write FThemeSquareIndex;
    property ShowLastMoveType: integer read FShowLastMoveType write FShowLastMoveType;
    property ShoutDuringgame: Boolean read FShoutDuringGame write FShoutDuringGame;
    property RejectWhilePlaying: Boolean read FRejectWhilePlaying write FRejectWhilePlaying;
    property PhotoPlayerList: Boolean read FPhotoPlayerList write FPhotoPlayerList;
    property PhotoGame: Boolean read FPhotoGame write FPhotoGame;
    property PhotoTournament: Boolean read FPhotoTournament write FPhotoTournament;
    property VideoInputDevice: string read FVideoInputDevice write FVideoInputDevice;
    property AudioInputDevice: string read FAudioInputDevice write FAudioInputDevice;
    property BadLagRestrict: Boolean read FBadLagRestrict write FBadLagRestrict;
    property LoseOnDisconnect: Boolean read FLoseOnDisconnect write FLoseOnDisconnect;
    property TimeEndingEnabled: Boolean read FTimeEndingEnabled write FTimeEndingEnabled default true;
    property TimeEndingLimit: integer read FTimeEndingLimit write FTimeEndingLimit default 10;
    property SeeTourShoutsEveryRound: Boolean read FSeeTourShoutsEveryRound write FSeeTourShoutsEveryRound;
    property BusyStatus: Boolean read FBusyStatus write FBusyStatus;
    property AnnouncementBlinkCount: integer read FAnnouncementBlinkCount write FAnnouncementBlinkCount;
    property AnnouncementAutoscroll: Boolean read FAnnouncementAutoscroll write FAnnouncementAutoscroll;
    property Language: string read FLanguage write FLanguage;
    property PublicEmail: Boolean read FPublicEmail write FPublicEmail;
    property ColorSchemas: TObjectList read FColorSchemas write FColorSchemas;
    property SchemaIndex: integer read FSchemaIndex write FSchemaIndex;
    property Birthday: TDateTime read FBirthday write FBirthday;
    property ShowBirthday: Boolean read FShowBirthday write FShowBirthday;
    property AutoMatch: Boolean read FAutoMatch write FAutoMatch;
    property AutoMatchMinR: integer read FAutoMatchMinR write FAutoMatchMinR;
    property AutoMatchMaxR: integer read FAutoMatchMaxR write FAutoMatchMaxR;
    property AllowSeekWhilePlaying: Boolean read FAllowSeekWhilePlaying write FAllowSeekWhilePlaying;
  end;

function TimeToRatedType(const Int, Inc: Integer): TRatedType;
procedure CompressImageSpecifiedSize(Bmp: Graphics.TBitmap; AWidth, AHeight: Integer;
 APixelFormat: TPixelFormat);

var
  fGL: TCLGlobal;
  fSquareLib: TCLPngLib;
  fSoundMovesLib: TCLSoundMovesLib;
  ADULT: TAdultType;

procedure GetPieceSet(Num,Size: integer; BitMap: TBitMap);
procedure GetLittlePieceImage(Piece: char; BitMap: TBitMap; Size: integer = 21; ColorWhite: Boolean = true);

implementation

uses
  FileCtrl, CLTerminal, CLMain, PNGUnit, CLLib;

const
  DAT_FILE = 'perpetualchess.dat';
  PGN_FILE = 'perpetualchess.pgn';

var
  SoundsDef: array[0..SOUND_COUNT-1] of string =
    ('logged_in','','challenged','game_started','check','offer_in_game','illegal_move',
     'legal_move','game_result','personal_tell','new_message','invited_to_room',
     'notify_arrived','notify_departed','','clock');

  FontTraitsDef: array[0..12,0..1] of integer =
    ((0,255),(65535,0),(65535,0),(0,65280),(0,65280),
    (0,16711935),(0,16776960),(0,16776960),(0,65280),(0,33023),
    (0,65535),(0,255),(0,65280));

//______________________________________________________________________________
function TimeToRatedType(const Int, Inc: Integer): TRatedType;
var
  Value: Integer;
begin
  Result := rtStandard;

  Value := (Inc div 3) * 2 + Int;

  if (Value < 3) and (Value > -1) then
    Result := rtBullet
  else if (Value >= 3) and (Value < 15) then
    Result := rtBlitz;
end;
//______________________________________________________________________________
{ TAccount }
constructor TAccount.Create;
begin
  FServer := CHESSLINK_SERVER;
  FPort := CHESSLINK_PORT;
end;
//______________________________________________________________________________
procedure TAccount.Assign(Source: TObject);
begin
  Name := TAccount(Source).Name;
  Login := TAccount(Source).Login;
  Password := TAccount(Source).Password;
  Server := TAccount(Source).Server;
  Port := TAccount(Source).Port;
  Proxy := TAccount(Source).Proxy;
  Command := TAccount(Source).Command;
end;
//______________________________________________________________________________
procedure TAccount.LoadFromStream(Stream: TStream);
var
  L: Integer;
  s: string;
begin
  with Stream do
    begin
      Read(L, SizeOf(L));
      SetLength(FName, L);
      Read(FName[1], L);
      Read(L, SizeOf(L));
      SetLength(FLogin, L);
      Read(FLogin[1], L);
      Read(L, SizeOf(L));
      SetLength(FPassword, L);
      Read(FPassword[1], L);
      Read(L, SizeOf(L));
      SetLength(FServer, L);
      Read(FServer[1], L);
      if FServer = 'server1.perpepetualchess.com' then
        FServer:=CHESSLINK_SERVER;
      Read(FPort, SizeOf(FPort));
      if FPort = 1024 then
        FPort:=CHESSLINK_PORT;
      Read(L, SizeOf(L));
      SetLength(FProxy, L);
      Read(FProxy[1], L);
      Read(L, SizeOf(L));
      SetLength(FCommand, L);
      Read(FCommand[1], L);
    end;
  if pos('perpetualchess',lowercase(FServer))>0 then
    FServer:=CHESSLINK_SERVER;
end;
//______________________________________________________________________________
procedure TAccount.SaveToStream(Stream: TStream);
var
  L: Integer;
begin
  with Stream do
    begin
      L := Length(FName);
      Write(L, SizeOf(L));
      Write(FName[1], L);
      L := Length(FLogin);
      Write(L, SizeOf(L));
      Write(FLogin[1], L);
      L := Length(FPassword);
      Write(L, SizeOf(L));
      Write(FPassword[1], L);
      L := Length(FServer);
      Write(L, SizeOf(L));
      Write(FServer[1], L);
      Write(FPort, SizeOf(FPort));
      L := Length(FProxy);
      Write(L, SizeOf(L));
      Write(FProxy[1], L);
      L := Length(FCommand);
      Write(L, SizeOf(L));
      Write(FCommand[1], L);
    end;
end;
//______________________________________________________________________________
{ TCommand }
procedure TCommand.Assign(Source: TObject);
begin
  Caption := TCommand(Source).Caption;
  Command := TCommand(Source).Command;
end;
//______________________________________________________________________________
function TCommand.GetCommand: string;
begin
  result:=FCommand;
  if copy(result,1,6)='/seek ' then begin
    result:=result+Format(' %s %d %d %d %d %s',
      [BoolTo_(fGL.SeekRated,'1','0'),
       fGL.SeekType,
       fGL.SeekColor,
       fGL.SeekMinimum,
       fGL.SeekMaximum,
       BoolTo_(fGL.CReject,'1','0')
      ]);
  end;
end;
//______________________________________________________________________________
procedure TCommand.LoadFromStream(Stream: TStream);
var
  L: Integer;
begin
  with Stream do
    begin
      Read(L, SizeOf(L));
      SetLength(FCaption, L);
      Read(FCaption[1], L);
      Read(L, SizeOf(L));
      SetLength(FCommand, L);
      Read(FCommand[1], L);
    end;
end;
//______________________________________________________________________________
procedure TCommand.SaveToStream(Stream: TStream);
var
  L: Integer;
begin
  with Stream do
    begin
      L := Length(FCaption);
      Write(L, SizeOf(L));
      Write(FCaption[1], L);
      L := Length(FCommand);
      Write(L, SizeOf(L));
      Write(FCommand[1], L);
    end;
end;
//______________________________________________________________________________
procedure TCLFont.LoadFromStream(Stream: TStream);
var
  B: Boolean;
  L: Integer;
  S: string;
begin
  with Stream do
    begin
      Read(L, SizeOf(L));
      Color := L;
      Read(L, SizeOf(L));
      SetLength(S, L);
      Read(S[1], L);
      Name := S;
      Read(L, SizeOf(L));
      Self.Size := L;
      Read(B, SizeOf(B));
      if B then Style := Style + [fsBold];
      Read(B, SizeOf(B));
      if B then Style := Style + [fsItalic];
      Read(B, SizeOf(B));
      //if B then Style := Style + [fsUnderline];
      Read(B, SizeOf(B));
      Style := Style - [fsStrikeout,fsUnderLine];
      //if B then Style := Style + [fsStrikeout];
    end;
end;
//______________________________________________________________________________
procedure TCLFont.SaveToStream(Stream: TStream);
var
  B: Boolean;
  L: Integer;
begin
  with Stream do
    begin
      Write(Color, SizeOf(Color));
      L := Length(Name);
      Write(L, SizeOf(L));
      Write(Name[1], L);
      L := Self.Size;
      Write(L, SizeOf(L));
      B := fsBold in Style;
      Write(B, SizeOf(B));
      B := fsItalic in Style;
      Write(B, SizeOf(B));
      B := fsUnderline in Style;
      Write(B, SizeOf(B));
      B := fsStrikeout in Style;
      Write(B, SizeOf(B));
    end;
end;
//______________________________________________________________________________
constructor TCLGlobal.Create;
var
  Index: Integer;
  name: string;
begin
  FAccounts := TList.Create;
  FCommands := TList.Create;
  bmpPieces := TBitMap.Create;
  bmpLightSquare := TBitMap.Create;
  bmpDarkSquare := TBitMap.Create;
  Photo64 := TBitMap.Create;

  name:=MAIN_DIR+'pieces.png';
  if FileExists(name) then
    ReadBitmapFromPngFile(name,bmpPieces);
  FMaxPieceSetNumber := bmpPieces.Height div (PIECE_BASIC_SIZE*2);

  FConsoleFont := TCLFont.Create;
  FConsoleFont.Name := 'Courier New';
  FConsoleFont.Size := 10;
  { At a minimum the LineTraits need to be created }
  for Index := Low(FontTraits) to High(FontTraits) do
    FontTraits[Index] := TFontTrait.Create;

  FMainWidth := 800;
  FMainHeight := 600;
  FMainState := Ord(wsNormal);
  for Index := Low(DivRight) to High(DivRight) do DivRight[Index] := 70;
  FDivCenter := 20;
  FRatingType := 1;
  FUserColorChat := true;
  FSeekRatingAbs := false;

  Load;
end;
//______________________________________________________________________________
procedure TCLGlobal.Clear;
begin
  while FAccounts.Count > 0 do
    begin
      TAccount(FAccounts[0]).Free;
      FAccounts.Delete(0);
    end;

  while FCommands.Count > 0 do
    begin
      TCommand(FCommands[0]).Free;
      FCommands.Delete(0);
    end;
end;
//______________________________________________________________________________
destructor TCLGlobal.Destroy;
var
  Index: Integer;
begin
  Clear;
  FAccounts.Free;
  FCommands.Free;
  bmpPieces.Free;
  bmpLightSquare.Free;
  bmpDarkSquare.Free;
  Photo64.Free;
  for Index := Low(FontTraits) to High(FontTraits) do FontTraits[Index].Free;
  inherited Destroy;
end;
//______________________________________________________________________________
procedure TCLGlobal.Load;
var
  i, j, Index, Count, Dump, nSeekInitial, nSeekDim: Integer;
  DatPath: string;
  Account: TAccount;
  Command: TCommand;
  F: TFileStream;
begin
  Clear;

  { Get a path to the CFG and DAT files }
  DatPath := ExtractFilePath(ParamStr(0));
  FPieceSetNumber := 1;
  FShout := true;
  FOrdType := 0;
  FOrdDirection := 0;
  FPremove := false;
  FPremoveColor := clPurple;
  FClickColor := clGreen;
  FMoveStyle := 0;
  FPremoveStyle:=PREMOVE_BOTH;
  FMoveSquare:=false;
  FLegalMoveColor:=clGreen;
  FIllegalMoveColor:=clRed;
  FAggressivePremove:=false;
  FFramesColor:=clYellow;
  FNotifyColor:=clYellow;

  FVersion:=6;
  FAutoFlag:=true;
  FAutoQueen:=false;
  FBufferLimit:=0;
  FConsoleColor:=0;
  FConsoleTextColor:=$00FF00;
  FClockColor:=$FFFF00;
  FDarkPiece:=0;
  FDarkSquare:=$C0C0C0;
  FDivCenter:=20;
  FDivLeft:=80;
  FDivLeft2:=40;
  FFilterBlitz:=false;
  FFilterBugHouse:=false;
  FFilterBullet:=false;
  FFilterComputer:=false;
  FFilterCrazyHouse:=false;
  FFilterLoser:=false;
  FFilterRated:=false;
  FFilterRating:=0;
  FFilterStandard:=false;
  FFilterUnrated:=false;
  FFilterWild:=false;
  FFrameAttached:=true;
  FHighLight:=$FF0000;
  FLightPiece:=$FFFFFF;
  FLightSquare:=$E5E5E5;
  FLogGames:=lgAll;
  FMainHeight:=512;
  FMainLeft:=0;
  FMainState:=2;
  FMainTop:=0;
  FMainWidth:=640;
  FMuteSounds:=false;
  FNotifyAttached:=true;
  FEventAttached:=true;
  FOpen:=true;
  FPGNDirectory:=DatPath;
  FPGNFile := DatPath + PGN_FILE;
  FRemoveOffers:=true;
  FSeekColor:=0;
  FSeekFormula:=false;
  FSeekInc:=0;
  //FSeekInitial:='1';
  nSeekInitial:=1;
  FSeekInitial:=IntToStr(nSeekInitial);
  nSeekDim:=0;
  FSeekManual:=false;
  FSeekMaximum:=3000;
  FSeekMinimum:=0;
  FSeekRated:=true;
  FSeeksEnabled:=false;
  FSeekType:=0;
  FShowArrows:=true;
  FShowCaptured:=true;
  FShowCoordinates:=true;
  FShowGameDetails:=false;
  FShowLastMove:=true;
  FShowLegal:=true;
  FSmartMove:=false;
  FDrawBoardLines:=true;
  FBoardLinesColor:=clBlack;

  FramesColor := DefFramesColor;
  NotifyColor := DefNotifyColor;
  EventColor := DefEventColor;
  DefaultBackgroundColor := DefDefaultBackgroundColor;
  BoardBackgroundColor := DefBoardBackgroundColor;
  SeekBulletColor := DefSeekBulletColor;
  SeekBlitzColor := DefSeekBlitzColor;
  SeekStandardColor := DefSeekStandardColor;
  SeekLoosersColor := DefSeekLoosersColor;
  SeekFisherColor := DefSeekFisherColor;
  SeekCrazyColor:= DefSeekCrazyColor;
  SeekTitleCColor:= DefSeekTitleCColor;
  SimulCurrentGameColor:= DefSimulCurrentGameColor;
  SimulLeaderGameColor:= DefSimulLeaderGameColor;
  RememberPassword:=true;
  nSeekDim := 0;
  Preject := false;
  FCountryId := -1;
  FSexId := -1;
  FAge := 0;
  FEmail := '';
  FThemeSquareIndex:=10;
  FShowLastMoveType:=0;
  FShoutDuringGame:=true;
  FRejectWhilePlaying:=true;
  FPhotoPlayerList:=true;
  FPhotoGame:=true;
  FPhotoTournament:=true;
  FVideoInputDevice:=DEVICE_NONE;
  FAudioInputDevice:=DEVICE_NONE;
  FBadLagRestrict:=false;
  FLoseOnDisconnect:=false;
  FTimeEndingEnabled:=true;
  FTimeEndingLimit:=10;
  FSeeTourShoutsEveryRound:=true;
  FAnnouncementBlinkCount:=clTerminal.BLINK_COUNT;
  FAnnouncementAutoscroll:=true;
  FLanguage:='English';
  FPublicEmail:=false;
  FSchemaIndex := 1;
  FBirthday := 0;
  FAutoMatch := true;
  FAutoMatchMinR := 0;
  FAutoMatchMaxR := 3000;
  FAllowSeekWhilePlaying := false;

  for i:=0 to SOUND_COUNT-1 do
    if SoundsDef[i]<>'' then Sounds[i]:=DatPath+SoundsDef[i]+'.wav';

  for i:=0 to 12 do
    begin
      FontTraits[i].BackColor:=FontTraitsDef[i,0];
      FontTraits[i].ForeColor:=FontTraitsDef[i,1];
    end;

  if not FileExists(DatPath + DAT_FILE) then Exit;

  try
    F := TFileStream.Create(DatPath + DAT_FILE, fmOpenRead);
  except
    if Assigned(F) then F.Free;
    Exit;
  end;

  with F do
    try
      Read(FVersion, SizeOf(Version));
      { Current DAT_VERSION is 6 but allow V5 dat files to be read. Only raise
        the exception when the client will seriously break if it reads a particular
        version of a dat file.}
      if FVersion < (DAT_VERSION -1) then raise Exception.Create('Invalid dat file version.');
      Read(FAutoFlag, SizeOf(FAutoFlag));
      Read(FAutoQueen, SizeOf(FAutoQueen));
      Read(FBufferLimit, SizeOf(FBufferLimit));
      Read(FConsoleColor, SizeOf(TColor));
      Read(FConsoleTextColor, SizeOf(TColor));
      Read(FClockColor, SizeOf(FClockColor));
      Read(FDarkPiece, SizeOf(FDarkPiece));
      Read(FDarkSquare, SizeOf(FDarkSquare));
      Read(FDivCenter, SizeOf(FDivCenter));
      Read(FDivLeft, SizeOf(FDivLeft));
      Read(FFilterBlitz, SizeOf(FFilterBlitz));
      Read(FFilterBlitz, SizeOf(FFilterBlitz));
      Read(FFilterBughouse, SizeOf(FFilterBughouse));
      Read(FFilterBullet, SizeOf(FFilterBullet));
      Read(FFilterComputer, SizeOf(FFilterComputer));
      Read(FFilterCrazyHouse, SizeOf(FFilterCrazyHouse));
      Read(FFilterLoser, SizeOf(FFilterLoser));
      Read(FFilterRated, SizeOf(FFilterRated));
      Read(FFilterRating, SizeOf(FFilterRating));
      Read(FFilterRating, SizeOf(FFilterRating));
      Read(FFilterStandard, SizeOf(FFilterStandard));
      Read(FFilterUnrated, SizeOf(FFilterUnrated));
      Read(FFilterWild, SizeOf(FFilterWild));
      Read(FFrameAttached, SizeOf(FFrameAttached));
      Read(FHighLight, SizeOf(FHighLight));
      Read(FLightPiece, SizeOf(FLightPiece));
      Read(FLightSquare, SizeOf(FLightSquare));
      Read(FLogGames, SizeOf(FLogGames));
      Read(FMainHeight, SizeOf(FMainHeight));
      Read(FMainLeft, SizeOf(FMainLeft));
      Read(FMainState, SizeOf(FMainState));
      Read(FMainTop, SizeOf(FMainTop));
      Read(FMainWidth, SizeOf(FMainWidth));
      Read(FMuteSounds, SizeOf(FMuteSounds));
      Read(FNotifyAttached, SizeOf(FNotifyAttached));
      Read(FOpen, SizeOf(FOpen));
      Read(Index, SizeOf(Index));
      SetLength(FPGNDirectory, Index);
      Read(FPGNDirectory[1], Index);
      if (FPGNDirectory = '') or not DirectoryExists(FPGNDirectory) then
        FPGNDirectory := DatPath;
      if Copy(FPGNDirectory, Length(FPGNDirectory), 1) <> '\' then
        FPGNDirectory := FPGNDirectory + '\';
      Read(Index, SizeOf(Index));
      SetLength(FPGNFile, Index);
      Read(FPGNFile[1], Index);
      if (FPGNFile = '') or not FileExists(FPGNFile) then
        FPGNFile := DatPath + PGN_FILE;
      Read(FRemoveOffers, SizeOf(FRemoveOffers));
      Read(FSeekColor, SizeOf(FSeekColor));
      Read(FSeekFormula, SizeOf(FSeekFormula));
      Read(FSeekInc, SizeOf(FSeekInc));
      Read(nSeekInitial, SizeOf(nSeekInitial));
      Read(FSeekManual, SizeOf(FSeekManual));
      Read(FSeekMaximum, SizeOf(FSeekMaximum));
      Read(FSeekMinimum, SizeOf(FSeekMinimum));
      Read(FSeekRated, SizeOf(FSeekRated));
      Read(FSeeksEnabled, SizeOf(FSeeksEnabled));
      Read(FSeeksEnabled, SizeOf(FSeeksEnabled));
      Read(FSeekType, SizeOf(FSeekType));
      Read(FShowArrows, SizeOf(FShowArrows));
      Read(FShowCaptured, SizeOf(FShowCaptured));
      Read(FShowCoordinates, SizeOf(FShowCoordinates));
      Read(FShowGameDetails, SizeOf(FShowGameDetails));
      Read(FShowLastMove, SizeOf(FShowLastMove));
      Read(FShowLegal, SizeOf(FShowLegal));
      Read(FSmartMove, SizeOf(FSmartMove));
      { Accounts }
      Read(Count, SizeOf(Count));
      for Index := 0 to Count -1 do
        begin
          Account := TAccount.Create;
          Account.LoadFromStream(F);
          FAccounts.Add(Account);
        end;
      { Commands }
      Read(Count, SizeOf(Count));
      for Index := 0 to Count -1 do
        begin
          Command := TCommand.Create;
          Command.LoadFromStream(F);
          FCommands.Add(Command);
        end;
      { Dividers }
      for Index := Low(DivRight) to High(DivRight) do
        Read(DivRight[Index], SizeOf(DivRight[Index]));

      { FontTraits }
      FConsoleFont.LoadFromStream(f);
      Read(Count, SizeOf(Count));
      for Index := 0 to Count do FontTraits[Index].LoadFromStream(F);

      { Sounds }
      Read(Count, SizeOf(Count));
      for Index := Low(Sounds) to Count do
        begin
          Read(Count, SizeOf(Count));
          SetLength(Sounds[Index], Count);
          Read(Sounds[Index][1], Count);
        end;
      Read(FRatingType, SizeOf(FRatingType));
      Read(FUserColorChat, SizeOf(FUserColorChat));
      //Read(FSeekRatingAbs, SizeOf(FSeekRatingAbs));
      Read(FPieceSetNumber, SizeOf(FPieceSetNumber));
      Read(FCReject, SizeOf(FCReject));
      Read(FShout, SizeOf(FShout));
      Read(FOrdType, SizeOf(FOrdType));
      Read(FOrdDirection, SizeOf(FOrdDirection));
      Read(FPremove, SizeOf(FPremove));
      Read(FPremoveColor, SizeOf(FPremoveColor));
      Read(FClickColor, SizeOf(FClickColor));
      Read(FMoveStyle, SizeOf(FMoveStyle));
      Read(FPremoveStyle,SizeOf(FPremoveStyle));
      Read(FIllegalMoveColor,SizeOf(FIllegalMoveColor));
      Read(FLegalMoveColor,SizeOf(FLegalMoveColor));
      Read(FMoveSquare,SizeOf(FMoveSquare));
      Read(FAggressivePremove,SizeOf(FAggressivePremove));

      Read(FFramesColor,sizeof(FFramesColor));
      Read(FNotifyColor,sizeof(FNotifyColor));
      Read(FDefaultBackgroundColor,sizeof(FDefaultBackgroundColor));
      Read(FBoardBackgroundColor,sizeof(FBoardBackgroundColor));
      Read(FSeekBulletColor,sizeof(FSeekBulletColor));
      Read(FSeekBlitzColor,sizeof(FSeekBlitzColor));
      Read(FSeekStandardColor,sizeof(FSeekStandardColor));
      Read(FSeekLoosersColor,sizeof(FSeekLoosersColor));
      Read(FSeekFisherColor,sizeof(FSeekFisherColor));
      Read(FSeekCrazyColor,sizeof(FSeekCrazyColor));
      Read(FSeekTitleCColor,sizeof(FSeekTitleCColor));
      Read(FDrawBoardLines,sizeof(FDrawBoardLines));
      Read(FBoardLinesColor,sizeof(FBoardLinesColor));
      Read(FDivLeft2,sizeof(FDivLeft2));
      Read(FEventAttached,sizeof(FEventAttached));
      Read(FEventColor,sizeof(FEventColor));
      Read(FSimulCurrentGameColor,sizeof(FSimulCurrentGameColor));
      Read(FRememberPassword,sizeof(FRememberPassword));
      Read(nSeekDim, SizeOf(nSeekDim));
      Read(FPReject, SizeOf(FPReject));
      Read(Index, SizeOf(Index));
      SetLength(FEmail, Index);
      Read(FEmail[1], Index);
      Read(FCountryId, SizeOf(FCountryId));
      Read(FSexId, SizeOf(FSexId));
      Read(FAge, SizeOf(FAge));
      Read(FThemeSquareIndex, SizeOf(FThemeSquareIndex));
      Read(FShowLastMoveType, SizeOf(FShowLastMoveType));
      Read(FShoutDuringGame, SizeOf(FShoutDuringGame));
      Read(FRejectWhilePlaying, SizeOf(FRejectWhilePlaying));
      Read(FPhotoPlayerList, SizeOf(FPhotoPlayerList));
      Read(FPhotoGame, SizeOf(FPhotoGame));
      Read(FPhotoTournament, SizeOf(FPhotoTournament));
      Read(Count,SizeOf(Count));
      SetLength(FVideoInputDevice,Count);
      Read(FVideoInputDevice[1],Count);
      Read(Count,SizeOf(Count));
      SetLength(FAudioInputDevice,Count);
      Read(FAudioInputDevice[1],Count);
      Read(FBadLagRestrict,SizeOf(FBadLagRestrict));
      Read(FLoseOnDisconnect,SizeOf(FLoseOnDisconnect));
      Read(FTimeEndingEnabled,SizeOf(FTimeEndingEnabled));
      Read(FTimeEndingLimit,SizeOf(FTimeEndingLimit));
      Read(FSeeTourShoutsEveryRound,SizeOf(FSeeTourShoutsEveryRound));
      Read(FBusyStatus,SizeOf(FBusyStatus));
      Read(FAnnouncementBlinkCount,SizeOf(FAnnouncementBlinkCount));
      Read(FAnnouncementAutoscroll,SizeOf(FAnnouncementAutoscroll));
      Read(Count,SizeOf(Count));
      SetLength(FLanguage,Count);
      Read(FLanguage[1],Count);
      Read(FPublicEmail,SizeOf(FPublicEmail));
      Read(FSchemaIndex,SizeOf(FSchemaIndex));
      Read(FBirthday, SizeOf(FBirthday));
      Read(FShowBirthday, SizeOf(FShowBirthday));
      Read(FAutoMatch, SizeOf(FAutoMatch));
      Read(FAutoMatchMinR, SizeOf(FAutoMatchMinR));
      Read(FAutoMatchMaxR, SizeOf(FAutoMatchMaxR));
      Read(FAllowSeekWhilePlaying, SizeOf(FAllowSeekWhilePlaying));
    finally
      F.Free;
      if FCommands.Count=0 then begin
        Command:=TCommand.Create;
        Command.FCaption:='Seek Blitz';
        Command.FCommand:='/seek 5 0';
        FCommands.Add(Command);

        Command:=TCommand.Create;
        Command.FCaption:='Seek Standard';
        Command.FCommand:='/seek 20 0';
        FCommands.Add(Command);

        Command:=TCommand.Create;
        Command.FCaption:='Open to match requests';
        Command.FCommand:='/set open 1';
        FCommands.Add(Command);

        Command:=TCommand.Create;
        Command.FCaption:='Closed to match requests';
        Command.FCommand:='/set open 0';
        FCommands.Add(Command);

        Command:=TCommand.Create;
        Command.FCaption:='-';
        Command.FCommand:='-';
        FCommands.Add(Command);

        Command:=TCommand.Create;
        Command.FCaption:='Exit';
        Command.FCommand:='/bye';
        FCommands.Add(Command);

      end;

      if ThemeSquareIndex<>-1 then begin
        if ThemeSquareIndex>=fSquareLib.Schemas.Count then
          ThemeSquareIndex:=-1
        else begin
          fSquareLib.ReadBitMap('light',ThemeSquareIndex,bmpLightSquare);
          fSquareLib.ReadBitMap('dark',ThemeSquareIndex,bmpDarkSquare);
        end;
      end;

      if nSeekDim=0 then FSeekInitial:=IntToStr(nSeekInitial)
      else FSeekInitial:='0.'+IntToStr(nSeekInitial);
    end;
end;
//______________________________________________________________________________
procedure TCLGlobal.PlayCLSound(const ID: Integer);
begin
  if (Sounds[ID] <> '') and (not FMuteSounds) then
    PlaySound(PChar(Sounds[ID]), 0, snd_ASYNC);
end;
//______________________________________________________________________________
procedure TCLGlobal.Save;
var
  Index, Count, nSeekInitmin, nSeekInitSec, nSeekInitTime, nSeekDim, n: Integer;
  DatPath: string;
  F: TFileStream;
begin
  { Get a path to the CFG and DAT files }
  DatPath := ExtractFilePath(ParamStr(0)) + DAT_FILE;

  TimeToComponents(FSeekInitial,nSeekInitmin,nSeekInitSec,nSeekDim);
  if nSeekDim = 0 then nSeekInitTime := nSeekInitMin
  else nSeekInitTime := nSeekInitMin * 60 + nSeekInitSec;

  try
    F := TFileStream.Create(DatPath, fmCreate);
  except
    if Assigned(F) then F.Free;
    Exit;
  end;

  FVersion := DAT_VERSION;
  with F do
    try
      Write(FVersion, SizeOf(FVersion));
      Write(FAutoFlag, SizeOf(FAutoFlag));
      Write(FAutoQueen, SizeOf(FAutoQueen));
      Write(FBufferLimit, SizeOf(FBufferLimit));
      Write(FConsoleColor, SizeOf(TColor));
      Write(FConsoleTextColor, SizeOf(TColor));
      Write(FClockColor, SizeOf(FClockColor));
      Write(FDarkPiece, SizeOf(FDarkPiece));
      Write(FDarkSquare, SizeOf(FDarkSquare));
      Write(FDivCenter, SizeOf(FDivCenter));
      Write(FDivLeft, SizeOf(FDivLeft));
      Write(FFilterBlitz, SizeOf(FFilterBlitz));
      Write(FFilterBlitz, SizeOf(FFilterBlitz));
      Write(FFilterBughouse, SizeOf(FFilterBughouse));
      Write(FFilterBullet, SizeOf(FFilterBullet));
      Write(FFilterComputer, SizeOf(FFilterComputer));
      Write(FFilterCrazyHouse, SizeOf(FFilterCrazyHouse));
      Write(FFilterLoser, SizeOf(FFilterLoser));
      Write(FFilterRated, SizeOf(FFilterRated));
      Write(FFilterRating, SizeOf(FFilterRating));
      Write(FFilterRating, SizeOf(FFilterRating));
      Write(FFilterStandard, SizeOf(FFilterStandard));
      Write(FFilterUnrated, SizeOf(FFilterUnrated));
      Write(FFilterWild, SizeOf(FFilterWild));
      Write(FFrameAttached, SizeOf(FFrameAttached));
      Write(FHighLight, SizeOf(FHighLight));
      Write(FLightPiece, SizeOf(FLightPiece));
      Write(FLightSquare, SizeOf(FLightSquare));
      Write(FLogGames, SizeOf(FLogGames));
      Write(FMainHeight, SizeOf(FMainHeight));
      Write(FMainLeft, SizeOf(FMainLeft));
      Write(FMainState, SizeOf(FMainState));
      Write(FMainTop, SizeOf(FMainTop));
      Write(FMainWidth, SizeOf(FMainWidth));
      Write(FMuteSounds, SizeOf(FMuteSounds));
      Write(FNotifyAttached, SizeOf(FNotifyAttached));
      Write(FOpen, SizeOf(FOpen));
      Index := Length(FPGNDirectory);
      Write(Index, SizeOf(Index));
      Write(FPGNDirectory[1], Index);
      Index := Length(FPGNFile);
      Write(Index, SizeOf(Index));
      Write(FPGNFile[1], Index);
      Write(FRemoveOffers, SizeOf(FRemoveOffers));
      Write(FSeekColor, SizeOf(FSeekColor));
      Write(FSeekFormula, SizeOf(FSeekFormula));
      Write(FSeekInc, SizeOf(FSeekInc));
      Write(nSeekInitTime, SizeOf(nSeekInitTime));
      Write(FSeekManual, SizeOf(FSeekManual));
      Write(FSeekMaximum, SizeOf(FSeekMaximum));
      Write(FSeekMinimum, SizeOf(FSeekMinimum));
      Write(FSeekRated, SizeOf(FSeekRated));
      Write(FSeeksEnabled, SizeOf(FSeeksEnabled));
      Write(FSeeksEnabled, SizeOf(FSeeksEnabled));
      Write(FSeekType, SizeOf(FSeekType));
      Write(FShowArrows, SizeOf(FShowArrows));
      Write(FShowCaptured, SizeOf(FShowCaptured));
      Write(FShowCoordinates, SizeOf(FShowCoordinates));
      Write(FShowGameDetails, SizeOf(FShowGameDetails));
      Write(FShowLastMove, SizeOf(FShowLastMove));
      Write(FShowLegal, SizeOf(FShowLegal));
      Write(FSmartMove, SizeOf(FSmartMove));
      { Accounts }
      Count := FAccounts.Count;
      Write(Count, SizeOf(Count));
      for Index := 0 to Count -1 do TAccount(FAccounts[Index]).SaveToStream(F);
      { Commands }
      Count := FCommands.Count;
      Write(Count, SizeOf(Count));
      for Index := 0 to Count -1 do TCommand(FCommands[Index]).SaveToStream(F);
      { Dividers }
      for Index := Low(DivRight) to High(DivRight) do
        Write(DivRight[Index], SizeOf(DivRight[Index]));
      { Fonts }
      FConsoleFont.SaveToStream(f);
      Count := High(FontTraits);
      Write(Count, SizeOf(Count));
      for Index := Low(FontTraits) to High(FontTraits) do
        FontTraits[Index].SaveToStream(F);

      { Sounds }
      Count := High(Sounds);
      Write(Count, SizeOf(Count));
      for Index := Low(Sounds) to Count do
        begin
          Count := Length(Sounds[Index]);
          Write(Count, SizeOf(Count));
          Write(Sounds[Index][1], Count);
        end;
      Write(FRatingType,SizeOf(FRatingType));
      Write(FUserColorChat,SizeOf(FUserColorChat));
      Write(FPieceSetNumber,SizeOf(FPieceSetNumber));
      Write(FCReject, SizeOf(FCReject));
      Write(FShout, SizeOf(FShout));
      Write(FOrdType, SizeOf(FOrdType));
      Write(FOrdDirection, SizeOf(FOrdDirection));
      Write(FPremove, SizeOf(FPremove));
      Write(FPremoveColor, SizeOf(FPremoveColor));
      Write(FClickColor, SizeOf(FClickColor));
      Write(FMoveStyle, SizeOf(FMoveStyle));
      Write(FPremoveStyle,SizeOf(FPremoveStyle));
      Write(FIllegalMoveColor,SizeOf(FIllegalMoveColor));
      Write(FLegalMoveColor,SizeOf(FLegalMoveColor));
      Write(FMoveSquare,SizeOf(FMoveSquare));
      Write(FAggressivePremove,SizeOf(FAggressivePremove));
      {FSeekRatingAbs:=true;
      Write(FSeekRatingAbs,SizeOf(Boolean));}
      Write(FFramesColor,sizeof(FFramesColor));
      Write(FNotifyColor,sizeof(FNotifyColor));
      Write(FDefaultBackgroundColor,sizeof(FDefaultBackgroundColor));
      Write(FBoardBackgroundColor,sizeof(FBoardBackgroundColor));
      Write(FSeekBulletColor,sizeof(FSeekBulletColor));
      Write(FSeekBlitzColor,sizeof(FSeekBlitzColor));
      Write(FSeekStandardColor,sizeof(FSeekStandardColor));
      Write(FSeekLoosersColor,sizeof(FSeekLoosersColor));
      Write(FSeekFisherColor,sizeof(FSeekFisherColor));
      Write(FSeekCrazyColor,sizeof(FSeekCrazyColor));
      Write(FSeekTitleCColor,sizeof(FSeekTitleCColor));
      Write(FDrawBoardLines,sizeof(FDrawBoardLines));
      Write(FBoardLinesColor,sizeof(FBoardLinesColor));
      Write(FDivLeft2,sizeof(FDivLeft2));
      Write(FEventAttached,sizeof(FEventAttached));
      Write(FEventColor,sizeof(FEventColor));
      Write(FSimulCurrentGameColor,sizeof(FSimulCurrentGameColor));
      Write(FRememberPassword,sizeof(FRememberPassword));
      Write(nSeekDim,sizeof(nSeekDim));
      Write(FPReject, SizeOf(FPReject));
      index:=length(FEmail);
      Write(index,SizeOf(index));
      Write(FEmail,index);
      Write(FCountryId, SizeOf(FCountryId));
      Write(FSexId, SizeOf(FSexId));
      Write(FAge, SizeOf(FAge));
      Write(FThemeSquareIndex, SizeOf(FThemeSquareIndex));
      Write(FShowLastMoveType, SizeOf(FShowLastMoveType));
      Write(FShoutDuringGame, SizeOf(FShoutDuringGame));
      Write(FRejectWhilePlaying, SizeOf(FRejectWhilePlaying));
      Write(FPhotoPlayerList, SizeOf(FPhotoPlayerList));
      Write(FPhotoGame, SizeOf(FPhotoGame));
      Write(FPhotoTournament, SizeOf(FPhotoTournament));
      Count:=length(FVideoInputDevice);
      Write(Count,SizeOf(Count));
      Write(FVideoInputDevice[1],Count);
      Count:=length(FAudioInputDevice);
      Write(Count,SizeOf(Count));
      Write(FAudioInputDevice[1],Count);
      Write(FBadLagRestrict,SizeOf(FBadLagRestrict));
      Write(FLoseOnDisconnect,SizeOf(FLoseOnDisconnect));
      Write(FTimeEndingEnabled,SizeOf(FTimeEndingEnabled));
      Write(FTimeEndingLimit,SizeOf(FTimeEndingLimit));
      Write(FSeeTourShoutsEveryRound,SizeOf(FSeeTourShoutsEveryRound));
      Write(FBusyStatus,SizeOf(FBusyStatus));
      Write(FAnnouncementBlinkCount,SizeOf(FAnnouncementBlinkCount));
      Write(FAnnouncementAutoscroll,SizeOf(FAnnouncementAutoscroll));
      Count:=Length(FLanguage);
      Write(Count,SizeOf(Count));
      Write(FLanguage[1],Count);
      Write(FPublicEmail,SizeOf(FPublicEmail));
      Write(FSchemaIndex,SizeOf(FSchemaIndex));
      Write(FBirthday, SizeOf(FBirthday));
      Write(FShowBirthday, SizeOf(FShowBirthday));
      Write(FAutoMatch, SizeOf(FAutoMatch));
      Write(FAutoMatchMinR, SizeOf(FAutoMatchMinR));
      Write(FAutoMatchMaxR, SizeOf(FAutoMatchMaxR));
      Write(FAllowSeekWhilePlaying, SizeOf(FAllowSeekWhilePlaying));
      //SaveColorSchemas(F);
    finally
      F.Free;
    end;
end;
//______________________________________________________________________________
procedure CompressImageSpecifiedSize(Bmp: Graphics.TBitmap; AWidth, AHeight: Integer;
 APixelFormat: TPixelFormat);
var
 TempBmp: Graphics.TBitmap;
 AX: Real;
 AY: Real;
 Compress: Real;
begin
{$ifdef ControlStack}
 try
{$endif ControlStack}
 TempBmp := Graphics.TBitmap.Create;
 TempBmp.PixelFormat := APixelFormat;
 TempBmp.Canvas.Lock;
 AX := Bmp.Width / AWidth;
 AY := Bmp.Height / AHeight;
 if AX > AY then
   Compress := AX
 else
   Compress := AY;
 if Compress > 1 then
 begin
   TempBmp.Width := Max(1, Round(Bmp.Width / Compress));
   TempBmp.Height := Max(1, Round(Bmp.Height / Compress));
 end
 else
 begin
   TempBmp.Width := Bmp.Width;
   TempBmp.Height := Bmp.Height;
 end;
 SetStretchBltMode(TempBmp.Canvas.Handle, HALFTONE);
 SetBrushOrgEx(TempBmp.Canvas.Handle, 0, 0, nil);
 StretchBlt(TempBmp.Canvas.Handle, 0, 0, TempBmp.Width, TempBmp.Height,
   Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, SRCCOPY);
 Bmp.Width := TempBmp.Width;
 Bmp.Height := TempBmp.Height;
 Bmp.Canvas.Draw(0, 0, TempBmp);
 Bmp.PixelFormat := APixelFormat;
 TempBmp.Canvas.Lock;
 TempBmp.Free;
{$ifdef ControlStack}
 except
   on E: Exception do
   begin
     ReRaiseException(E, 1547);
     raise;
   end;
 end;
{$endif ControlStack}
end;
//_______________________________________________________________________________
procedure GetPieceSet(Num,Size: integer; BitMap: TBitMap);
var
  rect1,rect2: TRect;
begin
  if (Num-1)*2*PIECE_BASIC_SIZE>fGL.bmpPieces.Height then
    Num:=0;
  if Num=0 then begin
    BitMap.LoadFromResourceName(HInstance,'P'+Lpad(IntToStr(Size),3,'0'));
  end else begin
    rect1:=Rect(0,0,6*PIECE_BASIC_SIZE-1,2*PIECE_BASIC_SIZE-1);
    rect2:=Rect(0,(Num-1)*2*PIECE_BASIC_SIZE,6*PIECE_BASIC_SIZE-1,Num*2*PIECE_BASIC_SIZE-1);
    BitMap.Width:=rect1.right-rect1.left+1;
    BitMap.Height:=rect1.bottom-rect1.top+1;
    BitMap.Canvas.CopyRect(rect1,fGL.bmpPieces.canvas,rect2);
    BitMap.TransparentMode:=tmFixed;
    BitMap.TransparentColor:=0;
    CompressImageSpecifiedSize(BitMap,Size*6, Size*2,pf32bit);
  end;
end;
//______________________________________________________________________________
procedure GetLittlePieceImage(Piece: char; BitMap: TBitMap; Size: integer = 21; ColorWhite: Boolean = true);
var
  n, k, Num: integer;
  bmp: TBitMap;
  img: TImage;
  rect1,rect2: TRect;
begin
  case Piece of
    'P': n:=0;
    'N': n:=1;
    'B': n:=2;
    'R': n:=3;
    'Q': n:=4;
    'K': n:=5;
  end;
  Num:=1;
  bmp:=TBitMap.Create;
  bmp.Width:=21*6;
  bmp.Height:=21*2;
  bmp.LoadFromResourceName(HInstance,'P021');

  k := BoolTo_(ColorWhite, 0, 21);
  rect1:=Rect(0,0,Size-1,Size-1);
  rect2:=Rect(n*21,0+k,n*21+20,20+k);
  BitMap.Width:=Size;
  BitMap.Height:=Size;
  BitMap.Canvas.CopyRect(rect1,bmp.canvas,rect2);
  {rect1:=Rect(0,0,PIECE_BASIC_SIZE-1,PIECE_BASIC_SIZE-1);
  rect2:=Rect(n*PIECE_BASIC_SIZE,0,(n+1)*PIECE_BASIC_SIZE-1,PIECE_BASIC_SIZE-1);

  BitMap.Width:=PIECE_BASIC_SIZE;
  BitMap.Height:=PIECE_BASIC_SIZE;

  BitMap.Canvas.CopyRect(rect1,fGL.bmpPieces.canvas,rect2);
  BitMap.TransparentMode:=tmFixed;
  BitMap.TransparentColor:=0;
  CompressImageSpecifiedSize(BitMap,21,21,pf24bit);}
end;
//______________________________________________________________________________
procedure TCLGlobal.SaveColorSchemas(F: TFileStream);
var
  i,j,n: integer;
  schema: TColorSchema;
begin
  exit;
  with F do begin
    Write(ColorSchemas.Count,SizeOf(ColorSchemas.Count));
    n := COLORS_COUNT;
    Write(n,SizeOf(n));
    for i:=0 to ColorSchemas.Count-1 do begin
      schema := TColorSchema(ColorSchemas[i]);
      n:=length(schema.Name);
      Write(n,sizeof(n));
      Write(schema.Name,n);
      for j:=1 to COLORS_COUNT do
        Write(schema.Colors[j],SizeOf(schema.Colors[j]));
    end;
  end;
end;
//______________________________________________________________________________
end.

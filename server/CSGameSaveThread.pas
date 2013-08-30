{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSGameSaveThread;

interface

uses
  Classes, SysUtils, CSConst, CSGame, ADOInt, ActiveX, CLOfferOdds, Variants;

type
  TGameSaveThread = class(TThread)
  private
    { Private declarations }
    GM: TGame;
    FBlackID: Integer;
    FBlackMSec: Integer;
    FBlackRating: Integer;
    FDate: string;
    FEvent: string;
    FFEN: string;
    FGameResult: TGameResult;
    FWhiteIncMSec: Integer;
    FWhiteInitialMSec: Integer;
    FBlackIncMSec: Integer;
    FBlackInitialMSec: Integer;
    FMoves: TList;
    FRated: Boolean;
    FRatedType: TRatedType;
    FRound: Integer;
    FSite: string;
    FWhiteID: Integer;
    FWhiteMSec: Integer;
    FWhiteRating: Integer;
    ErrMsg: string;
    FOdds: TOfferOdds;
    FStartTime: TDateTime;
    FEndTime: TDateTime;
    FTimeOddsScoreDeviation: integer;

    procedure Assign(const Game: TGame);

  protected
    { Protected declarations }
    procedure Execute; override;

  published
    { Published declarations }
    constructor Create(var Game: TGame);
  public
    GameId: integer;
    procedure Terminate(Sender: TObject);
  end;

implementation

uses CSLib;

{ TGameSaveThread }
//______________________________________________________________________________
procedure TGameSaveThread.Assign(const Game: TGame);
var
  Move: TMove;
  Index: Integer;
begin
  { Make a thread safe copy of the game header information. }
  GM:=Game;
  with Game do
    begin
      FBlackID := BlackId; //Black.LoginID;
      FBlackMSec := BlackMSec;
      FBlackRating := BlackRating;
      FDate := Game.Date;
      FEvent := Event;
      FFEN := FEN;
      FGameResult := GameResult;
      FWhiteIncMSec := WhiteIncMSec;
      FWhiteInitialMSec := WhiteInitialMSec;
      FBlackIncMSec := BlackIncMSec;
      FBlackInitialMSec := BlackInitialMSec;
      FRated := Rated;
      FRatedType := RatedType;
      FRound := Round;
      FSite := Site;
      FWhiteID := WhiteId; //White.LoginID;
      FWhiteMSec := WhiteMSec;
      FWhiteRating := WhiteRating;
      FStartTime := StartTime;
      FEndTime := EndTime;
      FTimeOddsScoreDeviation := TimeOddsScoreDeviation;
    end;

  { Make a thread safe copy of all the moves. }
  FMoves := TList.Create;
  for Index := 0 to Game.Moves.Count -1 do begin
    Move := TMove.Create;
    Move.Assign(Game.Moves[Index]);
    FMoves.Add(Move);
  end;

  FOdds := TOfferOdds.Create;
  FOdds.CopyFrom(Game.Odds);
end;
//______________________________________________________________________________
procedure TGameSaveThread.Execute;
const
  PROC_ADDGAME = 'dbo.proc_GameHeaderAdd';
  PROC_ADDMOVE = 'dbo.proc_GameMoveAdd';
  PROC_ECOUPDATE = 'dbo.proc_GameECOUpdate';
var
  oCon: _Connection;
  oCmd: _Command;
  RecsAffected: OleVariant;
  Move: TMove;
  Index: Integer;
begin
  try
    try
    //errlog('Save thread executed',nil);
    CoInitializeEx(nil, COINIT_MULTITHREADED);
    //errlog('Coinitialized',nil);
    { Connection to the DB }
    oCon := CoConnection.Create;
    with oCon do begin
      ConnectionString := DB_PROVIDER;
      ConnectionTimeout := 10;
      Open('', '', '', -1);
    end;
    //errlog('oCon created',nil);
    oCmd := CoCommand.Create;
    //errlog('oCmd created',nil);
    { Save to the GameHeaders table. }
    with oCmd do begin
      Set_ActiveConnection(oCon);
      CommandType := adCmdStoredProc;
      CommandText := PROC_ADDGAME;
      Parameters.Refresh;
      Parameters[1].Value := FBlackID;
      Parameters[2].Value := FBlackMSec;
      Parameters[3].Value := FBlackRating;
      Parameters[4].Value := FDate;
      Parameters[5].Value := FEvent;
      Parameters[6].Value := FFEN;
      Parameters[7].Value := FWhiteInitialMSec;
      Parameters[8].Value := FWhiteIncMSec;
      Parameters[9].Value := FRated;
      Parameters[10].Value := Ord(FRatedType);
      Parameters[11].Value := Ord(FGameResult);
      Parameters[12].Value := FRound;
      Parameters[13].Value := FSite;
      Parameters[14].Value := FWhiteID;
      Parameters[15].Value := FWhiteMSec;
      Parameters[16].Value := FWhiteRating;
      Parameters[17].Value := FBlackInitialMSec;
      Parameters[18].Value := FBlackIncMSec;
      Parameters[19].Value := FStartTime;
      Parameters[20].Value := FEndTime;
      //errlog('oCmd assigned',nil);
      Execute(RecsAffected, EmptyParam, adCmdStoredProc);
      //errlog('Header stored',nil);
      GameID := Parameters[0].Value;
    end;

    { If the header saved then save the moves and determine ECO. }
    if GameID > -1 then begin
      with oCmd do begin
        CommandText := PROC_ADDMOVE;
        Parameters.Refresh;
      end;
        { Moves }
      for Index := 1 to FMoves.Count -1 do begin
        Move := FMoves[Index];
        with oCmd do begin
          Parameters[1].Value := GameID;
          Parameters[2].Value := Index;
          Parameters[3].Value := Move.FFrom;
          Parameters[4].Value := Move.FTo;
          if Move.FType = mtPromotion then
            Parameters[5].Value := Move.FPosition[Move.FTo]
          else
            Parameters[5].Value := 0;
          Parameters[6].Value := Ord(Move.FType);
          Parameters[7].Value := Move.FPGN;
          Parameters[8].Value := Move.FMSec2;
          Execute(RecsAffected, EmptyParam, adCmdStoredProc);
        end;
      end;
      { ECO }
      with oCmd do begin
        CommandText := PROC_ECOUPDATE;
        Parameters.Refresh;
        Parameters[1].Value := GameID;
        Execute(RecsAffected, EmptyParam, adCmdStoredProc);
      end;

      if FOdds.Defined or FOdds.FAutoTimeOdds then
        with oCmd do begin
          CommandText := 'dbo.proc_GameOdds';
          Parameters.Refresh;
          Parameters[1].Value := GameID;
          Parameters[2].Value := BoolTo_(FOdds.FAutoTimeOdds,'1','0');
          Parameters[3].Value := FOdds.FInitMin;
          Parameters[4].Value := FOdds.FInitSec;
          Parameters[5].Value := FOdds.FInc;
          Parameters[6].Value := FOdds.FPiece;
          Parameters[7].Value := ord(FOdds.FTimeDirection);
          Parameters[8].Value := ord(FOdds.FPieceDirection);
          Parameters[9].Value := ord(FOdds.FInitiator);
          Parameters[10].Value := FTimeOddsScoreDeviation;
          Execute(RecsAffected, EmptyParam, adCmdStoredProc);
        end;
    end;

    except
      on E:Exception do
        ErrMsg:=E.Message;
    end;

  finally
    oCmd := nil;
    if oCon.State = adStateOpen then oCon.Close;
    oCon := nil;
    //CoUnInitialize;
  end;
  { Free the Moves }
  while FMoves.Count > 0 do
    begin
      TMove(FMoves[0]).Free;
      FMoves.Delete(0);
    end;
  FMoves.Free;
end;
//______________________________________________________________________________
constructor TGameSaveThread.Create(var Game: TGame);
begin
  Assign(Game);
  //Game := nil;
  FreeOnTerminate := false;
  OnTerminate:=Terminate;
  inherited Create(False);
end;
//______________________________________________________________________________
procedure TGameSaveThread.Terminate(Sender: TObject);
begin
  try
    GM.DbGameId := GameID;
    if ErrMsg<>'' then
      errlog('GameSaveThread: '+ErrMsg,nil);
  except
  end;
end;
//______________________________________________________________________________
end.

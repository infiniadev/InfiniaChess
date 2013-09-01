{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLLecture;

interface

uses Forms,Controls,CLEvents,Classes,CSReglament,SysUtils,CLGame,CLAccept;

type
  TCSLecture = class(TCSEvent)
  public
    procedure OnGameBorn(Game: TCLGame); override;
  end;

implementation

uses CLMain, CLSocket;

{ TCSLecture }
//==========================================================================
procedure TCSLecture.OnGameBorn(Game: TCLGame);
begin
  if Game.WhiteName = fCLSocket.MyName then Game.GameMode := gmCLSExamine
  else Game.GameMode := gmCLSObserve;
  AddGame(Game);
  if not fCLMain.GameIsActive(game) then
    fCLMain.SetActivePane(0, game);
end;
//==========================================================================
end.

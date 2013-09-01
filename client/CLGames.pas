{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLGames;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, ExtCtrls, StdCtrls, CLConst, Menus;

type
  TGamesHeader = (ghIndex, ghWhiteName, ghWhiteRating, ghBlackName,
    ghBlackRating, ghRatedType, ghTime, ghRated, ghResult, ghLocked);

  TCLListGame = class(TObject)
    FIndex: Integer;
    FWhiteName: string;
    FWhiteTitle: string;
    FWhiteRating: Integer;
    FBlackName: string;
    FBlackTitle: string;
    FBlackRating: Integer;
    FRatedType: string;
    //FInitialMSec: Integer;
    //FIncMSec: Integer;
    FWhiteInitialMSec: Integer;
    FWhiteIncMSec: Integer;
    FBlackInitialMSec: Integer;
    FBlackIncMSec: Integer;
    FRated: Integer;
    FResult: string;
    FLocked: Integer;
  end;

  TfCLGames = class(TForm)
    bvlHeader: TBevel;
    lblGames: TLabel;
    lvGames: TListView;
    miGamesObserve: TMenuItem;
    pmGames: TPopupMenu;
    sbMax: TSpeedButton;
    lblGames2: TLabel;
    miObserveHigh: TMenuItem;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lvGamesClick(Sender: TObject);
    procedure lvGamesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvGamesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvGamesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvGamesDblClick(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);
    procedure miGamesObserveClick(Sender: TObject);
    procedure miObserveHighClick(Sender: TObject);

  private
    { Private declarations }
    FColumnToSort: TGamesHeader;
    FReverseSort: Boolean;

    procedure SetMenuState;

  public
    { Public declarations }
    procedure Clear;
    procedure GameLock(const Datapack: TStrings);
    procedure GamePerish(const Datapack: TStrings);
    procedure GameResult(const Datapack: TStrings);
    procedure Games(const Datapack: TStrings);
    procedure GamesBegin;
    procedure GamesEnd;
  end;

var
  fCLGames: TfCLGames;

implementation

uses CLMain, CLNavigate, CLSocket, CLLib;

{$R *.DFM}

//______________________________________________________________________________
procedure TfCLGames.SetMenuState;
begin
  miGamesObserve.Enabled := (lvGames.Selected <> nil);
  if miGamesObserve.Enabled then miGamesObserve.Enabled := not Boolean(TCLListGame(lvGames.Selected.Data).FLocked);
  { Synce the menu items on the Main form. }
  fCLMain.miObserveGame.Enabled := miGamesObserve.Enabled;
  fCLMain.tbObserveGame.Visible := miGamesObserve.Enabled;
end;
//______________________________________________________________________________
procedure TfCLGames.Clear;
var
  Index: Integer;
begin
  { Free data associated with a listview item. Then remove the Items }
  for Index := 0 to lvGames.Items.Count -1 do
    TCLListGame(lvGames.Items[Index].Data).Free;

  with lvGames.Items do
    begin
      BeginUpdate;
      Clear;
      EndUpdate;
    end;
end;
//______________________________________________________________________________
{ DP_GAME_LOCK: DP#, GameNumber/ID, Locked (1=yes, 0=no)}
procedure TfCLGames.GameLock(const Datapack: TStrings);
var
  Item: TListItem;
begin
  { Attempt to find the Game in the games list }
  Item := lvGames.FindCaption(0, Datapack[1], False, True, True);
  { If found change the data and list view item. }
  if Item <> nil then
    begin
      TCLListGame(Item.Data).FLocked := StrToInt(Datapack[2]);
      if TCLListGame(Item.Data).FLocked = 1 then
        Item.SubItems[8] := 'Yes'
      else
        Item.SubItems[8] := 'No';
    end;
end;
//______________________________________________________________________________
{ DP_GAME_PERISH: DP#, GameNumber }
procedure TfCLGames.GamePerish(const Datapack: TStrings);
var
  Item: TListItem;
begin
  { Attempt to find the Game. }
  Item := lvGames.FindCaption(0, Datapack[1], False, True, True);
  { If found change the data and list view item. }
  if Item <> nil then
    begin
      TCLListGame(Item.Data).Free;
      Item.Free;
    end;
end;
//______________________________________________________________________________
{ DP_GAME_RESULT: DP#, GameNumber, ResultCode }
procedure TfCLGames.GameResult(const Datapack: TStrings);
var
  Item: TListItem;
begin
  { Attempt to find the Game. }
  Item := lvGames.FindCaption(0, Datapack[1], False, True, True);
  { If found change the data and list view item. }
  if Item <> nil then
    begin
      TCLListGame(Item.Data).FResult := RESULTCODES[StrToInt(Datapack[2])];
      Item.SubItems[7] := RESULTCODES[StrToInt(Datapack[2])];
    end;
end;
//______________________________________________________________________________
{ DP_GAME: DP#, GameNumber/ID,
  WhiteName, WhiteTitle, WhiteRating,
  BlackName, BlackTitle, BlackRating,
  RatedType, InitialMSec, IncMSec, Rated, ResultCode, Locked }
procedure TfCLGames.Games(const Datapack: TStrings);
var
  Item: TListItem;
  CLGame: TCLListGame;
  name: string;
begin
  { Create a TCLGames. }
  CLGame := TCLListGame.Create;
  with CLGame do
    begin
      FIndex := StrToInt(Datapack[1]);
      FWhiteName := Datapack[2];
      FWhiteTitle := Datapack[3];
      FWhiteRating := StrToInt(Datapack[4]);
      FBlackName := Datapack[5];
      FBlackTitle := Datapack[6];
      FBlackRating := StrToInt(Datapack[7]);
      FRatedType := RATED_TYPES[StrToInt(Datapack[8])];
      FWhiteInitialMSec := StrToInt(Datapack[9]);
      FWhiteIncMSec := StrToInt(Datapack[10]);
      FRated := Abs(StrToInt(Datapack[11]));
      FResult := RESULTCODES[StrToInt(Datapack[12])];
      FLocked := Abs(StrToInt(Datapack[13]));
      if Datapack.Count>15 then begin
        FBlackInitialMSec:=StrToInt(Datapack[14]);
        FBlackIncMSec:=StrToInt(Datapack[15]);
      end else begin
        FBlackInitialMSec:=FWhiteInitialMSec;
        FBlackIncMSec:=FWhiteIncMSec;
      end;
    end;
  { Create a new ListView entry. }
  Item := lvGames.Items.Add;
  with Item do
    begin
      Data := CLGame;
      ImageIndex := Tag;
      Caption := Datapack[1];
      SubItems.Add(GetNameWithTitle(Datapack[2],Datapack[3]));
      SubItems.Add(Datapack[4]);
      SubItems.Add(GetNameWithTitle(Datapack[5],Datapack[6]));
      SubItems.Add(Datapack[7]);
      SubItems.Add(CLGame.FRatedType);
      SubItems.Add(MSecToGridStr(CLGame.FWhiteInitialMSec,CLGame.FWhiteIncMSec));
      if CLGame.FRated = 1 then
        SubItems.Add('Yes')
      else
        SubItems.Add('No');
      SubItems.Add(RESULTCODES[StrToInt(Datapack[12])]);
      if CLGame.FLocked = 1 then
        SubItems.Add('Yes')
      else
        SubItems.Add('No');
    end;
end;
//______________________________________________________________________________
{ DP_GAME_BEGIN: DP# ListType, Message }
procedure TfCLGames.GamesBegin;
begin
  Clear;
  SetMenuState;
  lvGames.Items.BeginUpdate;
end;
//______________________________________________________________________________
{ DP_GAMES_END: DP# }
procedure TfCLGames.GamesEnd;
begin
  lvGames.Items.EndUpdate;
end;
//______________________________________________________________________________
procedure TfCLGames.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Clear;
  fCLGames := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLGames.FormCreate(Sender: TObject);
begin
  FReverseSort := False;
end;
//______________________________________________________________________________
procedure TfCLGames.lvGamesClick(Sender: TObject);
begin
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLGames.lvGamesColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  { Prepare to call custom sort }
  FReverseSort := not FReverseSort;
  FColumnToSort := TGamesHeader(Column.Index);
  lvGames.CustomSort(nil, 0);
end;
//______________________________________________________________________________
procedure TfCLGames.lvGamesCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  CLGame1, CLGame2: TCLListGame;
begin
  CLGame1 := TCLListGame(Item1.Data);
  CLGame2 := TCLListGame(Item2.Data);

  case FColumnToSort of
    ghIndex:
      Compare := CLGame1.FIndex - CLGame2.FIndex;
    ghWhiteName:
      Compare := AnsiCompareText(CLGame1.FWhiteName, CLGame2.FWhiteName);
    ghWhiteRating:
      Compare := CLGame1.FWhiteRating - CLGame2.FWhiteRating;
    ghBlackName:
      Compare := AnsiCompareText(CLGame1.FBlackName, CLGame2.FBlackName);
    ghBlackRating:
      Compare := CLGame1.FBlackRating - CLGame2.FBlackRating;
    ghRatedType:
      Compare := AnsiCompareText(CLGame1.FRatedType, CLGame2.FRatedType);
    ghTime:
      Compare := ((CLGame1.FWhiteIncMSec div 3) * 2 + CLGame1.FWhiteInitialMSec) -
        ((CLGame2.FWhiteIncMSec div 3) * 2 + CLGame2.FWhiteInitialMSec);
    ghRated:
      Compare := CLGame1.FRated - CLGame2.FRated;
    ghResult:
      Compare := AnsiCompareText(CLGame1.FResult, CLGame2.FResult);
    ghLocked:
      Compare := CLGame1.FLocked - CLGame2.FLocked;
  end;

  if FReverseSort then Compare := -Compare;
end;
//______________________________________________________________________________
procedure TfCLGames.lvGamesDblClick(Sender: TObject);
begin
  if lvGames.Selected <> nil then miGamesObserve.Click;
end;
//______________________________________________________________________________
procedure TfCLGames.lvGamesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLGames.miGamesObserveClick(Sender: TObject);
begin
  { Send the command to the server. }
  if lvGames.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_OBSERVE + #32 + lvGames.Selected.Caption]);
end;
//______________________________________________________________________________
procedure TfCLGames.sbMaxClick(Sender: TObject);
begin
  Self.SetFocus;
  fCLMain.miMaximizeTop.Click;
end;
//______________________________________________________________________________
procedure TfCLGames.miObserveHighClick(Sender: TObject);
var
  GM, GMRes: TCLListGame;
  i,max: integer;
  itm: TListItem;
begin
  if lvGames.Items.Count = 0 then exit;
  max:=0;
  for i:=0 to lvGames.Items.Count-1 do begin
    itm:=lvGames.Items[i];
    GM:=TCLListGame(itm.Data);
    if (GM.FResult = '-') and (GM.FWhiteRating > max) then begin
      GMRes:=GM;
      max:=GM.FWhiteRating;
    end;
    if (GM.FResult = '-') and (GM.FBlackRating > max) then begin
      GMRes:=GM;
      max:=GM.FBlackRating;
    end;
  end;
  if GMRes <> nil then
    fCLSocket.InitialSend([CMD_STR_OBSERVE,IntToStr(GMRes.FIndex)]);
end;
//______________________________________________________________________________
end.

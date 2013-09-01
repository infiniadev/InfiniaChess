{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLPGNLib;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, CLSocket, Menus, Registry, Buttons, ExtCtrls, StdCtrls;

type
  TPGNHeader = (phIndex, phWhiteName, phWhiteRating, phBlackName, phBlackRating,
    phSite, phEvent, phRound, phResult, phECO, phDate);

  { Used to store PGN Tag Data }
  PGame = ^TGame;
  TGame = record
    Index: Integer;
    Event: string;
    Date: string;
    WhiteName: string;
    WhiteRating: Integer;
    BlackName: string;
    BlackRating: Integer;
    ECO: string;
    GameLoc: Integer;
    Site: string;
    Round: Integer;
    Result: string;
  end;

  TfCLPGNLib = class(TForm)
    bvlHeader: TBevel;
    lblPGNFilePath: TLabel;    
    lblPGNLibrary: TLabel;
    lblPGNLibrary2: TLabel;    
    lvPGNLib: TListView;
    miClear: TMenuItem;
    miLoadGame: TMenuItem;
    miOpen: TMenuItem;
    N1: TMenuItem;
    odPGN: TOpenDialog;
    pmPGNLib: TPopupMenu;
    sbMax: TSpeedButton;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lvPGNLibClick(Sender: TObject);
    procedure lvPGNLibColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure lvPGNLibData(Sender: TObject; Item: TListItem);
    procedure lvPGNLibDblClick(Sender: TObject);
    procedure lvPGNLibSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miClearClick(Sender: TObject);
    procedure miLoadGameClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);

  private
    { Private declarations }
    FColumnToSort: TPGNHeader;
    FGames: TList;
    FReverseSort: Boolean;

    procedure SetMenuState;
    procedure ShowLibrary;

  public
    { Public declarations }
    procedure Clear;
    procedure LoadPGNFile(const PGNFile: string);
  end;

function GameSort(Item1, Item2: Pointer): Integer;

var
  fCLPGNLib: TfCLPGNLib;

implementation

uses
  CLBoard, CLConst, CLGame, CLGlobal, CLMain, CLNavigate, CLPgn, CLTerminal,
  CLConsole;

const
  EMPTY = -1;
  SPLAT = -2;
  HYPHEN = -3;
  QUESTION = -4;

{$R *.DFM}

//______________________________________________________________________________
function GameSort(Item1, Item2: Pointer): Integer;
var
  Game1, Game2: ^TGame;
begin
  Game1 := Item1;
  Game2 := Item2;

  case fCLPGNLib.FColumnToSort of
    phIndex:
      Result := Game1^.Index - Game2^.Index;
    phWhiteName:
      Result := AnsiCompareText(Game1^.WhiteName, Game2^.WhiteName);
    phWhiteRating:
      Result := Game1^.WhiteRating - Game2^.WhiteRating;
    phBlackName:
      Result := AnsiCompareText(Game1^.BlackName, Game2^.BlackName);
    phBlackRating:
      Result := Game1^.BlackRating - Game2^.BlackRating;
    phSite:
      Result := AnsiCompareText(Game1^.Site, Game2^.Site);
    phEvent:
      Result := AnsiCompareText(Game1^.Event, Game2^.Event);
    phRound:
      Result := Game1^.Round - Game2^.Round;
    phResult:
      Result := AnsiCompareText(Game1^.Result, Game2^.Result);
    phECO:
      Result := AnsiCompareText(Game1^.ECO, Game2^.ECO);
    phDate:
      Result := AnsiCompareText(Game1^.Date, Game2^.Date);
  end;

  if fCLPGNLib.FReverseSort then Result := -Result;
end;
//______________________________________________________________________________
function StrToIntFailSafe(const Value: string): Integer;
var
  E: Integer;
begin
  Val(Value, Result, E);

  if E <> 0 then
    begin
      if Value = '' then Result := EMPTY
      else if Value = '*' then Result := SPLAT
      else if Value = '-' then Result := HYPHEN
      else Result := QUESTION;
    end;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.SetMenuState;
begin
  miLoadGame.Enabled := lvPGNLib.SelCount > 0;
  fCLMain.miLoadGame.Enabled := lvPGNLib.SelCount > 0;
  fCLMain.tbLoadGame.Visible := lvPGNLib.SelCount > 0;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.ShowLibrary;
var
  Index: Integer;
begin
  { Have fCLNavigate make this form active & visible }
  if Self.Visible then Exit;
  with fCLNavigate do
    begin
      Index := clNavigate.Items.IndexOfObject(Self);
      clNavigate.ItemIndex := Index;
      clNavigate.OnClick(nil);
    end;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.Clear;
var
  Index: Integer;
begin
  { Dispose of (memory) data associated with a listview item.
   Then remove the Items }
  for Index := FGames.Count -1 downto 0 do Dispose(PGame(FGames[Index]));
  FGames.Clear;
  FGames.Capacity := 0;

  with lvPGNLib do
    begin
      Items.Count := 0;
      Invalidate;
    end;
  lblPGNFilePath.Caption := '';
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.LoadPGNFile(const PGNFile: string);
var
  PGN: TCLPgn;
  Game: PGame;
begin
  Screen.Cursor := crHourGlass;

  ShowLibrary;

  Clear; { Clear should follow setting of LibraryType }

  lblPGNFilePath.Caption := PGNFile;

  PGN := TCLPgn.Create(PGNFile, pmRead);
  while not PGN.EOPF do
    begin
      New(Game);
      with Game^ do
        begin
          Index := PGN.GameNo;
          Event := PGN.Tag('event');
          Date := PGN.Tag('date');
          WhiteName := PGN.Tag('white');
          WhiteRating := StrToIntFailSafe(PGN.Tag('whiteelo'));
          if WhiteRating = EMPTY then
            WhiteRating := StrToIntFailSafe(PGN.Tag('whitecrx'));
          BlackName := PGN.Tag('black');
          BlackRating := StrToIntFailSafe(PGN.Tag('blackelo'));
          if BlackRating = EMPTY then
            BlackRating := StrToIntFailSafe(PGN.Tag('blackcrx'));
          ECO := PGN.Tag('eco');
          Result := PGN.Tag('result');
          GameLoc := PGN.GameLoc;
          Site := PGN.Tag('site');
          Round := StrToIntFailSafe(PGN.Tag('round'));
        end;
      FGames.Add(Game);
      PGN.MoveNext;
    end;
  PGN.Free;
  lvPGNLib.Items.Count := FGames.Count;
  lvPGNLib.Refresh;

  Screen.Cursor := crDefault;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Clear;
  FGames.Free;
  fCLPGNLib := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.FormCreate(Sender: TObject);
begin
  FGames := TList.Create;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.lvPGNLibClick(Sender: TObject);
begin
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.lvPGNLibColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  { Prepare to call custom sort }
  FReverseSort := not FReverseSort;
  FColumnToSort := TPGNHeader(Column.Index);
  FGames.Sort(GameSort);
  lvPGNLib.Refresh;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.lvPGNLibData(Sender: TObject; Item: TListItem);
var
  Game: PGame;

function CodeToStr(const Value: Integer): string;
begin
  case Value of
    EMPTY: Result := '';
    SPLAT: Result := '*';
    HYPHEN: Result := '-';
    QUESTION: Result := '?';
    else Result := IntToStr(Value);
  end;
end;

begin
  Game := FGames[Item.Index];

  with Item do
    begin
      ImageIndex := Tag;
      Caption := IntToStr(Game^.Index);
      SubItems.Add(Game^.WhiteName);
      SubItems.Add(CodeToStr(Game^.WhiteRating));
      SubItems.Add(Game^.BlackName);
      SubItems.Add(CodeToStr(Game^.BlackRating));
      SubItems.Add(Game^.Site);
      SubItems.Add(Game^.Event);
      SubItems.Add(CodeToStr(Game^.Round));
      SubItems.Add(Game^.Result);
      SubItems.Add(Game^.ECO);
      SubItems.Add(Game^.Date);
    end;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.lvPGNLibDblClick(Sender: TObject);
begin
  if lvPGNLib.Selected <> nil then miLoadGame.Click;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.lvPGNLibSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.miClearClick(Sender: TObject);
begin
  Clear;
end;
//______________________________________________________________________________
procedure TfCLPGNLib.miLoadGameClick(Sender: TObject);
var
  Item: TListItem;
  GameInstance: TCLGame;
  PGN: TCLPgn;
begin
  Item := lvPGNLib.Selected;
  if Item = nil then Exit;

  Screen.Cursor := crHourGlass;

  try
    GameInstance := fCLBoard.CreateGame;
    PGN := TCLPgn.Create(lblPGNFilePath.Caption, pmRead);
    PGN.Seek(TGame(FGames[Item.Index]^).GameLoc);
    with GameInstance do
      begin
        WhiteName := PGN.Tag('white');
        WhiteRating := PGN.Tag('whiteelo');
        if WhiteRating = '' then WhiteRating := PGN.Tag('whitecrx');
        BlackName := PGN.Tag('black');
        BlackRating := PGN.Tag('blackelo');
        if BlackRating = '' then BlackRating := PGN.Tag('blackcrx');
        GameResult := PGN.Tag('result');
        if not (PGN.Tag('fen') = '') then
          begin
            fCLTerminal.ccConsole.AddLine(0, 'Loading FEN: ' + PGN.Tag('fen'), ltServerMsgNormal);
            FEN := PGN.Tag('fen');
          end;
        PGN.FirstMove;
        Render := False;
        while not PGN.EOPM do
          begin
            AddPGN(PGN.PGN);
            PGN.NextMove;
          end;
        Render := True;
      end;
    fCLNavigate.AddGame(GameInstance);
  except
    if Assigned(GameInstance) then GameInstance.Free;
    if Assigned(PGN) then PGN.Free;
  end;

  if Assigned(PGN) then PGN.Free;

  Screen.Cursor := crDefault;

end;
//______________________________________________________________________________
procedure TfCLPGNLib.miOpenClick(Sender: TObject);
begin
  if not fCLSocket.Rights.PgnLibrary then begin
    MessageDlg('Your membership has ended. You cannot use PGN Library.',
      mtWarning, [mbOk], 0);
    exit;
  end;
  if odPgn.InitialDir = '' then odPgn.InitialDir := fGL.PGNDirectory;
  if odPgn.Execute then LoadPGNFile(odPGN.FileName);
end;
//______________________________________________________________________________
procedure TfCLPGNLib.sbMaxClick(Sender: TObject);
begin
  Self.SetFocus;
  fCLMain.miMaximizeTop.Click;
end;
//______________________________________________________________________________
end.

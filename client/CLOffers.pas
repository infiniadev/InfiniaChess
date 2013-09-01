{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLOffers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ComCtrls, ExtCtrls, IniFiles, Menus, CLGame, ImgList,
  CLOfferOdds, CLConst, CLLib;

type
  TOffer = class(TObject)
  private
    function GetInitMin: integer;
    function GetInitSec: integer;
    function GetMyInc: integer;
    function GetMyInitMin: integer;
    function GetMyInitSec: integer;
    function GetOpInc: integer;
    function GetOpInitMin: integer;
    function GetOpInitSec: integer;
    function GetMyTimeString: string;
    function GetOpTimeString: string;
    function GetMyTimeStringFull: string;
    function GetOpTimeStringFull: string;
    function GetPieceString: string;
    function GetMyDeviation: integer;
  public
    FAssignedCell: Integer;
    FColor: Integer;
    FInitialTime: string;
    FIncTime: Integer;
    FIssuer: string;
    FIssuerTitle: string;
    FIssuee: string;
    FOfferNumber: Integer;
    FOfferType: TOfferType;
    FProvisional: Boolean;
    FRated: Boolean;
    FRating: Integer;
    FRatingType: TRatedType;
    FLoseOnDisconnect: Boolean;
    FGamesCnt: integer;
    FOdds: TOfferOdds;
    FRect: TRect;
    FIssuerMembershipType: TMembershipType;
    constructor Create;
    procedure GetRatingChanges(var RW, RL, RD: integer); // how much rating will be changed in the case of win, loss or draw
    procedure GetRatingChangesFinal(var RW, RL, RD: integer);
    function FixedTimeOddsSet: Boolean;
    function FullInitSec: integer;
    procedure CountAutoTimeOdds(var OddsInitFullSec, OddsInc, OddsDeviation: integer);
    function DifferentTime: Boolean;
    function MyTimeIsOdds: Boolean;
    function IHaveMoreTime: Boolean;
    function IsAchievementOffer: Boolean;

    property InitMin: integer read GetInitMin;
    property InitSec: integer read GetInitSec;
    property MyInitMin: integer read GetMyInitMin;
    property MyInitSec: integer read GetMyInitSec;
    property MyInc: integer read GetMyInc;
    property MyTimeString: string read GetMyTimeString;
    property MyTimeStringFull: string read GetMyTimeStringFull;
    property OpInitMin: integer read GetOpInitMin;
    property OpInitSec: integer read GetOpInitSec;
    property OpInc: integer read GetOpInc;
    property OpTimeString: string read GetOpTimeString;
    property OpTimeStringFull: string read GetOpTimeStringFull;
    property MyDeviation: integer read GetMyDeviation;
    property PieceString: string read GetPieceString;
  end;

type
  TfCLOffers = class(TForm)
    lblSeeks: TLabel;
    lblSeeks2: TLabel;
    miAccept: TMenuItem;
    miDecline: TMenuItem;
    miProfile: TMenuItem;
    miRemove: TMenuItem;
    pmPlayerMenu: TPopupMenu;
    pnlHeader: TPanel;
    sbMax: TSpeedButton;
    miScore: TMenuItem;
    pnlHint: TPanel;
    Image: TImage;
    il17: TImageList;
    pmSeek: TPopupMenu;
    Rated1: TMenuItem;
    CrazyHouse1: TMenuItem;
    FischerRandom1: TMenuItem;
    Losers1: TMenuItem;
    Rated2: TMenuItem;
    RatedTimeOdds1: TMenuItem;
    Unrated1: TMenuItem;
    UnratedTimeOdds1: TMenuItem;
    RatedGame1: TMenuItem;
    RatedTimeOdds2: TMenuItem;
    UnratedGame1: TMenuItem;
    UnratedTimeOdds2: TMenuItem;
    RatedGame2: TMenuItem;
    RatedTimeOdds3: TMenuItem;
    UnratedGame2: TMenuItem;
    UnratedTimeOdds3: TMenuItem;
    RatedGame3: TMenuItem;
    RatedTimeOdds4: TMenuItem;
    UnratedGame3: TMenuItem;
    UnratedTimeOdds4: TMenuItem;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miAcceptClick(Sender: TObject);
    procedure miDeclineClick(Sender: TObject);
    procedure miProfileClick(Sender: TObject);    
    procedure miRemoveClick(Sender: TObject);
    procedure pmPlayerMenuPopup(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);
    procedure miScoreClick(Sender: TObject);
    procedure pnlHintMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pmSeekItemCilck(Sender: TObject);
    procedure pmSeekPopup(Sender: TObject);

  private
  { Private declarations }
    FCellArea: TRect;
    FCellCapacity: Integer;
    FCellCols: Integer;
    FCellHeight: Integer;
    FCellIndex: Integer;
    FCellRows: Integer;
    FCells: array[0..143] of TObject;
    FCellWidth: Integer;
    FOffer: TOffer;
    FOfferList: TList;
    FLastPopupButton: TToolButton;

    function AssignCell(var Offer: TOffer): Boolean;
    function FindOffer(OfferNumber: Integer): TOffer;
    function GetCellFromXY(var X, Y: Integer): Integer;
    function GetEmptyCell: Integer;
    function GetXYFromCell(var Cell: Integer): TPoint;

    procedure AssignCells;
    procedure DrawOffer(var Offer: TOffer);
    procedure SetCapacity;
    procedure WMEraseBkgnd(var Msg: TMessage); message WM_ERASEBKGND;
    procedure ShowHint(Offer: TOffer);

  public
  { Public declarations }
    procedure Clear;
    procedure ReceiveOffer(var Datapack: TStrings);
    procedure RemoveOffer(_OfferNumber: Integer);
  end;

var
  fCLOffers: TfCLOffers;

implementation

{$R *.DFM}
uses
  CLGlobal, CLMain, CLSocket, CLTerminal, CLConsole, CLRating, CLLogins;

var sPieces: array[0..4] of string = ('pawn','knight','bishop','rook','queen');
//==============================================================================
function TfCLOffers.AssignCell(var Offer: TOffer): Boolean;
begin
  { This function assigns a cell number to a Offer. The cell number is where
    on the grid to draw a Offer. }
  with Offer do
    begin
      FAssignedCell := GetEmptyCell;
      if FAssignedCell = -1 then
        Result := False
      else
        begin
          Result := True;
          FCells[FAssignedCell] := Offer;
        end;
    end;
end;
//==============================================================================
function TfCLOffers.FindOffer(OfferNumber: Integer): TOffer;
var
  Index: Integer;
begin
  { Find the Offer in the OfferList }
  Result := nil;
  for Index := 0 to FOfferList.Count - 1 do
    begin
      Result := TOffer(FOfferList[Index]);
      if Result.FOfferNumber = OfferNumber then
        Break
      else
        Result := nil;
    end;
end;
//==============================================================================
function TfCLOffers.GetCellFromXY(var X, Y: Integer): Integer;
begin
  { Called from Mouse events. Returns the Cell number that the mouse is over }
  if (Y < FCellArea.Top) or(X >= FCellCols * FCellWidth + FCellArea.Left)
    then Result := -1
  else
    begin
      X := (X - FCellArea.Left) div FCellWidth;
      Y := (Y - FCellArea.Top) div FCellHeight;
      Result := Y * FCellCols + X;
    end;
end;
//==============================================================================
function TfCLOffers.GetEmptyCell: Integer;
var
  Index: Integer;
begin
  { Returns the next empty cell if available. It is possible that the form has
    been sized so small that the number of Offers in FOffers exceeds
    FCellCapacity, in which case there are probably no empty cells. }
  Result := -1;
  { Work forward from the last empty cell found to the end of the cell grid }
  for Index := 0{FCellIndex} to FCellCapacity do
    if FCells[Index] = nil then
      begin
        Result := Index;
        FCellIndex := Index + 1;
        if FCellIndex > FCellCapacity then FCellIndex := 0;
        Exit;
      end;

  { Work from the beginning of the grid to the the last empty cell found }
  for Index := 0 to FCellIndex - 1 do
    if FCells[Index] = nil then
      begin
        Result := Index;
        FCellIndex := Index + 1;
        if FCellIndex > FCellCapacity then FCellIndex := 0;
        Exit;
      end;
end;
//==============================================================================
function TfCLOffers.GetXYFromCell(var Cell: Integer): TPoint;
begin
  { Based on a cell number, determine just where to draw the post }
  Result.Y := Trunc(Cell / FCellCols);
  if Result.Y = 0 then
    Result.X := Cell * FCellWidth + FCellArea.Left
  else
    Result.X := (Cell - (Result.Y * FCellCols)) * FCellWidth  + FCellArea.Left;
  Result.Y := Result.Y * FCellHeight + FCellArea.Top;
end;
//==============================================================================
procedure TfCLOffers.AssignCells;
var
  Index: Integer;
  Offer: TOffer;
begin
  { Reassigns the AssignedCell field of each Offer }
  if FOfferList = nil then Exit;
  FOffer := nil;
  for Index := 0 to High(FCells) do FCells[Index] := nil;
  for Index := 0 to FOfferList.Count - 1 do
    begin
      Offer := FOfferList[Index];
      AssignCell(Offer);
    end;
  Refresh;
end;
//==============================================================================
procedure TfCLOffers.DrawOffer(var Offer: TOffer);
var
  Cell: TPoint;
  CellR, R: TRect;
  Text, sPieces: string;
  _TextWidth, pieceSize, ImageIndex, shift: Integer;
  Color,tmp: TColor;
  bmp: TBitMap;
  L: TLogin;
begin
  { Get the cell in which to draw }
  Cell := GetXYFromCell(Offer.FAssignedCell);
  CellR := Rect(Cell.X, Cell.Y, Cell.X + FCellWidth, Cell.Y + FCellHeight);

  with Canvas do
    begin
      Brush.Style := bsClear;

      { Different colors for seek or match }
      if Offer.FOfferType = otSeek then
        Brush.Color := clBtnFace
      else
        Brush.Color := clBtnShadow;

      { Draw the box }
      Rectangle(CellR);
      if Offer.FOfferType = otSeek then
        Frame3D(Canvas, CellR, clBtnHighLight, clBtnShadow, 1)
      else
        Frame3D(Canvas, CellR, clBtnFace, cl3DDkShadow, 1);

      { Issuer }
      Text := GetNameWithTitle(Offer.FIssuer,Offer.FIssuerTitle);
      Font.Name := 'Arial';
      if fCLSocket.MyAdminLevel >= 1 then begin
        L := fLoginList.LoginByName[Offer.FIssuer];
        if L = nil then Font.Style := []
        else Font.Style := MembershipType2FontStyle(L.MembershipType);
      end;
      _TextWidth := TextWidth(Text);
      if _TextWidth > FCellWidth - 4 then
        begin
          Text := Offer.FIssuer;
          while TextWidth(Text + '...') > FCellWidth - 4 do
            Delete(Text, Length(Text), 1);
          Text := Text + '...';
        end;
      _TextWidth := TextWidth(Text);

      if trim(Offer.FIssuerTitle)='C' then
        begin
          tmp:=Canvas.Brush.Color;
          Canvas.Brush.Color:=fGL.SeekTitleCColor;
          FillRect(Rect(Cell.X,Cell.Y,Cell.X+FCellWidth,Cell.Y+10));
          TextOut(Cell.X + (FCellWidth -_TextWidth) div 2, Cell.Y + 1, Text);
          Canvas.Brush.Color:=tmp;
        end
      else
        TextOut(Cell.X + (FCellWidth -_TextWidth) div 2, Cell.Y + 1, Text);

      Font.Style := [];

      Font.Color := clBlue;
      Text := GameParamOfferText(Offer.MyInitMin, Offer.MyInitSec,Offer.MyInc);
      TextOut (Cell.X + 4, Cell.Y + (FCellHeight div 4), Text);

      { Rated? }
      Font.Color := clBlack;
      if Boolean(Offer.FRated) and Offer.FLoseOnDisconnect then Font.Style := [fsBold]
      else Font.Style := [];
      if Boolean(Offer.FRated) then Text := 'Rated' else Text := 'Unrated';
      _TextWidth := TextWidth(Text);
      TextOut (Cell.X + FCellWidth - _TextWidth - 4,
        Cell.Y + (FCellHeight div 2), Text);
      Font.Style := [];

      { Rating }
      if not Offer.FProvisional then
        Font.Color := clBlack
      else
        Font.Color := clRed;

      Text := IntToStr({fCLSocket.MyRating[Offer.FRatingType] - }Offer.FRating);
      TextOut (Cell.X + 4, Cell.Y + (FCellHeight div 2), Text);

      { Color }
      Font.Color := clBlack;
      {if Offer.FColor = -1 then
        Text := 'White'
      else if Offer.FColor = 1 then
        Text := 'Black'
      else
        Text := 'Random';
      _TextWidth := TextWidth(Text);
      TextOut (Cell.X + FCellWidth - _TextWidth - 4,
        Cell.Y + (FCellHeight div 2), Text);}

      { Game Type }
      Font.Color := clBlack;
      Text := RATED_TYPES[Ord(Offer.FRatingType)];
      if (Offer.FRatingType = rtFischer) {and Offer.FAutoTimeOdds }then
        Text := 'Fischer';

      case Ord(Offer.FRatingType) of
        0: Color:=fGL.SeekStandardColor;
        1: Color:=fGL.SeekBlitzColor;
        2: Color:=fGL.SeekBulletColor;
        3: Color:=fGL.SeekCrazyColor;
        4: Color:=fGL.SeekFisherColor;
        5: Color:=fGL.SeekLoosersColor;
      end;

      tmp:=Canvas.Brush.Color;
      Canvas.Brush.Color:=Color;
      FillRect(Rect(Cell.X,Cell.Y+Trunc((FCellHeight * 0.72))-1,Cell.X+FCellWidth,Cell.Y+FCellHeight));


      TextOut (Cell.X + 4, Cell.Y + Trunc((FCellHeight * 0.72))+2, Text);
      Canvas.Brush.Color:=tmp;

      Brush.Style := bsSolid;

      if Offer.FOdds.PieceDefined then begin
        bmp := TBitMap.Create;
        pieceSize := 17;
        sPieces := 'PNBRQ';
        GetLittlePieceImage(sPieces[Offer.FOdds.FPiece+1], bmp, pieceSize, Offer.FOdds.FPieceDirection = oodGive);
        bmp.Canvas.FloodFill(1,1,Color,fsSurface);
        R := Rect(CellR.Right - pieceSize, CellR.Bottom - pieceSize, CellR.Right - 1, CellR.Bottom - 1);
        Canvas.CopyRect(R, bmp.Canvas, Rect(0, 0, pieceSize-1, pieceSize-1));
        bmp.Free;
      end;
      if Offer.FOdds.FAutoTimeOdds or Offer.FOdds.TimeDefined then begin
        ImageIndex := BoolTo_(Offer.IHaveMoreTime or (Offer.FIssuer = fCLSocket.MyName), 0, 1);
        shift := BoolTo_(Offer.FOdds.PieceDefined, 34, 17);
        il17.Draw(Canvas, CellR.Right - shift, CellR.Bottom - 17, ImageIndex)
      end;
    end;
end;
//==============================================================================
procedure TfCLOffers.SetCapacity;
begin
  { Set the capacity based on the size of the form }
  FCellArea := Rect(0, pnlHeader.Height, ClientWidth, ClientHeight);
  FCellCols := (FCellArea.Right - FCellArea.Left) div FCellWidth;
  FCellRows := (FCellArea.Bottom - FCellArea.Top) div FCellHeight;
  FCellCapacity := FCellCols * FCellRows - 1;
  if FCellCapacity > High(FCells) then FCellCapacity := High(FCells);
  FCellIndex := -1;
  FOffer := nil;
end;
//==============================================================================
procedure TfCLOffers.WMEraseBkgnd(var Msg: TMessage);
begin
  { Trap, but do not process }
end;
//==============================================================================
procedure TfCLOffers.Clear;
var
  Index: Integer;
begin
  for Index := 0 to High(FCells) do FCells[Index] := nil;
  while FOfferList.Count > 0 do
    begin
      TOffer(FOfferList[0]).Free;
      FOfferList.Delete(0);
    end;
  Refresh;
end;
//==============================================================================
procedure TfCLOffers.RemoveOffer(_OfferNumber: Integer);
var
  Offer: TOffer;
  Cell: TPoint;
begin
  Offer := FindOffer(_OfferNumber);
  { Offer not found }
  if Offer = nil then Exit;

  { If Offer has an AssignedCell then unpaint it }
  if Offer.FAssignedCell > -1 then
    begin
      Cell := GetXYFromCell(Offer.FAssignedCell);
      with Canvas do
        begin
          Pen.Color := Self.Color;
          Brush.Color := Self.Color;
          Rectangle(Cell.X , Cell.Y, Cell.X + FCellWidth, Cell.Y + FCellHeight);
        end;

      if Offer.FAssignedCell = pnlHint.Tag then
        pnlHint.Visible := false;
      { If Offer has the Mouseover then clear the FOffer var }
      if Offer = FOffer then
          begin
            FOffer := nil;
            Cursor := crDefault;
          end;

      { Set the Cell reference to nil }
      FCells[Offer.FAssignedCell] := nil;
    end;

  FOfferList.Remove(Offer);
  Offer.Free;
end;
//==============================================================================
{ DP_MATCH: DG#, OfferNumber, Color, InitialTime, IncTime, Issuer, Title
  Provisional, Rated, Rating, RatingType }
procedure TfCLOffers.ReceiveOffer(var Datapack: TStrings);
var
  Offer : TOffer;
  s, sPersonTime, sPersonPiece, sTime, sPiece: string;
  MyRating, OddsInitTime, OddsIncTime: integer;
begin
  { Attempt to find the offer first. }
  Offer := FindOffer(StrToInt(Datapack[1]));
  if Offer <> nil then Exit;

  if (Datapack[6]='C') and fGL.CReject then exit;

  Offer := TOffer.Create;

  with Offer do
    begin
      FAssignedCell := -1;
      if StrToInt(Datapack[0]) = DP_MATCH then
        FOfferType := otMatch
      else
        FOfferType := otSeek;
      FOfferNumber := StrToInt(Datapack[1]);
      FColor:= StrToInt(Datapack[2]);
      FInitialTime := Datapack[3];
      FIncTime := StrToInt(Datapack[4]);
      FIssuer := Datapack[5];
      FIssuerTitle := Datapack[6];
      FProvisional := Boolean(StrToInt(Datapack[7]));
      FRated := Boolean(StrToInt(Datapack[8]));
      FRating := StrToInt(Datapack[9]);
      FRatingType := TRatedType(StrToInt(Datapack[10]));
      FLoseOnDisconnect := (Datapack.Count>11) and (Datapack[11]='1');
      if FProvisional then FGamesCnt := fCLTerminal.NumberOfRatedGames(FIssuer, FRatingType)
      else FGamesCnt := 0;
      FOdds.FAutoTimeOdds := (Datapack.Count>12) and (Datapack[12]='1');
    end;

  if Datapack.Count > 13 then Offer.FOdds.FInitMin := StrToInt(Datapack[13]);
  if Datapack.Count > 14 then Offer.FOdds.FInitSec := StrToInt(Datapack[14]);
  if Datapack.Count > 15 then Offer.FOdds.FInc := StrToInt(Datapack[15]);
  if Datapack.Count > 16 then Offer.FOdds.FPiece := StrToInt(Datapack[16]);
  if Datapack.Count > 17 then Offer.FOdds.FTimeDirection := TOfferOddsDirection(StrToInt(Datapack[17]));
  if Datapack.Count > 18 then Offer.FOdds.FPieceDirection := TOfferOddsDirection(StrToInt(Datapack[18]));


  FOfferList.Add(Offer);

  if AssignCell(Offer) then DrawOffer(Offer);

  if (Offer.FOfferType = otMatch) and (Datapack[5] <> fCLSocket.MyName) then
    begin
      s := Trim(Datapack[6] + ' ' + Offer.FIssuer + '(' +  Datapack[9] + ') has challenged you to a');
      if Offer.FRated then s := s + ' rated ' else s := s + ' unrated ';
      s := s + '(' + GameParamOfferText(Offer.MyInitMin, Offer.MyInitSec, Offer.MyInc) + ') ';
      s := s + RATED_TYPES[Ord(Offer.FRatingType)] + ' game ';
      if Offer.FOdds.FAutoTimeOdds or Offer.FOdds.Defined then
        s := s + 'with odds';
      if Offer.FRated and Offer.FLoseOnDisconnect then s:=s+' (Lose On Disconnect)';
      s := s + '.';
      fCLTerminal.ccConsole.AddLine(-1, s, ltMessage);
      if Offer.DifferentTime then begin
        fCLTerminal.ccConsole.AddLine(-1, 'Your time: ' + Offer.MyTimeStringFull + '.', ltMessage);
        fCLTerminal.ccConsole.AddLine(-1, 'Opponent''s time: ' + Offer.OpTimeStringFull + '.', ltMessage);
      end;

      if Offer.FOdds.PieceDefined then
        fCLTerminal.ccConsole.AddLine(-1, Offer.PieceString + '.', ltMessage);

      s := 'Click "' + CMD_STR_ACCEPT + ' ' + Datapack[1] + '" to play. ';
      s := s + 'Click "' + CMD_STR_DECLINE + ' ' + Datapack[1] + '" to decline.';
      fCLTerminal.ccConsole.AddLine(-1, s, ltMessage);

      fGL.PlayCLSound (SI_CHALLENGE);
    end;
end;
//==============================================================================
procedure TfCLOffers.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Clear;
  FOfferList.Free;
  FOfferList := nil;
  fCLOffers := nil;
  Action := caFree;
end;
//==============================================================================
procedure TfCLOffers.FormCreate(Sender: TObject);
begin
  { Adjust post height & width for different screen resolutions }
  FCellWidth := Round(84 / (96 / PixelsPerInch));
  FCellHeight := Round(64 / (96 / PixelsPerInch));
  Image.Canvas.Font.Style := [fsBold];
  pnlHint.Width := Image.Canvas.TextWidth('000000000000000');

  FOfferList := TList.Create;

  SetCapacity;
end;
//==============================================================================
procedure TfCLOffers.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p: TPoint;
  Value: Integer;
  s: string;
begin
  if (Button <> mbLeft) or (Cursor = crNo) then Exit;
  p := ClientToScreen(Point(X, Y));
  Value := GetCellFromXY(X, Y);
  if (Value < 0) or (Value > High(FCells))
  or (fCLSocket.InitState < isLoginComplete) then Exit;

  if Assigned (FCells[Value]) then
    begin
      s := IntToStr(TOffer(FCells[Value]).FOfferNumber);
      fCLSocket.InitialSend([CMD_STR_ACCEPT, s]);
    end;
end;
//==============================================================================
procedure TfCLOffers.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Value: Integer;
begin
  Value := GetCellFromXY(X,Y);

  if TOffer(FCells[Value]) = FOffer then Exit;

  if (Value = -1) or (Value > FCellCapacity) then
    begin
      Cursor := crDefault;
      Exit;
    end;

  FOffer := TOffer(FCells[Value]);

  if Assigned(FOffer) then
    begin
      if RemoveTitle(FOffer.FIssuer) = fCLSocket.MyName then
        Cursor := crNo
      else
        Cursor := crIEHand;
    end
  else
    Cursor := crDefault;

  ShowHint(FOffer);

end;
//==============================================================================
procedure TfCLOffers.ShowHint(Offer: TOffer);
var
  RW, RL, RD, OddsInitTime, OddsIncTime, MyRating, CurY: integer;
  leftStart, topStart, maxWidth, maxHeight, indent: integer;
  nWidth, nHeight: integer;
  CNVS: TCanvas;
  str: string;
  //****************************************************************************
  procedure ChangeMaxParams(p_Width, p_Height: integer);
  begin
    if p_Width > maxWidth then maxWidth := p_Width;
    if p_Height > maxHeight then maxHeight := p_Height;
  end;
  //****************************************************************************
  procedure DrawRatingForecast(W, L, D: integer);
  var
    nLeft: integer;
    s: string;
  begin
    nLeft := leftStart;

    if not Offer.FRated then begin
      TextOut(CNVS,nLeft,topStart,'Unrated game',clBlack,-1,[],nWidth,nHeight);
      CurY := topStart + nHeight + indent;
      ChangeMaxParams(nLeft + nWidth + indent, CurY);
      exit;
    end;

    TextOut(CNVS, nLeft, topStart, 'Rating forecast:', clBlack, -1, [], nWidth, nHeight);
    CurY := topStart + nHeight + indent;
    ChangeMaxParams(nLeft + nWidth + indent, CurY);

    TextOut(CNVS, nLeft, CurY, IntToStrPlus(W), clGreen, -1, [fsBold], nWidth, nHeight);
    nLeft := nLeft + nWidth + indent;
    TextOut(CNVS, nLeft, CurY, IntToStrPlus(L), clRed, -1, [fsBold], nWidth, nHeight);
    nLeft := nLeft + nWidth + indent;
    TextOut(CNVS, nLeft, CurY, IntToStrPlus(D), clBlue, -1, [fsBold], nWidth, nHeight);
    nLeft := nLeft + nWidth + indent;
    CurY := CurY + nHeight + indent;
    ChangeMaxParams(nLeft, CurY);
  end;
  //****************************************************************************
  procedure PlaceHint;
  var
    point: TPoint;
  begin
    point := GetXYFromCell(Offer.FAssignedCell);
    pnlHint.Left := point.x;
    pnlHint.Top := point.y + FCellHeight+2;
  end;
  //****************************************************************************
  procedure DrawLine;
  begin
    CNVS.Brush.Color := clBlack;
    CNVS.FillRect(Rect(0, CurY+2, 1000, CurY+4));
    CurY := CurY + 8;
    CNVS.Brush.Color := pnlHint.Color;
  end;
  //****************************************************************************
  procedure PutString(str: string);
  begin
    TextOut(CNVS, leftStart, CurY, str, clBlack, -1, [], nWidth, nHeight);
    CurY := CurY + nHeight + indent;
    ChangeMaxParams(leftStart + nWidth + indent, CurY);
  end;
  //****************************************************************************
begin
  pnlHint.Visible := Cursor = crIEHand;
  if not pnlHint.Visible {or (pnlHint.Tag = Offer.FAssignedCell) }then exit;
  pnlHint.Tag := Offer.FAssignedCell;

  maxWidth := 0; maxHeight := 0;
  leftStart := 2; topStart := 0;
  indent := 4;

  PlaceHint;

  // clear hint with default color
  CNVS := Image.Canvas;
  CNVS.Brush.Color := pnlHint.Color;
  CNVS.Pen.Color := clBlack;
  CNVS.FillRect(Rect(0,0,1000,1000));

  CurY := 2;

  if Offer.FOdds.FAutoTimeOdds and fCLSocket.MyRatingProv[Offer.FRatingType] then begin
    PutString('You have provisional rating and');
    PutString('cannot accept rated odds games');
  end else begin
    Offer.GetRatingChangesFinal(RW, RL, RD);
    DrawRatingForecast(RW, RL, RD);
    if Offer.DifferentTime or Offer.FOdds.PieceDefined or (Offer.FColor <> 0) then
      DrawLine;

    if Offer.DifferentTime then begin
      PutString('Your time: ' + Offer.MyTimeStringFull);
      PutString('Opponent''s time: ' + Offer.OpTimeStringFull);
    end;

    if Offer.FOdds.PieceDefined then
      PutString(Offer.PieceString);

    if Offer.FColor <> 0 then begin
      str := 'You will play ' + BoolTo_(Offer.FColor = 1, 'black', 'white');
      PutString(str);
    end;
  end;

  pnlHint.Width := maxWidth;
  pnlHint.Height := maxHeight;
end;
//==============================================================================
procedure TfCLOffers.FormPaint(Sender: TObject);
var
  Index : Integer;
  Offer : TOffer;
begin
  { Clear the post area }
  Canvas.Brush.Color := fGL.DefaultBackgroundColor;
  Canvas.FillRect(FCellArea);

  { Reset the Pen color }
  Canvas.Pen.Color := clWindow;

  { Draw the posts }
  for Index := 0 to FCellCapacity do
    if FCells[Index] <> nil then
      begin
        Offer := TOffer(FCells[Index]);
        if Offer.FAssignedCell > -1 then DrawOffer(Offer);
      end;
end;
//==============================================================================
procedure TfCLOffers.FormResize(Sender: TObject);
begin
  SetCapacity;
  AssignCells;
end;
//==============================================================================
procedure TfCLOffers.miAcceptClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_ACCEPT, IntToStr(FOffer.FOfferNumber)]);
end;
//==============================================================================
procedure TfCLOffers.miDeclineClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_DECLINE, IntToStr(FOffer.FOfferNumber)]);
end;
//==============================================================================
procedure TfCLOffers.miProfileClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_PROFILE, FOffer.FIssuer]);
end;
//==============================================================================
procedure TfCLOffers.miRemoveClick(Sender: TObject);
begin
  if FOffer <> nil then
    fCLSocket.InitialSend([CMD_STR_UNOFFER, IntToStr(FOffer.FOfferNumber)]);
end;
//==============================================================================
procedure TfCLOffers.pmPlayerMenuPopup(Sender: TObject);
begin
  if FOffer = nil then
    begin
      miAccept.Enabled := False;
      miDecline.Enabled := False;
      miRemove.Enabled := False;
      miProfile.Enabled := False;
    end
  else
    begin
      miAccept.Enabled := (FOffer.FOfferType = otSeek) or
        (FOffer.FIssuer <> fCLSocket.MyName);
      miDecline.Enabled := (FOffer.FOfferType = otMatch) and
        (FOffer.FIssuer <> fCLSocket.MyName);
      miRemove.Enabled := FOffer.FIssuer = fCLSocket.MyName;
      miProfile.Enabled := True;
      miScore.Enabled := (FOffer.FIssuer <> fCLSocket.MyName);
    end;
end;
//==============================================================================
procedure TfCLOffers.sbMaxClick(Sender: TObject);
begin
  Self.SetFocus;
  fCLMain.miMaximizeTop.Click;
end;
//==============================================================================
procedure TfCLOffers.miScoreClick(Sender: TObject);
begin
  if FOffer <> nil then fCLSocket.InitialSend([CMD_STR_SCORE, RemoveTitle(FOffer.FIssuer)]);
end;
//==============================================================================
procedure TfCLOffers.pnlHintMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  pnlHint.Visible := false;
end;
//==============================================================================
{ TOffer }

constructor TOffer.Create;
begin
  FOdds := TOfferOdds.Create;
end;
//==============================================================================
procedure TOffer.GetRatingChanges(var RW, RL, RD: integer);
begin
  if fCLSocket.MyRatingProv[FRatingType] then // my rating is provisional
    CountProvRatingICC(
      fCLSocket.MyRating[FRatingType],
      fCLSocket.MyRatedGamesNumber[FRatingType],
      FRating,
      RW, RD, RL)
  else // my rating is persistent
    CountNotProvRatingICC(
      fCLSocket.MyRating[FRatingType],
      FRating, FGamesCnt, FProvisional,
      RW, RD, RL);
end;
//==============================================================================
procedure TfCLOffers.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  pnlHint.Visible := false;
end;
//==============================================================================
procedure TfCLOffers.pmSeekItemCilck(Sender: TObject);
var
  nTag, nFirst, nSecond, nInitTime, nIncTime: integer;
  sRated, sRatedType, sTimeOdds: string;
begin
  nTag := (Sender as TMenuItem).Tag;
  nFirst := nTag div 10;
  nSecond := nTag mod 10;

  if nFirst = 1 then sRatedType := '0'
  else sRatedType := IntToStr(nFirst+1);

  nIncTime := 0;

  if FLastPopupButton = fCLMain.tbSeek1_0 then nInitTime := 1
  else if FLastPopupButton = fCLMain.tbSeek3_0 then nInitTime := 3
  else if FLastPopupButton = fCLMain.tbSeek5_0 then nInitTime := 5
  else if FLastPopupButton = fCLMain.tbSeek15_0 then nInitTime := 15
  else if FLastPopupButton = fCLMain.tbSeek3_2 then begin
    nInitTime := 3; nIncTime := 2;
  end else if FLastPopupButton = fCLMain.tbSeek2_12 then begin
    nInitTime := 2; nIncTime := 12;
  end else raise exception.Create('pmSeekItemClick: unknown button pressed');

  if nSecond in [1,2] then sRated := '1'
  else sRated := '0';

  if nSecond in [2,4] then sTimeOdds := '1'
  else sTimeOdds := '0';


  fCLSocket.InitialSend([CMD_STR_SEEK,
    IntToStr(nInitTime), IntToStr(nIncTime),
    sRated, sRatedType,
    IntToStr(fGL.SeekColor),
    IntToStr(fGL.SeekMinimum),
    IntToStr(fGL.SeekMaximum),
    BoolTo_(fGL.CReject,'1','0'),
    sTimeOdds]);

end;
//==============================================================================
function TOffer.FullInitSec: integer;
begin
  result := TimeToMSec(FInitialTime) div 1000;
end;
//==============================================================================
function TOffer.FixedTimeOddsSet: Boolean;
begin
  result := (FOdds.FInitMin <> -1) and
    ((FullInitSec <> FOdds.InitSec) or (FIncTime <> FOdds.FInc));
end;
//==============================================================================
procedure TfCLOffers.pmSeekPopup(Sender: TObject);
var
  b: Boolean;
begin
  b := fCLMain.tbSeek3_0.Down or fCLMain.tbSeek5_0.Down or fCLMain.tbSeek3_2.Down or fCLMain.tbSeek2_12.Down;
  RatedTimeOdds1.Enabled := b;
  RatedTimeOdds2.Enabled := b;
  RatedTimeOdds3.Enabled := b;
  RatedTimeOdds4.Enabled := b;
  UnratedTimeOdds1.Enabled := b;
  UnratedTimeOdds2.Enabled := b;
  UnratedTimeOdds3.Enabled := b;
  UnratedTimeOdds4.Enabled := b;

  if fCLMain.tbSeek1_0.Down then FLastPopupButton := fCLMain.tbSeek1_0
  else if fCLMain.tbSeek3_0.Down then FLastPopupButton := fCLMain.tbSeek3_0
  else if fCLMain.tbSeek5_0.Down then FLastPopupButton := fCLMain.tbSeek5_0
  else if fCLMain.tbSeek15_0.Down then FLastPopupButton := fCLMain.tbSeek15_0
  else if fCLMain.tbSeek3_2.Down then FLastPopupButton := fCLMain.tbSeek3_2
  else if fCLMain.tbSeek2_12.Down then FLastPopupButton := fCLMain.tbSeek2_12;

  fCLMain.tbSeek1_0.Down := false;
  fCLMain.tbSeek3_0.Down := false;
  fCLMain.tbSeek5_0.Down := false;
  fCLMain.tbSeek15_0.Down := false;
  fCLMain.tbSeek3_2.Down := false;
  fCLMain.tbSeek2_12.Down := false;
end;
//==============================================================================
function TOffer.IHaveMoreTime: Boolean;
var
  OpponentTime40, MyTime40: integer;
begin
  if Fodds.FAutoTimeOdds then result := fCLSocket.MyRating[FRatingType] < FRating
  else if FOdds.TimeDefined then begin
    if FOdds.FTimeDirection = oodAsk then begin
      OpponentTime40 := FullInitSec + FIncTime * 40;
      MyTime40 := FOdds.InitSec + FOdds.FInc * 40;
    end else begin
      MyTime40 := FullInitSec + FIncTime * 40;
      OpponentTime40 := FOdds.InitSec + FOdds.FInc * 40;
    end;
    result := MyTime40 > OpponentTime40
  end else
    result := false;
end;
//==============================================================================
function TOffer.GetInitMin: integer;
var
  n, sec: integer;
begin
  n := pos('.',FInitialTime);
  if n = 0 then result := StrToInt(FInitialTime)
  else begin
    sec := StrToInt(copy(FInitialTime,n+1,length(FInitialTime)));
    result := sec div 60;
  end;
end;
//==============================================================================
function TOffer.GetInitSec: integer;
var
  n, sec: integer;
begin
  n := pos('.',FInitialTime);
  if n = 0 then result := 0
  else begin
    sec := StrToInt(copy(FInitialTime,n+1,length(FInitialTime)));
    result := sec mod 60;
  end;
end;
//==============================================================================
function TOffer.GetMyInc: integer;
var
  nFullInitSec, nInc, nDeviation: integer;
begin
  if (FOdds.FAutoTimeOdds) and (fCLSocket.MyRating[FRatingType] > FRating) then begin
    Self.CountAutoTimeOdds(nFullInitSec, nInc, nDeviation);
    result := nInc;
  end else if MyTimeIsOdds then
    result := FOdds.FInc
  else
    result := FIncTime;
end;
//==============================================================================
function TOffer.GetMyInitMin: integer;
var
  nFullInitSec, nInc, nDeviation: integer;
begin
  if (FOdds.FAutoTimeOdds) and (fCLSocket.MyRating[FRatingType] > FRating) then begin
    Self.CountAutoTimeOdds(nFullInitSec, nInc, nDeviation);
    result := nFullInitSec div 60;
  end else if MyTimeIsOdds then
    result := FOdds.FInitMin
  else
    result := InitMin;
end;
//==============================================================================
function TOffer.GetMyInitSec: integer;
var
  nFullInitSec, nInc, nDeviation: integer;
begin
  if (FOdds.FAutoTimeOdds) and (fCLSocket.MyRating[FRatingType] > FRating) then begin
    Self.CountAutoTimeOdds(nFullInitSec, nInc, nDeviation);
    result := nFullInitSec mod 60;
  end else if MyTimeIsOdds then
    result := FOdds.FInitSec
  else
    result := InitSec;
end;
//==============================================================================
function TOffer.GetOpInc: integer;
var
  nFullInitSec, nInc, nDeviation: integer;
begin
  if (FOdds.FAutoTimeOdds) and (fCLSocket.MyRating[FRatingType] < FRating) then begin
    Self.CountAutoTimeOdds(nFullInitSec, nInc, nDeviation);
    result := nInc;
  end else if not MyTimeIsOdds and not FOdds.FAutoTimeOdds then
    result := FOdds.FInc
  else
    result := FIncTime;
end;
//==============================================================================
function TOffer.GetOpInitMin: integer;
var
  nFullInitSec, nInc, nDeviation: integer;
begin
  if (FOdds.FAutoTimeOdds) and (fCLSocket.MyRating[FRatingType] < FRating) then begin
    Self.CountAutoTimeOdds(nFullInitSec, nInc, nDeviation);
    result := nFullInitSec div 60;
  end else if not MyTimeIsOdds and not FOdds.FAutoTimeOdds then
    result := FOdds.FInitMin
  else
    result := InitMin;
end;
//==============================================================================
function TOffer.GetOpInitSec: integer;
var
  nFullInitSec, nInc, nDeviation: integer;
begin
  if (FOdds.FAutoTimeOdds) and (fCLSocket.MyRating[FRatingType] < FRating) then begin
    Self.CountAutoTimeOdds(nFullInitSec, nInc, nDeviation);
    result := nFullInitSec mod 60;
  end else if not MyTimeIsOdds and not FOdds.FAutoTimeOdds then
    result := FOdds.FInitSec
  else
    result := InitSec;
end;
//==============================================================================
procedure TOffer.CountAutoTimeOdds(var OddsInitFullSec, OddsInc, OddsDeviation: integer);
var
  MyRating: integer;
begin
  MyRating := fCLSocket.MyRating[FRatingType];
  CountTimeOdds(TimeToMSec(FInitialTime) div 1000, FIncTime,
    FRating, MyRating, OddsInitFullSec, OddsInc, OddsDeviation);
end;
//==============================================================================
function TOffer.GetMyTimeString: string;
begin
  result := GameParamOfferText(MyInitMin, MyInitSec, MyInc);
end;
//==============================================================================
function TOffer.GetOpTimeString: string;
begin
  result := GameParamOfferText(OpInitMin, OpInitSec, OpInc);
end;
//==============================================================================
function TOffer.GetMyTimeStringFull: string;
begin
  result := GameParamOfferTextFull(MyInitMin, MyInitSec, MyInc);
end;
//==============================================================================
function TOffer.GetOpTimeStringFull: string;
begin
  result := GameParamOfferTextFull(OpInitMin, OpInitSec, OpInc);
end;
//==============================================================================
procedure TOffer.GetRatingChangesFinal(var RW, RL, RD: integer);
begin
  if FOdds.FAutoTimeOdds then begin
    RW := 16 + MyDeviation; RL := RW - 32; RD := MyDeviation;
  end else
    GetRatingChanges(RW, RL, RD);
end;
//==============================================================================
function TOffer.DifferentTime: Boolean;
begin
  result := FOdds.FAutoTimeOdds or
    FOdds.TimeDefined and ((InitMin <> FOdds.FInitMin) or (InitSec < FOdds.FInitSec)
    or (FIncTime <> FOdds.FInc));
end;
//==============================================================================
function TOffer.GetPieceString: string;
begin
  if FOdds.FPieceDirection = oodGive then result := 'Opponent'
  else result := 'Your';

  result := result + ' will play without ' + sPieces[FOdds.FPiece];
end;
//==============================================================================
function TOffer.MyTimeIsOdds: Boolean;
begin
  result := FOdds.TimeDefined and
    ((FOdds.FTimeDirection = oodGive) and (FIssuer = fCLSocket.MyName)
      or (FOdds.FTimeDirection = oodAsk) and (FIssuer <> fCLSocket.MyName));
end;
//==============================================================================
function TOffer.GetMyDeviation: integer;
var
  nFullInitSec, nInc, nDeviation: integer;
begin
  Self.CountAutoTimeOdds(nFullInitSec, nInc, nDeviation);
  if fCLSocket.MyRating[FRatingType] < FRating then result := nDeviation
  else result := -nDeviation;
end;
//==============================================================================
function TOffer.IsAchievementOffer: Boolean;
begin
  result := Self.FRated
    and (Self.FIssuer <> fCLSocket.MyName)
    and not Self.FProvisional
    and not fCLSocket.MyRatingProv[Self.FRatingType];
end;
//==============================================================================
end.

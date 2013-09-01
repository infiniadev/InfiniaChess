
{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLSeeks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CLBaseDraw, StdCtrls, contnrs, CLOffers, ExtCtrls, ImgList,
  Menus, ComCtrls, Math;

type
  TfCLSeeks = class(TfCLBaseDraw)
    pnlHeader: TPanel;
    il17: TImageList;
    pmSeek: TPopupMenu;
    Rated1: TMenuItem;
    Rated2: TMenuItem;
    RatedTimeOdds1: TMenuItem;
    Unrated1: TMenuItem;
    UnratedTimeOdds1: TMenuItem;
    CrazyHouse1: TMenuItem;
    RatedGame1: TMenuItem;
    RatedTimeOdds2: TMenuItem;
    UnratedGame1: TMenuItem;
    UnratedTimeOdds2: TMenuItem;
    FischerRandom1: TMenuItem;
    RatedGame2: TMenuItem;
    RatedTimeOdds3: TMenuItem;
    UnratedGame2: TMenuItem;
    UnratedTimeOdds3: TMenuItem;
    Losers1: TMenuItem;
    RatedGame3: TMenuItem;
    RatedTimeOdds4: TMenuItem;
    UnratedGame3: TMenuItem;
    UnratedTimeOdds4: TMenuItem;
    pmPlayerMenu: TPopupMenu;
    miAccept: TMenuItem;
    miDecline: TMenuItem;
    miRemove: TMenuItem;
    miProfile: TMenuItem;
    miScore: TMenuItem;
    pnlHint: TPanel;
    Image: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pmSeekItemCilck(Sender: TObject);
    procedure pmSeekPopup(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure pmPlayerMenuPopup(Sender: TObject);
    procedure miAcceptClick(Sender: TObject);
    procedure miDeclineClick(Sender: TObject);
    procedure miRemoveClick(Sender: TObject);
    procedure miProfileClick(Sender: TObject);
    procedure miScoreClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FOfferList: TObjectList;
    ButtonUnderMouse: TCLBaseDrawButton;
    OfferUnderMouse: TOffer;
    function FindOffer(p_OfferNumber: integer): TOffer;
    function FindOfferIndex(p_OfferNumber: integer): integer;
    procedure PrintTerminalMessage(p_Offer: TOffer);
    procedure ShowHint(Offer: TOffer);
    procedure InsertOfferToList(p_Offer: TOffer);
  public
    { Public declarations }
    FLastPopupButton: TToolButton;
    procedure VirtualDraw(cnv: TCanvas; X,Y: integer; var pp_FullWidth, pp_FullHeight: integer); override;
    procedure OnBaseDrawButtonCilck(btn: TCLBaseDrawButton); override;
    procedure MakeToolbarMenu(p_ToolButton: TToolButton);
    procedure Clear;
    procedure CMD_ReceiveOffer(CMD: TStrings);
    procedure CMD_RemoveOffer(CMD: TStrings);
  end;

var
  fCLSeeks: TfCLSeeks;

implementation

{$R *.dfm}

uses
  CLGlobal, CLTerminal, CLConst, CLLib, CLGame, CLOfferOdds,
  CLSocket, CLConsole, CLMain, CLLogins;

const
  CELL_WIDTH = 100;

{ TfCLSeeks }
//==============================================================================
procedure TfCLSeeks.Clear;
begin
  FOfferList.Clear;
  if Visible then Refresh;
end;
//==============================================================================
procedure TfCLSeeks.VirtualDraw(cnv: TCanvas; X, Y: integer;
  var pp_FullWidth, pp_FullHeight: integer);
var
  CellWidth, CellHeight, DistanceX, DistanceY, TextHeight: integer;
  CornerShift, OfferBorderWidth, OfferBottomHeight, FontSize: integer;
  clSeek, clMatch: TColor;
  //****************************************************************************
  procedure InitVars;
  begin
    cnv.Font.Name := 'Arial';
    FontSize := 8;
    cnv.Font.Size := FontSize;
    CellWidth := CELL_WIDTH; //cnv.TextWidth('OOOOOOOOOOOOO');
    CellHeight := 80;
    DistanceX := 10;
    DistanceY := 10;
    CornerShift := 3;
    OfferBorderWidth := 0;
    OfferBottomHeight := 22;
    clSeek := RGB(230, 230, 230);
    clMatch := RGB(160, 160, 160);
    TextHeight := cnv.TextHeight('0') + 2;
  end;
  //****************************************************************************
  procedure DrawOffer(p_Offer: TOffer; p_Left, p_Top: integer);
  var
    R, RLogin, RPiece: TRect;
    BorderColor, BackColor, col: TColor;
    CurY, TextLeft, TextRight, w, PieceSize, ImageIndex, shift, BorderLineWidth: integer;
    LoginWithTitle, s, sPieces: string;
    FontStyle: TFontStyles;
    bmp: TBitMap;
  begin
    R := Rect(p_Left, p_Top, p_Left + CellWidth, p_Top + CellHeight);
    BorderColor := ColorByRatedType(p_Offer.FRatingType);
    if p_OFfer.FOfferType = otSeek then BackColor := clSeek
    else BackColor := clMatch;
    // frame

    if p_Offer = OfferUnderMouse then begin
      R := ZoomRect(R, -1, -1);
      BorderLineWidth := 2;
    end else
      BorderLineWidth := 1;
      
    DrawFilledFrame(cnv, IncRect(R, 4, 4), clGray, clGray, 1, CornerShift);
    DrawFilledFrame(cnv, R, clBlack, BorderColor, BorderLineWidth, CornerShift);
    DrawFilledFrame(cnv,
      Rect(R.Left + OfferBorderWidth, R.Top + OfferBorderWidth,
           R.Right - OfferBorderWidth, R.Bottom - OfferBottomHeight),
      clBlack, BackColor, BorderLineWidth, CornerShift);

    // text
    TextLeft := R.Left + OfferBorderWidth + 6;
    TextRight := R.Right - OfferBorderWidth - 6;
    CurY := R.Top + OfferBorderWidth + 4;
    // login with title
    RLogin := Rect(TextLeft, CurY, TextRight, CurY + TextHeight);
    LoginWithTitle := GetNameWithTitle(p_Offer.FIssuer, p_Offer.FIssuerTitle);

    if fCLSocket.MyAdminLevel >= 1 then
      FontStyle := MembershipType2FontStyle(p_Offer.FIssuerMembershipType)
    else
      FontStyle := [];

    if trim(p_Offer.FIssuerTitle)='C' then begin
      cnv.Brush.Color := fGL.SeekTitleCColor;
      cnv.FillRect(RLogin);
    end;

    TextOutCenter(cnv, RLogin, LoginWithTitle, clBlack, FontSize, FontStyle, true);

    // time control
    CurY := CurY + TextHeight + 2;
    s := GameParamOfferText(p_Offer.MyInitMin, p_Offer.MyInitSec, p_Offer.MyInc);
    TextOut(cnv, TextLeft, CurY, s, clBlue, FontSize, [fsBold]);

    // achievement sign
    if p_Offer.IsAchievementOffer then
      il17.Draw(cnv, R.Right - 4 - 17, CurY, 2);

    // rating
    CurY := CurY + TextHeight + 2;
    if not p_Offer.FProvisional then col := clBlack
    else col := clRed;

    s := IntToStr(p_Offer.FRating);
    TextOut(cnv, TextLeft, CurY, s, col, FontSize, []);

    // rated - unrated
    if p_Offer.FRated and p_Offer.FLoseOnDisconnect then FontStyle := [fsBold]
    else FontStyle := [];

    if p_Offer.FRated then s := 'Rated'
    else s := 'Unrated';

    w := TextWidth(cnv, s, FontSize, FontStyle);
    TextOut(cnv, TextRight - w, CurY, s, clBlack, FontSize, FontStyle);

    // rated type
    CurY := R.Bottom - TextHeight - 2;

    if p_Offer = OfferUnderMouse then FontStyle := [fsBold]
    else FontStyle := [];

    if p_Offer.FRatingType = rtFischer then s := 'Fischer'
    else s := RATED_TYPES[Ord(p_Offer.FRatingType)];
    TextOut(cnv, TextLeft, CurY - BorderLineWidth, s, clBlack, FontSize, FontStyle);

    // piece time odds
    if p_Offer.FOdds.PieceDefined then begin
      bmp := TBitMap.Create;
      pieceSize := 17;
      sPieces := 'PNBRQ';
      GetLittlePieceImage(sPieces[p_Offer.FOdds.FPiece+1], bmp, pieceSize, p_Offer.FOdds.FPieceDirection = oodGive);
      bmp.Canvas.FloodFill(1,1,Color,fsSurface);
      RPiece := Rect(R.Right - pieceSize - 4, R.Bottom - pieceSize - 3, R.Right - 1 - 4, R.Bottom - 1 - 3);
      cnv.CopyRect(RPiece, bmp.Canvas, Rect(0, 0, pieceSize-1, pieceSize-1));
      bmp.Free;
    end;

    // auto time odds
    if p_Offer.FOdds.FAutoTimeOdds or p_Offer.FOdds.TimeDefined then begin
      ImageIndex := BoolTo_(p_Offer.IHaveMoreTime or (p_Offer.FIssuer = fCLSocket.MyName), 0, 1);
      shift := BoolTo_(p_Offer.FOdds.PieceDefined, 34, 17);
      il17.Draw(cnv, R.Right - 4 - shift, R.Bottom - 17 - 3, ImageIndex)
    end;

    AddBaseDrawButton(R, 1, p_Offer.FOfferNumber, true, true);
    p_Offer.FRect := R;
  end;
  //****************************************************************************
  procedure DrawOffers;
  var
    i, left, top, NumX, NumY, NumberInLine, AssignedCell: integer;
  begin
    NumberInLine := Width div (CellWidth + DistanceX);

    for i := 0 to FOfferList.Count - 1 do begin
      AssignedCell := TOffer(FOfferList[i]).FAssignedCell;
      NumX := AssignedCell mod NumberInLine;
      NumY := AssignedCell div NumberInLine;
      left := DistanceX + NumX * (CellWidth + DistanceX);
      top := DistanceY + NumY * (CellHeight + DistanceY) + pnlHeader.Height - Y;
      DrawOffer(TOffer(FOfferList[i]), left, top);
    end;
  end;
  //****************************************************************************
begin
  InitVars;
  Buttons.Clear;
  cnv.Brush.Color := fGL.DefaultBackgroundColor;
  cnv.FillRect(ClientRect);
  DrawOffers;
end;
//==============================================================================
procedure TfCLSeeks.FormCreate(Sender: TObject);
begin
  inherited;
  FOfferList := TObjectList.Create;
end;
//==============================================================================
procedure TfCLSeeks.FormDestroy(Sender: TObject);
begin
  inherited;
  FOfferList.Free;
end;
//==============================================================================
function TfCLSeeks.FindOffer(p_OfferNumber: Integer): TOffer;
var
  index: integer;
begin
  index := FindOfferIndex(p_OfferNumber);
  if index = -1 then result := nil
  else result := TOffer(FOfferList[index]);
end;
//==============================================================================
procedure TfCLSeeks.CMD_ReceiveOffer(CMD: TStrings);
var
  Offer : TOffer;
  L: TLogin;
begin
  Offer := FindOffer(StrToInt(CMD[1]));
  if Offer <> nil then exit;

  if (CMD[6]='C') and fGL.CReject then exit;

  Offer := TOffer.Create;

  with Offer do begin
    FAssignedCell := -1;
    if StrToInt(CMD[0]) = DP_MATCH then
      FOfferType := otMatch
    else
      FOfferType := otSeek;
    FOfferNumber := StrToInt(CMD[1]);
    FColor:= StrToInt(CMD[2]);
    FInitialTime := CMD[3];
    FIncTime := StrToInt(CMD[4]);
    FIssuer := CMD[5];
    FIssuerTitle := CMD[6];
    FProvisional := Boolean(StrToInt(CMD[7]));
    FRated := Boolean(StrToInt(CMD[8]));
    FRating := StrToInt(CMD[9]);
    FRatingType := TRatedType(StrToInt(CMD[10]));
    FLoseOnDisconnect := (CMD.Count>11) and (CMD[11]='1');

    L := fLoginList.LoginByName[FIssuer];
    if L = nil then FIssuerMembershipType := mmbTrial
    else FIssuerMembershipType := L.MembershipType;

    if FProvisional then FGamesCnt := fCLTerminal.NumberOfRatedGames(FIssuer, FRatingType)
    else FGamesCnt := 0;

    FOdds.FAutoTimeOdds := (CMD.Count>12) and (CMD[12]='1');
  end;

  if CMD.Count > 13 then Offer.FOdds.FInitMin := StrToInt(CMD[13]);
  if CMD.Count > 14 then Offer.FOdds.FInitSec := StrToInt(CMD[14]);
  if CMD.Count > 15 then Offer.FOdds.FInc := StrToInt(CMD[15]);
  if CMD.Count > 16 then Offer.FOdds.FPiece := StrToInt(CMD[16]);
  if CMD.Count > 17 then Offer.FOdds.FTimeDirection := TOfferOddsDirection(StrToInt(CMD[17]));
  if CMD.Count > 18 then Offer.FOdds.FPieceDirection := TOfferOddsDirection(StrToInt(CMD[18]));

  InsertOfferToList(Offer);

  PrintTerminalMessage(Offer);
  if Visible then Refresh;
end;
//==============================================================================
procedure TfCLSeeks.CMD_RemoveOffer(CMD: TStrings);
var
  index, OfferNumber: integer;
begin
  OfferNumber := StrToInt(CMD[1]);
  index := FindOfferIndex(OfferNumber);
  if index <> -1 then FOfferList.Delete(index);

  if Visible then Refresh;
end;
//==============================================================================
procedure TfCLSeeks.PrintTerminalMessage(p_Offer: TOffer);
var
  s: string;
begin
  if (p_Offer.FOfferType = otMatch) and (p_Offer.FIssuer <> fCLSocket.MyName) then begin
    s := Trim(p_Offer.FIssuerTitle + ' ' + p_Offer.FIssuer + '(' +  IntToStr(p_Offer.FRating) + ') has challenged you to a');
    if p_Offer.FRated then s := s + ' rated ' else s := s + ' unrated ';
    s := s + '(' + GameParamOfferText(p_Offer.MyInitMin, p_Offer.MyInitSec, p_Offer.MyInc) + ') ';
    s := s + RATED_TYPES[Ord(p_Offer.FRatingType)] + ' game ';
    if p_Offer.FOdds.FAutoTimeOdds or p_Offer.FOdds.Defined then
      s := s + 'with odds';
    if p_Offer.FRated and p_Offer.FLoseOnDisconnect then s:=s+' (Lose On Disconnect)';
    s := s + '.';
    fCLTerminal.ccConsole.AddLine(-1, s, ltMessage);
    if p_Offer.DifferentTime then begin
      fCLTerminal.ccConsole.AddLine(-1, 'Your time: ' + p_Offer.MyTimeStringFull + '.', ltMessage);
      fCLTerminal.ccConsole.AddLine(-1, 'Opponent''s time: ' + p_Offer.OpTimeStringFull + '.', ltMessage);
    end;

    if p_Offer.FOdds.PieceDefined then
      fCLTerminal.ccConsole.AddLine(-1, p_Offer.PieceString + '.', ltMessage);

    s := 'Click "' + CMD_STR_ACCEPT + ' ' + IntToStr(p_Offer.FOfferNumber) + '" to play. ';
    s := s + 'Click "' + CMD_STR_DECLINE + ' ' + IntToStr(p_Offer.FOfferNumber) + '" to decline.';
    fCLTerminal.ccConsole.AddLine(-1, s, ltMessage);

    fGL.PlayCLSound (SI_CHALLENGE);
  end;
end;
//==============================================================================
function TfCLSeeks.FindOfferIndex(p_OfferNumber: integer): integer;
var
  i: integer;
begin
  for i := 0 to FOfferList.Count - 1 do begin
    result := i;
    if TOffer(FOfferList[i]).FOfferNumber = p_OfferNumber then exit;
  end;
  result := -1;
end;
//==============================================================================
procedure TfCLSeeks.pmSeekItemCilck(Sender: TObject);
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
procedure TfCLSeeks.pmSeekPopup(Sender: TObject);
var
  b: Boolean;
  name: string;
begin
  name := TPopupMenu(Sender).Name;
  //b := fCLMain.tbSeek3_0.Down or fCLMain.tbSeek5_0.Down or fCLMain.tbSeek3_2.Down or fCLMain.tbSeek2_12.Down;
  b := (name = 'pmSeek3_0') or (name = 'pmSeek5_0') or (name = 'pmSeek3_2') or (name = 'pmSeek2_12');
  RatedTimeOdds1.Enabled := b;
  RatedTimeOdds2.Enabled := b;
  RatedTimeOdds3.Enabled := b;
  RatedTimeOdds4.Enabled := b;
  UnratedTimeOdds1.Enabled := b;
  UnratedTimeOdds2.Enabled := b;
  UnratedTimeOdds3.Enabled := b;
  UnratedTimeOdds4.Enabled := b;
  CopyPopupMenu(pmSeek, TPopupMenu(Sender));

  if name = 'pmSeek1_0' then FLastPopupButton := fCLMain.tbSeek1_0
  else if name = 'pmSeek3_0' then FLastPopupButton := fCLMain.tbSeek3_0
  else if name = 'pmSeek5_0' then FLastPopupButton := fCLMain.tbSeek5_0
  else if name = 'pmSeek15_0' then FLastPopupButton := fCLMain.tbSeek15_0
  else if name = 'pmSeek3_2' then FLastPopupButton := fCLMain.tbSeek3_2
  else if name = 'pmSeek2_12' then FLastPopupButton := fCLMain.tbSeek2_12;

  fCLMain.tbSeek1_0.Down := false;
  fCLMain.tbSeek3_0.Down := false;
  fCLMain.tbSeek5_0.Down := false;
  fCLMain.tbSeek15_0.Down := false;
  fCLMain.tbSeek3_2.Down := false;
  fCLMain.tbSeek2_12.Down := false;
end;
//==============================================================================
procedure TfCLSeeks.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  ButtonUnderMouse := Buttons.ButtonByXY(X, Y);
  if ButtonUnderMouse = nil then OfferUnderMouse := nil
  else OfferUnderMouse := FindOffer(ButtonUnderMouse.Tag);

  if OfferUnderMouse = nil then begin
    Cursor := crDefault;
    pnlHint.Visible := false;
  end else
    if OfferUnderMouse.FIssuer = fCLSocket.MyName then Cursor := crNo
    else begin
      Cursor := crIEHand;
      ShowHint(OfferUnderMouse);
    end;
  Refresh;
end;
//==============================================================================
procedure TfCLSeeks.OnBaseDrawButtonCilck(btn: TCLBaseDrawButton);
begin
  if OfferUnderMouse.FIssuer <> fCLSocket.MyName then
    fCLSocket.InitialSend([CMD_STR_ACCEPT, IntToStr(OfferUnderMouse.FOfferNumber)]);
end;
//==============================================================================
procedure TfCLSeeks.pmPlayerMenuPopup(Sender: TObject);
begin
  if OfferUnderMouse = nil then begin
    miAccept.Enabled := False;
    miDecline.Enabled := False;
    miRemove.Enabled := False;
    miProfile.Enabled := False;
    miScore.Enabled := False;
  end else begin
    miAccept.Enabled := (OfferUnderMouse.FOfferType = otSeek) or
      (OfferUnderMouse.FIssuer <> fCLSocket.MyName);
    miDecline.Enabled := (OfferUnderMouse.FOfferType = otMatch) and
      (OfferUnderMouse.FIssuer <> fCLSocket.MyName);
    miRemove.Enabled := OfferUnderMouse.FIssuer = fCLSocket.MyName;
    miProfile.Enabled := True;
    miScore.Enabled := (OfferUnderMouse.FIssuer <> fCLSocket.MyName);
  end;
end;
//==============================================================================
procedure TfCLSeeks.miAcceptClick(Sender: TObject);
begin
  if OfferUnderMouse <> nil then
    fCLSocket.InitialSend([CMD_STR_ACCEPT, IntToStr(OfferUnderMouse.FOfferNumber)]);
end;
//==============================================================================
procedure TfCLSeeks.miDeclineClick(Sender: TObject);
begin
  if OfferUnderMouse <> nil then
    fCLSocket.InitialSend([CMD_STR_DECLINE, IntToStr(OfferUnderMouse.FOfferNumber)]);
end;
//==============================================================================
procedure TfCLSeeks.miRemoveClick(Sender: TObject);
begin
  if OfferUnderMouse <> nil then
    fCLSocket.InitialSend([CMD_STR_UNOFFER, IntToStr(OfferUnderMouse.FOfferNumber)]);
end;
//==============================================================================
procedure TfCLSeeks.miProfileClick(Sender: TObject);
begin
  if OfferUnderMouse <> nil then
    fCLSocket.InitialSend([CMD_STR_PROFILE, OfferUnderMouse.FIssuer]);
end;
//==============================================================================
procedure TfCLSeeks.miScoreClick(Sender: TObject);
begin
  if OfferUnderMouse <> nil then
    fCLSocket.InitialSend([CMD_STR_SCORE, OfferUnderMouse.FIssuer]);
end;
//==============================================================================
procedure TfCLSeeks.ShowHint(Offer: TOffer);
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
  begin
    pnlHint.Left := Offer.FRect.Left;
    pnlHint.Top := Offer.FRect.Bottom + 8;
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

  pnlHint.Width := max(maxWidth, CELL_WIDTH + 8);
  {if pnlHint.Width < CELL_WIDTH then
    pnlHint.Width := CELL_WIDTH;}
  pnlHint.Height := maxHeight;
end;
//==============================================================================
procedure TfCLSeeks.MakeToolbarMenu(p_ToolButton: TToolButton);
var
  pm: TPopupMenu;
begin
  if p_ToolButton.DropdownMenu <> nil then exit;
  pm := TPopupMenu.Create(fCLMain);
  CopyPopupMenu(pmSeek, pm);
  pm.Name := 'pm' + copy(p_ToolButton.Name, 3, 255);
  p_ToolButton.DropdownMenu := pm;
end;
//==============================================================================
procedure TfCLSeeks.FormShow(Sender: TObject);
begin
  if fCLMain.tbSeek1_0.DropDownMenu = nil then begin
    MakeToolbarMenu(fCLMain.tbSeek1_0);
    MakeToolbarMenu(fCLMain.tbSeek3_0);
    MakeToolbarMenu(fCLMain.tbSeek5_0);
    MakeToolbarMenu(fCLMain.tbSeek15_0);
    MakeToolbarMenu(fCLMain.tbSeek3_2);
    MakeToolbarMenu(fCLMain.tbSeek2_12);
  end;
end;
//==============================================================================
procedure TfCLSeeks.InsertOfferToList(p_Offer: TOffer);
var
  i: integer;
begin
  i := 0;
  while (i < FOfferList.Count) and (TOffer(FOfferList[i]).FAssignedCell = i) do
    inc(i);
  p_Offer.FAssignedCell := i;
  FOfferList.Insert(i, p_Offer);
end;
//==============================================================================
end.

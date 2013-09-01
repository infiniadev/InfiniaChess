{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLBoard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, CLGame, CLClock, Buttons, ComCtrls, contnrs,
  CLSocket,Math;

type
  TDragSite = (dsNone, dsBoard, dsCaptured);
  TMouseState = (msDown, msExecute, msMoved);

  TfCLBoard = class(TForm)
    BC: TCLClock;
    bntAccept: TButton;
    btnCancel: TButton;
    btnClear: TButton;
    btnReset: TButton;
    bvlDetail: TBevel;
    bvlSetup: TBevel;
    cbBKS: TCheckBox;
    cbBQS: TCheckBox;
    cbWKS: TCheckBox;
    cbWQS: TCheckBox;
    edtPly: TEdit;
    lblBlkName: TLabel;
    lblBlkRating: TLabel;
    lblCastle: TLabel;
    lblColor: TLabel;
    lblEnpassant: TLabel;
    lblEpTarget: TLabel;
    lblRepetable: TLabel;
    lblWhtName: TLabel;
    lblWhtRating: TLabel;
    lvMoves: TListView;
    miAbort: TMenuItem;
    miAdjourn: TMenuItem;
    miAutoQueen: TMenuItem;
    miCaptured: TMenuItem;
    miClose: TMenuItem;
    miCopy: TMenuItem;
    miDetach: TMenuItem;
    miDraw: TMenuItem;
    miFlag: TMenuItem;
    miLogGame: TMenuItem;
    miMoretime: TMenuItem;
    miPasteFEN: TMenuItem;
    miRematch: TMenuItem;    
    miResign: TMenuItem;
    miRotate: TMenuItem;
    miSetup: TMenuItem;
    miTakeback: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    pnlDetails: TPanel;
    pnlSetup: TPanel;
    pupGameMenu: TPopupMenu;
    rbBlack: TRadioButton;
    rbWhite: TRadioButton;
    sbBack: TSpeedButton;
    sbBack10: TSpeedButton;
    sbClose: TSpeedButton;
    sbClose2: TSpeedButton;
    sbEnpassant: TSpeedButton;
    sbForward: TSpeedButton;
    sbForward10: TSpeedButton;
    sbMax: TSpeedButton;
    sbMax2: TSpeedButton;
    sbRevert: TSpeedButton;
    udPly: TUpDown;
    WC: TCLClock;
    pmColor: TPopupMenu;
    pnlCircle: TPanel;
    pnlArrow: TPanel;
    sbCircle: TSpeedButton;
    sbArrow: TSpeedButton;
    pnlLagWhite: TPanel;
    lblLagWhite: TLabel;
    lblLagValueWhite: TLabel;
    pnlLagBlack: TPanel;
    lblLagBlack: TLabel;
    lblLagValueBlack: TLabel;
    lblUpScore: TLabel;
    lblDownScore: TLabel;
    miLibrary: TMenuItem;
    miGameSave: TMenuItem;

    procedure bntAcceptClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lvMovesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miAutoQueenClick(Sender: TObject);
    procedure miAbortClick(Sender: TObject);
    procedure miAdjournClick(Sender: TObject);
    procedure miCapturedClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure miDetachClick(Sender: TObject);
    procedure miDrawClick(Sender: TObject);
    procedure miFlagClick(Sender: TObject);
    procedure miLogGameClick(Sender: TObject);
    procedure miMoretimeClick(Sender: TObject);
    procedure miPasteFENClick(Sender: TObject);
    procedure miRematchClick(Sender: TObject);
    procedure miResignClick(Sender: TObject);
    procedure miRotateClick(Sender: TObject);
    procedure miSetupClick(Sender: TObject);
    procedure miTakebackClick(Sender: TObject);
    procedure MoveButtonClick(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);
    procedure SetSetupRights(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbCircleClick(Sender: TObject);
    procedure sbArrowClick(Sender: TObject);
    procedure pupGameMenuPopup(Sender: TObject);
    procedure miLibraryClick(Sender: TObject);
    procedure miGameSaveClick(Sender: TObject);

  private
    { Private declarations }
    FBrd: TRect; { Area of the Canvas representing the chessboard }
    FBuffer: TBitmap; { Off screen work area }
    FCap: TRect; { Area of the Canvas representing the captured pieces / plunks }
    FCopy: TBitmap; { Square sized bitmap for work area }
    FDragSource: TDragSite;
    FDraw: TList;
    FGames: TObjectList; { List of TCLGames being managed }
    FGM: TCLGame; { The active TCLGame }
    FLastMoveNumber: Integer; { Last move number displayed in TListView for moves }
    FLoading: Boolean;
    FMask: TBitmap; { Bitmap of masks for FPieces }
    FMouseState: set of TMouseState;
    FMouseX: Integer; { Mouse X,Y shared between mouse events }
    FMouseY: Integer;
    FOrgX: Integer; { The chessboard (captured area) file and rank calculated in the OnMouseDownEvent }
    FOrgY: Integer;
    FPaint: Boolean; { Set to true for OnPaint to avoid some excess painting functions }
    FPieceDragged: Integer; { Internal value of the piece being dragged }
    FPieces: TBitmap; { Bitmap of chess pieces }
    FPieceSize: Integer; { Size in pixels of FPieces to bitblt }
    FPieceX: Integer; { The pixel position in FPieces of the piece to draw }
    FPieceY: Integer;
    FRefX: Integer; { Left Top FBrd or FCap pixel position of the FOrgX, FOrgY value }
    FRefY: Integer; { ex FBrd.Left + (FOrgX * FSquareSize }
    FSmartMove: Boolean;
    FSquare: TBitmap; { Square sized bitmap for work area }
    FSquareSize: Integer; { FBrd width div 8, pixel size of a chessboard square }
    FXOff: Integer; { Pixel offset to center a piece on a square }
    FFromCC: integer; { Square "from" in CC Style}
    FCurX: integer;
    FCurY: integer;
    FMouseCurX: integer;
    FMouseCurY: integer;
    FDoingPremove: Boolean;
    FStrCircleColor: string;
    FStrArrowColor: string;
    FCircleColor: TColor;
    FArrowColor: TColor;

    function ClearPremove: Boolean;
    procedure DrawBoard(Sender: TObject; const Pos1, Pos2: Integer;
      const Action: TDrawAction);

    procedure DrawLegal(Square: Integer);
    procedure DrawMarkers(const _Canvas: TCanvas); { Lines & Cirlcs }
    procedure DrawMoveSquare(MouseX,MouseY: integer);
    procedure EraseLegal;
    procedure GameModeChanged(Sender: TObject);
    function  GetMSec: string;
    procedure InvertBoard(Sender: TObject);
    procedure InvertXY(var X, Y: Integer);
    procedure MarkerAdded(Sender: TObject);
    procedure MarkerRemoved(Sender: TObject);
    procedure MoveInExGame(const Moves: Integer);
    procedure MoveLocally(const Moves: Integer);
    procedure PositionControls;
    procedure ProcessSmartMove(const Square: Integer);
    procedure SetGM(const Value: TCLGame);
    procedure WMEraseBkgnd(var Msg: TMessage); message WM_ERASEBKGND;
    procedure TogglePanels;
    procedure UpdateMoveList(const Action: TDrawAction);
    procedure UpdateSetupPanel;
    procedure ZeroTime(Sender: TObject);
    procedure PutThemeSquare(Canvas: TCanvas; Light: Boolean; W: integer);
    procedure CreatePMColor;
    procedure ColorMenuClick(Sender: TObject);
    procedure ShowPanelsColor;

  public
    { Public declarations }
    PGNPlaySound: string;
    property Pieces: TBitMap read FPieces;
    function  CreateGame: TCLGame;
    procedure RemoveGame(const Game: TCLGame);
    procedure KillGame(const Game: TCLGame; AskQuestion: Boolean = true);
    procedure DoPremove(const Game: TCLGame);
    function DoTurn(From,_To: integer): Boolean;
    procedure DrawArrow(_Canvas: TCanvas; X1,Y1,X2,Y2: integer; Color: TColor; Width: integer);
    function  Game(const GameNumber: Integer; p_LiveOnly: Boolean = true): TCLGame;
    function  GameCount: Integer;
    function  UsualGameCount: Integer;
    procedure ColorizePieces;
    procedure Disconnect;
    procedure SetClockEnabled(const Sender: TObject);
    procedure SetTime(Sender: TObject);
    procedure ShowCheatLights;
    procedure DrawBoardFull;
    procedure AddSquaresToDraw;
    procedure DrawBoard2(const Pos1, Pos2: Integer; const Action: TDrawAction);
    procedure OnUserLag(Login: string; Lag: integer);
    procedure ShowGameScore;
    procedure SetMenuState;
    procedure CMD_GameQuit(CMD: TStrings);

    property GM: TCLGame read FGM write SetGM;

  end;

var
  fCLBoard: TfCLBoard;

implementation
{$R CLImages.RES}
{$R *.DFM}

uses
  CLConst, CLGlobal, CLMain, CLNavigate, CLPromotion, CLPgn, CLTerminal,
  CLFilterManager, CLTakeback, CLMoreTime, Clipbrd, CLLib, PngUnit,
  CLEvents, CLEventControl, CLOfferOdds, CLSeek, CLLectures;

var PieceSizes: array [1..18] of integer = (21,25,29,33,37,40,45,49,54,58,64,72,80,87,95,108,116,129);

//______________________________________________________________________________
procedure TfCLBoard.DrawBoard(Sender: TObject; const Pos1, Pos2: Integer;
  const Action: TDrawAction);
begin
  if not (Sender = GM) then Exit;

  if not ((Pos1 = Pos2) and (Action = daPaintDiff)) then
    DrawBoard2(Pos1, Pos2, Action);
  if (Pos2 > Pos1) and (Action = daPaintDiff) then fGL.PlayCLSound(SI_LEGAL);
  UpdateMoveList(Action);
end;
//______________________________________________________________________________
function CheatModeToColor(CM: TCheatMode): TColor;
begin
  case CM of
    chmGreen: result:=clBtnFace;
    chmYellow: result:=clYellow;
    chmRed: result:=clRed;
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.DrawBoard2(const Pos1, Pos2: Integer;
  const Action: TDrawAction);
var
  R: TRect;
  Move1, Move2: TMove;
  i,Index, Square, Piece, A, B, X, Y, W, X1,Y1,X2,Y2: Integer;
  S: string;
  cl: TColor;
const
  ENPASSANT = 64;
  CASTLE = 65;
  EMPTY = 72;
  //****************************************************************************
  procedure DrawHighlightSquare;
  begin
    { Draw Highlight square if necessary }
    if ((Square = Move2.FFrom) or (Square = Move2.FTo))
    and not ( GM.SquareIsPremove(Square) and fGL.Premove and (GM.RatingType<>rtCrazy) )
    and (Pos2 > 0) and (fGL.ShowLastMoveType=0) and not GM.Setup then
      with FSquare.Canvas.Pen do
        begin
          Color := fGL.HighLight;
          Width := 2;
          FSquare.Canvas.Rectangle(1, 1, FSquareSize, FSquareSize);
        end
    else if GM.SquareIsPremove(Square)
      and fGL.Premove and (GM.RatingType<>rtCrazy) and not GM.Setup and (fGL.PremoveStyle<>PREMOVE_ARROW)
    then
      with FSquare.Canvas.Pen do begin
        Color := fGL.PremoveColor;
        Width := 2;
        FSquare.Canvas.Rectangle(1, 1, FSquareSize, FSquareSize);
      end
    else if (fGL.MoveStyle = MOVE_STYLE_CC) and (Square = FFromCC) then
        with FSquare.Canvas.Pen do
        begin
          Color := fGL.ClickColor;
          Width := 2;
          FSquare.Canvas.Rectangle(1, 1, FSquareSize, FSquareSize);
        end
    else
      with FSquare.Canvas.Pen do
        begin
          if FGL.DrawBoardLines then Color:=fGL.BoardLinesColor
          else Color := FSquare.Canvas.Brush.Color;
          Width := 1;
          FSquare.Canvas.Rectangle(0, 0, FSquareSize, FSquareSize);
        end;
    if (fGL.ThemeSquareIndex <> -1) and not fGL.DrawBoardLines then w:=0
    else w:=FSquare.Canvas.Pen.Width;
    PutThemeSquare(FSquare.Canvas,(x+y) mod 2 = 0, w);
  end;
  //****************************************************************************
  procedure PutBoardPiece;
  begin
    if (Piece <> 0) and
    (not (msExecute in FMouseState)
    or ((msExecute in FMouseState)
    and ((Move2.FPosition[XYToSqr(FOrgX, FOrgY)] <> FPieceDragged)
    or (Square <> XYToSqr(FOrgX, FOrgY))))) then
      begin
        if Piece < 0 then B := FPieceSize else B := 0;
        A := Abs(Piece * FPieceSize) - FPieceSize;
        BitBlt(FSquare.Canvas.Handle, FXOff, FXOff,
          FPieceSize, FPieceSize, FMask.Canvas.Handle, A, B, SRCPAINT);
        DrawTransparentBmp(FSquare.Canvas, FPieces, A, B, FPieceSize, FPieceSize,
          FXOff, FXOff, PIECES_TRANSPARENT_COLOR);
        {BitBlt(FSquare.Canvas.Handle, FXOff, FXOff,
          FPieceSize, FPieceSize, FPieces.Canvas.Handle, A, B, SRCAND);}
      end;

    BitBlt(Canvas.Handle, FBrd.Left + X * FSquareSize,
      FBrd.Top + Y * FSquareSize, FSquareSize, FSquareSize,
      FSquare.Canvas.Handle, 0, 0, SRCCOPY);
  end;
  //****************************************************************************
  procedure PutCapturedPiece;
  begin
    FSquare.Canvas.FillRect(Rect(0, 0, FSquareSize, FSquareSize));
    SqrToXY(Square, X, Y);
    A := (Y - 1) * FPieceSize;
    B := X * FPieceSize;

    { Not really piece, but the count of the piece position }
    if (Piece <> 0) or GM.Setup then
      begin
        if not GM.Setup then
          FSquare.Canvas.TextOut(2 + X* (FSquareSize-12), 2,
            IntToStr(Piece));
        BitBlt(FSquare.Canvas.Handle, FXOff, FXOff,
          FPieceSize, FPieceSize, FMask.Canvas.Handle, A, B, SRCPAINT);
        DrawTransparentBmp(FSquare.Canvas, FPieces, A, B, FPieceSize, FPieceSize,
          FXOff, FXOff, PIECES_TRANSPARENT_COLOR);
        {BitBlt(FSquare.Canvas.Handle, FXOff, FXOff,
          FPieceSize, FPieceSize, FPieces.Canvas.Handle, A, B, SRCAND);}
      end;
    BitBlt(Canvas.Handle, FCap.Left + X * FSquareSize,
      FCap.Top + (6 - Y) * FSquareSize, FSquareSize, FSquareSize,
      FSquare.Canvas.Handle, 0, 0, SRCCOPY);
  end;
  //****************************************************************************
  procedure DrawPremoveArrow(_Canvas: TCanvas; Premove: TMove);
  var X1,X2,Y1,Y2: integer;
  begin
    if fGL.PremoveStyle=PREMOVE_SQUARE then exit;
    if (Premove.FType=mtIllegal) or not fGL.Premove or (GM.RatingType=rtCrazy) then exit;
    SqrToXY(Premove.FFrom,X1,Y1);
    SqrToXY(Premove.FTo,X2,Y2);
    InvertXY(X1,Y1); InvertXY(X2,Y2);
    DrawArrow(_Canvas,X1,Y1,X2,Y2,fGL.PremoveColor,2);
  end;
  //****************************************************************************
begin
  { Pos1 = the old position. Pos2 = the new position. }
  Canvas.Lock;
  try
  if DEBUGGING then
    begin
      if GM.Switched then cl:=clYellow else cl:=clGreen;
      Canvas.Brush.Color:=cl;
      Canvas.Rectangle(1,1,20,20);
    end;

  ShowCheatLights;
  Move1 := TMove(GM.Moves[Pos1]);
  if GM.Setup then Move2 := GM.SetupMove else Move2 := TMove(GM.Moves[Pos2]);

  { Add squares that need drawing to FDraw. }
  if Action in [daPaintSameBoard, daPaintNewBoard] then
    begin
      FDraw.Clear;
      for X := Low(TPosition) to High(TPosition) do
        if not (X in [ENPASSANT, CASTLE, EMPTY]) then FDraw.Add(Pointer(X));
    end
  else if Action = daPaintDiff then
    begin
      for X := Low(TPosition) to High(TPosition) do
        if not (X in [ENPASSANT, CASTLE, EMPTY]) then
          if Move1.FPosition[X] <> Move2.FPosition[X] then
            FDraw.Add(Pointer(X));
      if (fGL.ShowLastMoveType=0) then
        begin
          FDraw.Add(Pointer(Move1.FFrom));
          FDraw.Add(Pointer(Move1.FTo));
          FDraw.Add(Pointer(Move2.FFrom));
          FDraw.Add(Pointer(Move2.FTo));
        end;
      {if fGL.Premove and (GM.Premove.FType=mtNormal) then
        begin
          FDraw.Add(Pointer(GM.Premove.FFrom));
          FDraw.Add(Pointer(GM.Premove.FTo));
        end;}
    end;

  if (fGL.MoveStyle = MOVE_STYLE_CC) and (FFromCC<>-1) then
    FDraw.Add(Pointer(FFromCC));

  { ??? if GM.Setup then for X := 66 to 78 do if not (X = 72) then
    FDraw.Add(Pointer(X)); }

  if FDraw.Count = 0 then Exit;

  { The first step is to erase the piece being dragged (if any) from the board }
  if (msExecute in FMouseState) then
    BitBlt(Canvas.Handle, FRefX, FRefY, FSquareSize, FSquareSize,
      FCopy.Canvas.Handle, 0, 0, SRCCOPY);

  { Loop through all the squares that need drawing and draw them. }
  for Index := 0 to FDraw.Count -1 do
    begin
      Square := Integer(FDraw[Index]);
      Piece := Move2.FPosition[Square];
      SqrToXY(Square, X, Y);
      InvertXY(X, Y);

      if Square > BOARD_MAX then
         FSquare.Canvas.Brush.Color := Color
      else
        if Odd(X) xor Odd(Y) then
          FSquare.Canvas.Brush.Color := fGL.DarkSquare
        else
          FSquare.Canvas.Brush.Color := fGL.LightSquare;

      DrawHighlightSquare;

      // Actual board area
      if Square <= BOARD_MAX then
        PutBoardPiece
      else if (Square > BOARD_MAX) and (GM.ShowCaptured or GM.Setup) then
        PutCapturedPiece;
    end;

  { If piece being held is not captured prepare for the possibility that it
   was over the square that the incoming move went to. }
  if (Move1.FPosition[XYToSqr(FOrgX, FOrgY)] = FPieceDragged) and
    (msExecute in FMouseState)
  then
    begin
      if not FPaint then
        BitBlt(FCopy.Canvas.Handle, 0, 0, FSquareSize, FSquareSize,
          Canvas.Handle, FRefX, FRefY, SRCCOPY);
      BitBlt(FBuffer.Canvas.Handle, FRefX, FRefY, FSquareSize, FSquareSize,
        FCopy.Canvas.Handle, 0, 0, SRCCOPY);
      BitBlt(FBuffer.Canvas.Handle, FRefX + FXOff, FRefY + FXOff,
        FPieceSize, FPieceSize,
        FMask.Canvas.Handle, FPieceX, FPieceY, SRCPAINT);
      BitBlt(FBuffer.Canvas.Handle, FRefX + FXOff, FRefY + FXOff,
        FPieceSize, FPieceSize,
        FPieces.Canvas.Handle, FPieceX, FPieceY, SRCAND);
      BitBlt(Canvas.Handle, FRefX, FRefY, FSquareSize, FSquareSize,
        FBuffer.Canvas.Handle, FRefX, FRefY, SRCCOPY);
    end
  else
    { This is all that needs to be done if the piece being held was captured
    since we already erased it from the board in the beginning of the
    procedure }
    FMouseState := FMouseState - [msExecute] - [msMoved];

  { Circles and Arrows }
  if not GM.Setup then DrawMarkers(Canvas);

  for i:=1 to GM.PremovesCount do
    DrawPremoveArrow(Canvas,GM.Premove[i]);

  { Score }
  if GM.Setup or GM.ShowCaptured then
    begin
      Canvas.Brush.Color := Self.Color;
      Canvas.Font.Size := 12;
      { Black Score }
      s := IntToStr(GM.BlackScore) + ' (' + IntToStr(GM.BlackScore
        - GM.WhiteScore) + ')';
      X := (FCap.Right - FCap.Left - Canvas.TextWidth(s)) div 2;
      Y := Canvas.TextHeight(s);
      if GM.Inverted then
        R := Rect(FCap.Left, FCap.Bottom + 10, FCap.Right, FCap.Bottom + 10 + Y)
      else
        R := Rect(FCap.Left, FCap.Top - 10 - Y, FCap.Right, FCap.Top - 10);
      Canvas.TextRect(R, R.Left + X, R.Top, s);
      { White Score }
      s := IntToStr(GM.WhiteScore) + ' (' + IntToStr(GM.WhiteScore
         - GM.BlackScore) + ')';
      X := (FCap.Right - FCap.Left - Canvas.TextWidth(s)) div 2;
      if GM.Inverted then
        R := Rect(FCap.Left, FCap.Top - 10 - Y, FCap.Right, FCap.Top - 10)
      else
        R := Rect(FCap.Left, FCap.Bottom + 10, FCap.Right, FCap.Bottom + 10 + Y);
      Canvas.TextRect(R, R.Left + X, R.Top, s);
    end;

  FPaint := False;
  FDraw.Clear;

  if (fGL.ShowLastMoveType = 1) and (Move2 <> nil) and (Move2.FFrom<>0) then begin
    SqrToXY(Move2.FFrom,X1,Y1);
    SqrToXY(Move2.FTo,X2,Y2);
    InvertXY(X1,Y1); InvertXY(X2,Y2);
    DrawArrow(Canvas,X1,Y1,X2,Y2,fGL.Highlight,2);
  end;
  OnMouseMove(Self,[],FMouseX,FMouseY);
  finally
    Canvas.Unlock;
    {try
      if PGNPlaySound <> '' then begin
        fSoundMovesLib.PlayMoveSound(PGNPlaySound,0);
        PGNPlaySound:='';
      end;
    except
      on E: Exception do
        ShowException(E, ExceptAddr);
    end;}
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.DrawLegal(Square: Integer);
var
  Move: TLegalMove;
  Index, X, Y: Integer;
begin
  if fGL.ShowLegal then
    begin
      FDraw.Clear;
      { Build a list of all the legal squares given the Square param.
        A persistant list is necessary to know what squares to undraw in the
        event the legal moves list changes. }
      for Index := 0 to GM.LegalMoves.Count -1 do
        begin
          Move := TLegalMove(GM.LegalMoves[Index]);
          if Move.FFrom = Square then FDraw.Add(Pointer(Move.FTo));
        end;

      { Draw the circles }  
      with Canvas do
        begin
          Brush.Style := bsClear;
          for Index := 0 To FDraw.Count - 1 do
            begin
              Square := Integer(FDraw[Index]);
              SqrToXY(Square, X, Y);
              InvertXY(X, Y);
              X := FSquareSize div 4 + X * FSquareSize + FBrd.Left;
              Y := FSquareSize div 4 + Y * FSquareSize + FBrd.Top;
              Ellipse (X, Y, X + FSquareSize div 2, Y + FSquareSize div 2);
            end;
        end;
    end;
end;
//______________________________________________________________________________
procedure TfCLBoard.DrawMarkers(const _Canvas: TCanvas);
var
  Marker: TMarker;
  Index, X1, Y1, X2, Y2: Integer;
  { Arrow head variables. }
begin
  if not Assigned(GM) or not fGL.ShowArrows then Exit;

  _Canvas.Pen.Color := fGL.HighLight;
  _Canvas.Pen.Width := 3;

  for Index := GM.Markers.Count -1 downto 0 do
    begin
      Marker := GM.Markers[Index];
      SqrToXY(Marker.FFrom, X1, Y1);
      SqrToXY(Marker.FTo, X2, Y2);
      InvertXY(X1, Y1);
      InvertXY(X2, Y2);
      _Canvas.Pen.Color:=Marker.FColor;
      _Canvas.Brush.Color:=Marker.FColor;
      if Marker.FTo = -1 then
        { Circle }
        begin
          X1 := FBrd.Left + X1 * FSquareSize + 1;
          Y1 := FBrd.Top + Y1 * FSquareSize + 1;
          _Canvas.Brush.Style := bsClear;
          _Canvas.Ellipse (X1, Y1, X1 + FSquareSize -1, Y1 + FSquareSize -1);
        end
      else
        { Lines }
        begin
          DrawArrow(_Canvas,X1,Y1,X2,Y2,Marker.FColor,3);
//          _Canvas.Ellipse(X2-3, Y2-3, X2+3, Y2+3);
        end;
    end;
end;
//______________________________________________________________________________
procedure TfCLBoard.EraseLegal;
begin
  if FDraw.Count = 0 then Exit;
  DrawBoard2(0, GM.MoveNumber, daNone);
end;
//______________________________________________________________________________
procedure TfCLBoard.GameModeChanged(Sender: TObject);
var
  Index: Integer;
begin
  { Game mode (gmCLSExamine, gmCLSObserve, etc) changed. Update fCLNavigate }
  with fCLNavigate.clNavigate do
    begin
      Index := Items.IndexOfObject(Sender);
      if Index > -1 then Items[Index] := TCLGame(Sender).GameModeString;
    end;
  SetMenuState;
  ShowPanelsColor;
end;
//______________________________________________________________________________
function TfCLBoard.GetMSec: string;
begin
  { Used to get the time to send to the server during a gmCLSLive game. }
  if GM = nil then Exit;
  Result := IntToStr(Trunc((Now - GM.MoveTS) * MSecsPerDay));
end;
//______________________________________________________________________________
procedure TfCLBoard.InvertBoard(Sender: TObject);
begin
  if Sender <> GM then Exit;
  PositionControls;
  ShowGameScore;
  Refresh;
end;
//______________________________________________________________________________
procedure TfCLBoard.InvertXY(var X, Y: Integer);
begin
  { Inverts X, Y. Used to draw the board when white in on top. }
  if not Assigned(GM) then Exit;

  if GM.Inverted then
    begin
      X := 7 - X;
      Y := 7 - Y;
    end;
end;
//______________________________________________________________________________
procedure TfCLBoard.KillGame(const Game: TCLGame; AskQuestion: Boolean = true);
var
  S, msg, cmd: string;
begin
  { Give the loser a chance if he/she is a live game. }
  if Game = nil then exit;
  if Game.MoveTotal > 5 then begin
    msg := 'resign';
    cmd := CMD_STR_RESIGN;
  end else begin
    msg := 'abort';
    cmd := CMD_STR_ABORT;
  end;

  if AskQuestion and (Game.GameMode in [gmCLSLive]) then
    if MessageDlg('Are you sure you want to '+msg+'?',
    mtConfirmation, [mbYes, mbNo, mbCancel], 0) <> mrYes then Exit;

  { Inform the server }
  S := IntToStr(Game.GameNumber);
  with fCLSocket do
    case Game.GameMode of
      gmCLSExamine, gmCLSObserve, gmCLSObEx: InitialSend([CMD_STR_QUIT, S]);
      gmCLSLive:
        begin
          InitialSend([cmd, S]);
          InitialSend([CMD_STR_QUIT, S]);
        end;
    end;

  RemoveGame(Game);
end;
//______________________________________________________________________________
procedure TfCLBoard.MarkerAdded(Sender: TObject);
begin
  if Sender = GM then DrawMarkers(Canvas);
end;
//______________________________________________________________________________
procedure TfCLBoard.MarkerRemoved(Sender: TObject);
begin
  { Redrawing the entire board is the easiest way to remove a marker(s) }
  if Sender = GM then DrawBoard2(0, GM.MoveNumber, daPaintSameBoard);
end;
//______________________________________________________________________________
procedure TfCLBoard.MoveInExGame(const Moves: Integer);
var
  S: string;
begin
  S := '';
  if GM.GameMode = gmCLSExamine then S := IntToStr(GM.GameNumber);

  if Moves = 0 then
    fCLSocket.InitialSend([CMD_STR_REVERT, S])
  else if Moves > 0 then
    fCLSocket.InitialSend([CMD_STR_FORWARD, S, IntToStr(Moves)])
  else if Moves < 0 then
    fCLSocket.InitialSend([CMD_STR_BACK, S, IntToStr(Moves * -1)]);
end;
//______________________________________________________________________________
procedure TfCLBoard.MoveLocally(const Moves: Integer);
begin
  { Requires non-complete boolean eval!! }
  if not Assigned(GM) or GM.Setup then Exit;

  if Moves = 0 then
    GM.Revert
  else
    GM.MoveTo(GM.MoveNumber + Moves);
end;
//______________________________________________________________________________
procedure TfCLBoard.PositionControls;
var
  ABlack, AWhite: TAnchors;
  YBlack, YWhite: Integer;
begin
  { if not Assigned (GM) then Exit }
  if not GM.Inverted then
    begin
      ABlack := [akLeft, akTop];
      YBlack := 20;
      AWhite := [akLeft, akBottom];
      YWhite := pnlDetails.Height - Trunc(58 / (96 / PixelsPerInch)) - 20;
    end
  else
    begin
      ABlack := [akLeft, akBottom];
      YBlack := pnlDetails.Height - Trunc(58 / (96 / PixelsPerInch)) - 20;
      AWhite := [akLeft, akTop];
      YWhite := 20;
    end;

  { Blacks Controls }
  lblBlkName.Anchors := ABlack;
  lblBlkName.Top := YBlack;
  lblBlkRating.Anchors := ABlack;
  lblBlkRating.Top := YBlack+20;
  BC.Anchors := ABlack;
  BC.Top := lblBlkRating.Top + 20;
  pnlLagBlack.Top:=BC.Top;
  { Whites Controls }
  lblWhtName.Anchors := AWhite;
  lblWhtName.Top := YWhite;
  lblWhtRating.Anchors := AWhite;
  lblWhtRating.Top := YWhite+20;
  WC.Anchors := AWhite;
  WC.Top := lblWhtRating.Top + 20;
  pnlLagWhite.Top:=WC.Top;
  {pnlWhiteLight.Top:=lblWhtRating.Top;
  pnlBlackLight.Top:=lblBlkRating.Top;}
end;
//______________________________________________________________________________
procedure TfCLBoard.ProcessSmartMove(const Square: Integer);
begin
  { Must set so FormMouseUp will not reject the call. The idea is simply to
    make the app think the mouse was actually moved to and released over the
    area indicated by the Square param. }
  FMouseState := [msExecute];

  { Aids in drawing procedures }
  FSmartMove := True;

  { Generate the X, Y paramaters to send to the MouseUpEvent}
  SqrToXY(Square, FRefX, FRefY);
  InvertXY(FRefX, FRefY);
  FRefX := FRefX * FSquareSize + FBrd.Left;
  FRefY := FRefY * FSquareSize + FBrd.Top;

  FormMouseUp(nil, mbLeft, [ssShift], FRefX, FRefY);
end;
//______________________________________________________________________________
procedure TfCLBoard.SetGM(const Value: TCLGame);
var
  Mode: TGameMode;
  Index, GameCount: Integer;
  col: TUserColor;
  ev: TCSEvent;
begin
  if Value = FGM then Exit;
  FGM := Value;
  if not Assigned(FGM) then Exit;

  { Menu options are based upon many game options. }
  SetMenuState;

  { Set the names and ratings }
  lblWhtName.Caption := GetNameWithTitle(GM.WhiteName,GM.WhiteTitle);
  lblWhtRating.Caption := GM.WhiteRating;
  lblBlkName.Caption := GetNameWithTitle(GM.BlackName,GM.BlackTitle);
  lblBlkRating.Caption := GM.BlackRating;

  { Check for the possibility of simultaneous games.
    Issue 'primary' command if necessary. }
  GameCount := 0;
  Mode := FGM.GameMode;
  if not (Mode = gmNone) then
    begin
      for Index := 0 to FGames.Count -1 do
        begin
          if TCLGame(FGames[Index]).GameMode
          in [gmCLSExamine, gmCLSLive, gmCLSObserve, gmCLSObEx] then
            Inc(GameCount);
          if GameCount > 1 then Break;
        end;
      if GameCount > 1 then
        fCLSocket.InitialSend([CMD_STR_PRIMARY, IntToStr(FGM.GameNumber)]);
    end;

  { Resize calls Paint }
  Resize;
  TogglePanels;
  PositionControls;
  UpdateMoveList(daPaintNewBoard);
  SetTime(GM);
  SetClockEnabled(GM);

  col:=GM.UserColor(fCLSocket.MyName);
  WC.SoundEnabled := fGL.TimeEndingEnabled and (col = uscWhite) and (GM.GameMode = gmCLSLive);
  BC.SoundEnabled := fGL.TimeEndingEnabled and (col = uscBlack) and (GM.GameMode = gmCLSLive);

  if GM.Setup then UpdateSetupPanel;
  ev := nil;
  if GM.EventID <> 0 then
    ev := fCLEvents.FindEvent(GM.EventID);
  sbClose.Enabled := ev = nil;
  FFromCC:=-1;
  ShowPanelsColor;
  OnUserLag(GM.WhiteName,fPingValues[GM.WhiteName]);
  OnUserLag(GM.BlackName,fPingValues[GM.BlackName]);
  ShowGameScore;
end;
//______________________________________________________________________________
procedure TfCLBoard.SetMenuState;
begin
  if not Assigned(GM) then Exit;

  miAbort.Enabled := GM.GameMode in [gmCLSLive];
  miAdjourn.Enabled := GM.GameMode in [gmCLSLive];
  miDraw.Enabled := GM.GameMode in [gmCLSLive];
  miFlag.Enabled := GM.GameMode in [gmCLSLive];
  miResign.Enabled := GM.GameMode in [gmCLSLive];
  miTakeback.Enabled := GM.GameMode in [gmCLSLive];
  miMoretime.Enabled := GM.GameMode in [gmCLSLive];
  miRematch.Enabled := (GM.GameMode in [gmNone, gmCLSExamine]) and
    (GM.MyColor <> 0) and (GM.WhiteName <> GM.BlackName);
  miGameSave.Enabled := GM.GameMode in [gmNone, gmCLSExamine];
  miAutoQueen.Checked := GM.AutoQueen;
  miLogGame.Enabled := GM.GameMode in [gmCLSLive, gmCLSObserve];
  miLogGame.Checked := GM.LogGame;
  miSetup.Enabled := GM.GameMode in [gmNone, gmCLSExamine];
  miPasteFEN.Enabled := GM.GameMode in [gmNone, gmCLSExamine];
  miCaptured.Checked := GM.ShowCaptured;
  miDetach.Enabled := GM.GameMode in [gmCLSExamine, gmCLSObserve, gmCLSObEx];

  with fCLMain do
    begin
      miAbort.Enabled := Self.miAbort.Enabled;
      miAdjourn.Enabled := Self.miAdjourn.Enabled;
      miDraw.Enabled := Self.miDraw.Enabled;
      miFlag.Enabled := Self.miFlag.Enabled;
      miResign.Enabled := Self.miResign.Enabled;
      miTakeback.Enabled := Self.miTakeback.Enabled;
      miMoretime.Enabled := Self.miMoretime.Enabled;
      miRematch.Enabled := Self.miRematch.Enabled;
      miAutoQueen.Checked := Self.miAutoQueen.Checked;
      miLogGame.Enabled := Self.miLogGame.Enabled;
      miLogGame.Checked := Self.miLogGame.Checked;
      miSetup.Enabled := Self.miSetup.Enabled;
      miPasteFEN.Enabled := Self.miPasteFEN.Enabled;
      miCaptured.Checked := Self.miCaptured.Checked;
      miDetach.Enabled := Self.miDetach.Enabled;
      miGameSave.Enabled := Self.miGameSave.Enabled;
      tbAbort.Visible := Self.miAbort.Enabled;
      tbAdjourn.Visible :=  Self.miAdjourn.Enabled;
      tbDraw.Visible := Self.miDraw.Enabled;
      tbFlag.Visible := Self.miFlag.Enabled;
      tbMoretime.Visible := Self.miMoretime.Enabled;
      tbResign.Visible := Self.miResign.Enabled;
      tbTakeback.Visible := Self.miTakeback.Enabled;
      tbRematch.Visible := Self.miRematch.Enabled;
      tbGameSave.Visible := Self.miGameSave.Enabled;
    end;
end;
//______________________________________________________________________________
procedure TfCLBoard.TogglePanels;
begin
  { Show/Hide panels based upon the Setup property. It's important to hide
    one panel before showing the other, this prevents both being shown at the
    same time for a split second, which causes flicker. }
  if GM.Setup then
    begin
      pnlDetails.Hide;
      pnlSetup.Show;
    end
  else
    begin
      pnlSetup.Hide;
      pnlDetails.Show;
    end;
end;
//______________________________________________________________________________
procedure TfCLBoard.WMEraseBkgnd(var Msg: TMessage);
begin
  { Trap, but do not process }
end;
//______________________________________________________________________________
procedure TfCLBoard.UpdateMoveList(const Action: TDrawAction);
var
  Lock: Boolean;
  Color, Index, Move, Row: Integer;
  pgn: string;
begin
  { This procedure gets called from the DrawBoard routine. The Action param
    indicates what type of drawing was being done, it can tell us how to deal
    with the move list. }
  if Action in [daNone, daPaintSameBoard] then Exit;

  Move := GM.MoveNumber;
  { Lots of adds removes, so lock the control. Reduces flicker. }
  Lock := (Action =  daPaintNewBoard) or (Abs(Move - FLastMoveNumber) > 3);
  { What color made the move. }
  Color := TMove(GM.Moves[Move]).FColor;
  { Determine the ROW of the ListControl. Could be based upon Odd/Even of
    MoveNumber except the potential exists for Black to start the game. }
  if ((Color = WHITE) and Odd(Move)) or ((Color = BLACK) and not Odd(Move)) then
    Row := (Move -1) div 2
  else
    Row := Move div 2;
  if Row < 0 then Row := 0;

  if Lock then lvMoves.Items.BeginUpdate;

  { Means either a brand new board with zero moves or changed to a different
    board. }
  if Action = daPaintNewBoard then
    begin
      lvMoves.Items.Clear;
      FLastMoveNumber := 0;
    end;

  { Add }
  if Move > FLastMoveNumber then
    begin
      Color := TMove(GM.Moves[FLastMoveNumber + 1]).FColor;
      for Index := FLastMoveNumber + 1 to Move do
        begin
          if (Color = WHITE) or (lvMoves.Items.Count = 0) then
            with lvMoves.Items.Add do
              begin
                Caption := IntToStr(lvMoves.Items.Count);
                SubItems.Add('');
                SubItems.Add('');
                MakeVisible(True);
              end;

          Row := lvMoves.Items.Count -1;
          pgn:=GM.GetPGN(Index);
          if Color = WHITE then
            lvMoves.Items[Row].SubItems[0] := pgn
          else
            lvMoves.Items[Row].SubItems[1] := pgn;

          Color := -Color;
        end;
    end
  { Update }
  else if (Move = FLastMoveNumber) and (lvMoves.Items.Count > 0) then
    begin
      if Color = WHITE then
        lvMoves.Items[Row].SubItems[0] := GM.GetPGN(Move)
      else
        lvMoves.Items[Row].SubItems[1] := GM.GetPGN(Move);
    end
  { Remove }
  else if Move < FLastMoveNumber then
    begin
      { The 'while' statement removes all but the first row. A different check
        is required for that. }
      while lvMoves.Items.Count > Row + 1 do lvMoves.Items.Delete(Row + 1);
      if (Color = WHITE) and (lvMoves.Items.Count > 0) then
        lvMoves.Items[Row].SubItems[1] :=  '';
      if (Move = 0) then lvMoves.Items.Delete(0);
    end;

  FLastMoveNumber := Move;
  if Lock then lvMoves.Items.EndUpdate;
end;
//______________________________________________________________________________
procedure TfCLBoard.UpdateSetupPanel;
var
  Move: TMove;
begin
  FLoading := True;
  Move := GM.SetupMove;
  if Move.FColor = WHITE then
    rbBlack.Checked := True
  else
    rbWhite.Checked := True;
  cbWKS.Checked := (Move.FPosition[65] and 8) = 8;
  cbWQS.Checked := (Move.FPosition[65] and 4) = 4;
  cbBKS.Checked := (Move.FPosition[65] and 2) = 2;
  cbBQS.Checked := (Move.FPosition[65] and 1) = 1;
  if Move.FPosition[64] > 0 then
    lblEpTarget.Caption := SQRToFR(Move.FPosition[64])
  else
    lblEpTarget.Caption := 'None selected';
  udPly.Position := Move.FRM;
  FLoading := False;
end;
//______________________________________________________________________________
procedure TfCLBoard.ZeroTime(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_ZERO_TIME, IntToStr(TCLGame(Sender).GameNumber)]);
end;
//______________________________________________________________________________
function TfCLBoard.CreateGame: TCLGame;
begin
  { Create a new TCLGame object and assign procedures to it's events }
  Result := TCLGame.Create;
  Result.OnModeChanged := GameModeChanged;
  Result.OnInvertBoard := InvertBoard;
  Result.OnMarkerAdded := MarkerAdded;
  Result.OnMarkerRemoved := MarkerRemoved;
  Result.OnDrawBoard := DrawBoard;
  Result.OnTimer := SetTime;
  Result.OnZeroTime := ZeroTime;
  Result.AutoQueen := fGL.AutoQueen;
  Result.ShowCaptured := fGL.ShowCaptured;

  FGames.Add(Result);
end;
//______________________________________________________________________________
function TfCLBoard.Game(const GameNumber: Integer; p_LiveOnly: Boolean = true): TCLGame;
var
  i: Integer;
begin
  for i := 0 to FGames.Count -1 do begin
    result := TCLGame(FGames[i]);
    if (result.GameNumber = GameNumber) and
      ((result.GameMode <> gmNone) or not p_LiveOnly)
    then
      exit;
  end;
  Result := nil;
end;
//______________________________________________________________________________
function TfCLBoard.GameCount: Integer;
begin
  Result := FGames.Count;
end;
//______________________________________________________________________________
procedure TfCLBoard.ColorizePieces;
var
  B2: TBitmap;
begin
  { ??? This routine will mess up the white pieces if the color of
    FGL.LightPiece = clBlack. To correct a netural color would have be be
    floodfilled first then returned to white. }
  B2 := TBitmap.Create;
  try
    B2.Assign(FPieces);

    FPieces.Canvas.Brush.Color := FGL.LightPiece;
    FPieces.Canvas.BrushCopy(Rect(0, 0, FPieces.Width, FPieceSize),
      B2, Rect(0, 0, B2.Width, FPieceSize), clWhite);

    FPieces.Canvas.Brush.Color := FGL.DarkPiece;
    FPieces.Canvas.BrushCopy(Rect(0, FPieceSize, FPieces.Width, FPieceSize * 2),
      B2, Rect(0, FPieceSize , B2.Width, FPieceSize * 2), clBlack);

    { The background color will have been changed in the first call. Return it. }
    FPieces.Canvas.Brush.Color := clWhite;
    FPieces.Canvas.FloodFill(0, 0, FGL.LightPiece, fsSurface);
  finally
    B2.Free;
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.Disconnect;
var
  Index: Integer;
begin
  for Index := 0 to FGames.Count -1 do
    TCLGame(FGames[Index]).GameMode := gmNone;
end;
//______________________________________________________________________________
procedure TfCLBoard.SetClockEnabled(const Sender: TObject);
begin
  if Sender <> GM then Exit;
  case GM.GameMode of
    gmNone:
      { nothing yet }
    else
      if GM.Color = BLACK then
        BC.Enabled := True
      else
        WC.Enabled := True;
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.SetTime(Sender: TObject);
begin
  if Sender <> GM then Exit;

  WC.Time := GM.WhiteMSec;
  BC.Time := GM.BlackMSec;
end;
//______________________________________________________________________________
procedure TfCLBoard.bntAcceptClick(Sender: TObject);
var
  FEN: string;
begin
  { Set Position, BuildFEN, Set Lag, Send Fen to server }
  GM.AssignSetupMove;
  if GM.GameMode = gmCLSExamine then
    begin
      GM.Lag := True;
      FEN := GM.FEN;
      fCLSocket.InitialSend([CMD_STR_FEN, IntToStr(GM.GameNumber), FEN]);
    end;
  GM.Setup := False;
  TogglePanels;
  Resize;
end;
//______________________________________________________________________________
procedure TfCLBoard.btnCancelClick(Sender: TObject);
begin
  if Assigned(GM) then GM.Setup := False;
  pnlSetup.Hide;
  pnlDetails.Show;
  Resize;
end;
//______________________________________________________________________________
procedure TfCLBoard.btnClearClick(Sender: TObject);
begin
  if not Assigned(GM) then Exit;
  if GM.Setup then GM.ClearBoard;
end;
//______________________________________________________________________________
procedure TfCLBoard.btnResetClick(Sender: TObject);
begin
  if not Assigned(GM) then Exit;
  if GM.Setup then GM.ResetBoard;
end;
//______________________________________________________________________________
procedure TfCLBoard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FGM := nil;
  lvMoves.Items.Clear;
  FGames.Free;
  FDraw.Clear;
  FDraw.Free;
  Action := caFree;

  { Bitmaps }
  FPieces.Free;
  FMask.Free;
  FBuffer.Free;
  FCopy.Free;
  FSquare.Free;
end;
//______________________________________________________________________________
procedure TfCLBoard.FormCreate(Sender: TObject);
begin
  with Canvas.Pen do
    begin
      Color := fGL.HighLight;
      Width := 2;
    end;

  WC.Color := fGL.ClockColor;
  BC.Color := fGL.ClockColor;

  FGames := TObjectList.Create;
  FGames.OwnsObjects := True;
  FDraw := TList.Create;

  { Bitmap initialization }
  FPieces := TBitmap.Create;
  FMask := TBitmap.Create;
  FCopy := TBitmap.Create;
  FSquare := TBitmap.Create;
  with FSquare.Canvas do
    begin
      Pen.Color := fGL.HighLight;
      Pen.Width := 1;
      Font.Color := clBlue;
      Font.Style := [fsBold];
    end;
  FBuffer := TBitmap.Create;
  FBuffer.Height := GetSystemMetrics(SM_CYSCREEN);
  FBuffer.Width := GetSystemMetrics(SM_CXSCREEN);
  with FBuffer.Canvas do
    begin
      Pen.Color := fGL.HighLight;
      Pen.Width := 2;
    end;
  FFromCC:=-1;
  CreatePMColor;
  FStrArrowColor:='blue';
  FStrCircleColor:='blue';
  FArrowColor:=clBlue;
  FCircleColor:=clBlue;
  ShowPanelsColor;

  WC.SoundFile := fGL.Sounds[SOUND_CLOCK_NUMBER];
  BC.SoundFile := fGL.Sounds[SOUND_CLOCK_NUMBER];
  WC.SoundLimit := fGL.TimeEndingLimit;
  BC.SoundLimit := fGL.TimeEndingLimit;
end;
//______________________________________________________________________________
procedure TfCLBoard.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Move: TMove;
  R: TRect;
  PieceColor, Square, FromColor, SquareColor: Integer;
  MyColorOnly, LegalColor: Boolean;
begin
  if pnlDetails.Visible then
    lvMoves.SetFocus
  else
    btnCancel.SetFocus;

  if (Button <> mbLeft) or not Assigned(GM) then Exit;

  { Bring local board in sycn with server if it's a server game }
  if (GM.MoveNumber < GM.MoveTotal) and (GM.GameMode <> gmNone)
  and not GM.Setup then GM.MoveTo(GM.MoveTotal);

  { Determine if were in the Board area, Captured area or other }
  if PtInRect(FBrd, Point(X, Y)) then
    begin
      FDragSource := dsBoard;
      R := FBrd;
    end
  else if (PtInRect(FCap, Point(X, Y))) and (GM.ShowCaptured or GM.Setup)
  and not (sbArrow.Down or sbCircle.Down) then
    begin
      FDragSource := dsCaptured;
      R := FCap;
    end
  else
    FDragSource := dsNone;

  if FDragSource = dsNone then Exit;

  FMouseState := [msDown];

  { Get the Board or Captured area X square and Y square for piece retrevial.
    Set the FRef for drawing purposes. }
  FMouseX := X;
  FMouseY := Y;
  X := (X - R.Left) div FSquareSize;
  Y := (Y - R.Top) div FSquareSize;
  FRefX := R.Left + X * FSquareSize;
  FRefY := R.Top + Y * FSquareSize;

  if FDragSource = dsBoard then InvertXY(X,Y);

  FOrgX := X;
  FOrgY := Y;

  { Check to see if we're drawing a circle or line. Exit this procedure
    and let the MouseUp procedure finish the line/circle. }
  if sbArrow.Down or sbCircle.Down then Exit;

  { Get the piece value }
  if GM.Setup then
    Move := GM.SetupMove
  else
    Move := TMove(GM.Moves[GM.MoveNumber]);
    
  FPieceDragged := 0;
  if FDragSource = dsBoard then
    begin
      Square := XYToSqr(X, Y);
      FPieceDragged := Move.FPosition[Square];
    end
  else if FDragSource = dsCaptured then
    begin
      { PieceDragged is based upon the POSITION of the Square in the array,
        NOT the contents of the array. }
      if X = 0 then PieceColor := 1 else PieceColor := -1;
      FPieceDragged := (6 - Y) * PieceColor;
      Square := 72 + FPieceDragged;
      if (Move.FPosition[Square] <= 0) and not GM.Setup then FPieceDragged := 0;
    end;

  { Check to see if we're setting the Enpassant position }
  if sbEnpassant.Down then
    begin
      if FDragSource = dsBoard then
        Move.FPosition[64] := Square
      else
        Move.FPosition[64] := -1;
      UpdateSetupPanel;
      sbEnpassant.Down := False;
      Exit;
    end;

  { Process Smart (best handled before Legal Moves)(Exit must be after Legal) }
  if (FDragSource = dsBoard) and (fGL.SmartMove)
  and (GM.OneLegal(Square) > - 1)
  and not (GM.GameMode in [gmCLSObserve, gmCLSObEx])
  and not ((GM.GameMode in [gmCLSLive]) and (GM.MyColor <> GM.Color)) then
    begin
      ProcessSmartMove(GM.OneLegal(Square));
      Exit;
    end;

  { Exit if I'm not allowed to move in this game }
  if GM.GameMode in [gmCLSObserve, gmCLSObEx] then Exit;

  { Prevents me from moving opponents piece in a real game }
  if (fGL.MoveStyle = MOVE_STYLE_DD) and (FPieceDragged <> 0) and (GM.MyColor <> 0)
  and (GM.GameMode in [gmCLSLive]) then
    if (FPieceDragged div Abs(FPieceDragged) <> GM.MyColor) then Exit;

  if (fGL.MoveStyle = MOVE_STYLE_CC) then
    begin
      MyColorOnly:=GM.GameMode in [gmCLSLive]; // is it legal to move only with own color

      if FFromCC=-1 then FromColor:=0
      else FromColor:=GM.GetColor(Move.FPosition,FFromCC);

      SquareColor:=GM.GetColor(Move.FPosition,Square);

      LegalColor:=(SquareColor=GM.MyColor) or not MyColorOnly and (SquareColor<>0);

      if FFromCC<>-1 then FDraw.Add(Pointer(FFromCC));

      if (FFromCC=-1) and LegalColor
        or (FFromCC<>-1) and (SquareColor=FromColor) and (Square<>FFromCC)
      then
        FFromCC := Square
      else if (Square=FFromCC) then
        FFromCC:=-1
      else if (FFromCC<>-1) and not GM.Lag and DoTurn(FFromCC,Square) then
        FFromCC:=-1;

      DrawBoard2(0,GM.MoveNumber,daNone);
    end;

  { Draw Legal Moves }
  if not GM.Setup and fGL.ShowLegal then
    if (FDragSource in [dsBoard, dsCaptured]) and (fGL.MoveStyle=MOVE_STYLE_DD) then
      DrawLegal(Square)
    else if (FFromCC<>-1) and (fGL.MoveStyle=MOVE_STYLE_CC) then
      DrawLegal(FFromCC);

  if fGL.MoveStyle = MOVE_STYLE_CC then exit;
  { If we actually have a piece to drag, then based on the FDragSource
    copy what should show behind that piece after it's moved to FCopy
    for use in FormMouseMoved }
  if FPieceDragged <> 0 then
    begin
      if FDragSource = dsBoard then
        begin
          if Odd(X) xor Odd(Y) then
            FBuffer.Canvas.Brush.Color := fGL.DarkSquare
          else
            FBuffer.Canvas.Brush.Color := fGL.LightSquare;

          if (fGL.ShowLastMoveType=0) and (Move.FTo = Square) then
            with FBuffer.Canvas.Pen do
              begin
                Color := fGL.HighLight;
                Width := 2;
                FBuffer.Canvas.Rectangle(FRefX + 1, FRefY + 1,
                  FRefX + FSquareSize, FRefY + FSquareSize);
              end
          else
            with FBuffer.Canvas.Pen do
              begin
                if FGL.DrawBoardLines then Color:=fGL.BoardLinesColor
                else Color := FSquare.Canvas.Brush.Color;
                Width := 1;
                FBuffer.Canvas.Rectangle(FRefX, FRefY, FRefX + FSquareSize,
                  FRefY + FSquareSize);
              end;

          { Lay down any markers that might be on the board }
          DrawMarkers(FBuffer.Canvas);

          BitBlt(FCopy.Canvas.Handle, 0, 0, FSquareSize, FSquareSize,
            FBuffer.Canvas.Handle, FRefX, FRefY, SRCCOPY);
          PutThemeSquare(FCopy.Canvas,(x+y) mod 2 = 0, 1);
        end
      else if FDragSource in [dsCaptured] then begin
        BitBlt(FCopy.Canvas.Handle, 0, 0, FSquareSize, FSquareSize,
          Canvas.Handle, FRefX, FRefY, SRCCOPY);
      end;

      { msExecute means a piece is actually held and may be dragged.
        Used in the other mouse events. }    
      FMouseState := FMouseState + [msExecute];

      { Get the Pieces bitmap X, Y posisition of the piece being dragged }
      if FPieceDragged < 0 then FPieceY := FPieceSize else FPieceY := 0;
      FPieceX := Abs(FPieceDragged * FPieceSize) - FPieceSize;
    end;
end;
//______________________________________________________________________________
procedure TfCLBoard.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  StartX, StartY, PicWidth, PicHigh: Integer;
begin
  FMouseCurX:=X;
  FMouseCurY:=Y;
  DrawMoveSquare(X,Y);
  if not (msExecute in FMouseState) then Exit;

  if X < FMouseX then StartX := FRefX + (X - FMouseX) else StartX := FRefX;
  if Y < FMouseY then StartY := FRefY + (Y - FMouseY) else StartY := FRefY;

  PicWidth := FSquareSize + Abs(X - FMouseX);
  PicHigh := FSquareSize + Abs(Y - FMouseY);

  BitBlt(FBuffer.Canvas.Handle, StartX, StartY, PicWidth, PicHigh,
    Canvas.Handle, StartX, StartY, SRCCOPY);
  BitBlt(FBuffer.Canvas.Handle, FRefX, FRefY, FSquareSize, FSquareSize,
    FCopy.Canvas.Handle, 0, 0, SRCCOPY);
  BitBlt(FCopy.Canvas.Handle, 0, 0, FSquareSize, FSquareSize,
    FBuffer.Canvas.Handle, FRefX + (X - FMouseX), FRefY + (Y - FMouseY),
    SRCCOPY);
  BitBlt(FBuffer.Canvas.Handle, FRefX + (X - FMouseX) + FXOff,
    FRefY + (Y - FMouseY) + FXOff, FPieceSize, FPieceSize,
    FMask.Canvas.Handle, FPieceX, FPieceY, SRCPAINT);
  DrawTransparentBmp(FBuffer.Canvas, FPieces, FPieceX, FPieceY, FPieceSize, FPieceSize,
    FRefX + (X - FMouseX) + FXOff, FRefY + (Y - FMouseY) + FXOff, PIECES_TRANSPARENT_COLOR);
  {BitBlt(FBuffer.Canvas.Handle, FRefX + (X - FMouseX) + FXOff,
    FRefY + (Y - FMouseY) + FXOff, FPieceSize, FPieceSize,
    FPieces.Canvas.Handle, FPieceX, FPieceY, SRCAND);}
  BitBlt(Canvas.Handle, StartX, StartY, PicWidth, PicHigh,
    FBuffer.Canvas.Handle, StartX, StartY, SRCCOPY);

  FRefX := FRefX + (X - FMouseX);
  FRefY := FRefY + (Y - FMouseY);
  FMouseX := X;
  FMouseY := Y;
  FMouseState := FMouseState + [msMoved];
  DrawMoveSquare(X,Y);
end;
//______________________________________________________________________________
procedure TfCLBoard.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  DragDestination: TDragSite;
  LegalMove: TLegalMove;
  Move: TMove;
  From, Promo, _To: Integer;
  Cmd: string;
label
  Finish;
begin
  if fGL.MoveStyle = MOVE_STYLE_CC then exit;
  { ProcessSmartMove will call this procedure, so we need to force the release
    of the mouse }
  ReleaseCapture;

  if (Button <> mbLeft) or (not Assigned(GM)) then Exit;

  { Initialize some variables }
  Promo := 0;
  Cmd := #0;

  { No longer pressing the mouse button. DrawBoard2 needs to know this fact. }
  FMouseState := FMouseState - [msExecute];

  { Remove the piece being dragged from the board (form) canvas. }
  if (msMoved in FMouseState) and not FSmartMove
    then BitBlt(Canvas.Handle, FRefX, FRefY, FSquareSize, FSquareSize,
      FCopy.Canvas.Handle, 0, 0, SRCCOPY);

  { If in Line or Circle mode then we bypassed the MouseMove Event. So we need
    to trick the system and assign FRefX & FRefY }
  if sbArrow.Down or sbCircle.Down then
    begin
      FRefX := X - FSquareSize div 2;
      FRefY := Y - FSquareSize div 2;
    end;

  { Where'd we land? }
  if PtInRect(FBrd, Point(X, Y)) then
    begin
      DragDestination := dsBoard;
      X := (FRefX + (FSquareSize div 2) - FBrd.Left) div FSquareSize;
      Y := (FRefY + (FSquareSize div 2) - FBrd.Top) div FSquareSize;
      InvertXY(X,Y);
      _To := XYToSqr(X, Y);
    end
  else if PtInRect(FCap, Point(X, Y))
  and not (sbArrow.Down or sbCircle.Down) then
    begin
      DragDestination := dsCaptured;
      _To := 72;
    end
  else DragDestination := dsNone;

  if FDragSource = dsCaptured then
    if FOrgX = 0 then From := 72 + (6 - FOrgY) else  From := 72 - (6 - FOrgY)
  else
    From := XYToSqr(FOrgX, FOrgY);

  if not sbArrow.Down and not sbCircle.Down then
    begin
      { A obvious non legal move requiring only a source square redraw }
       { Not allowd to attempt a move, just redraw 'legal' squares }
      if not (msMoved in FMouseState) and (not FSmartMove) then
        begin
          if fGL.ShowLegal then EraseLegal;
          goto Finish;
        end;

      if  GM.Lag or (_To = From) then
        begin
          FDraw.Add(Pointer(From));
          DrawBoard2(0, GM.MoveNumber, daNone);
          goto Finish;
        end;
    end;

  { Take action based on the DragSource, DragDestination and MouseState }
  if ((FDragSource = dsBoard) and (DragDestination = dsBoard)) then
    begin
      { Check for Arrow or Circle drawing first. Send to server if in examine
        mode. Then goto finish since no piece dragging has happened }
      if sbArrow.Down then
        begin
          //sbArrow.Down := False;
          if (FOrgX = X) and (FOrgY = Y) then goto Finish;
          GM.AddMarker(XYToSqr(FOrgX, FOrgY), XYToSqr(X, Y),FStrArrowColor);
          if GM.GameMode in [gmCLSExamine] then
            fCLSocket.InitialSend([CMD_STR_ARROW, IntToStr(GM.GameNumber),
            IntToStr(XYToSqr(FOrgX, FOrgY)), IntToStr(XYToSqr(X, Y)),FStrArrowColor]);
          goto Finish;
        end
      else if sbCircle.Down then
        begin
          //sbCircle.Down := False;
          GM.AddMarker(XYToSqr(X, Y), -1, FStrCircleColor);
          if GM.GameMode in [gmCLSExamine] then
            fCLSocket.InitialSend([CMD_STR_CIRCLE, IntToStr(GM.GameNumber),
              IntToStr(XYToSqr(X, Y)),FStrCircleColor]);
          goto Finish;
        end;
    end;

  if ((FDragSource in [dsBoard, dsCaptured]) and (DragDestination = dsBoard))
  and not GM.Setup then
    begin
      DoTurn(From,_To);
    end
  else if GM.Setup and not (dsNone in [FDragSource, DragDestination]) then
    GM.AddSetupMove(From, _To)
  else
    begin
      { Piece dropped somewhere off board }
      FDraw.Add(Pointer(XYToSqr(FOrgX, FOrgY)));
      DrawBoard2(0, GM.MoveNumber, daNone);
    end;
Finish:
  FMouseState := [];
  FSmartMove := False;
  //DrawBoardFull;
end;
//______________________________________________________________________________
procedure TfCLBoard.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  MoveLocally(WheelDelta div 120);
  Handled := True;
end;
//______________________________________________________________________________
procedure TfCLBoard.FormPaint(Sender: TObject);
var
  I: Integer;
  R: TRect;
  Rgn1, Rgn2, Rgn3: HRGN;
begin
  { No game object then no paint }
  if not Assigned(GM) then Exit;

  { Erase the background area surrounding the Board and Captured areas. By not
    erasing the Board anc Captured areas flicker is significently reduced. }
  Self.Color := fGL.BoardBackgroundColor;
  Canvas.Brush.Color := fGL.BoardBackgroundColor;//Self.Color;
  Rgn1 := CreateRectRgn(0, 0, ClientWidth, ClientHeight);
  with FBrd do Rgn2 := CreateRectRgn(Left - 1, Top - 1, Right + 1, Bottom + 1);
  CombineRgn(Rgn1, Rgn1, Rgn2, RGN_DIFF);
  with FCap do Rgn3 := CreateRectRgn(Left, Top, Right, Bottom);
  if GM.ShowCaptured or GM.Setup
    then CombineRgn(Rgn1, Rgn1, Rgn3, RGN_DIFF);
  FillRgn(Canvas.Handle, Rgn1, Canvas.Brush.Handle);
  DeleteObject(Rgn1);
  DeleteObject(Rgn2);
  DeleteObject(Rgn3);

  { Draw coordinates }
  Canvas.Font.Size := 8;
  if fGL.ShowCoordinates then
    if GM.Inverted then
      for I := 0 To 7 do
        begin
          Canvas.TextOut(FBrd.Left + I * FSquareSize + FSquareSize div 2,
            FBrd.Bottom + 1, FILES[7 - I]);
          Canvas.TextOut(FBrd.Right + 1,
            FBrd.Top + I * FSquareSize+ FSquareSize div 2, RANKS[I]);
        end
    else
      for I := 0 To 7 do
        begin
          Canvas.TextOut(FBrd.Left + I * FSquareSize + FSquareSize div 2,
            FBrd.Bottom + 1, FILES[I]);
          Canvas.TextOut(FBrd.Right + 1,
            FBrd.Top + I * FSquareSize + FSquareSize div 2, RANKS[7 - I]);
        end;

  { Paint the board }
  FPaint := True;
  DrawBoard2(0, GM.MoveNumber, daPaintSameBoard);
  { Odd change, but nice touch. }
  if fGL.ShowLegal then
    if (msDown in FMouseState) or (FFromCC<>-1) then
      DrawLegal(XYToSqr(FOrgX, FOrgY));

  { Draw border around the board }
  R := FBrd;
  InflateRect(R, 1, 1);
  Canvas.Brush.Color := clWindowText;
  Canvas.FrameRect(R);
end;
//______________________________________________________________________________
procedure TfCLBoard.FormResize(Sender: TObject);
const
  BORDER_BUFF = 14;
  COORD_WIDTH = 8;
  STD_FILES = 8;
var
  X, Y, i, nSet,BaseSize: Integer;
  Files: Integer;
begin
  if not Assigned(GM) then Exit;

  { Find the area available for the board }
  X := ClientWidth - pnlDetails.Width - BORDER_BUFF;
  Y := ClientHeight - BORDER_BUFF;

  if fGL.ShowCoordinates then
    begin
      X := X - COORD_WIDTH;
      Y := Y - COORD_WIDTH;
    end;
  if GM.ShowCaptured or GM.Setup then
    begin
      X := X - COORD_WIDTH;
      Files := 2;
    end
  else
    begin
      Files := 0;
    end;

  if (Y div STD_FILES) < (X div (STD_FILES + Files)) then
    FSquareSize := Y div STD_FILES
  else
    FSquareSize := X div (STD_FILES + Files);

  { Calculate Piece and Square sizes }
  if FSquareSize > 131 then FSquareSize := 131;
  if FSquareSize < 25 then FSquareSize := 25;

  for i:=High(PieceSizes) downto Low(PieceSizes) do
    if FSquareSize>PieceSizes[i] then begin
      FPieceSize:=PieceSizes[i];
      break;
    end;

  GetPieceSet(fGL.PieceSetNumber,FPieceSize,FPieces);
  if fGL.PieceSetNumber=0 then
    FMask.LoadFromResourceName(HInstance,'M'+Lpad(IntToStr(FPieceSize),3,'0'))
  else begin
    FMask.Empty; FMask.Width:=0; FMask.Height:=0;
  end;

  { Misc bitmap stuff. }
  FPieces.PixelFormat := pf32bit;
  FCopy.Height := FSquareSize;
  FCopy.Width := FSquareSize;
  FSquare.Height := FSquareSize;
  FSquare.Width := FSquareSize;
  ColorizePieces;

  { Offset of the piece in the square }
  FXOff := (FSquareSize - FPieceSize) div 2;

  { Calc Center points }
  X := (X - ((STD_FILES + Files) * FSquareSize)) div 2 + (BORDER_BUFF div 2);
  Y := (Y - 8 * FSquareSize) div 2 + (BORDER_BUFF div 2);

  { Setbounds for Board and Captured Rects }
  if GM.ShowCaptured or GM.Setup then
    begin
      FCap := Rect(X, Y + FSquareSize, X + Files * FSquareSize,
        Y + (STD_FILES - 1) * FSquareSize);
      FBrd := Rect(FCap.Right + COORD_WIDTH, Y,
        FCap.Right + COORD_WIDTH + STD_FILES * FSquareSize,
        Y + STD_FILES * FSquareSize);
    end
  else
    FBrd := Rect(X, Y, X + STD_FILES * FSquareSize, Y +STD_FILES * FSquareSize);

  { ??? PositionControls; }
  PositionControls;
  Paint;

  { The Align property only works naturally if the component is visible.
    Force the alignment for the hidden panel. Helps to avoid flicker.}
  pnlSetup.Left := Width - pnlSetup.Width;
  pnlDetails.Left := Width - pnlDetails.Width;
end;
//______________________________________________________________________________
procedure TfCLBoard.lvMovesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_Down: MoveLocally(- GM.MoveNumber);
    vk_Up: MoveLocally(GM.MoveTotal);
    vk_Left: MoveLocally(-1);
    vk_Right: MoveLocally(1);
  end;
  Key := 0;
end;
//______________________________________________________________________________
procedure TfCLBoard.miAbortClick(Sender: TObject);
begin
  if GM.GameMode = gmCLSLive then
    fCLSocket.InitialSend([CMD_STR_ABORT, IntToStr(GM.GameNumber)])
  else
    fCLSocket.InitialSend([CMD_STR_ABORT]);
end;
//______________________________________________________________________________
procedure TfCLBoard.miAdjournClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_ADJOURN]);
end;
//______________________________________________________________________________
procedure TfCLBoard.miAutoQueenClick(Sender: TObject);
begin
  if Assigned(GM) then GM.AutoQueen := not GM.AutoQueen;
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLBoard.miCapturedClick(Sender: TObject);
begin
  if not Assigned(GM) then Exit;
  GM.ShowCaptured := not GM.ShowCaptured;
  SetMenuState;
  Resize;
end;
//______________________________________________________________________________
procedure TfCLBoard.miCloseClick(Sender: TObject);
var
  ev: TCSEvent;
begin
  if GM.EventId = 0 then KillGame(GM)
  else begin
    if GM.EventID <> 0 then begin
      ev := fCLLectures.FindLecture(GM.EventID);
      if ev = nil then exit;
      fCLSocket.InitialSend([CMD_STR_EVENT_LEAVE,IntToStr(ev.ID)]);
    end;
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.miCopyClick(Sender: TObject);
var
  NewGame: TCLGame;
begin
  NewGame := CreateGame;
  NewGame.Assign(FGM);
  fCLNavigate.AddGame(NewGame);
end;
//______________________________________________________________________________
procedure TfCLBoard.miDetachClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_QUIT + #32 + IntToStr(GM.GameNumber)]);
end;
//______________________________________________________________________________
procedure TfCLBoard.miDrawClick(Sender: TObject);
begin
  if GM.GameMode = gmCLSLive then
    fCLSocket.InitialSend([CMD_STR_DRAW, IntToStr(GM.GameNumber)])
  else
    fCLSocket.InitialSend([CMD_STR_DRAW]);
end;
//______________________________________________________________________________
procedure TfCLBoard.miFlagClick(Sender: TObject);
begin
  if GM.GameMode = gmCLSLive then
    fCLSocket.InitialSend([CMD_STR_FLAG, IntToStr(GM.GameNumber)])
  else
    fCLSocket.InitialSend([CMD_STR_FLAG]);
end;
//______________________________________________________________________________
procedure TfCLBoard.miLogGameClick(Sender: TObject);
begin
  if Assigned(GM) then GM.LogGame := not GM.LogGame;
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLBoard.miMoretimeClick(Sender: TObject);
begin
  fCLMoretime := TfCLMoretime.Create(nil);
  if fCLMoretime.ShowModal = mrOK then fCLSocket.InitialSend([CMD_STR_MORETIME,
    IntToStr(GM.GameNumber), fCLMoretime.GetSeconds]);
  FreeAndNil(fCLMoretime);
end;
//______________________________________________________________________________
procedure TfCLBoard.miPasteFENClick(Sender: TObject);
var
  s: string;
begin
  if (GM = nil) then Exit;

  if Clipboard.HasFormat(CF_TEXT) then
    begin
      s := Clipboard.AsText;
      if TCLPgn.ValidFEN(s) then
        case GM.GameMode of
          gmNone: GM.FEN := s;
          gmCLSExamine:
            fCLSocket.InitialSend([CMD_STR_FEN, IntToStr(GM.GameNumber), s]);
        end;
    end;
end;
//______________________________________________________________________________
procedure TfCLBoard.miRematchClick(Sender: TObject);
var
  IWasInitiator: Boolean;
  InitMSec: integer;
begin
  fCLSeek := TfCLSeek.Create(nil);
  with fCLSeek do begin
    SeekMode := smMatch;
    if GM.MyColor = WHITE then begin
      edtOpponent.Text := GM.BlackName;
      rbBlack.Checked := True;
    end else begin
      edtOpponent.Text := GM.WhiteName;
      rbWhite.Checked := True;
    end;

    IWasInitiator := (GM.MyColor = WHITE) and (GM.Odds.FInitiator = ooiWhite)
      or (GM.MyColor = BLACK) and (GM.Odds.FInitiator = ooiBlack);

    if GM.Odds.FAutoTimeOdds and (StrToInt(GM.WhiteRating) > StrToInt(GM.BlackRating))
      or not GM.Odds.FAutoTimeOdds and (GM.Odds.FInitiator = ooiWhite)
    then begin
      InitMSec := GM.BlackInitialMSec;
      udInc.Position := GM.BlackIncTime;
    end else begin
      InitMSec := GM.WhiteInitialMSec;
      udInc.Position := GM.WhiteIncTime;
    end;

    udInitial.Position := InitMSec div MSecsPerMinute;
    udInitSec.Position := (InitMSec div 1000) mod 60;


    if GM.RatingType in [rtCrazy, rtFischer, rtLoser] then
      cbGameType.ItemIndex := Ord(GM.RatingType) -2
    else
      cbGameType.ItemIndex := 0;

    if GM.Rated then rbRated.Checked := True else rbUnrated.Checked := True;

    chkTimeOdds.Checked := GM.Odds.FAutoTimeOdds or GM.Odds.TimeDefined;
    udOddsInitMin.Position := GM.Odds.FInitMin;
    udOddsInitSec.Position := GM.Odds.FInitSec;
    udOddsInc.Position := GM.Odds.FInc;
    chkPieceOdds.Checked := GM.Odds.PieceDefined;
    cmbPieceOdds.ItemIndex := GM.Odds.FPiece;

    if IWasInitiator and GM.Odds.TimeDefined and not GM.Odds.FAutoTimeOdds then
      sbTimeChange.Click;

    {rbTimeOddsGive.Checked := IWasInitiator and (GM.Odds.FTimeDirection = oodGive)
      or not IWasInitiator and (GM.Odds.FTimeDirection = oodAsk);
    rbTimeOddsAsk.Checked := not rbTimeOddsGive.Checked;}

    rbPieceOddsGive.Checked := IWasInitiator and (GM.Odds.FPieceDirection = oodGive)
      or not IWasInitiator and (GM.Odds.FPieceDirection = oodAsk);
    rbPieceOddsAsk.Checked := not rbPieceOddsGive.Checked;

    SetEnabled;

    ShowModal;
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.miResignClick(Sender: TObject);
begin
  if GM.GameMode = gmCLSLive then
    fCLSocket.InitialSend([CMD_STR_RESIGN, IntToStr(GM.GameNumber)])
  else
    fCLSocket.InitialSend([CMD_STR_RESIGN]);
end;
//______________________________________________________________________________
procedure TfCLBoard.miRotateClick(Sender: TObject);
begin
  GM.Inverted := not GM.Inverted;
end;
//______________________________________________________________________________
procedure TfCLBoard.miSetupClick(Sender: TObject);
begin
  if Assigned(GM) then GM.Setup := True;
  FLoading := True;
  Resize;
  TogglePanels;
  UpdateSetupPanel;
end;
//______________________________________________________________________________
procedure TfCLBoard.miTakebackClick(Sender: TObject);
begin
  fCLTakeback := TfCLTakeback.Create(nil);
  if fCLTakeback.ShowModal = mrOK then fCLSocket.InitialSend([CMD_STR_TAKEBACK,
    IntToStr(GM.GameNumber),fCLTakeback.GetMoves]);
  FreeAndNil(fCLTakeback);
end;
//______________________________________________________________________________
procedure TfCLBoard.MoveButtonClick(Sender: TObject);
begin
  if GM.GameMode in [gmCLSExamine] then
    MoveInExGame((Sender as TSpeedButton).Tag)
  else
    MoveLocally((Sender as TSpeedButton).Tag);
end;
//______________________________________________________________________________
procedure TfCLBoard.sbMaxClick(Sender: TObject);
begin
  Self.SetFocus;
  fCLMain.miMaximizeTop.Click;
end;
//______________________________________________________________________________
procedure TfCLBoard.SetSetupRights(Sender: TObject);
var
  Move: TMove;
begin
  if FLoading then Exit;
  Move := GM.SetupMove;
  with Move do
    begin
      if rbWhite.Checked then FColor := BLACK else FColor := WHITE;
      FPosition[65] := 0;
      if cbWKS.Checked then FPosition[65] := FPosition[65] + 8;
      if cbWQS.Checked then FPosition[65] := FPosition[65] + 4;
      if cbBKS.Checked then FPosition[65] := FPosition[65] + 2;
      if cbBQS.Checked then FPosition[65] := FPosition[65] + 1;
      FRM := udPly.Position;
    end;
end;
//______________________________________________________________________________
function TfCLBoard.DoTurn(From, _To: integer): Boolean;
var
  LegalMove: TLegalMove;
  Promo,promopiece: integer;
  Cmd: string;
  Move, LastMove: TMove;
  ToRedrawBoard: Boolean;
  ev: TCSEvent;
begin
  try
  result:=false;
  { A potential leagl move requiring testing. Check our own engine.
    !!! Move is a reference in a TList that gets cleared when AddMove is
    called, so it's valid only up til that point. }
  Promo := 0;
  LegalMove := GM.IsLegal(From, _To);
  LastMove := TMove(GM.Moves[GM.MoveNumber]);
  {if LastMove.FColor<>GM.GetColor(LastMove.FPosition,From) then
    ClearPremove;}
  { !!! Requires NON complete boolean evaluation. }
  if not Assigned(LegalMove) or (LegalMove.FType = mtIllegal) then
    begin
      if LastMove.FColor=GM.GetColor(LastMove.FPosition,From) then
        begin
          GM.SetPremove(From, _To);
          result:=true;
          //DrawBoardFull;
        end
      else
        begin
          fGL.PlayCLSound(SI_ILLEGAL);
          FDraw.Add(Pointer(From));
          //DrawBoard2(0, GM.MoveNumber, daNone);
        end;
      exit;
    end;

  { Check for Promotion }
  if LegalMove.FType = mtPromotion then
    begin
      {if fGL.MoveStyle = MOVE_STYLE_CC then
        promopiece := LastMove.FPosition[FFromCC]
      else
        promopiece:=FPieceDragged;}
      promopiece:=LastMove.FPosition[From];
      if GM.AutoQueen then
        begin
          Promo := WQ * promopiece;
        end
      else
        begin
          fCLPromotion :=  TfCLPromotion.Create(nil);
          case fCLPromotion.ShowModal of
            mrOK: Promo := WQ * promopiece;
            mrCancel: Promo := WR * promopiece;
            mrAbort: Promo := WB * promopiece;
            mrRetry: Promo := WN * promopiece;
          end;
          fCLPromotion.Free;
        end;
    end;
  { Add the move (Get the MSecs first!) }
  Cmd := GetMSec;
  Move := GM.AddMove(From, _To, Promo, LegalMove.FType, '');
  if Move=nil then exit;

  if GM.GameMode in [gmCLSExamine, gmCLSLive] then
    begin
      fCLSocket.InitialSend([CMD_STR_MOVE, IntToStr(GM.GameNumber),
        IntToStr(From), IntToStr(_To), IntToStr(Promo),
        IntToStr(Ord(Move.FType)), Move.FPGN, Cmd, BoolTo_(GM.Switched,'1','0')]);
      GM.Switched := false;
      GM.Lag := True;
      if (GM.EventId<>0) then
        fCLEvents.OnDoTurn(GM);
    end;
  result:=true;
  FFromCC:=-1;
  finally
    DrawBoardFull;
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.DoPremove(const Game: TCLGame);
var
  i,j,From,_To,Color: integer;
  LegalMove: TLegalMove;
begin
  if not Assigned(GM) then exit;
  if FDoingPremove then exit;
  if (GM.RatingType=rtCrazy) or not fGL.Premove then exit;
  if not (Game.GameMode in [gmCLSExamine, gmCLSLive]) then exit;
  Color:=Game.NextColor;
  if Color<>Game.PremoveColor then exit;
  SetGM(Game);

  i:=1;
  while i<=GM.PremovesCount do
    begin
      FDoingPremove:=true;
      LegalMove := GM.IsLegal(GM.Premove[i].FFrom,GM.Premove[i].FTo);
      if Assigned(LegalMove) and (LegalMove.FType <> mtIllegal) then
        begin
          From:=GM.Premove[i].FFrom;
          _To:=GM.Premove[i].FTo;
          DoTurn(From,_To);
          break;
        end;
      inc(i);
    end;
  if i>PREMOVE_MAX_COUNT then i:=PREMOVE_MAX_COUNT;
  for j:=1 to i do
    GM.MovePremoves(j);
  GM.ClearBadPremoves(Color);
  FDoingPremove:=false;
  DrawBoardFull;
end;
//______________________________________________________________________________
procedure TfCLBoard.FormDblClick(Sender: TObject);
var X,Y: integer;
  sl: TStringList;
begin
  if PtInrect(FBrd,Point(FMouseCurX,FMouseCurY)) then
    begin
      X := (FMouseCurX - FBrd.Left) div FSquareSize;
      Y := (FMouseCurY - FBrd.Top) div FSquareSize;
      InvertXY(X,Y);
      GM.ClearPremove(XYToSqr(X,Y));
    end
  else
    ClearPremove;
  DrawBoardFull;

  {try
    fSoundMovesLib.PlayMoveSound('Kc6',0);
  except
    on E: Exception do
      ShowException(E, ExceptAddr);
  end;}

end;
//______________________________________________________________________________
function TfCLBoard.ClearPremove: Boolean;
begin
  // Clear old premove
  result:=GM.PremovesCount>0;
  GM.ClearPremoves;
end;
//______________________________________________________________________________
procedure TfCLBoard.CMD_GameQuit(CMD: TStrings);
var
  GM: TCLGame;
  GameNumber: integer;
begin
  GameNumber := StrToInt(CMD[1]);
  GM := Self.Game(GameNumber, false);
  if GM = nil then exit;
  RemoveGame(GM);
end;
//______________________________________________________________________________
procedure TfCLBoard.DrawArrow(_Canvas: TCanvas; X1, Y1, X2, Y2: integer; Color: TColor; Width: integer);
var
  HeadLength, xbase, xLineDelta, xNormalDelta, ybase, yLineDelta, yNormalDelta: Integer;
  xLineUnitDelta, xNormalUnitDelta, yLineUnitDelta, yNormalUnitDelta: Double;
  OldColor: TColor;
begin
  OldColor:=_Canvas.Pen.Color;
  _Canvas.Pen.Color := Color;
  _Canvas.Pen.Width:=Width;
  X1 := FBrd.Left + X1 * FSquareSize + FSquareSize div 2;
  Y1 := FBrd.Top + Y1 * FSquareSize + FSquareSize div 2;
  X2 := FBrd.Left + X2 * FSquareSize + FSquareSize div 2;
  Y2 := FBrd.Top + Y2 * FSquareSize + FSquareSize div 2;
  _Canvas.MoveTo(X1, Y1);
  _Canvas.LineTo(X2, Y2);

  xLineDelta := x2 - x1;
  yLineDelta := y2 - y1;

  xLineUnitDelta := xLineDelta / SQRT( SQR(xLineDelta) + SQR(yLineDelta));
  yLineUnitDelta := yLineDelta / SQRt( SQR(xLineDelta) + SQR(yLineDelta));

  // (xBase,yBase) is where arrow line is perpendicular to base of triangle.
  HeadLength := 6; // pixels
  xBase := x2 - ROUND(HeadLength * xLineUnitDelta);
  yBase := y2 - ROUND(HeadLength * yLineUnitDelta);

  xNormalDelta :=  yLineDelta;
  yNormalDelta := -xLineDelta;
  xNormalUnitDelta := xNormalDelta / SQRT(SQR(xNormalDelta) + SQR(yNormalDelta));
  yNormalUnitDelta := yNormalDelta / SQRt(SQR(xNormalDelta) + SQR(yNormalDelta));

  // Draw the arrow tip
  _Canvas.Brush.Style := bsSolid;
  _Canvas.Brush.Color := Color;
  _Canvas.Polygon([Point(x2,y2),
    Point(xBase + ROUND(HeadLength*xNormalUnitDelta),
    yBase + ROUND(HeadLength*yNormalUnitDelta)),
    Point(xBase - ROUND(HeadLength*xNormalUnitDelta),
    yBase - ROUND(HeadLength*yNormalUnitDelta)) ]);
  _Canvas.Pen.Color := OldColor;
end;
//______________________________________________________________________________
procedure TfCLBoard.DrawBoardFull;
var i: integer;
begin
  if not Assigned(GM) then exit;
  FDraw.Clear;
  for i:=0 to 63 do
    FDraw.Add(Pointer(i));
  DrawBoard2(0,GM.MoveNumber,daNone);
end;
//______________________________________________________________________________
procedure TfCLBoard.DrawMoveSquare(MouseX, MouseY: integer);
var
  X,Y,FRefX,FRefY,FRefX2,FRefY2: integer;
  LM: TLegalMove;
begin
  if (fGL.MoveStyle <> MOVE_STYLE_CC) or not fGL.MoveSquare then exit;
  if not PtInRect(FBrd, Point(MouseX, MouseY)) then
    begin
      if FCurX<>-1 then
        begin
          FDraw.Add(Pointer(XYToSqr(FCurX,FCurY)));
          DrawBoard2(0,GM.MoveNumber,daNone);
          FCurX:=-1; FCurY:=-1;
        end;
      exit;
    end;

  X := (MouseX - FBrd.Left) div FSquareSize;
  Y := (MouseY - FBrd.Top) div FSquareSize;
  //invertXY(X,Y);
  if (FCurX=X) and (FCurY=Y) then exit;

  if (FCurX<>-1) then
    begin
      FDraw.Add(Pointer(XYToSqr(FCurX,FCurY)));
      DrawBoard2(0,GM.MoveNumber,daNone);
    end;

  FRefX := FBrd.Left + X * FSquareSize+1;
  FRefY := FBrd.Top + Y * FSquareSize+1;
  InvertXY(X,Y);
  if (X=-1) or (Y=-1) then exit;

  with Canvas do
  begin
    if (FFromCC=-1) or
      (GM.GetColor(TMove(GM.Moves[GM.MoveNumber]).FPosition,XYToSqr(X,Y)) = - TMove(GM.Moves[GM.MoveNumber]).FColor)
    then LM:=GM.IsLegal(XYToSqr(X,Y),-1)
    else LM:=GM.IsLegal(FFromCC,XYToSqr(X,Y));
    if not Assigned(LM) or (LM.FType = mtIllegal) then
      Pen.Color := fGL.IllegalMoveColor
    else
      Pen.Color := fGL.LegalMoveColor;
    Pen.Width := 2;
    FRefX2:=FRefX+FSquareSize-2;
    FRefY2:=FRefY+FSquareSize-2;
    MoveTo(FRefX,FRefY);
    LineTo(FRefX2,FRefY);
    LineTo(FRefX2,FRefY2);
    LineTo(FRefX,FRefY2);
    LineTo(FRefX,FRefY);
  end;
  FCurX:=X; FCurY:=Y;
end;
//______________________________________________________________________________
procedure TfCLBoard.ShowCheatLights;
var
  lblB,lblW: TLabel;
begin
  if not Assigned(GM) then exit;
  lblW:=lblWhtName;
  lblB:=lblBlkName;

  if true {GM.GameMode in gmCLSLive} then
    begin
      //pnlWhiteLight.Visible:=true;
      //pnlBlackLight.Visible:=true;
      lblW.Color:=CheatModeToColor(GM.WhiteCheatMode);
      lblB.Color:=CheatModeToColor(GM.BlackCheatMode);
      //pnlWhiteLight.Color:=CheatModeToColor(GM.WhiteCheatMode);
      //pnlBlackLight.Color:=CheatModeToColor(GM.BlackCheatMode);
    end
  else
    begin
      lblB.Color:=clBtnFace;
      lblW.Color:=clBtnFace;
      //pnlWhiteLight.Visible:=false;
      //pnlBlackLight.Visible:=false;
    end;
end;
//______________________________________________________________________________
procedure TfCLBoard.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  
end;
//______________________________________________________________________________
function TfCLBoard.UsualGameCount: Integer;
var
  i: integer;
  game: TCLGame;
begin
  result:=0;
  for i:=0 to FGames.Count-1 do begin
    game:=TCLGame(FGames[i]);
    if game.EventId=0 then inc(result);
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.PutThemeSquare(Canvas: TCanvas; Light: Boolean; W: integer);
var
  bmp,src: TBitMap;
begin
  if fGL.ThemeSquareIndex=-1 then exit;
  //bmp:=TBitMap.Create;
  if Light then src:=fGL.bmpLightSquare
  else src:=fGL.bmpDarkSquare;

  //bmp.Canvas.CopyRect(Rect(0,0,src.Width,src.Height),src.Canvas,Rect(0,0,src.Width,src.Height));
  //CompressImageSpecifiedSize(bmp,FSquareSize,FSquareSize,pfDevice);

  Canvas.CopyRect(Rect(W,W,FSquareSize-W,FSquareSize-W),
    src.Canvas,Rect(W,W,FSquareSize-W,FSquareSize-W));
  //bmp.Free;
end;
//______________________________________________________________________________
procedure TfCLBoard.CreatePMColor;
var
  sl: TStringList;
  i: integer;
  col: TColor;
  desc: string;
  itm: TMenuItem;
begin
  sl:=TStringList.Create;
  Str2StringList(ArrowCircleColors,sl);
  for i:=0 to sl.Count-1 do begin
    ColorDescByName(sl[i],col,desc);
    itm:=TMenuItem.Create(pmColor);
    itm.Caption:=desc;
    itm.ImageIndex:=i;
    itm.OnClick:=ColorMenuClick;
    itm.Tag:=i;
    pmColor.Items.Add(itm);
  end;
  sl.Free;
end;
//______________________________________________________________________________
procedure TfCLBoard.ColorMenuClick(Sender: TObject);
var
  sl: TStringList;
  n: integer;
  btn: TSpeedButton;
  col: TColor;
  desc: string;
begin
  sl:=TStringList.Create;
  Str2StringList(ArrowCircleColors,sl);
  n:=(Sender as TMenuItem).Tag;

  btn:=pmColor.PopupComponent as TSpeedButton;
  ColorDescByName(sl[n],col,desc);
  if btn=sbCircle then begin
    FStrCircleColor:=sl[n];
    FCircleColor:=col;
    pnlCircle.Color:=col;
  end else begin
    FStrArrowColor:=sl[n];
    FArrowColor:=col;
    pnlArrow.Color:=col;
  end;
  sl.Free;
end;
//______________________________________________________________________________
procedure TfCLBoard.sbCircleClick(Sender: TObject);
begin
  if sbCircle.Down then sbArrow.Down:=false;
end;
//______________________________________________________________________________
procedure TfCLBoard.sbArrowClick(Sender: TObject);
begin
  if sbArrow.Down then sbCircle.Down:=false;
end;
//______________________________________________________________________________
procedure TfCLBoard.ShowPanelsColor;
begin
  if (GM<>nil) and (GM.GameMode in [gmCLSExamine]) then begin
    pnlCircle.Color:=FCircleColor;
    pnlArrow.Color:=FArrowColor;
  end else begin
    pnlCircle.Color:=pnlDetails.Color;
    pnlArrow.Color:=pnlDetails.Color;
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.AddSquaresToDraw;
var
  Move2: TMove;
begin
  Move2 := TMove(GM.Moves[GM.Moves.Count-1]);
  FDraw.Add(Pointer(Move2.FFrom));
  FDraw.Add(Pointer(Move2.FTo));
end;
//______________________________________________________________________________
procedure TfCLBoard.OnUserLag(Login: string; Lag: integer);
  //****************************************************************************
  procedure _SetLag(lbl: TLabel);
  begin
    lbl.Caption:=IntToStr(Lag);
    if Lag<LAG_YELLOW then lbl.Font.Color:=clBlack
    else if (Lag>=LAG_YELLOW) and (Lag<LAG_RED) then lbl.Font.Color:=clOlive
    else lbl.Font.Color:=clPurple;
  end;
  //****************************************************************************
begin
  if GM = nil then exit;
  if lowercase(GM.WhiteName) = lowercase(Login) then _SetLag(lblLagValueWhite);
  if lowercase(GM.BlackName) = lowercase(Login) then _SetLag(lblLagValueBlack);
end;
//______________________________________________________________________________
procedure TfCLBoard.ShowGameScore;
var
  s: string;
  lblW,lblB: TLabel;
  diff: integer;
begin
  //if GM.GameMode <> gmCLSLive then exit;

  lblUpScore.Visible:=GM.Score.Defined;
  lblDownScore.Visible:= GM.Score.Defined;

  if GM.Inverted then begin
    lblW:=lblUpScore;
    lblB:=lblDownScore;
  end else begin
    lblW:=lblDownScore;
    lblB:=lblUpScore;
  end;


  lblW.Caption:=Format('+%d -%d =%d',[GM.Score.Win,GM.Score.Lost,GM.Score.Draw]);
  lblB.Caption:=Format('+%d -%d =%d',[GM.Score.Lost,GM.Score.Win,GM.Score.Draw]);
  lblW.Hint:=Format('%s personal score %s vs %s',[RatedType2Str(GM.RatingType),GM.WhiteName,GM.BlackName]);
  lblB.Hint:=Format('%s personal score %s vs %s',[RatedType2Str(GM.RatingType),GM.BlackName,GM.WhiteName]);

  diff:=GM.Score.Win-GM.Score.Lost;

  if diff>2 then begin
    lblW.Font.Color:=clGreen;
    lblB.Font.Color:=clMaroon
  end else if diff<-2 then begin
    lblW.Font.Color:=clMaroon;
    lblB.Font.Color:=clGreen
  end else begin
    lblW.Font.Color:=clNavy;
    lblB.Font.Color:=clNavy;
  end;
end;
//______________________________________________________________________________
procedure TfCLBoard.pupGameMenuPopup(Sender: TObject);
begin
  miCopy.Enabled := (GM <> nil) and (GM.GameMode <> gmCLSLive);
  miLibrary.Enabled := (GM <> nil) and (GM.GameResult <> '') and (GM.GameResult <> '-');
end;
//______________________________________________________________________________
procedure TfCLBoard.miLibraryClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_LIBRARY_ADD, IntToStr(GM.GameNumber),'g']);
end;
//______________________________________________________________________________
procedure TfCLBoard.RemoveGame(const Game: TCLGame);
begin
  if GM = Game then GM := nil;
  fCLNavigate.RemoveObject(Game);
  fCLTerminal.CloseTab(fkGame, Integer(Game));
  FGames.Remove(Game);
end;
//______________________________________________________________________________
procedure TfCLBoard.miGameSaveClick(Sender: TObject);
begin
  fCLMain.miGameSave.Click;
end;
//______________________________________________________________________________
end.


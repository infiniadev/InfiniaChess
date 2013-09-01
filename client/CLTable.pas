
{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLTable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls,CSReglament,CLRectMap,CLTournament,Math,
  Menus;

type
  TfCLTable = class(TForm)
    Panel1: TPanel;
    lblGames: TLabel;
    sbMax: TSpeedButton;
    scbHor: TScrollBar;
    scbVer: TScrollBar;
    pm: TPopupMenu;
    miForfeit: TMenuItem;
    pnlPhoto: TPanel;
    imgPhoto: TImage;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDblClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure scbHorChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure pmPopup(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);
  private
    { Private declarations }
    RectMap: TCLRectMap;
    CurRectIndex: integer;
    BitMap: TBitMap;
    TableRight,PictureWidth,PictureHeight,StartX,StartY: integer;
    LastX, LastY: integer;
    CurImageLogin: string;
    procedure SetScrollBars;
    procedure PutSheduleOne(Canvas: TCanvas; X,Y,RoundNum: integer; var pp_Bottom: integer);
    procedure PutShedule(Canvas: TCanvas; Y: integer);
    procedure DrawTableUserList(p_Canvas: TCanvas; p_Left,p_Top: integer; MemberList: TCSUserList; var pp_Width: integer);
    procedure DrawRoundTable(Canvas: TCanvas; var pp_Right,pp_Bottom: integer);
    procedure DrawElimTable(Canvas: TCanvas; var pp_Right,pp_Bottom: integer);
    procedure DrawMatchTable(Canvas: TCanvas; var pp_Right,pp_Bottom: integer);
    procedure DrawSwissTable(Canvas: TCanvas; var pp_Right,pp_Bottom: integer);
  public
    { Public declarations }
    Tournament: TCSTournament;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy;

    procedure DrawActiveTable;
  end;

var
  fCLTable: TfCLTable;

implementation

uses CLMain,CLLib,CLGame,CLImageLib,CLGlobal,CLSocket,CLConst;

const
  ROW_HEIGHT = 20;
  LEFT_INDENT = 20;
  TOP_INDENT = 70;
  SHED_WIDTH = 200;
  SHED_INDENT = 40;
  MIN_SHED_COLS = 3;
  SMALL_INDENT = 5;

  COLOR_WIN = clGreen;
  COLOR_DRAW = clBlack;
  COLOR_LOST = clRed;
  COLOR_UNKNOWN = clMaroon;

{var
  ranks: array[0..7] of string =
    ('1-2','7-8','3-6','1-2','7-8','3-6','3-6','3-6');}

{$R *.DFM}
//================================================================================
{ TfCLTable }
//================================================================================
constructor TfCLTable.Create(AOwner: TComponent);
begin
  inherited;
  RectMap:=TCLRectMap.Create;
  BitMap:=TBitMap.Create;
  BitMap.PixelFormat:=pfDevice;
  BitMap.Width:=2000;
  BitMap.Height:=2000;
end;
//================================================================================
destructor TfCLTable.Destroy;
begin
  RectMap.Free;
  BitMap.Free;
end;
//================================================================================
procedure TfCLTable.DrawTableUserList(p_Canvas: TCanvas; p_Left,p_Top: integer; MemberList: TCSUserList; var pp_Width: integer);
var
  i,n,y,bottom,NumberWidth,NameWidth,RatingWidth,TitleWidth: integer;
  NameStart,TitleStart,RatingStart: integer;
  user: TCSUser;
  fs: TFontStyles;
begin
  NumberWidth:=p_Canvas.TextWidth(IntToStr(MemberList.Count))+SMALL_INDENT*2;

  p_Canvas.Font.Style:=[fsBold];
  TitleWidth:=p_Canvas.TextWidth('TITLE')+SMALL_INDENT*2;

  NameWidth:=p_Canvas.TextWidth('PLAYERS');
  for i:=0 to MemberList.Count-1 do begin
    n:=p_Canvas.TextWidth(MemberList[i].Login);
    if n>NameWidth then NameWidth:=n;
  end;
  NameWidth:=NameWidth+SMALL_INDENT*2;
  RatingWidth:=p_Canvas.TextWidth('RATING')+SMALL_INDENT*2;

  TitleStart:=p_Left+NumberWidth;
  NameStart:=TitleStart+TitleWidth;
  RatingStart:=NameStart+NameWidth;
  pp_Width:=NumberWidth+NameWidth+TitleWidth+RatingWidth;

  bottom:=p_Top+(MemberList.Count+1)*ROW_HEIGHT;
  p_Canvas.Font.Style:=[];

  p_Canvas.Pen.Width:=1;
  p_Canvas.Pen.Color:=clBlack;
  p_Canvas.MoveTo(NameStart,p_Top);
  p_Canvas.LineTo(NameStart,bottom);
  p_Canvas.MoveTo(TitleStart,p_Top);
  p_Canvas.LineTo(TitleStart,bottom);
  p_Canvas.MoveTo(RatingStart,p_Top);
  p_Canvas.LineTo(RatingStart,bottom);
  TextOut(p_Canvas,NameStart+SMALL_INDENT,p_Top+4,'PLAYERS',clBlack,8,[fsBold]);
  TextOut(p_Canvas,TitleStart+SMALL_INDENT,p_Top+4,'TITLE',clBlack,8,[fsBold]);
  TextOut(p_Canvas,RatingStart+SMALL_INDENT,p_Top+4,'RATING',clBlack,8,[fsBold]);

  for i:=0 to MemberList.Count-1 do begin
    if i=0 then p_Canvas.Pen.Width:=2
    else p_Canvas.Pen.Width:=1;

    {x:=LEFT_INDENT+NameWidth+i*ColWidth;
    p_Canvas.MoveTo(x,TOP_INDENT);
    p_Canvas.LineTo(x,bottom+1-p_Canvas.Pen.Width);}

    {
    p_Canvas.MoveTo(LEFT_INDENT,y);
    p_Canvas.LineTo(right,y);}
    y:=p_Top+(i+1)*ROW_HEIGHT;
    user:=MemberList[i];

    with Tournament.Reglament do
      if ((CurRound > 1) or (CurRound=1) and CurRoundCompleted) and (user.RankMin = 1) then
        fs:=[fsBold]
      else
        fs:=[];

    TextOutCenter(p_Canvas,Rect(p_Left,y,TitleStart,y+ROW_HEIGHT),IntToStr(i+1),clBlack,8,fs);
    TextOutCenter(p_Canvas,Rect(TitleStart,y,NameStart,y+ROW_HEIGHT),user.Title,clBlack,8,fs);
    TextOutCenter(p_Canvas,Rect(NameStart,y,RatingStart,y+ROW_HEIGHT),user.Login,clBlack,8,fs);
    TextOutCenter(p_Canvas,Rect(RatingStart,y,RatingStart+RatingWidth,y+ROW_HEIGHT),IntToStr(user.Rating),clBlack,8,fs);
    RectMap.AddRect(i,Rect(p_Left,y,p_Left+pp_Width,y+ROW_HEIGHT),rctPlayer,i,true,user.Login);
  end;
end;
//================================================================================
procedure TfCLTable.DrawRoundTable(Canvas: TCanvas; var pp_Right,pp_Bottom: integer);
const
  COL_WIDTH = 40;
var
  i,NameWidth,n,y,right,bottom,ColWidth: integer;
  x1,x2,y1,y2: integer;
  user: TCSUser;
  rgame: TCSReglGame;
  s: string;
  MemberList: TCSUserList;
  ReglGames: TList;
  //******************************************************************************
  procedure PutRealResult(WhiteNum,BlackNum: integer; sResult: string; PlaceNum: integer);
  var
    x1,y1,w: integer;
    col: TColor;
  begin
    x1:=LEFT_INDENT+NameWidth+(BlackNum)*ColWidth;
    y1:=TOP_INDENT+(WhiteNum+1)*ROW_HEIGHT;
    if sResult='1' then col:=COLOR_WIN
    else if sResult='0' then col:=COLOR_LOST
    else if sResult='1/2' then col:=COLOR_DRAW
    else col:=COLOR_UNKNOWN;

    if PlaceNum=2 then x1:=x1+ColWidth div 2;

    if Tournament.Reglament.ENumber=1 then w:=ColWidth
    else w:=ColWidth div 2;


    TextOutCenter(Canvas,Rect(x1,y1,x1+w,y1+ROW_HEIGHT),sResult,col,8,[fsBold]);
  end;
  //******************************************************************************
  procedure PutResult(rgame: TCSReglGame);
  var
    sWhite,sBlack: string;
    PlaceNum: integer;
  begin
    if rgame.result=rgrWhiteWin then begin
      sWhite:='1'; sBlack:='0';
    end else if rgame.result=rgrBlackWin then begin
      sWhite:='0'; sBlack:='1';
    end else if rgame.result=rgrDraw then begin
      sWhite:='1/2'; sBlack:='1/2';
    end else if rgame.result=rgrNone then
      if rgame.GameNum>0 then begin
        sWhite:='P'; sBlack:='P';
      end else begin
        sWhite:=''; sBlack:='';
      end;

    if sWhite<>'' then begin
      PlaceNum:=rgame.ID div (Tournament.Reglament.GamesCount div Tournament.Reglament.ENumber)+1;
      PutRealResult(rgame.WhiteNum,rgame.BlackNum,sWhite,PlaceNum);
      PutRealResult(rgame.BlackNum,rgame.WhiteNum,sBlack,PlaceNum);
    end;
  end;
  //******************************************************************************
  procedure DrawTable;
  var
    i,x: integer;
  begin
    Canvas.Pen.Color:=clBlack;
    Canvas.Pen.Width:=2;
    Canvas.Brush.Style := bsClear;
    Canvas.Brush.Color := Self.Color;

    DrawTableUserList(Canvas,LEFT_INDENT,TOP_INDENT,MemberList,NameWidth);
    right:=LEFT_INDENT+NameWidth+(MemberList.Count+2)*ColWidth;
    Canvas.Pen.Width:=2;
    Canvas.Polyline([Point(LEFT_INDENT,TOP_INDENT),Point(right,TOP_INDENT),
      Point(right,bottom),Point(LEFT_INDENT,bottom),Point(LEFT_INDENT,TOP_INDENT)]);
    for i:=0 to MemberList.Count-1 do begin
      if i=0 then Canvas.Pen.Width:=2
      else Canvas.Pen.Width:=1;

      x:=LEFT_INDENT+NameWidth+i*ColWidth;
      Canvas.MoveTo(x,TOP_INDENT);
      Canvas.LineTo(x,bottom+1-Canvas.Pen.Width);
      Canvas.TextOut(x+8,TOP_INDENT+3,IntToStr(i+1));
      y:=TOP_INDENT+(i+1)*ROW_HEIGHT;
      Canvas.MoveTo(LEFT_INDENT,y);
      Canvas.LineTo(right,y);
    end;

    Canvas.Pen.Width:=2;
    x:=LEFT_INDENT+NameWidth+MemberList.Count*ColWidth;
    Canvas.MoveTo(x,TOP_INDENT);
    Canvas.LineTo(x,bottom+1-Canvas.Pen.Width);
    Canvas.TextOut(x+4,TOP_INDENT+3,'Score');
    x:=LEFT_INDENT+NameWidth+(MemberList.Count+1)*ColWidth;
    pp_Right:=x;
    Canvas.MoveTo(x,TOP_INDENT);
    Canvas.LineTo(x,bottom+1-Canvas.Pen.Width);
    Canvas.TextOut(x+4,TOP_INDENT+3,'Rank');
    Canvas.Brush.Style := bsSolid;

    Canvas.Brush.Color:=clGray;
    for i:=0 to MemberList.Count-1 do begin
      if i=MemberList.Count-1 then n:=1
      else n:=0;
      x1:=LEFT_INDENT+NameWidth+i*ColWidth+1;
      x2:=LEFT_INDENT+NameWidth+(i+1)*ColWidth-n;
      y1:=TOP_INDENT+(i+1)*ROW_HEIGHT+1;
      y2:=TOP_INDENT+(i+2)*ROW_HEIGHT-n;
      Canvas.FillRect(Rect(x1,y1,x2,y2));
    end;
    Canvas.Brush.Color:=fCLTable.Color;

  end;
  //******************************************************************************
  procedure PutScore;
  var
    i,x,y: integer;
  begin
    Tournament.Reglament.CountRanks;
    x:=LEFT_INDENT+NameWidth+MemberList.Count*ColWidth;
    for i:=0 to MemberList.Count-1 do begin
      y:=TOP_INDENT+(i+1)*ROW_HEIGHT;
      TextOutCenter(Canvas,Rect(x,y,x+ColWidth,y+ROW_HEIGHT),MemberList[i].ScoreString,
        clBlack,8,[fsBold]);
      TextOutCenter(Canvas,Rect(x+ColWidth,y,x+ColWidth*2,y+ROW_HEIGHT),MemberList[i].RankString,
        clBlack,8,[fsBold]);
      {Canvas.TextOut(x+4,y+4,MemberList[i].ScoreString);
      Canvas.TextOut(x+ColWidth+4,y+4,MemberList[i].RankString);}
    end;
  end;
  //******************************************************************************
  function GetTableRect(WhiteNum,BlackNum,PlaceNum: integer): TRect;
  var
    x1,y1,x2,y2,w: integer;
  begin
    x1:=LEFT_INDENT+NameWidth+WhiteNum*ColWidth+1;
    y1:=TOP_INDENT+(BlackNum+1)*ROW_HEIGHT;
    y2:=y1+ROW_HEIGHT-2;

    if PlaceNum=2 then x1:=x1+ColWidth div 2;

    if Tournament.Reglament.ENumber=1 then w:=ColWidth
    else w:=ColWidth div 2;

    x2:=x1+w-2;
    result:=Rect(x1,y1,x2,y2);
  end;
  //******************************************************************************
  procedure CreateGamesRects;
  var
    i,PlaceNum: integer;
    rgame: TCSReglGame;
  begin
    RectMap.ClearByType(rctGame);
    for i:=0 to ReglGames.Count-1 do begin
      rgame:=ReglGames[i];
      if rgame.GameNum<>0 then begin
        PlaceNum:=rgame.ID div (Tournament.Reglament.GamesCount div Tournament.Reglament.ENumber)+1;
        RectMap.AddRect(i,GetTableRect(rgame.WhiteNum,rgame.BlackNum,PlaceNum),rctGame,rgame.GameNum,rgame.GameNum<>-1,'');
        RectMap.AddRect(i,GetTableRect(rgame.BlackNum,rgame.WhiteNum,PlaceNum),rctGame,rgame.GameNum,rgame.GameNum<>-1,'');
      end;
    end;
  end;
  //******************************************************************************
begin
  // initialization
  Self.Tournament:=Tournament;
  Tournament.Reglament.CountRanksFinishedRounds;
  if Tournament.Reglament.ENumber=2 then
    ColWidth:=60
  else
    ColWidth:=COL_WIDTH;

  MemberList:=Tournament.Reglament.MemberList;
  ReglGames:=Tournament.Reglament.ReglGames;
  Canvas.Brush.Color:=fCLTable.Color;
  bottom:=TOP_INDENT+(MemberList.Count+1)*ROW_HEIGHT;
  pp_Bottom:=bottom;

  // title
  TextOut(Canvas,LEFT_INDENT,30,Tournament.Name,clBlue,14,[fsBold]);
  DrawTable;
  CreateGamesRects;

  // results
  for i:=0 to ReglGames.Count-1 do begin
    rgame:=TCSReglGame(ReglGames[i]);
    PutResult(rgame);
  end;

  PutScore;
end;
//================================================================================
procedure TfCLTable.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  rct: TCLRect;
  LoginImage: TLoginImage;
  nTop, nLeft: integer;
begin
  CurRectIndex:=RectMap.IndexByPoint(StartX+X,StartY+Y, false);

  if CurRectIndex = -1 then begin
    Cursor:=0;
    pnlPhoto.Visible:=false;
    CurImageLogin:='';
  end else begin
    rct:=RectMap[CurRectIndex];
    if rct.Defined then Cursor:=1
    else Cursor:=0;

    if (rct.Type_ = rctPlayer) and not fGL.PhotoTournament then begin
      if rct.sTag<>CurImageLogin then begin
        LoginImage:=fLoginImages[rct.sTag];
        pnlPhoto.Visible:=(LoginImage<>nil);
        if pnlPhoto.Visible then begin
          nTop:=rct.Rect.Bottom + 2 - StartX;
          if nTop<0 then nTop:=0;

          nLeft:=rct.Rect.Left - StartY;
          if nLeft+pnlPhoto.Width>fCLTable.Width then
            nLeft:=fCLTable.Width - pnlPhoto.Width;

          pnlPhoto.Top:=nTop;
          pnlPhoto.Left:=nLeft;
          CopyBitmap(LoginImage.Photo,imgPhoto.Picture.Bitmap);
        end;
        CurImageLogin:=rct.sTag;
      end;
    end else
      CurImageLogin:='';
  end;

  if CurRectIndex<>-1 then Cursor:=1
  else Cursor:=0;

  LastX:=X; LastY:=Y;
end;
//================================================================================
procedure TfCLTable.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  clRect: TCLRect;
  game: TCLGame;
begin
  FormMouseMove(Sender,Shift,X,Y);
  if (Button=mbLeft) and (CurRectIndex<>-1) then begin
    clRect:=RectMap[CurRectIndex];
    if (clRect.Type_=rctGame) and (clRect.Defined) then begin
      game:=Tournament.FindGameByGameNumber(clRect.Tag);
      if game<>nil then
        fCLSocket.InitialSend([CMD_STR_EVENT_GAME_OBSERVE,IntToStr(game.GameNumber)]);
        fCLMain.SetActivePane(0, game);
    end;
  end;
end;
//================================================================================
procedure TfCLTable.DrawActiveTable;
var
  nRight,nBottom: integer;
begin
  RectMap.Clear;
  BitMap.Canvas.Brush.Color:=Self.Color;
  BitMap.Canvas.FillRect(Rect(0,0,Bitmap.Width-1,Bitmap.Height-1));
  case Tournament.Reglament.TourType of
    trtRound: DrawRoundTable(Bitmap.Canvas,nRight,nBottom);
    trtElim: DrawElimTable(Bitmap.Canvas,nRight,nBottom);
    trtMatch: DrawMatchTable(Bitmap.Canvas,nRight,nBottom);
    trtSwiss: DrawSwissTable(Bitmap.Canvas,nRight,nBottom);
  end;
  TableRight:=nRight;
  if Tournament.Reglament.TourType<>trtMatch then
    PutShedule(BitMap.Canvas,nBottom+20);
  SetScrollBars;
end;
//================================================================================
procedure TfCLTable.FormDblClick(Sender: TObject);
begin
  SetScrollBars;
  {DrawActiveTable;
  Self.Canvas.CopyRect(Rect(1,1,100,100),Bitmap.Canvas,Rect(1,1,100,100));}
end;
//================================================================================
procedure TfCLTable.FormPaint(Sender: TObject);
begin
  Self.Canvas.CopyRect(Rect(0,0,Width-1,Height-1),Bitmap.Canvas,
    Rect(StartX,StartY,StartX+Width,StartY+Height));
end;
//================================================================================
procedure TfCLTable.SetScrollBars;
begin
  scbHor.Visible:=PictureWidth>Self.Width;
  if scbHor.Visible then begin
    scbHor.Max:=PictureWidth-Self.Width;
    scbHor.SmallChange:=scbHor.Max div 10;
    scbHor.LargeChange:=scbHor.Max div 3;
    //scbHor.PageSize:=scbHor.Max*Self.Width div PictureWidth;
  end;

  scbVer.Visible:=PictureHeight>Self.Height;
  if scbVer.Visible then begin
    scbVer.Max:=PictureHeight-Self.Height;
    scbVer.SmallChange:=scbVer.Max div 10;
    scbVer.LargeChange:=scbVer.Max div 3;
    //scbVer.PageSize:=scbVer.Max*Self.Height div PictureHeight;
  end;
end;
//================================================================================
procedure TfCLTable.scbHorChange(Sender: TObject);
begin
  StartX:=scbHor.Position;
  StartY:=scbVer.Position;
  Repaint;
end;
//================================================================================
procedure TfCLTable.FormResize(Sender: TObject);
begin
  SetScrollBars;
end;
//================================================================================
procedure TfCLTable.PutSheduleOne(Canvas: TCanvas; X,Y,RoundNum: integer; var pp_Bottom: integer);
var
  i,w,h,curY: integer;
  rgame: TCSReglGame;
  s,res,white,black: string;
  user: TCSUser;
begin
  curY:=Y;
  TextOut(Canvas,X,Y,'Round '+IntToStr(RoundNum),clBlack,12,[fsBold],w,h);
  CurY:=CurY+h+4;
  for i:=0 to Tournament.Reglament.ReglGames.Count-1 do begin
    rgame:=TCSReglGame(Tournament.Reglament.ReglGames[i]);
    if (rgame.RoundNum<>RoundNum) or rgame.IsByeGame then
      continue;
    res:=ReglGameResult2Str(rgame.result);
    try
      user:=Tournament.Reglament.MemberList[rgame.WhiteNum];
      white:=GetNameWithTitle(user.Login,user.Title)+' '+IntToStr(user.Rating);
    except
      white := '*Unknown*';
    end;
    try
      user:=Tournament.Reglament.MemberList[rgame.BlackNum];
      black:=GetNameWithTitle(user.Login,user.Title)+' '+IntToStr(user.Rating);
    except
      black := '*Unknown*';
    end;

    s:=white+' - '+black;
    if rgame.GameNum<>-1 then begin
       Canvas.Font.Color:=clBlue;
       Canvas.Pen.Color:=clBlue;
       Canvas.Pen.Width:=1;
       Canvas.MoveTo(X-1,CurY+13);
       Canvas.LineTo(X+Canvas.TextWidth(s),CurY+13);
       Canvas.Pen.Color:=clBlack;
       RectMap.AddRect(i,Rect(X,CurY,X+SHED_WIDTH,CurY+Canvas.TextHeight(s)),rctGame,rgame.GameNum,rgame.GameNum<>-1,'');
    end else
      Canvas.Font.Color:=clBlack;

    Canvas.TextOut(X,CurY,s);
    if res<>'' then
      Canvas.TextOut(X+SHED_WIDTH-Canvas.TextWidth(res),CurY,res);
    Canvas.Font.Color:=clBlack;
    CurY:=CurY+Canvas.TextHeight(s)+4;
  end;
  pp_Bottom:=CurY;
end;
//================================================================================
procedure TfCLTable.PutShedule(Canvas: TCanvas; Y: integer);
var
  i,X,n,nCols,nRounds,maxBottom: integer;
begin
  Canvas.Brush.Style := bsClear;
  nRounds:=Tournament.Reglament.RoundCount;
  nCols:=(TableRight-LEFT_INDENT) div (SHED_WIDTH+SHED_INDENT)+1;
  if nCols<MIN_SHED_COLS then nCols:=MIN_SHED_COLS;

  maxBottom:=Y;
  for i:=1 to nRounds do begin
    X:=LEFT_INDENT+((i-1) mod nCols)*(SHED_WIDTH+SHED_INDENT);
    if i mod nCols = 1 then begin
      Y:=maxBottom+20;
    end;

    PutSheduleOne(Canvas,X,Y,i,n);
    if n>maxBottom then maxBottom:=n;
  end;
  PictureHeight:=maxBottom+40;
  PictureWidth:=max(LEFT_INDENT+(nCols)*(SHED_WIDTH+SHED_INDENT),TableRight);
  Canvas.Brush.Style := bsSolid;
end;
//================================================================================
procedure TfCLTable.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta>0 then
    scbVer.Position:=scbVer.Position-scbVer.SmallChange
  else
    scbVer.Position:=scbVer.Position+scbVer.SmallChange;
end;
//================================================================================
procedure TfCLTable.pmPopup(Sender: TObject);
{var
  index: integer;}
begin
  {index:=RectMap.IndexByPoint(LastX,LastY);
  if index=-1 then}
end;
//================================================================================
procedure TfCLTable.DrawElimTable(Canvas: TCanvas; var pp_Right,pp_Bottom: integer);
const
  RECT_INSIDE_INDENT = 10;
  RECT_VERT_INDENT = 10;
  ROUND_INDENT = 20;
var
  NameWidth,RectHeight,RectWidth: integer;
  MemberList: TCSUserList;
  ReglGames: TList;
  WinnerColor: TColor;
  //******************************************************************************
  function GetFullName(user: TCSUser): string;
  begin
    result:=Format('%s %d',[GetNameWithTitle(user.Login,user.Title),user.Rating]);
  end;
  //******************************************************************************
  function GetMaxNameWidth: integer;
  var
    i,n: integer;
    s: string;
  begin
    result:=0;
    for i:=0 to MemberList.Count-1 do begin
      s:=GetFullName(MemberList[i]);
      n:=Canvas.TextWidth(s);
      if n>result then result:=n;
    end;
  end;
  //******************************************************************************
  function CountRoundMembers(RoundNum: integer): integer;
  var
    i,n: integer;
  begin
    n:=1;
    repeat n:=n*2
    until n>=MemberList.Count;

    for i:=1 to RoundNum-1 do
      n:=n div 2;

    result:=n;
  end;
  //******************************************************************************
  procedure DrawRect(rct: TRect; col: TColor; Text: string);
  var
    oldColor: TColor;
  begin
    oldColor:=Canvas.Brush.Color;
    Canvas.Rectangle(rct);
    Canvas.Brush.Color:=col;
    Canvas.FillRect(Rect(rct.Left+1,rct.Top+1,rct.Right-1,rct.Bottom-1));
    TextOutCenter(Canvas,rct,Text,clBlack,8,[]);
    Canvas.Brush.Color:=oldColor;
  end;
  //******************************************************************************
  procedure DrawOneRoundRects(RoundNum,xLeft,yTop,Indent: integer);
  var
    i,x1,y1,nPlaying,nMembers,bye: integer;
    rct: TRect;
    col: TColor;
  begin
    x1:=xLeft; y1:=yTop;
    bye:=MemberList.ByeCountElim;
    nMembers:=CountRoundMembers(RoundNum);
    nPlaying:=0;
    for i:=0 to MemberList.Count-1 do begin
      if not Tournament.Reglament.UserIsRoundMember(MemberList[i].Login,RoundNum) then begin
        if Tournament.Reglament.UserIsRoundMember(MemberList[i].Login,RoundNum-1) then begin
          inc(nPlaying);
          if (nPlaying mod 2 = 0) and (RoundNum>Tournament.Reglament.RoundCount) then
            y1:=y1+RectHeight+Indent;
        end;
        continue;
      end;

      rct:=Rect(x1,y1,x1+RectWidth,y1+RectHeight);
      if (nMembers=1) or Tournament.Reglament.UserIsRoundMember(MemberList[i].Login,RoundNum+1) then
        col:=WinnerColor
      else
        col:=fCLTable.Color;
      DrawRect(rct,col,GetFullName(MemberList[i]));
      y1:=y1+RectHeight+Indent;

      if (RoundNum=1) and (i>=MemberList.Count-bye) then begin
        rct:=Rect(x1,y1,x1+RectWidth,y1+RectHeight);
        DrawRect(rct,clGray,'');
        y1:=y1+RectHeight+Indent;
      end;

      if rct.Bottom>pp_Bottom then pp_Bottom:=rct.Bottom;
      if rct.Right>pp_Right then pp_Right:=rct.Right;
    end;
  end;
  //******************************************************************************
  procedure DrawOneRoundLines(RoundNum,xLeft,yTop,Indent: integer);
  var
    i,y1,y2,middle,nMembers: integer;
  begin
    nMembers:=CountRoundMembers(RoundNum);
    y1:=yTop+RectHeight div 2;
    for i:=1 to nMembers div 2 do begin
      y2:=y1+RectHeight+Indent;
      middle:=xLeft+ROUND_INDENT div 2;
      Canvas.MoveTo(xLeft,y1);
      Canvas.LineTo(middle,y1);
      Canvas.LineTo(middle,y2);
      Canvas.LineTo(xLeft,y2);
      Canvas.MoveTo(middle,(y2+y1) div 2);
      Canvas.LineTo(xLeft+ROUND_INDENT,(y2+y1) div 2);
      y1:=y1+2*(RectHeight+Indent);
    end;
  end;
  //******************************************************************************
  procedure DrawRects;
  var
    i,nLeft,nTop,nIndent: integer;
  begin
    nLeft:=LEFT_INDENT;
    nTop:=TOP_INDENT;
    nIndent:=RECT_VERT_INDENT;
    for i:=1 to Tournament.Reglament.RoundCount+1 do begin
      DrawOneRoundRects(i,nLeft,nTop,nIndent);
      if i<=Tournament.Reglament.RoundCount then
        DrawOneRoundLines(i,nLeft+RectWidth,nTop,nIndent);
      nLeft:=nLeft+RectWidth+ROUND_INDENT;
      nTop:=nTop+(RectHeight+nIndent) div 2;
      nIndent:=nIndent+RectHeight+nIndent;
    end;
  end;
  //******************************************************************************
begin
  MemberList:=Tournament.Reglament.MemberList;
  ReglGames:=Tournament.Reglament.ReglGames;
  TextOut(Canvas,LEFT_INDENT,30,Tournament.Name,clBlue,14,[fsBold]);
  WinnerColor:=255*256;
  pp_Right:=0;
  pp_Bottom:=0;

  NameWidth:=GetMaxNameWidth;
  RectWidth:=NameWidth+2*RECT_INSIDE_INDENT;
  RectHeight:=Canvas.TextHeight('A')+8;
  DrawRects;
  //DrawOneRoundRects(1,LEFT_INDENT,TOP_INDENT,RECT_VERT_INDENT);
  //DrawOneRoundRects(2,LEFT_INDENT+RectWidth+ROUND_INDENT,TOP_INDENT,RECT_VERT_INDENT);
  //DrawOneRoundRects(3,LEFT_INDENT+2*(RectWidth+ROUND_INDENT),TOP_INDENT,RECT_VERT_INDENT);
end;
//================================================================================
procedure TfCLTable.DrawMatchTable(Canvas: TCanvas; var pp_Right,pp_Bottom: integer);
const
  ROW_HEIGHT = 20;
  NAME_WIDTH = 180;
  NUMBER_WIDTH = 20;
var
  MemberList: TCSUserList;
  ReglGames: TList;
  i,X,Y,w,h,h1,StartY,TableWidth,TableHeight,wins0,wins1: integer;
  rgame: TCSReglGame;
  s,res,whiteres,blackres: string;
  user: TCSUser;
  //******************************************************************************
  procedure PutRealResult(PlayerNum,RoundNum: integer; sResult: string);
  var
    x1,y1: integer;
    col: TColor;
  begin
    x1:=LEFT_INDENT+NUMBER_WIDTH+PlayerNum*NAME_WIDTH;
    y1:=StartY+(RoundNum+1)*ROW_HEIGHT;
    if sResult='1' then col:=COLOR_WIN
    else if sResult='0' then col:=COLOR_LOST
    else if sResult='=' then col:=COLOR_DRAW
    else col:=COLOR_UNKNOWN;

    TextOutCenter(Canvas,Rect(x1,y1,x1+NAME_WIDTH,y1+ROW_HEIGHT),sResult,col,8,[]);
  end;
  //******************************************************************************
begin
  MemberList:=Tournament.Reglament.MemberList;
  if MemberList.Count<2 then exit;
  ReglGames:=Tournament.Reglament.ReglGames;
  TextOut(Canvas,LEFT_INDENT,30,Tournament.Name,clBlue,14,[fsBold],w,h);

  if Tournament.Reglament.ENumber<>0 then
    s:=Format('(till %d wins)',[Tournament.Reglament.ENumber])
  else
    s:=Format('(%d rounds)',[Tournament.Reglament.NumberOfRounds]);
  TextOut(Canvas,LEFT_INDENT,30+h,s,clBlack,10,[fsBold],w,h1);

  TableWidth:=NUMBER_WIDTH+2*NAME_WIDTH;
  TableHeight:=(ReglGames.Count+2)*ROW_HEIGHT;

  StartY:=40+h+h1;

  Canvas.Pen.Color:=clBlack;
  Canvas.Pen.Width:=2;
  Canvas.Rectangle(LEFT_INDENT,StartY,LEFT_INDENT+TableWidth,StartY+TableHeight);
  Canvas.Rectangle(LEFT_INDENT,StartY,LEFT_INDENT+TableWidth,StartY+ROW_HEIGHT);
  Canvas.Rectangle(LEFT_INDENT,StartY+TableHeight-ROW_HEIGHT,LEFT_INDENT+TableWidth,StartY+TableHeight);

  Canvas.Pen.Width:=1;
  Canvas.MoveTo(LEFT_INDENT+NUMBER_WIDTH,StartY);
  Canvas.LineTo(LEFT_INDENT+NUMBER_WIDTH,StartY+TableHeight);

  Canvas.MoveTo(LEFT_INDENT+NUMBER_WIDTH+NAME_WIDTH,StartY);
  Canvas.LineTo(LEFT_INDENT+NUMBER_WIDTH+NAME_WIDTH,StartY+TableHeight);

  TextOutCenter(Canvas,Rect(LEFT_INDENT+NUMBER_WIDTH,StartY,LEFT_INDENT+NUMBER_WIDTH+NAME_WIDTH,StartY+ROW_HEIGHT),
    GetNameWithTitle(MemberList[0].Login,MemberList[0].Title),clBlack,8,[fsBold]);

  TextOutCenter(Canvas,Rect(LEFT_INDENT+NUMBER_WIDTH+NAME_WIDTH,StartY,LEFT_INDENT+TableWidth,StartY+ROW_HEIGHT),
    GetNameWithTitle(MemberList[1].Login,MemberList[1].Title),clBlack,8,[fsBold]);

  for i:=0 to Tournament.Reglament.ReglGames.Count-1 do begin
    rgame:=TCSReglGame(Tournament.Reglament.ReglGames[i]);
    Y:=StartY+(i+1)*ROW_HEIGHT;
    TextOutCenter(Canvas,Rect(LEFT_INDENT,Y,LEFT_INDENT+NUMBER_WIDTH,Y+ROW_HEIGHT),
      IntToStr(i+1),clBlack,8,[]);

    if rgame.result=rgrDraw then begin
      whiteres:='='; blackres:='=';
    end else if rgame.Result=rgrNone then begin
      whiteres:='P'; blackres:='P';
    end else if (rgame.result=rgrWhiteWin) and (rgame.WhiteNum=0) or
      (rgame.result=rgrBlackWin) and (rgame.WhiteNum=1)
    then begin
      whiteres:='1'; blackres:='0';
    end else begin
      whiteres:='0'; blackres:='1';
    end;

    PutRealResult(0,i,whiteres);
    PutRealResult(1,i,blackres);

    Canvas.Pen.Width:=1;
    Canvas.MoveTo(LEFT_INDENT,Y);
    Canvas.LineTo(LEFT_INDENT+TableWidth,Y);

    RectMap.AddRect(i,Rect(LEFT_INDENT,Y,LEFT_INDENT+TableWidth,Y+ROW_HEIGHT),rctGame,rgame.GameNum,rgame.GameNum<>-1,'');

  end;
  // results
  Tournament.Reglament.CountMatchResult(wins0,wins1);
  TextOutCenter(Canvas,
    Rect(LEFT_INDENT+NUMBER_WIDTH,StartY+TableHeight-ROW_HEIGHT,LEFT_INDENT+NUMBER_WIDTH+NAME_WIDTH,StartY+TableHeight),
    IntToStr(wins0),clBlue,10,[fsBold]);
  TextOutCenter(Canvas,
    Rect(LEFT_INDENT+NUMBER_WIDTH+NAME_WIDTH,StartY+TableHeight-ROW_HEIGHT,LEFT_INDENT+TableWidth,StartY+TableHeight),
    IntToStr(wins1),clBlue,10,[fsBold]);

  pp_Bottom:=StartY+TableHeight;
end;
//================================================================================
procedure TfCLTable.sbMaxClick(Sender: TObject);
begin
  Self.SetFocus;
  fCLMain.miMaximizeTop.Click;
end;
//================================================================================
procedure TfCLTable.DrawSwissTable(Canvas: TCanvas; var pp_Right,pp_Bottom: integer);
const
  NUMBER_WIDTH = 20;
  ROW_HEIGHT = 20;
  COLOR_WHITE = clPurple;
  COLOR_BLACK = clBlack;
var
  MemberList: TCSUserList;
  ReglGames: TList;
  rgame: TCSReglGame;
  i,PlayerNumWidth,ResultWidth,ColWidth,right,bottom,NameWidth: integer;
  //******************************************************************************
  procedure PutRealResult(RoundNum,PlayerNum,OpponentNum: integer; IsWhite: Boolean; sResult: string;
    ID: integer; rgame: TCSReglGame);
  var
    x1,y1,x2,y2,w: integer;
    col,col1: TColor;
  begin
    if PlayerNum = -1 then exit;
    if OpponentNum = -1 then begin
      x1:=LEFT_INDENT+NameWidth+(RoundNum-1)*ColWidth+1;
      x2:=x1+ColWidth-1;
      y1:=TOP_INDENT+(PlayerNum+1)*ROW_HEIGHT+1;
      y2:=y1+ROW_HEIGHT-1;
      if OpponentNum=MemberList.Count-1 then y2:=y2-1;

      Canvas.Brush.Color:=clGray;
      Canvas.FillRect(Rect(x1,y1,x2,y2));
      Canvas.Brush.Color:=fCLTable.Color;
      exit;
    end;

    x1:=LEFT_INDENT+NameWidth+(RoundNum-1)*ColWidth;
    y1:=TOP_INDENT+(PlayerNum+1)*ROW_HEIGHT;

    if sResult='1' then col:=COLOR_WIN
    else if sResult='0' then col:=COLOR_LOST
    else if sResult='1/2' then col:=COLOR_DRAW
    else col:=COLOR_UNKNOWN;

    if IsWhite then col1:=COLOR_WHITE
    else col1:=COLOR_BLACK;

    TextOutCenter(Canvas,Rect(x1,y1,x1+PlayerNumWidth,y1+ROW_HEIGHT),'('+IntToStr(OpponentNum+1)+')',col1,8,[]);
    TextOutCenter(Canvas,Rect(x1+PlayerNumWidth,y1,x1+ColWidth,y1+ROW_HEIGHT),sResult,col,8,[fsBold]);
    RectMap.AddRect(ID,Rect(x1,y1,x1+ColWidth,y1+ROW_HEIGHT),rctGame,rgame.GameNum,rgame.GameNum<>-1,'');
  end;
  //******************************************************************************
  procedure PutResult(ID: integer; rgame: TCSReglGame);
  var
    sWhite,sBlack: string;
    PlaceNum: integer;
  begin
    if rgame.result=rgrWhiteWin then begin
      sWhite:='1'; sBlack:='0';
    end else if rgame.result=rgrBlackWin then begin
      sWhite:='0'; sBlack:='1';
    end else if rgame.result=rgrDraw then begin
      sWhite:='1/2'; sBlack:='1/2';
    end else begin
      sWhite:=''; sBlack:='';
    end;

    PutRealResult(rgame.RoundNum,rgame.WhiteNum,rgame.BlackNum,true,sWhite,ID,rgame);
    PutRealResult(rgame.RoundNum,rgame.BlackNum,rgame.WhiteNum,false,sBlack,ID,rgame);
  end;
  //******************************************************************************
  procedure DrawTable;
  var
    i,x,y,n,x1,x2,y1,y2: integer;
    user: TCSUser;
    s: string;
  begin
    Canvas.Pen.Color:=clBlack;

    DrawTableUserList(Canvas,LEFT_INDENT,TOP_INDENT,MemberList,NameWidth);
    right:=LEFT_INDENT+NameWidth+ColWidth+(Tournament.Reglament.NumberOfRounds+2)*ColWidth;
    pp_Right:=right;
    Canvas.Pen.Width:=2;
    Canvas.Polyline([Point(LEFT_INDENT,TOP_INDENT),Point(right,TOP_INDENT),
      Point(right,bottom),Point(LEFT_INDENT,bottom),Point(LEFT_INDENT,TOP_INDENT)]);

    for i:=0 to MemberList.Count-1 do begin
      if i=0 then Canvas.Pen.Width:=2
      else Canvas.Pen.Width:=1;

      y:=TOP_INDENT+(i+1)*ROW_HEIGHT;
      Canvas.MoveTo(LEFT_INDENT,y);
      Canvas.LineTo(right,y);
    end;
    for i:=0 to Tournament.Reglament.NumberOfRounds-1 do begin
      x:=LEFT_INDENT+NameWidth+i*ColWidth;
      Canvas.MoveTo(x,TOP_INDENT);
      Canvas.LineTo(x,bottom+1-Canvas.Pen.Width);
      TextOutCenter(Canvas,Rect(x,TOP_INDENT,x+ColWidth,TOP_INDENT+ROW_HEIGHT),IntToStr(i+1),clBlack,8,[fsBold]);
    end;

    Canvas.Pen.Width:=2;
    x:=LEFT_INDENT+NameWidth+Tournament.Reglament.NumberOfRounds*ColWidth;
    Canvas.MoveTo(x,TOP_INDENT);
    Canvas.LineTo(x,bottom+1-Canvas.Pen.Width);
    Canvas.TextOut(x+4,TOP_INDENT+3,'Score');
    x:=LEFT_INDENT+NameWidth+(Tournament.Reglament.NumberOfRounds+1)*ColWidth;
    pp_Right:=x;
    Canvas.MoveTo(x,TOP_INDENT);
    Canvas.LineTo(x,bottom+1-Canvas.Pen.Width);
    Canvas.TextOut(x+4,TOP_INDENT+3,'Rank');
  end;
  //******************************************************************************
  procedure PutScore;
  var
    i,x,y: integer;
  begin
    Tournament.Reglament.CountRanks;
    x:=LEFT_INDENT+NameWidth+Tournament.Reglament.NumberOfRounds*ColWidth;
    for i:=0 to MemberList.Count-1 do begin
      y:=TOP_INDENT+(i+1)*ROW_HEIGHT;
      TextOutCenter(Canvas,Rect(x,y,x+ColWidth,y+ROW_HEIGHT),MemberList[i].ScoreString,
        clBlack,8,[fsBold]);
      TextOutCenter(Canvas,Rect(x+ColWidth,y,x+ColWidth*2,y+ROW_HEIGHT),MemberList[i].RankString,
        clBlack,8,[fsBold]);
    end;
  end;
  //******************************************************************************
begin
  Tournament.Reglament.CountRanksFinishedRounds;
  MemberList:=Tournament.Reglament.MemberList;
  ReglGames:=Tournament.Reglament.ReglGames;
  PlayerNumWidth:=Canvas.TextWidth(IntToStr(MemberList.Count))+10;
  ResultWidth:=40;
  ColWidth:=PlayerNumWidth+ResultWidth;
  NameWidth:=180;
  bottom:=TOP_INDENT+(MemberList.Count+1)*ROW_HEIGHT;
  pp_Bottom:=bottom;
  TextOut(Canvas,LEFT_INDENT,30,Tournament.Name,clBlue,14,[fsBold]);
  DrawTable;

  for i:=0 to ReglGames.Count-1 do begin
    rgame:=TCSReglGame(ReglGames[i]);
    PutResult(i,rgame);
  end;

  PutScore;
end;
//================================================================================
end.

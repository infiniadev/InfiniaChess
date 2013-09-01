{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLLib;

interface

uses Graphics,Math,SysUtils,ComCtrls,Windows,controls,stdctrls,
  FileCtrl,CSReglament,Classes,JPEG,CLGame,ComObj,ActiveX,extctrls,
  Variants, Menus;

type
  TMembershipType = (mmbNone, mmbTrial, mmbPaid, mmbEmployee, mmbVIP, mmbOldMember);

  TProgressIndicatorOptions = class
  public
    EdgeColor: TColor;
    BorderColor: TColor;
    GreenColor: TColor;
    EmptyColor: TColor;
    TextColor: TColor;
    ShadowColor: TColor;
    BackgroundColor: TColor;

    BorderWidth: integer;
    CornerShift: integer;
    ShadowShift: integer;
    FontSize: integer;
    FontStyle: TFontStyles;

    constructor Create;
  end;

function LPad(p_Str: string; p_Num: integer; p_Char: string): string;
procedure Log(p_Str: string; p_FileName: string = '');
function BoolTo_(b: Boolean; p_True,p_False: Variant): Variant;
procedure MoveListViewItemToExists(p_LV: TListView; p_From,p_To: integer);
procedure MoveListViewItem(p_LV: TListView; p_From,p_To: integer);
function CompareVars(p_Var1,p_Var2: Variant): integer;
procedure DrawTransparentBmp(
  Cnv: TCanvas;
  BmpFrom: Graphics.TBitmap;
  BmpX, BmpY, BmpSizeX, BmpSizeY, x, y: integer;
  clTransparent: TColor);
function Str2Float(Str: string): real;
function Replace(Str: string; cFrom,cTo: char): string;
procedure CopyListViewItems(ItemsFrom,ItemsTo: TListItems);
function AddLabel(
  Control: TWinControl;
  Text: string;
  X,Y: integer;
  Color: TColor;
  Style: TFontStyles
): TLabel;
function SubstrN(const Str: string; const Sep: char;  const Num: integer): string;
function RatingString2Rating(RatingString: string; RType: integer): string;
procedure DevideNameTitle(FullName: string; var Name,Title: string);
function FindListViewIndex(LV: TListView; Str: string; Where: integer = -1): integer;
function ReglGameResult2Str(p_Result: TCSReglGameResult): string;
procedure TextOut(Canvas: TCanvas; X,Y: integer; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles;
  var pp_Width,pp_Height: integer); overload;
procedure GetTextParams(Canvas: TCanvas; Text: string; Size: integer; Style: TFontStyles;
  var pp_Width, pp_Height: integer);
function TextWidth(Canvas: TCanvas; Text: string; Size: integer; Style: TFontStyles): integer;
function TextHeight(Canvas: TCanvas; Text: string; Size: integer; Style: TFontStyles): integer;

procedure TextOut(Canvas: TCanvas; X,Y: integer; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles); overload;
procedure TextOutCenter(Canvas: TCanvas; Rect: TRect; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles; CutIfNotMatch: Boolean = false);
procedure TextOutMultiLine(Canvas: TCanvas; Left, Right, Top, YDistance: integer; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles; var pp_Bottom: integer;
  p_Center: Boolean = FALSE; p_HeightLimit: integer = 0);
function TextHeightMultiLine(Canvas: TCanvas; Width, YDistance: integer; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles): integer;
function GameParamOfferText(p_InitMin, p_InitSec, p_IncTime: integer): string;
function GameParamOfferTextFull(p_InitMin, p_InitSec, p_IncTime: integer): string;
function MSecToGridStr(p_InitMSec,p_IncMSec: integer): string;
function TimeAbsValue(p_Time: string): integer;
function TimeToStrEventFormat(p_InitTime: string; p_IncTime: integer): string;
function TimeConvertToS(Str: string): string;
function TimeConvertToPoint(Str: string): string;
procedure TimeToComponents(p_Time: string; var pp_InitMin,pp_InitSec,pp_DimIndex: integer);
function RemoveSpaces(p_Str: string): string;
function EncryptANSI(p_Str: ANSIstring): ANSIstring;
function DecryptANSI(p_Str: ANSIstring): ANSIstring;
function BitmapToANSIString(bmp: Graphics.TBitMap): ANSIString;
function ANSIStringToBitmap(Str: string; bmp: Graphics.TBitmap): Boolean;
procedure SaveStrToFile(FileName,Str: string);
procedure CopyBitmap(bmpFrom,bmpTo: Graphics.TBitMap);
procedure ColorDescByName(sColor: string; var col: TColor; var Desc: string);
procedure Str2StringList(s:string;var sl:TStringList;Sep:string=',');
procedure SaveErrorLog(Source,ProcName: string; Addr: integer; Msg, SocketCommand: string);
procedure SendErrorToServer(Source,ProcName: string; Addr: integer; Msg, SocketCommand: string);
procedure ProcessError(Source,ProcName: string; Addr: integer; Msg, SocketCommand: string);
function ControlSumm(Str: string): LongWord;
function Var2String(V: Variant): string;
function GetExtension(FileName: string): string;
function GetNameWithTitle(const name,title: string): string;
procedure CreateDirectoryTree(p_Dir: string);
procedure ClearDirectory(p_Dir: string; p_Ext: string = '*');
function RatedType2Str(RatedType: TRatedType): string;
procedure PutListViewToExcel(LV: TListView; p_Head: string);
function IntToStrPlus(Num: integer): string;
function TimeToMSec(p_Time: string): integer;
function TimeSecToMinSec(Sec: integer): string;
function MultiKeyExists: Boolean;
function AgeByBirthday(Birthday: TDateTime): string;
function GetOptionsDate(year, month, day: word): TDateTime;
function RGB(R,G,B: byte): TColor;
function PointInRect(R: TRect; X,Y: integer): Boolean;
procedure DrawFrame(cnv: TCanvas; p_Rect: TRect; p_Color: TColor; p_Width, p_CornerShift: integer);
procedure DrawFilledFrame(cnv: TCanvas; p_Rect: TRect; p_Color, p_FillColor: TColor; p_Width, p_CornerShift: integer);
procedure DrawFilledFrameWithCorners(cnv: TCanvas; p_Rect: TRect; p_Color, p_FillColor: TColor;
  p_Width, p_CornerShift: integer; p_CornersColor: TColor);
procedure DrawProgressIndicator(cnv: TCanvas; R: TRect; Text: string;
  Progress, MaxCount: integer; Options: TProgressIndicatorOptions);
function IncRect(R: TRect; X, Y: integer): TRect;
function ZoomRect(R: TRect; X, Y: integer): TRect;
function RemoveControlSymbols(Str: string): string;
function Sign(N: integer): integer;
function Date2Str(dt: TDateTime): string;
procedure GetDateDiff(Date1, Date2: TDateTime; var pp_Days, pp_Hours, pp_Minutes: integer);
function GetTimeAgo(p_Date: TDateTime): string;
function IsRightNumber(p_Str: string): Boolean;
function InCommaString(CommaString, part: string): Boolean; overload;
function InCommaString(CommaString: string; part: integer): Boolean; overload;
function MembershipType2FontStyle(p_MT: TMembershipType): TFontStyles;
function ColorByRatedType(p_RatedType: TRatedType): TColor;
procedure CopyPopupMenu(p_Source, p_Dest: TPopupMenu);
function GetAutoUpdateExe: string;
procedure DeleteAutoUpdates;
function CreateProcessSimple(sExecutableFilePath: string): string;

var
  Months: array[1..12] of string = ('January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December');
  MonthsShort: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');


implementation

uses CLConst, CLMain, CLSocket, CLGlobal;
//==========================================================================
function LPad(p_Str: string; p_Num: integer; p_Char: string): string;
var i: integer;
begin
  result:='';
  for i:=length(p_Str)+1 to p_Num do
    result:=result+p_Char;
  result:=result+p_Str;
end;
//==========================================================================
procedure Log(p_Str: string; p_FileName: string = '');
var F: TextFile;
begin
  //if not DEBUGGING then exit;
  if (DebugHook = 0) or not LOGGING then exit;
  if not DirectoryExists(MAIN_DIR+'log') then
    CreateDir(MAIN_DIR+'log');
  if p_FileName='' then
    if fCLSocket=nil then p_FileName:='DEFAULT_LOG_NAME'
    else p_FileName:=fCLSocket.MyName+'.log';
  p_FileName:=MAIN_DIR+'log\'+p_FileName;
  AssignFile(F,p_FileName);
  try
    Append(F)
  except
    Rewrite(F);
  end;
  writeln(F,p_Str);
  CloseFile(F);
end;
//==========================================================================
function BoolTo_(b: Boolean; p_True,p_False: Variant): Variant;
begin
  if b then result:=p_True
  else result:=p_False;
end;
//==========================================================================
procedure CopyListViewItem(p_LV: TListView; p_From,p_To: integer);
var i: integer;
begin
  try
    if p_From=p_To then
      raise exception.create('cannot copy item to itself');
    with p_LV do begin
      Items[p_To].Caption:=Items[p_From].Caption;
      for i:=Items[p_To].SubItems.Count to Items[p_From].SubItems.Count do
        Items[p_To].SubItems.Add('');
      for i:=0 to Items[p_From].SubItems.Count-1 do
        Items[p_To].SubItems[i]:=Items[p_From].SubItems[i];
      Items[p_To].ImageIndex := Items[p_From].ImageIndex;
    end;
  except
    on E:Exception do
      raise exception.create('CopyListViewItem: '+E.Message);
  end;
end;
//==========================================================================
procedure MoveListViewItemToExists(p_LV: TListView; p_From,p_To: integer);
begin
  if p_From = p_To then exit;
  CopyListViewItem(p_LV,p_From,p_To);
  p_LV.Items.Delete(p_From);
end;
//==========================================================================
procedure MoveListViewItem(p_LV: TListView; p_From,p_To: integer);
var
  item: TListItem;
begin
  CLLib.Log(Format('MoveListViewItem(LV,%d,%d)',[p_From,p_To]));
  if p_From = p_To then exit;

  if p_To<0 then p_To:=0;
  if p_To>=p_LV.Items.Count then
    item:=p_LV.Items.Add
  else
    item:=p_LV.Items.Insert(p_To);
  if p_To<p_From then inc(p_From);
  CopyListViewItem(p_LV,p_From,p_To);
  p_LV.Items.Delete(p_From);
end;
//==========================================================================
function CompareVars(p_Var1,p_Var2: Variant): integer;
// result: 0: equal; 1: p_Var1 less then p_Var2; -1: p_Var1 greater then p_Var2
begin
  if p_Var1<p_Var2 then result:=1
  else if p_Var1=p_Var2 then result:=0
  else result:=-1;
end;
//==========================================================================
procedure DrawTransparentBmp(
  Cnv: TCanvas;
  BmpFrom: Graphics.TBitmap;
  BmpX, BmpY, BmpSizeX, BmpSizeY, x, y: integer;
  clTransparent: TColor);
var
  Bmp,bmpXOR, bmpAND, bmpINVAND, bmpTarget: Graphics.TBitmap;
  oldcol: Longint;
begin
  try
    Bmp := Graphics.TBitmap.Create;
    Bmp.Width := BmpSizeX;
    Bmp.Height := BmpSizeY;
    Bmp.Monochrome := false;
    BitBlt(Bmp.Canvas.Handle, 0, 0, BmpSizeX, BmpSizeY, BmpFrom.Canvas.Handle, BmpX, BmpY, SRCCOPY);

    bmpAND := Graphics.TBitmap.Create;
    bmpAND.Width := Bmp.Width;
    bmpAND.Height := Bmp.Height;
    bmpAND.Monochrome := True;
    oldcol := SetBkColor(Bmp.Canvas.Handle, ColorToRGB(clTransparent));
    BitBlt(bmpAND.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
    SetBkColor(Bmp.Canvas.Handle, oldcol); 

    bmpINVAND := Graphics.TBitmap.Create;
    bmpINVAND.Width := Bmp.Width; 
    bmpINVAND.Height := Bmp.Height; 
    bmpINVAND.Monochrome := True; 
    BitBlt(bmpINVAND.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, bmpAND.Canvas.Handle, 0, 0, NOTSRCCOPY); 

    bmpXOR := Graphics.TBitmap.Create;
    bmpXOR.Width := Bmp.Width; 
    bmpXOR.Height := Bmp.Height; 
    BitBlt(bmpXOR.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY); 
    BitBlt(bmpXOR.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, bmpINVAND.Canvas.Handle, 0, 0, SRCAND); 

    bmpTarget := Graphics.TBitmap.Create;
    bmpTarget.Width := Bmp.Width;
    bmpTarget.Height := Bmp.Height;
    BitBlt(bmpTarget.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, Cnv.Handle, x, y, SRCCOPY);
    BitBlt(bmpTarget.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, bmpAND.Canvas.Handle, 0, 0, SRCAND);
    BitBlt(bmpTarget.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, bmpXOR.Canvas.Handle, 0, 0, SRCINVERT);
    BitBlt(Cnv.Handle, x, y, Bmp.Width, Bmp.Height, bmpTarget.Canvas.Handle, 0, 0, SRCCOPY); 
  finally
    bmp.Free;
    bmpXOR.Free; 
    bmpAND.Free; 
    bmpINVAND.Free; 
    bmpTarget.Free; 
  end; 
end;
//=====================================================================
function Str2Float(Str: string): real;
var
  n: integer;
  c: char;
begin
  if DECIMALSEPARATOR = '.' then c:=','
  else c:='.';
  n:=pos(c,Str);
  if n>0 then Str[n]:=DECIMALSEPARATOR;
  result:=StrToFloat(Str);
end;
//==========================================================================
function Replace(Str: string; cFrom,cTo: char): string;
var i: integer;
begin
  result:=Str;
  for i:=1 to length(Str) do
    if result[i]=cFrom then
      result[i]:=cTo;
end;
//=====================================================================
procedure CopyListViewItems(ItemsFrom,ItemsTo: TListItems);
var
  i,j: integer;
  itmFrom,itmTo: TListItem;
begin
  ItemsTo.Clear;
  for i:=0 to ItemsFrom.Count-1 do begin
    itmFrom:=ItemsFrom[i];
    itmTo:=ItemsTo.Add;
    itmTo.Caption:=itmFrom.Caption;
    for j:=0 to itmFrom.SubItems.Count-1 do
      itmTo.SubItems.Add(itmFrom.SubItems[j]);
  end;
end;
//=====================================================================
function AddLabel(
  Control: TWinControl;
  Text: string;
  X,Y: integer;
  Color: TColor;
  Style: TFontStyles): TLabel;
var
  lbl: TLabel;
begin
  lbl:=TLabel.Create(Control);
  lbl.Caption:=Text;
  lbl.Left:=X;
  lbl.Top:=Y;
  lbl.Font.Color:=Color;
  lbl.Font.Style:=Style;
  Control.InsertControl(lbl);
  result:=lbl;
end;
//=====================================================================
function SubstrN(const Str: string; const Sep: char;  const Num: integer): string;
var i,n: integer;
begin
  n:=0; result:='';
  for i:=1 to length(Str) do begin
    if Str[i]=Sep then inc(n);
    if n>Num then exit;
    if (Str[i]<>Sep) and (n=Num) then
      result:=result+Str[i];
  end;
end;
//=====================================================================
function RatingString2Rating(RatingString: string; RType: integer): string;
begin
  result:=SubstrN(SubstrN(RatingString,';',RType),',',0);
end;
//=====================================================================
procedure DevideNameTitle(FullName: string; var Name,Title: string);
var
  n: integer;
begin
  n:=pos('(',FullName);
  if n=0 then begin
    Name:=FullName; Title:='';
  end else begin
    Name:=trim(copy(FullName,1,n-1));
    Title:=copy(FullName,n+1,length(FullName)-n-1);
  end;
end;
//=====================================================================
function FindListViewIndex(LV: TListView; Str: string; Where: integer = -1): integer;
var
  i: integer;
  item: TListItem;
begin
  for i:=0 to LV.Items.Count-1 do begin
    item:=LV.Items[i];
    if (Where=-1) and (item.Caption=Str) or
      (Where<>-1) and (item.SubItems[Where]=Str)
    then begin
      result:=i;
      exit;
    end;
  end;
  result:=-1;
end;
//=====================================================================
function ReglGameResult2Str(p_Result: TCSReglGameResult): string;
begin
  case p_Result of
    rgrWhiteWin: result:='1-0';
    rgrBlackWin: result:='0-1';
    rgrDraw: result:='1/2';    
  else
    result:='';
  end;
end;
//=====================================================================
procedure TextOut(Canvas: TCanvas; X,Y: integer; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles;
  var pp_Width,pp_Height: integer);
var
  OldColor: TColor;
  OldSize: integer;
  OldStyle: TFontStyles;
begin
  OldColor:=Canvas.Font.Color;
  OldSize:=Canvas.Font.Size;
  OldStyle:=Canvas.Font.Style;

  Canvas.Font.Color:=Color;
  if Size <> -1 then Canvas.Font.Size:=Size;

  Canvas.Font.Style:=Style;
  Canvas.Brush.Style := bsClear;

  pp_Width:=Canvas.TextWidth(Text);
  pp_Height:=Canvas.TextHeight(Text);

  Canvas.TextOut(X,Y,Text);

  Canvas.Font.Color:=OldColor;
  Canvas.Font.Size:=OldSize;
  Canvas.Font.Style:=OldStyle;
  Canvas.Brush.Style := bsSolid;
end;
//=====================================================================
procedure GetTextParams(Canvas: TCanvas; Text: string; Size: integer; Style: TFontStyles;
  var pp_Width, pp_Height: integer);
var
  OldSize: integer;
  OldStyle: TFontStyles;
begin
  OldSize:=Canvas.Font.Size;
  OldStyle:=Canvas.Font.Style;
  Canvas.Font.Size := Size;
  Canvas.Font.Style := Style;
  pp_Width := Canvas.TextWidth(Text);
  pp_Height := Canvas.TextHeight(Text);
  Canvas.Font.Size:=OldSize;
  Canvas.Font.Style:=OldStyle;
end;
//=====================================================================
function TextWidth(Canvas: TCanvas; Text: string; Size: integer; Style: TFontStyles): integer;
var
  w, h: integer;
begin
  GetTextParams(Canvas, Text, Size, Style, w, h);
  result := w;
end;
//=====================================================================
function TextHeight(Canvas: TCanvas; Text: string; Size: integer; Style: TFontStyles): integer;
var
  w, h: integer;
begin
  GetTextParams(Canvas, Text, Size, Style, w, h);
  result := h;
end;
//=====================================================================
procedure TextOut(Canvas: TCanvas; X,Y: integer; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles);
var
  DumpWidth,DumpHeight: integer;
begin
  TextOut(Canvas,X,Y,Text,Color,Size,Style,DumpWidth,DumpHeight);
end;
//=====================================================================
procedure TextOutCenter(Canvas: TCanvas; Rect: TRect; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles; CutIfNotMatch: Boolean = false);
var
  RectHeight,RectWidth,TextHeight,TextWidth: integer;
  OldSize,X,Y: integer;
  OldColor: TColor;
  OldStyle: TFontStyles;
  //****************************************************************************
  procedure CutText;
  var
    i: integer;
    s: string;
  begin
    i := length(Text) - 1;
    while i > 1 do begin
      s := copy(Text, 1, i) + '...';
      if Canvas.TextWidth(s) < RectWidth then
        break;
      dec(i);
    end;
    Text := s;
    TextWidth := Canvas.TextWidth(Text);
  end;
  //****************************************************************************
begin
  RectHeight:=Rect.Bottom-Rect.Top+1;
  RectWidth:=Rect.Right-Rect.Left+1;

  OldColor:=Canvas.Font.Color;
  OldSize:=Canvas.Font.Size;
  OldStyle:=Canvas.Font.Style;

  Canvas.Font.Color:=Color;
  Canvas.Font.Size:=Size;
  Canvas.Font.Style:=Style;
  Canvas.Brush.Style := bsClear;

  TextWidth:=Canvas.TextWidth(Text);
  TextHeight:=Canvas.TextHeight(Text);

  if CutIfNotMatch and (TextWidth > RectWidth) then
    CutText;

  X:=Rect.Left+(RectWidth-TextWidth) div 2;
  Y:=Rect.Top+(RectHeight-TextHeight) div 2;

  Canvas.TextOut(X,Y,Text);

  Canvas.Font.Color:=OldColor;
  Canvas.Font.Size:=OldSize;
  Canvas.Font.Style:=OldStyle;
  Canvas.Brush.Style := bsSolid;
end;
//=====================================================================
procedure TextOutMultiLine(Canvas: TCanvas; Left, Right, Top, YDistance: integer; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles; var pp_Bottom: integer;
  p_Center: Boolean = FALSE; p_HeightLimit: integer = 0);
const
  MAX_DIVISION_LEN = 14;
  MAX_DIVISION_RELATION = 0.6;
var
  Width, OldSize, X, Y, w: integer;
  OldColor: TColor;
  OldStyle: TFontStyles;
  sLine: string;
  //*******************************************************************
  function GetNumOfSymbolsFetch: integer;
  var
    i, w: integer;
    s: string;
  begin
    w := Canvas.TextWidth(Text);
    if w <= Width then result := length(Text)
    else begin
      s := '';
      for i := 1 to length(Text) do begin
        s := s + Text[i];
        w := Canvas.TextWidth(s);
        if w > Width then begin
          result := i - 1;
          break;
        end;
      end;
    end;
    if result = 0 then result := 1;
  end;
  //*******************************************************************
  function FindSpace(N: integer): integer;
  begin
    while (N > 0) and (Text[N] <> ' ') do
      dec(N);
    result := N;
  end;
  //*******************************************************************
  procedure BiteOff(var pp_Str: string);
  var
    n, NFull, NReturn: integer;
  begin
    NFull := GetNumOfSymbolsFetch();
    NReturn := pos('\n', Text);

    if (NFull = length(Text)) or (Text[NFull + 1] = ' ') then n := NFull
    else begin
      n := FindSpace(NFull);
      if (n = 0) or (NFull - n > MAX_DIVISION_LEN) or (1.0 * (NFull - n) / NFull > MAX_DIVISION_RELATION) then begin
        Insert('-', Text, NFull);
        n := NFull;
      end;
    end;

    if (NReturn > 0) and (NReturn < n) then begin
      pp_Str := copy(Text, 1, NReturn - 1);
      Text := copy(Text, NReturn + 2, length(Text));
    end else begin
      pp_Str := copy(Text, 1, n);
      Text := copy(Text, n + 1, length(Text));
    end;
  end;
  //*******************************************************************
begin

  Width := Right - Left;

  OldColor:=Canvas.Font.Color;
  OldSize:=Canvas.Font.Size;
  OldStyle:=Canvas.Font.Style;

  Canvas.Font.Color:=Color;
  Canvas.Font.Size:=Size;
  Canvas.Font.Style:=Style;
  Canvas.Brush.Style := bsClear;

  pp_Bottom := Top;
  while Text <> '' do begin
    BiteOff(sLine);
    if (p_HeightLimit > 0) and (pp_Bottom + Canvas.TextHeight(sLine) > p_HeightLimit) then
      break;
    if p_Center then begin
      w := Canvas.TextWidth(sLine);
      Canvas.TextOut(Left + (Width - w) div 2, pp_Bottom, sLine)
    end else
      Canvas.TextOut(Left, pp_Bottom, sLine);
    pp_Bottom := pp_Bottom + Canvas.TextHeight(sLine) + YDistance;
  end;

  Canvas.Font.Color := OldColor;
  Canvas.Font.Size := OldSize;
  Canvas.Font.Style := OldStyle;
  Canvas.Brush.Style := bsSolid;

end;
//=====================================================================
function TextHeightMultiLine(Canvas: TCanvas; Width, YDistance: integer; Text: string;
  Color: TColor; Size: integer; Style: TFontStyles): integer;
var
  height: integer;
begin
  TextOutMultiline(Canvas, -Width, -1, 0, YDistance, Text, Color, Size, Style, height);
  result := height;
end;
//=====================================================================
function GameParamOfferText(p_InitMin, p_InitSec, p_IncTime: integer): string;
var
  s: string;
begin
  s := '';
  if p_InitMin <> 0 then begin
    s := s + IntToStr(p_InitMin);
    if p_InitSec <> 0 then s := s + 'm';
  end;
  if p_InitSec <> 0 then s := s + IntToStr(p_InitSec) + 's';
  result:= s + '-' + IntToStr(p_IncTime);
end;
//=====================================================================
function GameParamOfferTextFull(p_InitMin, p_InitSec, p_IncTime: integer): string;
var
  s: string;
begin
  s := '';
  if p_InitMin <> 0 then begin
    s := s + IntToStr(p_InitMin);
    if p_InitSec <> 0 then s := s + ' min';
  end;
  if p_InitSec <> 0 then s := s + ' ' + IntToStr(p_InitSec) + ' sec';
  result:= s + ' + ' + IntToStr(p_IncTime) + ' sec per move';
end;
//=====================================================================
function MSecToGridStr(p_InitMSec,p_IncMSec: integer): string;
var
  n: integer;
begin
  n:=p_InitMSec div 1000;
  if n mod 60 = 0 then result:=IntToStr(n div 60)
  else result:=IntToStr(n)+'s';

  result:=result+'-'+IntToStr(p_IncMSec div 1000);
end;
//=====================================================================
function TimeAbsValue(p_Time: string): integer;
var
  n: integer;
begin
  n:=pos('.',p_Time);
  if n=0 then result:=StrToInt(p_Time)
  else result:=StrToInt(copy(p_Time,n+1,length(p_Time)));
end;
//=====================================================================
function TimeToStrEventFormat(p_InitTime: string; p_IncTime: integer): string;
var
  n: integer;
begin
  n:=pos('.',p_InitTime);
  if n=0 then result:=p_InitTime+' min'
  else result:=copy(p_InitTime,n+1,100)+' sec';

  result:=result+' + '+IntToStr(p_IncTime)+' sec';
end;
//=====================================================================
function TimeConvertToS(Str: string): string;
// convert from 0.45 format to 45s
var
  n: integer;
begin
  n:=pos('.',Str);
  if n=0 then result:=Str
  else result:=copy(Str,n+1,length(Str))+'s';
end;
//=====================================================================
function TimeConvertToPoint(Str: string): string;
// convert from 45s format to 0.45
begin
  if pos('s',Str)=0 then result:=Str
  else result:='0.'+copy(Str,1,length(Str)-1);
end;
//=====================================================================
procedure TimeToComponents(p_Time: string; var pp_InitMin,pp_InitSec,pp_DimIndex: integer);
var
  s: string;
  sec, n: integer;
begin
  s:=p_Time;
  n:=pos('.',s);
  if n=0 then begin
    pp_InitMin:=StrToInt(s);
    pp_InitSec := 0;
    pp_DimIndex:=0;
  end else begin
    sec := StrToInt(copy(s,n+1,length(s)));
    pp_InitMin := sec div 60;
    pp_InitSec := sec mod 60;
    pp_DimIndex:=1;
  end;
end;
//=====================================================================
function RemoveSpaces(p_Str: string): string;
var
  i: integer;
begin
  result:='';
  for i:=1 to length(p_Str) do
    if p_Str[i]<>' ' then
      result:=result+p_Str[i];
end;
//=====================================================================
var ALFA1: string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_!';

function EncryptANSI(p_Str: ANSIstring): ANSIstring;
var
  i,n: integer;
begin
  result:='@!001!'+IntToStr(length(p_Str) mod 3);

  if length(p_Str) mod 3=1 then p_Str:=p_Str+#0#0
  else if length(p_Str) mod 3=2 then p_Str:=p_Str+#0;


  for i:=0 to length(p_Str) div 3 -1 do begin
    n:=ord(p_Str[i*3+1])*256*256+ord(p_Str[i*3+2])*256+ord(p_Str[i*3+3]);
    result:=result+ALFA1[n div (64*64*64) + 1];
    n:=n mod (64*64*64);
    result:=result+ALFA1[n div (64*64) + 1];
    n:=n mod (64*64);
    result:=result+ALFA1[n div 64 + 1]+ALFA1[n mod 64 + 1];
  end;
end;
//==============================================================================
function DecryptANSI(p_Str: ANSIstring): ANSIstring;
var i,n,k: integer;
  //****************************************************************************
  function Val(n: integer): integer;
  begin
    result:=pos(p_Str[n],ALFA1)-1;
  end;
  //****************************************************************************
begin
  if copy(p_Str,1,6)<>'@!001!' then
    raise exception.Create('DecryptSmart: wrong header');
  k:=StrToInt(p_Str[7]);
  p_Str:=copy(p_Str,8,length(p_Str));
  if length(p_Str) mod 4 <> 0 then
    raise exception.Create('Decrypt1: wrotg length of parameter!');
  result:='';
  for i:=0 to length(p_Str) div 4 - 1 do begin
    n:=Val(i*4+1)*64*64*64+Val(i*4+2)*64*64+Val(i*4+3)*64+Val(i*4+4);
    result:=result+chr(n div (256*256));
    n:=n mod (256*256);
    result:=result+chr(n div 256)+chr(n mod 256);
  end;
  if k<>0 then
    SetLength(result,length(result)-3+k);
end;
//==============================================================================
function BitmapToANSIString(bmp: Graphics.TBitMap): ANSIString;
var
  st: TStringStream;
  jpg: TJpegImage;
begin
  jpg:=TJpegImage.Create;
  st:=TStringStream.Create('');
  try
    jpg.Assign(bmp);
    jpg.CompressionQuality:=50;
    jpg.Compress;
    jpg.SaveToStream(st);
    result:=EncryptANSI(st.DataString);
  finally
    jpg.Free;
    st.Free;
  end;
end;
//==============================================================================
function ANSIStringToBitmap(Str: string; bmp: Graphics.TBitmap): Boolean;
var
  jpg: TJpegImage;
  ss: TStringStream;
begin
  try
    Str:=DecryptANSI(Str);
  except
    result:=false;
  end;
  ss:=TStringStream.Create(Str);
  //SaveStrToFile(MAIN_DIR+TEMP_IMAGE_FILE,Str);
  jpg:=TJpegImage.Create;
  try
    //jpg.LoadFromFile(MAIN_DIR+TEMP_IMAGE_FILE);
    jpg.LoadFromStream(ss);
    ss.Free;
    bmp.Assign(jpg);
    SysUtils.DeleteFile(MAIN_DIR+TEMP_IMAGE_FILE);
    result:=true;
  except
    jpg.Free;
  end;
end;
//==============================================================================
procedure SaveStrToFile(FileName,Str: string);
var
  F: TextFile;
begin
  AssignFile(F, FileName);
  Rewrite(F);
  Write(F,Str);
  CloseFile(F);
end;
//==============================================================================
procedure CopyBitmap(bmpFrom,bmpTo: Graphics.TBitMap);
begin
  bmpTo.Assign(bmpFrom);

  {bmpFrom.SaveToFile(MAIN_DIR+TEMP_IMAGE_FILE);
  bmpTo.LoadFromFile(MAIN_DIR+TEMP_IMAGE_FILE);
  SysUtils.DeleteFile(MAIN_DIR+TEMP_IMAGE_FILE);}
end;
//==============================================================================
procedure ColorDescByName(sColor: string; var col: TColor; var Desc: string);
begin
  if sColor='black' then col:=clBlack
  else if sColor='blue' then col:=clBlue
  else if sColor='dkgray' then col:=clDkGray
  else if sColor='fuchsia' then col:=clFuchsia
  else if sColor='gray' then col:=clGray
  else if sColor='green' then col:=clGreen
  else if sColor='lime' then col:=clLime
  else if sColor='ltgray' then col:=clLtGray
  else if sColor='maroon' then col:=clMaroon
  else if sColor='navy' then col:=clNavy
  else if sColor='olive' then col:=clOlive
  else if sColor='purple' then col:=clPurple
  else if sColor='red' then col:=clRed
  else if sColor='silver' then col:=clSilver
  else if sColor='teal' then col:=clTeal
  else if sColor='white' then col:=clWhite
  else if sColor='yellow' then col:=clYellow;

  if sColor='dkgray' then Desc:='Dark Gray'
  else if sColor='ltgray' then Desc:='Light Gray'
  else Desc:=UpperCase(copy(sColor,1,1))+copy(sColor,2,length(sColor));
end;
//==============================================================================
procedure Str2StringList(s:string;var sl:TStringList;Sep:string=',');
var n,i:integer;
begin
  if not Assigned(sl) then sl:=TStringList.Create;
  sl.Clear;
  if s='' then exit;
  n:=1;
  if s[length(s)]<>Sep then s:=s+Sep[1];
  for i:=1 to length(s) do
    if s[i]=Sep then begin
      sl.Add(trim(copy(s,n,i-n)));
      n:=i+1;
    end;
end;
//==============================================================================
procedure SaveErrorLog(Source,ProcName: string; Addr: integer; Msg, SocketCommand: string);
var
  F: TextFile;
begin
  AssignFile(F,ERROR_LOG_FILENAME);
  if FileExists(ERROR_LOG_FILENAME) then Append(F)
  else Rewrite(F);

  writeln(F,'=======================');
  writeln(F,FormatDateTime('yyyy-mm-dd hh:nn:ss',Date+Time)+': '+ProcName);
  write(F,'from '+Source);
  if SocketCommand <> '' then
    writeln(F,'; command='+SocketCommand)
  else
    writeln(F,'');
  writeln(F,IntToHex(integer(ErrorAddr),6));
  writeln(F,Msg);
  CloseFile(F);
end;
//==============================================================================
function ControlSumm(Str: string): LongWord;
var
  i,n: integer;
begin
  result:=0;
  for i:=1 to length(Str) do
    result:=result+ord(Str[i])*i;
end;
//==========================================================================
function Var2String(V: Variant): string;
begin
  case VarType(v) of
    varSmallInt, varInteger, varByte: result:=IntToStr(v);
    varSingle, varDouble: result:=FloatToStr(v);
    varBoolean: begin if v then result:='1' else result:='0'; end;
  else
    result:=v;
  end;
end;
//==========================================================================
function GetExtension(FileName: string): string;
var
  i: integer;
begin
  i:=length(FileName);
  while (i<>0) and (FileName[i]<>'.') do
    dec(i);
  if i=0 then result:=''
  else result:=copy(FileName,i+1,length(FileName));
end;
//==========================================================================
function GetNameWithTitle(const name,title: string): string;
begin
  if trim(title)='' then result:=name
  else result:=name+' ('+title+')';
end;
//==========================================================================
procedure CreateDirectoryTree(p_Dir: string);
var
  n: integer;
  s: string;
begin
  if p_Dir='' then exit;
  if p_Dir[length(p_Dir)]<>'\' then
    p_Dir:=p_Dir+'\';
  n:=pos('\',p_Dir);
  if n=0 then exit;
  if (n<=1) or (p_Dir[n-1]<>':') then exit;
  s:=copy(p_Dir,1,n-1);
  p_Dir:=copy(p_Dir,n+1,length(p_Dir));
  repeat
    n:=pos('\',p_Dir);
    if n<>0 then begin
      s:=s+'\'+copy(p_Dir,1,n-1);
      p_Dir:=copy(p_Dir,n+1,length(p_Dir));
      if not DirectoryExists(s) then
        CreateDir(s);
    end;
  until n=0;
end;
//==========================================================================
procedure ClearDirectory(p_Dir: string; p_Ext: string = '*');
var
  sr: TSearchRec;
  n: integer;
begin
  if not DirectoryExists(p_Dir) then exit;
  if p_Dir[length(p_Dir)]<>'\' then
    p_Dir:=p_Dir+'\';
  n:=FindFirst(p_Dir+'*.'+p_Ext,faAnyFile,sr);
  while n=0 do begin
    SysUtils.DeleteFile(p_Dir+sr.Name);
    n:=FindNext(sr);
  end;
end;
//==========================================================================
function RatedType2Str(RatedType: TRatedType): string;
begin
  case RatedType of
    rtStandard: result:='Standard';
    rtBlitz: result:='Blitz';
    rtBullet: result:='Bullet';
    rtCrazy: result:='Crazy House';
    rtFischer: result:='Fischer Random';
    rtLoser: result:='Losers';
  end;
end;
//==========================================================================
function ExcelNumberToColumn(n:integer):string;
begin
     if (n<1) or (n>8*26+22) then
        Raise Exception.Create('ExcelNumberToColumn('+IntToStr(n)+'): bad argument');
     if n<=26 then result:=chr(ord('A')+n-1)
     else result:=chr((n-1) div 26+ord('A')-1)+chr(ord('A')+(n-1) mod 26);
end;
//==========================================================================
function GetExcelRange(top,left,bottom,right:integer):string;
begin
    result:=ExcelNumberToColumn(left)+IntToStr(top)+':'+ExcelNumberToColumn(right)+IntToStr(bottom);
end;
//==============================================================================
procedure DrawLineInExcelByRange(p_List:Variant;p_Range:string;
          p_Position:integer;p_LineStyle:integer=1;p_Weight:integer=2);
begin
    p_List.Range[p_Range].Borders[p_Position].LineStyle:=p_LineStyle;
    p_List.Range[p_Range].Borders[p_Position].Weight:=p_Weight;
end;
//==============================================================================
procedure DrawLineInExcel(p_List:Variant;p_Left,p_Right,p_Top,p_Bottom:integer;
          p_Position:integer;p_LineStyle:integer=1;p_Weight:integer=2);
var range:string;
begin
    range:=ExcelNumberToColumn(p_Left)+IntToStr(p_Top)+':'+
           ExcelNumberToColumn(p_Right)+IntToStr(p_Bottom);
    DrawLineInExcelByRange(p_List,range,p_Position,p_LineStyle,p_Weight);
end;
//==============================================================================
procedure DrawNetInExcel(p_List:Variant;p_Left,p_Right,p_Top,p_Bottom:integer; p_Weight:integer=2;p_Inside:Boolean=TRUE);
const
  xlEdgeBottom = $00000009;
  xlEdgeLeft = $00000007;
  xlEdgeRight = $0000000A;
  xlEdgeTop = $00000008;
  xlInsideHorizontal = $0000000C;
  xlInsideVertical = $0000000B;

var
  range:string;
begin
  range:=ExcelNumberToColumn(p_Left)+IntToStr(p_Top)+':'+
         ExcelNumberToColumn(p_Right)+IntToStr(p_Bottom);
  DrawLineInExcelByRange(p_List,range,xlEdgeTop,1,p_Weight);
  DrawLineInExcelByRange(p_List,range,xlEdgeBottom,1,p_Weight);
  DrawLineInExcelByRange(p_List,range,xlEdgeLeft,1,p_Weight);
  DrawLineInExcelByRange(p_List,range,xlEdgeRight,1,p_Weight);
  if p_Inside and (p_Right-p_Left>0) then DrawLineInExcelByRange(p_List,range,xlInsideVertical,1,p_Weight);
  if p_Inside and (p_Bottom-p_Top>0) then DrawLineInExcelByRange(p_List,range,xlInsideHorizontal,1,p_Weight);
end;
//==============================================================================
procedure PutListViewToExcel(LV:TListView; p_Head: string);
const FIRSTLINE=6;
var XLApp,List:Variant;
    i,j,right,n:integer;
    range,Fields:string;
    Unknown: iUnknown;
    col: TListColumn;
    item: TListItem;
begin
  if Succeeded(GetActiveObject(ProgIDToClassID('Excel.Application'), nil, Unknown)) then
    XLApp := GetActiveOleObject('Excel.Application')
  else
    XLApp := CreateOleObject('Excel.Application');

  XLApp.Workbooks.Add;
  List:=XLApp.ActiveWorkBook.Worksheets[1];

  right := LV.Columns.Count;
  for i:=0 to right-1 do
    List.Cells[FIRSTLINE, i+1] := LV.Columns[i].Caption;
  range:=GetExcelRange(FIRSTLINE,1,FIRSTLINE,right);
  List.Range[range].Font.Bold:=TRUE;
  List.Range[range].Interior.ColorIndex:=34;
  List.Range[range].Borders.LineStyle:=1;
  List.Range[range].AutoFilter;


  for i:=0 to LV.Items.Count-1 do begin
    item := LV.Items[i];
    List.Cells[FIRSTLINE+i+1,1]:=item.Caption;
    for j:=0 to item.SubItems.Count-1 do
      List.Cells[FIRSTLINE+i+1,j+2]:=item.SubItems[j];
  end;
  List.Columns['A:'+ExcelNumberToColumn(right)].EntireColumn.AutoFit;

  if right > 3 then n := 2
  else n := 1;

  List.Cells[3,n]:=p_Head;
  List.Cells[3,n].Font.Bold:=TRUE;
  List.Cells[3,n].Font.Size:=14;
  DrawNetInExcel(List,1,right,FIRSTLINE+1,FIRSTLINE+LV.Items.Count);

   XLApp.Visible:=TRUE;
end;
//==============================================================================
procedure SendErrorToServer(Source,ProcName: string; Addr: integer; Msg, SocketCommand: string);
var
  src: string;
begin
  try
    if source = 'Interface' then src:='0'
    else src:='1';
    fCLSocket.InitialSend([CMD_STR_CLIENTERROR, src, RemoveSpaces(ProcName), IntToHex(Addr,6),
      RemoveSpaces(SocketCommand), Msg]);
  except
  end;
end;
//==============================================================================
procedure ProcessError(Source,ProcName: string; Addr: integer; Msg, SocketCommand: string);
begin
  if ERRORS_SAVING then SaveErrorLog(Source,ProcName,Addr,Msg,SocketCommand);
  if ERRORS_SENDING then SendErrorToServer(Source,ProcName,Addr,Msg,SocketCommand);
end;
//==============================================================================
function IntToStrPlus(Num: integer): string;
begin
  if Num >= 0 then result := '+' + IntToStr(Num)
  else result := IntToStr(Num);
end;
//==========================================================================
function TimeToMSec(p_Time: string): integer;
var
  n: integer;
begin
  n:=pos('.',p_Time);
  if n=0 then result:=1000*60*StrToInt(p_Time)
  else begin
    p_Time:=copy(p_Time,n+1,length(p_Time));
    result:=1000*StrToInt(p_Time);
  end;
end;
//==============================================================================
function TimeSecToMinSec(Sec: integer): string;
begin
  result := IntToStr(Sec div 60);
  if Sec mod 60 <> 0 then
    result := result + ':' + IntToStr(Sec mod 60);
end;
//==============================================================================
function MultiKeyExists: Boolean;
var
  F: Text;
  s, filename: string;
  i, sum: integer;
begin
  result := false;
  try
    filename := GetCurrentDir + '\multikey.ini';
    if not FileExists(filename) then exit;

    AssignFile(F,filename);
    Reset(F);
    Readln(F, s);
    if length(s) <> 7 then exit;
    sum := 0;
    for i := 1 to length(s) do
      sum := sum + StrToInt(s[i]);
    result := sum = 30; 
  except
  end;
end;
//==============================================================================
function AgeByBirthday(Birthday: TDateTime): string;
var
  y1, m1, d1, y2, m2, d2, n: word;
begin
  if Birthday = 0 then result := ''
  else begin
    DecodeDate(Birthday, y1, m1, d1);
    DecodeDate(Date, y2, m2, d2);
    if y2 = y1 then result := '0'
    else begin
      n := y2 - y1 - 1;
      if (m2 > m1) or (m2 = m1) and (d2 >= d1) then
        inc(n);
      result := IntToStr(n);
    end;
  end;
end;
//==============================================================================
function GetOptionsDate(year, month, day: word): TDateTime;
begin
  try
    result := EncodeDate(year, month, day)
  except
    result := 0
  end;
end;
//==============================================================================
{function Str2EventType(Str: string): TCSEventType;
var
  i: integer;
begin
  result:=TCSEventType(0);
  for i:=Low(EVT_STRINGS) to High(EVT_STRINGS) do
    if EVT_STRINGS[i]=Str then begin
      result:=TCSEventType(i);
      exit;
    end;
end;}
//==========================================================================
function RGB(R,G,B: byte): TColor;
begin
  result := B * 256 * 256 + G * 256 + R;
end;
//==========================================================================
function PointInRect(R: TRect; X,Y: integer): Boolean;
begin
  result := (X >= R.Left) and (X <= R.Right) and (Y >= R.Top) and (Y <= R.Bottom);
end;
//==========================================================================
procedure DrawFrame(cnv: TCanvas; p_Rect: TRect; p_Color: TColor; p_Width, p_CornerShift: integer);
var
  r, l, t, b: integer;
begin
  r := p_Rect.right - p_Width div 2;
  t := p_Rect.top;
  l := p_Rect.left;
  b := p_Rect.bottom - p_Width div 2;

  if (p_CornerShift * 2 >= b - t) or (p_CornerShift * 2 >= r - l) then
    p_CornerShift := 0;

  cnv.Pen.Color := p_Color;
  cnv.Pen.Width := p_Width;

  cnv.MoveTo(l, t + p_CornerShift);
  cnv.LineTo(l, b - p_CornerShift);
  cnv.LineTo(l + p_CornerShift, b);
  cnv.LineTo(r - p_CornerShift, b);
  cnv.LineTo(r, b - p_CornerShift);
  cnv.LineTo(r, t + p_CornerShift);
  cnv.LineTo(r - p_CornerShift, t);
  cnv.LineTo(l + p_CornerShift, t);
  cnv.LineTo(l, t + p_CornerShift);
end;
//==========================================================================
procedure DrawFilledFrame(cnv: TCanvas; p_Rect: TRect; p_Color, p_FillColor: TColor; p_Width, p_CornerShift: integer);
var
  r, l, t, b: integer;
begin
  r := p_Rect.right - p_Width div 2;
  t := p_Rect.top;
  l := p_Rect.left;
  b := p_Rect.bottom - p_Width div 2;

  if (p_CornerShift * 2 >= b - t) or (p_CornerShift * 2 >= r - l) then
    p_CornerShift := 0;

  cnv.Pen.Color := p_Color;
  cnv.Pen.Width := p_Width;
  cnv.Brush.Color := p_FillColor;

  cnv.Polygon([
    Point(l, t + p_CornerShift),
    Point(l, b - p_CornerShift),
    Point(l + p_CornerShift, b),
    Point(r - p_CornerShift, b),
    Point(r, b - p_CornerShift),
    Point(r, t + p_CornerShift),
    Point(r - p_CornerShift, t),
    Point(l + p_CornerShift, t),
    Point(l, t + p_CornerShift)
  ]);
end;
//==========================================================================
procedure DrawFilledFrameWithCorners(cnv: TCanvas; p_Rect: TRect; p_Color, p_FillColor: TColor;
  p_Width, p_CornerShift: integer; p_CornersColor: TColor);
var
  shift: integer;
begin
  cnv.Brush.Color := clRed;
  cnv.Pen.Color := clRed;
  cnv.FillRect(p_Rect);
  DrawFilledFrame(cnv, p_Rect, p_Color, p_FillColor, p_Width, p_CornerShift);

  if p_CornerShift = 0 then exit
  else if p_CornerShift = 1 then begin
    cnv.Pixels[p_Rect.Left,p_Rect.Top] := p_CornersColor;
    cnv.Pixels[p_Rect.Left,p_Rect.Bottom] := p_CornersColor;
    cnv.Pixels[p_Rect.Right,p_Rect.Top] := p_CornersColor;
    cnv.Pixels[p_Rect.Right,p_Rect.Bottom] := p_CornersColor;
  end else begin
    cnv.Brush.Color := p_CornersColor;
    cnv.Pen.Color := p_CornersColor;
    cnv.Pen.Width := 1;
    shift := p_CornerShift - 1 - p_Width div 2;
    cnv.Polygon([
      Point(p_Rect.Left, p_Rect.Top),
      Point(p_Rect.Left + shift, p_Rect.Top),
      Point(p_Rect.Left, p_Rect.Top + shift),
      Point(p_Rect.Left, p_Rect.Top)]);
    cnv.Polygon([
      Point(p_Rect.Right, p_Rect.Top),
      Point(p_Rect.Right - shift, p_Rect.Top),
      Point(p_Rect.Right, p_Rect.Top + shift),
      Point(p_Rect.Right, p_Rect.Top)]);
    cnv.Polygon([
      Point(p_Rect.Left, p_Rect.Bottom),
      Point(p_Rect.Left + shift, p_Rect.Bottom),
      Point(p_Rect.Left, p_Rect.Bottom - shift),
      Point(p_Rect.Left, p_Rect.Bottom)]);
    cnv.Polygon([
      Point(p_Rect.Right, p_Rect.Bottom),
      Point(p_Rect.Right - shift, p_Rect.Bottom),
      Point(p_Rect.Right, p_Rect.Bottom - shift),
      Point(p_Rect.Right, p_Rect.Bottom)]);
  end;
end;
//==========================================================================
procedure DrawProgressIndicator(cnv: TCanvas; R: TRect; Text: string;
  Progress, MaxCount: integer; Options: TProgressIndicatorOptions);
var
  greenWidth, n, ProgressLeft, TextLeft: integer;
  RGreen: TRect;
  bmpPI: Graphics.TBitMap;
  sProgress, s: string;
  //************************************************************************
  function GetText(p_Width: integer): string;
  var
    i: integer;
  begin
    if TextWidth(cnv, Text, Options.FontSize, Options.FontStyle) <= p_Width then
      result := Text
    else begin
      i := length(Text) - 2;
      repeat
        result := copy(Text, 1, i) + '...';
        if TextWidth(cnv, result, Options.FontSize, Options.FontStyle) <= p_Width then
          exit;
        dec(i);
      until i <= 0;
      result := copy(Text, 1, 1) + '...';
    end;
  end;
  //************************************************************************
  procedure DrawPIOne(Canvas: TCanvas; Color: TColor; R: TRect; Progress, MaxCount: integer);
  var
    w, h, ProgressLeft: integer;
  begin
    Canvas.Brush.Color := Options.BackgroundColor;
    Canvas.FillRect(R);
    DrawFilledFrame(Canvas, R, Options.EdgeColor, Color, 1, Options.CornerShift);
    sProgress := Format('%d / %d', [Progress,MaxCount]);
    if Text = '' then
      TextOutCenter(Canvas, R, sProgress, Options.TextColor, 12, [fsBold])
    else begin
      cnv.Font.Size := Options.FontSize;
      cnv.Font.Style := Options.FontStyle;
      w := cnv.TextWidth(sProgress);
      h := cnv.TextHeight(sProgress);
      ProgressLeft := R.Right - w - Options.BorderWidth - 2;
      TextOut(Canvas, ProgressLeft, R.Top + (R.Bottom - R.Top - h) div 2 + 1,
        sProgress, Options.TextColor, Options.FontSize, Options.FontStyle);

      TextLeft := R.Left + 8;
      s := GetText(ProgressLeft - TextLeft - 10);
      TextOut(Canvas, TextLeft, R.Top + (R.Bottom - R.Top - h) div 2 + 1,
        s, Options.TextColor, Options.FontSize, Options.FontStyle);
    end;
  end;
  //************************************************************************
begin
  if Options.ShadowShift > 0 then begin
    cnv.Brush.Color := Options.ShadowColor;
    n := Options.ShadowShift;
    DrawFilledFrame(cnv, Rect(R.left + n, R.top + n, R.Right + n, R.Bottom + n),
      Options.ShadowColor, Options.ShadowColor, 1, Options.CornerShift);
  end;

  bmpPI := Graphics.TBitMap.Create;
  bmpPI.Width := R.Right - R.Left + 1;
  bmpPI.Height := R.Bottom - R.Top + 1;
  bmpPI.Canvas.Font.Name := cnv.Font.Name;
  RGreen := Rect(0,0,R.Right - R.Left,R.Bottom - R.Top);
  DrawPIOne(bmpPI.Canvas, Options.GreenColor, RGreen, Progress, MaxCount);
  DrawPIOne(cnv, Options.EmptyColor, R, Progress, MaxCount);
  greenWidth := Round(Progress * 1.0 * (R.Right - R.Left) / MaxCount);

  cnv.CopyRect(Rect(R.Left,R.Top,R.Left + greenWidth, R.Bottom), bmpPI.Canvas,
    Rect(0,0,greenWidth,R.Bottom-R.Top));
  bmpPI.Free;
end;
//==========================================================================
{ TProgressIndicatorOptions }

constructor TProgressIndicatorOptions.Create;
begin
  CornerShift := 3;
  FontSize := 12;
  FontStyle := [fsBold];
end;
//==========================================================================
function IncRect(R: TRect; X, Y: integer): TRect;
begin
  result := Rect(R.Left + X, R.Top + Y, R.Right + X, R.Bottom + Y);
end;
//==========================================================================
function ZoomRect(R: TRect; X, Y: integer): TRect;
begin
  result := Rect(R.Left + X, R.Top + Y, R.Right - X, R.Bottom - Y);
end;
//==========================================================================
function RemoveControlSymbols(Str: string): string;
var
  i: integer;
begin
  result := '';
  for i := 1 to length(Str) do
    if ord(Str[i]) >= 32 then
      result := result + Str[i];
end;
//==========================================================================
function Sign(N: integer): integer;
begin
  if N < 0 then result := -1
  else if N > 0 then result := 1
  else result := 0;
end;
//==========================================================================
function Date2Str(dt: TDateTime): string;
var
  day, month, year, d, m, y: word;
begin
  DecodeDate(dt, year, month, day);
  DecodeDate(Date, y, m, d);
  if year = y then result := Format('%s %d', [Months[month], day])
  else result := Format('%s %d, %d', [MonthsShort[month], day, year]);
end;
//==========================================================================
procedure GetDateDiff(Date1, Date2: TDateTime; var pp_Days, pp_Hours, pp_Minutes: integer);
var
  diff: real;
begin
  diff := abs(Date2 - Date1);
  pp_Days := trunc(diff);
  diff := (diff - pp_Days) * 24;
  pp_Hours := trunc(diff);
  diff := (diff - pp_Hours) * 60;
  pp_Minutes := trunc(diff);
end;
//==========================================================================
function GetTimeAgo(p_Date: TDateTime): string;
var
  days, hours, minutes: integer;
begin
  result := '';
  GetDateDiff(fCLMain.ServerTime, p_Date, days, hours, minutes);
  if days <> 0 then result := result + IntToStr(days) + ' days ';
  if (days <> 0) or (hours <> 0) then result := result + IntToStr(hours) + ' hours ';
  result := result + IntToStr(minutes) + ' minutes';
end;
//==========================================================================
function IsRightNumber(p_Str: string): Boolean;
begin
  try
    StrToFloat(p_Str);
    result := true;
  except
    result := false;
  end;
end;
//==========================================================================
function InCommaString(CommaString, part: string): Boolean;
begin
  result := pos(','+part+',',','+CommaString+',') > 0;
end;
//==========================================================================
function InCommaString(CommaString: string; part: integer): Boolean; overload;
begin
  result := InCommaString(CommaString, IntToStr(part));
end;
//==========================================================================
function MembershipType2FontStyle(p_MT: TMembershipType): TFontStyles;
begin
  case p_MT of
    mmbNone, mmbEmployee, mmbVIP: result := [];
    mmbTrial: result := [fsItalic];
    mmbPaid: result := [fsBold];
    mmbOldMember: result := [];
  else
    result := [];
  end;
end;
//==========================================================================
function ColorByRatedType(p_RatedType: TRatedType): TColor;
begin
  case p_RatedType of
    rtStandard: result := fGL.SeekStandardColor;
       rtBlitz: result := fGL.SeekBlitzColor;
      rtBullet: result := fGL.SeekBulletColor;
       rtCrazy: result := fGL.SeekCrazyColor;
     rtFischer: result := fGL.SeekFisherColor;
       rtLoser: result := fGL.SeekLoosersColor;
  end;
end;
//==========================================================================
procedure CopyPopupMenu(p_Source, p_Dest: TPopupMenu);
var
  itmFrom, itmTo: TMenuItem;
  i: integer;
  //************************************************************************
  procedure CopySubitems(p_ItemFrom, p_ItemTo: TMenuItem);
  var
    itmFrom, itmTo: TMenuItem;
  var
    i: integer;
  begin
    for i := 0 to p_ItemFrom.Count - 1 do begin
      itmFrom := p_ItemFrom.Items[i];
      itmTo := TMenuItem.Create(p_Dest);
      itmTo.Caption := itmFrom.Caption;
      itmTo.Tag := itmFrom.Tag;
      itmTo.Enabled := itmFrom.Enabled;
      itmTo.OnClick := itmFrom.OnClick;
      p_ItemTo.Add(itmTo);
      CopySubItems(itmFrom, itmTo);
    end;
  end;
  //************************************************************************
begin
  p_Dest.OnPopup := p_Source.OnPopup;
  p_Dest.Items.Clear;
  for i := 0 to p_Source.Items.Count - 1 do begin
    itmFrom := p_Source.Items[i];
    itmTo := TMenuItem.Create(p_Dest);
    itmTo.Caption := itmFrom.Caption;
    itmTo.Tag := itmFrom.Tag;
    itmTo.Enabled := itmFrom.Enabled;
    itmTo.OnClick := itmFrom.OnClick;
    p_Dest.Items.Add(itmTo);
    CopySubitems(itmFrom, itmTo);
  end;
end;
//==========================================================================
function GetAutoUpdateExe: string;
var
  sr: TSearchRec;
  n: integer;
  version, maxversion: string;
begin
  result := '';
  maxversion := CLIENT_VERSION;
  n := FindFirst(MAIN_DIR + 'upd*.exe', faAnyFile, sr);
  while n = 0 do begin
    version := copy(sr.Name, 4, 5);
    if version <= maxversion then
      SysUtils.DeleteFile(MAIN_DIR + sr.Name)
    else begin
      maxversion := version;
      result := sr.Name;
    end;
    n := FindNext(sr);
  end;
end;
//==========================================================================
procedure DeleteAutoUpdates;
var
  sr: TSearchRec;
  n: integer;
begin
  n := FindFirst(MAIN_DIR + 'upd*.exe', faAnyFile, sr);
  while n = 0 do begin
    SysUtils.DeleteFile(MAIN_DIR + sr.Name);
    n := FindNext(sr);
  end;
end;
//==========================================================================
function CreateProcessSimple(sExecutableFilePath: string): string;
var
  pi: TProcessInformation;
  si: TStartupInfo;
begin
  FillMemory( @si, sizeof( si ), 0 );
  si.cb := sizeof( si );

  CreateProcess(
    Nil,
    PChar( sExecutableFilePath ),
    Nil, Nil, False,
    NORMAL_PRIORITY_CLASS, Nil, Nil,
    si, pi );

  CloseHandle( pi.hProcess );
  CloseHandle( pi.hThread );
end;
//==========================================================================
end.


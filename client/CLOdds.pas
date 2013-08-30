unit CLOdds;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ComCtrls, Buttons, StdCtrls, ExtCtrls, Menus, jpeg;

type
  TfCLOdds = class(TForm)
    lv: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    edRating: TEdit;
    edInitTime: TEdit;
    edIncTime: TEdit;
    sbAdd: TSpeedButton;
    udIncTime: TUpDown;
    udInitTime: TUpDown;
    udRating: TUpDown;
    Panel3: TPanel;
    SpeedButton2: TSpeedButton;
    Panel4: TPanel;
    SpeedButton3: TSpeedButton;
    cbInitTime: TCheckBox;
    cbIncTime: TCheckBox;
    Panel5: TPanel;
    SpeedButton1: TSpeedButton;
    img: TImage;
    sbDelete: TSpeedButton;
    Panel6: TPanel;
    SpeedButton4: TSpeedButton;
    Panel7: TPanel;
    SpeedButton5: TSpeedButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    sbDimension: TSpeedButton;
    procedure sbAddClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure cbInitTimeClick(Sender: TObject);
    procedure cbIncTimeClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvClick(Sender: TObject);
    procedure imgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lvKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbDeleteClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure sbDimensionClick(Sender: TObject);
  private
    { Private declarations }
    Changed: Boolean;
    OldLV: TListView;
    curPieces: string;
    procedure TakeCurItemData;
    function FindInLV(Rating: integer; var index: integer): Boolean;
    procedure MakeCaptions;
    procedure ClearLV;
    procedure DrawBoard(pieces: string);
    function GetPiecesDesc(pieces: string): string;
    procedure SaveOdds(FileName: string);
    procedure LoadOdds(FileName: string);
  public
    { Public declarations }
    procedure AddToLV(Rating,InitTime,IncTime: integer; Pieces,Dimension: string);
  end;

var
  fCLOdds: TfCLOdds;

implementation

uses CLLib,CLGlobal,CLMain,CLConst;

const
  COL_R = 3;

{$R *.DFM}
//====================================================================
procedure TfCLOdds.AddToLV(Rating, InitTime, IncTime: integer;
  Pieces,Dimension: string);
var
  i,index: integer;
  exact: Boolean;
  itm: TListItem;
  s: string;
begin
  exact:=FindInLV(Rating,index);
  if exact then itm:=lv.Items[index]
  else begin
    itm:=lv.Items.Insert(index);
    for i:=2 to lv.Columns.Count do
      itm.SubItems.Add('');
  end;
  if Dimension='M' then s:=''
  else s:='s';
  //itm.Caption:=IntToStr(Rating);
  itm.SubItems[0]:=BoolTo_(InitTime<>-1,IntToStr(InitTime),'')+s;
  itm.SubItems[1]:=BoolTo_(IncTime<>-1,IntToStr(IncTime),'');
  itm.SubItems[2]:=Pieces;
  itm.SubItems[3]:=IntToStr(Rating);
  itm.SubItems[4]:=GetPiecesDesc(Pieces);
  MakeCaptions;
end;
//====================================================================
function TfCLOdds.FindInLV(Rating: integer; var index: integer): Boolean;
var
  i,r: integer;
  itm: TListItem;
begin
  for i:=0 to lv.Items.Count-1 do begin
    itm:=lv.Items[i];
    r:=StrToInt(itm.SubItems[COL_R]);
    if Rating>=r then begin
      result:=Rating=r;
      index:=i;
      exit;
    end;
  end;
  index:=lv.Items.Count;
  result:=false;
end;
//====================================================================
procedure TfCLOdds.sbAddClick(Sender: TObject);
var
  InitTime: string;
begin
  AddToLV(udRating.Position,
    BoolTo_(cbInitTime.Checked,udInitTime.Position,-1),
    BoolTo_(cbIncTime.Checked,udIncTime.Position,-1),
    curPieces,sbDimension.Caption);
  Changed:=true;
end;
//====================================================================
procedure TfCLOdds.SpeedButton3Click(Sender: TObject);
begin
  if Changed then begin
    if MessageDlg('Are you sure you want to discard changes?',
      mtWarning,[mbYes,mbNo],0)=mrYes
    then begin
      CopyListViewItems(OldLV.Items,lv.Items);
      Changed:=false;
      ModalResult:=mrCancel;
    end;
  end else
    ModalResult:=mrCancel;
end;
//====================================================================
procedure TfCLOdds.cbInitTimeClick(Sender: TObject);
begin
  edInitTime.Enabled:=cbInitTime.Checked;
  udInitTime.Enabled:=cbInitTime.Checked;
end;
//====================================================================
procedure TfCLOdds.cbIncTimeClick(Sender: TObject);
begin
  edIncTime.Enabled:=cbIncTime.Checked;
  udIncTime.Enabled:=cbIncTime.Checked;
end;
//====================================================================
procedure TfCLOdds.MakeCaptions;
var
  i,prev: integer;
  itm: TListItem;
begin
  prev:=0;
  for i:=lv.Items.Count-1 downto 0 do begin
    itm:=lv.Items[i];
    itm.Caption:=IntToStr(prev+1)+'-'+itm.SubItems[COL_R];
    prev:=StrToInt(itm.SubItems[COL_R]);
  end;
end;
//====================================================================
procedure TfCLOdds.SpeedButton1Click(Sender: TObject);
begin
  ClearLV;
end;
//====================================================================
procedure TfCLOdds.ClearLV;
begin
  if MessageDlg('Are you sure you want to clear odds list?',
    mtWarning,[mbYes,mbNo],0)=mrYes
  then begin
    lv.Items.Clear;
    Changed:=true;
  end;
end;
//====================================================================
procedure TfCLOdds.SpeedButton2Click(Sender: TObject);
begin
  if Changed then CopyListViewItems(lv.Items,OldLV.Items);
  Changed:=false;
  ModalResult:=mrOk;
end;
//====================================================================
procedure TfCLOdds.FormCreate(Sender: TObject);
var
  itm: TListItem;
begin
  OldLV:=TListView.Create(Self);
  OldLV.Visible:=false;
  OldLV.Parent:=Self;
  {AddToLV(2700,5,30,'Pf');
  AddToLV(1800,3,30,'Nb');
  AddToLV(1700,2,20,'Ra');
  AddToLV(1500,2,10,'Qd');}
  MakeCaptions;

  CopyListViewItems(lv.Items,OldLV.Items);
end;
//====================================================================
procedure TfCLOdds.FormDestroy(Sender: TObject);
begin
  OldLV.Free;
end;
//====================================================================
function GetPieceLetter(Row,Col: integer): char;
begin
  if Row = 2 then result:='P'
  else
    case Col of
      1,8: result:='R';
      2,7: result:='N';
      3,6: result:='B';
        4: result:='Q';
        5: result:='K';
    end;
end;
//====================================================================
procedure TfCLOdds.DrawBoard(pieces: string);
var
  bmp: TBitMap;
  i,j,size: integer;
  pc,col: char;
begin
  size:=25;
  with img.{Picture.Bitmap.}Canvas do begin
    Rectangle(0,0,img.Width,img.Height);
    for i:=0 to 7 do
      for j:=0 to 1 do begin
        if (i+j) mod 2 = 1 then Brush.Color:=fGL.DarkSquare
        else Brush.Color:=fGL.LightSquare;

        FillRect(Rect(i*size+1,j*size+1,i*size+size,j*size+size));
      end;
    for i:=1 to 7 do begin
      MoveTo(i*size,0);
      LineTo(i*size,img.Height);
    end;
    MoveTo(0,img.Height div 2);
    LineTo(img.Width,img.Height div 2);

    bmp:=TBitMap.Create;
    bmp.Height:=21; bmp.Width:=21;
    for i:=0 to 7 do
      for j:=0 to 1 do begin
        pc:=GetPieceLetter(2-j,i+1);
        col:=chr(ord('a')+i);
        if pos(pc+col,pieces)=0 then begin
          GetLittlePieceImage(pc,bmp);
          if (i+j) mod 2 = 1 then bmp.Canvas.Brush.Color:=fGL.DarkSquare
          else bmp.Canvas.Brush.Color:=fGL.LightSquare;
          bmp.Canvas.FloodFill(1,1,bmp.Canvas.Pixels[1,1],fsSurface);

          img.Canvas.CopyRect(Rect(i*size+2,j*size+2,i*size+22,j*size+22),bmp.Canvas,Rect(0,0,20,20));
        end;
      end;
    bmp.Free;
  end;
end;
//====================================================================
procedure TfCLOdds.FormShow(Sender: TObject);
begin
  DrawBoard(curPieces);
end;
//====================================================================
procedure TfCLOdds.TakeCurItemData;
var
  itm: TListItem;
  s: string;
begin
  itm:=lv.Selected;
  if itm=nil then exit;
  udRating.Position := StrToInt(itm.SubItems[3]);
  cbInitTime.Checked := itm.SubItems[0]<>'';
  if cbInitTime.Checked then begin
    s:=itm.SubItems[0];
    if pos('s',s)=0 then begin
      udInitTime.Position := StrToInt(s);
      sbDimension.Caption:='M';
    end else begin
      udInitTime.Position:=StrToInt(copy(s,1,length(s)-1));
      sbDimension.Caption:='S';
    end;
  end;
  cbIncTime.Checked := itm.SubItems[1]<>'';
  if cbIncTime.Checked then
    udIncTime.Position := StrToInt(itm.SubItems[1]);
  curPieces := itm.SubItems[2];
  DrawBoard(curPieces);
end;
//====================================================================
procedure TfCLOdds.lvClick(Sender: TObject);
begin
  TakeCurItemData;
end;
//====================================================================
procedure TfCLOdds.imgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  n,row,col,size: integer;
  s: string;
begin
  size:=img.Height div 2;
  if Y>size then row:=1
  else row:=2;
  col:=X div size+1;

  s:=GetPieceLetter(row,col)+chr(ord('a')+col-1);
  if s='Ke' then exit;
  n:=pos(s,curPieces);
  if n=0 then curPieces:=curPieces+s
  else curPieces:=copy(curPieces,1,n-1)+copy(curPieces,n+2,length(curPieces));
  DrawBoard(curPieces);
end;
//====================================================================
procedure TfCLOdds.lvKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  TakeCurItemData;
end;
//====================================================================
function TfCLOdds.GetPiecesDesc(pieces: string): string;
var
  i: integer;
  s: string;
begin
  result:='';
  for i:=1 to length(pieces) div 2 do begin
    case pieces[i*2-1] of
      'P': s:='Pawn';
      'N': s:='Knight';
      'B': s:='Bishop';
      'R': s:='Rook';
      'Q': s:='Queen';
      'K': s:='King';
    end;
    result:=result+s+' ('+pieces[i*2]+') ';
  end;
end;
//====================================================================
procedure TfCLOdds.sbDeleteClick(Sender: TObject);
begin
  if lv.Selected=nil then exit;
  lv.Items.Delete(lv.Items.IndexOf(lv.Selected));
  TakeCurItemData;
  MakeCaptions;
end;
//====================================================================
procedure TfCLOdds.SpeedButton4Click(Sender: TObject);
begin
  SaveDialog1.InitialDir:=MAIN_DIR;
  if SaveDialog1.Execute then
    SaveOdds(SaveDialog1.FileName);
end;
//====================================================================
procedure TfCLOdds.SaveOdds(FileName: string);
var
  F: TextFile;
  i: integer;
  itm: TListItem;
begin
  AssignFile(F,FileName);
  if FileExists(FileName) then
    if MessageDlg('This file already exists. Overwrite?',mtConfirmation,
      [mbYes,mbNo],0) = mrNo
    then
      exit;
  Rewrite(F);
  for i:=lv.Items.Count-1 downto 0 do begin
    itm:=lv.Items[i];
    writeln(F,Format('%s,%s,%s,%s',
      [itm.SubItems[3],itm.SubItems[0],itm.SubItems[1],itm.SubItems[2]]));
  end;
  CloseFile(F);
end;
//====================================================================
procedure TfCLOdds.SpeedButton5Click(Sender: TObject);
begin
  OpenDialog1.InitialDir:=MAIN_DIR;
  if OpenDialog1.Execute then
    LoadOdds(OpenDialog1.FileName);
end;
//====================================================================
procedure TfCLOdds.LoadOdds(FileName: string);
var
  F: TextFile;
  s,Pieces,sInitTime,Dim: string;
  sl: TStringList;
  i,Rating,InitTime,IncTime: integer;
begin
  AssignFile(F,FileName);
  try
    Reset(F);
  except
    on E:Exception do
      MessageDlg('Cannot open file: '+E.Message,mtError,[mbOk],0);
  end;
  sl:=TStringList.Create;

  try
    try
      lv.Items.Clear;
      while not eof(F) do begin
        readln(F,s);
        sl.CommaText:=s;
        for i:=sl.Count-1 to 3 do
          sl.Add('');
        Rating:=StrToInt(sl[0]);

        sInitTime:=sl[1];
        if sInitTime='' then begin
          Dim:='M';
          InitTime:=-1;
        end else if pos('s',sInitTime)=0 then begin
          Dim:='M';
          InitTime:=StrToInt(sInitTime);
        end else begin
          Dim:='S';
          InitTime:=StrToInt(copy(sInitTime,1,length(sInitTime)-1));
        end;

        if sl[2]='' then IncTime:=-1
        else IncTime:=StrToInt(sl[2]);

        Pieces:=sl[3];
        AddToLV(Rating,InitTime,IncTime,Pieces,Dim);
      end;
    except
      on E: Exception do
        MessageDlg('Error loading odds: '+E.Message,mtError,[mbOk],0);
    end;
  finally
    sl.Free;
    CloseFile(F);
  end;
end;
//====================================================================
procedure TfCLOdds.sbDimensionClick(Sender: TObject);
begin
  if sbDimension.Caption='M' then sbDimension.Caption:='S'
  else sbDimension.Caption:='M';
end;
//====================================================================
end.

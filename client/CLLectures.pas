{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLLectures;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, CLLecture, CLEvents, Menus;

type
  TfCLLectures = class(TForm)
    lvLectures: TListView;
    pmLectures: TPopupMenu;
    miJoin: TMenuItem;
    miStart: TMenuItem;
    miDelete: TMenuItem;
    miLeave: TMenuItem;
    miEdit: TMenuItem;
    miFinish: TMenuItem;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    pnlHeader: TPanel;
    procedure miJoinClick(Sender: TObject);
    procedure miStartClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure miLeaveClick(Sender: TObject);
    procedure lvLecturesDblClick(Sender: TObject);
    procedure pmLecturesPopup(Sender: TObject);
    procedure miEditClick(Sender: TObject);
    procedure lvLecturesDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
    procedure miFinishClick(Sender: TObject);
    procedure lvLecturesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
  private
    { Private declarations }
    procedure ArrangeButtons;
  public
    { Public declarations }
    function FindLectureIndex(id: integer): integer;
    function FindLecture(id: integer): TCSLecture;
    function UpdateLecture(EV: TCSEvent): integer;
  end;

var
  fCLLectures: TfCLLectures;

implementation

{$R *.DFM}

uses CLMain, CLLib, CLSocket, CLConst, CLLectureNew;

//==========================================================================
function TfCLLectures.FindLecture(id: integer): TCSLecture;
var
  index: integer;
begin
  index:=FindLectureIndex(id);
  if index=-1 then result:=nil
  else result:=TCSLecture(lvLectures.Items[index].Data);
end;
//==========================================================================
function TfCLLectures.FindLectureIndex(id: integer): integer;
var
  i: integer;
  ev: TCSLecture;
begin
  for i:=0 to lvLectures.Items.Count-1 do begin
    ev:=TCSLecture(lvLectures.Items[i].Data);
    if ev.ID=id then begin
      result:=i;
      exit;
    end;
  end;
  result:=-1;
end;
//==========================================================================
function TfCLLectures.UpdateLecture(EV: TCSEvent): integer;
var
  i,index: integer;
  item: TListItem;
begin
  index:=FindLectureIndex(EV.ID);
  if index = -1 then item:=lvLectures.Items.Add
  else item:=lvLectures.Items[index];

  item.Caption:=IntToStr(EV.id);
  for i:=item.SubItems.Count to 6 do
    item.SubItems.Add('');
  item.SubItems[0]:=EV.Name;
  item.SubItems[1]:= EV.StatusStr;
  item.SubItems[2]:=Format('%d',[EV.CountJoined]);
  item.SubItems[3]:=DateTimeToStr(EV.StartTime);
  item.SubItems[4]:=EV.Leaders.CommaText;
  item.SubItems[5]:=EventType2Str(EV.Type_);
  item.SubItems[6]:=EV.Description;
  item.Data:=EV;
  result:=index;
  //if pnlInfo.Tag=EV.ID then DisplayInfo(EV);
end;
//==========================================================================
procedure TfCLLectures.miJoinClick(Sender: TObject);
begin
  if lvLectures.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_JOIN + #32 + lvLectures.Selected.Caption]);
end;
//==========================================================================
procedure TfCLLectures.miStartClick(Sender: TObject);
begin
  if lvLectures.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_START + #32 + lvLectures.Selected.Caption]);
end;
//==========================================================================
procedure TfCLLectures.miDeleteClick(Sender: TObject);
begin
  if lvLectures.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_DELETE + #32 + lvLectures.Selected.Caption]);
end;
//==========================================================================
procedure TfCLLectures.miLeaveClick(Sender: TObject);
begin
  if lvLectures.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_LEAVE,lvLectures.Selected.Caption]);
end;
//==========================================================================
procedure TfCLLectures.lvLecturesDblClick(Sender: TObject);
begin
  miJoin.Click;
end;
//==========================================================================
procedure TfCLLectures.pmLecturesPopup(Sender: TObject);
var
  ev: TCSEvent;
begin
  if lvLectures.Selected = nil then begin
    miJoin.Visible := false;
    miLeave.Visible := false;
    miFinish.Visible := false;
  end else begin
    ev := TCSEvent(lvLectures.Selected.Data);
    miFinish.Visible := ((fCLSocket.MyAdminLevel > 0) or ev.IAmLeader) and (ev.Status = estStarted);
    miJoin.Visible := (ev.Status <> estFinished) and (ev.State = eusNone);
    miLeave.Visible := not miJoin.Visible;
  end;
  miStart.Visible := fCLMain.tbLectureStart.Visible;
  miDelete.Visible := fCLMain.tbLectureDelete.Visible;
  miEdit.Visible := fCLMain.tbLectureEdit.Visible;
end;
//==========================================================================
procedure TfCLLectures.miEditClick(Sender: TObject);
var
  F: TfCLLectureNew;
  ev: TCSEvent;
begin
  if lvLectures.Selected = nil then exit;

  ev:=TCSEvent(lvLectures.Selected.Data);
  F:=TfCLLectureNew.Create(Application);
  F.Init(ev);
  if F.ShowModal=mrOk then
    fCLMain.SendLectureCreate(F);
  F.Free;
end;
//==========================================================================
procedure TfCLLectures.lvLecturesDrawItem(Sender: TCustomListView;
  Item: TListItem; Rect: TRect; State: TOwnerDrawState);
var
  i,n: integer;
  txt: string;
  ev: TCSEvent;
  lv: TListView;
  IsLecturerColumn: Boolean;
begin
  lv := lvLectures;
  n:=Rect.Left;
  if lv.Selected = Item then begin
    lv.Canvas.Brush.Color := clBlue;
    lv.Canvas.FillRect(Rect);//(Rect.Left+2,Rect.Top+2,Rect.Right-2,Rect.Bottom-2);
    lv.Canvas.Font.Color := clWhite;
  end else begin
    lv.Canvas.Brush.Color := lv.Color;
    lv.Canvas.FillRect(Rect);
    //lv.Canvas.Rectangle(Rect.Left+2,Rect.Top+2,Rect.Right-2,Rect.Bottom-2);
    lv.Canvas.Font.Color := clBlack;
  end;

  for i:=0 to lv.Columns.Count-1 do begin
    if i=0 then txt:=Item.Caption
    else txt:=Item.SubItems[i-1];

    ev := TCSEvent(Item.Data);

    IsLecturerColumn := lvLectures.Columns[i].Caption = 'Lecturer';
    if (ev.State <> eusNone) or (ev.CountLeader > 0) and IsLecturerColumn then
      lv.Canvas.Font.Style := [fsBold]
    else
      lv.Canvas.Font.Style := [];

    if lv.Selected = Item then lv.Canvas.Font.Color := clWhite
    else if (ev.CountLeader > 0) and IsLecturerColumn then
      lv.Canvas.Font.Color := clBlue
    else
      lv.Canvas.Font.Color := clBlack;
    {if cl.id = fCLSocket.ClubId then
      lv.Canvas.Font.Style := [fsBold]
    else
      lv.Canvas.Font.Style := [];}

    lv.Canvas.FillRect(Classes.Rect(n,Rect.Top,n+lvLectures.Columns[i].Width,Rect.Bottom));

    lv.Canvas.TextOut(n+4,Rect.Top,Txt);
    n:=n+lv.Columns[i].Width;
  end;
end;
//==========================================================================
procedure TfCLLectures.miFinishClick(Sender: TObject);
begin
  if lvLectures.Selected <> nil then
    fCLSocket.InitialSend([CMD_STR_EVENT_FINISH + #32 + lvLectures.Selected.Caption]);
end;
//==========================================================================
procedure TfCLLectures.ArrangeButtons;
var
  b: Boolean;
  ev: TCSEvent;
begin
  if lvLectures.Selected = nil then b := false
  else begin
    ev := TCSEvent(lvLectures.Selected.Data);
    b := (fCLSocket.MyAdminLevel > 0) or ev.IAmLeader;
  end;
  fCLMain.tbLectureStart.Visible := b;
  fCLMain.tbLectureEdit.Visible := b;
end;
//==========================================================================
procedure TfCLLectures.lvLecturesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  ArrangeButtons;
end;
//==========================================================================
end.

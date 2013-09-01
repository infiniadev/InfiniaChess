{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLClubList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, ExtCtrls, Menus, StdCtrls;

type
  TClubListType = (cltNormal,cltCheckboxes);

  TfCLClubList = class(TForm)
    pnlButtons: TPanel;
    Panel11: TPanel;
    sbOk: TSpeedButton;
    lv: TListView;
    pnlCancel: TPanel;
    SpeedButton3: TSpeedButton;
    pm: TPopupMenu;
    miGoToClub: TMenuItem;
    miJoinClub: TMenuItem;
    miManageClub: TMenuItem;
    miLeaveClub: TMenuItem;
    miInfo: TMenuItem;
    miEditName: TMenuItem;
    miDelete: TMenuItem;
    pnlInfo: TPanel;
    pnlCommon: TPanel;
    lblNum: TLabel;
    lblTitle: TLabel;
    pnlPhoto: TPanel;
    imgPhoto: TImage;
    lblDescription: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure sbOkClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure lvDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
    procedure miManageClubClick(Sender: TObject);
    procedure lvSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miGoToClubClick(Sender: TObject);
    procedure miJoinClubClick(Sender: TObject);
    procedure miLeaveClubClick(Sender: TObject);
    procedure miInfoClick(Sender: TObject);
    procedure miEditNameClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure lvMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlCommonMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    FListType: TClubListType;
    OldX, OldY: integer;
    { Private declarations }
    function CheckedExists: Boolean;
    procedure SetListType(const Value: TClubListType);
    procedure ArrangeMenu;
    function SelectedClub: TObject;
    procedure DisplayInfo(Index: integer);
  public
    { Public declarations }
    function CheckedList: string;
    procedure Init(ClubList: string);
    function ChoosenId: integer;
    property ListType: TClubListType read FListType write SetListType;
    procedure LoadClubs;
    function IDisBusy(ID: integer): Boolean;
  end;


implementation

{$R *.DFM}

uses CSClub, CLSocket, CLGlobal, CLConst, CLClubInfo, CLClubNew, CLMain;

//===========================================================================
function TfCLClubList.CheckedExists: Boolean;
var
  i: integer;
  itm: TListItem;
begin
  result:=true;
  for i:=0 to lv.Items.Count-1 do begin
    itm:=lv.Items[i];
    if itm.Checked then exit;
  end;
  result:=false;
end;
//===========================================================================
function TfCLClubList.CheckedList: string;
var
  i: integer;
  itm: TListItem;
begin
  result:='';
  for i:=0 to lv.Items.Count-1 do begin
    itm:=lv.Items[i];
    if itm.Checked then
      result:=result+itm.Caption+',';
  end;
  SetLength(result,length(result)-1);
end;
//===========================================================================
function TfCLClubList.ChoosenId: integer;
var
  itm: TListItem;
begin
  itm:=lv.Selected;
  if itm = nil then result:=-1
  else result:=StrToInt(itm.Caption);
end;
//===========================================================================
procedure TfCLClubList.FormCreate(Sender: TObject);
begin
  lv.Color := fGL.DefaultBackgroundColor;
  LoadClubs;
end;
//===========================================================================
procedure TfCLClubList.Init(ClubList: string);
var
  i: integer;
  itm: TListItem;
begin
  for i:=0 to lv.Items.Count-1 do begin
    itm:=lv.Items[i];
    itm.Checked := pos(','+itm.Caption+',',','+ClubList+',')>0;
  end;
end;
//===========================================================================
procedure TfCLClubList.sbOkClick(Sender: TObject);
begin
  if ListType = cltCheckBoxes then
    if CheckedExists then ModalResult:=mrOk
    else showmessage('Check at least one club')
  else
    {if lv.Selected = nil then showmessage('Choose one of the clubs first')
    else }ModalResult:=mrOk;
end;
//===========================================================================
procedure TfCLClubList.SetListType(const Value: TClubListType);
begin
  FListType := Value;
  case FListType of
    cltCheckBoxes:
      begin
        lv.CheckBoxes:=true;
        lv.PopupMenu := nil;
        lv.OwnerDraw := false;
      end;
    cltNormal:
      begin
        lv.CheckBoxes:=false;
        lv.PopupMenu := pm;
        lv.OwnerDraw := true;
      end;
  end;
end;
//===========================================================================
procedure TfCLClubList.SpeedButton3Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;
//===========================================================================
procedure TfCLClubList.lvDrawItem(Sender: TCustomListView; Item: TListItem;
  Rect: TRect; State: TOwnerDrawState);
var
  i,n: integer;
  txt: string;
  cl: TClub;
begin
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

    cl := TClub(Item.Data);
    if cl.id = fCLSocket.ClubId then
      lv.Canvas.Font.Style := [fsBold]
    else
      lv.Canvas.Font.Style := [];

    lv.Canvas.TextOut(n+4,Rect.Top,Txt);
    n:=n+lv.Columns[i].Width;                    
  end;
end;
//===========================================================================
procedure TfCLClubList.miManageClubClick(Sender: TObject);
var
  cl: TClub;
  itm: TListItem;
begin
  itm:=lv.Selected;
  if itm = nil then exit;
  cl:=TClub(itm.Data);
  if Assigned(cl.fCLClubMembers) then
    cl.fCLClubMembers.ShowModal
  else
    fCLSocket.InitialSend([CMD_STR_GETCLUBMEMBERS,IntToStr(cl.id)]);
end;
//===========================================================================
procedure TfCLClubList.ArrangeMenu;
var
  itm: TListItem;
  cl: TClub;
begin
  itm:=lv.Selected;
  if itm = nil then begin
    lv.PopupMenu:=nil;
    exit;
  end else
    lv.PopupMenu:=pm;

  cl:=TClub(itm.Data);

  miGoToClub.Visible := cl.CanGoTo;
  miJoinClub.Visible := cl.CanJoin;
  miLeaveClub.Visible := cl.CanLeave;
  miManageClub.Visible := cl.CanManage;
  miEditName.Visible := fCLSocket.MyAdminLevel = 3;
  miDelete.Visible := (fCLSocket.MyAdminLevel = 3) and (cl.id <> 1);

  fCLMain.tbClubEdit.Visible := miManageClub.Visible;
  fCLMain.tbClubEnter.Visible := miGoToClub.Visible;
  fCLMain.tbClubDelete.Visible := miDelete.Visible;
  miInfo.Visible := cl.info <> '';
end;
//===========================================================================
procedure TfCLClubList.lvSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  ArrangeMenu;
end;
//===========================================================================
procedure TfCLClubList.miGoToClubClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_GOTOCLUB,IntToStr(TClub(SelectedClub).id)]);
  ModalResult:=mrOk;
end;
//===========================================================================
function TfCLClubList.SelectedClub: TObject;
var
  itm: TListItem;
begin
  result:=nil;
  itm:=lv.Selected;
  if (itm = nil) or (itm.Data = nil) then exit;
  result:=TClub(itm.Data);
end;
//===========================================================================
procedure TfCLClubList.miJoinClubClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to join club '+TClub(SelectedClub).Name+'?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes
  then
    fCLSocket.InitialSend([CMD_STR_CLUBSTATUS,fCLSocket.MyName,
      IntToStr(TClub(SelectedClub).Id),'1']);
end;
//===========================================================================
procedure TfCLClubList.LoadClubs;
var
  i: integer;
  itm: TListItem;
begin
  lv.Items.Clear;
  for i:=0 to fClubs.Count-1 do begin
    itm:=lv.Items.Add;
    itm.Caption:=IntToStr(fClubs[i].Id);
    itm.SubItems.Add(fClubs[i].Name);
    itm.SubItems.Add(fClubs[i].StatusName);
    itm.Checked := fClubs[i].id = fCLSocket.ClubId;
    itm.Data := fClubs[i];
  end;
end;
//===========================================================================
procedure TfCLClubList.miLeaveClubClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to leave club '+TClub(SelectedClub).Name+'?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes
  then
    fCLSocket.InitialSend([CMD_STR_CLUBSTATUS,fCLSocket.MyName,
      IntToStr(TClub(SelectedClub).Id),'0']);
end;
//===========================================================================
procedure TfCLClubList.miInfoClick(Sender: TObject);
var
  F: TfCLClubInfo;
  cl: TClub;
begin
  cl:=TClub(SelectedClub);
  if cl = nil then exit;
  F:=TfCLClubInfo.Create(Application);
  F.Caption:=cl.name;
  F.reInformation.Color := lv.Color;
  F.reInformation.Lines.Text:=cl.info;
  F.ShowModal;
  F.Free;
end;
//===========================================================================
function TfCLClubList.IDisBusy(ID: integer): Boolean;
var
  i: integer;
  itm: TListItem;
begin
  result := true;
  for i:=0 to lv.Items.Count-1 do begin
    itm := lv.Items[i];
    if StrToInt(itm.Caption) = ID then exit;
  end;
  result := false;
end;
//===========================================================================
procedure TfCLClubList.miEditNameClick(Sender: TObject);
var
  F: TfClubNew;
  itm: TListItem;
begin
  itm:=lv.Selected;
  if itm = nil then exit;

  F := TfClubNew.Create(Application);
  F.chkAuto.Checked := false;
  F.chkAuto.Visible := false;
  F.edId.Enabled := false;
  F.udID.Enabled := false;
  F.udID.Position := StrToInt(itm.Caption);
  F.edName.Text := itm.SubItems[0];
  if F.ShowModal = mrOk then
    fCLSocket.InitialSend([CMD_STR_CLUB, itm.Caption, F.edName.Text]);
  F.Free;
end;
//===========================================================================
procedure TfCLClubList.miDeleteClick(Sender: TObject);
var
  itm: TListItem;
begin
  itm:=lv.Selected;
  if itm = nil then exit;
  if MessageDlg('Are you sure you really want to delete club '+itm.SubItems[0]+'?',mtConfirmation,[mbYes,mbNo],0) = mrNo then
    exit;
  fCLSocket.InitialSend([CMD_STR_CLUB_REMOVE, itm.Caption]);
end;
//===========================================================================
procedure TfCLClubList.DisplayInfo(Index: integer);
var
  cl: TClub;
begin
  cl := TClub(lv.Items[Index].Data);
  lblNum.Caption := '#'+IntToStr(cl.ID);
  lblTitle.Caption := cl.name;
  lblDescription.Caption := cl.info;
  if Assigned(cl.bmpPhoto) then begin
    imgPhoto.Picture.Bitmap.Assign(cl.bmpPhoto);
    imgPhoto.Visible := true;
  end else
    imgPhoto.Visible := false;
  //lblManager.Caption := cl.

end;
//===========================================================================
procedure TfCLClubList.lvMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i,btm,index: integer;
  itm: TListItem;
  found: Boolean;
begin
  if (X=OldX) and (Y=OldY) or (Self.Parent <> fCLMain) then exit;
  pnlInfo.Parent:=lv;
  found:=false;
  for i:=0 to lv.Items.Count-1 do begin
    itm:=lv.Items[i];
    btm:=itm.Position.Y-trunc(lv.Font.Height*1.2);
    if (y>itm.Position.Y) and (y<btm) then begin
      found:=true; index := i; break;
    end;
  end;
  pnlInfo.Visible:=found;
  if Found then begin
    pnlInfo.Top:=btm+2;
    DisplayInfo(index);
  end else
    pnlInfo.Tag:=0;
  {pnlInfo.Caption:=IntToStr(i);
  pnlInfo.Caption:=pnlInfo.Caption+' '+Format('%d-%d',[x,y]);}
  OldX:=X; OldY:=Y;
end;
//===========================================================================
procedure TfCLClubList.pnlCommonMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  pnlInfo.Visible := false;
end;
//===========================================================================
end.

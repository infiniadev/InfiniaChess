unit CLClubMembers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, ComCtrls, StdCtrls, Menus;

type
  TfCLClubMembers = class(TForm)
    lv: TListView;
    Panel5: TPanel;
    pnlOk: TPanel;
    sbOk: TSpeedButton;
    pnlCancel: TPanel;
    SpeedButton3: TSpeedButton;
    Panel1: TPanel;
    lblName: TLabel;
    pm: TPopupMenu;
    miStatus: TMenuItem;
    Pretendent1: TMenuItem;
    Member1: TMenuItem;
    Helper1: TMenuItem;
    Master1: TMenuItem;
    miKickOut: TMenuItem;
    miAccept: TMenuItem;
    miRefuse: TMenuItem;
    pnlPhoto: TPanel;
    imgPhoto: TImage;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    procedure lvDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
    procedure SpeedButton3Click(Sender: TObject);
    procedure miKickOutClick(Sender: TObject);
    procedure ChangeStatus(Sender: TObject);
    procedure lvSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure sbOkClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ArrangeMenu;
  public
    { Public declarations }
    Club: TObject;
    procedure RefreshList;
    procedure UpdateStatus(Login,StatusStr: string);
    function ItemByLogin(Login: string): TListItem;
  end;

var
  fCLClubMembers: TfCLClubMembers;

implementation

uses CSClub, CLClubOptions, CLSocket, CLConst;

{$R *.DFM}
//===========================================================================
{ TfCLClubMembers }

procedure TfCLClubMembers.RefreshList;
var
  memb: TClubMembers;
  i: integer;
  itm: TListItem;
begin
  lv.Items.Clear;
  if Club = nil then exit;
  memb:=TClub(Club).Members;
  for i:=0 to memb.Count-1 do begin
    itm:=lv.Items.Add;
    itm.Caption:=memb[i].Login;
    itm.SubItems.Add(memb[i].Title);
    itm.SubItems.Add(memb[i].StatusName);
    itm.Data:=memb[i];
  end;
end;
//===========================================================================
procedure TfCLClubMembers.lvDrawItem(Sender: TCustomListView;
  Item: TListItem; Rect: TRect; State: TOwnerDrawState);
var
  i,n: integer;
  txt: string;
  member: TClubMember;
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

    member:=TClubMember(Item.Data);
    lv.Canvas.Font.Color := clBlack;
    case member.Status of
      clsPretendent: lv.Canvas.Font.Color := clGray;
      clsMember: lv.Canvas.Font.Style := [];
      clsHelper: lv.Canvas.Font.Style := [fsBold];
      clsMaster:
        begin
          lv.Canvas.Font.Style := [fsBold];
          lv.Canvas.Font.Color := clRed;
        end;
    end;

    if lv.Selected = Item then lv.Canvas.Font.Color := clWhite;
    lv.Canvas.TextOut(n+4,Rect.Top,Txt);
    n:=n+lv.Columns[i].Width;                    
  end;
end;
//===========================================================================
procedure TfCLClubMembers.SpeedButton3Click(Sender: TObject);
var
  F: TfCLClubOptions;
  cl: TClub;
begin
  F:=TfCLClubOptions.Create(Application);
  cl:=TClub(Club);
  F.ClubId:=cl.Id;
  F.reInformation.Lines.Text:=cl.Info;
  F.edtClubName.Text:=cl.name;
  F.edtSponsor.Text := cl.Sponsor;
  F.chkRequests.Checked:=cl.Requests;
  if Assigned(cl.bmpPhoto) then
    F.imgPhoto.Picture.Bitmap.Assign(cl.bmpPhoto);
  F.ShowModal;
  F.Free;
end;
//===========================================================================
procedure TfCLClubMembers.UpdateStatus(Login, StatusStr: string);
var
  itm: TListItem;
begin
  itm:=ItemByLogin(Login);

  if itm<>nil then
    if StatusStr = '' then lv.Items.Delete(lv.Items.IndexOf(itm))
    else itm.SubItems[1]:=StatusStr;
end;
//===========================================================================
function TfCLClubMembers.ItemByLogin(Login: string): TListItem;
var
  i: integer;
begin
  for i:=0 to lv.Items.Count-1 do begin
    result:=lv.Items[i];
    if lowercase(result.Caption) = lowercase(Login) then exit;
  end;
  result:=nil;
end;
//===========================================================================
procedure TfCLClubMembers.miKickOutClick(Sender: TObject);
begin
  {if MessageDlg('Are you sure you want to kick out '+TClub(SelectedClub).Name+'?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes
  then
    fCLSocket.InitialSend([CMD_STR_CLUBSTATUS,fCLSocket.MyName,
      IntToStr(TClub(SelectedClub).Id),'1']);}
end;
//===========================================================================
procedure TfCLClubMembers.ArrangeMenu;
var
  itm: TListItem;
  member: TClubMember;
begin
  itm:=lv.Selected;
  if (itm = nil) or (itm.Data = nil) then exit;
  member:=TClubMember(itm.Data);
  miStatus.Visible:=member.Status >= clsMember;
  miKickOut.Visible:=miStatus.Visible;
  miAccept.Visible:=not miStatus.Visible;
  miRefuse.Visible:=not miStatus.Visible;
end;
//===========================================================================
procedure TfCLClubMembers.ChangeStatus(Sender: TObject);
var
  Status: TClubStatus;
  itm: TListItem;
  member: TClubMember;
begin
  itm:=lv.Selected;
  if (itm = nil) or (itm.Data = nil) then exit;
  member:=TClubMember(itm.Data);
  Status:=TClubStatus(TComponent(Sender).Tag);
  if (Status = clsNone) and (member.Status >= clsMember) and
    (MessageDlg('Are you sure you want to kick out '+member.Login+'?',
      mtConfirmation,[mbYes,mbNo],0) = mrYes)
    or (Status = clsMaster) and (MessageDlg('Are you sure you want to make '+member.Login+' master of club?'+#13#10+
      'Old master will become helper after this operation.',
        mtConfirmation,[mbYes,mbNo],0) = mrYes)
    or (Status in [clsMember,clsHelper])
    or (Status = clsNone) and (member.Status = clsPretendent)
  then
    fCLSocket.InitialSend([CMD_STR_CLUBSTATUS,member.Login,
      IntToStr(TClub(Club).Id),IntToStr(ord(Status))]);
end;
//===========================================================================
procedure TfCLClubMembers.lvSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  ArrangeMenu;
end;
//===========================================================================
procedure TfCLClubMembers.sbOkClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;
//===========================================================================
procedure TfCLClubMembers.SpeedButton1Click(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_GETCLUBMEMBERS,IntToStr(TClub(Club).Id)]);
end;
//===========================================================================
end.

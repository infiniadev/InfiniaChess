{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLClubs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CLBaseDraw, StdCtrls, Menus, ExtCtrls, CSClub, ComCtrls;

type
  TClubsListMode = (clmClubs, clmSchools, clmAll);

  TfCLClubs = class(TfCLBaseDraw)
    pm: TPopupMenu;
    miGoToClub: TMenuItem;
    miJoinClub: TMenuItem;
    miManageClub: TMenuItem;
    miLeaveClub: TMenuItem;
    miInfo: TMenuItem;
    miEditName: TMenuItem;
    miDelete: TMenuItem;
    miCreateClub: TMenuItem;
    pnlHeader: TPanel;
    procedure miGoToClubClick(Sender: TObject);
    procedure miJoinClubClick(Sender: TObject);
    procedure miManageClubClick(Sender: TObject);
    procedure miLeaveClubClick(Sender: TObject);
    procedure miInfoClick(Sender: TObject);
    procedure miEditNameClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure pmPopup(Sender: TObject);
    procedure miCreateClubClick(Sender: TObject);
  private
    { Private declarations }
    FClubIdChoosen: integer;
    FClubChoosen: TClub;
    FListMode: TClubsListMode;
    procedure SetHeader;
  protected
    procedure OnBaseDrawButtonCilck(btn: TCLBaseDrawButton); override;
  public
    { Public declarations }
    procedure SetListMode(p_ListMode: TClubsListMode);
    procedure LoadClubs;
    procedure VirtualDraw(cnv: TCanvas; X,Y: integer; var pp_FullWidth, pp_FullHeight: integer); override;
    procedure ArrangeMenu;

    property ClubIdChoosen: integer read FClubIdChoosen;
    property ClubChoosen: TClub read FClubChoosen;
    property ListMode: TClubsListMode read FListMode;
  end;

var
  fCLClubs: TfCLClubs;
  fCLSchools: TfCLClubs;

implementation

{$R *.DFM}

uses CLLib, CLSocket, CLConst, CLClubInfo, CLClubNew, CLMain, CLGlobal;

const
  BTN_CLUB = 1;
  BTN_RETURN_TO_MAIN = 2;

{ TfCLClubs }
//==============================================================================================
procedure TfCLClubs.LoadClubs;
begin
  //
end;
//==============================================================================================
procedure TfCLClubs.OnBaseDrawButtonCilck(btn: TCLBaseDrawButton);
begin
  if btn.ButtonType = BTN_CLUB then begin
    if btn.Tag <> FClubIDChoosen then begin
      FClubIDChoosen := btn.Tag;
      FClubChoosen := fClubs.ClubByID(btn.Tag);
      ArrangeMenu;
      Repaint;
    end;
  end else if btn.ButtonType = BTN_RETURN_TO_MAIN then begin
    fCLSocket.InitialSend([CMD_STR_GOTOCLUB,'1']);
  end;
end;
//==============================================================================================
procedure TfCLClubs.VirtualDraw(cnv: TCanvas; X, Y: integer;
  var pp_FullWidth, pp_FullHeight: integer);
var
  BarWidth, BarHeight, shiftLeft, shiftRight, shiftBetween, shiftVer, OneSideWidth, NumOfColumns: integer;
  //********************************************************************************************
  procedure InitVars;
  begin
    BarWidth := 240;
    BarHeight := 150;

    shiftLeft := 10;
    shiftRight := 10;
    shiftBetween := 10;
    shiftVer := 10;

    cnv.Font.Name := 'Arial';

    if FListMode = clmAll then NumOfColumns := 2
    else NumOfColumns := 3;

    OneSideWidth := BarWidth * NumOfColumns + shiftLeft + shiftRight + shiftBetween
  end;
  //********************************************************************************************
  procedure AddBaseDrawButton(R: TRect; ClubID: integer; ButtonType: integer);
  var
    Btn: TCLBaseDrawButton;
  begin
    Btn := TCLBaseDrawButton.Create;
    Btn.R := R;
    Btn.Tag := ClubID;
    Btn.CanBePressed := true;
    Btn.MouseRespond := true;
    Btn.ButtonType := ButtonType;
    Buttons.Add(btn);
  end;
  //********************************************************************************************
  procedure DrawCaption(p_Caption: string; R: TRect; p_Color: TColor);
  begin
    DrawFilledFrame(cnv, IncRect(R, 4, 4), clGray, clGray, 1, 3);
    DrawFilledFrame(cnv, R, clBlack, p_Color, 2, 3);
    TextOutCenter(cnv, R, p_Caption, clBlack, 14, [fsBold]);
  end;
  //********************************************************************************************
  procedure DrawOneClub(Club: TClub; R: TRect; p_Color: TColor);
  var
    CurY, w, h, photoLeft, photoTop, photoWidth, photoHeight: integer;
    TextLeft, TextRight: integer;
  begin
    DrawFilledFrame(cnv, IncRect(R, 4, 4), clGray, clGray, 1, 3);
    if Club.ID = ClubIDChoosen then
      DrawFilledFrame(cnv, R, clYellow, p_Color, 2, 3)
    else
      DrawFilledFrame(cnv, R, clBlack, p_Color, 2, 3);
      //DrawFilledFrame(cnv, R, clGray, p_Color, 1, 3);
    CurY := R.Top + 4;
    TextOut(cnv, R.Left + 6, CurY, Club.Name, clBlack, 10, [fsBold]);
    w := TextWidth(cnv, Format('#%d',[Club.ID]), 10, [fsBold]);
    TextOut(cnv, R.Right - w - 4, CurY, Format('#%d',[Club.ID]), clBlack, 10, [fsBold], w, h);
    CurY := CurY + h + 20;

    if Assigned(Club.bmpPhoto) then begin
      photoWidth := Club.bmpPhoto.Width;
      photoHeight := Club.bmpPhoto.Height;
    end else begin
      photoWidth := 92;
      photoHeight := 92;
    end;

    photoLeft := R.Right - photoWidth - 10;
    photoTop := CurY;
    cnv.Pen.Color := clBlack;
    cnv.Pen.Width := 2;
    cnv.Brush.Color := p_Color;

    cnv.Rectangle(Rect(photoLeft - 1, photoTop - 1,
      photoLeft + photoWidth + 2, photoTop + photoHeight + 2));

    if Assigned(Club.bmpPhoto) then
      cnv.Draw(photoLeft, photoTop, Club.bmpPhoto)
    else
      TextOutCenter(cnv, Rect(photoLeft, photoTop, photoLeft + photoWidth, photoTop + photoHeight), 'NO LOGO',
        clGray, 10, [fsBold]);

    TextLeft := R.Left + 6;
    TextRight := photoLeft - 6;
    if Club.Sponsor <> '' then begin
      TextOut(cnv, TextLeft, CurY, 'Sponsor: ', clBlack, 8, [], w, h);
      TextOutMultiline(cnv, TextLeft, TextRight, CurY, 0, '                ' + Club.Sponsor, clBlack, 8, [fsBold], CurY);
      CurY := CurY + 4;
    end;

    TextOut(cnv, TextLeft, CurY, 'Members: ', clBlack, 8, [], w, h);
    TextOut(cnv, TextLeft + w + 2, CurY, IntToStr(Club.MembersCount), clBlack, 8, [fsBold]);
    CurY := CurY + h + 4;

    if Club.Info <> '' then begin
      TextOutMultiline(cnv, TextLeft, TextRight, CurY, 0, RemoveControlSymbols(Club.Info), clBlack, 8, [fsItalic], CurY,
        false, R.Bottom - 4);
      CurY := CurY + 4;
    end;

    //TextOutMultiline(cnv, TextLeft, TextRight, CurY, 0, 'Members: ' + IntToStr(Club.MembersCount), clBlack, 8, [fsBold], CurY);
  end;
  //********************************************************************************************
  procedure DrawOneSide(p_Caption: string; p_Left: integer; p_ClubType: TClubType; p_Color: TColor);
  var
    R: TRect;
    i, w, h, l, CurY, CurL, FullHeight, CurColumn: integer;
    Club: TClub;
  begin
    w := 200;
    h := 30;
    l := (OneSideWidth - w) div 2 + p_Left;
    CurY := 30 - Y;
    R := Rect(l, CurY, l + w, CurY + h);
    DrawCaption(p_Caption, R, p_Color);
    CurY := CurY + h + shiftVer * 2;
    CurL := p_Left + shiftLeft;
    FullHeight := CurY;

    CurColumn := 1;
    for i := 0 to fClubs.Count - 1 do begin
      Club := fClubs[i];
      if Club.ClubType <> p_ClubType then continue;
      R := Rect(CurL, CurY, CurL + BarWidth, CurY + BarHeight);
      DrawOneClub(Club, R, p_Color);
      AddBaseDrawButton(R, Club.ID, BTN_CLUB);
      inc(CurColumn);

      if CurColumn <= NumOfColumns then
        CurL := CurL + BarWidth + shiftBetween
      else begin
        CurY := CurY + BarHeight + shiftVer;
        CurL := p_Left + shiftLeft;
        CurColumn := 1;
      end;
      FullHeight := CurY + BarHeight + shiftVer;
    end;

    if FullHeight + Y > pp_FullHeight then
      pp_FullHeight := FullHeight + Y;
  end;
  //********************************************************************************************
  procedure AddReturnToMainClubButton;
  var
    R: TRect;
  begin
    R := Rect(10, 30 - Y, 200, 30 - Y + 30);
    DrawFilledFrame(cnv, IncRect(R, 4, 4), clGray, clGray, 1, 3);
    DrawFilledFrame(cnv, R, clBlack, fGL.DefaultBackgroundColor, 2, 3);
    TextOutCenter(cnv, R, 'Return To Main Club', clBlue, 10, [fsBold]);
    AddBaseDrawButton(R, -1, BTN_RETURN_TO_MAIN);
  end;
  //********************************************************************************************
begin
  cnv.Brush.Color := fGL.DefaultBackgroundColor;
  cnv.FillRect(ClientRect);
  pp_FullHeight := 0;

  InitVars;
  Buttons.Clear;

  case FListMode of
    clmClubs: DrawOneSide('Clubs', -X, cltClub, RGB(193,185,255));
    clmSchools: DrawOneSide('Schools', - X, cltSchool, RGB(200,250,200));
    clmAll:
      begin
        DrawOneSide('Clubs', -X, cltClub, RGB(193,185,255));
        DrawOneSide('Schools', OneSideWidth - X, cltSchool, RGB(200,250,200));
      end;
  end;

  if fCLSocket.ClubId <> 1 then
    AddReturnToMainClubButton;

  pp_FullWidth := OneSideWidth * 2 + shiftLeft * 2;
end;
//==============================================================================================
procedure TfCLClubs.miGoToClubClick(Sender: TObject);
begin
  if ClubIDChoosen = 0 then exit;
    fCLSocket.InitialSend([CMD_STR_GOTOCLUB,IntToStr(ClubIDChoosen)]);
end;
//==============================================================================================
procedure TfCLClubs.miJoinClubClick(Sender: TObject);
begin
  if ClubIDChoosen = 0 then exit;
  if MessageDlg('Are you sure you want to join club '+ClubChoosen.Name+'?',
      mtConfirmation, [mbYes,mbNo], 0) = mrYes
  then
    fCLSocket.InitialSend([CMD_STR_CLUBSTATUS,fCLSocket.MyName,
      IntToStr(ClubIDChoosen),'1']);
end;
//==============================================================================================
procedure TfCLClubs.miManageClubClick(Sender: TObject);
begin
  if ClubIDChoosen = 0 then exit;
  if Assigned(ClubChoosen.fCLClubMembers) then
    ClubChoosen.fCLClubMembers.ShowModal
  else
    fCLSocket.InitialSend([CMD_STR_GETCLUBMEMBERS,IntToStr(ClubIDChoosen)]);
end;
//==============================================================================================
procedure TfCLClubs.miLeaveClubClick(Sender: TObject);
begin
  if ClubIDChoosen = 0 then exit;
  if MessageDlg('Are you sure you want to leave club '+ClubChoosen.Name+'?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes
  then
    fCLSocket.InitialSend([CMD_STR_CLUBSTATUS,fCLSocket.MyName,
      IntToStr(ClubIDChoosen),'0']);
end;
//==============================================================================================
procedure TfCLClubs.miInfoClick(Sender: TObject);
var
  F: TfCLClubInfo;
begin
  if ClubIDChoosen = 0 then exit;
  F:=TfCLClubInfo.Create(Application);
  F.Caption := ClubChoosen.Name;
  F.reInformation.Color := Self.Color;
  F.reInformation.Lines.Text := ClubChoosen.Info;
  F.ShowModal;
  F.Free;
end;
//==============================================================================================
procedure TfCLClubs.miEditNameClick(Sender: TObject);
var
  F: TfClubNew;
begin
  if ClubIDChoosen = 0 then exit;
  F := TfClubNew.Create(Application);
  F.chkAuto.Checked := false;
  F.chkAuto.Visible := false;
  F.edId.Enabled := false;
  F.udID.Enabled := false;
  F.udID.Position := ClubIDChoosen;
  F.edName.Text := ClubChoosen.Name;
  F.cmbType.ItemIndex := ord(ClubChoosen.ClubType);
  if F.ShowModal = mrOk then
    fCLSocket.InitialSend([CMD_STR_CLUB, IntToStr(ClubIDChoosen),
      IntToStr(F.cmbType.ItemIndex), F.edName.Text]);
  F.Free;
end;
//==============================================================================================
procedure TfCLClubs.miDeleteClick(Sender: TObject);
begin
  if ClubIDChoosen = 0 then exit;
  if MessageDlg('Are you sure you really want to delete club '+ClubChoosen.Name+'?',
      mtConfirmation,[mbYes,mbNo],0) = mrNo then
    exit;
  fCLSocket.InitialSend([CMD_STR_CLUB_REMOVE, IntToStr(ClubIDChoosen)]);
end;
//==============================================================================================
procedure TfCLClubs.pmPopup(Sender: TObject);
var
  b: Boolean;
begin
  ArrangeMenu;
  b := ClubIDChoosen <> 0;
  miGoToClub.Enabled := b;
  miJoinClub.Enabled := b;
  miManageClub.Enabled := b;
  miLeaveClub.Enabled := b;
  miInfo.Enabled := b;
  miEditName.Enabled := b;
  miDelete.Enabled := b;
end;
//==============================================================================================
procedure TfCLClubs.ArrangeMenu;
begin
  miCreateClub.Visible := (fCLSocket.MyAdminLevel = 3) or fCLSocket.MeEmployed('ClubManager');
  miGoToClub.Visible := Assigned(ClubChoosen) and ClubChoosen.CanGoTo;
  miJoinClub.Visible := Assigned(ClubChoosen) and ClubChoosen.CanJoin;
  miLeaveClub.Visible := Assigned(ClubChoosen) and ClubChoosen.CanLeave;
  miManageClub.Visible := Assigned(ClubChoosen) and ClubChoosen.CanManage;
  miEditName.Visible := Assigned(ClubChoosen) and (fCLSocket.MyAdminLevel = 3) or fCLSocket.MeEmployed('ClubManager');
  miDelete.Visible := Assigned(ClubChoosen) and (fCLSocket.MyAdminLevel = 3) and (ClubChoosen.id <> 1);

  fCLMain.tbClubNew.Visible := miCreateClub.Visible;
  fCLMain.tbClubEdit.Visible := miManageClub.Visible;
  fCLMain.tbClubEnter.Visible := miGoToClub.Visible;
  fCLMain.tbClubDelete.Visible := miDelete.Visible;
end;
//==============================================================================================
procedure TfCLClubs.miCreateClubClick(Sender: TObject);
begin
  fCLMain.tbClubNew.Click;
end;
//==============================================================================================
procedure TfCLClubs.SetListMode(p_ListMode: TClubsListMode);
begin
  FListMode := p_ListMode;
  SetHeader;
end;
//==============================================================================================
procedure TfCLClubs.SetHeader;
var
  s: string;
begin
  case FListMode of
    clmClubs: s := 'Clubs';
    clmSchools: s := 'Schools';
    clmAll: s := 'Clubs & Schools';
  end;
  pnlHeader.Caption := s;
end;
//==============================================================================================
end.

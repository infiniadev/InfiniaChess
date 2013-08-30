{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLNotify;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, CLGlobal, Buttons, ExtCtrls, StdCtrls,
  CLListBox, CLLogins;

const
  TAB_NOTIFY = 0;
  TAB_CENSOR = 1;
  TAB_NEW_USERS = 4;

type
  TNotifyType = (ntFriend, ntIFriend, ntCensor, ntICensor, ntNoPlay, ntINoPlay);

  TNotifyNewUserData = class
    Days: integer;
    AdminGreated: Boolean;
  end;

  TfCLNotify = class(TForm)
    clNotify: TCLListBox;
    miInvite: TMenuItem;
    miMatch: TMenuItem;
    miMessage: TMenuItem;
    miNotifyAdd: TMenuItem;
    miNotifyRemove: TMenuItem;
    miProfile: TMenuItem;
    N1: TMenuItem;
    pmNotify: TPopupMenu;
    tbNotify: TTabControl;
    miTell: TMenuItem;
    miFollow: TMenuItem;
    miObserve: TMenuItem;
    miUnfollow: TMenuItem;
    pnlHeader: TPanel;
    lblNotify: TLabel;
    sbClose: TSpeedButton;
    miAdminGreetings: TMenuItem;
    miNotifyChange: TMenuItem;
    miCensorAdd: TMenuItem;
    miFullCensored: TMenuItem;
    miNoPlay: TMenuItem;

    procedure clNotifyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure clNotifyDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure clNotifyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miInviteClick(Sender: TObject);
    procedure miMatchClick(Sender: TObject);
    procedure miMessageClick(Sender: TObject);
    procedure miNotifyAddClick(Sender: TObject);
    procedure miNotifyRemoveClick(Sender: TObject);
    procedure miProfileClick(Sender: TObject);
    procedure pmNotifyPopup(Sender: TObject);
    procedure sbCloseClick(Sender: TObject);
    procedure tbNotifyChange(Sender: TObject);
    procedure miTellClick(Sender: TObject);
    procedure miFollowClick(Sender: TObject);
    procedure miObserveClick(Sender: TObject);
    procedure miUnfollowClick(Sender: TObject);
    procedure tbNotifyDrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure miAdminGreetingsClick(Sender: TObject);
    procedure miNotifyChangeClick(Sender: TObject);
  private
    { Private declarations }
    FFriends: TStringList;
    FCensored: TStringList;
    FAdmins: TStringList;
    FMasters: TStringList;
    FNewUsers: TStringList;

    procedure PutToRightPlace(FullName: string; SL: TStrings; State, TabIndex: integer);

  public
    { Public declarations }
    procedure Notify(const Datapack: TStrings);
    procedure NotifyBegin;
    procedure NotifyEnd;
    procedure NotifyRemove(const Datapack: TStrings);
    procedure SetMenuState;
    procedure AddAdmin(Login, Title: string);
    procedure AddMaster(Login, Title: string);
    procedure AddNewUser(Login, Title: string; Days: integer; AdminGreated: Boolean);
    procedure RemoveUser(Login, Title: string);
    procedure ClearAll;
    procedure ArrangeTabs;
    procedure NewUserGreated(CMD: TStrings);
    procedure OnNewLogin(p_Login: TLogin);
  end;

var
  fCLNotify: TfCLNotify;

implementation

uses
  CLConst, CLMain, CLTerminal, CLSocket, CLConsole, CLMessages, CLRooms,
  CLFilterManager, CLLib;

const
  STR_ARRIVED = '%s has arrived';
  STR_DEPARTED = '%s has departed';

{$R *.DFM}

//______________________________________________________________________________
{ DP_NOTIFY: DP#, LoginID, Login, Title, NotifyType, State }
procedure TfCLNotify.Notify(const Datapack: TStrings);
var
  LoginID, State, Index: Integer;
  Login, Title, FullName, s: string;
  NT: TNotifyType;
begin
  { A player has arrived or his/her state has changed. Update the listbox. }

  try
    LoginID := StrToInt(Datapack[1]);
    Login := Datapack[2];
    Title := Datapack[3];
    FullName := GetNameWithTitle(Login, Title);
    NT := TNotifyType(StrToInt(Datapack[4]));
    State := StrToInt(Datapack[5]);
  except
    exit;
  end;

  if Login = fCLSocket.MyName then exit;

  { Friend }
  if NT in [ntFriend, ntIFriend] then begin
    { Try to find the Login param in the stringlist. }
    Index := FFriends.IndexOf(FullName);
    if (Index <> -1) and (Integer(FFriends.Objects[Index])<>State) then begin
      { Sounds }
      if State = 1 then begin { Arrived. }
        fGL.PlayCLSound(SI_ARRIVED);
        s := Format(STR_ARRIVED, [FullName]);
        fCLTerminal.AddLine(fkConsole, 0, s, ltNotifyArrived);
      end else begin { Departed. }
        fGL.PlayCLSound(SI_LEFT);
        s := Format(STR_DEPARTED, [FullName]);
        fCLTerminal.AddLine(fkConsole, 0, s, ltNotifyDeparted);
      end;
    end;
    PutToRightPlace(FullName, FFriends, State, 0);
  end
  { Censored }
  else if NT in [ntCensor, ntNoPlay, ntICensor, ntINoPlay] then begin
    State := ord(NT) * 10 + State;
    PutToRightPlace(FullName, FCensored, State, 1);
  end;


  { Update listbox display }
  Index := clNotify.Items.IndexOf(FullName);
  if Index > -1 then begin
    clNotify.ItemIndex := Index;
    clNotify.Items.Objects[Index] := Pointer(State);
      { Required to fire OnCustomDrawItem }
    clNotify.Items[Index] := FullName;
  end;
end;
//______________________________________________________________________________
{ DP_NOTIFY_BEGIN: DP# }
procedure TfCLNotify.NotifyBegin;
begin
  with clNotify.Items do
    begin
      BeginUpdate;
      Clear;
    end;
  FFriends.Clear;
  FCensored.Clear;
end;
//______________________________________________________________________________
{ DP_NOTIFY_END: DP# }
procedure TfCLNotify.NotifyEnd;
begin
  clNotify.Items.EndUpdate;
end;
//______________________________________________________________________________
{ DP_NOTIFY_REMOVE: DP#, LoginID, Login, Title, NotifyType }
procedure TfCLNotify.NotifyRemove(const Datapack: TStrings);
var
  LoginID, Index: Integer;
  Login, Title, FullName, s: string;
  NT: TNotifyType;
begin
  try
    LoginID := StrToInt(Datapack[1]);
    Login := Datapack[2];
    Title := Datapack[3];
    FullName := GetNameWithTitle(Login, Title);
    NT := TNotifyType(StrToInt(Datapack[4]));
  except
    exit;
  end;

  if NT = ntFriend then begin
    Index := FFriends.IndexOf(FullName);
    if Index > -1 then FFriends.Delete(Index);
  end else if NT in [ntCensor,ntNoPlay] then begin
    Index := FCensored.IndexOf(FullName);
    if Index > -1 then FCensored.Delete(Index);
  end;

  { Attempt to find the clNNotify item that matches the Login param, if found
    remove it from the listbox. }
  Index := clNotify.Items.IndexOf(FullName);
  if Index > -1 then clNotify.Items.Delete(Index);
  if clNotify.Items.Count > Index then
    clNotify.ItemIndex := Index
  else
    clNotify.ItemIndex := Index -1;
  clNotify.OnClick(nil);
end;
//______________________________________________________________________________
procedure TfCLNotify.OnNewLogin(p_Login: TLogin);
begin
  if p_Login.AdminLevel > 0 then
    fCLNotify.AddAdmin(p_Login.Login,p_Login.Title);

  if p_Login.Master then
    fCLNotify.AddMaster(p_Login.Login,p_Login.Title);

  if Date-60 < p_Login.Created then
    fCLNotify.AddNewUser(p_Login.Login, p_Login.Title, Trunc(Date-p_Login.Created+1), p_Login.AdminGreated);
end;
//______________________________________________________________________________
procedure TfCLNotify.SetMenuState;
var
  NotifyType: integer;
begin
  { Enable/Disable the popupmenus. Called when the InitState changes or
    from the OnPopup event. }
  miInvite.Enabled := (clNotify.ItemIndex > -1) and (fCLRooms.RoomCreator) and
    (Integer(clNotify.Items.Objects[clNotify.ItemIndex]) = 1) and
    (tbNotify.TabIndex = 0);
  miMatch.Enabled := (clNotify.ItemIndex > -1) and (tbNotify.TabIndex = 0) and
    (Integer(clNotify.Items.Objects[clNotify.ItemIndex]) = 1);
  miMessage.Enabled := (clNotify.ItemIndex > -1) and (tbNotify.TabIndex = 0);
  miNotifyAdd.Enabled := fCLSocket.InitState >= isLoginComplete;
  miCensorAdd.Enabled := fCLSocket.InitState >= isLoginComplete;
  miNotifyRemove.Enabled := clNotify.ItemIndex > -1;
  miProfile.Enabled := clNotify.ItemIndex > -1;
  miTell.Enabled := clNotify.ItemIndex > -1;
  miFollow.Enabled := clNotify.ItemIndex > -1;
  miObserve.Enabled := clNotify.ItemIndex > -1;
  miUnfollow.Enabled := clNotify.ItemIndex > -1;

  miNotifyChange.Visible := tbNotify.TabIndex = TAB_CENSOR;
  miNotifyChange.Enabled := miNotifyChange.Visible and (clNotify.ItemIndex > -1);
  if (clNOtify.ItemIndex > -1) and miNotifyChange.Enabled then begin
    NotifyType := Integer(clNotify.Items.Objects[clNotify.ItemIndex]) div 10;
    if NotifyType = 2 then miNotifyChange.Caption := 'Change to No Play'
    else miNotifyChange.Caption := 'Change to Full Censored';

    miNotifyChange.Tag := 6 - NotifyType;
  end;

  miNotifyAdd.Visible := tbNotify.TabIndex = TAB_NOTIFY;
  miCensorAdd.Visible := tbNotify.TabIndex = TAB_CENSOR; 
  miNotifyRemove.Visible := (tbNotify.TabIndex = TAB_NOTIFY) or (tbNotify.TabIndex = TAB_CENSOR);
  N1.Visible := (tbNotify.TabIndex = TAB_NOTIFY) or (tbNotify.TabIndex = TAB_CENSOR);

  if tbNotify.TabIndex <> TAB_NEW_USERS then
    miAdminGreetings.Enabled := clNotify.ItemIndex > -1
  else
    miAdminGreetings.Enabled := not TNotifyNewUserData(clNotify.Items.Objects[clNotify.ItemIndex]).AdminGreated

  {miAdminGreetings.Enabled := (clNotify.ItemIndex > -1)
    and (clNotify.Items.Objects[clNotify.ItemIndex] is TNotifyNewUserData)
    and not TNotifyNewUserData(clNotify.Items.Objects[clNotify.ItemIndex]).AdminGreated;}
end;
//______________________________________________________________________________
procedure TfCLNotify.clNotifyClick(Sender: TObject);
begin
  //SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLNotify.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FFriends.Free;
  FCensored.Free;
  FAdmins.Free;
  FMasters.Free;
  FNewUsers.Free;
  clNotify.Clear;
  fCLNotify := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLNotify.FormCreate(Sender: TObject);
begin
  { Cannot set this value at design time in the sub-classed listbox. bug? }
  clNotify.ItemHeight := Round(20 / (96 / PixelsPerInch));
  FFriends := TStringList.Create;
  FFriends.Sorted := false;
  FCensored := TStringList.Create;
  FAdmins := TStringList.Create;
  FMasters := TStringList.Create;
  FNewUsers := TStringList.Create;
  FAdmins.Sorted := true;
  FMasters.Sorted := true;
  //FNewUsers.Sorted := true;
end;
//______________________________________________________________________________
procedure TfCLNotify.clNotifyDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
const
  BITMAP_BUFF = 4;
var
  Days, h, w, n, nTop, NotifyType, ImageIndex: integer;
  s: string;
  NewUserData: TNotifyNewUserData;
begin
  { Determine which index of bitmap in the fMain.ImageList to draw. }
  if tbNotify.TabIndex > 1 then n := 0
  else
    if Integer(clNotify.Items.Objects[Index]) mod 10 = 1 then
      n := 0
    else
      n := 1;

  { Draw it. }
  fCLMain.ilNotify.Draw(clNotify.Canvas, BITMAP_BUFF, Rect.Top +
    (clNotify.ItemHeight - fCLMain.ilNotify.Height) div 2, n);

  if tbNotify.TabIndex = TAB_NEW_USERS then begin
    NewUserData := TNotifyNewUserData(clNotify.Items.Objects[Index]);
    if NewUserData.AdminGreated then
      clNotify.Canvas.Font.Style := []
    else
      clNotify.Canvas.Font.Style := [fsBold];

    h := clNotify.Canvas.TextHeight('0');
    nTop := Rect.Top + (Rect.Bottom - Rect.Top - h) div 2;
    clNotify.Canvas.TextOut(Rect.Left + clNotify.TextBuff,
      nTop, clNotify.Items[Index]);

    s := IntToStr(NewUserData.Days)+' days';
    w := clNotify.Canvas.TextWidth(s);
    clNotify.Canvas.TextOut(Rect.Right-w-8, nTop, s);
  end;

  if tbNotify.TabIndex = TAB_CENSOR then begin
    NotifyType := Integer(clNotify.Items.Objects[Index]) div 10;
    if NotifyType = 2 then ImageIndex := 3
    else ImageIndex := 6;

    fCLMain.ilNotify.Draw(clNotify.Canvas, Rect.Right - 20, Rect.Top +
    (clNotify.ItemHeight - fCLMain.ilNotify.Height) div 2, ImageIndex);
  end;
end;
//______________________________________________________________________________
procedure TfCLNotify.clNotifyKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE: miNotifyRemove.Click;
    VK_INSERT: miNotifyAdd.Click;
  end;
end;
//______________________________________________________________________________
procedure TfCLNotify.miInviteClick(Sender: TObject);
begin
  fCLRooms.ShowInviteDialog(RemoveTitle(clNotify.Items[clNotify.ItemIndex]));
end;
//______________________________________________________________________________
procedure TfCLNotify.miMatchClick(Sender: TObject);
begin
  fCLMain.ShowMatchDialog(RemoveTitle(clNotify.Items[clNotify.ItemIndex]));
end;
//______________________________________________________________________________
procedure TfCLNotify.miMessageClick(Sender: TObject);
begin
  fCLMessages.ShowMessageDialog(RemoveTitle(clNotify.Items[clNotify.ItemIndex]), '');
end;
//______________________________________________________________________________
procedure TfCLNotify.miNotifyAddClick(Sender: TObject);
var
  s: string;
begin
  { Add somebody to your notify list. }
  s := InputBox('Add a Friend', 'Enter the name of a friend to add to your list.', '');
  if s <> '' then
    begin
      s := Copy(s, 1, 15);
      if tbNotify.TabIndex = 0 then
        fCLSocket.InitialSend([CMD_STR_NOTIFY_ADD, s])
      else
        fCLSocket.InitialSend([CMD_STR_CENSOR_ADD, s, IntToStr((Sender as TMenuItem).Tag)]);
    end;
end;
//______________________________________________________________________________
procedure TfCLNotify.miNotifyRemoveClick(Sender: TObject);
begin
  { Remove somebody from your notify list. }
  if clNotify.ItemIndex = -1 then Exit;

  if tbNotify.TabIndex = 0 then
    fCLSocket.InitialSend([CMD_STR_NOTIFY_REMOVE, clNotify.Items[clNotify.ItemIndex]])
  else
    fCLSocket.InitialSend([CMD_STR_CENSOR_REMOVE, clNotify.Items[clNotify.ItemIndex]]);
end;
//______________________________________________________________________________
procedure TfCLNotify.miProfileClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_PROFILE, RemoveTitle(clNotify.Items[clNotify.ItemIndex])]);
end;
//______________________________________________________________________________
procedure TfCLNotify.pmNotifyPopup(Sender: TObject);
begin
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLNotify.sbCloseClick(Sender: TObject);
begin
  { Detach the Notify form from the Main form. }
  fCLMain.NotifyAttached := not fCLMain.NotifyAttached;
end;
//______________________________________________________________________________
procedure TfCLNotify.tbNotifyChange(Sender: TObject);
begin
  clNotify.CustomDraw := tbNotify.TabIndex = 4;

  clNotify.Items.BeginUpdate;
  clNotify.Items.Clear;

  if tbNotify.TabIndex = 0 then begin
    lblNotify.Caption := 'Friends';
    clNotify.Items.Assign(FFriends);
  end else if tbNotify.TabIndex = 1 then begin
    lblNotify.Caption := 'Censored';
    clNotify.Items.Assign(FCensored);
  end else if tbNotify.TabIndex = 2 then begin
    lblNotify.Caption := 'Admins';
    clNotify.Items.Assign(FAdmins);
  end else if tbNotify.TabIndex = 3 then begin
    lblNotify.Caption := 'Masters';
    clNotify.Items.Assign(FMasters);
  end else if tbNotify.TabIndex = 4 then begin
    lblNotify.Caption := 'New users';
    clNotify.Items.Assign(FNewUsers);
  end;

  miAdminGreetings.Visible := (tbNotify.TabIndex = 4) and (fCLSocket.MyAdminLevel > 0);

  clNotify.Items.EndUpdate;
end;
//______________________________________________________________________________
procedure TfCLNotify.miTellClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_TELL, RemoveTitle(clNotify.Items[clNotify.ItemIndex]), 'Hi!']);
end;
//______________________________________________________________________________
procedure TfCLNotify.miFollowClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_FOLLOW, RemoveTitle(clNotify.Items[clNotify.ItemIndex])]);
end;
//______________________________________________________________________________
procedure TfCLNotify.miObserveClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_OBSERVE, RemoveTitle(clNotify.Items[clNotify.ItemIndex])]);
end;
//______________________________________________________________________________
procedure TfCLNotify.miUnfollowClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_UNFOLLOW]);
end;
//______________________________________________________________________________
procedure TfCLNotify.tbNotifyDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  x, y, index: integer;
  color: TColor;
begin

  case TabIndex of
    0: index := 0;
    1: index := 3;
    2: index := 2;
    3: index := 4;
    4: index := 5;
  end;

  if tbNotify.TabIndex = TabIndex then begin
    x := 4; y := 4; color := clWhite;
  end else begin
    x := 0; y := 0; color := clNotify.Color;
  end;

  Control.Canvas.Brush.Color := color;
  Control.Canvas.FillRect(Rect);
  fCLMain.ilNotify.Draw(Control.Canvas,Rect.Left+2+x,Rect.Top+y,index);
end;
//______________________________________________________________________________
procedure TfCLNotify.PutToRightPlace(FullName: string; SL: TStrings;
  State, TabIndex: integer);
  //****************************************************************************
  function FindRightPlace: integer;
  var
    i: integer;
    ItemState: integer;
  begin
    i := 0;
    while i < SL.Count do begin
      ItemState := Integer(SL.Objects[i]);
      if (State mod 10 > ItemState mod 10) or (State mod 10 = ItemState mod 10) and (lowercase(FullName) <= lowercase(SL[i])) then begin
        result := i;
        exit;
      end;
      inc(i);
    end;
    result := SL.Count;
  end;
  //****************************************************************************
  procedure PutToStringList(p_SL: TStrings; p_From, p_To: integer);
  begin
    if p_From = p_To then
      p_SL.Objects[p_From] := TObject(State)
    else begin
      p_SL.InsertObject(p_To, FullName, TObject(State));
      if p_From <> -1 then
        if p_To > p_From then p_SL.Delete(p_From)
        else p_SL.Delete(p_From + 1);
    end;
  end;
  //****************************************************************************
var
  nFrom, nTo: integer;
begin
  nFrom := SL.IndexOf(FullName);
  nTo := FindRightPlace;
  PutToStringList(SL,nFrom,nTo);
  if tbNotify.TabIndex = TabIndex then
    PutToStringList(CLNotify.Items,nFrom,nTo);
end;
//______________________________________________________________________________
procedure TfCLNotify.AddAdmin(Login, Title: string);
var
  FullName: string;
  Index: integer;
begin
  FullName := GetNameWithTitle(Login, Title);
  Index := FAdmins.IndexOf(FullName);
  if Index > -1 then exit;
  FAdmins.AddObject(FullName,TObject(1));
  if tbNotify.TabIndex = 2 then clNotify.Items.Assign(FAdmins);
end;
//______________________________________________________________________________
procedure TfCLNotify.RemoveUser(Login, Title: string);
var
  FullName: string;
  //****************************************************************************
  procedure Del(SL: TStringList; TabIndex: integer);
  var
    index: integer;
  begin
    Index := SL.IndexOf(FullName);
    if Index = -1 then exit;

    SL.Delete(Index);
    if tbNotify.TabIndex = TabIndex then
      clNotify.Items.Delete(Index);
  end;
  //****************************************************************************
begin
  FullName := GetNameWithTitle(Login, Title);
  Del(FAdmins,2);
  Del(FMasters,3);
  Del(FNewUsers,4);
end;
//______________________________________________________________________________
procedure TfCLNotify.AddMaster(Login, Title: string);
var
  FullName: string;
  Index: integer;
begin
  FullName := GetNameWithTitle(Login, Title);
  Index := FMasters.IndexOf(FullName);
  if Index > -1 then exit;
  FMasters.AddObject(FullName,TObject(1));
  if tbNotify.TabIndex = 3 then clNotify.Items.Assign(FMasters);
end;
//______________________________________________________________________________
procedure TfCLNotify.AddNewUser(Login, Title: string; Days: integer; AdminGreated: Boolean);
var
  FullName: string;
  i, Index: integer;
  NewUserData: TNotifyNewUserData;
begin
  FullName := GetNameWithTitle(Login, Title);
  Index := FNewUsers.IndexOf(FullName);
  if Index > -1 then exit;
  i:=0;
  while (i < FNewUsers.Count) and (TNotifyNewUserData(FNewUsers.Objects[i]).Days < Days) do
    inc(i);

  NewUserData := TNotifyNewUserData.Create;
  NewUserData.Days := Days;
  NewUserData.AdminGreated := AdminGreated;

  FNewUsers.InsertObject(i,FullName,NewUserData);
  if tbNotify.TabIndex = 4 then clNotify.Items.Assign(FNewUsers);
end;
//______________________________________________________________________________
procedure TfCLNotify.ClearAll;
begin
  clNotify.Clear;
  FFriends.Clear;
  FCensored.Clear;
  FAdmins.Clear;
  FMasters.Clear;
  FNewUsers.Clear;
end;
//______________________________________________________________________________
procedure TfCLNotify.ArrangeTabs;
begin
  if (fCLSocket.MyAdminLevel = 0) and (tbNotify.Tabs.Count > 4) then
    tbNotify.Tabs.Delete(4)
  else if (fCLSocket.MyAdminLevel > 0) and (tbNotify.Tabs.Count <=4) then
    tbNotify.Tabs.Add('');
end;
//______________________________________________________________________________
procedure TfCLNotify.miAdminGreetingsClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_ADMINGREETINGS, RemoveTitle(clNotify.Items[clNotify.ItemIndex])]);

end;
//______________________________________________________________________________
procedure TfCLNotify.NewUserGreated(CMD: TStrings);
var
  i: integer;
  Login: string;
begin
  if CMD.Count < 2 then exit;
  Login := lowercase(CMD[1]);

  for i:=0 to FNewUsers.Count - 1 do begin
    if Login = lowercase(RemoveTitle(FNewUsers[i])) then begin
      TNotifyNewUserData(FNewUsers.Objects[i]).AdminGreated := true;
      if tbNotify.TabIndex = TAB_NEW_USERS then begin
        clNotify.Items.Assign(FNewUsers);
        clNotify.Repaint;
      end;
      exit;
    end;
  end;
end;
//______________________________________________________________________________
procedure TfCLNotify.miNotifyChangeClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_CENSOR_ADD, RemoveTitle(clNotify.Items[clNotify.ItemIndex]),
    IntToStr((Sender as TMenuItem).Tag)]);
end;
//______________________________________________________________________________
end.


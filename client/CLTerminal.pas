{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLTerminal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, contnrs,
  StdCtrls, Menus, CLGlobal, ShellApi, Buttons, ComCtrls, ExtCtrls,
  CLListBox, CLConsole, CLFilterManager, CLGame, Dialogs, ClipBrd, CLEvents,
  CLConsole1L, ImgList, CLLib, CLLogins;

const
  VISIBLE_TIME = 50;
  STATIC_TIME = 50;
  SCROLLING_TIME = 10;

  BLINK_COUNT = 5;

type
  TAnnStates = (asStatic, asBlinking, asScrolling, asMouseDown);

  TOneRatingInfo = record
    R, W, L, D: integer; // rating, wins, losses and draws
  end;

  TRatingInfo = class
  private
    FRatingString: string;
    FProvString: string;
    FData: array [0..5] of TOneRatingInfo;
    FIsOk: Boolean;
    function GetIsProv(RatedType: TRatedType): Boolean;
    function GetRating(RatedType: TRatedType): integer;
  public
    constructor Create(RatingString: string);
    procedure SetRatingString(RatingString: string);
    function NumberOfGames(RatedType: TRatedType): integer;
    function ProvByRating: string;
    procedure Clear;

    property IsOk: Boolean read FIsOk write FIsOk;
    property IsProv[RatedType: TRatedType]: Boolean read GetIsProv;
    property ProvString: string read FProvString write FProvString;
    property Rating[RatedType: TRatedType]: integer read GetRating;
  end;

  TAnnState = record
    State: TAnnStates;
    OldState: TAnnStates;
    Text: string;
    Visible: Boolean;
    Ticks: integer;
    Counter: integer;
    Start: integer;
    MouseX: integer;
    ScrollingEnabled: Boolean;
  end;

  TCLHistory = class
  private
    sl: TStringList;
    Position: integer;
  public
    constructor Create;
    destructor Destroy;
    function Prev: string;
    function Next: string;
    procedure Last;
    procedure Add(Str: string);
  end;

  TfCLTerminal = class(TForm)
    cbCmd: TComboBox;
    ccConsole: TCLConsole;
    edtInput: TEdit;
    miAddFriend: TMenuItem;
    miInclude: TMenuItem;
    miInvite: TMenuItem;
    miMatch: TMenuItem;
    miMessage: TMenuItem;
    miProfile: TMenuItem;
    pmCommand: TPopupMenu;
    pmLogins: TPopupMenu;
    sbClose: TSpeedButton;
    sbMax: TSpeedButton;
    tcMain: TTabControl;
    lvLogins: TListView;
    miTell: TMenuItem;
    miFollow: TMenuItem;
    miObserve: TMenuItem;
    miUnfollow: TMenuItem;
    pmConsole: TPopupMenu;
    miClearConsole: TMenuItem;
    miClipboardConsole: TMenuItem;
    miSaveConsole: TMenuItem;
    pnlPhoto: TPanel;
    imgPhoto: TImage;
    miScore: TMenuItem;
    udAnnounce: TUpDown;
    ccAnnounce: TCLConsole1L;
    Timer1: TTimer;
    ilLogins: TImageList;
    Panel1: TPanel;
    sbShoutMute: TSpeedButton;
    miAdmin: TMenuItem;
    Mute1: TMenuItem;
    Nuke1: TMenuItem;
    Ban1: TMenuItem;
    N1hour1: TMenuItem;
    N2hour1: TMenuItem;
    N5hours1: TMenuItem;
    N10hours1: TMenuItem;
    N24hours1: TMenuItem;
    miMute1Week: TMenuItem;
    miMute1Month: TMenuItem;
    miMuteForever: TMenuItem;
    Others1: TMenuItem;
    N1hour2: TMenuItem;
    N2hours1: TMenuItem;
    N5hours2: TMenuItem;
    N10hours2: TMenuItem;
    N24hours2: TMenuItem;
    miBan1Week: TMenuItem;
    miBan1Month: TMenuItem;
    miBanForever: TMenuItem;
    Others2: TMenuItem;
    Unmute1: TMenuItem;
    BanHistory1: TMenuItem;
    miAddCensor: TMenuItem;
    miFullCensor: TMenuItem;
    miNoPlay: TMenuItem;
    ilOnlineStatus: TImageList;

    procedure ccConsoleClick(Sender: TObject);
    procedure ccConsoleKeyPress(Sender: TObject; var Key: Char);
    procedure edtInputKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure miAddFriendClick(Sender: TObject);
    procedure miAddCensorClick(Sender: TObject);
    procedure miInviteClick(Sender: TObject);
    procedure miMatchClick(Sender: TObject);
    procedure miMessageClick(Sender: TObject);
    procedure pmLoginsPopup(Sender: TObject);
    procedure miProfileClick(Sender: TObject);
    procedure sbCloseClick(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);
    procedure SendCommand(Sender: TObject);
    procedure tcMainChange(Sender: TObject);
    procedure tcMainDrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure miIncludeClick(Sender: TObject);
    procedure miTellClick(Sender: TObject);
    procedure miObserveClick(Sender: TObject);
    procedure miFollowClick(Sender: TObject);
    procedure cbCmdChange(Sender: TObject);
    procedure miUnfollowClick(Sender: TObject);
    procedure miClearConsoleClick(Sender: TObject);
    procedure miClipboardConsoleClick(Sender: TObject);
    procedure miSaveConsoleClick(Sender: TObject);
    procedure edtInputKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvLoginsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure miScoreClick(Sender: TObject);
    procedure udAnnounceClick(Sender: TObject; Button: TUDBtnType);
    procedure Timer1Timer(Sender: TObject);
    procedure ccAnnounceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ccAnnounceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ccAnnounceMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ccAnnounceDblClick(Sender: TObject);
    procedure lvLoginsDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
    procedure sbShoutMuteClick(Sender: TObject);
    procedure Nuke1Click(Sender: TObject);
    procedure MuteClick(Sender: TObject);
    procedure BanClick(Sender: TObject);
    procedure BanMuteClick(Sender: TObject; p_Str, p_Command: string);
    procedure Unmute1Click(Sender: TObject);
    procedure tcMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BanHistory1Click(Sender: TObject);

  private
  { Private declarations }
    FFilterMgr: TCLFilterManager;
    //FLogins: TObjectList;
    FLoginsUpdating: Boolean;
    FTabBitmapY: Integer;
    FTabTextY: Integer;
    FCurrentRType: integer;
    FFollowing: Boolean;
    FFollowedPlayer: string;
    FHistory: TCLHistory;
    OldX, OldY: integer;
    CurImageLogin: string;
    OldTabIndex: integer;
    slAnnounce: TStringList;
    ShoutMuted: Boolean;
    LoginFilterList: TLoginFilterList;
    LoadLoginInProgress: Boolean;

    annState: TAnnState;

    procedure AddLoginFilter(Key1: TCLFilterKey; Key2: integer; LoginID: integer);
    {procedure AddLogin(const Filter: TCLFilter; const LoginID: Integer;
       const LoginName: string; const Title: string; const RatingString: string;
       const ImageIndex: integer; const AdminLevel: integer;
       const Master: Boolean; const Created: TDateTime;
       const ProvString: string; const MembershipType: TMembershipType);}
    procedure DeleteLvLogins(const LoginID: integer);
    function FindLvLoginsIndex(const LoginID: integer): integer;
    procedure ClearLogin(const Filter: Integer; const LoginID: Integer);
    procedure ClearLogins(const Filter: Integer); overload;
    procedure ClearMenuItems;
    procedure CloseTab(const Filter: TCLFilter); overload;
    procedure ProcessCommand;
    //procedure UpdateRatingAndStats(const N: integer);
    //procedure UpdateAllRatingAndStats;
    //procedure SetLvLoginsRating(const N: integer; const RatingString: string); overload;
    //procedure SetLvLoginsRating(const Login: string; const RatingString: string); overload;
    procedure SetLvLoginsRating(const L: TLogin);

    procedure AddToLvLogins(const L: TLogin);
    procedure SortLvLogins(OrdType,OrdDirection: integer);
    function FindLvLoginPlace(const L: TLogin): integer;

    function LvLoginsCompare(FromNum,ToNum,OrdType,OrdDirection: integer): integer;
    function CompareLvLogins(L: TLogin; Index: integer): integer;
    function LvLoginsIndex(const LoginName: string): integer;
    procedure LvLoginsDelete(const LoginName: string);
    function FindLvLoginsMin(Start,OrdType,OrdDirection: integer): integer;
    procedure SetCurrentRType(const RType: integer);
    procedure ShowLvLoginsHint;
    function GetCurrentCLFilter: TCLFilter;
    function LastAnnounce: string;
    function ProvStringByRatingString(RatingString: string): string;
    procedure ShowFilterGame;
  public
  { Public declarations }
    function CreateFilter(const Caption: string; const Key1: TCLFilterKey;
      const Key2: Integer): TCLFilter;
    function CreateChildFilter(const Key1: TCLFilterKey; const Key2: Integer;
      const ParentKey1: TCLFilterKey; const ParentKey2: Integer;
      const ParentCaption: string): TCLFilter;
    procedure AddLine(const Key1: TCLFilterKey; const Key2: Integer;
      const Line: string; const LineTrait: TLineTrait; const Color: TColor = -1);
    procedure AssignFont;
    procedure ClearLogins; overload;
    procedure ClearObservers(const Game: Integer);
    procedure CloseTab(const Key1: TCLFilterKey; const Key2: Integer); overload;
    procedure CreateMenuItems;
    procedure LoginBegin;
    procedure LoginEnd;
    procedure LogOff(const Datapack: TStrings);
    procedure Observer(const Datapack: TStrings);
    procedure ObserverBegin(const Datapack: TStrings);
    procedure ObserverEnd(const Datapack: TStrings);
    procedure RoomEnter(const Datapack: TStrings);
    procedure RoomExit(const Datapack: TStrings);
    procedure RoomSetBegin(const Datapack: TStrings);
    procedure RoomSetEnd(const Datapack: TStrings);
    procedure SetMenuState;
    procedure ShowTab(const Game: TCLGame);
    procedure Tell(const CMD: TStrings);
    procedure UnObserver(const Datapack: TStrings);
    procedure ReceiveRating2(const Datapack: TStrings);
    procedure FollowStart(const Datapack: TStrings);
    procedure FollowEnd(const Datapack: TStrings);
    procedure SortLvLoginsCurrent;
    procedure EventExit(ID: integer);
    procedure AddAnnounce(Msg: string);
    procedure SetFontSize(Size: integer);
    function NumberOfRatedGames(Login: string; RatingType: TRatedType): integer;
    procedure FocusConsoleFilter;
    procedure OnNewLogin(p_Login: TLogin);
    procedure CMD_OnlineStatus(CMD: TStrings);
    procedure LoadLogins;
    procedure CMD_PmExit(CMD: TStrings);
    
    property FilterMgr: TCLFilterManager read FFilterMgr;
    property CurrentRType: integer read FCurrentRType write SetCurrentRType;
    property FollowedPlayer: string read FFollowedPlayer write FFollowedPlayer;
    property CurrentCLFilter: TCLFilter read GetCurrentCLFilter;
    property LoginsUpdating: Boolean read FLoginsUpdating;
  end;

var
  fCLTerminal: TfCLTerminal;
  fLoginList: TLoginList;

function RemoveTitle(const LoginName: string): string;

implementation

{$R *.DFM}

uses
  CLConst, CLMain, CLSocket, CLBoard, CLRooms, CLMessages, CLImageLib,
  CLNotify, CLLectures, CLNavigate;

const
  SORT_NAME=0;
  SORT_RATING=1;

//==============================================================================
function RemoveTitle(const LoginName: string): string;
var n: integer;
begin
  n:=pos('(',LoginName);
  if n=0 then result:=LoginName
  else result:=trim(copy(LoginName,1,n-1));
end;
//==============================================================================
{procedure TfCLTerminal.UpdateRatingAndStats(const N: integer);
var
  i: integer;
  RatingString: string;
  Item: TListItem;
begin
  Item:=lvLogins.Items[N];
  RatingString:=Item.SubItems[4];
  for i:=0 to 3 do
    Item.SubItems[i]:=SubstrN(SubstrN(RatingString,';',FCurrentRType),',',i);
end;}
//==============================================================================
{procedure TfCLTerminal.UpdateAllRatingAndStats;
var i: integer;
begin
  for i:=0 to lvLogins.Items.Count-1 do
    UpdateRatingAndStats(i);
end;}
//==============================================================================
procedure TfCLTerminal.DeleteLvLogins(const LoginID: integer);
var
  index: integer;
begin
  index := FindLvLoginsIndex(LoginID);
  if index <> -1 then 
    lvLogins.Items.Delete(index);
end;
//==============================================================================
{procedure TfCLTerminal.SetLvLoginsRating(const N: integer; const RatingString: string);
var Item: TListItem;
begin
  Item:=lvLogins.Items[N];
  Item.SubItems[4]:=RatingString;
  UpdateRatingAndStats(N);
end;}
//==============================================================================
{procedure TfCLTerminal.SetLvLoginsRating(const Login: string; const RatingString: string);
var
  i: integer;
  itm: TListItem;
  vLogin: string;
begin
  vLogin := lowercase(Login);
  for i := 0 to lvLogins.Items.Count - 1 do begin
    itm := lvLogins.Items[i];
    if lowercase(itm.Caption) = vLogin then
      itm.SubItems[4] := RatingString;
      UpdateRatingAndStats(i);
  end;
end;}
//==============================================================================
procedure TfCLTerminal.AddToLvLogins(const L: TLogin);
 {(const LoginName, Title, RatingString: string;
  nImageIndex: integer; p_OnlineStatus: TOnlineStatus);}
var
  n: integer;
  Item, it: TListItem;
  s: string;
begin
  if Assigned(lvLogins.FindCaption(0, L.LoginWithTitle, false, true, false)) then
    exit;

  n := FindLvLoginPlace(L);
  Item:=lvLogins.Items.Insert(n);

  Item.Caption := GetNameWithTitle(L.Login, L.Title);
  Item.SubItems.Add(IntToStr(L.Rating[fGL.RatingType]));
  Item.SubItems.Add(IntToStr(L.LoginID));
  Item.ImageIndex := L.ImageIndex - 1;
  ShowLvLoginsHint;
end;
//==============================================================================
procedure TfCLTerminal.SetCurrentRType(const RType: integer);
begin
  if RType = FCurrentRType then exit;

  FCurrentRType:=RType;
  LoadLogins;
end;
//==============================================================================
procedure TfCLTerminal.ClearLogin(const Filter, LoginID: Integer);
var
  Login: TCLLogin;
  Index: Integer;
begin
  LoginFilterList.RemoveLoginFilter(LoginID, Filter);
  if CurrentCLFilter.Filter = Filter then
    DeleteLvLogins(LoginID);
end;
//==============================================================================
procedure TfCLTerminal.ClearLogins(const Filter: Integer);
var
  Index: Integer;
  flt: TCLFilter;
begin
  flt:=FilterMgr.GetFilterByNum(Filter);
  if flt.ParentFilter<>nil then flt:=flt.ParentFilter;

  LoginFilterList.ClearFilterID(flt.Filter);
  if CurrentCLFilter = flt then
    lvLogins.Clear;
end;
//==============================================================================
procedure TfCLTerminal.ClearMenuItems;
begin
  { fTerminal }
  while pmCommand.Items.Count > 0 do pmCommand.Items[0].Free;
  { fCLMain }
  while fCLMain.miCommand.Count > 0 do fCLMain.miCommand.Items[0].Free;
end;
//==============================================================================
procedure TfCLTerminal.CloseTab(const Filter: TCLFilter);
var
  n: integer;
  ParentFilter: TCLFilter;
begin
  if Filter = nil then Exit;
  ParentFilter:=Filter.ParentFilter;

  ClearLogins(Filter.Filter);
  ccConsole.FreeFilterID(Filter.Filter);
  FFilterMgr.Filters.Remove(Filter);

  if ParentFilter=nil then begin
    n:=tcMain.Tabs.IndexOfObject(Filter);
    if n>-1 then begin
      tcMain.Tabs.Delete(n);
      tcMain.TabIndex := 0;
      OldTabIndex:=tcMain.TabIndex;
      tcMain.OnChange(nil);
    end;
  end;

  if (ParentFilter<>nil) and (ParentFilter.Key1=fkEvent)
    and not FFilterMgr.HasChildren(Parentfilter)
  then begin
    CloseTab(ParentFilter);
    {n:=tcMain.Tabs.IndexOfObject(ParentFilter);
    if n>-1 then begin
      ccConsole.FreeFilterID(ParentFilter.Filter);
      FFilterMgr.Filters.Remove(ParentFilter);
      tcMain.Tabs.Delete(n);
      tcMain.TabIndex := 0;
      tcMain.OnChange(nil);
    end;}
  end;
end;
//==============================================================================
procedure TfCLTerminal.LoadLogins;
var
  Filter: TCLFilter;
  LF: TLoginFilter;
  L: TLogin;
  i: integer;
begin
  LoadLoginInProgress := true;
  lvLogins.Items.BeginUpdate;
  try
    Filter := CurrentCLFilter;
    if Filter = nil then Exit;

    if Filter.ParentFilter<>nil then
      Filter:=Filter.ParentFilter;

    lvLogins.Items.Clear;
    for i := 0 to LoginFilterList.Count - 1 do begin
      LF := LoginFilterList[i];
      if LF.FilterID = Filter.Filter then begin
        L := fLoginList[LF.LoginID];
        if L = nil then continue;
        AddToLvLogins(L);
      end;
    end;

    LoadLoginInProgress := false;
  finally
    lvLogins.Items.EndUpdate;
  end;
end;
//==============================================================================
procedure TfCLTerminal.ProcessCommand;
var
  Game: TCLGame;
  Filter: TCLFilter;
  s,sColor: string;
  color: TColor;
begin
  s := Trim(edtInput.Text);
  FHistory.Add(s);
  color:=fGL.FontTraits[12].ForeColor;
  sColor:='~'+IntToStr(color);

  if (fCLSocket.InitState < isBeginLogin) or (s = '') then Exit;

  { Filter better not equal nil! }
  Filter := CurrentCLFilter;

  if s[1] = '/' then
    begin
      ccConsole.AddLine(0, edtInput.Text, ltUser);
      ccConsole.EndUpdate;
    end
  else
    begin
      case Filter.Key1 of
       fkConsole: { do nothing };
       fkRoom: s := CMD_STR_TELL + #32 + sColor+ #32 + IntToStr(Filter.Key2) + #32 + s;
       fkTell: s := CMD_STR_TELL + #32 + sColor+ #32 + tcMain.Tabs[tcMain.TabIndex] + #32 + s;
       fkEvent: s := CMD_STR_EVENT_TELL + #32 + sColor+ #32 + IntToStr(Filter.Key2) + #32 + s;
       fkGame:
        begin
          Game := TCLGame(Filter.Key2);
          case cbCmd.ItemIndex of
            0: s := CMD_STR_SAY + #32 + sColor+ #32 + IntToStr(Game.GameNumber) + #32 + s;
            1: s := CMD_STR_KIBITZ + #32 + sColor+ #32 + IntToStr(Game.GameNumber) + #32 + s;
            2: s := CMD_STR_WHISPER + #32 + sColor+ #32 + IntToStr(Game.GameNumber) + #32 + s;
          end;
        end;
      end;
    end;

  fCLSocket.InitState := isRequestSent;
  fCLSocket.InitialSend(s);

  edtInput.Clear;
end;
//==============================================================================
function TfCLTerminal.CreateFilter(const Caption: string;
  const Key1: TCLFilterKey; const Key2: Integer): TCLFilter;
var
  OrgFilter, Index: Integer;
begin
  OrgFilter := ccConsole.FilterID;
  Result := FFilterMgr.CreateFilter(Key1, Key2, Index);
  if Index > tcMain.Tabs.Count then
    Index:=tcMain.Tabs.Count;
  with tcMain.Tabs do if IndexOfObject(Result) < 0 then
    begin
      InsertObject(Index, Caption, Result);
      { Setting the FilterID creates and changes it to that filter. }
      ccConsole.FilterID := Result.Filter;
      { Return to the original Filter. }
      if OrgFilter <> -1 then ccConsole.FilterID := OrgFilter;
    end;

  if (fCLSocket.InitState >= isRequestSent) and (Key1 <> fkTell)
    and not ( (Key1 = fkRoom) and (Key2 = 3) and (fCLSocket.InitState = isReceivingData))
  then
    begin
      tcMain.TabIndex := Index;
      OldTabIndex:=tcMain.TabIndex;
      tcMain.OnChange(nil);
    end;
  ShowFilterGame;
end;
//==============================================================================
procedure TfCLTerminal.AddLine(const Key1: TCLFilterKey; const Key2: Integer;
  const Line: string; const LineTrait: TLineTrait; const Color: TColor = -1);
var
  Filter: TCLFilter;
  Clean: Boolean;
begin
  Filter := FFilterMgr.GetFilter(Key1, Key2);
  if Filter = nil then Exit;

  Clean := not Filter.Dirty;
  Filter.Dirty := (Filter <> CurrentCLFilter);
  ccConsole.AddLine(Filter.Filter, Line, LineTrait, Color);
  if Filter.Dirty and Clean then tcMain.Repaint;
end;
//==============================================================================
procedure TfCLTerminal.AddLoginFilter(Key1: TCLFilterKey; Key2, LoginID: integer);
var
  Filter: TCLFilter;
  L: TLogin;
begin
  Filter := FFilterMgr.GetFilter(Key1, Key2);
  LoginFilterList.AddLoginFilter(LoginID, Filter.Filter);
  L := fLoginList[LoginID];
  if not FLoginsUpdating and (Filter=CurrentCLFilter) and Assigned(L) then begin
    //AddToLvLogins(L.Login,L.Title, L.RatingString, L.ImageIndex, L.OnlineStatus);
    //SortLvLoginsCurrent;
    //LoadLogins;
    AddToLvLogins(L);
  end;
end;
//==============================================================================
procedure TfCLTerminal.AssignFont;
var
  Index: Integer;
begin
  with ccConsole do
    begin
      Color := fGL.ConsoleColor;
      Font.Assign(fGL.ConsoleFont);
      for Index := 0 to High(fGL.FontTraits) do
        FontTraits[TLineTrait(Index)] := fGL.FontTraits[Index];
    end;

  with ccAnnounce do
    begin
      Color := fGL.ConsoleColor;
      Font.Color := fGL.FontTraits[0].ForeColor;
      Font.Style := fGL.FontTraits[0].FontStyle;
      Font.Size := ccConsole.Font.Size;
      for Index := 0 to High(fGL.FontTraits) do
        FontTraits[TLineTrait(Index)] := fGL.FontTraits[Index];
    end;

  with edtInput do
    begin
      Color := fGL.ConsoleColor;
      Font.Name := fGL.ConsoleFont.Name;
      Font.Color := fGL.ConsoleTextColor;
      Font.Size := ccConsole.Font.Size;
    end;

  with cbCmd do
    begin
      Color := fGL.ConsoleColor;
      Font.Color := fGL.ConsoleTextColor;
    end;

  with lvLogins do
    begin
      Color := fGL.ConsoleColor;
      Font.Color := fGL.ConsoleTextColor;
    end;
  Refresh;
end;
//==============================================================================
procedure TfCLTerminal.ClearLogins;
begin
  LoginFilterList.Clear;
  lvLogins.Items.Clear;
end;
//==============================================================================
procedure TfCLTerminal.ClearObservers(const Game: Integer);
var
  Filter: TCLFilter;
begin
  { Called when a DP_GAME_PERISH is issued. }
  Filter := FFilterMgr.GetFilter(fkGame, Game);
  if Filter = nil then Exit;
  ClearLogins(Filter.Filter);
  if Filter = CurrentCLFilter then
    lvLogins.Items.Clear;
end;
//==============================================================================
procedure TfCLTerminal.CloseTab(const Key1: TCLFilterKey; const Key2: Integer);
var
  Filter: TCLFilter;
begin
  try
    Filter := FFilterMgr.GetFilter(Key1, Key2);
    CloseTab(Filter);
  except
  end;
end;
//==============================================================================
procedure TfCLTerminal.CMD_OnlineStatus(CMD: TStrings);
var
  LoginID: integer;
  NewStatus: TOnlineStatus;
  L: TLogin;
begin
  LoginID := StrToInt(CMD[1]);
  NewStatus := TOnlineStatus(StrToInt(CMD[2]));

  L := fLoginList[LoginID];
  if L = nil then exit;
  if L.OnlineStatus = NewStatus then exit;

  L.OnlineStatus := NewStatus;
  lvLogins.Repaint;
end;
//==============================================================================
procedure TfCLTerminal.CMD_PmExit(CMD: TStrings);
var
  Filter: TCLFilter;
begin
  Filter := FFilterMgr.GetFilter(fkTell, StrToInt(CMD[1]));
  if Filter <> nil then
    ClearLogin(Filter.Filter, StrToInt(CMD[1]));
end;
//==============================================================================
function TfCLTerminal.CompareLvLogins(L: TLogin; Index: integer): integer;
var
  itm: TListItem;
  s: string;
  r: integer;
begin
  itm := lvLogins.Items[Index];
  if itm = nil then begin
    result := 1;
    exit;
  end;

  if fGL.OrdType = SORT_NAME then begin
    s := lowercase(L.LoginWithTitle);
    if s > lowercase(itm.Caption) then result := -1
    else if s = lowercase(itm.Caption) then result := 0
    else result := 1;
  end else if fGL.OrdType = SORT_RATING then begin
    r := StrToInt(itm.SubItems[0]);
    if L.Rating[fGL.RatingType] > r then result := -1
    else if L.Rating[fGL.RatingType] = r then  result := 0
    else result := 1;
  end;

  if fGL.OrdDirection = 1 then
    result := - result;
end;
//==============================================================================
procedure TfCLTerminal.CreateMenuItems;
var
  i,Counter: Integer;
  NewItem: TMenuItem;
begin
  ClearMenuItems;

  for i:=0 to pmConsole.Items.Count-1 do
    begin
      NewItem:=TMenuItem.Create(pmCommand);
      NewItem.Caption:=pmConsole.Items[i].Caption;
      NewItem.OnClick:=pmConsole.Items[i].OnClick;
      pmCommand.Items.Add(NewItem);
    end;

  NewItem:=TMenuItem.Create(pmCommand);
  NewItem.Caption:='-';
  pmCommand.Items.Add(NewItem);

  for Counter := 0 to fGL.Commands.Count -1 do
    begin
      NewItem := TMenuItem.Create(pmCommand);
      with NewItem do
        begin
          Caption := TCommand(fGL.Commands[Counter]).Caption;
          Tag:=Counter;
          OnClick := SendCommand;
          if (Counter > 0) and (Counter Mod 20 = 0) then
            Break := mbBarBreak;
          pmCommand.Items.Add(NewItem);
        end;
      NewItem := TMenuItem.Create(fCLMain.miCommand);
      with NewItem do
        begin
          Caption := TCommand(fGL.Commands[Counter]).Caption;
          Tag:=Counter;
          OnClick := SendCommand;
          fCLMain.miCommand.Add(NewItem);
        end;
    end;

  SetMenuState;
end;
//==============================================================================
{ DP_LOGIN2: DP#, LoginID, Login, Title }
{procedure TfCLTerminal.Login2(const Datapack: TStrings);
var
  Filter: TCLFilter;
  AdminLevel, LoginID, ImageIndex: integer;
  Master, AdminGreated: Boolean;
  MembershipType: TMembershipType;
  Created: TDateTime;
  ProvString, Login, Title, RatingString: string;
begin
  Filter := FFilterMgr.GetFilter(fkConsole, 0);
  if Filter = nil then Exit;
  LoginID := StrToInt(Datapack[1]);
  Login := Datapack[2];
  Title := Datapack[3];
  RatingString := Datapack[4];
  ImageIndex := StrToInt(Datapack[5]);
  AdminLevel := StrToInt(Datapack[6]);
  Master := Datapack[7] = '1';
  Created := Str2Float(Datapack[8]);
  AdminGreated := Datapack[9] = '1';

  if Datapack.Count >= 11 then ProvString := Datapack[10]
  else ProvString := ProvStringByRatingString(RatingString);

  if Datapack.Count >= 12 then MembershipType := TMembershipType(StrToInt(Datapack[11]))
  else MembershipType := mmbTrial;

  AddLogin(Filter, LoginID, Login, Title, RatingString,
    ImageIndex, AdminLevel, Master, Created, ProvString, MembershipType);

  if Datapack[5] = '1' then
    fCLNotify.AddAdmin(Login,Title);

  if Master then
    fCLNotify.AddMaster(Login,Title);

  if Date-60 < Created then
    fCLNotify.AddNewUser(Login, Title, Trunc(Date-Created+1), AdminGreated);

  if Login = fCLSocket.MyName then
    fCLSocket.SetMyRating(RatingString, ProvString);

  if not FLoginsUpdating then fGL.PlayCLSound(SI_PLAYER_ARRIVED);
end;             }
//==============================================================================
{ DP_LOGIN_BEGIN: DP# }
procedure TfCLTerminal.LoginBegin;
var
  Filter: TCLFilter;
begin
  Filter := FFilterMgr.GetFilter(fkConsole, 0);
  ClearLogins(Filter.Filter);
  FLoginsUpdating := True;
end;
//==============================================================================
{ DP_LOGIN_END: DP#}
procedure TfCLTerminal.LoginEnd;
var
  Filter: TCLFilter;
begin
  Filter := FFilterMgr.GetFilter(fkConsole, 0);
  FLoginsUpdating := False;
  if Filter = CurrentCLFilter then LoadLogins;
end;
//==============================================================================
{ DP_LOGOFF: DP#, LoginID, Login, Title }
procedure TfCLTerminal.LogOff(const Datapack: TStrings);
var
  Filter: TCLFilter;
  Index: Integer;
begin
  Index := StrToInt(Datapack[1]);
  { Console }
  Filter := FFilterMgr.GetFilter(fkConsole, 0);
  ClearLogin(Filter.Filter, Index);

  { Possible tell tabs. }
  Filter := FFilterMgr.GetFilter(fkTell, Index);
  if Filter <> nil then ClearLogin(Filter.Filter, Index);
  fCLNotify.RemoveUser(Datapack[2],Datapack[3]);
end;
//==============================================================================
{ DP_OBSERVER: DP#, GameNumber, LoginID, Login, Title }
procedure TfCLTerminal.Observer(const Datapack: TStrings);
var
  Game: TCLGame;
  s,sEventUserState: string;
  ID, LoginID: integer;
begin
  if Datapack.Count>6 then s:=Datapack[6]
  else s:='g';

  ID := StrToInt(Datapack[1]);
  LoginID := StrToInt(Datapack[2]);
  if s='g' then begin
    Game := fCLBoard.Game(ID);
    AddLoginFilter(fkGame, Integer(Game), LoginID);
  end else begin
    AddLoginFilter(fkEvent, ID, LoginID);
    fCLEvents.OnObserver(
      StrToInt(Datapack[1]),StrToInt(Datapack[2]),
      Datapack[3],Datapack[4],Datapack[5],
      TCSEventUserState(StrToInt(Datapack[7])));
  end;

  if (s='g') and (lowercase(Game.BlackName) = lowercase(FollowedPlayer))
    and (lowercase(Game.WhiteName) <> lowercase(FollowedPlayer))
    and (lowercase(Game.WhiteName) <> lowercase(fCLSocket.MyName))
  then
    Game.Inverted:=true;
end;
//==============================================================================
{ DP_OBSERVER_BEGIN: DP#, GameNumber }
procedure TfCLTerminal.ObserverBegin(const Datapack: TStrings);
var
  Game: TCLGame;
  Filter: TCLFilter;
  s: string;
begin
  if Datapack.Count>2 then s:=Datapack[2]
  else s:='g';
  if s='g' then begin
    Game := fCLBoard.Game(StrToInt(Datapack[1]));
    Filter := FFilterMgr.GetFilter(fkGame, Integer(Game));
  end else
    Filter:=FFilterMgr.GetFilter(fkEvent, StrToInt(Datapack[1]));
  ClearLogins(Filter.Filter);
  FLoginsUpdating := True;
end;
//==============================================================================
{ DP_OBSERVER_END: DP#, GameNumber }
procedure TfCLTerminal.ObserverEnd(const Datapack: TStrings);
var
  Game: TCLGame;
  Filter: TCLFilter;
  s: string;
begin
  if Datapack.Count>2 then s:=Datapack[2]
  else s:='g';
  if s='g' then begin
    Game := fCLBoard.Game(StrToInt(Datapack[1]));
    Filter := FFilterMgr.GetFilter(fkGame, Integer(Game));
  end else
    Filter:=FFilterMgr.GetFilter(fkEvent, StrToInt(Datapack[1]));
  FLoginsUpdating := False;
  if Filter = CurrentCLFilter then LoadLogins;
end;
//==============================================================================
procedure TfCLTerminal.OnNewLogin(p_Login: TLogin);
var
  Filter: TCLFilter;
begin
  Filter := FFilterMgr.GetFilter(fkConsole, 0);
  if Filter = nil then exit;
  if not LoginFilterList.Exists(p_Login.LoginID, Filter.Filter) then
    LoginFilterList.AddLoginFilter(p_Login.LoginID, Filter.Filter);
end;
//==============================================================================
{DP_ROOM_ENTER: DP#, RoomNumber, LoginID, Login }
procedure TfCLTerminal.RoomEnter(const Datapack: TStrings);
var
  RoomID: integer;
  LoginID: integer;
begin
  RoomID := StrToInt(Datapack[1]);
  LoginID := StrToInt(Datapack[2]);
  AddLoginFilter(fkRoom, RoomID, LoginID);
end;
//==============================================================================
{DP_ROOM_EXIT: DP#, RoomNumber, LoginID, Login }
procedure TfCLTerminal.RoomExit(const Datapack: TStrings);
var
  Filter: TCLFilter;
begin
  Filter := FFilterMgr.GetFilter(fkRoom, StrToInt(Datapack[1]));
  ClearLogin(Filter.Filter, StrToInt(Datapack[2]));
end;
//==============================================================================
{ DP_ROOM_BEGIN: DP#, RoomNumber }
procedure TfCLTerminal.RoomSetBegin(const Datapack: TStrings);
var
  Filter: TCLFilter;
begin
  Filter := FFilterMgr.GetFilter(fkRoom, StrToInt(Datapack[1]));
  ClearLogins(Filter.Filter);
  FLoginsUpdating := True;
end;
//==============================================================================
{ DP_ROOM_END: DP#, RoomNumber }
procedure TfCLTerminal.RoomSetEnd(const Datapack: TStrings);
var
  Filter: TCLFilter;
begin
  Filter := FFilterMgr.GetFilter(fkRoom, StrToInt(Datapack[1]));
  FLoginsUpdating := False;
  if Filter = CurrentCLFilter then LoadLogins;
end;
//==============================================================================
procedure TfCLTerminal.SetMenuState;
var
  Index: Integer;
  b: Boolean;
begin
  { The Command menu items. }
  for Index := 0 to pmCommand.Items.Count -1 do
    pmCommand.Items[Index].Enabled := fCLSocket.InitState >= isLoginComplete;

  for Index := 0 to fCLMain.miCommand.Count-1 do
    fCLMain.miCommand[Index].Enabled := fCLSocket.InitState >= isLoginComplete;
  { The Login menu items. }
  b:=lvLogins.ItemFocused<>nil{clLogins.ItemIndex > -1};
  miAddFriend.Enabled := b; { TODO check existing friend }
  miAddCensor.Enabled := b; { TODO check existing censor }
  miInclude.Enabled := b; { TODO check the game mode.}
  miInvite.Enabled := (b) and (fCLRooms.RoomCreator);
  miMatch.Enabled := b;
  miMessage.Enabled := b;
  miProfile.Enabled := b;
  miTell.Enabled := b;
  miObserve.Enabled := b;
  miFollow.Enabled := b;
  miUnfollow.Enabled := b and FFollowing;
  miScore.Enabled := b and (RemoveTitle(lvLogins.ItemFocused.Caption)<>fCLSocket.MyName);
  miAdmin.Visible := b and (fCLSocket.MyAdminLevel >= 2);

  miMute1Week.Enabled := (fCLSocket.MyAdminLevel >= 3);
  miMute1Month.Enabled := (fCLSocket.MyAdminLevel >= 3);
  miMuteForever.Enabled := (fCLSocket.MyAdminLevel >= 3);
  miBan1Week.Enabled := (fCLSocket.MyAdminLevel >= 3);
  miBan1Month.Enabled := (fCLSocket.MyAdminLevel >= 3);
  miBanForever.Enabled := (fCLSocket.MyAdminLevel >= 3);
end;
//==============================================================================
procedure TfCLTerminal.ShowTab(const Game: TCLGame);
var
  Index: Integer;
begin
  for Index := 0 to tcMain.Tabs.Count -1 do
    if CurrentCLFilter.Key2 = Integer(Game) then
      begin
        tcMain.TabIndex := Index;
        tcMain.OnChange(nil);
        Break;
      end;
end;
//==============================================================================
{DP_TELL_LOGIN: DP#, (from)LoginID, (from)Login, (from) Title,
(reciprocate)LoginID, (reciprocate)Login, (reciprocate)Title, Message }
procedure TfCLTerminal.Tell(const CMD: TStrings);
var
  Filter: TCLFilter;
  FromLoginID, RecipLoginID: integer;
  FromLogin, FromTitle, RecipLogin, RecipTitle, msg: string;
  color: TColor;
begin
  FromLoginID := StrToInt(CMD[1]);
  FromLogin := CMD[2];
  FromTitle := CMD[3];
  RecipLoginID := StrToInt(CMD[4]);
  RecipLogin := CMD[5];
  RecipTitle := CMD[6];
  msg := CMD[7];
  // CMD[8] - rating string, obsolete parameter
  color := StrToInt(CMD[9]);

  Filter := CreateFilter(RecipLogin, fkTell, RecipLoginID);
  AddLoginFilter(Filter.Key1, Filter.Key2, RecipLoginID);
  AddLoginFilter(Filter.Key1, Filter.Key2, fCLSocket.MyLoginID);
  AddLine(fkTell, RecipLoginID, GetNameWithTitle(FromLogin, FromTitle) + ': ' + msg,
    ltTellLogin, color);

  { CreateFilter will not change the tab if it's a tell. But if we're the one
    initiating the tell, we do want the tab to change. }
  if FromLoginID = fCLSocket.MyLoginID then begin
    tcMain.TabIndex := tcMain.Tabs.IndexOfObject(Filter);
    tcMain.OnChange(nil);
  end;
end;
//==============================================================================
{ DP_UNOBSERVER: DP#, GameNumber, LoginID, Login, Title}
procedure TfCLTerminal.UnObserver(const Datapack: TStrings);
var
  Game: TCLGame;
  Filter: TCLFilter;
  mode,UserName,UserTitle: string;
  ID,UserId: integer;
begin
  if Datapack.Count<5 then exit;
  try
    ID:=StrToInt(Datapack[1]);
    UserId:=StrToInt(Datapack[2]);
  except
    exit;
  end;

  UserName:=Datapack[3];
  UserTitle:=Datapack[4];
  if Datapack.Count>5 then mode:=Datapack[5]
  else mode:='g';

  if mode='g' then begin
    Game := fCLBoard.Game(ID);
    Filter := FFilterMgr.GetFilter(fkGame, Integer(Game));
  end else begin
    Filter:=FFilterMgr.GetFilter(fkEvent, ID);
    fCLEvents.OnUnobserver(ID,UserID);
  end;

  if not Assigned(Filter) then exit;
  ClearLogin(Filter.Filter, UserID);
end;
//==============================================================================
procedure TfCLTerminal.ccConsoleClick(Sender: TObject);
var
  Link: string;
begin
  try
  Link := (Sender as TCLConsole).Hyperlink;
  if Link <> '' then
    begin
      if (Pos('http://', Link) = 1) or (Pos('www.', Link) = 1) then
        ShellExecute(Handle, 'open', PChar(Link), '', '', SW_SHOWNORMAL)
      else
        begin
          fCLSocket.InitState := isRequestSent;
          fCLSocket.InitialSend(Link);
        end;
    end;
  except
  end;
end;
//==============================================================================
procedure TfCLTerminal.ccConsoleKeyPress(Sender: TObject; var Key: Char);
begin
  edtInput.SetFocus;
end;
//==============================================================================
procedure TfCLTerminal.edtInputKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13: { Return }
      begin
        Key := #0;
        ProcessCommand;
      end;
    #27: { Esc }
      begin
        Key := #0;
        edtInput.Clear;
      end;
  end; {case of}
end;
//==============================================================================
procedure TfCLTerminal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Release the menu items we created }
  ClearMenuItems;
  FFilterMgr.Free;
  lvLogins.Items.Clear;
  Action := caFree;
  FHistory.Free;
  slAnnounce.Free;
  LoginFilterList.Free;
end;
//==============================================================================
procedure TfCLTerminal.FormCreate(Sender: TObject);
var
  Filter: TCLFilter;
begin
  FHistory:=TCLHistory.Create;
  slAnnounce := TStringList.Create;
  LoginFilterList := TLoginFilterList.Create;
  annState.State := asBlinking;
  annState.Visible := true;
  annState.Ticks := 0;
  annState.Counter := 0;
  annState.Start := 0;
  annState.MouseX := -1;
  annState.ScrollingEnabled := true;

  AssignFont;
  CreateMenuItems;
  ccConsole.CustomCursor := crIEHand;
  ccAnnounce.CustomCursor := crIEHand;

  { Calc the Y reference position for the bitmap and text on the tabs. }
  FTabBitmapY := (tcMain.TabHeight - tcMain.Images.Height) div 2;
  FTabTextY := ((tcMain.TabHeight - tcMain.Canvas.TextHeight('Ag')) div 2) -1;

  FFilterMgr := TCLFilterManager.Create;
  Filter := CreateFilter('Console', fkConsole, 0);
  ccConsole.FilterID := Filter.Filter;
  ccAnnounce.FilterID := 0;
  CurrentRType := fGL.RatingType;
  ccConsole.UserColor:=fGL.UserColorChat;

  ShoutMuted := False;
  SetFontSize(fGL.ConsoleFont.Size);
end;
//==============================================================================
procedure TfCLTerminal.miAddFriendClick(Sender: TObject);
begin
  if lvLogins.ItemFocused <> nil then
    fCLSocket.InitialSend([CMD_STR_NOTIFY_ADD, RemoveTitle(lvLogins.ItemFocused.Caption)]);
end;
//==============================================================================
procedure TfCLTerminal.miAddCensorClick(Sender: TObject);
begin
  if lvLogins.ItemFocused <> nil then
    fCLSocket.InitialSend([CMD_STR_CENSOR_ADD, RemoveTitle(lvLogins.ItemFocused.Caption),
      IntToStr((Sender as TMenuItem).Tag)]);
end;
//==============================================================================
procedure TfCLTerminal.miIncludeClick(Sender: TObject);
begin
  if lvLogins.ItemFocused <> nil then
    fCLSocket.InitialSend([CMD_STR_INCLUDE, RemoveTitle(lvLogins.ItemFocused.Caption)]);
end;
//==============================================================================
procedure TfCLTerminal.miInviteClick(Sender: TObject);
begin
  if lvLogins.ItemFocused <> nil then
    fCLRooms.ShowInviteDialog(RemoveTitle(lvLogins.ItemFocused.Caption));
end;
//==============================================================================
procedure TfCLTerminal.miMatchClick(Sender: TObject);
begin
  if lvLogins.ItemFocused <> nil then
    fCLMain.ShowMatchDialog(RemoveTitle(lvLogins.ItemFocused.Caption));
end;
//==============================================================================
procedure TfCLTerminal.miMessageClick(Sender: TObject);
begin
  if lvLogins.ItemFocused <> nil then
    fCLMessages.ShowMessageDialog(RemoveTitle(lvLogins.ItemFocused.Caption), '');
end;
//==============================================================================
procedure TfCLTerminal.miProfileClick(Sender: TObject);
begin
  if lvLogins.ItemFocused <> nil then
    fCLSocket.InitialSend([CMD_STR_PROFILE, RemoveTitle(lvLogins.ItemFocused.Caption)]);
end;
//==============================================================================
procedure TfCLTerminal.pmLoginsPopup(Sender: TObject);
begin
  SetMenuState;
end;
//==============================================================================
procedure TfCLTerminal.sbCloseClick(Sender: TObject);
var
  Filter: TCLFilter;
  s: string;
begin
  Filter := CurrentCLFilter;
  { Needs to proceed the CloseTab call. CloseTab frees Filter. }
  case Filter.Key1 of
    fkRoom: s := CMD_STR_EXIT;
    fkTell: s := CMD_STR_PM_EXIT;
  else
    exit;
  end;

  s := s + #32 + IntToStr(Filter.Key2);
  fCLSocket.InitialSend(s);
  CloseTab(Filter);
end;
//==============================================================================
procedure TfCLTerminal.sbMaxClick(Sender: TObject);
begin
  Self.SetFocus;
  fCLMain.miMaximizeBottom.Click;
end;
//==============================================================================
procedure TfCLTerminal.SendCommand(Sender: TObject);
var
  Command: string;
begin
  Command :=  TCommand(fGL.Commands[TMenuItem(Sender).Tag]).Command;
  ccConsole.AddLine(0, Command, ltUser);
  ccConsole.EndUpdate;
  fCLSocket.InitialSend([Command]);
end;
//==============================================================================
procedure TfCLTerminal.tcMainChange(Sender: TObject);
var
  Game: TCLGame;
  Filter: TCLFilter;
  ad: TAdultType;
begin
  Filter := CurrentCLFilter;
  if Filter=nil then exit;
  if (fCLSocket.InitState <> isReceivingData) and (Filter.Key1 = fkRoom)
    and (Filter.Key2 = 3) and (ADULT = adtNone) then
  begin
    if MessageDlg(
      'This is not moderated room. '+#10#13+
      'Are you sure you''re 18 years or older?',mtWarning,[mbYes,mbNo],0) = mrYes
    then
      ad:=adtAdult
    else
      ad:=adtChild;
    fCLSocket.InitialSend([CMD_STR_ADULT,fCLSocket.MyName,IntToStr(ord(ad))]);
    if ad = adtChild then begin
      tcMain.TabIndex := OldTabIndex;
      exit;
    end;
  end;

  ccConsole.FilterID := Filter.Filter;
  sbClose.Enabled := Filter.Key1 in [fkRoom, fkTell];
  cbCmd.Enabled := Filter.Key1 in [fkGame,fkEvent];
  //if Filter.

  if Filter.Key1 in [fkGame] then
    begin
      Game := TCLGame(Filter.Key2);
      if Game.SayMode<>-1 then cbCmd.ItemIndex:=Game.SayMode
      else begin
        case Game.GameMode of
          gmNone: cbCmd.ItemIndex := -1; { disabled. }
          gmCLSLive: cbCmd.ItemIndex := 0; { say }
          gmCLSExamine, gmCLSObEx: cbCmd.ItemIndex := 1; { kibitz }
          gmCLSObserve: cbCmd.ItemIndex := 2; { whisper }
        end;
      end;
    end
  else
    cbCmd.ItemIndex := -1;

  if Filter.Dirty then
    begin
      Filter.Dirty := False;
      tcMain.Repaint;
    end;

  LoadLogins;
  OldTabIndex:=tcMain.TabIndex;
end;
//==============================================================================
procedure TfCLTerminal.tcMainDrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  Filter: TCLFilter;
  R: TRect;
  ImageIndex: Integer;
begin
  { Filter holds the Dirty flag needed to customize the drawing. }
  Filter := TCLFilter(tcMain.Tabs.Objects[TabIndex]);//CurrentCLFilter;
  if Filter = nil then Exit;

  { Draw the tab a different shade if the is unviewed text in that tab. }
  with tcMain.Canvas do
    if Filter.Dirty then
      begin
        Brush.Color := clHighLight;
        Font.Color := clHighLightText;
      end
    else
      begin
        Brush.Color := clBtnFace;
        Font.Color := clWindowText;
      end;

  { Determine the bitmap for the tab. }
  case Filter.Key1 of
    fkConsole: ImageIndex := 10;
    fkRoom: ImageIndex := 3;
    fkTell: ImageIndex := 1;
    fkGame,fkEvent: ImageIndex := 11;
  end;

  { The paramater Rect is too large, adjust it to fit inside the tab. }
  R := Rect;
  InflateRect(R, -1, 0);
  R.Bottom := R.Bottom -3;
  with tcMain.Canvas do
    begin
      Brush.Style := bsSolid;
      FillRect(R);
      { Set the brush style to clear so Textout won't draw shadow colors
        that might fall outside the boundry of our R(ect) }
      Brush.Style := bsClear;
    end;

  { Draw the bitmap. }
  R := Rect;
  if Active then
    InflateRect(R, -8, -(FTabBitMapY + 4))
  else
    InflateRect(R, -4, -(FTabBitMapY - 2));
  tcMain.Images.Draw(tcMain.Canvas, R.Left, R.Top, ImageIndex);

  { Draw the text. }
  R := Rect;
  if Active then
    InflateRect(R, -(tcMain.Images.Width + 12), -(FTabTextY + 4))
  else
    InflateRect(R, -(tcMain.Images.Width + 8), -(FTabTextY - 2));
  tcMain.Canvas.TextOut(R.Left, R.Top, tcMain.Tabs[TabIndex]);
end;
//==============================================================================
procedure TfCLTerminal.LvLoginsDelete(const LoginName: string);
var n: integer;
begin
  n:=LvLoginsIndex(LoginName);
  if n<>-1 then
    lvLogins.Items.Delete(n);
  ShowLvLoginsHint;
end;
//==============================================================================
function TfCLTerminal.LvLoginsIndex(const LoginName: string): integer;
var
  i: integer;
  Item: TListItem;
begin
  for i:=0 to lvLogins.Items.Count-1 do
    begin
      Item:=lvLogins.Items[i];
      if lowercase(RemoveTitle(Item.Caption))=lowercase(LoginName) then
        begin
          result:=i;
          exit;
        end;
    end;
  result:=-1;
end;
//==============================================================================
{ DP_RATING2: Login, RatingString, ProvString }
procedure TfCLTerminal.ReceiveRating2(const Datapack: TStrings);
var
  RatingString, ProvString: string;
  LoginID: integer;
  L: TLogin;
begin

  LoginID := StrToInt(Datapack[1]);
  RatingString := Datapack[2];
  ProvString := Datapack[3];

  L := fLoginList[LoginID];
  if L = nil then exit;

  L.RatingString := RatingString;
  L.ProvString := ProvString;

  //SetLVLoginsRating(L.Login, L.RatingString);
  //LoadLogins;
  //DeleteLvLogins(L.LoginID);
  //AddToLvLogins(L);
  SetLvLoginsRating(L);

  if L.Login = fCLSocket.MyName then
    fCLSocket.SetMyRating(RatingString, ProvString);
end;
//==============================================================================
procedure TfCLTerminal.miTellClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_TELL, RemoveTitle(lvLogins.ItemFocused.Caption), 'Hi!']);
end;
//==============================================================================
procedure TfCLTerminal.miObserveClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_OBSERVE, RemoveTitle(lvLogins.ItemFocused.Caption)]);
end;
//==============================================================================
procedure TfCLTerminal.FollowEnd(const Datapack: TStrings);
begin
  ccConsole.AddLine(-1, 'You are following nobody now.', ltMessage);
  FFollowing:=false;
  FFollowedPlayer:='';
  miUnfollow.Enabled:=(lvLogins.ItemFocused<>nil) and FFollowing;
end;
//==============================================================================
procedure TfCLTerminal.FollowStart(const Datapack: TStrings);
var s: string;
begin
  if Datapack.Count<2 then exit;
  s:=Format('You are now following %s. Click "/unfollow" to cancel.',[Datapack[1]]);
  ccConsole.AddLine(-1, s, ltMessage);
  FFollowing:=true;
  FollowedPlayer:=Datapack[1];
  miUnfollow.Enabled:=(lvLogins.ItemFocused<>nil) and FFollowing;
end;
//==============================================================================
procedure TfCLTerminal.miFollowClick(Sender: TObject);
begin
  if lvLogins.ItemFocused <> nil then
    fCLSocket.InitialSend([CMD_STR_FOLLOW, RemoveTitle(lvLogins.ItemFocused.Caption)]);
end;
//==============================================================================
procedure TfCLTerminal.SortLvLogins(OrdType, OrdDirection: integer);
var
  i,n: integer;
begin
  for i:=0 to LvLogins.Items.Count-1 do begin
    n:=FindLvLoginsMin(i,OrdType,OrdDirection);
    if n<>i then begin
      LvLogins.Items.Insert(i);
      MoveListViewItemToExists(LvLogins,n+1,i);
    end;
  end;
end;
//==============================================================================
function TfCLTerminal.LvLoginsCompare(FromNum, ToNum, OrdType,
  OrdDirection: integer): integer;
// OrdDirection: 0 - direct, 1 - backward sorting direction
var Item1, Item2: TListItem;
begin
  Item1:=LvLogins.Items[FromNum];
  Item2:=LvLogins.Items[ToNum];
  case OrdType of
    SORT_NAME: result:=CompareVars(LowerCase(Item1.Caption),LowerCase(Item2.Caption));
    SORT_RATING: result:=CompareVars(StrToInt(Item1.SubItems[0]),StrToInt(Item2.SubItems[0]));
  end;
  if OrdDirection=1 then result:=-result;
end;
//==============================================================================
function TfCLTerminal.FindLvLoginPlace(const L: TLogin): integer;
var
  i: integer;
begin
  for i := 0 to lvLogins.Items.Count - 1 do
    if CompareLvLogins(L, i) > -1 then begin
      result := i;
      exit;
    end;
  result := lvLogins.Items.Count;
end;
//==============================================================================
function TfCLTerminal.FindLvLoginsIndex(const LoginID: integer): integer;
var
  i: integer;
  itm: TListItem;
begin
  for i := 0 to lvLogins.Items.Count - 1 do begin
    itm := lvLogins.Items[i];
    if StrToInt(itm.SubItems[1]) = LoginID then begin
      result := i;
      exit;
    end;
  end;
  result := -1;
end;
//==============================================================================
function TfCLTerminal.FindLvLoginsMin(Start,OrdType,OrdDirection: integer): integer;
var
  i: integer;
begin
  result:=Start;
  for i:=Start+1 to LvLogins.Items.Count-1 do begin
    if LvLoginsCompare(result,i,OrdType,OrdDirection)=-1 then
      result:=i;
  end;
end;
//==============================================================================
procedure TfCLTerminal.SortLvLoginsCurrent;
begin
  SortLvLogins(fGL.OrdType,fGL.OrdDirection);
end;
//==============================================================================
procedure TfCLTerminal.cbCmdChange(Sender: TObject);
var
  Game: TCLGame;
  Filter: TCLFilter;
begin
  Filter := CurrentCLFilter;
  if Filter.Key1 = fkGame then
    begin
      Game := TCLGame(Filter.Key2);
      Game.SayMode := cbCmd.ItemIndex;
    end;
end;
//==============================================================================
procedure TfCLTerminal.miUnfollowClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_UNFOLLOW]);
end;
//==============================================================================
procedure TfCLTerminal.miClearConsoleClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to clear?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    CCConsole.ClearText;
end;
//==============================================================================
procedure TfCLTerminal.miClipboardConsoleClick(Sender: TObject);
begin
  ClipBoard.Astext:=CCConsole.GetText;
end;
//==============================================================================
procedure TfCLTerminal.miSaveConsoleClick(Sender: TObject);
var
  sl: TStringList;
  sv: TSaveDialog;
begin
  sv:=TSaveDialog.Create(nil);
  sl:=TStringList.Create;
  try
    sv.InitialDir:=MAIN_DIR;
    sv.Defaultext:='txt';
    sv.Filter:='*.txt';
    if sv.Execute then begin
      sl.Text:=CCConsole.GetText;
      sl.SaveToFile(sv.FileName);
    end;
  finally
    sl.Free;
    sv.Free;
  end;
end;
//==============================================================================
procedure TfCLTerminal.ShowLvLoginsHint;
var s: string;
begin
  if lvLogins.Items.Count mod 10 = 1 then s:='player'
  else s:='players';

  lvLogins.Hint:=Format('%d %s',[lvLogins.Items.Count,s]);
end;
//==============================================================================
procedure TfCLTerminal.EventExit(ID: integer);
var
  Filter: TCLFilter;
  ev: TCSEvent;
  game: TCLGame;
begin
  Filter := FFilterMgr.GetFilter(fkEvent, ID);

  CloseTab(Filter);
end;
//==============================================================================
function TfCLTerminal.CreateChildFilter(const Key1: TCLFilterKey;
  const Key2: Integer; const ParentKey1: TCLFilterKey;
  const ParentKey2: Integer;
  const ParentCaption: string): TCLFilter;
var
  ParentFilter: TCLFilter;
begin
  ParentFilter:=FFilterMgr.GetFilter(ParentKey1,ParentKey2);
  if ParentFilter = nil then
    ParentFilter := CreateFilter(ParentCaption,ParentKey1,ParentKey2);

  Result := FFilterMgr.CreateChildFilter(Key1, Key2, ParentKey1, ParentKey2);
end;
//==============================================================================
function TfCLTerminal.GetCurrentCLFilter: TCLFilter;
var
  ev: TCSEvent;
  game: TCLGame;
begin
  result:=TCLFilter(tcMain.Tabs.Objects[tcMain.TabIndex]);
  if result=nil then exit;
  if result.Key1=fkEvent then begin
    ev:=fCLEvents.FindEvent(result.Key2);
    if ev=nil then exit;
    if (ev.ActiveGameNum<>-1) and (ev.ActiveGameNum<ev.Games.Count) then begin
      game:=ev.Games[ev.ActiveGameNum];
      result:=FilterMgr.GetFilter(fkGame,Integer(game));
    end;
  end;
end;
//==============================================================================
{ TCLHistory }
//==============================================================================
procedure TCLHistory.Add(Str: string);
var
  LastCmd: string;
begin
  if Str='' then exit;
  if sl.Count=0 then LastCmd:=''
  else LastCmd:=sl[sl.Count-1];

  if Str<>LastCmd then sl.Add(Str);
  Last;
end;
//==============================================================================
constructor TCLHistory.Create;
begin
  sl:=TStringList.Create;
  Position:=-1;
end;
//==============================================================================
destructor TCLHistory.Destroy;
begin
  sl.Free;
end;
//==============================================================================
procedure TCLHistory.Last;
begin
  Position:=sl.Count;
end;
//==============================================================================
function TCLHistory.Next: string;
begin
  if sl.Count=0 then result:=''
  else begin
    if Position<sl.Count-1 then inc(Position);
    if Position>=sl.Count then result:=sl[sl.Count-1]
    else result:=sl[Position];
  end;
end;
//==============================================================================
function TCLHistory.Prev: string;
begin
  if sl.Count=0 then result:=''
  else begin
    if Position>0 then dec(Position);
    result:=sl[Position];
  end;
end;
//==============================================================================
procedure TfCLTerminal.edtInputKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s: string;
begin
  case Key of
    38: edtInput.Text:=FHistory.Prev;
    40: edtInput.Text:=FHistory.Next;
  end;
end;
//==============================================================================
procedure TfCLTerminal.lvLoginsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i,btm: integer;
  itm: TListItem;
  found: Boolean;
  LoginImage: TLoginImage;
  login: string;
begin
  if (X=OldX) and (Y=OldY) then exit;
  found:=false;
  if (X>4) and (X<lvLogins.Width-4) then
    for i:=0 to lvLogins.Items.Count-1 do begin
      itm:=lvLogins.Items[i];
      btm:=itm.Position.Y-trunc(lvLogins.Font.Height*1.2);
      if (y>itm.Position.Y) and (y<btm) then begin
        found:=true;
        login:=RemoveTitle(itm.Caption);
        break;
      end;
    end;
  if found then LoginImage:=fLoginImages[Login]
  else Login:='';
  pnlPhoto.Visible:=found and fGL.PhotoPlayerList and (LoginImage<>nil);
  if pnlPhoto.Visible then begin
    pnlPhoto.Top:=0;
    pnlPhoto.Left:=lvLogins.Left - pnlPhoto.Width;
    if Login<>CurImageLogin then begin
      CopyBitmap(LoginImage.Photo,imgPhoto.Picture.Bitmap);
      pnlPhoto.Width := imgPhoto.Picture.Bitmap.Width+4;
      pnlPhoto.Height := imgPhoto.Picture.Bitmap.Height+4;
    end;
  end;
  CurImageLogin := Login;
  {if Found then begin
    pnlInfo.Top:=btm+2;
    DisplayInfo(TCSEvent(lvEvents.Items[i].Data));
  end else
    pnlInfo.Tag:=0;
  {pnlInfo.Caption:=IntToStr(i);
  pnlInfo.Caption:=pnlInfo.Caption+' '+Format('%d-%d',[x,y]);}
  OldX:=X; OldY:=Y;
end;
//==============================================================================
procedure TfCLTerminal.miScoreClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_SCORE, RemoveTitle(lvLogins.ItemFocused.Caption)]);
end;
//==============================================================================
procedure TfCLTerminal.AddAnnounce(Msg: string);
begin
  slAnnounce.Add(Msg);
  with udAnnounce do begin
    if Min = -1 then Min := 0;
    Max := Max + 1;
    Position := Max;
  end;
  if ShoutMuted then exit;
  
  ccAnnounce.SetText(Msg);
  annState.Text := Msg;
  annState.State := asBlinking;
  annState.Ticks := 0;
  annState.Counter := 0;
  annState.Visible := true;
  annState.ScrollingEnabled := fGL.AnnouncementAutoscroll;
  udAnnounce.Enabled := true;
end;
//==============================================================================
procedure TfCLTerminal.udAnnounceClick(Sender: TObject; Button: TUDBtnType);
begin
  with udAnnounce do begin
    //if (Button = btNext) and (Position = Max) or (Button = btPrev) and (Position = Min) then exit;
    annState.Text := slAnnounce[Position];
    annState.State := asStatic;
    annState.Ticks := 0;
    annState.Counter := 0;
    annState.Start := 0;
    ccAnnounce.SetText(annState.Text);
  end;
end;
//==============================================================================
procedure TfCLTerminal.Timer1Timer(Sender: TObject);
var
  Size: integer;
begin
  if (slAnnounce.Count = 0) or ShoutMuted then exit;

  if annState.State = asBlinking then begin
    inc(annState.Ticks);
    if annState.Ticks >= VISIBLE_TIME then begin
      if annState.Visible then ccAnnounce.SetText(annState.Text)
      else ccAnnounce.SetText('');

      annState.Visible := not annState.Visible;
      annState.Ticks := 0;
      inc(annState.Counter);
      if annState.Counter >= fGL.AnnouncementBlinkCount then begin
        annState.State := asStatic;
        annState.Counter := 0;
      end;
    end;
  end else if annState.State = asStatic then begin
    inc(annState.Ticks);
    if (annState.Ticks >= STATIC_TIME) and annState.ScrollingEnabled then begin
      Size := ccAnnounce.TextWidth(annState.Text);
      if Size > ccConsole.Width then begin
        annState.Ticks := 0;
        annState.State := asScrolling;
      end;
    end;
  end else if annState.State = asScrolling then begin
    inc(annState.Ticks);
    if annState.Ticks >= SCROLLING_TIME then begin
      inc(annState.Start);
      ccAnnounce.SetText(copy(annState.Text, annState.Start, length(annState.Text)));
      annState.Ticks := 0;
      if annState.Start > length(annState.Text)+20 then begin
        annState.State := asStatic;
        ccAnnounce.SetText(annState.Text);
        annState.Start := 0;
        annState.ScrollingEnabled := false;
      end;
    end;
  end;
end;
//==============================================================================
function TfCLTerminal.LastAnnounce: string;
begin
  if slAnnounce.Count = 0 then result := ''
  else result := slAnnounce[slAnnounce.Count-1];
end;
//==============================================================================
procedure TfCLTerminal.ccAnnounceMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not (annState.State in [asScrolling,asStatic]) then exit;
  annState.OldState := annState.State;
  annState.State := asMouseDown;
end;
//==============================================================================
procedure TfCLTerminal.ccAnnounceMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if annState.State <> asMouseDown then exit;
  annState.State := annState.OldState;
  annState.MouseX := -1;
end;
//==============================================================================
procedure TfCLTerminal.ccAnnounceMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  Size: integer;
  n: integer;
begin
  if annState.State <> asMouseDown then exit;
  
  if annState.MouseX = -1 then annState.MouseX := X
  else begin
    Size := ccAnnounce.TextWidth('o');
    if abs(annState.MouseX - X) > Size then begin
      n := (annState.MouseX - X) div Size;
      annState.start := annState.start + n;
      annState.MouseX := X; //annState.MouseX + n*Size;
      ccAnnounce.SetText(copy(annState.Text, annState.start, length(annState.Text)));
    end;
  end;
end;
//==============================================================================
procedure TfCLTerminal.ccAnnounceDblClick(Sender: TObject);
begin
  with annState do begin
    if State = asScrolling then begin
      State := asStatic;
      ScrollingEnabled := false;
    end else begin
      ScrollingEnabled := true;
      //State := asScrolling;
    end;
  end;
end;
//==============================================================================
procedure TfCLTerminal.lvLoginsDrawItem(Sender: TCustomListView; Item: TListItem; Rect: TRect; State: TOwnerDrawState);
var
  w, n, vRight, RatingLeft, nOnlineStatus, Top: integer;
  MT: TMembershipType;
  L: TLogin;
begin
  if LoadLoginInProgress then exit;

  if odSelected in State then begin
    lvLogins.Canvas.Brush.Color := clBlue;
    lvLogins.Canvas.Font.Color := clYellow;
  end else begin
    lvLogins.Canvas.Brush.Color := fGL.ConsoleColor;
    lvLogins.Canvas.Font.Color := fGL.ConsoleTextColor;
  end;

  lvLogins.Canvas.FillRect(Rect);

  vRight := lvLogins.Width - 16;

  Top := Rect.Top + 2;

  lvLogins.Canvas.Font.Name := 'Arial';
  lvLogins.Canvas.Font.Size := 10;
  ilLogins.Draw(lvLogins.Canvas, Rect.Left + 2, Top, Item.ImageIndex);

  L := fLoginList[StrToInt(Item.SubItems[1])];
  if L = nil then begin
    MT := mmbTrial;
    nOnlineStatus := ord(onlActive);
  end else begin
    MT := L.MembershipType;
    nOnlineStatus := ord(L.OnlineStatus);
  end;

  if fCLSocket.MyAdminLevel > 0 then
    lvLogins.Canvas.Font.Style := MembershipType2FontStyle(MT);

  lvLogins.Canvas.TextOut(Rect.Left+24, Top - 2, Item.Caption);
  w := lvLogins.Canvas.TextWidth(Item.SubItems[0]);
  RatingLeft := vRight - w - 8;
  lvLogins.Canvas.TextOut(RatingLeft, Top - 2, Item.SubItems[0]);

  if nOnlineStatus <> ord(onlActive) then begin
    ilOnlineStatus.Draw(lvLogins.Canvas, RatingLeft - 20, Top, nOnlineStatus - 1);
  end;
end;
//==============================================================================
procedure TfCLTerminal.sbShoutMuteClick(Sender: TObject);
begin
  ShoutMuted := sbShoutMute.Down;
  if ShoutMuted then
    ccAnnounce.ClearText
  else
    if slAnnounce.Count > 0 then begin
      ccAnnounce.SetText(slAnnounce[slAnnounce.Count-1]);
      annState.State := asStatic;
    end;
end;
//==============================================================================
procedure TfCLTerminal.SetFontSize(Size: integer);
var
  h, diff: integer;
begin
  h := ccAnnounce.TextHeight('0')+4;
  diff := h - ccAnnounce.Height;
  ccAnnounce.Top := ccAnnounce.Top - diff;
  ccAnnounce.Height := ccAnnounce.Height + diff;
  ccConsole.Height := ccAnnounce.Top - 2;
end;
//==============================================================================
procedure TfCLTerminal.SetLvLoginsRating(const L: TLogin);
var
  index, OldRating, NewRating: integer;
  itm: TListItem;
begin
  index := FindLvLoginsIndex(L.LoginID);
  if index = -1 then exit;
  itm := lvLogins.Items[index];
  OldRating := StrToInt(itm.SubItems[0]);
  NewRating := L.Rating[fGL.RatingType];
  if NewRating <> OldRating then
    if fGL.OrdType = SORT_NAME then
      itm.SubItems[0] := IntToStr(NewRating)
    else begin
      lvLogins.Items.Delete(index);
      AddToLvLogins(L);
    end;
end;
//==============================================================================
{ TRatingInfo }

procedure TRatingInfo.Clear;
var
  i: integer;
begin
  FRatingString := '';
  IsOk := false;
  for i := 0 to 5 do
    with FData[i] do begin
      R := 0;
      W := 0;
      D := 0;
      L := 0; 
    end;
end;
//==============================================================================
constructor TRatingInfo.Create(RatingString: string);
begin
  inherited Create;
  if RatingString <> '' then
    SetRatingString(RatingString);
end;
//==============================================================================
function TRatingInfo.GetIsProv(RatedType: TRatedType): Boolean;
begin
  if FProvString <> '' then result := FProvString[ord(RatedType)+1] = '1'
  else result := false;
end;
//==============================================================================
function TRatingInfo.GetRating(RatedType: TRatedType): integer;
begin
  result := FData[ord(RatedType)].R;
end;
//==============================================================================
function TRatingInfo.NumberOfGames(RatedType: TRatedType): integer;
begin
  with FData[ord(RatedType)] do
    result := W + L + D;
end;
//==============================================================================
function TRatingInfo.ProvByRating: string;
var
  i: integer;
begin
  result := '000000';
  for i:=0 to 5 do begin
    if NumberOfGames(TRatedType(i)) < 20 then
      result[i+1] := '1';
  end;
end;
//==============================================================================
function TfCLTerminal.ProvStringByRatingString(
  RatingString: string): string;
var
  RI: TRatingInfo;
begin
  RI := TRatingInfo.Create(RatingString);
  result := RI.ProvByRating;
  RI.Free;
end;
//==============================================================================
function TfCLTerminal.NumberOfRatedGames(Login: string; RatingType: TRatedType): integer;
var
  RI: TRatingInfo;
  L: TLogin;
  i: integer;
begin
  result := 0;
  L := fLoginList.LoginByName[Login];
  if L = nil then exit;

  RI := TRatingInfo.Create(L.RatingString);
  result := RI.NumberOfGames(RatingType);
  RI.Free;
end;
//==============================================================================
procedure TRatingInfo.SetRatingString(RatingString: string);
var
  sl1,sl2: TStringList;
  i: integer;
begin
  FRatingString := RatingString;
  FIsOk := false;
  sl1 := TStringList.Create;
  sl2 := TStringList.Create;
  try
    Str2StringList(RatingString,sl1,';');
    for i := 0 to 5 do begin
      Str2StringList(sl1[i],sl2,',');
      FData[i].R := StrToInt(sl2[0]);
      FData[i].W := StrToInt(sl2[1]);
      FData[i].L := StrToInt(sl2[2]);
      FData[i].D := StrToInt(sl2[3]);
    end;
    FIsOk := true;
  except
  end;

  sl1.Free;
  sl2.Free;
end;
//==============================================================================
procedure TfCLTerminal.FocusConsoleFilter;
begin
  if tcMain.TabIndex <> 0 then begin
    tcMain.TabIndex := 0;
    tcMain.OnChange(tcMain);
  end;
end;
//==============================================================================
procedure TfCLTerminal.Nuke1Click(Sender: TObject);
var
  sReason, Login: string;
begin
  if lvLogins.ItemFocused = nil then exit;
  Login := RemoveTitle(lvLogins.ItemFocused.Caption);
  if not InputQuery('Enter reason to nuke ' + Login, 'Reason', sReason) then exit;
  fCLSocket.InitialSend([CMD_STR_NUKE, Login, sReason]);
end;
//==============================================================================
procedure TfCLTerminal.BanMuteClick(Sender: TObject; p_Str, p_Command: string);
var
  Login, s, sHours, param, sReason: string;
  hours: integer;
begin
  if lvLogins.ItemFocused = nil then exit;
  Login := RemoveTitle(lvLogins.ItemFocused.Caption);
  hours := (Sender as TMenuItem).Tag;
  if hours = -1 then
    while true do begin
      if not InputQuery('Enter number of hours you want to ' + p_Str + ' ' + Login+' for','Hours',sHours) then exit;
      try
        hours := StrToInt(sHours);
        if hours <= 0 then raise exception.create('');
        break;
      except
        showmessage('You must enter positive number');
      end;
    end
  else begin
    if hours = 0 then s := ' forever'
    else s := ' for ' + IntToStr(hours) + ' hours';
  end;

  if not InputQuery('Enter reason to ' + p_Str + ' ' + Login, 'Reason', sReason) then exit;

  fCLSocket.InitialSend([p_Command, Login, IntToStr(hours), sReason]);
end;
//==============================================================================
procedure TfCLTerminal.MuteClick(Sender: TObject);
begin
  BanMuteClick(Sender, 'mute', CMD_STR_MUTE);
end;
//==============================================================================
procedure TfCLTerminal.BanClick(Sender: TObject);
begin
  BanMuteClick(Sender, 'ban', CMD_STR_BAN);
end;
//==============================================================================
procedure TfCLTerminal.Unmute1Click(Sender: TObject);
var
  Login: string;
begin
  if lvLogins.ItemFocused = nil then exit;
  Login := RemoveTitle(lvLogins.ItemFocused.Caption);
  if MessageDlg('Do you really want to unmute '+Login+'?',mtConfirmation,[mbNo,mbYes],0) = mrNo then exit;
  fCLSocket.InitialSend([CMD_STR_UNMUTE, Login]);
end;
//==============================================================================
procedure TfCLTerminal.ShowFilterGame;
var
  EventID: integer;
  ev: TCSEvent;
  Game: TCLGame;
  Filter: TCLFilter;
begin
  Filter := CurrentCLFilter;
  if Filter=nil then exit;
  if Filter.Key1=fkEvent then begin
    EventID := Filter.Key2;
    ev := fCLLectures.FindLecture(EventID);
    if (ev <> nil) and (ev.Games.Count = 1) then begin
      if ev.Games.Count > 0 then begin
        game := TCLGame(ev.Games[0]);
        fCLMain.SetActivePane(0, game);
      end;
    end;
  end;
end;
//==============================================================================
procedure TfCLTerminal.tcMainMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ShowFilterGame;
end;
//==============================================================================
procedure TfCLTerminal.BanHistory1Click(Sender: TObject);
var
  Login: string;
begin
  if lvLogins.ItemFocused = nil then exit;
  Login := RemoveTitle(lvLogins.ItemFocused.Caption);
  fCLSocket.InitialSend([CMD_STR_BANHISTORY, Login]);
end;
//==============================================================================
end.

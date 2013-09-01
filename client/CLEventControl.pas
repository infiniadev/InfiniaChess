{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLEventControl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, CLListBox, ComCtrls, rxAnimate, rxGIFCtrl, CLGame, CLEvents,
  ToolWin, Menus;

type
  {TEventGameState = (egsNone,egsGMMove,egsPlayerMove,egsWin,egsLoss,egsDraw);

  TEventGame = class(TObject)
    public
      State: TEventGameState;
      GM: TCLGame;
  end;}

  TfCLEventControl = class(TForm)
    tb: TTabControl;
    pnlGames: TPanel;
    pnlMyLocation: TPanel;
    pnlLeaderLocation: TPanel;
    pnlButtons: TPanel;
    tbButtons: TToolBar;
    tbSwitchMode: TToolButton;
    tbFollow: TToolButton;
    tbRotate: TToolButton;
    pmSwitch: TPopupMenu;
    Byorder1: TMenuItem;
    Bytime1: TMenuItem;
    Bymoves1: TMenuItem;
    Noswitching1: TMenuItem;
    pnlTop: TPanel;
    lblLeader: TLabel;
    lblTimeControl: TLabel;
    lblScoreCaption: TLabel;
    lblScore: TLabel;
    lblGamesCaption: TLabel;
    lblGames: TLabel;
    imgUserState: TImage;
    pnlHeader: TPanel;
    lblNotify: TLabel;
    sbClose: TSpeedButton;
    pnlQueue: TPanel;
    lvQueue: TListView;
    Label1: TLabel;
    lblCurrentGame: TLabel;
    lblRating: TLabel;
    pnlFinished: TPanel;
    lvFinished: TListView;
    pnlKing: TPanel;
    lvKingQueue: TListView;
    Panel1: TPanel;
    Label2: TLabel;
    lblKingName: TLabel;
    lblKingRating: TLabel;
    lblKilled: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblRank: TLabel;
    tbPause: TToolButton;
    pmPause: TPopupMenu;
    Pause1: TMenuItem;
    Resume1: TMenuItem;
    pmJoin: TPopupMenu;
    miJoin: TMenuItem;
    pnlTournament: TPanel;
    lvMembers: TListView;
    tbStandings: TToolButton;
    tbMyGame: TToolButton;
    tbAbortGame: TToolButton;
    procedure sbCloseClick(Sender: TObject);
    procedure animClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pnlGamesDblClick(Sender: TObject);
    procedure pnlGamesResize(Sender: TObject);
    procedure tbSwitchModeClick(Sender: TObject);
    procedure Byorder1Click(Sender: TObject);
    procedure tbChange(Sender: TObject);
    procedure SetActiveGame(GameNum: integer);
    procedure SetMyCurrentGame;
    procedure lvFinishedSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormClick(Sender: TObject);
    procedure Pause1Click(Sender: TObject);
    procedure Resume1Click(Sender: TObject);
    procedure tbPauseClick(Sender: TObject);
    procedure miJoinClick(Sender: TObject);
    procedure btnTableClick(Sender: TObject);
    procedure btnMyGameClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbStandingsClick(Sender: TObject);
    procedure tbMyGameClick(Sender: TObject);
    procedure tbAbortGameClick(Sender: TObject);
    procedure lvMembersCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
    Buttons: TList;
    FEVCurrent: TCSEvent;
    procedure GameButtonClick(Sender: TObject); overload;
    procedure GameButtonClick(Num: integer); overload;
    function GetCurrentQueue: TListView;
    procedure SetEVCurrent(const Value: TCSEvent);
  public
    { Public declarations }
    procedure CreateGameButtons;
    procedure ArrangeGameButtons;
    procedure AddGame(Game: TCLGame);
    procedure AddGameButton(Game: TCLGame);
    procedure AddMainQueueGame(Game: TCLGame);
    procedure DisplayEventInfo;
    procedure DisplayUserState;
    procedure ClearGameButtons;
    procedure SetMyGame;
    procedure SetNextLeaderGame(CurrentNum: integer);
    procedure LoadRightImage(Game: TCLGame);
    //procedure ShowMarkers;
    procedure DisplaySwitchMode;
    procedure DisplayScore;
    procedure DisplayUserStat;
    procedure CloseEventControl;
    procedure ClickGameButton(Num: integer);
    procedure ArrangePanels;
    procedure CountFinished;
    procedure AddToQueue(LV: TListview; LG: TCLLogin; RatedType: TRatedType); overload;
    procedure AddToQueue(LV: TListView; Login,Title: string; Rating: integer); overload;
    procedure RemoveFromQueue(LV: TListView; Name: string);
    procedure AddToFinished(Game: TCLGame);
    procedure DeleteFromQueue(LV: TListView; LG: TCLLogin);
    procedure MoveUserToTail(name,title: string);
    procedure QueueClear;
    procedure RefreshMembers;
    procedure InsOrUpdMember(name,title: string; rating: integer);
    procedure AddMember(fullname: string; rating: integer);
    function  GetButton(Num: integer): TRxGifAnimator;
    property EVCurrent: TCSEvent read FEVCurrent write SetEVCurrent;
    procedure RepaintActiveTable;
  end;

var
  fCLEventControl: TfCLEventControl;

implementation

uses CLMain,CLSocket,CLTerminal,CLConst,CLNavigate, CLBoard, CLLib,CLGlobal,
  CLTable,CLTournament,CSReglament;

var
  SwitchModeHints: array [0..3] of string =
    ('Next by order',
     'Minimum time rest',
     'Minimum moves done',
     'Don''t switch');
  SwitchModeCaptions: array [0..3] of string =
    ('O','T','M',' ');

{$R *.DFM}
//===========================================================================================
procedure TfCLEventControl.sbCloseClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to leave event?',mtWarning,[mbYes,mbNo],0)=mrNo then exit;
  fCLSocket.InitialSend([CMD_STR_EVENT_LEAVE,IntToStr(EVCurrent.ID)]);
end;
//===========================================================================================
procedure TfCLEventControl.animClick(Sender: TObject);
begin
end;
//===========================================================================================
procedure TfCLEventControl.FormCreate(Sender: TObject);
begin
  Buttons:=TList.Create;
  DisplaySwitchMode;
end;
//===========================================================================================
procedure TfCLEventControl.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Buttons.Free;
end;
//===========================================================================================
procedure TfCLEventControl.CreateGameButtons;
var
  i: integer;
  btn: TRxGifAnimator;
begin
  for i:=0 to 15 do begin
    btn:=TRxGifAnimator.Create(pnlGames);
    btn.Parent:=pnlGames;
    btn.Tag:=i;
    //btn.Image.LoadFromFile(GetCurrentDir+'\'+FileNames[i mod 4]+'.gif');
    btn.Animate:=true;
    Buttons.Add(btn);
  end;
  ArrangeGameButtons;
end;
//===========================================================================================
procedure TfCLEventControl.pnlGamesDblClick(Sender: TObject);
begin
  //CreateGameButtons;
end;
//===========================================================================================
procedure TfCLEventControl.ArrangeGameButtons;
var
  i,w,n,d,bw,x,y: integer;
  btn: TRxGifAnimator;
begin
  if EVCurrent.Type_<>evtSimul then exit;
  pnlMyLocation.Visible:=false;
  pnlLeaderLocation.Visible:=false;
  w:=pnlGames.Width;
  d:=4; // distance between buttons
  bw:=32; // width and height of button
  n:=(w-d) div (d+bw); // number of buttons in one row
  for i:=0 to Buttons.Count-1 do begin
    y:=(i div n)*(bw+d)+d;
    x:=(i mod n)*(bw+d)+d;
    btn:=TRxGifAnimator(Buttons[i]);
    btn.Width:=bw;
    btn.Height:=bw;

    if (i = EVCurrent.ActiveGameNum) and (i <> EVCurrent.LeaderLocation) then begin
      btn.Parent:=pnlMyLocation;
      btn.Left:=2;
      btn.Top:=2;
      pnlMyLocation.Width:=bw+4;
      pnlMyLocation.Height:=bw+4;
      pnlMyLocation.Left:=x-2;
      pnlMyLocation.Top:=y-2;
      pnlMyLocation.Visible:=true;
    end else if (i = EVCurrent.ActiveGameNum) and (i = EVCurrent.LeaderLocation) then begin
      pnlMyLocation.Width:=bw+4;
      pnlMyLocation.Height:=bw+4;
      pnlMyLocation.Left:=x-2;
      pnlMyLocation.Top:=y-2;

      btn.Parent:=pnlLeaderLocation;
      btn.Left:=1;
      btn.Top:=1;

      pnlLeaderLocation.Width:=bw+2;
      pnlLeaderLocation.Height:=bw+2;
      pnlLeaderLocation.Parent:=pnlMyLocation;
      pnlLeaderLocation.Left:=1;
      pnlLeaderLocation.Top:=1;
      pnlLeaderLocation.Visible:=true;

      pnlMyLocation.Visible:=true;
    end else if (i <> EVCurrent.ActiveGameNum) and (i = EVCurrent.LeaderLocation) then begin
      btn.Parent:=pnlLeaderLocation;
      btn.Left:=2;
      btn.Top:=2;
      pnlLeaderLocation.Width:=bw+4;
      pnlLeaderLocation.Height:=bw+4;
      pnlLeaderLocation.Left:=x-2;
      pnlLeaderLocation.Parent:=pnlGames;
      pnlLeaderLocation.Top:=y-2;
      pnlLeaderLocation.Visible:=true;
    end
    else begin
      btn.Parent:=pnlGames;
      btn.left:=x;
      btn.top:=y;
    end;
  end;
end;
//===========================================================================================
procedure TfCLEventControl.pnlGamesResize(Sender: TObject);
begin
  ArrangeGameButtons;
end;
//===========================================================================================
procedure TfCLEventControl.AddGameButton(Game: TCLGame);
var
  i: integer;
  btn: TRxGifAnimator;
  player: string;
  EVSimul: TCSEventSimul;
begin
  EVSimul:=EVCurrent as TCSEventSimul;
  for i:=Buttons.Count to Game.EventOrdNum-1 do begin
    btn:=TRxGifAnimator.Create(pnlGames);
    Buttons.Add(btn);
    btn.Parent:=pnlGames;
    btn.Tag:=i;
    LoadRightImage(Game);
    btn.Animate:=true;
    btn.OnClick:=GameButtonClick;

    if lowercase(Game.WhiteName) = lowercase(EVSimul.LeaderName) then player:=Game.BlackName
    else player:=Game.WhiteName;

    btn.Hint:=Format('(%d) %s',[Game.EventOrdNum,player]);
    btn.ShowHint:=true;

  end;
  ArrangeGameButtons;
  DisplayScore;
end;
//===========================================================================================
procedure TfCLEventControl.DisplayEventInfo;
var
  s: string;
begin
  if EVCurrent = nil then exit;
  lblLeader.Visible:=EVCurrent.Type_ in ETLeader;
  lblLeader.Caption:=EVCurrent.LeaderName;
  lblTimeControl.Caption:=TimeToStrEventFormat(EVCurrent.InitialTime,EVCurrent.IncTime);
  lblTimeControl.Left:=pnlTop.Width - 4 - lblTimeControl.Width;
  DisplayUserStat;
  {lblScore.Caption:='0/0/0';
  lblGames.Caption:=IntToStr(Buttons.Count);}
  //pnlButtons.Visible:=lowercase(fCLSocket.MyName)=lowercase(lblLeader.Caption);
  tbSwitchMode.Visible:=(EVCurrent.Type_ in ETLeader) and EVCurrent.IAmLeader;//lowercase(fCLSocket.MyName)=lowercase(lblLeader.Caption);
  tbPause.Visible:=EVCurrent.IAmLeader and (EVCurrent.Type_=evtChallenge) or (EVCurrent.Type_=evtTournament);
  tbFollow.Visible:=(EVCurrent.Type_ in ETLeader) and not tbSwitchMode.Visible;
  tbRotate.Visible:=(EVCurrent.Type_ in ETLeader) and not tbSwitchMode.Visible;
  tbStandings.Visible:=EVCurrent.Type_ = evtTournament;
  tbMyGame.Visible:= (EVCurrent.Type_ = evtTournament) or (EVCurrent.Type_ = evtSimul) and not EVCurrent.IAmLeader;
  tbAbortGame.Visible:=(EVCurrent.Type_ in ETAborted) and (fCLSocket.MyAdminLevel=3);
  ArrangePanels;
  if pnlQueue.Visible then begin
    if EVCurrent.Games.Count=0 then begin
      lblCurrentGame.Caption:='-';
      lblRating.Caption:='';
    end;
  end;
  if EVCurrent.Type_=evtKing then
    with EVCurrent as TCSEventKing do begin
      s:=GetNameWithTitle(KingName,KingTitle);
      lblKingName.Caption:=s;
      RemoveFromQueue(lvKingQueue,s);
      lblKingRating.Caption:=IntToStr(KingRating);
      lblKilled.Caption:=IntToStr(KingGamesWon);
      lblRank.Caption:=KingRank;
    end;
  pnlButtons.Visible:=true; //not (EVCurrent.Type_ in [evtKing]);
  tb.Visible:=EVCurrent.Type_<>evtSimul;
end;
//===========================================================================================
procedure TfCLEventControl.ClearGameButtons;
var
  i: integer;
  btn: TRxGifAnimator;
begin
  for i:=Buttons.Count-1 downto 0 do begin
    btn:=TRxGifAnimator(Buttons[i]);
    pnlGames.RemoveControl(btn);
    btn.Free;
    Buttons.Delete(i);
  end;
end;
//===========================================================================================
procedure TfCLEventControl.GameButtonClick(Sender: TObject);
begin
  if Sender<>nil then SetActiveGame((Sender as TRxGifAnimator).Tag);
end;
//===========================================================================================
procedure TfCLEventControl.SetMyGame;
var
  i: integer;
  Game: TCLGame;
begin
  if EVCurrent = nil then exit;
  for i:=0 to EVCurrent.Games.Count-1 do begin
    Game:=TCLGame(EVCurrent.Games[i]);
    if (Game.WhiteName = fCLSocket.MyName) or (Game.BlackName = fCLSocket.MyName) then begin
      GameButtonClick(i);
      exit;
    end;
  end;
end;
//===========================================================================================
procedure TfCLEventControl.SetNextLeaderGame(CurrentNum: integer);
var
  n: integer;
  EVSimul: TCSEventSimul;
begin
  if EVCurrent = nil then exit;
  EVSimul:=EVCurrent as TCSEventSimul;
  if EVSimul.SwitchMode = eswNone then exit;

  n:=CurrentNum;
  case EVSimul.SwitchMode of
    eswOrder: n:=EvSimul.GetLeaderGameNextOrder;
    eswTime: n:=EvSimul.GetLeaderGameLessTime;
    eswMoves: n:=EvSimul.GetLeaderGameLessMoves;
  end;

  GameButtonClick(n);
end;
//===========================================================================================
var ImgNames: array[0..5] of string = ('Game_ProgressL','Game_ProgressP','Draw','Game_Lost','win','Abort');
//===========================================================================================
procedure TfCLEventControl.LoadRightImage(Game: TCLGame);
var
  status: TCSEventGameStatus;
  n: integer;
  btn: TRxGifAnimator;
begin
  if EVCurrent = nil then exit;

  status:=EVCurrent.GameStatus(Game);
  if status = egsNone then exit;

  case status of
    egsLeaderMove: n:=0;
    egsPlayerMove: n:=1;
    egsDraw: n:=2;
    egsLeaderLost: n:=3;
    egsLeaderWin: n:=4;
    egsAborted: n:=5;
  else
    n:=-1;
  end;

  btn:=GetButton(Game.EventOrdNum-1);
  if btn<>nil then
    if n<>-1 then begin
      btn.Image.LoadFromFile(MAIN_DIR+ImgNames[n]+'.gif');
      btn.Animate:=true;
    end else begin
      btn.Image.LoadFromFile(MAIN_DIR+ImgNames[2]+'.gif');
      btn.Animate:=false;
    end;
end;
//===========================================================================================
{procedure TfCLEventControl.ShowMarkers;
var btn: TRxGifAnimator;
begin
  if EVCurrent = nil then exit;
  btn:=Buttons[EVCurrent.ActiveGameNum];
end;}
//===========================================================================================
procedure TfCLEventControl.DisplayScore;
var
  Win,Draw,Lost,Progress: integer;
begin
  if EVCurrent = nil then exit;
  if EVCurrent.Type_ <> evtSimul then exit;
  EVCurrent.GetScore(Win,Draw,Lost,Progress);
  lblScoreCaption.Caption:='Current Score (W/L/D):';
  lblScore.Caption:=Format('%d / %d / %d',[Win,Lost,Draw]);
  lblGamesCaption.Caption:='Playing Games:';
  lblGames.Caption:=IntToStr(Progress);
end;
//===========================================================================================
procedure TfCLEventControl.DisplaySwitchMode;
begin
  with tbSwitchMode do begin
    ImageIndex:=Tag;
    Hint:=SwitchModeHints[Tag];
  end;
end;
//===========================================================================================
procedure TfCLEventControl.CloseEventControl;
var
  i: integer;
  btn: TRxGifAnimator;
begin
  if EVCurrent.Games.Count=0 then
    fCLTerminal.EventExit(EVCurrent.ID);
  EVCurrent.Leave;
  for i:=0 to Buttons.Count-1 do begin
    btn:=GetButton(i);
    if btn<>nil then btn.Free;
  end;
  Buttons.Clear;
  lvQueue.Items.Clear;
  lvKingQueue.Items.Clear;
  lvFinished.Items.Clear;
  EVCurrent:=nil;
  fCLMain.EventAttached := false; //not fCLMain.EventAttached;
  fCLNavigate.clNavigate.ItemIndex:=2;
  fCLNavigate.clNavigateClick(nil);
end;
//===========================================================================================
procedure TfCLEventControl.ClickGameButton(Num: integer);
var
  btn: TRxGifAnimator;
begin
  btn:=GetButton(Num);
  if btn<>nil then GameButtonClick(btn);
end;
//===========================================================================================
procedure TfCLEventControl.tbSwitchModeClick(Sender: TObject);
var
  n: integer;
begin
  n:=High(SwitchModeHints);
  if tbSwitchMode.Tag=n then tbSwitchMode.Tag:=0
  else tbSwitchMode.Tag:=tbSwitchMode.Tag+1;

  if EVCurrent<>nil then EVCurrent.SwitchMode:=TCSEventSwitchMode(tbSwitchMode.Tag);
  DisplaySwitchMode;
end;
//===========================================================================================
procedure TfCLEventControl.Byorder1Click(Sender: TObject);
begin
  tbSwitchMode.Tag:=(Sender as TMenuItem).Tag;
  DisplaySwitchMode;
  if EVCurrent.Type_ <> evtSimul then exit;
  (EVCurrent as TCSEventSimul).SwitchMode:=TCSEventSwitchMode(tbSwitchMode.Tag);
end;
//===========================================================================================
procedure TfCLEventControl.DisplayUserState;
var
  n: integer;
begin
  if EVCurrent=nil then begin
    imgUserState.Visible:=false;
    exit;
  end;

  case EVCurrent.State of
    eusMember  : n:=6;
    eusObserver: n:=7;
    eusLeader  : n:=8;
  else
    n:=-1;
  end;
  imgUserState.Visible:=n>-1;
  fCLMain.ilMain24.GetBitmap(n,imgUserState.Picture.Bitmap);
  imgUserState.Refresh;

  if EVCurrent.State=eusLeader then imgUserState.PopupMenu:=nil
  else imgUserState.PopupMenu:=pmJoin;

  if evCurrent.State=eusMember then begin
    miJoin.Caption:='Observe';
    miJoin.ImageIndex:=7;
  end else begin
    miJoin.Caption:='Join';
    miJoin.ImageIndex:=6;
  end;
end;
//===========================================================================================
procedure TfCLEventControl.DisplayUserStat;
begin
  if (EVCurrent=nil) then exit;
  if (EVCurrent.Type_ = evtSimul) and (EVCurrent.Status<>estWaited) then exit;
  lblScoreCaption.Caption:='Joined: ';
  lblScore.Caption:=IntToStr(EVCurrent.CountJoined);
  lblGamesCaption.Caption:='Observers:';
  lblGames.Caption:=IntToStr(EVCurrent.CountObserver);
end;
//===========================================================================================
procedure TfCLEventControl.AddGame(Game: TCLGame);
begin
  if EVCurrent.Type_=evtSimul then
    AddGameButton(Game)
  else if EVCurrent.Type_=evtChallenge then
    AddMainQueueGame(Game)
  else if EVCurrent.Type_=evtKing then
    AddMainQueueGame(Game);
end;
//===========================================================================================
procedure TfCLEventControl.tbChange(Sender: TObject);
begin
  ArrangePanels;
end;
//===========================================================================================
procedure TfCLEventControl.ArrangePanels;
var
  itm: TListItem;
begin
  if EVCurrent=nil then exit;

  if tb.TabIndex = 0 then begin
    pnlFinished.Visible:=false;
    if EVCurrent.Type_=evtSimul then begin
      pnlGames.Visible:=true;
      pnlGames.Align:=alClient;
      pnlQueue.Visible:=false;
      pnlKing.Visible:=false;
      pnlTournament.Visible:=false;
    end else if EVCurrent.Type_=evtChallenge then begin
      pnlQueue.Visible:=true;
      pnlQueue.Align:=alClient;
      pnlGames.Visible:=false;
      pnlKing.Visible:=false;
      pnlTournament.Visible:=false;
    end else if EVCurrent.Type_=evtKing then begin
      pnlKing.Visible:=true;
      pnlKing.Align:=alClient;
      pnlGames.Visible:=false;
      pnlQueue.Visible:=false;
      pnlTournament.Visible:=false;
    end else if EVCurrent.Type_=evtTournament then begin
      pnlKing.Visible:=false;
      pnlGames.Visible:=false;
      pnlQueue.Visible:=false;
      pnlTournament.Visible:=true;
      pnlTournament.Align:=alClient;
    end;
    if (EVCurrent.Games.Count>0) and (EVCurrent.Type_ in [evtKing,evtChallenge]) then
      SetActiveGame(EVCurrent.Games.Count-1);
  end else if tb.TabIndex = 1 then begin
    pnlGames.Visible:=false;
    pnlQueue.visible:=false;
    pnlKing.Visible:=false;
    pnlFinished.Visible:=true;
    pnlFinished.Align:=alClient;
    if lvFinished.Items.Count>0 then begin
      itm:=lvFinished.Selected;
      if itm<>nil then SetActiveGame(StrToInt(itm.SubItems[2]));
    end;
  end;

  CountFinished;
end;
//===========================================================================================
procedure TfCLEventControl.AddToQueue(LV: TListView; LG: TCLLogin; RatedType: TRatedType);
begin
  AddToQueue(LV,LG.FLogin,LG.FTitle,StrToInt(RatingString2Rating(LG.FRatingString,fGL.RatingType)));
end;
//===========================================================================================
procedure TfCLEventControl.DeleteFromQueue(LV: TListView; LG: TCLLogin);
var
  s: string;
  itm: TListItem;
begin
  CLLib.Log(Format('AddToQueue(LV,%s (%s))',[LG.FLogin,LG.FTitle]));
  s:=GetNameWithTitle(LG.FLogin,LG.FTitle);
  itm:=LV.FindCaption(0,s,false,true,true);
  if itm<>nil then begin
    LV.Items.Delete(LV.Items.IndexOf(itm));
    CLLib.Log('Deleted');
  end else
    CLLib.Log('Alerady deleted');
end;
//===========================================================================================
procedure TfCLEventControl.AddMainQueueGame(Game: TCLGame);
var
  name,title,rating: string;
  inverted: Boolean;
  itm: TListItem;
begin
  EVCurrent.GetPlayerAttributes(Game,name,title,rating);
  name:=GetNameWithTitle(name,title);

  case Game.UserColor(fCLSocket.MyName) of
    uscWhite: Inverted:=false;
    uscBlack: Inverted:=true;
    uscNone: Inverted:=Game.UserColor(EVCUrrent.LeaderName)=uscBlack;
  end;

  lblCurrentGame.Caption:=name;
  lblRating.Caption:=rating;

  Game.Inverted:=inverted;

  itm:=lvQueue.FindCaption(0,name,false,true,true);
  if itm<>nil then lvQueue.Items.Delete(lvQueue.Items.IndexOf(itm));

  fCLSocket.InitialSend([CMD_STR_EVENT_GAME_OBSERVE,IntToStr(game.GameNumber)]);
  fCLMain.SetActivePane(0, Game);
  EVCurrent.ActiveGameNum:=Game.EventOrdNum-1;
end;
//===========================================================================================
procedure TfCLEventControl.CountFinished;
begin
  if tb.Tabs.Count>1 then
    tb.Tabs[1]:=Format('Finished (%d)',[lvFinished.Items.Count]);
end;
//=====================================================================
function EventGameStatus2Letter(Status: TCSEventGameStatus): string;
begin
  case Status of
    egsLeaderWin: result:='W';
    egsLeaderLost: result:='L';
    egsDraw: result:='D';
  else
    result:='';
  end;
end;
//===========================================================================================
procedure TfCLEventControl.AddToFinished(Game: TCLGame);
var
  name,title,rating: string;
  index: integer;
  itm: TListItem;
begin
  if not (EVCurrent.Type_ in ETFinished) then exit;
  if EVCurrent.Type_ = evtChallenge then begin
    EVCurrent.GetPlayerAttributes(Game,name,title,rating);
    name:=GetNameWithTitle(name,title);
    itm:=lvFinished.FindCaption(0,name,false,true,true);
    if itm<>nil then exit;
    itm:=lvFinished.Items.Add;
    itm.Caption:=name;
    itm.SubItems.Add(rating);
    itm.SubItems.Add(EventGameStatus2Letter(EVCurrent.GameStatus(Game)));
    itm.SubItems.Add(IntToStr(Game.EventOrdNum-1));

    lvFinished.Columns[0].Width:=100;
    lvFinished.Columns[1].Width:=40;
    lvFinished.Columns[2].Width:=50;
  end else if EVCurrent.Type_ = evtKing then begin
    index:=FindListViewIndex(lvFinished,IntToStr(Game.EventOrdNum-1),2);
    if index<>-1 then exit;
    itm:=lvFinished.Items.Add;
    itm.Caption:=Format('%s - %s',
      [GetNameWithTitle(Game.WhiteName,Game.WhiteTitle),
       GetNameWithTitle(Game.BlackName,Game.BlackTitle)]);
    itm.SubItems.Add('');
    itm.SubItems.Add('');
    itm.SubItems.Add(IntToStr(Game.EventOrdNum-1));

    lvFinished.Columns[0].Width:=190;
    lvFinished.Columns[1].Width:=0;
    lvFinished.Columns[2].Width:=0;
  end;
  CountFinished;
end;
//===========================================================================================
procedure TfCLEventControl.SetActiveGame(GameNum: integer);
var
  game: TCLGame;
begin
  if (GameNum<0) or (GameNum>=EVCurrent.Games.Count) then begin
    {MessageDlg(Format('SetActiveGame: GameNum=%d; Games.Count=%d',[GameNum,EVCurrent.Games.Count]),
      mtError,[mbOk],0);}
    exit;
  end;
  game:=EVCurrent.Games[GameNum];
  if tbRotate.Down and (lowercase(Game.WhiteName)<>lowercase(fCLSocket.MyName))
    and (lowercase(Game.BlackName)<>lowercase(fCLSocket.MyName))
  then begin
    if lowercase(Game.WhiteName)=lowercase(EVCurrent.LeaderName) then game.Inverted:=false
    else if lowercase(Game.BlackName)=lowercase(EVCurrent.LeaderName) then game.Inverted:=true;
  end;
  fCLSocket.InitialSend([CMD_STR_EVENT_GAME_OBSERVE,IntToStr(game.GameNumber)]);
  if not fCLMain.GameIsActive(game) then
    fCLMain.SetActivePane(0, game);
  //fCLBoard.Inver
  EVCurrent.ActiveGameNum:=GameNum;
end;
//===========================================================================================
procedure TfCLEventControl.lvFinishedSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  SetActiveGame(StrToInt(Item.SubItems[2]));
end;
//===========================================================================================
procedure TfCLEventControl.RemoveFromQueue(LV: TListView; Name: string);
var
  item: TListItem;
begin
  item:=LV.FindCaption(0,Name,false,true,true);
  if item<>nil then
    LV.Items.Delete(LV.Items.IndexOf(item));
end;
//===========================================================================================
procedure TfCLEventControl.MoveUserToTail(name, title: string);
var
  s: string;
  LV: TListView;
  index,n: integer;
begin
  CLLib.Log(Format('MoveUserToTail(%s,%s)',[name,title]));
  if EVCurrent=nil then exit;
  s:=GetNameWithTitle(name,title);
  LV:=GetCurrentQueue;
  index:=FindListViewIndex(LV,s);
  CLLib.Log(Format('index=%d',[index]));
  if index<>-1 then MoveListViewItem(LV,index,LV.Items.Count)
  else begin
    n:=EVCurrent.FindCLLogin(name);
    CLLib.Log(Format('n=%d',[n]));
    if n<>-1 then AddToQueue(LV,TCLLogin(EVCurrent.LoginList[n]),EVCurrent.RatedType);
  end;
end;
//===========================================================================================
procedure TfCLEventControl.FormClick(Sender: TObject);
var
  game: TCLGame;
begin
  game:=EVCurrent.ActiveGame;
  if game = nil then exit;
  fCLSocket.InitialSend([CMD_STR_EVENT_GAME_OBSERVE,IntToStr(game.GameNumber)]);
  fCLMain.SetActivePane(0, game);
end;
//===========================================================================================
function TfCLEventControl.GetButton(Num: integer): TRxGifAnimator;
begin
  if (Num>=0) and (Num<Buttons.Count) then result:=TRxGifAnimator(Buttons[Num])
  else result:=nil;
end;
//===========================================================================================
procedure TfCLEventControl.GameButtonClick(Num: integer);
var
  btn: TRxGifAnimator;
begin
  btn:=GetButton(Num);
  if btn<>nil then GameButtonClick(btn);
end;
//===========================================================================================
procedure TfCLEventControl.Pause1Click(Sender: TObject);
begin
  if EVCurrent=nil then exit;
  fCLSocket.InitialSend([CMD_STR_EVENT_PAUSE,IntToStr(EVCurrent.ID)]);
  tbPause.ImageIndex:=9;
end;
//===========================================================================================
procedure TfCLEventControl.Resume1Click(Sender: TObject);
begin
  if EVCurrent=nil then exit;
  fCLSocket.InitialSend([CMD_STR_EVENT_RESUME,IntToStr(EVCurrent.ID)]);
  tbPause.ImageIndex:=10;
end;
//===========================================================================================
procedure TfCLEventControl.tbPauseClick(Sender: TObject);
var
  s: string;
begin
  if EVCurrent=nil then exit;
  if tbPause.ImageIndex=10 then s:=CMD_STR_EVENT_PAUSE
  else s:=CMD_STR_EVENT_RESUME;

  fCLSocket.InitialSend([s,IntToStr(EVCurrent.ID)]);
  tbPause.ImageIndex:=19-tbPause.ImageIndex;
end;
//===========================================================================================
procedure TfCLEventControl.miJoinClick(Sender: TObject);
begin
  if miJoin.Caption='&Join' then fCLSocket.InitialSend([CMD_STR_EVENT_JOIN + #32 + IntToStr(EVCurrent.ID)])
  else fCLSocket.InitialSend([CMD_STR_EVENT_OBSERVE + #32 + IntToStr(EVCurrent.ID)]);
end;
//===========================================================================================
procedure TfCLEventControl.btnTableClick(Sender: TObject);
begin
  fCLTable.Tournament:=evCurrent as TCSTournament;
  fCLTable.DrawActiveTable;
  fCLMain.SetActivePane(0, fCLTable);
  {fCLTable.DrawRoundTable(
    EVCurrent as TCSTournament,fCLTable.Canvas);}
end;
//===========================================================================================
procedure TfCLEventControl.QueueClear;
var
  LV: TListView;
begin
  LV:=GetCurrentQueue;
  LV.Items.Clear;
end;
//===========================================================================================
procedure TfCLEventControl.AddToQueue(LV: TListView; Login, Title: string; Rating: integer);
var
  s: string;
  itm: TListItem;
begin
  if LV=nil then LV:=GetCurrentQueue;
  if LV=nil then exit;
  CLLib.Log(Format('AddToQueue(LV,%s (%s))',[Login,Title]));
  s:=GetNameWithTitle(Login,Title);
  itm:=LV.FindCaption(0,s,false,true,true);
  if itm<>nil then begin
    CLLib.Log('itm=nil; exiting...');
    exit;
  end;
  if (EVCurrent.Type_ = evtKing) and (Login = (EVCurrent as TCSEventKing).KingName) then begin
    CLLib.Log(Format('%s is king, not adding to queue',[Login]));
    exit;
  end;
  itm:=LV.Items.Add;
  itm.Caption:=s;
  itm.SubItems.Add(IntToStr(Rating));
  CLLib.Log('item added to queue');
end;
//===========================================================================================
function TfCLEventControl.GetCurrentQueue: TListView;
begin
  result:=nil;
  case EVCurrent.Type_ of
    evtChallenge: result:=lvQueue;
    evtKing: result:=lvKingQueue;
  else
    begin
      CLLib.Log('Not a valid event type; exiting...');
      exit;
    end;
  end;
end;
//===========================================================================================
procedure TfCLEventControl.btnMyGameClick(Sender: TObject);
var
  i: integer;
  game: TCLGame;
begin
  for i:=0 to EVCurrent.Games.Count-1 do begin
    game:=TCLGame(EVCurrent.Games[i]);
    if ((game.GameResult='') or (game.GameResult='-'))
     and ((Game.WhiteName=fCLSocket.MyName) or (Game.BlackName=fCLSocket.MyName))
    then
      SetActiveGame(i);
  end;
end;
//===========================================================================================
procedure TfCLEventControl.SetMyCurrentGame;
var
  game: TCLGame;
begin
  game:=EVCurrent.MyCurrentGame;
  if game<>nil then
    SetActiveGame(game.EventOrdNum-1);
end;
//===========================================================================================
procedure TfCLEventControl.FormShow(Sender: TObject);
begin
  ArrangePanels;
end;
//===========================================================================================
procedure TfCLEventControl.SetEVCurrent(const Value: TCSEvent);
begin
  FEVCurrent := Value;
  if FEVCurrent=nil then exit;

  if FEVCurrent.Type_ = evtTournament then begin
    tb.Tabs.CommaText:='Members'
  end else
    tb.Tabs.CommaText:='Games,Finished';
end;
//===========================================================================================
procedure TfCLEventControl.RefreshMembers;
var
  MemberList: TCSUserList;
  user: TCSUser;
  i: integer;
  item: TListItem;
begin
  if EVCurrent=nil then exit;
  if EVCurrent.Type_ <> evtTournament then exit;
  lvMembers.Items.Clear;
  MemberList:=(EVCurrent as TCSTournament).Reglament.MemberList;
  for i:=0 to MemberList.Count-1 do begin
    user:=MemberList[i];
    AddMember(GetNameWithTitle(user.Login,user.Title),user.Rating);
  end;
end;
//===========================================================================================
procedure TfCLEventControl.InsOrUpdMember(name, title: string; rating: integer);
var
  s: string;
  index: integer;
begin
  s:=GetNameWithTitle(name,title);
  index:=FindListViewIndex(lvMembers,s,0);
  if index=-1 then
    AddMember(s,rating);
end;
//===========================================================================================
procedure TfCLEventControl.AddMember(fullname: string; rating: integer);
var
  item: TListItem;
begin
  item:=lvMembers.Items.Add;
  item.Caption:=IntToStr(lvMembers.Items.Count)+'.';
  item.SubItems.Add(fullname);
  item.SubItems.Add(IntToStr(rating));
end;
//===========================================================================================
procedure TfCLEventControl.tbStandingsClick(Sender: TObject);
begin
  RepaintActiveTable;
  fCLMain.SetActivePane(0, fCLTable);
end;
//===========================================================================================
procedure TfCLEventControl.tbMyGameClick(Sender: TObject);
var
  i: integer;
  game: TCLGame;
begin
  for i:=0 to EVCurrent.Games.Count-1 do begin
    game:=TCLGame(EVCurrent.Games[i]);
    if ((game.GameResult='') or (game.GameResult='-'))
     and ((Game.WhiteName=fCLSocket.MyName) or (Game.BlackName=fCLSocket.MyName))
    then
      SetActiveGame(i);
  end;
end;
//===========================================================================================
procedure TfCLEventControl.RepaintActiveTable;
begin
  fCLTable.Tournament:=evCurrent as TCSTournament;
  fCLTable.DrawActiveTable;
  fCLTable.Repaint;
end;
//===========================================================================================
procedure TfCLEventControl.tbAbortGameClick(Sender: TObject);
begin
  if EVCurrent = nil then exit;
  if MessageDlg('Are you sure you want to abort current game?',mtConfirmation,[mbYes,mbNo],0)=mrYes then
    fCLSocket.InitialSend([CMD_STR_EVENT_GAME_ABORT,IntToStr(EVCurrent.ID)]);
end;
//===========================================================================================
procedure TfCLEventControl.lvMembersCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (Item = nil) or (EVCurrent = nil) then exit;
  if EVCurrent.UserIsLoggedIn(Item.SubItems[0]) then
    lvMembers.Canvas.Font.Color := clBlack
  else
    lvMembers.Canvas.Font.Color := clGray;
end;
//===========================================================================================
end.

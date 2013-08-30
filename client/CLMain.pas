{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, ExtCtrls, StdCtrls, inifiles, CLSocket, CLColorButton,
  ScktComp, ImgList, ShellApi, ToolWin, FileCtrl, Buttons, CLEventNew, CLGame,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  CLLectureNew, JclDebug, AppEvnts;

type
  TPaneState = (psMaximized, psRestored, psHidden); { Don't change this order! }
  TPaneSector = (psNW, psSW, psNE, psSE, psEV);
  TActiveDivider = (dvLeft, dvLeft2, dvCenter, dvRight, dvNone);

  TPane = record
    Pane: TObject;
    State: TPaneState;
    Area: TRect;
    Sector: TPaneSector;
  end;

  TDivider = record
    Pos: Integer;
    Pct: Single;
  end;

  TPingValues = class
  private
    sl: TStringList;
    function GetPingValue(Name: string): integer;
    procedure SetPingValue(Name: string; const Value: integer);
  public
    constructor Create;
    destructor Destroy; override;
    property PingValue[Name: string]: integer read GetPingValue write SetPingValue; default;
  end;

  TfCLMain = class(TForm)
    cbFrame: TCLColorButton;
    ilMain: TImageList;
    miAbort: TMenuItem;
    miAbout: TMenuItem;
    miAddLibrary: TMenuItem;
    miAdjourn: TMenuItem;
    miAutoQueen: TMenuItem;
    miBoard: TMenuItem;
    miCaptured: TMenuItem;
    miChessLinkHomePage: TMenuItem;
    miClearPGNLib: TMenuItem;
    miCloseGame: TMenuItem;
    miCommand: TMenuItem;
    miCopy: TMenuItem;
    miCreateRoom: TMenuItem;
    miDeleteMessage: TMenuItem;
    miDetach: TMenuItem;
    miDraw: TMenuItem;
    miEnterRoom: TMenuItem;
    miExamine: TMenuItem;
    miExit: TMenuItem;
    miExitRoom: TMenuItem;
    miFile: TMenuItem;
    miFlag: TMenuItem;
    miFrameList: TMenuItem;
    miGames: TMenuItem;
    miHelp: TMenuItem;
    miLoadGame: TMenuItem;
    miLogGame: TMenuItem;
    miLogin: TMenuItem;
    miMatchDialog: TMenuItem;
    miMaximizeBottom: TMenuItem;
    miMaximizeTop: TMenuItem;
    miMessages: TMenuItem;
    miMoretime: TMenuItem;
    miNew: TMenuItem;
    miNewMessage: TMenuItem;
    miNotifyList: TMenuItem;
    miObserveGame: TMenuItem;
    miOpen: TMenuItem;
    miOpen2: TMenuItem;
    miPasteFEN: TMenuItem;    
    miPGNLib: TMenuItem;
    miProfile: TMenuItem;
    miProfileOf: TMenuItem;
    miRefresh: TMenuItem;
    miRemoveLibrary: TMenuItem;
    miReply: TMenuItem;
    miResign: TMenuItem;
    miResume: TMenuItem;
    miRooms: TMenuItem;
    miRotate: TMenuItem;
    miSeekDialog: TMenuItem;
    miSetup: TMenuItem;
    miTakeback: TMenuItem;
    miView: TMenuItem;
    mmMain: TMainMenu;
    N1: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    sbMain: TStatusBar;
    tbAbort: TToolButton;
    tbAddLibrary: TToolButton;
    tbAdjourn: TToolButton;
    tbCreateRoom: TToolButton;
    tbDeleteMessage: TToolButton;
    tbDivider: TToolButton;
    tbDraw: TToolButton;
    tbEnterRoom: TToolButton;
    tbExamine: TToolButton;
    tbExitRoom: TToolButton;
    tbFlag: TToolButton;
    tbLoadGame: TToolButton;
    tbLogin: TToolButton;
    tbMain: TToolBar;
    tbMatch: TToolButton;
    tbMoretime: TToolButton;
    tbNewMessage: TToolButton;
    tbObserveGame: TToolButton;
    tbOpen: TToolButton;
    tbOptions: TToolButton;
    tbRefresh: TToolButton;
    tbRematch: TToolButton;
    tbRemoveLibrary: TToolButton;
    tbReply: TToolButton;
    tbResign: TToolButton;
    tbResume: TToolButton;
    tbRotate: TToolButton;
    tbSeek: TToolButton;
    tbTakeback: TToolButton;
    tbLectureStart: TToolButton;
    tbLectureDelete: TToolButton;
    tbLectureNew: TToolButton;
    tbLectureEdit: TToolButton;
    tbLectureJoin: TToolButton;
    tbClubNew: TToolButton;
    tbClubEdit: TToolButton;
    tbClubEnter: TToolButton;
    tbClubDelete: TToolButton;
    miRematch: TMenuItem;
    DemoBoard1: TMenuItem;
    ilMain48: TImageList;
    ilMain32: TImageList;
    ilNotify: TImageList;
    miGameSave: TMenuItem;
    savePGN: TSaveDialog;
    miEventList: TMenuItem;
    miCreateEvent: TMenuItem;
    ilMain24: TImageList;
    ilArrowCirleColors: TImageList;
    miOpenVideo: TMenuItem;
    tbSeek1_0: TToolButton;
    tbSeek3_0: TToolButton;
    tbSeek5_0: TToolButton;
    tbSeek15_0: TToolButton;
    tbSeek3_2: TToolButton;
    tbSeek2_12: TToolButton;
    miSuspendMMThread: TMenuItem;
    miTerminate: TMenuItem;
    VideoBroadcast1: TMenuItem;
    miAdmin: TMenuItem;
    miStatistics: TMenuItem;
    miClubList: TMenuItem;
    miClubListBreak: TMenuItem;
    tbObserveHigh: TToolButton;
    ilNavigate48: TImageList;
    ilNavigate64: TImageList;
    miPersonalize: TMenuItem;
    timerServerTime: TTimer;
    tbGameSave: TToolButton;
    ApplicationEvents1: TApplicationEvents;
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
    procedure cbFrameClick(Sender: TObject);
    procedure Connect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miAbortClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miAddLibraryClick(Sender: TObject);
    procedure miAdjournClick(Sender: TObject);
    procedure miAutoQueenClick(Sender: TObject);
    procedure miCapturedClick(Sender: TObject);
    procedure miChessLinkHomePageClick(Sender: TObject);
    procedure miClearPGNLibClick(Sender: TObject);
    procedure miCloseGameClick(Sender: TObject);
    procedure miCopyClick(Sender: TObject);
    procedure miCreateRoomClick(Sender: TObject);
    procedure miDeleteMessageClick(Sender: TObject);
    procedure miDetachClick(Sender: TObject);
    procedure miLoginClick(Sender: TObject);
    procedure miDrawClick(Sender: TObject);
    procedure miEnterRoomClick(Sender: TObject);
    procedure miExamineClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure miExitRoomClick(Sender: TObject);
    procedure miFlagClick(Sender: TObject);
    procedure miFrameListClick(Sender: TObject);
    procedure miLoadGameClick(Sender: TObject);
    procedure miLogGameClick(Sender: TObject);
    procedure miMatchClick(Sender: TObject);
    procedure miMatchDialogClick(Sender: TObject);
    procedure miMaximizeTopClick(Sender: TObject);
    procedure miMoretimeClick(Sender: TObject);
    procedure miNewClick(Sender: TObject);
    procedure miNewMessageClick(Sender: TObject);
    procedure miNotifyListClick(Sender: TObject);
    procedure miObserveGameClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure miOptionsClick(Sender: TObject);
    procedure miPasteFENClick(Sender: TObject);
    procedure miProfileOfClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
    procedure miRematchClick(Sender: TObject);
    procedure miRemoveLibraryClick(Sender: TObject);
    procedure miReplyClick(Sender: TObject);
    procedure miResignClick(Sender: TObject);
    procedure miResumeClick(Sender: TObject);
    procedure miRotateClick(Sender: TObject);
    procedure miSeekDialogClick(Sender: TObject);
    procedure miSetupClick(Sender: TObject);
    procedure miTakebackClick(Sender: TObject);
    procedure DemoBoard1Click(Sender: TObject);
    procedure miGameSaveClick(Sender: TObject);
    procedure miEventListClick(Sender: TObject);
    procedure miCreateEventClick(Sender: TObject);
    procedure tbEventDeleteClick(Sender: TObject);
    procedure tbEventJoinClick(Sender: TObject);
    procedure tbEventObserveClick(Sender: TObject);
    procedure tbEventStartClick(Sender: TObject);
    procedure InitializeMM1Click(Sender: TObject);
    procedure tbSeek1_0Click(Sender: TObject);
    procedure tbSeek3_0Click(Sender: TObject);
    procedure tbSeek5_0Click(Sender: TObject);
    procedure tbSeek15_0Click(Sender: TObject);
    procedure miSuspendMMThreadClick(Sender: TObject);
    procedure miTerminateClick(Sender: TObject);
    procedure VideoBroadcast1Click(Sender: TObject);
    procedure miStatisticsClick(Sender: TObject);
    procedure miClubListClick(Sender: TObject);
    procedure tbObserveHighClick(Sender: TObject);
    procedure timerServerTimeTimer(Sender: TObject);
    procedure tbSeek3_2Click(Sender: TObject);
    procedure tbSeek2_12Click(Sender: TObject);
    procedure tbLectureNewClick(Sender: TObject);
    procedure tbLectureJoinClick(Sender: TObject);
    procedure tbLectureDeleteClick(Sender: TObject);
    procedure tbLectureStartClick(Sender: TObject);
    procedure tbClubEnterClick(Sender: TObject);
    procedure tbClubEditClick(Sender: TObject);
    procedure tbClubNewClick(Sender: TObject);
    procedure tbClubDeleteClick(Sender: TObject);
    //procedure miOpenVideoClick(Sender: TObject);

  private
    { Private declarations }
    FActiveDivider: TActiveDivider;
    FActiveRight: Integer;
    FCenterDivider: TDivider;
    FDrawMenu: Boolean;
    FFooter: Integer;
    FFrameAttached: Boolean;
    FHeader: Integer;
    FInitState: TInitState;
    FLastMenu: TMenuItem;
    FLastNE: TObject;
    FLeftDivider: TDivider;
    FLeft2Divider: TDivider;
    FMouseXY: TPoint;
    FNE: TPane;
    FNW: TPane;
    FEV: TPane;
    FNotifyAttached: Boolean;
    FEventAttached: Boolean;
    FRightDivider: array[0..7] of TDivider;
    FSE: TPane;
    FShift: TShiftState;
    FSW: TPane;
    FCreating: Boolean;
    FServerTime: TDateTime;
    FCloseWithoutConfirmation: Boolean;
    FServerTimeDiff: real;

    procedure AttachFrame;
    procedure AttachNotify;
    procedure AttachEvents;
    procedure DeactivateApplication(Sender: TObject);
    procedure DetachFrame;
    procedure DetachNotify;
    procedure DetachEvents;
    procedure SetDividerPosition;
    procedure SetFrameAttached(const Value: Boolean);
    procedure SetInitState(const State: TInitState);
    procedure SetNotifyAttached(const Value: Boolean);
    procedure SetEventAttached(const Value: Boolean);
    procedure SetPaneSize;
    procedure SetPaneState(var Pane: TPane; State: TPaneState);
    procedure CreateArrowCirleColors;

    procedure WMEraseBkgnd(var Msg: TMessage); message WM_ERASEBKGND;
    procedure WMGetMinMaxInfo(var mmInfo: TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure CMDialogKey(var Msg: TWMKey); message CM_DIALOGKEY;
    procedure WMNCPaint(var Msg: TWMNCPaint); message WM_NCPAINT;
    procedure SetServerTime(const Value: TDateTime);

  public
    { Public declarations }
    procedure HandleException(Sender: TObject; E: Exception);
    procedure SetActivePane(const Index: Integer; Data: TObject);
    procedure SetFormColors;
    procedure SetGameInfo;
    procedure ShowDialog(const Msg: string);
    procedure ShowMatchDialog(const Opponent: string);
    procedure SetToolButtonState(const Value: Integer);
    procedure ArrangeMenu;

    property FrameAttached: Boolean read FFrameAttached write SetFrameAttached;
    property InitState: TInitState read FInitState write SetInitState;
    property NotifyAttached: Boolean read FNotifyAttached write SetNotifyAttached;
    property EventAttached: Boolean read FEventAttached write SetEventAttached;
    property ServerTime: TDateTime read FServerTime write SetServerTime;
    property ServerTimeDiff: real read FServerTimeDiff write FServerTimeDiff;
    function GameIsActive(Game: TCLGame): Boolean;
    procedure SendEventCreate(F: TfCLEventNew);
    procedure SendLectureCreate(F: TfCLLectureNew);
    procedure PingValue(Datapack: TStrings);
    procedure SetClubName(Name: string);
    procedure CMD_ServerTime(Datapack: TStrings);
    function GetExceptionStack: string;
    procedure CloseAndExit;
  end;

var
  fCLMain: TfCLMain;
  fPingValues: TPingValues;
  FULL_LOAD_DIR: string;

implementation

{$R *.DFM}

uses
  CLAbout, CLBoard, CLConst, CLGlobal, CLLogin, CLMessages,
  CLNavigate, CLNotify, CLOptions, CLPGNLib, CLRooms, CLSeek, CLPgn,
  CLTerminal, CLGames, CLAccount, CLRegister, CLAccounts, CLProfile,CLLib,CLBan,
  CLDemoBoard,CLEventControl,CLEvents,CLTable, CLImageLib, CLFileLib, CLSocket2,
  CLStat, CSClub, CLClubList, CLLectures, CLCLubNew, CLAchievementClass,
  CLAchievements, CLClubs, CLMembershipType, CLSeeks, CLLogins;

const
  DIV_WIDTH: Integer = 3;
  MIN_SIZE: Integer = 80;

//______________________________________________________________________________
procedure TfCLMain.AttachFrame;
begin
  fCLNavigate.BorderStyle := bsNone;
  fCLNavigate.Parent := Self;
  SetPaneState(FNW, psRestored);
  SetPaneSize;
end;
//______________________________________________________________________________
procedure TfCLMain.AttachNotify;
begin
  SetPaneState(FSW, psRestored);
  SetPaneSize;
end;
//______________________________________________________________________________
procedure TfCLMain.AttachEvents;
begin
  fCLEventControl.BorderStyle := bsNone;
  fCLNavigate.Parent := Self;
  SetPaneState(FEV, psRestored);
  SetPaneSize;
end;
//______________________________________________________________________________
procedure TfCLMain.DetachFrame;
begin
  FActiveDivider := dvNone;
  Cursor := crDefault;
  SetPaneState(FNW, psHidden);
  SetPaneSize;
  fCLNavigate.Parent := nil;
  fCLNavigate.BorderStyle := bsDialog;
end;
//______________________________________________________________________________
procedure TfCLMain.DetachNotify;
begin
  FActiveDivider := dvNone;
  Cursor := crDefault;
  SetPaneState(FSW, psHidden);
  SetPaneSize;
end;
//______________________________________________________________________________
procedure TfCLMain.DetachEvents;
begin
  FActiveDivider := dvNone;
  Cursor := crDefault;
  SetPaneState(FEV, psHidden);
  SetPaneSize;
 { fCLEventControl.Parent := nil;
  fCLEventControl.BorderStyle := bsDialog;}
end;
//______________________________________________________________________________
procedure TfCLMain.SetDividerPosition;
var
  Index: Integer;
procedure SetDivPos(var Divider: TDivider);
begin
  Divider.Pos := Round((ClientHeight - FHeader - FFooter) * Divider.Pct);
  if Divider.Pos < MIN_SIZE then
    Divider.Pos := MIN_SIZE + FHeader
  else if ClientHeight - FHeader - FFooter - Divider.Pos < MIN_SIZE then
    Divider.Pos := ClientHeight - FFooter - MIN_SIZE
  else
    Divider.Pos := Divider.Pos + FHeader;
end;
begin
  { Set the position of each divider }

  SetDivPos(FLeftDivider);
  SetDivPos(FLeft2Divider);

  for Index := Low(FRightDivider) to High(FRightDivider) do
    SetDivPos(FRightDivider[Index]);

  FCenterDivider.Pos := Round(ClientWidth * FCenterDivider.Pct);

  if FCenterDivider.Pos < MIN_SIZE then
    FCenterDivider.Pos := MIN_SIZE
  else if FCenterDivider.Pos >= ClientWidth then
    FCenterDivider.Pos := ClientWidth - MIN_SIZE;
end;
//______________________________________________________________________________
procedure TfCLMain.SetFrameAttached(const Value: Boolean);
var
  Index: Integer;
begin
  FFrameAttached := Value;
  miFrameList.Checked := Value;
  fCLNavigate.PinGlyph(Value);

  if tbMain.Visible then
    Index := tbMain.Height
  else
    Index := 0;

  if FFrameAttached = True then
    begin
      FHeader := Index;
      AttachFrame;
    end
  else
    begin
      FHeader := Round((Index + cbFrame.Height + 2 + DIV_WIDTH) / (96 / PixelsPerInch));
      //FHeader := Index;
      DetachFrame;
    end;
end;
//______________________________________________________________________________
procedure TfCLMain.SetInitState(const State: TInitState);
begin
  if State = FInitState then Exit;
  FInitState := State;

  case FInitState of
    isConnect:
      begin
        miLogin.Caption := 'Logoff...';
        tbLogin.Hint := 'Logoff...';
        tbLogin.ImageIndex :=  21;
      end;
    isLoginComplete:
      begin
        sbMain.Panels[0].Text := fCLSocket.MyName;
        miProfileOf.Enabled := True;
      end;
    isRequestSent:
      sbMain.Panels[1].Text := 'Request Sent';
    isReceivingData:
      sbMain.Panels[1].Text := 'Receiving Data...';
    isRequestComplete:
      sbMain.Panels[1].Text := 'Complete';
    isDisconnect:
      begin
        sbMain.Panels[0].Text := '';
        sbMain.Panels[1].Text := 'Not Connected';
        miLogin.Caption := 'Login...';
        tbLogin.Hint := 'Login...';
        tbLogin.ImageIndex := 0;
        miProfileOf.Enabled := False;
      end;
  end;
end;
//______________________________________________________________________________
procedure TfCLMain.SetNotifyAttached(const Value: Boolean);
begin
  FNotifyAttached := Value;
  miNotifyList.Checked := Value;

  if FNotifyAttached = True then
    AttachNotify
  else
    DetachNotify;
end;
//______________________________________________________________________________
procedure TfCLMain.SetEventAttached(const Value: Boolean);
begin
  if NO_EVENT_MODE and Value then exit;
  FEventAttached := Value;
  miEventList.Checked := Value;

  if FEventAttached = True then
    AttachEvents
  else
    DetachEvents;
end;
//______________________________________________________________________________
procedure TfCLMain.SetPaneSize;
var
  X, Y, Y1, iTop: Integer;
begin
  LockWindowUpdate(Self.Handle);

  { Center Position }
  if (FNW.State = psHidden) and (FSW.State = psHidden) and (FEV.State = psHidden) then
    X := 0
  else
    X := FCenterDivider.Pos + DIV_WIDTH;

  { Check to see if the width has changed at all }
  { ??? LockUpdate := not ((ClientWidth - X) = (FSE.Area.Right - FSE.Area.Left + 2)); }


  iTop:=tbMain.Height;
  Y:=iTop;
  if FNW.State=psHidden then
    Y1:=Y
  else if FEV.State<>psHidden then
    Y1:=FLeft2Divider.Pos
  else if FSW.State<>psHidden then
    Y1:=FLeftDivider.Pos
  else
    Y1:=ClientHeight-FFooter;

  if FNW.State<>psHidden then
    FNW.Area := Rect(1, Y +1, FCenterDivider.Pos -1 , Y1-1);

  Y:=Y1+1;
  if FSW.State<>psHidden then
    begin
      if FEV.State<>psHidden then
        Y1:=FLeftDivider.Pos
      else
        Y1:=ClientHeight-FFooter;
      FSW.Area := Rect(1, Y+1, FCenterDivider.Pos -1, Y1-1);
    end;

  Y:=Y1;
  if FEV.State<>psHidden then
    FEV.Area := Rect(1, Y+1, FCenterDivider.Pos-1, ClientHeight-FFooter-1);


  {// Top left pane
  if FNW.State = psMaximized then
    Y := ClientHeight - FFooter
  else
    Y := FLeft2Divider.Pos;
  FNW.Area := Rect(1, FHeader +1, FCenterDivider.Pos -1 , Y -1);

  // Botton left pane
  Y1:=Y;
  if FSW.State = psMaximized then
    Y := FHeader
  else
    Y := FLeftDivider.Pos + DIV_WIDTH;

  FEV.Area := Rect(1, Y1+1, FCenterDivider.Pos -1, Y-1);

  FSW.Area := Rect(1, Y +1, FCenterDivider.Pos -1, ClientHeight - FFooter -1);}


  { Top right pane }
  if FNE.State = psMaximized then
    Y := ClientHeight - FFooter
  else
    Y := FRightDivider[FActiveRight].Pos;
  FNE.Area := Rect(X +1, iTop, ClientWidth -1, Y -1);

  { Bottom right pane }
  if FSE.State = psMaximized then
    Y := iTop
  else
    Y := FRightDivider[FActiveRight].Pos + DIV_WIDTH;
  FSE.Area := Rect(X +1, Y +1, ClientWidth -1, ClientHeight - FFooter -1);

  { Show / Hide Framebar }
  cbFrame.Visible := not FFrameAttached;
  { Show/Hide chessboard toolbuttons }
  if Assigned(FNE.Pane) then SetToolButtonState((FNE.Pane as TForm).Tag);

  try
    { Resize and set visibility for forms assigned to panes }
    if Assigned(FNW.Pane) then
      begin
        { Show/Hide before setting Area. Necessary to avoid flicker of
          "Detached" FrameList. }
        (FNW.Pane as TForm).Visible := not (FNW.State = psHidden);
        (FNW.Pane as TForm).BoundsRect := FNW.Area;
      end;

    if Assigned(FSW.Pane) then
      begin
        (FSW.Pane as TForm).BoundsRect := FSW.Area;
        (FSW.Pane as TForm).Visible := not (FSW.State = psHidden);
      end;

    if Assigned(FNE.Pane) then
      begin
        (FNE.Pane as TForm).Visible := not (FNE.State = psHidden);
        if FNE.State <> psHidden then (FNE.Pane as TForm).BoundsRect := FNE.Area;
        { ??? if FNE.State = psMaximized then (FNE.Pane as TForm).SetFocus; }
        if Assigned(FLastNE) then (FLastNE as TForm).Visible := False;
        FLastNE := nil;
      end;

    { Prevent window drawing during resize }
    if Assigned(FSE.Pane) then
      begin
        (FSE.Pane as TForm).BoundsRect := FSE.Area;
        (FSE.Pane as TForm).Visible := not (FSE.State = psHidden);
        { ??? if FSE.State = psMaximized then (FSE.Pane as TForm).SetFocus; }
      end;

    if Assigned(FEV.Pane) then
      begin
        (FEV.Pane as TForm).BoundsRect := FEV.Area;
        (FEV.Pane as TForm).Visible := not (FEV.State = psHidden);
        { ??? if FSE.State = psMaximized then (FSE.Pane as TForm).SetFocus; }
      end;
  finally
  end;

  LockWindowUpdate(0);
  { Enable Windows Drawing }
  { ??? if LockUpdate then
    LockWindowUpdate(0)
  else
    if Assigned(FSE.Pane) then TForm(FSE.Pane).Invalidate; }
  Invalidate;
end;
//______________________________________________________________________________
procedure TfCLMain.SetPaneState(var Pane: TPane; State: TPaneState);
var
  Enap: ^TPane;
begin
  { Get the partner sector }
  case Pane.Sector of
    psNW: Enap := @FSW;
    psSW: Enap := @FNW;
    psNE: Enap := @FSE;
    psSE: Enap := @FNE;
  end;

  { Negoiate with the partner sector }
  case Pane.Sector of
    psNW, psSW:
      begin
        if (Enap^.State = psHidden) and (State <> psHidden) then
          State := psMaximized
        else if (Enap^.State <> psHidden) and (State <> psHidden) then
          State := psRestored;

        if Enap^.State <> psHidden then Enap^.State :=
          TPaneState(Ord(psHidden) - Ord(State));
      end;
    psNE, psSE:
      Enap^.State := TPaneState(Ord(psHidden) - Ord(State));
  end;

  Pane.State := State;
end;
//______________________________________________________________________________
procedure TfCLMain.SetToolButtonState(const Value: Integer);
var
  Index: Integer;
  b: Boolean;
begin
  if FCreating then exit;
  for Index := 4 to tbMain.ButtonCount -1 do begin
    if (tbMain.Buttons[Index].Name = 'tbEventCreate') or
      (tbMain.Buttons[Index].Name = 'tbEventStart') or
      (tbMain.Buttons[Index].Name = 'tbEventDelete') or
      (tbMain.Buttons[Index].Name = 'tbLectureNew') or
      (tbMain.Buttons[Index].Name = 'tbLectureEdit') or
      (tbMain.Buttons[Index].Name = 'tbLectureStart') or
      (tbMain.Buttons[Index].Name = 'tbLectureDelete')
    then
       b:=fCLSocket.MyAdminLevel>0
    else if (tbMain.Buttons[Index].Name = 'tbClubNew') or
      (tbMain.Buttons[Index].Name = 'tbClubEdit') or
      (tbMain.Buttons[Index].Name = 'tbClubDelete')
    then
      b:=fCLSocket.MyAdminLevel = 3
    else
      b:=true;
    tbMain.Buttons[Index].Visible := (tbMain.Buttons[Index].Tag = Value) and b;
  end;
  //tbEventCreate.Visible:=miEventCreate.Visible;
end;
//______________________________________________________________________________
procedure TfCLMain.WMEraseBkgnd(var Msg: TMessage);
begin
  { Trap but do not process }
end;
//______________________________________________________________________________
procedure TfCLMain.WMGetMinMaxInfo(var mmInfo : TWMGetMinMaxInfo);
const
  OFFSET = 5;
begin
  with mmInfo.MinMaxInfo^ do
  begin
    ptMaxPosition.x := -OFFSET;
    ptMaxPosition.y := -OFFSET;

    ptMinTrackSize.x := Screen.Width div 2;
    ptMinTrackSize.y := Screen.Height div 2;
  end;
end;
//______________________________________________________________________________
procedure TfCLMain.CloseAndExit;
begin
  FCloseWithoutConfirmation := true;
  Self.Close;
end;
//______________________________________________________________________________
procedure TfCLMain.CMDialogKey(var Msg: TWMKey);
begin
  { Handles the Tabbing between frames. And because fHome does not have any
    Windowed controls this procedure handles the arrow keys. This is a potential
    conflict if other forms with no Windowed controls are added. }
  case Msg.CharCode of
    VK_TAB:
      begin
        if FShift = [ssCtrl] then
          fCLNavigate.clNavigate.Next
        else if FShift = [ssShift, ssCtrl] then
          fCLNavigate.clNavigate.Previous
        else
          inherited;
      end;
  else
    inherited;
  end;
end;
//______________________________________________________________________________
procedure TfCLMain.WMNCPaint(var Msg: TWMNCPaint);
begin
  { Implimented to prevent menu flicker when setting 'Action' menu visibility }
  if FDrawMenu then inherited;
end;
//______________________________________________________________________________
procedure TfCLMain.SetActivePane(const Index: Integer; Data: TObject);
var
  Menu: TMenuItem;
begin
  { Called from fCLNavigate }

  if not FrameAttached then fCLNavigate.Hide;

  { Special Case }
  if miMaximizeTop.Checked and (Data is TfCLTerminal) then
    begin
      miMaximizeBottom.Checked := True;
      SetPaneState(FSE, psMaximized);
    end
  else if miMaximizeBottom.Checked and not (Data is TfCLTerminal) then
    begin
      miMaximizeTop.Checked := True;
      SetPaneState(FNE, psMaximized);
    end;
  { End Special Case }

  Menu := nil;

  { Different game or different form? It is important that a .Pane is only
    assigned a TForm (or nil) because SetPaneSize assumes that each .Pane
    is a Form (This includes FLastNE) }
  FLastNE := FNE.Pane;
  { Special case }
  if (Data is TfCLTerminal) then
    begin
      Data := nil;
      if (FLastNE is TfCLBoard) and (fCLBoard.GM <> nil) then
        Data := fCLBoard.GM;
      if (FLastNE is TfCLProfile) and (fCLProfile.Profile <> nil) then
        Data := fCLProfile.Profile;
      if Data = nil then
        Data := fCLSeeks
      else
        Data := FLastNE;
    end;

  FNE.Pane := Data;

  if (Data is TCLProfile) then
    begin
      FActiveRight := 0;
      Menu := miProfile;
      FNE.Pane := fCLProfile;
      fCLProfile.Profile := TCLProfile(Data);
    end
  else if (Data is TfCLPGNLib) then
    begin
      FActiveRight := 1;
      Menu := miPGNLib;
    end
  else if (Data is TfCLGames) then
    begin
      FActiveRight := 2;
      Menu := miGames;
    end
  else if (Data is TfCLMessages) then
    begin
      FActiveRight := 3;
      Menu := miMessages;
    end
  else if (Data is TfCLRooms) then
    begin
      FActiveRight := 4;
      Menu := miRooms;
    end
  else if (Data is TfCLSeeks) then
    begin
      FActiveRight := 5;
      Menu := nil;
    end
  else if (Data is TCLGame) then
    begin
      FActiveRight := 6;
      Menu := miBoard;
      FNE.Pane := fCLBoard;
      fCLBoard.GM := TCLGame(Data);
    end
  else if (Data is TfCLEvents) then
    begin
      FActiveRight := 7;
      Menu := nil;
    end
  else if (Data is TfCLEvents) then
    begin
      FActiveRight := 8;
      Menu := nil;
    end;

  if FLastNE = FNE.Pane then FLastNE := nil;

  { Prevent drawing of the menubar. Hide old 'Action' menu. Show new 'Action' }
  FDrawMenu := (Menu = nil) or (FLastMenu = nil);
  if Assigned(FLastMenu) and (Menu <> FLastMenu) then
    begin
      FLastMenu.Visible := False;
      FLastMenu.Enabled := False;
    end;
  if Assigned(Menu) and (Menu <> FLastMenu) then
    begin
      Menu.Enabled := True;
      Menu.Visible := True;
    end;
  FDrawMenu := True;
  FLastMenu := Menu;

  { Set the Frame button caption }
  if (FNE.Pane is TfCLBoard) then
      cbFrame.Caption := fCLBoard.GM.WhiteName + ' vs ' + fCLBoard.GM.BlackName
  else if (FNE.Pane is TfCLProfile) then
    cbFrame.Caption := fCLProfile.Caption
  else
    cbFrame.Caption := (FNE.Pane as TForm).Caption;

  { Show / Hide proper frames }
  SetPaneSize;
  { Show / Hide game info in status bar}
  SetGameInfo;

  if FNE.Pane is TfCLBoard then
    TfCLBoard(FNE.Pane).SetMenuState;

end;
//______________________________________________________________________________
procedure TfCLMain.SetGameInfo;
begin
  { Clear the game info. }
  sbMain.Panels[2].Text := '';
  if not (FNE.Pane is TfCLBoard) then Exit;
  { If the Board is showing display the game number. }
  if fCLBoard.GM.GameNumber > -1 then
    sbMain.Panels[2].Text := '(' + IntToStr(fCLBoard.GM.GameNumber) + ')'
  else
    sbMain.Panels[2].Text := '(local)';
  { Display the game style. }
  sbMain.Panels[2].Text := sbMain.Panels[2].Text + #32 + fCLBoard.GM.GameStyle;
  if fCLBoard.GM.GameResult <> '' then
    sbMain.Panels[2].Text := sbMain.Panels[2].Text + #32 + '('
    + fCLBoard.GM.GameResult + #32 + fCLBoard.GM.GameResultDesc + ')';
end;
//______________________________________________________________________________
procedure TfCLMain.ShowDialog(const Msg: string);
begin
  ShowMessage(Msg);
end;
//______________________________________________________________________________
procedure TfCLMain.ShowMatchDialog(const Opponent: string);
begin
  fCLSeek := TfCLSeek.Create(nil);
  with fCLSeek do
    begin
      edtOpponent.Text := Opponent;
      SeekMode := smMatch;
      ShowModal;
    end;
end;
//______________________________________________________________________________
procedure TfCLMain.cbFrameClick(Sender: TObject);
begin
  fCLNavigate.SetBounds(Left + 2, Top + (Height - ClientHeight) + FHeader -6,
    300, ClientHeight - FHeader);
  fCLNavigate.Show;
end;
//______________________________________________________________________________
procedure TfCLMain.Connect(Sender: TObject);
begin
  if InitState = isDisconnect then begin
    fCLSocket.InitState := isConnect;
  end else
    if FCLoseWithoutConfirmation or (MessageDlg(QRY_LOGOFF, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
      fCLSocket2.Disconnect;
      fCLSocket.InitState := isDisconnect;
    end;
end;
//______________________________________________________________________________
procedure TfCLMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Index: Integer;
begin

  if FileExists(ERROR_LOG_FILENAME) then
    MessageDlg(
      'There were errors during work of this program. '+#13#10+
      'Please, send file '+ERROR_LOG_FILENAME+#13#10+
      'to email support@infiniachess.com. '+#13#10+
      'You will help to make program better. '+#13#10+
      'Thank you very much :-)',
      mtInformation,[mbOk],0);

  if InitState in [isConnect..isRequestComplete] then Connect(nil);
  if InitState in [isConnect..isRequestComplete] then
    begin
      Action := caNone;
      Exit;
    end;

  if WindowState = wsNormal then
    begin
      fGL.MainLeft := Left;
      fGL.MainTop := Top;
      fGL.MainWidth := Width;
      fGL.MainHeight := Height;
    end;
  if WindowState <> wsMinimized then fGL.MainState := Ord(WindowState);

  fGL.DivLeft := Round(FLeftDivider.Pct * 100);
  fGL.DivLeft2 := Round(FLeft2Divider.Pct * 100);
  fGL.DivCenter := Round(FCenterDivider.Pct * 100);
  for Index := Low(FRightDivider) to High(FRightDivider) do
    fGL.DivRight[Index] := Round(FRightDivider[Index].Pct * 100);

  fGL.FrameAttached := FFrameAttached;
  fGL.NotifyAttached := FNotifyAttached;
  //fGL.EventAttached := FEventAttached;

  { Close objects }
  FNW.Pane := nil;
  FSW.Pane := nil;
  FNE.Pane := nil;
  FSE.Pane := nil;
  FEV.Pane := nil;

  fCLNavigate.Close; { Needs to be first }
  fCLBoard.Close;
  fCLTerminal.Close;
  fCLNotify.Close;
  fCLEventControl.Close;
  if Assigned(fCLPGNLib) then fCLPGNLib.Close;
  if Assigned(fCLGames) then fCLGames.Close;
  if Assigned(fCLMessages) then fCLMessages.Close;
  if Assigned(fCLRooms) then FCLRooms.Close;
  if Assigned(fCLSeeks) then fCLSeeks.Close;
  if Assigned(fCLProfile) then fCLProfile.Close;
  if Assigned(fCLTable) then fCLTable.Close;
  if Assigned(fCLAchievements) then fCLAchievements.Close;
  fPingValues.Free;
  fCLSocket.Free;
  fGL.Save;
  fGL.Free;
  if Assigned(fLoginImages) then fLoginImages.Free;

  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLMain.FormCreate(Sender: TObject);
var
  Index: Integer;
  fname: string;
begin

  if not DirectoryExists(MAIN_DIR+ERROR_LOG_DIR) then
    CreateDir(MAIN_DIR+ERROR_LOG_DIR);
  ERROR_LOG_FILENAME:=MAIN_DIR+ERROR_LOG_DIR+FormatDateTime('yyyy-mm-dd-hh-nn',Date+Time)+'.log';

  Application.OnException:=HandleException;
  FCreating:=true;
  { Load custom cursor. }
  FULL_LOAD_DIR:=MAIN_DIR+LOAD_DIR;
  fname:=FULL_LOAD_DIR+'infiniachess.exe';
  if DirectoryExists(FULL_LOAD_DIR) and FileExists(fname) then
    begin
      CopyFile(PChar(fname),PChar(MAIN_DIR+'infiniachess.exe'),false);
      DeleteFile(fname);
    end;

  Screen.Cursors[crIEHand] := LoadCursor(HInstance, 'HAND');

  miCreateEvent.Visible:=not NO_EVENT_MODE;
  miEventList.Visible:=not NO_EVENT_MODE;

  FActiveRight := 2;
  FDrawMenu := True;
  FLastMenu := miGames;
  FFooter := sbMain.Height;
  FMouseXY := Point(-1, -1);
  FFrameAttached := fGL.FrameAttached;
  FNotifyAttached := fGL.NotifyAttached;
  FEventAttached := false; //fGL.EventAttached;

(*
  FLeftDivider.Pct := fGL.DivLeft * 0.01;
  FCenterDivider.Pct := fGL.DivCenter * 0.01;
  for Index := Low(FRightDivider) to High(FRightDivider) do
    FRightDivider[Index].Pct := fGL.DivRight[Index] * 0.01;
  SetBounds(fGL.MainLeft, fGL.MainTop, fGL.MainWidth, fGL.MainHeight);
  { Show needs to proceed WindowState so that the main form will open maximized
    correctly. }
  Show;
  WindowState := TWindowState(fGL.MainState);
*)
  { Initialize the Frame States }
  FNW.Sector := psNW;
  FSW.Sector := psSW;
  FNE.Sector := psNE;
  FSE.Sector := psSE;
  FEV.Sector := psEV;

  FNW.State := psHidden;
  FSW.State := psHidden;
  FNE.State := psRestored;
  FSE.State := psRestored;
  FEV.State := psRestored;

  Log('Creating objects...');
  AchList := TCLAchList.Create;
  { Create the child forms }
  fCLPGNLib := TfCLPGNLib.Create(nil);
  fCLGames := TfCLGames.Create(nil);
  fCLMessages := TfCLMessages.Create(nil);
  fCLRooms := TfCLRooms.Create(nil);
  //fCLOffers := TfCLOffers.Create(nil);
  fCLSeeks := TfCLSeeks.Create(nil);
  fCLProfile := TfCLProfile.Create(nil);
  fCLBoard := TfCLBoard.Create(nil);
  fCLTerminal := TfCLTerminal.Create(nil);
  fLoginList := TLoginList.Create;
  fCLNavigate := TfCLNavigate.Create(nil);
  fCLNotify := TfCLNotify.Create(nil);
  fCLEventControl := TfCLEventControl.Create(nil);
  fCLEvents := TfCLEvents.Create(nil);
  fCLTable := TfCLTable.Create(nil);
  fLoginImages := TLoginImages.Create;
  fCLStat := TfCLStat.Create(nil);
  fClubs := TClubs.Create;
  fPingValues := TPingValues.Create;
  //fCLClubList := TfCLClubList.Create(nil);
  fCLClubs := TfCLClubs.Create(nil);
  fCLClubs.SetListMode(clmClubs);
  fCLClubs.Name := 'fCLClubs';
  fCLSchools := TfCLClubs.Create(nil);
  fCLSchools.SetListMode(clmSchools);
  fCLSchools.Name := 'fCLSchools';
  fCLLectures := TfCLLectures.Create(nil);
  MyAchUserList := TCLAchUserList.Create;
  fCLAchievements := TfCLAchievements.Create(nil);

  fCLMembershipTypes := TCLMembershipTypes.Create;
  Log('Objects created.');

  fCLPGNLib.Parent := Self;
  fCLGames.Parent := Self;
  fCLMessages.Parent := Self;
  fCLRooms.Parent := Self;
  //fCLOffers.Parent := Self;
  fCLSeeks.Parent := Self;
  fCLProfile.Parent := Self;
  fCLBoard.Parent := Self;
  fCLTerminal.Parent := Self;
  fCLNavigate.Parent := Self;
  fCLNotify.Parent := Self;
  fCLEventControl.Parent := Self;
  fCLEvents.Parent := Self;
  fCLTable.Parent := Self;
  fCLStat.Parent := Self;
  //fCLClubList.Parent := Self;
  fCLClubs.Parent := Self;
  fCLSchools.Parent := Self;
  fCLAchievements.Parent := Self;
  //fCLClubList.BorderStyle := bsNone;
  //fCLClubList.pnlButtons.Visible := false;
  fCLLectures.Parent := Self;

  FNE.Pane := fCLGames;
  FNW.Pane := fCLNavigate;
  FSE.Pane := fCLTerminal;
  FSW.Pane := fCLNotify;
  FEV.Pane := fCLEventControl;

  { Add necessary forms to fCLNavigate }
  with fCLNavigate.clNavigate do
    begin
      Items.AddObject('Library', fCLPGNLib);
      Items.AddObject('Messages', fCLMessages);
      Items.AddObject('Chat Rooms', fCLRooms);
      Items.AddObject('Seeks', fCLSeeks);
      if not NO_EVENT_MODE then
        Items.AddObject('Events', fCLEvents);
      Items.AddObject('Lectures', fCLLectures);
      Items.AddObject('Live Games', fCLGames);
      Items.AddObject('Clubs', fCLClubs);
      Items.AddObject('Schools', fCLSchools);
      //Items.AddObject('Achievements', fCLAchievements);

      {Items.AddObject('Library' + #10 + '(of local PGN games)', fCLPGNLib);
      Items.AddObject('Messages' + #10 + '(from other players)', fCLMessages);
      Items.AddObject('Chat Rooms', fCLRooms);
      Items.AddObject('Seeks' + #10 + '(players seeking opponents)', fCLSeeks);
      if not NO_EVENT_MODE then
        Items.AddObject('Events', fCLEvents);
      Items.AddObject('Games' + #10 + '(being played)', fCLGames);}
      ItemIndex:=4;
    end;

  FrameAttached := FFrameAttached;
  NotifyAttached := FNotifyAttached;
  EventAttached := FEventAttached;

  FLeftDivider.Pct := fGL.DivLeft * 0.01;
  FLeft2Divider.Pct := fGL.DivLeft2 * 0.01;
  FCenterDivider.Pct := fGL.DivCenter * 0.01;
  for Index := Low(FRightDivider) to High(FRightDivider) do
    FRightDivider[Index].Pct := fGL.DivRight[Index] * 0.01;
  SetBounds(fGL.MainLeft, fGL.MainTop, fGL.MainWidth, fGL.MainHeight);
  { Show needs to proceed WindowState so that the main form will open maximized
    correctly. }
  Show;
  WindowState := TWindowState(fGL.MainState);

  SetDividerPosition;

  Application.OnDeactivate := DeactivateApplication;

  IS_BANNED:=IsBanned;
  SetFormColors;

  { Show Login Dialog (displays Regisiter if no account found). }
  miLogin.Click;
  FCreating:=false;
  SetToolButtonState(9);
  fCLNavigate.clNavigate.ItemIndex:=3;
  CreateArrowCirleColors;
  ServerTime := Date + Time;
end;
//______________________________________________________________________________
procedure TfCLMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  c: char;
  s: string;
begin
  FShift := Shift;
  if not (ssAlt in Shift) and not (ssCtrl in Shift) and not fCLTerminal.edtInput.Focused and (Key>=32)
    and not fCLProfile.edtRoomName.Focused and not fCLProfile.edtText.Focused
    and not fCLProfile.edtECO.Focused and not fCLProfile.edtOpponent.Focused
    and not fCLProfile.edtPage.Focused
    and not fCLStat.edStrParam.Focused and not fCLMessages.edtSender.Focused
    and not fCLMessages.edtText.Focused and not fCLMessages.edPage.Focused
  then
    with fCLTerminal.edtInput do begin
      SetFocus;
      c:=chr(Key);
      if ssShift in Shift then s:=uppercase(c)
      else s:=lowercase(c);
      Text:=Text+s;
      SelStart:=length(Text);
    end;
end;
//______________________________________________________________________________
procedure TfCLMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_TAB then Exit;
  FShift := [];
end;
//______________________________________________________________________________
procedure TfCLMain.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (Y > FHeader) then FMouseXY := Point(X, Y);
end;
//______________________________________________________________________________
procedure TfCLMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  {Assign a cursor based on the Divider the mouse pointer is over}

  { X that is greater than -1 means the mouse button has already been pressed. }
  if FMouseXY.X > -1 then Exit;

  if (FNW.State = psRestored) and (X < FCenterDivider.Pos -1)
     and (X > 1) and (Y > FHeader)
  then
    if (Y<FLeftDivider.Pos-1) then
      FActiveDivider := dvLeft2
    else
      FActiveDivider := dvLeft
  else if ((FNW.State <> psHidden) or (FSW.State <> psHidden))
     and (Y > FHeader) and (X >= FCenterDivider.Pos)
     and (X <= FCenterDivider.Pos + DIV_WIDTH)
  then
    FActiveDivider := dvCenter
  else if (Y >= FRightDivider[FActiveRight].Pos)
     and (Y <= FRightDivider[FActiveRight].Pos + DIV_WIDTH)
  then
    FActiveDivider := dvRight
  else
    FActiveDivider := dvNone;

  case FActiveDivider of
    dvCenter: Cursor := crHSplit;
    dvLeft, dvRight: Cursor := crVSplit;
    dvNone: Cursor := crDefault;
  end;

end;
//______________________________________________________________________________
procedure TfCLMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  { For the divider "moved", set it's percentage of the screen }
  if (FMouseXY.X = X) and (FMouseXY.Y = Y) then
    begin
      FMouseXY := Point(-1, -1);
      Exit;
    end
  else
    FMouseXY := Point(-1, -1);

  if X < MIN_SIZE then X := 0;
  if X > ClientWidth - MIN_SIZE then X := ClientWidth;
  if Y < FHeader + MIN_SIZE then Y := 0;
  if Y > ClientHeight-MIN_SIZE-FFooter then Y := ClientHeight;

  case FActiveDivider of
    dvLeft:
      begin
        if Y<=FLeft2Divider.Pos then Y:=FLeft2Divider.Pos+1;
        FLeftDivider.Pct := (Y - FHeader) / (ClientHeight - FHeader - FFooter);
      end;
    dvLeft2:
      begin
        if Y>=FLeftDivider.Pos then Y:=FLeftDivider.Pos-1;
        FLeft2Divider.Pct := (Y - FHeader) / (ClientHeight - FHeader - FFooter);
      end;
    dvCenter:
      FCenterDivider.Pct := X / ClientWidth;
    dvRight:
      FRightDivider[FActiveRight].Pct :=
        (Y - FHeader) / (ClientHeight - FHeader - FFooter);
  end;

  SetDividerPosition;
  SetPaneSize;

end;
//______________________________________________________________________________
procedure TfCLMain.FormPaint(Sender: TObject);
var
  R: TRect;
begin
  { Drawing to avoid flicker is tricky. Do not erase any of the background.
    Rather fill in what needs to be erased.
    It's extra work but worth the effort. }

  if not FFrameAttached then
    with Canvas do
      begin
        { Draw the Header Frame }
        R := Rect(0, 0, ClientWidth, FHeader - DIV_WIDTH);
        Brush.Color := clAppWorkSpace;
        FillRect(R);
        MoveTo(0, 1);
        Pen.Color := clBtnFace;
        LineTo(ClientWidth, 1);
        { Fill in the buffer }
        R := Rect(0, FHeader - DIV_WIDTH, ClientWidth, FHeader);
        Brush.Color := clBtnFace;
        FillRect(R);
      end;

  { Fill in the divider bars }
  with Canvas do
    begin
      Brush.Color := clBtnFace;
      R := Rect(0, FLeftDivider.Pos, FCenterDivider.Pos,
        FLeftDivider.Pos + DIV_WIDTH);
      FillRect(R);
      R := Rect(FCenterDivider.Pos, FHeader,
        FCenterDivider.Pos + DIV_WIDTH, ClientHeight);
      FillRect(R);
      R := Rect(0, FRightDivider[FActiveRight].Pos,
        ClientWidth, FRightDivider[FActiveRight].Pos + DIV_WIDTH);
      FillRect(R);
    end;

  { Draw Frames }
  if Assigned(FNW.Pane) and not (FNW.State = psHidden) then
    begin
      R := FNW.Area;
      InflateRect(R, 1, 1);
      Frame3D(Canvas, R, clBtnShadow, clBtnHighLight, 1);
    end;

  if Assigned(FEV.Pane) and not (FEV.State = psHidden) then
    begin
      R := FEV.Area;
      InflateRect(R, 1, 1);
      Frame3D(Canvas, R, clBtnShadow, clBtnHighLight, 1);
    end;

  if Assigned(FSW.Pane) and not (FSW.State = psHidden) then
    begin
      R := FSW.Area;
      InflateRect(R, 1, 1);
      Frame3D(Canvas, R, clBtnShadow, clBtnHighLight, 1);
    end;

  if Assigned(FSE.Pane) and not (FSE.State = psHidden) then
    begin
      R := FSE.Area;
      InflateRect(R, 1, 1);
      Frame3D(Canvas, R, clBtnShadow, clBtnHighLight, 1);
    end;

  if Assigned(FNE.Pane) and not (FNE.State = psHidden) then
    begin
      R := FNE.Area;
      InflateRect(R, 1, 1);
      Frame3D(Canvas, R, clBtnShadow, clBtnHighLight, 1);
    end;
end;
//______________________________________________________________________________
procedure TfCLMain.FormResize(Sender: TObject);
begin
  SetDividerPosition;
  SetPaneSize;
end;
//______________________________________________________________________________
procedure TfCLMain.miAbortClick(Sender: TObject);
begin
  fCLBoard.miAbortClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.miAboutClick(Sender: TObject);
begin
  with TfCLAbout.Create(Application) do ShowModal;
end;
//______________________________________________________________________________
procedure TfCLMain.miAddLibraryClick(Sender: TObject);
begin
  fCLProfile.miAddLibrary.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miAdjournClick(Sender: TObject);
begin
  fCLBoard.miAdjournClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.miAutoQueenClick(Sender: TObject);
begin
  fCLBoard.miAutoQueen.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miCapturedClick(Sender: TObject);
begin
  fCLBoard.miCaptured.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miChessLinkHomePageClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(CHESSLINK_WEB), '', '', SW_SHOWNORMAL);
end;
//______________________________________________________________________________
procedure TfCLMain.miClearPGNLibClick(Sender: TObject);
begin
  fCLPGNLib.miClear.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miCloseGameClick(Sender: TObject);
begin
  fCLBoard.miClose.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miCopyClick(Sender: TObject);
begin
  fCLBoard.miCopyClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.miCreateRoomClick(Sender: TObject);
begin
  fCLRooms.miCreateRoom.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miDeleteMessageClick(Sender: TObject);
begin
  fCLMessages.miDeleteMessage.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miDetachClick(Sender: TObject);
begin
  fCLBoard.miDetach.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miDrawClick(Sender: TObject);
begin
  fCLBoard.miDrawClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.miEnterRoomClick(Sender: TObject);
begin
  fCLRooms.miEnterRoom.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miExamineClick(Sender: TObject);
begin
  fCLProfile.miExamine.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miExitClick(Sender: TObject);
begin
  Close;
end;
//______________________________________________________________________________
procedure TfCLMain.miExitRoomClick(Sender: TObject);
begin
  fCLRooms.miExitRoom.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miFlagClick(Sender: TObject);
begin
  fCLBoard.miFlagClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.miFrameListClick(Sender: TObject);
begin
  FrameAttached := not FrameAttached;
end;
//______________________________________________________________________________
procedure TfCLMain.miLoadGameClick(Sender: TObject);
begin
  fCLPGNLib.miLoadGame.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miLogGameClick(Sender: TObject);
begin
  fCLBoard.miLogGame.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miLoginClick(Sender: TObject);
begin
  if InitState = isDisconnect then
    begin
      if fGL.Accounts.Count = 0 then
        with TfCLAccounts.Create(nil) do ShowModal
      else
        begin
          fCLLogin := TfCLLogin.Create(nil);
          fCLLogin.ShowModal;
        end;
    end
  else
    if FCLoseWithoutConfirmation or (MessageDlg(QRY_LOGOFF, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
      fCLSocket.InitState := isDisconnect;
end;
//______________________________________________________________________________
procedure TfCLMain.miMatchClick(Sender: TObject);
begin
  fCLNotify.miMatch.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miMatchDialogClick(Sender: TObject);
begin
  ShowMatchDialog('');
end;
//______________________________________________________________________________
procedure TfCLMain.miMaximizeTopClick(Sender: TObject);
var
  Obj: TObject;
  Index: Integer;
begin
  (Sender as TMenuItem).Checked := not (Sender as TMenuItem).Checked;

  Index := fCLNavigate.clNavigate.Items.IndexOfObject(fCLTerminal);
  if (miMaximizeTop.Checked or miMaximizeBottom.Checked) and (Index = -1) then
    begin
      Index := fCLNavigate.clNavigate.Items.Count - fCLBoard.UsualGameCount;
      fCLNavigate.clNavigate.Items.InsertObject(Index, 'Terminal', fCLTerminal);
    end;

  if miMaximizeTop.Checked then
    begin
      SetPaneState(FNE, psMaximized);
      Obj := FNE.Pane;
    end
  else if miMaximizeBottom.Checked then
    begin
      SetPaneState(FSE, psMaximized);
      Obj := FSE.Pane;
    end
  else
    begin
      Obj := FNE.Pane;
      SetPaneState(FNE, psRestored);
      if Index>-1 then
        fCLNavigate.clNavigate.Items.Delete(Index);
    end;

  if (Obj is TfCLBoard) then Obj := fCLBoard.GM;

  with fCLNavigate.clNavigate do
    begin
      ItemIndex := Items.IndexOfObject(Obj);
      if ItemIndex > -1 then Items[ItemIndex] := Items[ItemIndex];
    end;

  SetPaneSize;
end;
//______________________________________________________________________________
procedure TfCLMain.miMoretimeClick(Sender: TObject);
begin
  fCLBoard.miMoretime.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miNewClick(Sender: TObject);
begin
  fCLNavigate.AddGame(fCLBoard.CreateGame);
end;
//______________________________________________________________________________
procedure TfCLMain.miNewMessageClick(Sender: TObject);
begin
  fCLMessages.miNewMessage.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miNotifyListClick(Sender: TObject);
begin
  NotifyAttached := not NotifyAttached;
end;
//______________________________________________________________________________
procedure TfCLMain.miObserveGameClick(Sender: TObject);
begin
  fCLGames.miGamesObserve.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miOpenClick(Sender: TObject);
begin
  fCLPGNLib.miOpen.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miOptionsClick(Sender: TObject);
begin
  fCLOptions := TfCLOptions.Create(nil);
  fCLOptions.ShowModal;
end;
//______________________________________________________________________________
procedure TfCLMain.miPasteFENClick(Sender: TObject);
begin
  fCLBoard.miPasteFEN.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miProfileOfClick(Sender: TObject);
var
  s: string;
begin
  s := InputBox('Profile of...', 'Enter the name of a player.', '');
  if s <> '' then
    begin
      s := Copy(s, 1, 15);
      fCLSocket.InitialSend([CMD_STR_PROFILE, s]);
    end;
end;
//______________________________________________________________________________
procedure TfCLMain.miRefreshClick(Sender: TObject);
begin
  fCLProfile.miRefresh.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miRematchClick(Sender: TObject);
begin
  fCLBoard.miRematch.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miRemoveLibraryClick(Sender: TObject);
begin
  fCLProfile.miRemoveLibrary.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miReplyClick(Sender: TObject);
begin
  fCLMessages.miReply.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miResignClick(Sender: TObject);
begin
  fCLBoard.miResignClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.miResumeClick(Sender: TObject);
begin
  fCLProfile.miResume.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miRotateClick(Sender: TObject);
begin
  fCLBoard.miRotateClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.miSeekDialogClick(Sender: TObject);
begin
  fCLSeek := TfCLSeek.Create(nil);
  fCLSeek.ShowModal;
end;
//______________________________________________________________________________
procedure TfCLMain.miSetupClick(Sender: TObject);
begin
  fCLBoard.miSetup.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.miTakebackClick(Sender: TObject);
begin
  fCLBoard.miTakeback.Click;
end;
//______________________________________________________________________________
procedure TfCLMain.DeactivateApplication(Sender: TObject);
begin
  fCLNavigate.SetSwitchedAllGames;
end;
//______________________________________________________________________________
procedure TfCLMain.DemoBoard1Click(Sender: TObject);
var F: TfCLDemoBoard;
begin
  F:=TfCLDemoBoard.Create(Application);
  if F.ShowModal=mrOk then
    fCLSocket.InitialSend([CMD_STR_DEMOBOARD, F.edWhite.Text+'('+F.cmbWhiteTitle.Text+')',
      F.edBlack.Text+'('+F.cmbBlackTitle.Text+')',
      F.edWhiteRating.Text,F.edBlackRating.Text]);
  F.Free;
end;
//______________________________________________________________________________
procedure TfCLMain.SetFormColors;
begin
  fCLNavigate.Color:=fGL.FramesColor;
  fCLNavigate.clNavigate.Color:=fGL.FramesColor;
  fCLNavigate.clNavigate.Repaint;
  fCLNotify.Color:=fGL.NotifyColor;
  fCLNotify.clNotify.Color:=fGL.NotifyColor;
  fCLEventControl.Color:=fGL.EventColor;
  fCLEventControl.pnlGames.Color:=fGL.EventColor;
  fCLEventControl.pnlHeader.Color:=fGL.EventColor;
  fCLEventControl.pnlMyLocation.Color:=fGL.SimulCurrentGameColor;
  fCLEventControl.pnlLeaderLocation.Color:=fGL.SimulLeaderGameColor;
  fCLEventControl.pnlTop.Color:=fGL.EventColor;
  //fCLOffers.Color:=fGL.DefaultBackgroundCOlor;
  fCLSeeks.Color := fGL.DefaultBackgroundCOlor;
  fCLGames.lvGames.Color:=fGL.DefaultBackgroundCOlor;
  fCLPGNLib.lvPGNLib.Color:=fGL.DefaultBackgroundCOlor;
  fCLRooms.lvRooms.Color:=fGL.DefaultBackgroundCOlor;
  fCLMessages.lvMessages.Color:=fGL.DefaultBackgroundCOlor;
  fCLMessages.Panel4.Color:=fGL.DefaultBackgroundCOlor;
  fCLEvents.lvEvents.Color:=fGL.DefaultBackgroundCOlor;
  fCLEvents.pnlInfo.Color:=fGL.EventCOlor;
  fCLTable.Color:=fGL.DefaultBackgroundColor;
  fCLProfile.Color:=fGL.DefaultBackgroundColor;
  //fCLClubList.Color:=fGL.DefaultBackgroundColor;
  fCLClubs.Color:=fGL.DefaultBackgroundColor;
  fCLLectures.Color:=fGL.DefaultBackgroundColor;
  fCLAchievements.Color:=fGL.DefaultBackgroundColor;
  fCLAchievements.SetChildrenParams;
  //fCLStat.Color:=fGL.DefaultBackgroundColor;
end;
//______________________________________________________________________________
procedure TfCLMain.miGameSaveClick(Sender: TObject);
var
  Dir: string;
  PGN: TCLPgn;
begin
  if not fCLSocket.Rights.SavingGames then begin
    MessageDlg('Your membership has ended. You cannot save games.',
      mtWarning, [mbOk], 0);
    exit;
  end;
  if not Assigned(fCLBoard.GM) then begin
    showmessage('First start the game');
    exit;
  end;
  Dir:=ExtractFileDir(Application.ExeName);
  Dir:=Dir+'\Saved Games';
  if not DirectoryExists(Dir) then
     CreateDir(Dir);
  savePGN.InitialDir:=dir;
  if savePGN.Execute then begin
    PGN := TCLPgn.Create(savePGN.FileName, pmWrite);
    PGN.LogGame(fCLBoard.GM);
    PGN.Free;
  end;
end;
//______________________________________________________________________________
procedure TfCLMain.miEventListClick(Sender: TObject);
begin
  if (fCLEventControl.EVCurrent<>nil) or (EventAttached) then
    EventAttached := not EventAttached;
end;
//______________________________________________________________________________
var cmd1: array [0..4] of string = ('s','c','k','t','l');
//______________________________________________________________________________
procedure TfCLMain.miCreateEventClick(Sender: TObject);
var
  F: TfCLEventNew;
begin
  F:=TfCLEventNew.Create(Application);
  if F.ShowModal=mrOk then
    SendEventCreate(F);
  F.Free;
end;
//______________________________________________________________________________
procedure TfCLMain.tbEventDeleteClick(Sender: TObject);
begin
  fCLEvents.miDeleteClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.tbEventJoinClick(Sender: TObject);
begin
  fCLEvents.miJoinClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.tbEventObserveClick(Sender: TObject);
begin
  fCLEvents.miObserveClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.tbEventStartClick(Sender: TObject);
begin
  fCLEvents.miStartClick(Sender);
end;
//______________________________________________________________________________
procedure TfCLMain.ApplicationEvents1Exception(Sender: TObject; E: Exception);
var
  Str: TStringList;
begin
  Str := TStringList.Create;
  try
    JclLastExceptStackListToStrings(Str, True, True, True, True);
    Str.Insert(0, E.Message);
    Str.Insert(1, '');
    Application.MessageBox(PChar(Str.Text), 'Îøèáêà', MB_OK or MB_ICONSTOP);
  finally
    FreeAndNil(Str);
  end;
end;
//______________________________________________________________________________
procedure TfCLMain.ArrangeMenu;
begin
  miCreateEvent.Visible:=fCLSocket.MyAdminLevel>0;

  miStatistics.Visible:=fCLSocket.MyAdminLevel = 3;

  miAdmin.Visible := miStatistics.Visible;

end;
//______________________________________________________________________________
function TfCLMain.GameIsActive(Game: TCLGame): Boolean;
begin
  result:=(FNE.Pane = fCLBoard) and (fCLBoard.GM = Game);
end;
//______________________________________________________________________________
function TfCLMain.GetExceptionStack: string;
var
  sl: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  try
    JclLastExceptStackListToStrings(sl, True, True, True, True);
    result := '';
    for i := 0 to sl.Count - 1 do begin
      if result <> '' then result := result + ' <- ';
      result := result + sl[i];
      if length(result) > 2048 then
        break;
    end;
    SetLength(result, 2048);
  finally
    FreeAndNil(sl);
  end;
end;
//______________________________________________________________________________
procedure TfCLMain.SendEventCreate(F: TfCLEventNew);
var
  i,TimeLimit,ShoutStart,ShoutInc: integer;
  itm: TListItem;
  min,InitTime,IncTime,Rating,Pieces,LeaderName: string;
  sRatedType,ENumber,NumberOfRounds,sReserved,sClubList: string;
begin
  if F.edLeader.Visible then LeaderName:=F.edLeader.Text
  else LeaderName:='-';

  TimeLimit:=BoolTo_(F.cbTimeLimit.Checked,F.udTimeLimit.Position,-1);
  ShoutStart:=BoolTo_(F.cbShout.Checked,F.udShoutStart.Position,-1);
  ShoutInc:=BoolTo_(F.cbShout.Checked,F.udShoutInc.Position,-1);

  if F.cbRatedType.ItemIndex=0 then sRatedType:='0'
  else sRatedType:=IntToStr(F.cbRatedType.ItemIndex+2);

  if F.cbDimension.ItemIndex = 0 then min:=F.edMin.Text
  else min:='0.'+F.edMin.Text;

  //sReserved:=RemoveSpaces(F.edReserved.Text);
  if sReserved='' then sReserved:='-';

  sClubList:=F.Clubs.CheckedList;
  if sClubList='' then sClubList:=IntToStr(fCLSocket.ClubId);

  fCLSocket.InitialSend([CMD_STR_EVENT_CREATE,
    IntToStr(F.ID),
    Replace(F.edName.Text,' ','_'),
    cmd1[F.cbType.ItemIndex],'FL',FloatToStr(F.dtDate.Date+F.dtTime.Time),
    LeaderName,Replace(F.edDescription.Text,' ','_'),
    F.edMinRating.Text,
    F.edMaxRating.Text,
    IntToStr(F.udGames.Position),
    min,IntToStr(F.udSec.Position),
    IntToStr(TimeLimit),IntToStr(ShoutStart),
    IntToStr(ShoutInc),
    sRatedType,
    BoolTo_(F.cbProvisional.Checked,'1','0'),
    BoolTo_(F.cbRated.Checked,'1','0'),
    BoolTo_(F.cbAdminOnly.Checked,'1','0'),
    BoolTo_(F.cbAutoStart.Checked,'1','0'),
    sReserved,
    sClubList,
    BoolTo_(F.cbLagRestriction.Checked,'1','0'),
    BoolTo_(F.cbShoutEveryRound.Checked,'1','0')]);

  case F.cbType.ItemIndex of
    0,2: fCLSocket.InitialSend([CMD_STR_EVENT_PARAMS,'0',
      IntToStr(F.cbLeaderColor.ItemIndex)]);
    1: fCLSocket.InitialSend([CMD_STR_EVENT_PARAMS,'0',
      IntToStr(F.cbLeaderColor.ItemIndex),
      BoolTo_(F.cbOneGame.Checked,'1','0')]);
    3: begin // tournament
         if F.cbTourType.ItemIndex=3 then // match
           if F.sbRoundWins.Caption='R' then begin
             NumberOfRounds:='0';
             ENumber:=F.edRounds.Text;
           end else begin
             NumberOfRounds:=F.edRounds.Text;
             ENumber:='0';
           end
         else if F.cbTourType.ItemIndex=2 then begin
           NumberOfRounds:=F.edRounds.Text;
           ENumber:='0';
         end else begin
           NumberOfRounds:='0';
           ENumber:=F.edRounds.Text;
         end;
         fCLSocket.InitialSend([CMD_STR_EVENT_PARAMS,IntToStr(F.ID),
           IntToStr(F.cbTourType.ItemIndex),
           IntToStr(F.cbRoundsOrder.ItemIndex),
           ENumber,
           IntToStr(F.udPause.Position),NumberOfRounds,
           F.edMinPeople.Text, F.edMaxPeople.Text]);
       end;
  end;

  if trim(F.edShoutMsg.Text)<>'' then
    fCLSocket.InitialSend([CMD_STR_EVENT_SHOUT, IntToStr(F.ID), trim(F.edShoutMsg.Text)]);

  if trim(F.edCongMsg.Text)<>'' then
    fCLSocket.InitialSend([CMD_STR_EVENT_CONG, IntToStr(F.ID), trim(F.edCongMsg.Text)]);

  if F.pnlOdds.Visible then
    with F.Odds.lv do begin
      for i:=Items.Count-1 downto 0 do begin
        itm:=Items[i];
        Rating:=itm.SubItems[3];
        InitTime:=itm.SubItems[0];
        if InitTime='' then InitTime:=min
        else InitTime:=TimeConvertToPoint(InitTime);
        IncTime:=itm.SubItems[1];
        if IncTime='' then IncTime:=IntToStr(F.udSec.Position);
        Pieces:=itm.SubItems[2];
        if Pieces='' then Pieces:='-';
        fCLSocket.InitialSend([CMD_STR_ODDS_ADD,
          '0',Rating,InitTime,IncTime,Pieces]);
      end;
  end;

  fCLSocket.InitialSend([CMD_STR_EVENT_TICKETS_BEGIN,IntToStr(F.ID)]);
  for i:=0 to F.Tickets.lv.Items.Count-1 do begin
    itm:=F.Tickets.lv.Items[i];
    fCLSocket.InitialSend([CMD_STR_EVENT_TICKET,IntToStr(F.ID),itm.Caption]);
  end;
  fCLSocket.InitialSend([CMD_STR_EVENT_TICKETS_END,IntToStr(F.ID)]);

  fCLSocket.InitialSend([CMD_STR_EVENT_CREATE_END,IntToStr(F.ID)]);
end;
//______________________________________________________________________________
procedure TfCLMain.HandleException(Sender: TObject; E: Exception);
begin
  ProcessError('Interface', GetExceptionStack, integer(ErrorAddr), E.Message, '');
end;
//______________________________________________________________________________
procedure TfCLMain.CreateArrowCirleColors;
var
  bmp: TBitMap;
  sl: TStringList;
  i: integer;
  col: TColor;
  desc: string;
begin
  sl:=TSTringList.Create;
  Str2StringList(ArrowCircleColors,sl);
  for i:=0 to sl.Count-1 do begin
    ColorDescByName(sl[i],col,desc);
    bmp:=TBitMap.Create;
    bmp.Width:=16;
    bmp.Height:=16;
    bmp.Canvas.Pen.Color:=col;
    bmp.Canvas.Brush.Color:=col;
    bmp.Canvas.Rectangle(0,0,16,16);
    ilArrowCirleColors.Add(bmp,nil);
  end;
  sl.Free;
end;
//______________________________________________________________________________
{procedure TfCLMain.miOpenVideoClick(Sender: TObject);
var
  od: TOpenDialog;
  F: TfCLVideo;
begin
  od:=TOpenDialog.Create(Application);
  od.FileName := '*.mpg;*.mpeg;*.vro;*.avi;*.wav;*.mp3;*.asf;*.wmv;*.vob';
   if not od.Execute then exit;
   F:=TfCLVideo.Create(Application);
   F.Visible:=true;
   F.VG.PlayerFileName := od.FileName;
   F.VG.OpenPlayer;
end;}

{ TProcLog }

//============================================================
procedure TfCLMain.InitializeMM1Click(Sender: TObject);
begin
end;
//============================================================
procedure TfCLMain.tbSeek1_0Click(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_SEEK,'1','0']);
end;
//============================================================
procedure TfCLMain.tbSeek3_0Click(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_SEEK,'3','0']);
end;
//============================================================
procedure TfCLMain.tbSeek5_0Click(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_SEEK,'5','0']);
end;
//============================================================
procedure TfCLMain.tbSeek15_0Click(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_SEEK,'15','0']);
end;
//============================================================
procedure TfCLMain.miSuspendMMThreadClick(Sender: TObject);
begin
  miSuspendMMThread.Checked:=not miSuspendMMThread.Checked;
  if miSuspendMMThread.Checked then
    fCLSocket2Thread.Suspend
  else
    fCLSocket2Thread.Resume;
end;
//============================================================
procedure TfCLMain.miTerminateClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to terminate?',mtWarning,
    [mbYes,mbNo],0) = mrYes
  then
    fCLSocket2Thread.Terminate;
end;
//============================================================
procedure TfCLMain.VideoBroadcast1Click(Sender: TObject);
// var F: TfCLVideo;
begin
  {if fGL.VideoInputDevice = DEVICE_NONE then begin
    MessageDlg(MSG_VIDEO_DEVICE_NOT_DEFINED,mtInformation,[mbOk],0);
    exit;
  end;
  F:=TfCLVideo.Create(Application);
  F.Show;}
end;
//============================================================
procedure TfCLMain.PingValue(Datapack: TStrings);
begin
  if Datapack.Count<2 then exit;
  sbMain.Panels[3].Text := 'Lag: '+Datapack[1]+' msec';
end;
//============================================================
procedure TfCLMain.miStatisticsClick(Sender: TObject);
begin
  fCLStat.Visible:=true;
  fCLStat.Show;
end;
//============================================================
procedure TfCLMain.miClubListClick(Sender: TObject);
begin
  fClubs.fCLClubList:=TfCLClubList.Create(Application);
  with fClubs.fCLClubList do begin
    ListType:=cltNormal;
    ShowModal;
    Free;
  end;
end;
//============================================================
procedure TfCLMain.SetClubName(Name: string);
begin
  sbMain.Panels[4].Text:=Name;
end;
//============================================================
{ TPingValues }

constructor TPingValues.Create;
begin
  sl:=TStringList.Create;
end;
//============================================================
destructor TPingValues.Destroy;
begin
  inherited;
  sl.Free;
end;
//============================================================
function TPingValues.GetPingValue(Name: string): integer;
var
  s: string;
begin
  s:=sl.Values[lowercase(Name)];
  if s = '' then result:=0
  else result:=StrToInt(s);
end;
//============================================================
procedure TPingValues.SetPingValue(Name: string; const Value: integer);
begin
  sl.Values[lowercase(Name)]:=IntToStr(Value);
  fCLBoard.OnUserLag(Name,Value);
end;
//============================================================
procedure TfCLMain.tbObserveHighClick(Sender: TObject);
begin
  fCLGames.miObserveHigh.Click;
end;
//============================================================
procedure TfCLMain.SetServerTime(const Value: TDateTime);
begin
  FServerTime := Value;
  sbMain.Panels[5].Text := 'Server time '+FormatDateTime('mmm dd hh:mm AM/PM', FServerTime);
end;
//============================================================
procedure TfCLMain.CMD_ServerTime(Datapack: TStrings);
begin
  if Datapack.Count < 2 then exit;
  try
    ServerTime := Str2Float(Datapack[1]);
  except
  end;
end;
//============================================================
procedure TfCLMain.timerServerTimeTimer(Sender: TObject);
begin
  ServerTime := ServerTime + timerServerTime.Interval/(SecsPerDay*MSecs);
end;
//============================================================
procedure TfCLMain.tbSeek3_2Click(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_SEEK,'3','2']);
end;
//============================================================
procedure TfCLMain.tbSeek2_12Click(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_SEEK,'2','12']);
end;
//============================================================
procedure TfCLMain.tbLectureNewClick(Sender: TObject);
var
  F: TfCLLectureNew;
begin
  F:=TfCLLectureNew.Create(Application);
  if F.ShowModal=mrOk then
    SendLectureCreate(F);
  F.Free;
end;
//============================================================
procedure TfCLMain.SendLectureCreate(F: TfCLLectureNew);
var
  ShoutStart, ShoutInc: integer;
  sClubList: string;
begin
  ShoutStart:=BoolTo_(F.cbShout.Checked,F.udShoutStart.Position,-1);
  ShoutInc:=BoolTo_(F.cbShout.Checked,F.udShoutInc.Position,-1);

  sClubList:=F.Clubs.CheckedList;
  if sClubList='' then sClubList:=IntToStr(fCLSocket.ClubId);

  fCLSocket.InitialSend([CMD_STR_EVENT_CREATE,
    IntToStr(F.ID),
    Replace(F.edName.Text,' ','_'),
    'l', // type of event - lecture
    'FL',FloatToStr(F.dtDate.Date+F.dtTime.Time),
    F.edLecturer.Text,Replace(F.edDescription.Text,' ','_'),
    '0', // min rating
    '5000', // max rating
    '-1', // games
    '0', // initial minutes
    '0', // incremention seconds
    '-1', // time limit
    IntToStr(ShoutStart),
    IntToStr(ShoutInc),
    '0', // rated type
    '1', // provisional
    '0', // rated
    BoolTo_(F.cbAdminOnly.Checked,'1','0'),
    BoolTo_(F.cbAutoStart.Checked,'1','0'),
    '-', // reserved
    sClubList,
    '0', // lag restriction
    '0' // shout every round
    ]);

  if trim(F.edShoutMsg.Text)<>'' then
    fCLSocket.InitialSend([CMD_STR_EVENT_SHOUT, IntToStr(F.ID), trim(F.edShoutMsg.Text)]);

  fCLSocket.InitialSend([CMD_STR_EVENT_CREATE_END,IntToStr(F.ID)]);
end;
//============================================================
procedure TfCLMain.tbLectureJoinClick(Sender: TObject);
begin
  fCLLectures.miJoin.Click;
end;
//============================================================
procedure TfCLMain.tbLectureDeleteClick(Sender: TObject);
begin
  fCLLectures.miDelete.Click;
end;
//============================================================
procedure TfCLMain.tbLectureStartClick(Sender: TObject);
begin
  fCLLectures.miStart.Click;
end;
//============================================================
procedure TfCLMain.tbClubEnterClick(Sender: TObject);
begin
  fCLClubs.miGoToClub.Click;
end;
//============================================================
procedure TfCLMain.tbClubEditClick(Sender: TObject);
begin
  fCLClubs.miManageClub.Click;
end;
//============================================================
procedure TfCLMain.tbClubNewClick(Sender: TObject);
var
  F: TfClubNew;
  itm: TListItem;
begin
  F := TfClubNew.Create(Application);
  if F.ShowModal = mrOk then
    fCLSocket.InitialSend([CMD_STR_CLUB, IntToStr(F.CurrentID), IntToStr(F.cmbType.ItemIndex), F.edName.Text]);
  F.Free;
end;
//============================================================
procedure TfCLMain.tbClubDeleteClick(Sender: TObject);
begin
  fCLClubs.miDelete.Click;
end;
//============================================================
initialization
  JclStartExceptionTracking;

finalization
  JclStopExceptionTracking;
//============================================================
end.


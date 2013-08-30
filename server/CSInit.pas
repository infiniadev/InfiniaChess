unit CSInit;

interface

uses ExtCtrls, SysUtils, contnrs, CSTypes, Windows, controls, JclDebug;

type
  TSheduleTask = class
  public
    Method: TObjectProcedure;
    Interval: integer; // milliseconds
    LastLaunched: TDateTime;
  end;

  TShedule = class(TObjectList)
  public
    procedure AddTask(p_Method: TObjectProcedure; p_Interval: integer);
  end;

  TCSInit = class
  private
    { Private declarations }
    FServiceEnabled: Boolean;
    FTimer: TTimer;
    FShedule: TShedule;
    FCurrentDate: TDate;

    procedure OnTimer(Sender: TObject);
    procedure SetServiceEnabled(const Value: Boolean);
    procedure StartService;
    procedure StopService;
    procedure InitShedule;
    procedure CheckForNewDay;
  public
    { Public declarations }

    constructor Create;
    destructor Destroy; override;

    property ServiceEnabled: Boolean read FServiceEnabled write SetServiceEnabled;
  end;

var
  fInit: TCSInit;

implementation

uses
  CSCommand, CSConnections, CSDB, CSGames, CSLibrary, CSMessages, CSOffers,
  CSProfiles, CSRooms, CSSocket, CSConst, CSLib, CSEvents, CSMail, CSSocket2,
  CSTimeStat, CSAccessLevels, CSAchievements, CSActions;

//==============================================================================
{ TCSInit }
//==============================================================================
procedure TCSInit.CheckForNewDay;
begin
  if FCurrentDate <> Date then begin
    FCurrentDate := Date;
    fConnections.NullifyAllGamesPerDay;
  end;
end;
//==============================================================================
constructor TCSInit.Create;
begin
  FCurrentDate := Date;

  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := 250;
  FTimer.OnTimer := OnTimer;

  FShedule := TShedule.Create;
end;
//==============================================================================
destructor TCSInit.Destroy;
begin
  FTimer.Free;
  FShedule.Free;
  inherited;
end;
//==============================================================================
procedure TCSInit.InitShedule;
begin
  AssertInMainThread;
  with FShedule do begin
    AddTask(fConnections.CheckIdleTime, 15000);
    AddTask(fConnections.Flush, 15000);
    AddTask(fConnections.Ping, 60000);
    AddTask(fEvents.OnTimer, 60000);
    AddTask(fConnections.UnbanByTime, 300000);
    AddTask(fGames.SetFlagEventResults, 5000);
    AddTask(fGames.CheckTimeForfeits, 1000);
    AddTask(fDB.SetServerOnline, 300000);
    AddTask(fDB.SaveUsersOnline, 300000);
    AddTask(fConnections.DoEngineActions, 1000);
    AddTask(fConnections.SetEnginePingValues, 60000);
    AddTask(fCommand.DoDeferredCommands, 1000);
    AddTask(Self.CheckForNewDay, 60000);
  end;
end;
//==============================================================================
procedure TCSInit.OnTimer(Sender: TObject);
var
  d1: TDateTime;
  i, OnTimerWorkMSec: integer;
  Task: TSheduleTask;
begin
  d1 := Now;
  if MAIN_THREAD_ID = 0 then
    MAIN_THREAD_ID := GetCurrentThreadID;

  try
    for i := 0 to FShedule.Count - 1 do begin
      Task := TSheduleTask(FShedule[i]);
      if GetDateDiffMSec(Task.LastLaunched, Now) > Task.Interval then begin
        Task.LastLaunched := Now;
        Task.Method;
      end;
    end;
  except
    on E:Exception do begin
      ErrLog('========================================');
      ErrLog('Time: ' + DateTimeToStr(Now));
      ErrLog('CSInit.OnTimer');
      ErrLog('Error: ' + E.Message);
      ErrLog('Stack: ');
      ErrLog(GetExceptionStack);
      ErrLog('========================================');
    end;
  end;
  OnTimerWorkMSec := GetDateDiffMSec(d1, Now);
  fTimeStat.AddTime('OnTimer',OnTimerWorkMSec);
  fDB.SaveLagStat('server','ontimer','',OnTimerWorkMSec);
end;
//==============================================================================
procedure TCSInit.SetServiceEnabled(const Value: Boolean);
begin
  if FServiceEnabled = Value then exit;

  FServiceEnabled := Value;

  if FServiceEnabled then StartService
  else StopService;
end;
//==============================================================================
procedure TCSInit.StartService;
var
  dumb: string;
begin
  ErrLog('TCSInit.StartService', nil);
  fSocket := TSocket.Create;
  ErrLog('fSocket created', nil);
  fSocket2 := TSocket2.Create;
  ErrLog('fSocket2 created', nil);
  fActions := TActions.Create;
  ErrLog('fActions created', nil);
  fDB := TDB.Create;
  ErrLog('fDB created', nil);
  fDB.Init;
  ErrLog('fDB.Init', nil);
  fConnections := TConnections.Create;
  ErrLog('fConnections created', nil);
  fCommand := TCommand.Create;
  ErrLog('fCommand created', nil);
  fOffers := TOffers.Create;
  ErrLog('fOffers created', nil);
  fLibrary := TLibrary.Create;
  ErrLog('fLibrary created', nil);
  fGames := TGames.Create;
  ErrLog('fGames created', nil);
  fMessages := TMessages.Create;
  ErrLog('fMessaages created', nil);
  fRooms := TRooms.Create;
  ErrLog('fRooms created', nil);
  fProfiles := TProfiles.Create;
  ErrLog('fProfiles created', nil);
  fEvents := TCSEvents.Create;
  ErrLog('fEvents created', nil);
  fAccessLevels := TAccessLevels.Create;
  ErrLog('fAccessLevels created', nil);
  fAchievements := TAchievements.Create;
  ErrLog('fAchievements created', nil);
  fAchUserLibrary := TAchUserLibrary.Create;
  ErrLog('fAchUserLibrary created', nil);

  CreateMailObjects;
  ConnectMail(dumb);
  FTimer.Enabled := True;
  ErrLog('Mail objects created', nil);
  InitShedule;
  ErrLog('started.', nil);

  ErrLog('====================================',nil);
  ErrLog('Started...',nil);
  ErrLog(Format('MAIN_THREAD_ID = %d', [MAIN_THREAD_ID]), nil);
end;
//==============================================================================
procedure TCSInit.StopService;
begin
  FShedule.Clear;
  FTimer.Enabled := False;
  DestroyMailObjects;
  fAchUserLibrary.Free;
  fAchievements.Free;
  fAccessLevels.Free;
  fEvents.Free;
  fProfiles.Free;
  fRooms.Free;
  fLibrary.Free;
  fOffers.Free;
  fCommand.Free;
  fConnections.Free;
  fDB.Free;
  fActions.Free;
  fSocket2.Free;
  fSocket.Free;
  MAIN_THREAD_ID := 0;

  ErrLog('Stopped.',nil);
  ErrLog('====================================',nil);
end;
//==============================================================================
{ TShedule }

procedure TShedule.AddTask(p_Method: TObjectProcedure; p_Interval: integer);
var
  Task: TSheduleTask;
begin
  Task := TSheduleTask.Create;
  Task.Method := p_Method;
  Task.Interval := p_Interval;
  Task.LastLaunched := 0;
  Add(Task);
end;
//==============================================================================
initialization
  JclStartExceptionTracking;

finalization
  JclStopExceptionTracking;
//============================================================
end.

{*******************************************************}
{                                                       }
{         Delphi VCL Extensions (RX)                    }
{                                                       }
{         Copyright (c) 1996 AO ROSNO                   }
{         Copyright (c) 1997, 1998 Master-Bank          }
{                                                       }
{ Patched by Polaris Software                           }
{*******************************************************}

unit RxTimer;

interface

{$I RX.INC}
{$IFDEF RX_D6}
{$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}
uses{$IFNDEF VER80}Windows, {$ELSE}WinTypes, WinProcs, {$ENDIF}
  Messages, SysUtils, Classes, Controls;

type

  {  TRxTimer  }

  TRxTimer = class(TComponent)
  private
    FEnabled: Boolean;
    FInterval: Cardinal;
    FOnTimer: TNotifyEvent;
    FWindowHandle: HWND;
{$IFNDEF VER80}
    FSyncEvent: Boolean;
    FThreaded: Boolean;
    FTimerThread: TThread;
    FThreadPriority: TThreadPriority;
    procedure SetThreaded(Value: Boolean);
    procedure SetThreadPriority(Value: TThreadPriority);
{$ENDIF}
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure UpdateTimer;
    procedure WndProc(var Msg: TMessage);
  protected
    procedure Timer; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
{$IFNDEF VER80}
    procedure Synchronize(Method: TThreadMethod);
{$ENDIF}
  published
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
{$IFNDEF VER80}
    property SyncEvent: Boolean read FSyncEvent write FSyncEvent default True;
    property Threaded: Boolean read FThreaded write SetThreaded default True;
    property ThreadPriority: TThreadPriority read FThreadPriority write
      SetThreadPriority default tpNormal;
{$ENDIF}
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
  end;

  {  TCustomThread  }

  TCustomThread = class(TThread)
  private
    FOnExecute: TNotifyEvent;
  protected
    procedure Execute; override;
  public
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
    property Terminated;
  end;

  {  TRxThread  }

  TRxThread = class(TComponent)
  private
    FThread: TCustomThread;
    FSyncMethod: TNotifyEvent;
    FSyncParams: Pointer;
    FStreamedSuspended, FCycled: Boolean;
    FOnExecute, FOnException: TNotifyEvent;
    FInterval: Integer;
    procedure InternalSynchronize;
    function GetHandle: THandle;
    function GetThreadID: THandle;
    function GetOnTerminate: TNotifyEvent;
    procedure SetOnTerminate(Value: TNotifyEvent);
    function GetPriority: TThreadPriority;
    procedure SetPriority(Value: TThreadPriority);
    function GetReturnValue: Integer;
    procedure SetReturnValue(Value: Integer);
    function GetSuspended: Boolean;
    procedure SetSuspended(Value: Boolean);
    function GetTerminated: boolean;
  protected
    procedure DoExecute(Sender: TObject); virtual;
    procedure DoException(Sender: TObject); virtual;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Execute;
    procedure Synchronize(Method: TThreadMethod);
    procedure SynchronizeEx(Method: TNotifyEvent; Params: Pointer);
    procedure Suspend;
    procedure Resume;
    procedure Terminate;
    function TerminateWaitFor: Integer;
    procedure TerminateHard;
    function WaitFor: Integer;
    property ReturnValue: Integer read GetReturnValue write SetReturnValue;
    property Handle: THandle read GetHandle;
    property ThreadID: THandle read GetThreadID;
    property Terminated: Boolean read GetTerminated;
    procedure Delay(MSecs: Longint);
  published
    property OnTerminate: TNotifyEvent read GetOnTerminate write SetOnTerminate;
    property Priority: TThreadPriority read GetPriority write SetPriority;
    property Suspended: Boolean read GetSuspended write SetSuspended default True;
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
    property OnException: TNotifyEvent read FOnException write FOnException;
    property Interval: Integer read FInterval write FInterval;
    property Cycled: Boolean read FCycled write FCycled;
  end;

implementation

uses Forms, Consts, RxVCLUtils;

{$IFNDEF VER80}

{ TTimerThread }

type
  TTimerThread = class(TThread)
  private
    FOwner: TRxTimer;
    FInterval: Cardinal;
    FException: Exception;
    procedure HandleException;
  protected
    procedure Execute; override;
  public
    constructor Create(Timer: TRxTimer; Enabled: Boolean);
  end;

constructor TTimerThread.Create(Timer: TRxTimer; Enabled: Boolean);
begin
  FOwner := Timer;
  inherited Create(not Enabled);
  FInterval := 1000;
  FreeOnTerminate := True;
end;

procedure TTimerThread.HandleException;
begin
  if not (FException is EAbort) then
  begin
    if Assigned(Application.OnException) then
      Application.OnException(Self, FException)
    else
      Application.ShowException(FException);
  end;
end;

procedure TTimerThread.Execute;

  function ThreadClosed: Boolean;
  begin
    Result := Terminated or Application.Terminated or (FOwner = nil);
  end;

begin
  repeat
    if not ThreadClosed then
      if SleepEx(FInterval, False) = 0 then
      begin
        if not ThreadClosed and FOwner.FEnabled then
          with FOwner do
            if SyncEvent then Synchronize(Timer)
            else
            try
              Timer;
            except
              on E: Exception do
              begin
                FException := E;
                HandleException;
              end;
            end;
      end;
  until Terminated;
end;

{$ENDIF}

{ TRxTimer }

constructor TRxTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled := True;
  FInterval := 1000;
{$IFNDEF VER80}
  FSyncEvent := True;
  FThreaded := True;
  FThreadPriority := tpNormal;
  FTimerThread := TTimerThread.Create(Self, False);
{$ELSE}
  FWindowHandle := AllocateHWnd(WndProc);
{$ENDIF}
end;

destructor TRxTimer.Destroy;
begin
  Destroying;
  FEnabled := False;
  FOnTimer := nil;
{$IFNDEF VER80}
  {TTimerThread(FTimerThread).FOwner := nil;}
  while FTimerThread.Suspended do
    FTimerThread.Resume;//{$IFDEF RX_D14}Start{$ELSE}Resume{$ENDIF};
  FTimerThread.Terminate;
  {if not SyncEvent then FTimerThread.WaitFor;}
  if FWindowHandle <> 0 then
  begin
{$ENDIF}
    KillTimer(FWindowHandle, 1);
{$IFDEF RX_D6}Classes.{$ENDIF}DeallocateHWnd(FWindowHandle); // Polaris
{$IFNDEF VER80}
  end;
{$ENDIF}
  inherited Destroy;
end;

procedure TRxTimer.WndProc(var Msg: TMessage);
begin
  with Msg do
    if Msg = WM_TIMER then
    try
      Timer;
    except
      Application.HandleException(Self);
    end
    else Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

procedure TRxTimer.UpdateTimer;
begin
{$IFNDEF VER80}
  if FThreaded then
  begin
    if FWindowHandle <> 0 then
    begin
      KillTimer(FWindowHandle, 1);
{$IFDEF RX_D6}Classes.{$ENDIF}DeallocateHWnd(FWindowHandle); // Polaris
      FWindowHandle := 0;
    end;
    if not FTimerThread.Suspended then FTimerThread.Suspend;
    TTimerThread(FTimerThread).FInterval := FInterval;
    if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
    begin
      FTimerThread.Priority := FThreadPriority;
      while FTimerThread.Suspended do
        FTimerThread.Resume; //{$IFDEF RX_D14}Start{$ELSE}Resume{$ENDIF};
    end;
  end
  else
  begin
    if not FTimerThread.Suspended then FTimerThread.Suspend;
    if FWindowHandle = 0 then FWindowHandle := {$IFDEF RX_D6}Classes.{$ENDIF}AllocateHWnd(WndProc) // Polaris
    else KillTimer(FWindowHandle, 1);
    if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
      if SetTimer(FWindowHandle, 1, FInterval, nil) = 0 then
        raise EOutOfResources.Create(ResStr(SNoTimers));
  end;
{$ELSE}
  KillTimer(FWindowHandle, 1);
  if (FInterval <> 0) and FEnabled and Assigned(FOnTimer) then
    if SetTimer(FWindowHandle, 1, FInterval, nil) = 0 then
      raise EOutOfResources.Create(ResStr(SNoTimers));
{$ENDIF}
end;

procedure TRxTimer.SetEnabled(Value: Boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TRxTimer.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

{$IFNDEF VER80}
procedure TRxTimer.SetThreaded(Value: Boolean);
begin
  if Value <> FThreaded then
  begin
    FThreaded := Value;
    UpdateTimer;
  end;
end;

procedure TRxTimer.SetThreadPriority(Value: TThreadPriority);
begin
  if Value <> FThreadPriority then
  begin
    FThreadPriority := Value;
    if FThreaded then UpdateTimer;
  end;
end;

procedure TRxTimer.Synchronize(Method: TThreadMethod);
begin
  if (FTimerThread <> nil) then
  begin
    with TTimerThread(FTimerThread) do
    begin
      if Suspended or Terminated then Method
      else TTimerThread(FTimerThread).Synchronize(Method);
    end;
  end
  else Method;
end;
{$ENDIF}

procedure TRxTimer.SetOnTimer(Value: TNotifyEvent);
begin
  if Assigned(FOnTimer) <> Assigned(Value) then
  begin
    FOnTimer := Value;
    UpdateTimer;
  end
  else
    FOnTimer := Value;
end;

procedure TRxTimer.Timer;
begin
  if FEnabled and not (csDestroying in ComponentState) and Assigned(FOnTimer) then
    FOnTimer(Self);
end;

{  TCustomThread  }

procedure TCustomThread.Execute;
begin
  if Assigned(FOnExecute) then FOnExecute(Self);
end;

{  TThreadHack  }

type  TThreadHack = class(TCustomThread);

{  TRxThread  }

constructor TRxThread.Create(AOwner: TComponent);
begin
  inherited;
  FStreamedSuspended := True;
  FThread := TCustomThread.Create(True);
  FThread.OnExecute := DoExecute;
  FInterval := 0;
  FCycled := False;
end;

destructor TRxThread.Destroy;
begin
  if not FStreamedSuspended then
    FThread.Suspend;
  FThread.Free;
  inherited;
end;

procedure TRxThread.DoExecute(Sender: TObject);
begin
  repeat
    Delay(FInterval);
    if FThread.Terminated then Break;
    try
      if Assigned(FOnExecute) then FOnExecute(Self);
    except
      SynchronizeEx(DoException, ExceptObject);
    end;
  until FThread.Terminated or not (Cycled);
end;

procedure TRxThread.DoException(Sender: TObject);
var
  s: string;
begin
  if Assigned(FOnException) then
    FOnException(Sender)
  else
  begin
    s := Format('Thread %s raised exception class %s with message ''%s''.',
      [Name, Exception(Sender).ClassName, Exception(Sender).Message]);
    Application.MessageBox(PChar(s), PChar(Application.Title),
      MB_ICONERROR or MB_SETFOREGROUND or MB_APPLMODAL);
  end;
end;

function TRxThread.GetHandle: THandle;
begin
  Result := FThread.Handle;
end;

function TRxThread.GetOnTerminate: TNotifyEvent;
begin
  Result := FThread.OnTerminate;
end;

function TRxThread.GetPriority: TThreadPriority;
begin
  Result := FThread.Priority;
end;

function TRxThread.GetReturnValue: Integer;
begin
  Result := TThreadHack(FThread).ReturnValue;
end;

function TRxThread.GetSuspended: Boolean;
begin
  if not (csDesigning in ComponentState) then
    Result := FThread.Suspended
  else
    Result := FStreamedSuspended;
end;

procedure TRxThread.Execute;
begin
  TerminateHard;
  FThread.Resume; //{$IFDEF RX_D14}Start{$ELSE}Resume{$ENDIF};
end;

procedure TRxThread.Loaded;
begin
  inherited;
  SetSuspended(FStreamedSuspended);
end;

procedure TRxThread.SetOnTerminate(Value: TNotifyEvent);
begin
  FThread.OnTerminate := Value;
end;

procedure TRxThread.SetPriority(Value: TThreadPriority);
begin
  FThread.Priority := Value;
end;

procedure TRxThread.SetReturnValue(Value: Integer);
begin
  TThreadHack(FThread).ReturnValue := Value;
end;

procedure TRxThread.SetSuspended(Value: Boolean);
begin
  if not (csDesigning in ComponentState) then
  begin
    if (csLoading in ComponentState) then
      FStreamedSuspended := Value
    else
      FThread.Suspended := Value;
  end
  else
    FStreamedSuspended := Value;
end;

procedure TRxThread.Suspend;
begin
  FThread.Suspend;
end;

procedure TRxThread.Synchronize(Method: TThreadMethod);
begin
  TThreadHack(FThread).Synchronize(Method);
end;

procedure TRxThread.InternalSynchronize;
begin
  FSyncMethod(FSyncParams);
end;

procedure TRxThread.SynchronizeEx(Method: TNotifyEvent; Params: Pointer);
begin
  if not Assigned(FSyncMethod) then
  begin
    FSyncMethod := Method; FSyncParams := Params;
    try
      TThreadHack(FThread).Synchronize(InternalSynchronize);
    finally
      FSyncMethod := nil; FSyncParams := nil;
    end;
  end;
end;

procedure TRxThread.Resume;
begin
  FThread.Resume; //{$IFDEF RX_D14}Start{$ELSE}Resume{$ENDIF};
end;

procedure TRxThread.Terminate;
begin
  FThread.Terminate;
end;

function TRxThread.TerminateWaitFor: Integer;
begin
  Terminate;
  Result := WaitFor;
end;

procedure TRxThread.TerminateHard;
var
  FTmp: TCustomThread;
begin
  TerminateThread(FThread.Handle, 0);
  FTmp := TCustomThread.Create(True);
  try
    FTmp.Priority := Self.Priority;
    FTmp.OnExecute := DoExecute;
    FTmp.OnTerminate := Self.OnTerminate;
  except
    FTmp.Free;
    raise;
  end;
  FThread.Free;
  FThread := FTmp;
end;

function TRxThread.WaitFor: Integer;
begin
  Result := FThread.WaitFor;
end;

function TRxThread.GetTerminated: boolean;
begin
  Result := FThread.Terminated;
end;

function TRxThread.GetThreadID: THandle;
begin
  Result := FThread.ThreadID;
end;

procedure TRxThread.Delay(MSecs: Longint);
var
  FirstTickCount, Now: Longint;
begin
  if MSecs < 0 then exit;
  FirstTickCount := GetTickCount;
  repeat
    Sleep(1);
    Now := GetTickCount;
  until (Now - FirstTickCount >= MSecs) or (Now < FirstTickCount) or Terminated;
end;

end.

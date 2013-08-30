unit CSEngine;

interface

uses classes, SysUtils, DosCommand;

type
  TEngineMove = string;
  EngineNotExecutedException = class(Exception);

  TNotifyEngineMove = procedure(Sender: TObject; p_Move: TEngineMove) of object;
  TNotifyEngineTerminate = procedure(Sender: TObject) of object;

  TEngineLibrary = class
  private
    slMoves: TStrings;
  public
    constructor Create(p_FileName: string);
    destructor Destroy; override;
    function GetNextMove(MovesHistory: string): string;
    function GetFirstMove: string;
  end;

  TEngineInfo = class
  public
    DirName: string;
    ExeName: string;
    Params: TStrings;
    OpeningFileName: string;
    constructor Create;
    destructor Destroy; override;
  end;

  TEngine = class(TComponent)
  private
    FEngineExePath: string;
    FExecuted: Boolean;
    slOutput: TStringList;
    DS: TDosCommand;
    StartPosition: string;
    MovesHistory: string;
    LogFileName: string;
    slStartParams: TStrings;
    Lib: TEngineLibrary;

    procedure OnNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
    procedure OnTerminated(Sender: TObject);
    procedure SendCommand(p_Command: string);
    procedure AddMoveToHistory(p_Move: TEngineMove);
    procedure Log(p_Line: string);
  public
    OnNewEngineMove: TNotifyEngineMove;
    OnEngineTerminate: TNotifyEngineTerminate;
    ExternalLines: TStrings;
    Connection: TObject;
    Game: TObject;
    TimeToThink: integer;
    UseOpenings: Boolean;

    constructor Create(p_EngineExePath, p_LogFileName, p_OpeningFileName: string); overload;
    destructor Destroy; override;

    procedure Execute;
    procedure Terminate;
    procedure StartLog(p_FileName: string);
    procedure SetStartParams(p_Params: TStrings);

    procedure StartNewGame(p_StartPosition: string = 'startpos');
    procedure Move(p_Move: TEngineMove);
    procedure MakeFirstMove;
    procedure SetName(p_Name: string);
  end;

implementation

uses CSConnection, CSGame, CSConst, CSLib;

//==============================================================================
{ TCSEngine }

procedure TEngine.AddMoveToHistory(p_Move: TEngineMove);
begin
  if MovesHistory <> '' then
    MovesHistory := MovesHistory + ' ';
  MovesHistory := MovesHistory + p_Move;
end;
//==============================================================================
constructor TEngine.Create(p_EngineExePath, p_LogFileName, p_OpeningFileName: string);
begin
  inherited Create(nil);
  StartLog(p_LogFileName);
  FEngineExePath := p_EngineExePath;
  Log('engine file = ' + p_EngineExePath);
  slOutput := TStringList.Create;
  DS := TDosCommand.Create(Self);
  DS.CommandLine := p_EngineExePath;
  DS.OutputLines := slOutput;
  DS.OnNewLine := Self.OnNewLine;
  DS.OnTerminated := Self.OnTerminated;

  slStartParams := TStringList.Create;
  lib := TEngineLibrary.Create(MAIN_DIR + 'engines\!books\' + p_OpeningFileName);

  TimeToThink := 1000;
end;
//==============================================================================
destructor TEngine.Destroy;
begin
  slOutput.Free;
  DS.Free;
  slStartParams.Free;
  Lib.Free;
  inherited;
end;
//==============================================================================
procedure TEngine.Execute;
var
  i: integer;
begin
  if not FExecuted then begin
    DS.Execute;
    Log('executed...');
    FExecuted := true;
    SendCommand('uci');
    for i := 0 to slStartParams.Count - 1 do
      SendCommand(slStartParams[i]);
  end;
end;
//==============================================================================
procedure TEngine.Log(p_Line: string);
var
  F: TextFile;
  sTime: string;
begin
  if LogFileName = '' then exit;
  
  sTime := FormatDateTime('yyyy-mm-dd hh:nn:ss:zzz', Date+Time);
  AssignFile(F, LogFileName);
  Append(F);
  writeln(F, '[' + sTime + ']: ' + p_Line);
  CloseFile(F);
end;
//==============================================================================
procedure TEngine.MakeFirstMove;
var
  NewMove: string;
begin
  if UseOpenings then NewMove := Lib.GetFirstMove
  else NewMove := '';
  
  if NewMove = '' then begin
    SendCommand('position ' + StartPosition);
    SendCommand('go movetime ' + IntToStr(TimeToThink));
  end else begin
    AddMoveToHistory(NewMove);
    OnNewEngineMove(Self, NewMove);
  end;
end;
//==============================================================================
procedure TEngine.Move(p_Move: TEngineMove);
var
  NewMove: string;
begin
  AddMoveToHistory(p_Move);
  if UseOpenings then NewMove := Lib.GetNextMove(MovesHistory)
  else NewMove := '';

  if NewMove = '' then begin
    SendCommand('position ' + StartPosition + ' moves ' + MovesHistory);
    SendCommand('go movetime ' + IntToStr(TimeToThink));
  end else begin
    AddMoveToHistory(NewMove);
    OnNewEngineMove(Self, NewMove);
  end;
end;
//==============================================================================
procedure DevideEngineLine(p_Line: string; pp_SL: TStringList);
var
  n: integer;
  s: string;
begin
  pp_SL.Clear;
  s := p_Line;
  while s <> '' do begin
    n := pos(' ', s);
    if n = 0 then begin
      pp_SL.Add(s);
      s := '';
    end else begin
      pp_SL.Add(copy(s, 1, n-1));
      s := copy(s, n+1, length(s));
    end;
  end;
end;
//==============================================================================
procedure TEngine.OnNewLine(Sender: TObject; NewLine: string; OutputType: TOutputType);
var
  sl: TStringList;
begin
  AssertInMainThread;
  if (NewLine = '') or (OutputType = otBeginningOfLine) then exit;
  Log(NewLine);
  if ExternalLines <> nil then
    ExternalLines.Add(NewLine);
  sl := TStringList.Create;
  try
    DevideEngineLine(NewLine, sl);
    if sl[0] = 'bestmove' then begin
      OnNewEngineMove(Self, sl[1]);
      AddMoveToHistory(sl[1]);
    end;
  finally
    sl.Free;
  end;
end;
//==============================================================================
procedure TEngine.OnTerminated(Sender: TObject);
begin
  if Assigned(OnEngineTerminate) then OnEngineTerminate(Self);
end;
//==============================================================================
procedure TEngine.SendCommand(p_Command: string);
begin
  DS.SendLine(p_Command, true);
  Log('>> ' + p_Command);
  if Assigned(ExternalLines) then begin
    ExternalLines.Add('===================================');
    ExternalLines.Add('    ' + p_Command);
  end;
end;
//==============================================================================
procedure TEngine.SetName(p_Name: string);
begin
  Name := p_Name;
  DS.Name := 'DS_' +  p_Name;
end;
//==============================================================================
procedure TEngine.SetStartParams(p_Params: TStrings);
begin
  slStartParams.AddStrings(p_Params);
end;
//==============================================================================
procedure TEngine.StartLog(p_FileName: string);
var
  F: TextFile;
begin
  if p_FileName = '' then exit;

  LogFileName := p_FileName;
  AssignFile(F, LogFileName);
  try
    Rewrite(F);
    CloseFile(F);
  except
    on E:Exception do begin
      LogFileName := '';
      raise exception.create('TCSEngine.StartLog: cannot rewrite file ' + p_FileName);
    end;
  end;

end;
//==============================================================================
procedure TEngine.StartNewGame(p_StartPosition: string = 'startpos');
begin
  if not FExecuted then
     raise EngineNotExecutedException.Create('TCSEngine.StartNewGame: Engine is not executed');
  SendCommand('ucinewgame');
  MovesHistory := '';
  StartPosition := p_StartPosition;
end;
//==============================================================================
procedure TEngine.Terminate;
begin
  if FExecuted then begin
    SendCommand('quit');
  end;
end;
//==============================================================================
{ TCSEngineInfo }

constructor TEngineInfo.Create;
begin
  Params := TStringList.Create;
end;
//==============================================================================
destructor TEngineInfo.Destroy;
begin
  Params.Free;
  inherited;
end;
//==============================================================================
{ TEngineLibrary }

constructor TEngineLibrary.Create(p_FileName: string);
begin
  slMoves := TStringList.Create;

  if FileExists(p_FileName) then
    slMoves.LoadFromFile(p_FileName);
end;
//==============================================================================
destructor TEngineLibrary.Destroy;
begin
  slMoves.Free;
  inherited;
end;
//==============================================================================
function TEngineLibrary.GetFirstMove: string;
var
  sl: TStrings;
  i, n: integer;
  Move: string;
begin
  if slMoves.Count = 0 then begin
    result := '';
    exit;
  end;
  sl := TStringList.Create;
  for i := 0 to slMoves.Count - 1 do begin
    Move := copy(slMoves[i], 1, 4);
    if Move = '' then continue;
    if sl.IndexOf(Move) = -1 then
      sl.Add(Move);
  end;
  n := Random(sl.Count);
  result := sl[n];
  sl.Free;
end;
//==============================================================================
function TEngineLibrary.GetNextMove(MovesHistory: string): string;
var
  i, n: integer;
  slNums: TStrings;
  line: string;
begin
  slNums := TStringList.Create;
  for i := 0 to slMoves.Count - 1 do
    if pos(MovesHistory + ' ', slMoves[i]) = 1 then
      slNums.Add(IntToStr(i));

  if slNums.Count = 0 then result := ''
  else begin
    n := Random(slNums.Count);
    line := slMoves[StrToInt(slNums[n])];
    line := copy(line, length(MovesHistory) + 2, length(line));
    n := pos(' ', line);
    if n = 0 then result := line
    else result := copy(line, 1, n-1);
  end;
  slNums.Free;
end;
//==============================================================================
end.

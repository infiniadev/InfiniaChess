unit CLSocket2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, StdCtrls;

type
  TCLSocket2 = class
    Client: TIdTCPClient;
  private
    FAccepted: Boolean;
    function GetHost: string;
    function GetPort: integer;
    procedure SetHost(const Value: string);
    procedure SetPort(const Value: integer);
  public
    slCMD: TStringList;
    constructor Create;
    destructor Destroy;

    property Host: string read GetHost write SetHost;
    property Port: integer read GetPort write SetPort;
    property Accepted: Boolean read FAccepted write FAccepted;

    procedure Connect;
    procedure Disconnect;
    function Connected: Boolean;
    procedure Send(CMD: array of variant);

    procedure CMD_Invite(CMD: TStrings);
    procedure CMD_Initialize;
    procedure CMD_Photo;
    procedure MMThreadLog(Str: string);
  end;

  TCLSocket2Thread = class(TThread)
  private
    procedure Parse(slCMD: TStrings);
  protected
    procedure Execute; override;
  end;

var
  fCLSocket2Thread: TCLSocket2Thread;
  fCLSocket2: TCLSocket2;

implementation

uses CLConst, CLSocket, CLLib, CLCLS;

{ TCLSocket2 }
//=====================================================================
procedure TCLSocket2.CMD_Initialize;
begin
  Accepted:=true;
  Send([CMM_GET_ALL_PHOTO]);
end;
//=====================================================================
procedure TCLSocket2.CMD_Photo;
begin
  fCLCLS.CMD_Photo(slCMD);
end;
//=====================================================================
procedure TCLSocket2.Connect;
begin
  fCLSocket2Thread := TCLSocket2Thread.Create(True);
  fCLSocket2Thread.FreeOnTerminate:=True;
  fCLSocket2Thread.Priority:=tpLowest;
  fCLSocket2Thread.Resume;
end;
//=====================================================================
constructor TCLSocket2.Create;
begin
  Client:=TIdTcpClient.Create(nil);
  slCMD:=TStringList.Create;
end;
//=====================================================================
destructor TCLSocket2.Destroy;
begin
  Client.Destroy;
  slCMD.Free;
end;
//=====================================================================
procedure TCLSocket2.Disconnect;
begin
  if Client.Connected then Client.Disconnect;
end;

{ TCLSocket2Thread }
//=====================================================================
procedure TCLSocket2Thread.Execute;
var
  cmd: string;
begin
  //showmessage('Priority = '+IntToStr(ord(Priority)));
  if fCLSocket2.Client.Connected then fCLSOcket2.Client.Disconnect;
  try
    fCLSOcket2.Client.Connect(1000);
  except
    Terminate;
  end;
  fCLSOcket2.Send([CMM_INITIALIZE, fCLSocket.Account.Login]);
  while not Terminated do begin
    if not fCLSocket2.Client.Connected then Terminate
    else
      try
        cmd:=fCLSOcket2.Client.Readln; //(#0, -2, 64*1024);//WaitFor(DP_END);
        fCLSocket2.MMThreadLog('-> '+cmd);
        if cmd[length(cmd)]=DP_END then
          SetLength(cmd,length(cmd)-1);
        Str2StringList(cmd,fCLSocket2.slCMD,DP_DELIMITER);
        Parse(fCLSocket2.slCMD);
      except
      end;
  end;
end;
//=====================================================================
procedure TCLSocket2Thread.Parse(slCMD: TStrings);
var
  nCMD: integer;
begin
  try
    nCMD:=StrToInt(slCMD[0]);
  except
  end;

  case nCMD of
    DPM_INITIALIZED: fCLSocket2.CMD_Initialize;
    DPM_PHOTO: {Synchronize(}fCLSocket2.CMD_Photo;
  end;
end;
//=====================================================================
function TCLSocket2.GetHost: string;
begin
  result:=Client.Host;
end;
//=====================================================================
function TCLSocket2.GetPort: integer;
begin
  result:=Client.Port;
end;
//=====================================================================
procedure TCLSocket2.Send(CMD: array of variant);
var
  i: integer;
  s,res: string;
begin
  if not Client.Connected then exit;
  res:='';
  for i:=0 to High(CMD) do begin
    s:=Var2String(CMD[i]);
    if i<>0 then res:=res+' ';
    res:=res+s;
  end;
  Client.WriteLn(res);
end;
//=====================================================================
procedure TCLSocket2.SetHost(const Value: string);
begin
  Client.Host := Value;
end;
//=====================================================================
procedure TCLSocket2.SetPort(const Value: integer);
begin
  Client.Port := Value;
end;
//=====================================================================
procedure TCLSocket2.MMThreadLog(Str: string);
var
  F: TextFile;
  filename: string;
begin
  if DebugHook = 0 then exit;
  filename:=MAIN_DIR+'log\mm_'+fCLSocket.MyName+'.log';
  AssignFile(F,filename);
  if FileExists(filename) then Append(F)
  else rewrite(F);

  writeln(F,Str);
  CloseFile(F);
end;
//==========================================================================
procedure TCLSocket2.CMD_Invite(CMD: TStrings);
var
  nPort: integer;
begin
  if CMD.Count<2 then exit;
  try
    nPort:=StrToInt(CMD[1]);
  except
    nPort:=PORT_MM_DEFAULT;
  end;
  Client.Host := fCLSocket.Account.Server;
  Client.Port := nPort;
  Connect;
end;
//==========================================================================
function TCLSocket2.Connected: Boolean;
begin
  result:=Client.Connected;
end;
//==========================================================================
end.

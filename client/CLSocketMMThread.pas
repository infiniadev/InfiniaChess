unit CLSocketMMThread;

interface

uses
  Classes, winsock, scktcomp, CLSocketMM, SysUtils;

const
  COMMAND_SIZE = 1024;

type
  TCLSocketMMThread = class(TThread)
  private
    buf: string;
    slSendCommands: TStringList;
    Stream: TWinSocketStream;
    procedure ReceiveMM(var cmd: string);
    procedure ParseMM(cmd: string);
  protected
    procedure Execute; override;
  public
    SocketMM: TCLSocketMM;
    Socket: TCustomWinSocket;
    procedure AddSendCommand(cmd: string);
    procedure ProcessSendCommand(cmd: string);
    procedure Initialize;
    procedure Init;
    procedure MMThreadLog(Str: string);
  end;

var
  fCLSocketMMThread: TCLSocketMMThread;

implementation

uses CLConst, CLLib, CLCLS;

{ TCLSocketMMThread }
//================================================================
procedure TCLSocketMMThread.AddSendCommand(cmd: string);
begin
  slSendCommands.Add(cmd);
end;
//================================================================
procedure TCLSocketMMThread.Execute;
var
  vBuf: PChar;//string;
  i,len: integer;
  c: char;
begin
  buf:='';
  vBuf:=AllocMem(COMMAND_SIZE);
  //SetLength(vBuf,COMMAND_SIZE);
  Stream:=TWinSocketStream.Create(Socket,100);
  while not Terminated and Socket.Connected do begin
    repeat
      len:=Stream.Read(vBuf[1], COMMAND_SIZE);
      if len>0 then begin
        for i:=1 to len do begin
          //c:=Char(vBuf+i-1);
          buf:=buf+copy(vBuf,1,len);
        end;
        MMThreadLog('-> '+copy(vBuf,1,len));
      end;
    until (len<=0);
    if pos(DP_END,buf)>0 then
      ReceiveMM(buf);

    while slSendCommands.Count>0 do begin
      ProcessSendCommand(slSendCommands[0]);
      slSendCommands.Delete(0);
    end;
  end;
  FreeMem(vBuf,COMMAND_SIZE);
end;
//================================================================
procedure TCLSocketMMThread.Init;
begin
  slSendCommands:=TStringList.Create;
end;
//================================================================
procedure TCLSocketMMThread.Initialize;
begin
  SocketMM.Accepted:=true;
  AddSendCommand(CMM_GET_ALL_PHOTO+#10);
  MMThreadLog('================================');
  MMThreadLog('Socket initialized');
end;
//================================================================
procedure TCLSocketMMThread.ParseMM(cmd: string);
var
  slCMD: TStringList;
  nCMD: integer;
begin
  slCMD:=TStringList.Create;
  try
    Str2StringList(cmd,slCMD,DP_DELIMITER);
    try
      nCMD:=StrToInt(slCMD[0]);
    except
    end;
    case nCMD of
      DPM_INITIALIZED: Initialize;
      DPM_PHOTO: fCLCLS.CMD_Photo(slCMD);
    end;
  finally
    slCMD.Free;
  end;
end;
//================================================================
procedure TCLSocketMMThread.ProcessSendCommand(cmd: string);
var
  s,s1: string;
begin
  s:=cmd;
  if s[length(s)]<>#10 then s:=s+#10;
  Socket.SendBuf(s[1],length(s));
end;
//================================================================
procedure TCLSocketMMThread.ReceiveMM(var cmd: string);
var
  len: integer;
begin
  while pos(DP_END,cmd)>0 do begin
    ParseMM(copy(cmd,1,pos(DP_END,cmd)-1));
    cmd:=copy(cmd,pos(DP_END,cmd)+1,length(cmd));
  end;
end;
//================================================================
procedure TCLSocketMMThread.MMThreadLog(Str: string);
var
  F: TextFile;
  filename: string;
begin
  filename:=MAIN_DIR+'\log\mm.log';
  AssignFile(F,filename);
  if FileExists(filename) then Append(F)
  else rewrite(F);

  writeln(F,Str);
  CloseFile(F);
end;
//==========================================================================
end.

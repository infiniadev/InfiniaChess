unit CSMail;

interface

uses IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdMessageClient, IdSMTP, SysUtils, Dialogs, CSConnection, Classes;

type
  TConnectMailThread = class(TThread)
  public
    Connection: TConnection;
    ErrMsg: string;
    Success: Boolean;
    procedure Terminate(Sender: TObject);
    procedure Execute; override;
  end;

function SendMail(Address,Subject,Body: string; var ErrMsg: string): Boolean;
procedure UserSendMail(Connection: TConnection; CMD: TStrings);
procedure CreateMailObjects;
procedure DestroyMailObjects;
function ConnectMail(var ErrMsg: string): Boolean;
procedure UserReconnectMail(Connection: TConnection);
function SendPatternMail(Address,Name: string; args: array of string; var ErrMsg: string): Boolean;

var
  SMTP: TIdSMTP;
  IdMsg: TIdMessage;
  Reconnecting: Boolean = false;

implementation

uses CSConst, CSSocket, CSLib;
//===============================================================================
procedure SendEmail(Address,Subject,Body: string);
begin

end;
//===============================================================================
procedure CreateMailObjects;
begin
  SMTP:=TIdSMTP.Create(nil);
  IdMsg:=TIdMessage.Create(nil);
end;
//===============================================================================
procedure DestroyMailObjects;
begin
  SMTP.Destroy;
  IdMSG.Destroy;
end;
//===============================================================================
function ConnectMail(var ErrMsg: string): Boolean;
begin
  exit;
  try
    if SMTP.Connected then SMTP.Disconnect;
  except
  end;
  SMTP.Host:=MAIL_HOST;
  SMTP.Username:=MAIL_USER;
  SMTP.Password:=MAIL_PASSWORD;
  SMTP.Port:=MAIL_PORT;
  try
    SMTP.Connect;
    ErrMsg:='';
    result:=true;
  except
    on E:Exception do begin
      ErrMsg:=E.Message;
      result:=false;
      ErrLog('ConnectMail: '+ErrMsg,nil);
    end;
  end;
end;
//===============================================================================
procedure UserReconnectMail(Connection: TConnection);
var
  th: TConnectMailThread;
begin
  if not Assigned(SMTP) then CreateMailObjects;
  if SMTP.Connected then SMTP.Disconnect;
  th:=TConnectMailThread.Create(false);
  th.Connection:=Connection;
  th.OnTerminate:=th.Terminate;
  th.FreeOnTerminate:=true;
  th.Execute;
end;
//===============================================================================
function SendMail(Address,Subject,Body: string; var ErrMsg: string): Boolean;
begin
  try
    IdMsg.From.Name := MAIL_FROM_NAME;
    IdMsg.From.Address := MAIL_FROM_ADDRESS;
    IdMsg.Recipients.EMailAddresses := Address;
    IdMsg.Subject := Subject;
    IdMsg.MessageParts.Clear;
    IdMsg.Body.Text:=Body;

    if not SMTP.Connected or SMTP.ClosedGracefully then begin
      result:=ConnectMail(ErrMsg);
      if not result then exit;
    end;
    SMTP.Send(IdMsg);
    IdMsg.MessageParts.Clear;
    ErrMsg:='';
    result:=true;
  except
    on E:Exception do begin
      ErrMsg:=E.Message;
      result:=false;
      ErrLog('SendMail: '+ErrMsg,nil);
    end;
  end;
end;
//===============================================================================
procedure UserSendMail(Connection: TConnection; CMD: TStrings);
var
  ErrMsg: string;
  Address,Subject,Body: string;
begin
  if CMD.Count>1 then Address:=CMD[1]
  else Address:='registration@infiniachess.com';

  Subject:='Test message';
  Body:='Test message';
  if SendMail(Address,Subject,Body,ErrMsg) then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Mail sent successfully'])
  else begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Error occured during mail sending']);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,ErrMsg]);
  end;
end;
//===============================================================================
{ TConnectMailThread }
//===============================================================================
procedure TConnectMailThread.Execute;
begin
  Success:=ConnectMail(ErrMsg);
end;
//===============================================================================
procedure TConnectMailThread.Terminate(Sender: TObject);
begin
  if Connection = nil then exit;
  if Success then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Mail client reconnected successfully']);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('Host: %s; User/password: %s/%s ',[SMTP.Host,SMTP.Username,SMTP.Password])]);
  end else begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Error occured during reconnecting']);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,ErrMsg]);
  end;
end;
//===============================================================================
function SendPatternMail(Address,Name: string; args: array of string; var ErrMsg: string): Boolean;
var
  sl: TStringList;
  filename,subj,body: string;
  i: integer;
begin
  sl:=TStringList.Create;
  try
    filename:=MAIN_DIR+MAIL_PATTERN_DIR+'\'+Name+'.txt';
    if not FileExists(filename) then exit;
    sl.LoadFromFile(filename);
    if sl.Count = 0 then exit;
    subj:=sl[0];
    sl.Delete(0);
    body:=sl.Text;
    for i:=Low(args) to High(args) div 2 do
      body:=ReplaceAllSubstr(body,args[i*2],args[i*2+1]);
    result:=SendMail(Address,subj,body,ErrMsg);
  finally
    sl.Free;
  end;
end;
//===============================================================================
end.

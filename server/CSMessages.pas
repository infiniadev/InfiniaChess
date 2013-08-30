{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSMessages;

interface

uses
  Classes, SysUtils, CSConnection;

type
  TMessages = class(TObject)
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    procedure CMD_DeleteMessage(var Connection: TConnection;
      var CMD: TStrings);
    procedure CMD_Message(var Connection: TConnection; var CMD: TStrings);
    procedure SendMessages(var Connection: TConnection);
    procedure SendWelcome(var Connection: TConnection);
    procedure CMD_MessageGroup(var Connection: TConnection; CMD: TStrings);
  end;

var
  fMessages: TMessages;

implementation

uses
  ADOInt, CSConst, CSConnections, CSDb, CSSocket;
{ TMessages }
//______________________________________________________________________________
constructor TMessages.Create;
begin

end;
//______________________________________________________________________________
destructor TMessages.Destroy;
begin
  inherited;
end;
//______________________________________________________________________________
procedure TMessages.CMD_DeleteMessage(var Connection: TConnection;
  var CMD: TStrings);
const
  MESSAGEID = 1;
var
  Index: Integer;
  s: string;
  Permanently: Boolean;
begin
  { Verify registered login }
  if Connection.LoginID < 0 then
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_REGISTERED_ONLY]);
      Exit;
    end;

  { Parameter check:
      CMD[0] = /Command
      CMD[1] = MessageID }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;

  if CMD.Count >=2 then Permanently := CMD[2] = '1'
  else Permanently := false;
  { Check paramater values }
  try
    StrToInt(CMD[MESSAGEID]);
  except
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE]);
      Exit;
    end;
  end;
  { Database call }
  Index := fDB.MessageDelete(Connection.LoginID, StrToInt(CMD[MESSAGEID]),Permanently);
  { If successful then send a DP_MESSAGE_DELETE with the MessageID }
  if Index = 1 then
    fSocket.Send(Connection, [DP_MESSAGE_DELETE, CMD[MESSAGEID]])
  else
    { Send a error message }
    begin
      s := Format(DP_MSG_MESSAGEID_INVALID, [CMD[MESSAGEID]]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
    end;
end;
//______________________________________________________________________________
procedure TMessages.CMD_Message(var Connection: TConnection;
  var CMD: TStrings);
const
  LOGIN = 1;
  MSG = 2;
var
  _Connection: TConnection;
  Index: Integer;
  s, b: string;
begin
  { Verify registered lgoin }
  if not Connection.Registered then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_REGISTERED_ONLY]);
      Exit;
    end;

  { Verify login not muted }
  if Connection.Muted = True then
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MUTE]);
      Exit;
    end;

  { Parameter check:
      CMD[0] = /Command
      CMD[1] = Receiver Handle
      CMD[2] = Subject||Message }
  if CMD.Count < 3 then
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  if (Length(CMD[LOGIN]) > MAX_LOGIN_LENGTH) then
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_LOGIN_EXCEEDS_MAX]);
      Exit;
    end;

  if Connection.MembershipType = mmbNone then begin
    Connection.SendNoMembershipMsg(DP_MSG_NO_MESSAGES);
    exit;
  end;

  { Split subject / body }
  b := CMD[MSG];
  Index := Pos('||', b);
  if Index > 0 then
    begin
      s := Copy(b, 1, Index - 1);
      Delete(b, 1, Index + 1);
    end
  else
    begin
      Index := Pos(#32, b);
      if Index > 0 then s := Copy(b, 1, Index);
    end;
  { Check the lengths of the subject and body. Adjust the max if necessary.
    50 and 500 are the max sizes in the CLServer..LoginMessages table. }
  s := Trim(s);
  if Length(s) > 50 then SetLength(s, 50);
  b := Trim(b);
  if Length(b) > 500 then SetLength(b, 500);

  { Call fDB MessageAdd }
  Index := fDB.MessageAdd(Connection.LoginID, CMD[LOGIN], s, b);
  { Inform Connection of success / failure }
  case Index of
    DB_ERROR:
      begin
        { The fDB was unable to process the request. }
        { ??? need to send user a response. }
        Exit;
      end;
    -4:
      begin
        s := Format(DP_MSG_CENSORED, [CMD[LOGIN]]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
        Exit;
      end;
    -3:
      begin
        s := Format(DP_MSG_CENSORING, [CMD[LOGIN]]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
        Exit;
      end;
    -2:
      begin
        s := Format(DP_MSG_LOGINID_INVALID, [CMD[LOGIN]]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
        Exit;
      end;
  end;

  { Send notification to receiver DP_MESSAGE }
  _Connection := fConnections.GetConnection(CMD[LOGIN]);

  { Dont send messages to version zero clients (it will break the client) }
  if Assigned(_Connection) and (_Connection.Version <> '') then
    fSocket.Send(_Connection, [DP_MESSAGE, IntToStr(Index), Connection.Handle,
      Connection.Title, FormatDateTime('yyyy.mm.dd', Now), s, b]);

  { Send notification to sender DP_MESSAGE }
  s := Format(DP_MSG_MESSAGE_SENT, [CMD[LOGIN]]);
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
end;
//______________________________________________________________________________
procedure TMessages.SendMessages(var Connection: TConnection);
var
  Rst: _RecordSet;
begin
  { Get a list of message headers to send to the Connection as part of the
    login process. }
  fDB.Messages(Connection.LoginID, Rst);
  if not Assigned(Rst) then Exit;
  { Verify the Rst and send the results. }
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do
      begin
        fSocket.Send(Connection, [DP_MESSAGE,
          Rst.Fields[1].Value, Rst.Fields[3].Value, Rst.Fields[4].Value,
          Rst.Fields[5].Value, Rst.Fields[6].Value, Rst.Fields[7].Value]);
        Rst.MoveNext;
      end;
  Rst := nil;
end;
//______________________________________________________________________________
procedure TMessages.SendWelcome(var Connection: TConnection);
var
  Rst: _RecordSet;
begin
  fDB.Welcome(Connection.Version, Rst);
  if not Assigned(Rst) then Exit;
  { Verify the Rst and send the results. }
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do
      begin
        fSocket.Send(Connection, [DP_SERVER_MSG,
          Rst.Fields[0].Value, Rst.Fields[1].Value]);
        Rst.MoveNext;
      end;
  Rst := nil;
end;
//______________________________________________________________________________
procedure TMessages.CMD_MessageGroup(var Connection: TConnection; CMD: TStrings);
var
  subj, msg, param: string;
  i, res, n, group: integer;
begin
  if CMD.Count < 4 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  if Connection.MembershipType = mmbNone then begin
    Connection.SendNoMembershipMsg(DP_MSG_NO_MESSAGES);
    exit;
  end;

  group := StrToInt(CMD[1]);
  param := CMD[2];

  if group > -1 then begin // old client
    case group of
      0: param := '2,3';
      1: param := '1,2,3';
      2: param := '7';
    end;
    group := -1;
  end;

  msg := ''; subj := '';
  for i := 3 to CMD.Count - 1 do
    msg := msg + CMD[i] + ' ';

  n := pos('||', msg);
  if n > 0 then begin
    subj := copy(msg, 1, n-1);
    msg := copy(msg, n+2, length(msg));
  end;
  res := fDB.ExecProc('dbo.proc_MessageGroupAdd', [Connection.LoginID, group, param, subj, msg]);
  if res = 0 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, 'Your message was sent to nobody'])
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Your message was sent to ' + IntToStr(res) + ' users']);
end;
//______________________________________________________________________________
end.

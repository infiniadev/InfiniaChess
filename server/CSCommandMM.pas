unit CSCommandMM;

interface

uses scktcomp, classes, SysUtils;

procedure IdentifySocketMM(Socket: TCustomWinSocket; CMD: TStrings);
function GetMMCommandNum(cmd: string): integer;

implementation

uses CSConnections, CSConnection;
//=========================================================================
procedure IdentifySocketMM(Socket: TCustomWinSocket; CMD: TStrings);
var
  login: string;
  conn: TConnection;
begin
  if CMD.Count<2 then exit;
  login:=CMD[1];
  conn:=fConnections.GetConnection(login);
  {if conn<>nil then
    conn.SocketMM := Socket;}
end;
//=========================================================================
function GetMMCommandNum(cmd: string): integer;
begin
  result:=-1;
  if length(cmd)<>6 then exit;
  if copy(cmd,1,3)<>'cmm' then exit;
  try
    result:=StrToInt(copy(cmd,4,3));
  except
  end;
end;
//=========================================================================
end.

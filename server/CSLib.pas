unit CSLib;

interface

uses SysUtils,CSConnection,CSConnections,ADOInt,Classes,
     contnrs,CSConst,CSGame,CSReglament,FileCtrl, Variants, Windows;

procedure ErrLog(p_Text: string; Connection: TConnection; p_Where: string = ''); overload;
procedure ErrLog(p_Text: string); overload;
function rtrim(s: string): string;
function lpad(Str: string; Num: integer; Symbol: char = ' '): string;
function rpad(Str: string; Num: integer; Symbol: char = ' '): string;
function CompareVersion(Ver1,Ver2: string): integer;
function FormatRst(Rst: _RecordSet; Pattern: string; Indexes: array of integer): string;
function TestParams(
  CMD: TStrings;
  Types: array of integer;
  NOptional: integer;
  var Err: string): Boolean;
function Replace(Str: string; cFrom,cTo: char): string;
function ReplaceSubstr(Str,sFrom,sTo: string): string;
function ReplaceAllSubstr(Str,sFrom,sTo: string): string;
function Str2Float(Str: string): real;
function Dice(Cnt,FullCnt: integer): Boolean;
procedure SocketLog(p_Who, p_Text: string; p_In: Boolean);
function OddsToFEN(odds: string; White: Boolean): string;
//function ConnectionToList(Connection: TConnection): TObjectList;
procedure MarkSendOnlyOne(conns: TObjectList; Connection: TConnection);
function GetDPName(Num: string): string;
function TimeToRatedType(const Int: string; Inc: Integer): TRatedType;
function GameResult2ReglGameResult(RatedType: TRatedType; GameResult: TGameResult): TCSReglGameResult;
function GetNameWithTitle(const name,title: string): string;
function BoolTo_(b: Boolean; p_True,p_False: Variant): Variant;
function TimeToMSec(p_Time: string): integer;
function FilterByVersion(conns: TObjectList; Version: string): TObjectList;
function GenerateAuthKey: string;
function nvl(v1, v2: Variant): Variant;
function EncryptANSI(p_Str: ANSIstring): ANSIstring;
function DecryptANSI(p_Str: ANSIstring): ANSIstring;
procedure SaveStrToFile(FileName,Str: string);
function ReadStrFromFile(FileName: string): string;
procedure Str2StringList(s:string;sl:TStrings;Sep:char=',');
procedure PressStringList(SL: TStrings; NewCount: integer; Sep: string = #32);
function DevideBy3(sNum: string; Devider: string = '.'): string; overload;
function DevideBy3(Num: integer; Devider: string = '.'): string; overload;
function FormatByLength(Values: array of variant; Len: array of integer): string;
function AssembleSendCommand(slCMD: array of variant): string;
function ControlSumm(Str: string): LongWord;
function Var2String(V: Variant): string;
procedure Init;
procedure ShoutMultiLine(Txt: string; Initiator: TObject);
function CountChars(Str: string; c: char): integer;
function RatedType2Str(RatedType: TRatedType): string;
function IsMasterOnlyTitle(title: string): Boolean;
function IsGMOnlyTitle(title: string): Boolean;
function InCommaString(CommaString, part: string): Boolean; overload;
function InCommaString(CommaString: string; part: integer): Boolean; overload;
procedure GetDateDiff(Date1, Date2: TDateTime; var pp_Days, pp_Hours, pp_Minutes: integer);
function GetDateDiffStrRound(Date1, Date2: TDateTime): string;
function MinValue(v1, v2: Variant): Variant;
function MaxValue(v1, v2: Variant): Variant;
function IsStandardRules(p_RatedType: TRatedType): Boolean;
function GetDateDiffMSec(p_Date1, p_Date2: TDateTime): integer;
procedure TestInMainThread;
function Decode(Params: array of Variant): Variant;
function BoolTo01(b: Boolean): integer;
function NullIf(p_Param, p_Value: Variant): Variant;
procedure AppendToFile(p_FileName, p_Line: string);
function NowLogFormat: string;
procedure AssertInMainThread(p_CalledFrom: string = '');
function GetExceptionStack: string;

implementation

uses CSService, CSSocket, JclDebug;

var
  alphabet: string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';

//=====================================================================
procedure ErrLog(p_Text: string; Connection: TConnection; p_Where: string = ''); overload;
var
  F: TextFile;
  name: string;
begin
  csErrLog.Enter;
  try
    AssignFile(F,MAIN_DIR+ERR_LOG);
    try
      try Append(F) except Rewrite(F) end;
    except
      exit;
    end;
    if Connection=nil then name:='nil'
    else name:=Connection.Handle;
    writeln(F,DateTimeToStr(Date+Time)+' '+name+' '+p_Where+': '+p_Text);
    Closefile(F);
  finally
    csErrLog.Leave;
  end;
end;
//=====================================================================
procedure ErrLog(p_Text: string); overload;
var
  F: TextFile;
begin
  csErrLog.Enter;
  try
    AssignFile(F,MAIN_DIR+ERR_LOG);
    try
      try Append(F) except Rewrite(F) end;
    except
      exit;
    end;
    writeln(F, p_Text);
    Closefile(F);
  finally
    csErrLog.Leave;
  end;
end;
//=====================================================================
procedure SocketLog(p_Who, p_Text: string; p_In: Boolean);
var
  F: TextFile;
  s: string;
begin
  AssignFile(F,MAIN_DIR+SOCKET_LOG);
  if FileExists(MAIN_DIR+SOCKET_LOG) then Append(F)
  else Rewrite(F);
  if p_In then s:='>>>>>> '
  else s:='<<<<<< ';

  writeln(F,s+p_Who);
  writeln(F,'  '+p_Text);
  CloseFile(F);
end;
//=====================================================================
function rtrim(s: string): string;
var n: integer;
begin
  n:=length(s);
  while (n>0) and (s[n]=#32) do
    dec(n);
  result:=copy(s,1,n);
end;
//=====================================================================
function CompareVersion(Ver1,Ver2: string): integer;
// -1: Ver1<Ver2; 0: Ver1=Ver2; 1: Ver1>Ver2
begin
  if pos('.',Ver1)=0 then Ver1:=Ver1+'.0';
  if pos('.',Ver2)=0 then Ver2:=Ver2+'.0';
  Ver1:=rpad(Ver1,5,chr(96));
  Ver2:=rpad(Ver2,5,chr(96));

  if Ver1=Ver2 then result:=0
  else if Ver1<Ver2 then result:=-1
  else result:=1;
end;
//=====================================================================
function FormatRst(Rst: _RecordSet; Pattern: string; Indexes: array of integer): string;
// %d - integer, %s - string, %t - date with time, %y - date without time
var
  i,len,n: integer;
  s: string;
begin
  len:=length(Pattern);
  i:=1;
  result:='';
  while i<=len do begin
    if (Pattern[i]<>'%') or (i=len) or (Pattern[i]='%') and not (Pattern[i+1] in ['s','d','t','y'])
    then begin
      result:=result+Pattern[i];
      inc(i);
    end else begin
      case Pattern[i+1] of
        's': s:=nvl(Rst.Fields[Indexes[n]].Value,'');
        'd': s:=VarToStr(Rst.Fields[Indexes[n]].Value);
        't': s:=FormatDateTime('mm/dd/yyyy hh:mi:ss AM/PM',Rst.Fields[Indexes[n]].Value);
        'y': s:=FormatDateTime('mm/dd/yyyy',Rst.Fields[Indexes[n]].Value);
      end;
      result:=result+s;
      inc(n);
      i:=i+2;
    end;
  end;
end;
//=====================================================================
function TestParams(
  CMD: TStrings;
  Types: array of integer; // 0 - string, 1 - integer
  NOptional: integer;
  var Err: string): Boolean;
var
  i,NTypes: integer;
begin
  result:=false;
  NTypes:=High(Types)-Low(Types)+1;
  if (CMD.Count-1+NOptional<NTypes) or (CMD.Count-1>NTypes) then
    begin
      err:='Illegal number of parameters';
      exit;
    end;

  for i:=1 to CMD.Count-1 do
    if Types[i-1]=1 then
      try
        StrToInt(CMD[i]);
      except
        err:=Format('Parameter %d must be integer',[i]);
        exit;
      end;
  result:=true;
end;
//=====================================================================
function Replace(Str: string; cFrom,cTo: char): string;
var i: integer;
begin
  result:=Str;
  for i:=1 to length(Str) do
    if result[i]=cFrom then
      result[i]:=cTo;
end;
//=====================================================================
function Str2Float(Str: string): real;
var
  n: integer;
  c: char;
begin
  if DECIMALSEPARATOR = '.' then c:=','
  else c:='.';
  n:=pos(c,Str);
  if n>0 then Str[n]:=DECIMALSEPARATOR;
  result:=StrToFloat(Str);
end;
//=====================================================================
function Dice(Cnt,FullCnt: integer): Boolean;
var
  n: integer;
begin
  if Cnt>=FullCnt then result:=true
  else result:=Random(FullCnt)<Cnt;
end;
//=====================================================================
function OddsToFEN(odds: string; White: Boolean): string;
var
  i,pieces,pawns,start,n: integer;
begin
  result:=START_POSITION;
  if not White then begin
    pieces:=pos('r',START_POSITION);
    pawns:=pos('p',START_POSITION);
  end else begin
    pieces:=pos('R',START_POSITION);
    pawns:=pos('P',START_POSITION);
  end;

  for i:=1 to length(odds) div 2 do begin
    if odds[i*2-1]='P' then start:=pawns
    else start:=pieces;

    n:=start+ord(odds[i*2])-ord('a');
    result[n]:='1';
  end;
end;
//=====================================================================
{function ConnectionToList(Connection: TConnection): TObjectList;
begin
  result:=TObjectList.Create;
  result.OwnsObjects:=false;
  result.Add(Connection);
end;}
//=====================================================================
function lpad(Str: string; Num: integer; Symbol: char = ' '): string;
var
  s: string;
  i: integer;
begin
  s:='';
  for i:=length(Str)+1 to Num do
    s:=s+Symbol;
  result:=s+Str;
end;
//=====================================================================
function rpad(Str: string; Num: integer; Symbol: char = ' '): string;
var
  s: string;
  i: integer;
begin
  s:='';
  for i:=length(Str)+1 to Num do
    s:=s+symbol;
  result:=Str+s;
end;
//=====================================================================
function GetDPName(Num: string): string;
begin
  //result:=SL_DP_CODES.Values[Num];
end;
//=====================================================================
function ReplaceSubstr(Str,sFrom,sTo: string): string;
var
  n: integer;
begin
  n:=pos(sFrom,Str);
  if n=0 then result:=Str
  else result:=copy(Str,1,n-1)+sTo+copy(Str,n+length(sFrom),length(Str));
end;
//=====================================================================
function TimeToRatedType(const Int: string; Inc: Integer): TRatedType;
var
  Value: Integer;
begin
  Result := rtStandard;

  Value := (Inc div 3) * 2 + TimeToMSec(Int) div 60000;

  if (Value < 3) and (Value > -1) then
    Result := rtBullet
  else if (Value >= 3) and (Value < 15) then
    Result := rtBlitz;
end;
//=====================================================================
function GameResult2ReglGameResult(RatedType: TRatedType; GameResult: TGameResult): TCSReglGameResult;
begin
  case GameResult of
    grNone: result:=rgrNone;
    grDraw,grWhiteStaleMated, grBlackStaleMated,grAborted,grAdjourned: result:=rgrDraw;
    grWhiteResigns,grWhiteCheckMated,
      grWhiteForfeitsOnTime,grWhiteForfeitsOnNetwork: result:=rgrBlackWin;
    grBlackResigns,grBlackCheckMated,
      grBlackForfeitsOnTime,grBlackForfeitsOnNetwork: result:=rgrWhiteWin;
  end;

  if RatedType = rtLoser then
    case result of
      rgrBlackWin: result:=rgrWhiteWin;
      rgrWhiteWin: result:=rgrBlackWin;
    end;
end;
//=====================================================================
function GetNameWithTitle(const name,title: string): string;
begin
  if trim(title)='' then result:=name
  else result:=name+' ('+title+')';
end;
//=====================================================================
function BoolTo_(b: Boolean; p_True,p_False: Variant): Variant;
begin
  if b then result:=p_True
  else result:=p_False;
end;
//==========================================================================
function TimeToMSec(p_Time: string): integer;
var
  n: integer;
begin
  n:=pos('.',p_Time);
  if n=0 then result:=1000*60*StrToInt(p_Time)
  else begin
    p_Time:=copy(p_Time,n+1,length(p_Time));
    result:=1000*StrToInt(p_Time);
  end;
end;
//==========================================================================
function MSecToTime(p_MSec: integer): string;
var
  n: integer;
begin
  n:=p_MSec div 1000;
  if n mod 60 = 0 then result:=IntToStr(n div 60)
  else result:='0.'+IntToStr(n);
end;
//==========================================================================
function FilterByVersion(conns: TObjectList; Version: string): TObjectList;
var
  i: integer;
  conn: TConnection;
begin
  result:=TObjectList.Create;
  result.OwnsObjects:=false;
  for i:=0 to conns.Count-1 do begin
    conn:=TConnection(conns[i]);
    if conn=nil then continue;
    if CompareVersion(conn.Version,Version)>-1 then
      result.Add(conn);
  end;
end;
//==========================================================================
function GenerateAuthKey: string;
var
  i: integer;
begin
  result:='';
  for i:=1 to 20 do
    result:=result+alphabet[Random(length(alphabet))+1];
end;
//==========================================================================
function nvl(v1, v2: Variant): Variant;
begin
  if v1 = null then result:=v2
  else result:=v1;
end;
//==========================================================================
function ReplaceAllSubstr(Str,sFrom,sTo: string): string;
var
  n: integer;
begin
  result:='';
  while Str<>'' do begin
    n:=pos(sFrom,Str);
    if n=0 then begin
      result:=result+Str;
      Str:='';
    end else begin
      result:=result+copy(Str,1,n-1)+sTo;
      Str:=copy(Str,n+length(sFrom),length(Str));
    end;
  end;
end;
//==========================================================================
//=====================================================================
var ALFA1: string = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_!';

function EncryptANSI(p_Str: ANSIstring): ANSIstring;
var
  i,n: integer;
begin
  result:='@!001!'+IntToStr(length(p_Str) mod 3);

  if length(p_Str) mod 3=1 then p_Str:=p_Str+#0#0
  else if length(p_Str) mod 3=2 then p_Str:=p_Str+#0;


  for i:=0 to length(p_Str) div 3 -1 do begin
    n:=ord(p_Str[i*3+1])*256*256+ord(p_Str[i*3+2])*256+ord(p_Str[i*3+3]);
    result:=result+ALFA1[n div (64*64*64) + 1];
    n:=n mod (64*64*64);
    result:=result+ALFA1[n div (64*64) + 1];
    n:=n mod (64*64);
    result:=result+ALFA1[n div 64 + 1]+ALFA1[n mod 64 + 1];
  end;
end;
//==============================================================================
function DecryptANSI(p_Str: ANSIstring): ANSIstring;
var i,n,k: integer;
  //****************************************************************************
  function Val(n: integer): integer;
  begin
    result:=pos(p_Str[n],ALFA1)-1;
  end;
  //****************************************************************************
begin
  if copy(p_Str,1,6)<>'@!001!' then
    raise exception.Create('DecryptSmart: wrong header');
  k:=StrToInt(p_Str[7]);
  p_Str:=copy(p_Str,8,length(p_Str));
  if length(p_Str) mod 4 <> 0 then
    raise exception.Create('Decrypt1: wrotg length of parameter!');
  result:='';
  for i:=0 to length(p_Str) div 4 - 1 do begin
    n:=Val(i*4+1)*64*64*64+Val(i*4+2)*64*64+Val(i*4+3)*64+Val(i*4+4);
    result:=result+chr(n div (256*256));
    n:=n mod (256*256);
    result:=result+chr(n div 256)+chr(n mod 256);
  end;
  if k<>0 then
    SetLength(result,length(result)-3+k);
end;
//==============================================================================
procedure SaveStrToFile(FileName,Str: string);
var
  F: TextFile;
begin
  AssignFile(F, FileName);
  Rewrite(F);
  Write(F,Str);
  CloseFile(F);
end;
//==============================================================================
function ReadStrFromFile(FileName: string): string;
var
  F: File of char;
  c: char;
begin
  result:='';
  if not FileExists(FileName) then result:=''
  else begin
    AssignFile(F,FileName);
    Reset(F);
    while not eof(F) do begin
      read(F,c);
      result:=result+c;
    end;
    CloseFile(F);
  end;
end;
//==============================================================================
procedure Str2StringList(s:string;sl:TStrings;Sep:char=',');
var n,i:integer;
begin
  if not Assigned(sl) then sl:=TStringList.Create;
  sl.Clear;
  if s='' then exit;
  n:=1;
  if s[length(s)]<>Sep then s:=s+Sep;
  for i:=1 to length(s) do
    if s[i]=Sep then begin
      sl.Add(copy(s,n,i-n));
      n:=i+1;
    end;
end;
//==============================================================================
procedure PressStringList(SL: TStrings; NewCount: integer; Sep: string = #32);
var i: integer;
begin
  if SL.Count<=NewCount then exit;
  for i:=NewCount to SL.Count-1 do
    SL[NewCount-1]:=SL[NewCount-1]+Sep+SL[i];
  for i:=SL.Count-1 downto NewCount do
    SL.Delete(i);
end;
//==============================================================================
function DevideBy3(sNum: string; Devider: string = '.'): string; overload;
var
  i: integer;
begin
  result:='';
  for i:=0 to length(sNum) do begin
    if (i mod 3 = 0) and (i>0) then
      result:=sNum[length(sNum)-i]+','+result
    else
      result:=sNum[length(sNum)-i]+result;
  end;
end;
//==============================================================================
function DevideBy3(Num: integer; Devider: string = '.'): string; overload;
begin
  result:=DevideBy3(IntToStr(Num));
end;
//==============================================================================
function FormatByLength(Values: array of variant; Len: array of integer): string;
var
  i: integer;
  s: string;
begin
  if High(Values)<>High(Len) then
    raise exception.create('Wrong length of argument arrays');
  result:='';
  for i:=0 to High(Values) do begin
    case VarType(Values[i]) of
      varString: s:=lpad(Values[i],Len[i]);
      varInteger: s:=lpad(IntToStr(Values[i]),Len[i]);
    else
      s:='Error';
    end;
    result:=result+s;
    if i<>High(Values) then
      result:=result+' ';
  end;

end;
//==============================================================================
function AssembleSendCommand(slCMD: array of variant): string;
var
  i: integer;
  s: string;
begin
  result:='';
  if High(slCMD)=-1 then exit;

  for i:=0 to High(slCMD) do begin
    s:=Var2String(slCMD[i]);
    result:=result+s+DP_DELIMITER;
  end;
  result[length(result)]:=DP_END;
end;
//==============================================================================
function ControlSumm(Str: string): LongWord;
var
  i,n: integer;
begin
  result:=0;
  for i:=1 to length(Str) do
    result:=result+ord(Str[i])*i;
end;
//==========================================================================
function Var2String(V: Variant): string;
begin
  if v = null then result:=''
  else case VarType(v) of
    varSmallInt, varInteger, varByte: result:=IntToStr(v);
    varSingle, varDouble: result:=FloatToStr(v);
    varBoolean: begin if v then result:='1' else result:='0'; end;
  else
    result:=v;
  end;
end;
//==========================================================================
procedure Init;
var
  sl: TStringList;
begin
  MAIN_DIR:=ExtractFileDir(System.ParamStr(0));

  if MAIN_DIR[length(MAIN_DIR)]<>'\' then
    MAIN_DIR:=MAIN_DIR+'\';

  {if not DirectoryExists(MAIN_DIR+MM_LOG_DIR) then
    CreateDir(MAIN_DIR+MM_LOG_DIR);}

  if FileExists(MAIN_DIR + 'clserver.ini') then begin
    sl:=TStringList.Create;
    sl.LoadFromFile(MAIN_DIR + 'clserver.ini');

    if sl.Values['DB_PROVIDER']<>'' then
      DB_PROVIDER:=sl.Values['DB_PROVIDER'];

    WORKING_PORT := StrToInt(sl.Values['PORT']);

    if sl.Values['PORT_MM']<>'' then
      try
        PORT_MM:=StrToInt(sl.Values['PORT_MM']);
      except
        PORT_MM:=1026;
      end;

    MM_OPENED := sl.Values['MM']='Y';

    if sl.Values['LAUNCH_MODE'] = 'APPLICATION' then
      LAUNCH_MODE := lncApplication
    else
      LAUNCH_MODE := lncService;

    if sl.Values['DB_LOGGING'] <> '' then
      DB_LOGGING := sl.Values['DB_LOGGING'] = 'Y';

    if sl.Values['DB_SAVEGAME_THREAD'] <> '' then
      DB_SAVEGAME_THREAD := sl.Values['DB_SAVEGAME_THREAD'] = 'Y';
    sl.Free;
  end;
end;
//==========================================================================
procedure ShoutMultiLine(Txt: string; Initiator: TObject);
var
  sl: TStringList;
  i: integer;
begin
  sl:=TStringList.Create;
  try
    sl.Text:=Txt;
    for i:=0 to sl.Count-1 do
      fSocket.Send(fConnections.Connections,[DP_SHOUT,'Server','',sl[i]],Initiator);
    sl.Free;
  finally
    sl.Free;
  end;
end;
//==========================================================================
function CountChars(Str: string; c: char): integer;
var
  i: integer;
begin
  result:=0;
  for i:=1 to length(Str) do
    if Str[i]=c then
      inc(result);
end;
//==========================================================================
function RatedType2Str(RatedType: TRatedType): string;
begin
  case RatedType of
    rtStandard: result:='Standard';
    rtBlitz: result:='Blitz';
    rtBullet: result:='Bullet';
    rtCrazy: result:='Crazy House';
    rtFischer: result:='Fischer Random';
    rtLoser: result:='Losers';
  end;
end;
//==========================================================================
procedure MarkSendOnlyOne(conns: TObjectList; Connection: TConnection);
var
  conn: TConnection;
  i: integer;
begin
  for i:=0 to conns.Count - 1 do begin
    conn := TConnection(conns[i]);
    conn.Send := conn = Connection;
  end;
end;
//==========================================================================
function IsMasterOnlyTitle(title: string): Boolean;
begin
  result := (title = 'FM') or (title = 'IM') or (title = 'WFM') or (title = 'WIM');
end;
//==========================================================================
function IsGMOnlyTitle(title: string): Boolean;
begin
  result := (title = 'GM') or (title = 'WGM');
end;
//==========================================================================
function InCommaString(CommaString, part: string): Boolean;
begin
  result := pos(','+part+',',','+CommaString+',') > 0;
end;
//==========================================================================
function InCommaString(CommaString: string; part: integer): Boolean; overload;
begin
  result := InCommaString(CommaString, IntToStr(part));
end;
//==========================================================================
procedure GetDateDiff(Date1, Date2: TDateTime; var pp_Days, pp_Hours, pp_Minutes: integer);
var
  diff: real;
begin
  diff := abs(Date2 - Date1);
  pp_Days := trunc(diff);
  diff := (diff - pp_Days) * 24;
  pp_Hours := trunc(diff);
  diff := (diff - pp_Hours) * 60;
  pp_Minutes := trunc(diff);
end;
//==========================================================================
function GetDateDiffStrRound(Date1, Date2: TDateTime): string;
var
  days, hours, minutes: integer;
begin
  GetDateDiff(Date1, Date2, days, hours, minutes);
  if days > 0 then result := IntToStr(days) + ' day' + BoolTo_(days > 1, 's', '')
  else if hours > 0 then result := IntToStr(hours) + ' hour' + BoolTo_(hours > 1, 's', '')
  else result := IntToStr(minutes) + ' minute' + BoolTo_(minutes > 1, 's', '');
end;
//==========================================================================
function MinValue(v1, v2: Variant): Variant;
begin
  if v1 < v2 then result := v1
  else result := v2;
end;
//==========================================================================
function MaxValue(v1, v2: Variant): Variant;
begin
  if v1 > v2 then result := v1
  else result := v2;
end;
//==========================================================================
function IsStandardRules(p_RatedType: TRatedType): Boolean;
begin
  result := p_RatedType in [rtBullet, rtBlitz, rtStandard];
end;
//==========================================================================
function GetDateDiffMSec(p_Date1, p_Date2: TDateTime): integer;
begin
  result := trunc((p_Date2 - p_Date1) * MSecsPerDay);
  if result < 0 then result := MAXINT;
end;
//==========================================================================
procedure TestInMainThread;
begin
  if GetCurrentThreadID <> MAIN_THREAD_ID then
    raise exception.create('Wrong thread!!!');
end;
//==========================================================================
function Decode(Params: array of Variant): Variant;
var
  i, l, h: integer;
  value: Variant;
begin
  l := Low(Params);
  h := High(Params);

  result := null;
  if (l <> 0) or (h <= 1) then begin
    ErrLog(Format('CSLib.Decode: Warning! Array with wrong bounds: %d to %d', [l, h]), nil);
    exit;
  end;

  value := Params[0];
  if h mod 2 = 1 then result := Params[h]
  else result := value;

  for i := 1 to (h + 1) div 2 do
    if value = Params[i * 2 - 1] then begin
      result := Params[i * 2];
      exit;
    end;
end;
//==========================================================================
function BoolTo01(b: Boolean): integer;
begin
  if b then result := 1
  else result := 0;
end;
//==========================================================================
function NullIf(p_Param, p_Value: Variant): Variant;
begin
  if p_Param = p_Value then result := null
  else result := p_Param;
end;
//==========================================================================
procedure AppendToFile(p_FileName, p_Line: string);
var
  F: TextFile;
begin
  try
    AssignFile(F, p_FileName);
    if FileExists(p_FileName) then Append(F)
    else Rewrite(F);

    writeln(F, p_Line);
    CloseFile(F);
  except
  end;
end;
//==========================================================================
function NowLogFormat: string;
begin
  result := FormatDateTime('yyyy-mm-dd hh:nn:ss:zzz', Now);
end;
//==========================================================================
procedure AssertInMainThread(p_CalledFrom: string = '');
begin
  exit;
end;
//==========================================================================
function GetExceptionStack: string;
var
  sl: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  try
    JclLastExceptStackListToStrings(sl, True, True, True, True);
    result := sl.Text;
  finally
    FreeAndNil(sl);
  end;
end;
//==========================================================================
end.

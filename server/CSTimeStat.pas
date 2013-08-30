unit CSTimeStat;

interface

uses Classes, SysUtils, CSCOnnection;

type
  TCSTimeStat = class
  private
    slData: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTime(Operation: string; MSec: integer);
    procedure CMD_TimeStat(Connection: TConnection; CMD: TStrings);
    procedure CMD_ClearTimeStat(Connection: TConnection);
    procedure GetData(Operation: string; var MSec, Count: integer);
  end;

var
  fTimeStat: TCSTimeStat;

implementation

uses CSConst, CSSocket, CSLib;

{ TCSTimeStat }

procedure TCSTimeStat.AddTime(Operation: string; MSec: integer);
var
  s: string;
  n,vMSec,vCount: integer;
begin
  if slData = nil then slData:=TStringList.Create;
  operation:=LowerCase(operation);
  if (length(operation)=1) and (ord(operation[1])<32) then
    operation:='['+IntToStr(ord(operation[1]))+']';
  s:=slData.Values[Operation];
  if s='' then s:=Format('%d,%d',[MSec,1])
  else begin
    n:=pos(',',s);
    vMSec:=StrToInt(copy(s,1,n-1));
    vCount:=StrToInt(copy(s,n+1,length(s)));
    vMSec:=vMSec+MSec;
    inc(vCount);
    s:=Format('%d,%d',[vMSec,vCount]);
  end;
  slData.Values[Operation]:=s;
end;
//=========================================================================
procedure TCSTimeStat.CMD_ClearTimeStat(Connection: TConnection);
begin
  slData.Clear;
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Time statistics cleared']);
end;
//=========================================================================
procedure TCSTimeStat.CMD_TimeStat(Connection: TConnection; CMD: TStrings);
var
  i,n,fullCount,fullMsec,count,msec,maxnamelen,msecpercent,countpercent,avg: integer;
  s,sdiv: string;
begin
  fullCount:=0; fullMSec:=0; maxnamelen:=0;
  for i:=0 to slData.Count-1 do begin
    GetData(slData.Names[i],msec,count);
    fullCount:=fullCount+count;
    fullMSec:=fullMSec+msec;
    n:=length(slData.Names[i]);
    if n>maxnamelen then maxnamelen:=n;
  end;

  s:=FormatByLength(['COMMAND','AVG','MS','MS%','CNT','CNT%'],
    [maxnamelen,6,14,4,14,4]);
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,s]);
  sdiv:=rpad('-',length(s),'-');
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,sdiv]);
  for i:=0 to slData.Count-1 do begin
    s:=rpad(slData.Names[i],maxnamelen,' ')+' ';
    try
      GetData(slData.Names[i],msec,count);
      if fullMSec=0 then msecpercent:=0
      else msecpercent:=msec*100 div fullMSec;

      if fullCount=0 then countpercent:=0
      else countpercent:=count*100 div fullCount;

      if count=0 then avg:=0
      else avg:=msec div count;

      s:=s+FormatByLength([avg,msec,IntToStr(msecpercent)+'%',count,IntToStr(countpercent)+'%'],
        [6,14,4,14,4]);

      {s:=s+lpad(IntToStr(avg),6)+' '+lpad(IntToStr(msecpercent),2)+'% '+
        lpad(IntToStr(countpercent),2)+'%';}
    except
      s:=s+'Error: '+slData.Values[slData.Names[i]];
    end;
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,s]);
  end;
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,sdiv]);
  s:=FormatByLength(['TOTAL',' ',fullmsec,' ',fullcount,' '],[maxnamelen,6,14,4,14,4]);
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,s]);
end;
//=========================================================================
constructor TCSTimeStat.Create;
begin
  slData:=TStringList.Create;
end;
//=========================================================================
destructor TCSTimeStat.Destroy;
begin
  inherited;
  slData.Free;
end;
//=========================================================================
procedure TCSTimeStat.GetData(Operation: string; var MSec, Count: integer);
var
  s: string;
  n: integer;
begin
  s:=slData.Values[operation];
  if s='' then begin
    MSec:=0; Count:=0;
  end else begin
    n:=pos(',',s);
    MSec:=StrToInt(copy(s,1,n-1));
    Count:=StrToInt(copy(s,n+1,length(s)));
  end;
end;
//=========================================================================
end.

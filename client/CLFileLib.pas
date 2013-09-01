{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLFileLib;

interface

uses SysUtils,Classes,contnrs, graphics;

type
  TCLFileLibSchema = class
    id: integer;
    name: string;
    desc: string;
  end;

  TCLFileLibSchemas = class(TObjectList)
  private
    function GetSchema(Num: integer): TCLFileLibSchema;
  public
    procedure AddSchema(name,desc: string);
    property Schema[Num: integer]: TCLFileLibSchema read GetSchema; default;
  end;

  TCLFileLibUnit = class
    name: string;
    schema: integer;
    FData: array of byte;
  private
    function GetData: string;
    procedure SetData(const Value: string);
  public
    data: string;
    constructor Create;
    destructor Destroy;
    //property Data: string read GetData write SetData;
  end;

  TCLFileLibUnits = class(TObjectList)
  private
    function GetLibUnit(Num: integer): TCLFileLibUnit;
  public
    function IndexOfUnit(name: string; schema: integer): integer;
    procedure InsOrUpd(name: string; schema: integer; data: string);
    property LibUnit[Num: integer]: TCLFileLibUnit read GetLibUnit; default;
  end;

  TCLFileLib = class
  private
    FSchemas: TCLFileLibSchemas;
    FUnits: TCLFileLibUnits;
    FCurrentSchema: integer;
    procedure SetCurrentSchema(const Value: integer);
  public
    FileName: string;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Load;
    function Save: Boolean;
    procedure AddFile(name: string; schema: integer; filename: string);
    function SaveUnitToFile(name: string; schema: integer; filename: string): Boolean;
    property Schemas: TCLFileLibSchemas read FSchemas;
    property Units: TCLFileLibUnits read FUnits;
    property CurrentSchema: integer read FCurrentSchema write SetCurrentSchema;
  end;

  TCLPngLib = class(TCLFileLib)
  public
    function ReadBitMap(name: string; schema: integer; BitMap: TBitMap): Boolean;
  end;

  TCLSoundLib = class(TCLFileLib)
  public
    procedure PlaySounds(SoundList: string; schema: integer);
  end;

  TCLSoundMovesLib = class(TCLSoundLib)
  private
    function PieceToSoundName(piece: char): string;
    function PgnToSoundList(pgn: string): string;
  public
    procedure PlayMoveSound(pgn: string; schema: integer);
  end;

implementation

uses PngUnit, CLMediaPlayer, CLMain;
//==============================================================================
procedure Str2StringList(s:string;var sl:TStringList;Sep:string=',');
var n,i:integer;
begin
  if not Assigned(sl) then sl:=TStringList.Create;
  sl.Clear;
  if s='' then exit;
  n:=1;
  if s[length(s)]<>Sep then s:=s+Sep[1];
  for i:=1 to length(s) do
    if s[i]=Sep then begin
      sl.Add(trim(copy(s,n,i-n)));
      n:=i+1;
    end;
end;
//==============================================================================
function ReadStrFromFile(FileName: string; var data: string): Boolean;
var
  F: File;
  buf: PByteArray;
  i,bytesread: integer;
begin
  new(buf);
  result:=false;
  data:='';
  try
    AssignFile(F,FileName);
    Reset(F,1);
    repeat
      BlockRead(F, buf^, SizeOf(buf^), BytesRead);
      for i:=0 to BytesRead-1 do
        data:=data+char(buf[i]);
    until BytesRead<>SizeOf(buf^);
    CloseFile(F);
    result:=true;
  finally
    dispose(buf);
  end;
end;
//==============================================================================
function WriteStrToFile(FileName: string; data: string): Boolean;
var
  F: File of char;
  i: integer;
begin
  result:=false;
  try
    AssignFile(F,FileName);
    Rewrite(F);
    for i:=1 to length(data) do
      write(F,data[i]);
    CloseFile(F);
    result:=true;
  except
  end;
end;
//==============================================================================
function GetTempFileName(ext: string): string;
var
  i: integer;
begin
  i:=0;
  repeat
    inc(i);
    result:='tmp'+IntToStr(i)+'.'+ext;
  until not FileExists(result);
end;

{ TCLFileLibSchemas }

procedure TCLFileLibSchemas.AddSchema(name, desc: string);
var
  sch: TCLFileLibSchema;
begin
  sch:=TCLFileLibSchema.Create;
  sch.name:=name;
  sch.desc:=desc;
  sch.id:=Count;
  Add(sch);
end;
//==============================================================================
function TCLFileLibSchemas.GetSchema(Num: integer): TCLFileLibSchema;
begin
  result:=TCLFileLibSchema(Items[Num]);
end;

{ TCLFileLibUnits }

function TCLFileLibUnits.GetLibUnit(Num: integer): TCLFileLibUnit;
begin
  result:=TCLFileLibUnit(Items[Num]);
end;
//==============================================================================
function TCLFileLibUnits.IndexOfUnit(name: string;
  schema: integer): integer;
var
  i: integer;
begin
  for i:=0 to Count-1 do
    if (LibUnit[i].name=name) and (LibUnit[i].schema=schema) then begin
      result:=i;
      exit;
    end;
  result:=-1;
end;
//==============================================================================
procedure TCLFileLibUnits.InsOrUpd(name: string; schema: integer; data: string);
var
  n: integer;
  un: TCLFileLibUnit;
begin
  n:=IndexOfUnit(name,schema);
  if n=-1 then begin
    un:=TCLFileLibUnit.Create;
    un.name:=name;
    un.schema:=schema
  end else
    un:=LibUnit[n];

  un.data:=data;
  Add(un);
end;

{ TCLFileLib }

procedure TCLFileLib.AddFile(name: string; schema: integer; filename: string);
var
  data: string;
begin
  if ReadStrFromFile(filename,data) then
    FUnits.InsOrUpd(name,schema,data);
end;
//==============================================================================
procedure TCLFileLib.Clear;
begin
  Schemas.Clear;
  Units.Clear;
end;
//==============================================================================
constructor TCLFileLib.Create;
begin
  inherited;
  FUnits:=TCLFileLibUnits.Create;
  FSchemas:=TCLFileLibSchemas.Create;
end;
//==============================================================================
destructor TCLFileLib.Destroy;
begin
  inherited;
  FUnits.Free;
  FSchemas.Free;
end;
//==============================================================================
procedure TCLFileLib.Load;
var
  buf,s,msg: string;
  i,n,start,size,schema: integer;
  sl: TStringList;
begin
  if FileName = '' then raise exception.create('Define filename first');
  if not ReadStrFromFile(FileName,buf) then
    raise exception.create('Error reading file '+FileName);
  msg:='Wrong format of data file';
  sl:=TStringList.Create;
  try
    // schemas
    n:=pos('@',buf);
    if n=0 then raise exception.create(msg);
    s:=copy(buf,1,n-1);
    buf:=copy(buf,n+1,length(buf));
    Str2StringList(s,sl,'|');
    if sl.Count mod 2 = 1 then sl.Add('');
    for i:=0 to (sl.Count-1) div 2 do
      Schemas.AddSchema(sl[i*2],sl[i*2+1]);
    // units
    n:=pos('@',buf);
    if n=0 then raise exception.create(msg);
    s:=copy(buf,1,n-1);
    buf:=copy(buf,n+1,length(buf));
    Str2StringList(s,sl,'|');
    if sl.Count mod 3 <> 0 then
      raise exception.create(msg);
    start:=1;
    for i:=0 to (sl.Count-1) div 3 do begin
      schema:=StrToInt(sl[i*3+1]);
      size:=StrToInt(sl[i*3+2]);
      Units.InsOrUpd(sl[i*3],schema,copy(buf,start,size));
      start:=start+size;
    end;
  finally
    sl.Free;
  end;
end;
//==============================================================================
function TCLFileLib.Save: Boolean;
var
  i: integer;
  buf,s: string;
begin
  buf:='';
  if FileName = '' then raise exception.create('Define filename first');
  for i:=0 to Schemas.Count-1 do begin
    s:=Format('%s|%s',[Schemas[i].Name,Schemas[i].Desc]);
    if i<Schemas.Count-1 then s:=s+'|';
    buf:=buf+s;
  end;
  buf:=buf+'@';
  for i:=0 to Units.Count-1 do begin
    s:=Format('%s|%d|%d',[Units[i].Name,Units[i].Schema,length(Units[i].data)]);
    if i<Units.Count-1 then s:=s+'|';
    buf:=buf+s;
  end;
  buf:=buf+'@';
  for i:=0 to Units.Count-1 do
    buf:=buf+Units[i].Data;
  result:=WriteStrToFile(FileName,buf);
end;
//==============================================================================
function TCLFileLib.SaveUnitToFile(name: string; schema: integer; filename: string): Boolean;
var
  n: integer;
begin
  n:=Units.IndexOfUnit(name,schema);
  if n=-1 then raise exception.create(
    Format('There are now unit name=%s schema=%d',[name,schema]));
  result:=WriteStrToFile(filename,Units[n].Data);
end;
//==============================================================================
procedure TCLFileLib.SetCurrentSchema(const Value: integer);
begin
  if (Value>=0) and (Value<Schemas.Count) then
    FCurrentSchema := Value;
end;

{ TCLPngLib }

function TCLPngLib.ReadBitMap(name: string; schema: integer;
  BitMap: TBitMap): Boolean;
var
  i: integer;
  filename: string;
begin
  result:=false;
  i:=0;
  repeat
    inc(i);
    filename:='tmp'+IntToStr(i)+'.png';
  until not FileExists(filename);
  if not SaveUnitToFile(name,schema,filename) then exit;
  ReadBitmapFromPngFile(filename,BitMap);
  DeleteFile(filename);
  result:=true;
end;
//==============================================================================
{ TCLSoundLib }

procedure TCLSoundLib.PlaySounds(SoundList: string; schema: integer);
var
  sl: TStringList;
  i: integer;
  filename: string;
  thread: TCLMPlayerThread;
begin
  sl:=TStringList.Create;
  try
    Str2StringList(SoundList,sl,';');
    for i:=0 to sl.Count-1 do begin
      filename:=GetTempFileName('mp3');
      SaveUnitToFile(sl[i],schema,filename);
      slMP3List.Add(filename);
    end;
    thread:=TCLMPlayerThread.Create(false);
  finally
    sl.Free;
  end;
end;
//==============================================================================
{ TCLSoundMovesLib }

function TCLSoundMovesLib.PieceToSoundName(piece: char): string;
begin
  if piece in ['K','Q','R','B','N','x','+'] then
    case piece of
      'K': result:='king';
      'Q': result:='queen';
      'R': result:='rook';
      'B': result:='bishop';
      'N': result:='knight';
      'x': result:='takes';
      '+': result:='check';
    end
  else
    result:=piece;
end;
//==============================================================================
function TCLSoundMovesLib.PgnToSoundList(pgn: string): string;
var
  i: integer;
  s,tail: string;
begin
  if pgn='' then exit;
  result:='';
  // tail
  tail:='';
  while not (pgn[length(pgn)] in ['0'..'9']) do begin
    tail:=PieceToSoundName(pgn[length(pgn)])+';'+tail;
    pgn:=copy(pgn,1,length(pgn)-1);
  end;

  if (pgn='0-0') or (pgn='0-0-0') then
    result:=pgn+';'
  else begin
    //if pgn='0-0' then

    while length(pgn)>2 do begin
      result:=result+PieceToSoundName(pgn[1])+';';
      pgn:=copy(pgn,2,length(pgn));
    end;

    result:=result+pgn+';';
  end;
  result:=result+tail;
  if result[length(result)]=';' then
    SetLength(result,length(result)-1);
end;
//==============================================================================
procedure TCLSoundMovesLib.PlayMoveSound(pgn: string; schema: integer);
var
  s: string;
begin
  s:=PgnToSoundList(pgn);
  if s<>'' then PlaySounds(s,schema);
end;
//==============================================================================
{ TCLFileLibUnit }

constructor TCLFileLibUnit.Create;
begin
end;
//==============================================================================
destructor TCLFileLibUnit.Destroy;
begin
end;
//==============================================================================
function TCLFileLibUnit.GetData: string;
var
  i: word;
begin
  result:='';
  for i:=0 to High(FData) do
    result:=result+chr(FData[i]);
end;
//==============================================================================
procedure TCLFileLibUnit.SetData(const Value: string);
var
  i: integer;
begin
  SetLength(FData,length(Value));
  for i:=0 to length(Value) do
    FData[i]:=ord(Value[i]);
end;
//==============================================================================
end.

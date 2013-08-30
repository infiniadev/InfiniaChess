unit CLBan;

interface

uses Windows, Comctrls, Classes, SysUtils;

function GetNewBanRegistryName: string;
function RegistryNameIsBanName(Str: string): Boolean;
function CreateBanRegistryKey(var Name: string): Boolean;
function FindBanRegistryKeys(Keys: TStrings): Boolean;
function DeleteBanRegistryKeys: Boolean;
function CreateBanFile: Boolean;
function DeleteBanFile: Boolean;
function BanFileExists: Boolean;
function Ban: Boolean;
function Unban: Boolean;
function IsBanned: Boolean;

implementation

uses Registry,CLCOnst, CLMain;

//==============================================================================
const
  Shifr='abcdefghijklmnoprstuvwxyz';
  CodeWord='disable';
  BanFileName='c:\ntcl.sys';
//==============================================================================
function Coding(s:string; seed: integer = 0):string;
var sm,i,n:integer;
    res:string;
begin
  if seed=0 then sm:=random(length(Shifr))+1
  else sm:=seed mod length(Shifr)+1;
  res:=Shifr[sm];
  for i:=1 to length(s) do begin
    n:=pos(s[i],Shifr);
    if n=0 then Raise Exception.Create('Coding: Symbol not found '+s[i]);
    n:=(n+sm*i) mod length(Shifr)+1;
    res:=res+Shifr[n];
  end;
  result:=res;
end;
//==============================================================================
function Decoding(s:string):string;
var sm,i,n:integer;
    res:string;
begin
  sm:=pos(s[1],Shifr);
  res:=''; result:='';
  for i:=2 to length(s) do begin
     n:=pos(s[i],Shifr);
     if n=0 then exit;
     n:=n-sm*(i-1)+length(Shifr)*i-2;
     n:=n mod length(Shifr)+1;
     res:=res+Shifr[n];
  end;
  result:=res;
end;
//==============================================================================
function UpperLetter(Str: string; Num: integer): string;
var s: string;
begin
  if (Num<1) or (Num>length(Str)) then result:=Str
  else begin
    s:=uppercase(copy(Str,Num,1));
    result:=copy(Str,1,Num-1)+s+copy(Str,Num+1,length(Str));
  end;
end;
//==============================================================================
function GetNewBanRegistryName: string;
var
  s,s1: string;
  i,n: integer;
begin
  s:=CodeWord;
  s1:='';
  for i:=1 to length(s) do
    s1:=s1+Shifr[Random(length(Shifr))+1]+s[i];
  result:=Coding(s1);
  n:=Random(3);
  result:=UpperLetter(result,1);
  result:=UpperLetter(result,7+n);
end;
//==============================================================================
function RegistryNameIsBanName(Str: string): Boolean;
var
  s,s1: string;
  i: integer;
begin
  result:=false;
  s:=Decoding(lowercase(Str));
  if (s='') or (length(s)<>length(CodeWord)*2) then exit;
  s1:='';
  for i:=1 to length(s) do
    if i mod 2 = 0 then
      s1:=s1+s[i];
  result:=s1=CodeWord;
end;
//==============================================================================
function GetRandomSetString(Str: string; Len: integer): string;
var i: integer;
begin
  result:='';
  for i:=1 to Len do
    result:=result+Str[Random(length(Str))+1];
end;
//==============================================================================
function GetFakeClsId: string;
var s,s1: string;
begin
  s1:='0123456789ABCDEFabcdef';
  result:='{'+GetRandomSetString(s1,8)+'-'+GetRandomSetString(s1,4)+'-'+
    GetRandomSetString(s1,4)+'-'+GetRandomSetString(s1,13)+'}';
end;
//==============================================================================
function CreateBanRegistryKey(var Name: string): Boolean;
var
  clsid: string;     // XhanbigNkuhsndc
  R: TRegistry;
begin
  result:=false;
  name:=GetNewBanRegistryName;
  clsid:=GetFakeCLSId;
  R:=TRegistry.Create;
  try
    R.RootKey:=HKEY_CLASSES_ROOT;
    if not R.OpenKey(name,true) then exit;
    result:=true;
    if R.OpenKey('CLSID',true) then
      try R.WriteString('',clsid); except end;
  finally
    R.Free;
  end;
end;
//==============================================================================
function FindBanRegistryKeys(Keys: TStrings): Boolean;
var
  R,R1: TRegistry;
  sl: TStringList;
  i: integer;
begin
  sl:=TStringList.Create;
  Keys.Clear;
  R:=TRegistry.Create;
  R.RootKey:=HKEY_CLASSES_ROOT;
  R.OpenKeyReadOnly('');
  R.GetKeyNames(sl);
  for i:=0 to sl.Count-1 do
    if RegistryNameIsBanName(sl[i]) then
      Keys.Add(sl[i]);
  result:=Keys.Count>0;
  sl.Free;
  R.Free;
end;
//==============================================================================
function DeleteRegistryKeyRecursive(Root: HKEY; KeyName: string): Boolean;
var
  R: TRegistry;
  sl: TStringList;
  i: integer;
begin
  result:=false;
  sl:=TStringList.Create;
  R:=TRegistry.Create;
  try
    R.RootKey:=Root;
    R.OpenKey(KeyName,false);
    R.GetKeyNames(sl);
    for i:=0 to sl.Count-1 do
      if not DeleteRegistryKeyRecursive(Root,KeyName+'\'+sl[i]) then
        exit;
    R.CloseKey;
    R.DeleteKey(KeyName);
    result:=true;
  finally
    sl.Free;
    R.Free;
  end;
end;
//==============================================================================
function DeleteBanRegistryKeys: Boolean;
var
  sl: TStringList;
  i: integer;
begin
  sl:=TStringList.Create;
  try
    if not FindBanRegistryKeys(sl) then exit;
    result:=false;
    for i:=0 to sl.Count-1 do
      if not DeleteRegistryKeyRecursive(HKEY_CLASSES_ROOT,sl[i]) then
        exit;
    result:=true;
  finally
    sl.Free;
  end;
end;
//==============================================================================
function CreateBanFile: Boolean;
var F: TextFile;
begin
  //if NO_IO then exit;
  result:=false;
  if FileExists(BanFileName) then exit;
  AssignFile(F,BanFileName);
  try
    try
      Rewrite(F);
      result:=true;
      FileSetAttr(BanFileName,faReadOnly or faSysFile);
    except
    end;
  finally
    CloseFile(F);
  end;
end;
//==============================================================================
function BanFileExists: Boolean;
begin
  result:=FileExists(BanFileName);
end;
//==============================================================================
function DeleteBanFile: Boolean;
begin
  if not FileExists(BanFileName) then exit;
  FileSetAttr(BanFileName,0);
  result:=DeleteFile(BanFileName);
end;
//==============================================================================
function Ban: Boolean;
var s: string;
begin
  result:=CreateBanFile or CreateBanRegistryKey(s);
end;
//==============================================================================
function Unban: Boolean;
begin
  result:=DeleteBanFile and DeleteBanRegistryKeys;
end;
//==============================================================================
function IsBanned: Boolean;
var sl: TStringList;
begin
  if DebugHook<>0 then result:=false
  else begin
    sl:=TStringList.Create;
    result:=FindBanRegistryKeys(sl) or BanFileExists;
    sl.Free;
  end;
end;
//==============================================================================
end.



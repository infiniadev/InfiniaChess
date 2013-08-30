unit CLAchievementClass;

interface

uses contnrs, SysUtils, classes, graphics, windows;

type
  TAchUserStatus = (ausDisabled, ausNotStarted, ausInProgress, ausFinished);
  TAchButtonType = (abtGroup, abtAchDetails);

  TCLAchButton = class
  public
    R: TRect;
    ButtonType: TAchButtonType;
    TurnedOn: Boolean;
    Tag: integer;
  end;

  TCLAchButtonList = class(TObjectList)
  private
    function GetAchButton(Index: integer): TCLAchButton;
  public
    function ButtonByXY(X,Y: integer): TCLAchButton;
    property AchButton[Index: integer]: TCLAchButton read GetAchButton; default;
  end;

  TCLAchInfo = class
    Text: string;
    Completed: Boolean;
    Progress: integer;
    MaxCount: integer;
  end;

  TCLAchGroup = class
  public
    ID: integer;
    Name: string;
  end;

  TCLAchGroups = class(TObjectList)
  private
    function GetGroup(Index: integer): TCLAchGroup;
    function GetGroupByID(ID: integer): TCLAchGroup;
  public
    function IndexByID(ID: integer): integer;
    property Group[Index: integer]: TCLAchGroup read GetGroup; default;
    property GroupByID[ID: integer]: TCLAchGroup read GetGroupByID;
  end;

  TCLAchInfoList = class(TObjectList)
  public

  end;

  TCLAchievement = class
  public
    ID: integer;
    Name: string;
    Description: string;
    GroupID: integer;
    MaxCountOne: integer;
    MaxCount: integer;
    Score: integer;
    ClusterID: integer;
    ClusterOrderNum: integer;
  end;

  TCLAchList = class
  private
    GroupList: TCLAchGroups;
    AchList: TObjectList;

    function GetAch(Index: integer): TCLAchievement;
    function GetCount: integer;
    function GetGroupCount: integer;
    function GetGroup(Index: integer): TCLAchGroup;
    function GetGroupByID(ID: integer): TCLAchGroup;
    function GetAchByID(ID: integer): TCLAchievement;
  public
    constructor Create; virtual;
    destructor Destroy; virtual;

    procedure CMD_AchClear;
    procedure CMD_AchGroup(CMD: TStrings);
    procedure CMD_Achievement(CMD: TStrings);
    function AchIndexByID(ID: integer): integer;
    procedure Clear;

    property Ach[Index: integer]: TCLAchievement read GetAch; default;
    property AchByID[ID: integer]: TCLAchievement read GetAchByID;
    property Count: integer read GetCount;
    property GroupCount: integer read GetGroupCount;
    property Group[Index: integer]: TCLAchGroup read GetGroup;
    property GroupByID[ID: integer]: TCLAchGroup read GetGroupByID;
  end;

  TCLAchUserInfo = class
  public
    Text: string;
    Done: Boolean;
    Progress: integer;
    MaxCount: integer;
    Date: TDateTime;
    function ScreenText: string;
  end;

  TCLAchUserInfoList = class(TObjectList)
  private
    function GetUserInfo(Index: integer): TCLAchUserInfo;
  public
    property UserInfo[Index: integer]: TCLAchUserInfo read GetUserInfo; default;
  end;

  TCLAchUser = class
  public
    AchID: integer;
    Status: TAchUserStatus;
    Progress: integer;
    AchieveDate: TDateTime;
    InfoList: TCLAchUserInfoList;

    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TCLAchUserList = class(TObjectList)
  private
    slStat: TStringList;
    FScore: integer;
    FSLRecent: TStringList;
    function GetAchUser(Index: integer): TCLAchUser;
    function GetAchUserByID(ID: integer): TCLAchUser;
    function GetStatCount: integer;
    function GetStatMaxcount(Index: integer): integer;
    function GetStatName(Index: integer): string;
    function GetStatProgress(Index: integer): integer;
    function GetRecentAchID(Index: integer): integer;
    function GetRecentCount: integer;
    function GetStatGroupID(Index: integer): integer;
  public
    Login: string;
    Buttons: TCLAchButtonList;
    stGroup: string;
    stAch: string;

    constructor Create; virtual;
    destructor Destroy; override;
    procedure CMD_AchUser(CMD: TStrings);
    procedure CMD_AchUserInfo(CMD: TStrings);
    procedure CMD_AchUserInfoClear(CMD: TStrings);
    procedure CMD_AchSendEnd(CMD: TStrings);
    procedure FillStateStrings;
    function GetButtonState(obj: TObject): Boolean;
    function SwapButtonState(ButtonType: TAchButtonType; ID: integer): Boolean;
    function ProgressByID(ID: integer): integer;
    function InfoExists(ID: integer): Boolean;
    function GetStatus(ID: integer): TAchUserStatus;
    procedure CreateGroupStatistics;

    property AchUser[Index: integer]: TCLAchUser read GetAchUser; default;
    property AchUserByID[ID: integer]: TCLAchUser read GetAchUserByID;
    property StatCount: integer read GetStatCount;
    property StatName[Index: integer]: string read GetStatName;
    property StatProgress[Index: integer]: integer read GetStatProgress;
    property StatMaxCount[Index: integer]: integer read GetStatMaxcount;
    property StatGroupID[Index: integer]: integer read GetStatGroupID;
    property Score: integer read FScore;
    property RecentCount: integer read GetRecentCount;
    property RecentAchID[Index: integer]: integer read GetRecentAchID;
  end;

var
  AchList: TCLAchList;
  MyAchUserList: TCLAchUserList;

implementation

uses CLLib;

const
  GROUP_HEIGHT = 40;
//===================================================================================
{ TAchGroups }

function TCLAchGroups.GetGroup(Index: integer): TCLAchGroup;
begin
  result := TCLAchGroup(Items[Index]);
end;
//===================================================================================
function TCLAchGroups.GetGroupByID(ID: integer): TCLAchGroup;
var
  i: integer;
begin
  for i := 0 to Count-1 do begin
    result := Group[i];
    if result.ID = ID then exit;
  end;
  result := nil;
end;
//================================================================================
{ TCLAchievements }

function TCLAchList.AchIndexByID(ID: integer): integer;
var
  vAch: TCLAchievement;
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := i;
    if Ach[i].ID = ID then exit;
  end;
  result := -1;
end;
//================================================================================
procedure TCLAchList.Clear;
begin
  GroupList.Clear;
  AchList.Clear;
end;
//================================================================================
procedure TCLAchList.CMD_AchClear;
begin
  GroupList.Clear;
  AchList.Clear;
end;
//================================================================================
procedure TCLAchList.CMD_AchGroup(CMD: TStrings);
var
  group: TCLAchGroup;
begin
  if CMD.Count < 3 then exit;
  group := TCLAchGroup.Create;
  group.ID := StrToInt(CMD[1]);
  group.Name := CMD[2];
  GroupList.Add(group);
end;
//================================================================================
procedure TCLAchList.CMD_Achievement(CMD: TStrings);
var
  vAch: TCLAchievement;
begin
  if CMD.Count < 9 then exit;
  vAch := TCLAchievement.Create;
  vAch.ID := StrToInt(CMD[1]);
  vAch.Name := CMD[2];
  vAch.Description := CMD[3];
  vAch.GroupID := StrToInt(CMD[4]);
  vAch.MaxCountOne := StrToInt(CMD[5]);
  vAch.MaxCount := StrToInt(CMD[6]);
  vAch.Score := StrToInt(CMD[7]);
  vAch.ClusterID := StrToInt(CMD[8]);
  vAch.ClusterOrderNum := StrToInt(CMD[9]);
  AchList.Add(vAch);
end;
//================================================================================
constructor TCLAchList.Create;
begin
  GroupList := TCLAchGroups.Create;
  AchList := TObjectList.Create;
end;
//================================================================================
destructor TCLAchList.Destroy;
begin
  GroupList.Free;
  AchList.Free;
end;
//================================================================================
function TCLAchList.GetAch(Index: integer): TCLAchievement;
begin
  result := TCLAchievement(AchList.Items[Index]);
end;
//================================================================================
{ TCLAchUserInfoList }

function TCLAchUserInfoList.GetUserInfo(Index: integer): TCLAchUserInfo;
begin
  result := TCLAchUserInfo(Items[Index]);
end;
//================================================================================
{ TCLAchUser }

constructor TCLAchUser.Create;
begin
  InfoList := TCLAchUserInfoList.Create;
end;
//================================================================================
destructor TCLAchUser.Destroy;
begin
  inherited;
  InfoList.Free;
end;
//================================================================================
{ TCLAchUserList }

procedure TCLAchUserList.CMD_AchSendEnd(CMD: TStrings);
begin
  CreateGroupStatistics;
end;
//================================================================================
procedure TCLAchUserList.CMD_AchUser(CMD: TStrings);
var
  vAchId, vProgress: integer;
  vStatus: TAchUserStatus;
  AU: TCLAchUser;
  vAchieveDate: TDateTime;
begin
  if CMD.Count < 5 then exit;
  vAchID := StrToInt(CMD[2]);
  vStatus := TAchUserStatus(StrToInt(CMD[3]));
  vProgress := StrToInt(CMD[4]);
  vAchieveDate := Str2Float(CMD[5]);
  
  AU := GetAchUserByID(vAchID);
  if AU = nil then begin
    AU := TCLAchUser.Create;
    AU.AchID := vAchID;
    Add(AU);
  end;
  AU.Status := vStatus;
  AU.Progress := vProgress;
  AU.AchieveDate := vAchieveDate;
end;
//================================================================================
procedure TCLAchUserList.CMD_AchUserInfo(CMD: TStrings);
var
  i, vAchID, vProgress, vMaxCount: integer;
  vDone: Boolean;
  AU: TCLAchUser;
  AUI: TCLAchUserInfo;
  sAchIDList, text: string;
  sl: TStringList;
  vDate: TDateTime;
begin
  if CMD.Count < 8 then exit;
  sAchIDList := CMD[2];
  text := CMD[3];
  vDone := CMD[4] = '1';
  vProgress := StrToInt(CMD[5]);
  vMaxCount := StrToInt(CMD[6]);
  vDate := Str2Float(CMD[7]);

  sl := TStringList.Create;
  Str2StringList(sAchIDList, sl);
  for i := 0 to sl.Count - 1 do begin
    vAchID := StrToInt(sl[i]);
    AU := GetAchUserByID(vAchID);
    if AU = nil then continue;
    AUI := TCLAchUserInfo.Create;
    AUI.Text := text;
    AUI.Done := vDone;
    AUI.Progress := vProgress;
    AUI.MaxCount := vMaxCount;
    AUI.Date := vDate;
    AU.InfoList.Add(AUI);
  end;
  sl.Free;
end;
//================================================================================
procedure TCLAchUserList.CMD_AchUserInfoClear(CMD: TStrings);
var
  i, vAchID: integer;
  sl: TStringList;
  sAchIDList: string;
  AU: TCLAchUser;
begin
  sAchIDList := CMD[2];
  sl := TStringList.Create;
  Str2StringList(sAchIDList, sl);
  for i := 0 to sl.Count - 1 do begin
    vAchID := StrToInt(sl[i]);
    AU := GetAchUserByID(vAchID);
    if AU <> nil then
      AU.InfoList.Clear;
  end;
  sl.Free;
end;
//================================================================================
constructor TCLAchUserList.Create;
begin
  Buttons := TCLAchButtonList.Create;
  slStat := TStringList.Create;
  FSLRecent := TStringList.Create;
end;
//================================================================================
procedure TCLAchUserList.CreateGroupStatistics;
var
  slFinished, slByDate: TStringList;
  i, j, total, completed, n: integer;
  GR: TCLAchGroup;
  s: string;
  AU: TCLAchUser;
begin
  slFinished := TStringList.Create;
  slByDate := TStringList.Create;
  slFinished.Sorted := true;
  slByDate.Sorted := true;

  FScore := 0;
  for i := 0 to Count - 1 do begin
    AU := AchUser[i];
    if AU.Status = ausFinished then begin
      slFinished.Add(IntToStr(AU.AchID));
      FScore := FScore + AchList.AchByID[AU.AchID].Score;
      s := FormatDateTime('yyyymmdd',AU.AchieveDate) + lpad(IntToStr(AU.AchID),5,'0');
      slByDate.Add(s);
    end;
  end;

  FSLRecent.Clear;
  if slByDate.Count > 5 then n := 5
  else n := slByDate.Count;
  for i := slByDate.Count - 1 downto slByDate.Count - n do begin
    s := copy(slByDate[i], 9, 255);
    FSLRecent.Add(s);
  end;

  slStat.Clear;
  slStat.Add('All Achievements%' + IntToStr(slFinished.Count) + '%' + IntToStr(AchList.Count));
  for i := 0 to AchList.GroupCount - 1 do begin
    GR := AchList.Group[i];
    total := 0;
    completed := 0;
    for j := 0 to AchList.Count - 1 do
      if AchList[j].GroupID = GR.ID then begin
        inc(total);
        if slFinished.IndexOf(IntToStr(AchList[j].ID)) <> -1 then
          inc(completed);
      end;
    slStat.Add(GR.Name + '%' + IntToStr(completed) + '%' + IntToStr(total));
  end;

  slFinished.Free;
  slByDate.Free;
end;
//================================================================================
destructor TCLAchUserList.Destroy;
begin
  inherited;
  Buttons.Free;
  slStat.Free;
  FSLRecent.Free;
end;
//================================================================================
procedure TCLAchUserList.FillStateStrings;
var
  i: integer;
begin
  stGroup := lpad('', AchList.GroupCount, '1');
  stAch := lpad('', AchList.Count, '0');
end;
//================================================================================
function TCLAchUserList.GetAchUser(Index: integer): TCLAchUser;
begin
  result := TCLAchUser(Items[Index]);
end;
//================================================================================
function TCLAchUserList.GetAchUserByID(ID: integer): TCLAchUser;
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := AchUser[i];
    if result.AchID = ID then exit;
  end;
  result := nil;
end;
//================================================================================
function TCLAchList.GetAchByID(ID: integer): TCLAchievement;
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := Ach[i];
    if result.ID = ID then exit;
  end;
  result := nil;
end;
//================================================================================
function TCLAchList.GetCount: integer;
begin
  result := AchList.Count;
end;
//================================================================================
function TCLAchList.GetGroup(Index: integer): TCLAchGroup;
begin
  result := TCLAchGroup(GroupList[Index]);
end;
//================================================================================
function TCLAchList.GetGroupByID(ID: integer): TCLAchGroup;
begin
  result := GroupList.GroupByID[ID];
end;
//================================================================================
function TCLAchList.GetGroupCount: integer;
begin
  result := GroupList.Count;
end;
//================================================================================
function TCLAchUserList.GetButtonState(obj: TObject): Boolean;
var
  index: integer;
begin
  if obj is TCLAchGroup then begin
    index := AchList.GroupList.IndexOf(obj);
    result := stGroup[index + 1] = '1';
  end else if obj is TCLAchievement then begin
    index := AchList.AchList.IndexOf(obj);
    result := stAch[index + 1] = '1';
  end else
    raise exception.create('TCLAchUserList.GetButtonState: wrong object type');
end;
//================================================================================
function Swap01String(index: integer; var str: string): Boolean;
var
  c: char;
begin
  c := str[index];
  if c = '1' then c := '0' else c := '1';
  str[index] := c;
  result := c = '1';
end;
//================================================================================
function TCLAchUserList.GetRecentAchID(Index: integer): integer;
begin
  result := StrToInt(FSLRecent[Index]);
end;
//================================================================================
function TCLAchUserList.GetRecentCount: integer;
begin
  result := FSLRecent.Count;
end;
//================================================================================
function TCLAchUserList.GetStatCount: integer;
begin
  result := slStat.Count;
end;
//================================================================================
function TCLAchUserList.GetStatGroupID(Index: integer): integer;
begin
  result := AchList.Group[Index - 1].ID;
end;
//================================================================================
function TCLAchUserList.GetStatMaxcount(Index: integer): integer;
var
  s: string;
  n: integer;
begin
  s := slStat[Index];
  n := pos('%', s);
  s := copy(s, n + 1, length(s));
  n := pos('%', s);
  result := StrToInt(copy(s, n + 1, length(s)));
end;
//================================================================================
function TCLAchUserList.GetStatName(Index: integer): string;
var
  s: string;
  n: integer;
begin
  s := slStat[Index];
  n := pos('%', s);
  result := copy(s, 1, n - 1);
end;
//================================================================================
function TCLAchUserList.GetStatProgress(Index: integer): integer;
var
  s: string;
  n: integer;
begin
  s := slStat[Index];
  n := pos('%', s);
  s := copy(s, n + 1, length(s));
  n := pos('%', s);
  result := StrToInt(copy(s, 1, n - 1));
end;
//================================================================================
function TCLAchUserList.GetStatus(ID: integer): TAchUserStatus;
var
  AU: TCLAchUser;
begin
  AU := AchUserByID[ID];
  if AU = nil then result := ausNotStarted
  else result := AU.Status;
end;
//================================================================================
function TCLAchUserList.InfoExists(ID: integer): Boolean;
var
  AU: TCLAchUser;
begin
  AU := AchUserByID[ID];
  result := (AU <> nil) and (AU.InfoList.Count > 0); 
end;
//================================================================================
function TCLAchUserList.ProgressByID(ID: integer): integer;
var
  AU: TCLAchUser;
begin
  AU := AchUserByID[ID];
  if AU = nil then result := 0
  else result := AU.Progress;
end;
//================================================================================
function TCLAchUserList.SwapButtonState(ButtonType: TAchButtonType; ID: integer): Boolean;
var
  index: integer;
begin
  if ButtonType = abtGroup then begin
    index := AchList.GroupList.IndexByID(ID);
    result := Swap01String(index + 1, stGroup);
  end else begin
    index := AchList.AchIndexByID(ID);
    result := Swap01String(index + 1, stAch);
  end;
end;
//================================================================================
{ TCLAchButtonList }

function TCLAchButtonList.ButtonByXY(X, Y: integer): TCLAchButton;
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := Self[i];
    if PointInRect(result.R, X, Y) then exit;
  end;
  result := nil;
end;
//================================================================================
function TCLAchButtonList.GetAchButton(Index: integer): TCLAchButton;
begin
  result := TCLAchButton(Items[Index]);
end;
//================================================================================
function TCLAchGroups.IndexByID(ID: integer): integer;
var
  i: integer;
begin
  for i := 0 to Count-1 do begin
    result := i;
    if Group[i].ID = ID then exit;
  end;
  result := -1;
end;
//================================================================================
{ TCLAchUserInfo }

function TCLAchUserInfo.ScreenText: string;
var
  n: integer;
begin
  n := pos('%timeago%',Text);
  if n = 0 then result := Text
  else result := copy(Text, 1, n-1) + GetTimeAgo(Date) + copy(Text, n+9, length(Text));
end;
//================================================================================
end.

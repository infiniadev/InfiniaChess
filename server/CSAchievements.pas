unit CSAchievements;

interface

uses contnrs, ADOInt, SysUtils, CSConst, Dialogs, classes, CSReglament,
  CSConnection, Variants;

type
  TAchGameResult = (agrLose, agrWin, agrDraw, agrNone);
  TAchOpTitle = (aotNone, aotMaster, aotGM);
  TAchType = (achGame, achTournament, achNonPlaying);
  TAchUserStatus = (ausDisabled, ausNotStarted, ausInProgress, ausFinished);

  TAchFactInfo = class
    LoginID: integer;
    Login: string;
    DT: TDateTime;
  end;

  TAchGameInfo = class(TAchFactInfo)
  public
    RatedType: TRatedType;
    AchGameResult: TAchGameResult;
    OpID: integer;
    OpLogin: string;
    OpTitle: TAchOpTitle;
    RDiff: integer;
    EventType: integer;
    TimeOdds: Boolean;
    procedure SetGameResult(IsWhite: Boolean; GR: integer; p_RatedType: TRatedType);
    procedure SetOpTitle(Title: string);
  end;

  TAchTournamentInfo = class(TAchFactInfo)
  public
    TournamentType: TCSTournamentType;
    RatedType: TRatedType;
    RankMin: integer;
    RankMax: integer;
    PlayersCount: integer;
  end;

  TAchGroup = class
  public
    ID: integer;
    Name: string;
  end;

  TAchGroups = class(TObjectList)
  private
    function GetGroup(Index: integer): TAchGroup;
    function GetGroupByID(ID: integer): TAchGroup;
  public
    property Group[Index: integer]: TAchGroup read GetGroup; default;
    property GroupByID[ID: integer]: TAchGroup read GetGroupByID;
  end;

  TAchievement = class
  private
    FRatedTypesCount: integer;
    FRatedTypes: string;
    function MatchRatedType(RT: TRatedType): Boolean;
    function MatchResult(AchRes: TAchGameResult): Boolean;
    function MatchTitle(AchTitle: TAchOpTitle): Boolean;
    function MatchRDiff(RDiff: integer): Boolean;
    function MatchEventType(EventType: integer): Boolean;
    function MatchTimeOdds(p_TimeOdds: Boolean): Boolean;
    function MatchTournamentResult(RankMin, RankMax: integer): Boolean;
    function MatchPlayersCount(PlayersCount: integer): Boolean;
    function MatchTournamentType(TourType: TCSTournamentType): Boolean;
    function GetMaxCountToSend: integer;
    procedure SetRatedTypes(const Value: string);
  public
    ID: integer;
    Name: string;
    Description: string;
    GroupID: integer;
    Score: integer;
    AchType: TAchType;
    MaxCount: integer;
    TimeRange: integer;
    GameResults: string;
    OpTitles: string;
    OpRDiffMin: integer;
    OpRDiffMax: integer;
    OpRDiffRequired: Boolean;
    RatedTypeSep: Boolean;
    OpDiff: Boolean;
    EventTypes: string;
    TimeOdds: Boolean;
    TournamentPlayers: integer;

    ClusterID: integer;
    ClusterOrderNum: integer;

    function Match(FI: TAchFactInfo): Boolean;
    function UserInfoNeeded: Boolean;
    function FromSameCluster(p_Ach: TAchievement): Boolean;

    property RatedTypes: string read FRatedTypes write SetRatedTypes;
    property RatedTypesCount: integer read FRatedTypesCount;
    property MaxCountToSend: integer read GetMaxCountToSend;
  end;

  TAchievements = class
  private
    GroupList: TAchGroups;
    AchList: TObjectList;
    function GetAch(Index: integer): TAchievement;
    function GetAchByID(ID: integer): TAchievement;
    procedure OnAchGameEvent(Sender: TObject);
    procedure OnAchTournamentEvent(Sender: TObject);
    procedure DefineClusters;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure ReadFromDB;
    procedure Send(Connection: TConnection);
    procedure OnAchEvent(Sender: TObject);
    function AchListByCluster(p_ClusterID, p_ClusterOrderNum: integer): string;
    procedure CMD_ReadAchievements(Connection: TConnection; CMD: TStrings);

    property Ach[Index: integer]: TAchievement read GetAch; default;
    property AchByID[ID: integer]: TAchievement read GetAchByID;
  end;

  TAchUserInfo = class
  private
    FDbID: integer;
    FDT: TDateTime;
    FOpID: integer;
    FOpLogin: string;
    FRatedType: integer;
    FCnt: integer;
    procedure DbUpdate;
  public
    constructor CreateFromDB(p_DbID: integer; p_DT: TDateTime; p_OpID,p_RatedType,p_Cnt: integer; p_OpLogin: string); virtual;
    constructor CreateNew(p_LoginID, p_AchID: integer; p_DT: TDateTime; p_OpID,p_RatedType,p_Cnt: integer; p_OpLogin: string); virtual;

    function AlreadyCountedOne(Ach: TAchievement; FI: TAchFactInfo): Boolean;
    procedure DeleteFromDB;
    procedure IncCnt;

    property DbID: integer read FDbID;
    property DT: TDateTime read FDT;
    property OpID: integer read FOpID;
    property RatedType: integer read FRatedType;
    property Cnt: integer read FCnt;
    property OpLogin: string read FOpLogin;
  end;

  TAchUserInfoList = class(TObjectList)
  private
    function GetAchUserInfo(Index: integer): TAchUserInfo;
    procedure DeleteByTime(DT: TDateTime);
    procedure GetMinMaxDate(var pp_minDate, pp_maxDate: TDateTime);
  public
    function AlreadyCounted(Ach: TAchievement; FI: TAchFactInfo): Boolean;
    function CountAch(Ach: TAchievement; FI: TAchFactInfo): Boolean;
    function UserInfoByRatedType(RatedType: integer): TAchUserInfo;
    procedure Send(Connection: TConnection; Login: string; Ach: TAchievement);
    function RatedTypeCount(p_RatedType: integer): integer;
    function OpponentListSorted: string;
    procedure ClearFromDB;

    property UserInfo[Index: integer]: TAchUserInfo read GetAchUserInfo; default;
  end;

  TAchUser = class
  private
    FDbID: integer;
    FStatus: TAchUserStatus;
    FAchID: integer;
    FProgress: integer;
    FAchieveDate: TDateTime;
  public
    InfoList: TAchUserInfoList;

    constructor Create; virtual;
    constructor CreateFromDB(p_DbID: integer; p_AchID: integer; p_Status: TAchUserStatus;
      p_Progress: integer; p_AchieveDate: TDateTime); virtual;
    constructor CreateNew(p_LoginID, p_AchID: integer; p_Status: TAchUserStatus;
      p_Progress: integer; p_AchieveDate: TDateTime); virtual;
    destructor Destroy; override;

    procedure IncProgress;
    procedure SetProgress(p_Progress: integer);

    property DbID: integer read FDbID;
    property Status: TAchUserStatus read FStatus;
    property AchID: integer read FAchID;
    property Progress: integer read FProgress;
    property AchieveDate: TDateTime read FAchieveDate;
  end;

  TAchUserList = class(TObjectList)
  private
    //FConnection: TObject;
    FLogin: string;
    FClustersSent: string;

    function GetAchUser(Index: integer): TAchUser;
    function GetAchUserByID(ID: integer): TAchUser;
    function AchMustBeCounted(Ach: TAchievement; FI: TAchFactInfo): Boolean;
    function IsClusterSent(ClusterID: integer): Boolean;
  public
    procedure SendByList(Connection: TConnection; p_List: string);
    function CheckEvent(Ach: TAchievement; FI: TAchFactInfo): Boolean;
    procedure CountAch(Ach: TAchievement; FI: TAchFactInfo);
    function ReadFromDB(Login: string): Boolean;

    procedure ClearClustersSent;

    property AchUser[Index: integer]: TAchUser read GetAchUser; default;
    property AchUserByID[ID: integer]: TAchUser read GetAchUserByID;
    property Login: string read FLogin;
  end;

  TAchUserLibrary = class
  private
    List: TObjectList;
    function GetAchUserListIndex(p_Login: string): integer;
    function GetAchUserList(p_Login: string): TAchUserList; overload;
    procedure FreeAchUserList(p_Login: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure OnNewConnection(Connection: TConnection);
    procedure OnFreeConnection(Connection: TConnection);
    procedure CMD_ProfileAch(Connection: TConnection; var CMD: TStrings);
    procedure ProcessFactInfo(FI: TAchFactInfo);
  end;

var
  fAchievements: TAchievements;
  fAchUserLibrary: TAchUserLibrary;

implementation

uses CSDb, CSSocket, CSLib, CSGame, CSEvent, CSEvents, CSTournament, CSConnections;
//===================================================================================
{ TAchGroups }

function TAchGroups.GetGroup(Index: integer): TAchGroup;
begin
  result := TAchGroup(Items[Index]);
end;
//===================================================================================
function TAchGroups.GetGroupByID(ID: integer): TAchGroup;
var
  i: integer;
begin
  for i := 0 to Count-1 do begin
    result := Group[i];
    if result.ID = ID then exit;
  end;
  result := nil;
end;
//===================================================================================
{ TAchievements }

function TAchievements.AchListByCluster(p_ClusterID, p_ClusterOrderNum: integer): string;
var
  i: integer;
  vAch: TAchievement;
begin
  result := '';
  for i := 0 to AchList.Count - 1 do begin
    vAch := Ach[i];
    if (vAch.ClusterID = p_ClusterID) and (vAch.ClusterOrderNum >= p_ClusterOrderNum) then
      result := result + IntToStr(vAch.ID) + ',';
  end;
end;
//===================================================================================
procedure TAchievements.CMD_ReadAchievements(Connection: TConnection; CMD: TStrings);
begin
  try
    ReadFromDB;
    fSocket.Send(TConnection(Connection),[DP_SERVER_MSG, DP_ERR_0, 'Achievements are read successfully']);
  except on E:Exception do
    fSocket.Send(TConnection(Connection),[DP_SERVER_MSG, DP_ERR_2, 'Error: ' + E.Message]);
  end;
end;
//===================================================================================
constructor TAchievements.Create;
begin
  GroupList := TAchGroups.Create;
  AchList := TObjectList.Create;
  ReadFromDB;
end;
//===================================================================================
procedure TAchievements.DefineClusters;
var
  i, j, vID, vOrder: integer;
  vAch1, vAch2: TAchievement;
begin
  vID := 0;

  for i := 0 to AchList.Count - 1 do begin
    vAch1 := Ach[i];
    if vAch1.ClusterID = 0 then begin
      inc(vID); vOrder := 1;
      vAch1.ClusterID := vID;
      vAch1.ClusterOrderNum := 0;
      for j := i + 1 to AchList.Count - 1 do begin
        vAch2 := Ach[j];
        if vAch1.FromSameCluster(vAch2) then begin
          vAch2.ClusterID := vID;
          vAch2.ClusterOrderNum := vOrder;
          inc(vOrder);
        end;
      end;
    end;
  end;
end;
//===================================================================================
destructor TAchievements.Destroy;
begin
  inherited;
  GroupList.Free;
  AchList.Free;
end;
//===================================================================================
function TAchievements.GetAch(Index: integer): TAchievement;
begin
  result := TAchievement(AchList[Index]);
end;
//===================================================================================
function TAchievements.GetAchByID(ID: integer): TAchievement;
var
  i: integer;
begin
  for i := 0 to AchList.Count - 1 do begin
    result := Ach[i];
    if result.ID = ID then exit;
  end;
  result := nil;
end;
//===================================================================================
procedure TAchievements.OnAchEvent(Sender: TObject);
begin
  if Sender is TGame then OnAchGameEvent(Sender)
  else if Sender is TCSTournament then OnAchTournamentEvent(Sender); 
end;
//===================================================================================
procedure TAchievements.OnAchGameEvent(Sender: TObject);
var
  GM: TGame;
  GI: TAchGameInfo;
  ev: TCSEvent;
begin
  GM := Sender as TGame;
  if (GM.White = GM.Black) or not GM.Rated or (GM.GameResult in [grAborted, grAdjourned])
    or GM.White.Provisional[GM.RatedType]
    or GM.Black.Provisional[GM.RatedType]
  then
    exit;

  GI := TAchGameInfo.Create;
  GI.DT := Date + Time;
  GI.RatedType := GM.RatedType;
  GI.TimeOdds := GM.Odds.FAutoTimeOdds;

  if GM.EventID = 0 then GI.EventType := -1
  else begin
    ev := fEvents.FindEvent(GM.EventID);
    GI.EventType := ord(ev.Type_);
  end;

  if Assigned(GM.White) and GM.White.Rights.Achievements
    and (GM.White.MembershipType > mmbNone)
  then begin
    GI.LoginID := GM.WhiteId;
    GI.Login := GM.WhiteLogin;
    GI.SetGameResult(true, ord(GM.GameResult), GM.RatedType);
    GI.OpID := GM.Black.LoginID;
    GI.OpLogin := GM.BlackLogin;
    GI.SetOpTitle(GM.Black.Title);
    GI.RDiff := GM.BlackRating - GM.WhiteRating;
    fAchUserLibrary.ProcessFactInfo(GI);
  end;

  if Assigned(GM.Black) and GM.Black.Rights.Achievements
    and (GM.Black.MembershipType > mmbNone)
  then begin
    GI.LoginID := GM.BlackID;
    GI.Login := GM.BlackLogin;
    GI.SetGameResult(false, ord(GM.GameResult), GM.RatedType);
    GI.OpID := GM.White.LoginID;
    GI.OpLogin := GM.WhiteLogin;
    GI.SetOpTitle(GM.White.Title);
    GI.RDiff := GM.WhiteRating - GM.BlackRating;
    fAchUserLibrary.ProcessFactInfo(GI);
  end;
end;
//===================================================================================
procedure TAchievements.OnAchTournamentEvent(Sender: TObject);
var
  Tour: TCSTournament;
  TI: TAchTournamentInfo;
  user: TCSUser;
  conn: TConnection;
  i: integer;
begin
  Tour := TCSTournament(Sender);
  TI := TAchTournamentInfo.Create;

  TI.TournamentType := Tour.Reglament.TourType;
  TI.DT := Tour.StartTime;
  TI.RatedType := TimeToRatedType(Tour.Reglament.InitTime, Tour.Reglament.IncTime);
  TI.PlayersCount := Tour.Reglament.MemberList.Count;

  for i := 0 to Tour.Reglament.MemberList.Count - 1 do begin
    user := Tour.Reglament.MemberList[i];
    conn := fConnections.GetConnection(user.Login);
    if (conn = nil) or not TConnection(conn).Rights.Achievements
      or (conn.MembershipType = mmbNone)
    then
      continue;

    TI.LoginID := conn.LoginID;
    TI.Login := conn.Handle;
    TI.RankMin := user.RankMin;
    TI.RankMax := user.RankMax;
    fAchUserLibrary.ProcessFactInfo(TI);
  end;

  TI.Free;
end;
//===================================================================================
procedure TAchievements.ReadFromDB;
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
  Group: TAchGroup;
  Ach: TAchievement;
begin
  fDB.OpenRecordSet('dbo.proc_GetAchievements', [], Rst);

  if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then exit;
  while not Rst.EOF do begin
    Group := TAchGroup.Create;
    Group.ID := Rst.Fields[0].Value;
    Group.Name := Rst.Fields[1].Value;
    GroupList.Add(Group);
    Rst.MoveNext;
  end;

  Rst := Rst.NextRecordset(RecsAffected);
  if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then exit;
  while not Rst.EOF do begin
    Ach := TAchievement.Create;
    Ach.ID := Rst.Fields[0].Value;
    Ach.Name := Rst.Fields[1].Value;
    Ach.Description := Rst.Fields[2].Value;
    Ach.AchType := TAchType(Rst.Fields[3].Value);
    Ach.GroupID := Rst.Fields[4].Value;
    Ach.Score := Rst.Fields[6].Value;
    Ach.MaxCount := Rst.Fields[7].Value;
    Ach.TimeRange := Rst.Fields[8].Value;
    Ach.RatedTypes := Rst.Fields[9].Value;
    Ach.GameResults := Rst.Fields[10].Value;
    Ach.OpTitles := Rst.Fields[11].Value;
    Ach.OpRDiffRequired := Rst.Fields[12].Value;
    Ach.OpRDiffMin := Rst.Fields[13].Value;
    Ach.OpRDiffMax := Rst.Fields[14].Value;
    Ach.RatedTypeSep := Rst.Fields[15].Value;
    Ach.OpDiff := Rst.Fields[16].Value;
    Ach.EventTypes := Rst.Fields[17].Value;
    Ach.TimeOdds := Rst.Fields[18].Value;
    Ach.TournamentPlayers := Rst.Fields[19].Value;
    AchList.Add(Ach);
    Rst.MoveNext;
  end;

  Rst := nil;

  DefineClusters;
end;
//===================================================================================
procedure TAchievements.Send(Connection: TConnection);
var
  i: integer;
  group: TAchGroup;
  vAch: TAchievement;
  AU: TAchUser;
begin
  if not Connection.Rights.Achievements then exit;

  fSocket.Send(Connection, [DP_ACH_CLEAR]);

  for i := 0 to GroupList.Count - 1 do begin
    group := GroupList[i];
    fSocket.Send(Connection, [DP_ACH_GROUP,
      IntToStr(group.ID),
      group.Name]);
  end;

  for i := 0 to AchList.Count - 1 do begin
    vAch := Ach[i];
    fSocket.Send(Connection, [DP_ACHIEVEMENT,
      IntToStr(vAch.ID),
      vAch.Name,
      vAch.Description,
      IntToStr(vAch.GroupID),
      IntToStr(vAch.MaxCount),
      IntToStr(vAch.MaxCountToSend),
      IntToStr(vAch.Score),
      IntToStr(vAch.ClusterID),
      IntToStr(vAch.ClusterOrderNum)
    ]);
  end;
end;
//===================================================================================
{ TAchUserInfoList }

procedure TAchUserInfoList.DeleteByTime(DT: TDateTime);
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    if UserInfo[i].DT < DT then begin
      UserInfo[i].DeleteFromDB;
      Delete(i);
    end;
end;
//===================================================================================
function TAchUserInfoList.GetAchUserInfo(Index: integer): TAchUserInfo;
begin
  result := TAchUserInfo(Items[Index]);
end;
//===================================================================================
function TAchUserInfoList.AlreadyCounted(Ach: TAchievement; FI: TAchFactInfo): Boolean;
var
  i, n: integer;
  AUI: TAchUserInfo;
  GI: TAchGameInfo;
begin
  if FI is TAchGameInfo then begin
    result := true;
    GI := TAchGameInfo(FI);
    n := 0;
    for i := 0 to Count - 1 do begin
      AUI := Self[i];
      if Ach.OpDiff and (AUI.OpID = GI.OpID) then exit;
      if Ach.RatedTypeSep and (AUI.RatedType = ord(GI.RatedType)) then
        inc(n);
    end;
    if Ach.RatedTypeSep and (n >= Ach.MaxCount) then exit;

    result := false;
  end else if FI is TAchTournamentInfo then
    result := false;
end;
//===================================================================================
function TAchUserInfoList.CountAch(Ach: TAchievement; FI: TAchFactInfo): Boolean;
var
  vDT: TDateTime;
  vOpID, vRatedType, vCnt: integer;
  GI: TAchGameInfo;
  AUI: TAchUserInfo;
begin
  result := false;
  if not Ach.UserInfoNeeded then exit;

  if FI is TAchGameInfo then begin
    GI := TAchGameInfo(FI);

    if Ach.TimeRange > 0 then vDT := Date + Time
    else vDT := 0;

    if Ach.OpDiff then vOpID := GI.OpID
    else vOpID := 0;

    if Ach.RatedTypeSep then vRatedType := ord(GI.RatedType)
    else vRatedType := -1;

    AUI := TAchUserInfo.CreateNew(GI.LoginID, Ach.ID, vDT, vOpID, vRatedType, 1, GI.OpLogin);
    Add(AUI);
    result := true;
  end;
end;
//===================================================================================
function TAchUserInfoList.UserInfoByRatedType(RatedType: integer): TAchUserInfo;
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := UserInfo[i];
    if result.RatedType = RatedType then exit;
  end;
  result := nil;
end;
//===================================================================================
procedure TAchUserInfoList.Send(Connection: TConnection; Login: string; Ach: TAchievement);
var
  vAchString, s, s1: string;
  minDate, maxDate: TDateTime;
  i, cnt, vRatedType: integer;
  AUI: TAchUserInfo;
  SL: TStringList;
begin
  if not Ach.UserInfoNeeded then exit;


  if ACH_SEND_BY_CLUSTERS then vAchString := fAchievements.AchListByCluster(Ach.CLusterID, Ach.ClusterOrderNum)
  else vAchString := IntToStr(Ach.ID);

  fSocket.Send(Connection, [DP_ACH_USER_INFO_CLEAR, Login, vAchString]);

  //-------------- TIME RANGE INFO --------------------
  if (Ach.TimeRange > 0) and (Count > 0) then begin
    GetMinMaxDate(minDate, maxDate);
    if Count = 1 then s := '1 game played %timeago% ago'
    else s := IntToStr(Count) + ' games, first of them was played %timeago% ago';
    fSocket.Send(Connection, [DP_ACH_USER_INFO, Login, vAchString, s, '0', '-1', '-1', FloatToStr(minDate)]);
  end;

  //-------------- DIFFERENT OPPONENTS INFO --------------------
  if Ach.OpDiff then begin
    s1 := OpponentListSorted;
    if s1 <> '' then begin
      s := 'Opponents: ' + s1;
      fSocket.Send(Connection, [DP_ACH_USER_INFO, Login, vAchString, s, '0', '-1', '-1', '0']);
    end;
  end;

  //-------------- DIFFERENT RATED TYPES INFO --------------------
  if Ach.RatedTypeSep then begin
    SL := TStringList.Create;
    Str2StringList(Ach.RatedTypes,SL);
    for i := 0 to SL.Count - 1 do begin
      vRatedType := StrToInt(SL[i]);
      cnt := RatedTypeCount(vRatedType);
      s := RatedType2Str(TRatedType(vRatedType));
      fSocket.Send(Connection, [DP_ACH_USER_INFO, Login, vAchString, s,
        BoolTo_(cnt >= Ach.MaxCount, '1', '0'),
        IntToStr(cnt), '-1', '0']);
    end;
    SL.Free;
  end;
end;
//===================================================================================
procedure TAchUserInfoList.GetMinMaxDate(var pp_minDate, pp_maxDate: TDateTime);
var
  i: integer;
  AUI: TAchUserInfo;
begin
  pp_MinDate := Now;
  pp_MaxDate := 0;
  for i := 0 to Count - 1 do begin
    AUI := Self[i];
    if AUI.FDT < pp_MinDate then pp_MinDate := AUI.FDT;
    if AUI.FDT > pp_MaxDate then pp_MaxDate := AUI.FDT;
  end;
end;
//===================================================================================
function TAchUserInfoList.RatedTypeCount(p_RatedType: integer): integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to Count - 1 do
    if Self[i].RatedType = p_RatedType then
      inc(result);
end;
//===================================================================================
function TAchUserInfoList.OpponentListSorted: string;
var
  i: integer;
  sl: TStringList;
begin
  sl := TStringList.Create;
  for i := 0 to Count - 1 do begin
    if Self[i].OpLogin <> '' then
      sl.Add(Self[i].OpLogin);
  end;
  sl.Sort;

  result := '';
  for i := 0 to sl.Count - 1 do begin
    result := result + sl[i];
    if i < sl.Count - 1 then
      result := result + ', ';
  end;
  sl.Free;
end;
//===================================================================================
procedure TAchUserInfoList.ClearFromDB;
var
  i: integer;
begin
  for i := 0 to Count - 1 do
    Self[i].DeleteFromDB;
end;
//===================================================================================
{ TAchUser }

constructor TAchUser.Create;
begin
  InfoList := TAchUserInfoList.Create;
end;
//===================================================================================
constructor TAchUser.CreateFromDB(p_DbID: integer; p_AchID: integer; p_Status: TAchUserStatus;
  p_Progress: integer; p_AchieveDate: TDateTime);
begin
  Create;
  FDbID := p_DbID;
  FAchID := p_AchID;
  FStatus := p_Status;
  FProgress := p_Progress;
  FAchieveDate := p_AchieveDate;
end;
//===================================================================================
constructor TAchUser.CreateNew(p_LoginID, p_AchID: integer; p_Status: TAchUserStatus;
  p_Progress: integer; p_AchieveDate: TDateTime);
begin
  Create;
  FAchID := p_AchID;
  FStatus := p_Status;
  FProgress := p_Progress;
  FAchieveDate := p_AchieveDate;
  FDbID := fDB.ExecProc('dbo.proc_AddAchUser',
    [p_LoginID, p_AchID, ord(p_Status), p_Progress, p_AchieveDate]);
end;
//===================================================================================
destructor TAchUser.Destroy;
begin
  InfoList.Free;
end;
//===================================================================================
procedure TAchUser.IncProgress;
begin
  SetProgress(Progress + 1);
end;
//===================================================================================
procedure TAchUser.SetProgress(p_Progress: integer);
var
  vMaxCount: integer;
  vAchieveDate: Variant;
begin
  if (Status in [ausDisabled, ausFinished]) or (Progress = p_Progress) then exit;

  vMaxCount := fAchievements.AchByID[AchID].MaxCountToSend;
  FProgress := MinValue(p_Progress, vMaxCount);

  if FProgress = vMaxCount then begin
    FStatus := ausFinished;
    FAchieveDate := Date + Time;
    vAchieveDate := AchieveDate;
  end else begin
    if Status = ausNotStarted then FStatus := ausInProgress;
    FAchieveDate := 0;
    vAchieveDate := null;
  end;


  fDB.ExecProc('dbo.proc_AchUserUpdateProgress',
    [DbID, FStatus, FProgress, vAchieveDate]);
end;
//===================================================================================
{ TAchUserList }

function TAchUserList.AchMustBeCounted(Ach: TAchievement; FI: TAchFactInfo): Boolean;
var
  AU: TAchUser;
begin
  if not Ach.Match(FI) then begin
    result := false;
    exit;
  end;

  AU := AchUserByID[Ach.ID];
  if AU = nil then begin
    result := true;
    exit;
  end;

  if AU.Status in [ausDisabled,ausFinished] then begin
    result := false;
    exit;
  end;

  if Ach.TimeRange > 0 then begin
    AU.InfoList.DeleteByTime(Date + Time - Ach.TimeRange/24.0);
    AU.SetProgress(AU.InfoList.Count);
  end;

  result := not AU.InfoList.AlreadyCounted(Ach, FI);
end;
//===================================================================================
function TAchUserList.CheckEvent(Ach: TAchievement; FI: TAchFactInfo): Boolean;
begin
  result := AchMustBeCounted(Ach, FI);
  if result then
    CountAch(Ach, FI);
end;
//===================================================================================
procedure TAchUserList.ClearClustersSent;
begin
  FClustersSent := '';
end;
//===================================================================================
procedure TAchUserList.CountAch(Ach: TAchievement; FI: TAchFactInfo);
var
  AU: TAchUser;
  conn: TConnection;
  vAchieveDate: TDateTime;
  vOldStatus, vStatus: TAchUserStatus;
begin
  conn := fConnections.GetConnection(FLogin);
  if conn = nil then exit;
  
  AU := AchUserByID[Ach.ID];

  if AU = nil then vOldStatus := ausNotStarted
  else vOldStatus := AU.Status;

  if AU = nil then begin
    if Ach.MaxCount = 1 then begin
      vAchieveDate := Date + Time;
      vStatus := ausFinished
    end else begin
      vAchieveDate := 0;
      vStatus := ausInProgress;
    end;

    AU := TAchUser.CreateNew(
      FI.LoginID,
      Ach.ID,
      vStatus,
      1,
      vAchieveDate);

    Self.Add(AU);
  end else
    AU.IncProgress;

  AU.InfoList.CountAch(Ach, FI);

  {if (vOldStatus <> ausFinished) and (AU.Status = ausFinished) then
    fSocket.Send(conn, [DP_ACH_FINISHED, IntToStr(Ach.ID)]);}
end;
//===================================================================================
function TAchUserList.GetAchUser(Index: integer): TAchUser;
begin
  result := TAchUser(Items[Index]);
end;
//===================================================================================
function TAchUserList.GetAchUserByID(ID: integer): TAchUser;
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := AchUser[i];
    if result.AchID = ID then exit;
  end;
  result := nil;
end;
//===================================================================================
function TAchUserList.IsClusterSent(ClusterID: integer): Boolean;
begin
  result := pos(','+IntToStr(ClusterID)+',', ','+FClustersSent+',') > 0;
end;
//===================================================================================
function TAchUserList.ReadFromDB(Login: string):  Boolean;
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
  vAchUser: TAchUser;
  vInfo: TAchUserInfo;
  AchID, res, LoginID: integer;
begin
  Self.Clear;

  result := false;
  FLogin := Login;
  LoginID := fDB.GetLoginID(Login);
  fDB.ExecProc('dbo.proc_AchUserDeleteByTime',[LoginID]);

  res := fDB.OpenRecordSet('dbo.proc_GetAchUserData', [Login], Rst);
  if res = -1 then exit;

  if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then exit;
  while not Rst.EOF do begin
    vAchUser := TAchUser.CreateFromDB(
      Rst.Fields[0].Value,
      Rst.Fields[1].Value,
      TAchUserStatus(Rst.Fields[2].Value),
      Rst.Fields[3].Value,
      nvl(Rst.Fields[4].Value,0));
    Add(vAchUser);
    Rst.MoveNext;
  end;

  Rst := Rst.NextRecordset(RecsAffected);
  if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then exit;
  while not Rst.EOF do begin
    AchID := Rst.Fields[0].Value;
    vAchUser := AchUserByID[AchID];
    if vAchUser <> nil then begin
      vInfo := TAchUserInfo.CreateFromDB(
        Rst.Fields[1].Value,
        nvl(Rst.Fields[2].Value,0),
        nvl(Rst.Fields[3].Value,0),
        nvl(Rst.Fields[4].Value,-1),
        nvl(Rst.Fields[5].Value,0),
        nvl(Rst.Fields[6].Value,''));

      vAchUser.InfoList.Add(vInfo);
    end;
    Rst.MoveNext;
  end;
  result := true;
  Rst := nil;
end;
//===================================================================================
procedure TAchUserList.SendByList(Connection: TConnection; p_List: string);
var
  i: integer;
  AU: TAchUser;
  vAch: TAchievement;
begin
  if not Connection.Rights.Achievements then exit;

  if ACH_SEND_BY_CLUSTERS then FClustersSent := '';

  for i := 0 to Count - 1 do begin
    AU := Self[i];
    if (p_List = '') or InCommaString(p_List, AU.AchID) then begin
      fSocket.Send(Connection, [DP_ACH_USER, Self.FLogin, IntToStr(AU.AchID),
        IntToStr(ord(AU.Status)), IntToStr(AU.Progress), FloatToStr(AU.AchieveDate)]);

      if (AU.Status = ausFinished) and (p_List <> '') then
        fSocket.Send(Connection, [DP_ACH_FINISHED, IntToStr(AU.AchID)]);
    end;
  end;

  for i := 0 to Count - 1 do begin
    AU := Self[i];
    vAch := fAchievements.AchByID[AU.AchID];
    if vAch.UserInfoNeeded and (AU.Status <> ausFinished)
      and ((p_List = '') or InCommaString(p_List, AU.AchID))
      and (not ACH_SEND_BY_CLUSTERS or not IsClusterSent(vAch.ClusterID))
    then begin
      AU.InfoList.Send(Connection, FLogin, vAch);

      if ACH_SEND_BY_CLUSTERS then
        FClustersSent := FClustersSent + IntToStr(vAch.ClusterID) + ',';
    end;
  end;

  fSocket.Send(TConnection(Connection),[DP_ACH_SEND_END, FLogin]);
end;
//===================================================================================
{ TAchGameInfo }

procedure TAchGameInfo.SetGameResult(IsWhite: Boolean; GR: integer; p_RatedType: TRatedType);
var
  score: TGameScore;
begin
  score := CSGame.GameScoreByResult(TGameResult(GR));

  if (score = gsWhiteWin) and IsWhite or (score = gsBlackWin) and not IsWhite then
    AchGameResult := agrWin
  else if (score = gsWhiteWin) and not IsWhite or (score = gsBlackWin) and IsWhite then
    AchGameResult := agrLose
  else if score = gsDraw then
    AchGameResult := agrDraw
  else
    AchGameResult := agrNone;

  if p_RatedType = rtLoser then
    if AchGameResult = agrWin then AchGameResult := agrLose
    else if AchGameResult = agrLose then AchGameResult := agrWin;
end;
//===================================================================================
procedure TAchGameInfo.SetOpTitle(Title: string);
begin
  if IsMasterOnlyTitle(Title) then
    OpTitle := aotMaster
  else if IsGMOnlyTitle(Title) then
    OpTitle := aotGM
  else
    OpTitle := aotNone;
end;
//===================================================================================
{ TAchievement }

function TAchievement.FromSameCluster(p_Ach: TAchievement): Boolean;
begin
  result := (GroupID = p_Ach.GroupID)
    and (AchType = p_Ach.AchType)
    and (TimeRange = p_Ach.TimeRange)
    and (RatedTypes = p_Ach.RatedTypes)
    and (GameResults = p_Ach.GameResults)
    and (OpTitles = p_Ach.OpTitles)
    and (OpRDiffMin = p_Ach.OpRDiffMin)
    and (OpRDiffMax = p_Ach.OpRDiffMax)
    and (OpRDiffRequired = p_Ach.OpRDiffRequired)
    and (RatedTypeSep = p_Ach.RatedTypeSep)
    and (OpDiff = p_Ach.OpDiff)
    and (EventTypes = p_Ach.EventTypes);
end;
//===================================================================================
function TAchievement.GetMaxCountToSend: integer;
begin
  if RatedTypeSep then result := RatedTypesCount * MaxCount
  else result := MaxCount;
end;
//===================================================================================
function TAchievement.Match(FI: TAchFactInfo): Boolean;
var
  GI: TAchGameInfo;
  TI: TAchTournamentInfo;
begin
  if FI is TAchGameInfo then begin
    GI := TAchGameInfo(FI);
    result := (AchType = achGame)
      and MatchRatedType(GI.RatedType)
      and MatchResult(GI.AchGameResult)
      and MatchTitle(GI.OpTitle)
      and MatchRDiff(GI.RDiff)
      and MatchEventType(GI.EventType)
      and MatchTimeOdds(GI.TimeOdds)
  end else if AchType = achTournament then begin
    TI := TAchTournamentInfo(FI);
    result := (AchType = achTournament)
      and MatchRatedType(TI.RatedType)
      and MatchTournamentResult(TI.RankMin, TI.RankMax)
      and MatchPlayersCount(TI.PlayersCount);
  end else
    result := false;
end;
//===================================================================================
function TAchievement.MatchEventType(EventType: integer): Boolean;
begin
  result := (EventTypes = '') or InCommaString(Eventtypes, EventType);
end;
//===================================================================================
function TAchievement.MatchPlayersCount(PlayersCount: integer): Boolean;
begin
  result := PlayersCount >= TournamentPlayers; 
end;
//===================================================================================
function TAchievement.MatchRatedType(RT: TRatedType): Boolean;
begin
  result := (RatedTypes = '') or InCommaString(RatedTypes, ord(RT));
end;
//===================================================================================
function TAchievement.MatchRDiff(RDiff: integer): Boolean;
begin
  result := not OpRDiffRequired or (RDiff >= OpRDiffMin) and (RDiff <= OpRDiffMax);
end;
//===================================================================================
function TAchievement.MatchResult(AchRes: TAchGameResult): Boolean;
begin
  result := (GameResults = '') or InCommaString(GameResults, ord(AchRes));
end;
//===================================================================================
function TAchievement.MatchTimeOdds(p_TimeOdds: Boolean): Boolean;
begin
  result := not TimeOdds or p_TimeOdds;
end;
//===================================================================================
function TAchievement.MatchTitle(AchTitle: TAchOpTitle): Boolean;
begin
  result := (OpTitles = '') or InCommaString(OpTitles, ord(AchTitle));
end;
//===================================================================================
function TAchievement.MatchTournamentResult(RankMin, RankMax: integer): Boolean;
begin
  result := (GameResults = '') or (GameResults = '1') and (RankMin = 1) and (RankMax = 1);
end;
//===================================================================================
function TAchievement.MatchTournamentType(
  TourType: TCSTournamentType): Boolean;
begin
  result := true;
end;
//===================================================================================
procedure TAchievement.SetRatedTypes(const Value: string);
var
  i, n: integer;
begin
  FRatedTypes := Value;
  if Value = '' then FRatedTypesCount := 0
  else begin
    n := 0;
    for i := 1 to length(Value)-1 do
      if Value[i] = ',' then inc(n);

    FRatedTypesCount := n + 1;
  end;
end;
//===================================================================================
function TAchievement.UserInfoNeeded: Boolean;
begin
  result := RatedTypeSep or OpDiff or (TimeRange > 0);
end;
//===================================================================================
{ TAchUserInfo }

constructor TAchUserInfo.CreateFromDB(p_DbID: integer; p_DT: TDateTime; p_OpID, p_RatedType, p_Cnt: integer; p_OpLogin: string);
begin
  FDbID := p_DbID;
  FDT := p_DT;
  FOpID := p_OpID;
  FRatedType := p_RatedType;
  FCnt := p_Cnt;
  FOpLogin := p_OpLogin;
end;
//===================================================================================
constructor TAchUserInfo.CreateNew(p_LoginID, p_AchID: integer;
  p_DT: TDateTime; p_OpID, p_RatedType, p_Cnt: integer; p_OpLogin: string);
begin
  FDT := p_DT;
  FOpID := p_OpID;
  FRatedType := p_RatedType;
  FCnt := p_Cnt;
  FOpLogin := p_OpLogin;
  FDbID := fDB.ExecProc('dbo.proc_AddAchUserInfo',
    [p_LoginID, p_AchID, p_DT, p_OpID, p_RatedType, p_Cnt]);
end;
//===================================================================================
function TAchUserInfo.AlreadyCountedOne(Ach: TAchievement; FI: TAchFactInfo): Boolean;
var
  GI: TAchGameInfo;
  b1, b2: Boolean;
begin
  if FI is TAchGameInfo then begin
    GI := TAchGameInfo(FI);
    result := Ach.OpDiff and (OpID = GI.OpID)
      or Ach.RatedTypeSep and (RatedType = ord(GI.RatedType)) and (Cnt >= Ach.MaxCount);
  end;
end;
//===================================================================================
procedure TAchUserInfo.DbUpdate;
begin
  fDB.ExecProc('dbo.proc_UpdateAchUserInfo',[DbID, DT, OpID, RatedType, Cnt]);
end;
//===================================================================================
procedure TAchUserInfo.IncCnt;
begin
  inc(FCnt);
  DbUpdate;
end;
//===================================================================================
procedure TAchUserInfo.DeleteFromDB;
begin
  fDB.ExecProc('dbo.proc_DeleteAchUserInfo',[DbID]);
end;
//===================================================================================
{ TAchUserLibrary }

constructor TAchUserLibrary.Create;
begin
  List := TObjectList.Create;
  List.OwnsObjects := true;
end;
//===================================================================================
destructor TAchUserLibrary.Destroy;
begin
  inherited;
  List.Free;
end;
//===================================================================================
function TAchUserLibrary.GetAchUserListIndex(p_Login: string): integer;
var
  i: integer;
  vLoginLower: string;
begin
  vLoginLower := lowercase(p_Login);
  for i := List.Count - 1 downto 0 do
    if lowercase(TAchUserList(List[i]).Login) = vLoginLower then begin
      result := i;
      exit;
    end;
  result := -1;
end;
//===================================================================================
procedure TAchUserLibrary.FreeAchUserList(p_Login: string);
var
  vIndex: integer;
begin
  vIndex := GetAchUserListIndex(p_Login);
  if vIndex <> -1 then List.Delete(vIndex);
end;
//===================================================================================
function TAchUserLibrary.GetAchUserList(p_Login: string): TAchUserList;
var
  vIndex: integer;
begin
  vIndex := GetAchUserListIndex(p_Login);
  if vIndex <> -1 then
    result := TAchUserList(List[vIndex])
  else begin
    result := TAchUserList.Create;
    result.ReadFromDB(p_Login);
    List.Add(result);
  end;
end;
//===================================================================================
procedure TAchUserLibrary.OnNewConnection(Connection: TConnection);
var
  AUL: TAchUserList;
begin
  AUL := GetAchUserList(Connection.Handle);
  AUL.SendByList(Connection, '');
end;
//===================================================================================
procedure TAchUserLibrary.OnFreeConnection(Connection: TConnection);
begin
  FreeAchUserList(Connection.Handle);
end;
//===================================================================================
procedure TAchUserLibrary.CMD_ProfileAch(Connection: TConnection; var CMD: TStrings);
var
  Login: string;
  AUL: TAchUserList;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login := CMD[1];
  AUL := GetAchUserList(Login);
  AUL.SendByList(Connection, '');

  if fConnections.GetConnection(Login) = nil then
    FreeAchUserList(Login);
end;
//===================================================================================
procedure TAchUserLibrary.ProcessFactInfo(FI: TAchFactInfo);
var
  i: integer;
  conn: TConnection;
  AUL: TAchUserList;
  vCountedList: string;
  vAch: TAchievement;
begin
  conn := fConnections.GetConnection(FI.Login);
  if conn = nil then exit;
  AUL := GetAchUserList(FI.Login);

  vCountedList := '';
  for i := 0 to fAchievements.AchList.Count - 1 do begin
    vAch := fAchievements.Ach[i];
    if AUL.CheckEvent(vAch, FI) then
      vCountedList := vCountedList + IntToStr(vAch.ID) + ',';
  end;

  AUL.SendByList(conn, vCountedList);
end;
//===================================================================================
end.

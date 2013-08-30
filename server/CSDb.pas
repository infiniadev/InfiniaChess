unit CSDb;

interface

uses
  ADOInt, ActiveX, CSConnection, CSGame, CSConst, Dialogs, SysUtils, Classes,
  contnrs, CSEvent, Variants, Windows, Graphics;

type
  TStatType = class
    Name: string;
    Description: string;
    Params: string;
    ParamNames: string;
  end;

  TStatTypes = class(TObjectList);

  TDbConn = class
  private
    FCon: _Connection;
    FCmd: _Command;
    procedure DbLog(p_Line: string);
  public
    constructor Create;
    destructor Destroy; override;

    function ExecSqlProc(const p_ProcName: string; p_Params: array of variant;
      p_OutParNums: array of integer;
      var pp_OutParValues: Variant; // array of variants
      var pp_Rst: _RecordSet): integer;
  end;

  TDB = class(TObject)
  private
    { Private declarations }
    //FRst: _RecordSet;
    FStatTypes: TStatTypes;
    fDBConn: TDbConn;

  public

    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    procedure Init;

    //procedure CloseDatabaseObject;

    function AdjustRating(const Game: TGame;
      var WhiteRating, BlackRating: Integer;
      var WhiteProvisional, BlackProvisional: Boolean): Integer;
    procedure Ban(var Connection: TConnection; var CMD: TStrings);
    function ChangeTitle(const Login, Title: string): Integer;
    function Enable(const Login: string; Enable: Integer): Integer;
    function ExecProc(const ProcName: string; Params: array of variant): integer;
    function ExecProcOutParams(const ProcName: string; Params: array of Variant;
      p_OutParNums: array of integer; var pp_OutParValues: Variant): integer;
    function OpenRecordSet(const ProcName: string; Params: array of variant;
      var Rst: _RecordSet): Variant;

    procedure GetProfile(Login: string; var Result: Integer; var Rst: _Recordset);
    procedure LoadGame(const ID: Integer; var Game: TGame; const DeleteAdjourned: Boolean);
    function LibraryAdd(const LoginID, GameID: Integer): Integer;
    function LibraryRemove(const LoginID, GameID: Integer): Integer;
    procedure UpdateLoginSettings(const Connection: TConnection);
    procedure Logoff(const Connection: TConnection);
    procedure Login(var Connection: TConnection; const Login, Password, MAC: string);
    procedure ReadRoles(var Connection: TConnection);
    procedure LoginErrors(var Connection: TConnection; var CMD: TStrings);
    procedure LoginHistory(var Connection: TConnection; var CMD: TStrings);
    function LoginRegister(const Login, Password, Email, MAC, AuthKey: string;
        CountryId, SexId, Age: integer; Language: string;
        PublicEmail: Boolean; Birthday: TDateTime; ShowBirthday: Boolean): Integer;
    function MessageAdd(const LoginID: Integer;
      const Login, Subject, Body: string): Integer;
    function MessageDelete(const LoginID, MessageID: Integer; Permanently: Boolean): Integer;
    procedure Messages(const LoginID: Integer; var Rst: _RecordSet);
    function Mute(const Login, Admin: string; Action, Hours: integer; reason: string): Integer;
    function NotifyAdd(const LoginID: Integer; const Login: string;
      const NotifyType: TNotifyType): Integer;
    function NotifyRemove(const LoginID: Integer; const Login: string;
      const NotifyType: TNotifyType): Integer;
    procedure SetRating(var Connection: TConnection; var CMD: TStrings);
    procedure Twins(var Connection: TConnection; var CMD: TStrings);
    procedure Unban(var Connection: TConnection; var CMD: TStrings);
    //function UnMute(const Login, Admin: string): Integer;
    procedure VerifyGame(const LoginID, GameID: Integer;
      const IsAdjourned: Boolean;
      var BlackID, WhiteID: integer;
      var Int: string;
      var Inc, Rated, RatedType: Integer;
      var BlackLogin, WhiteLogin: string;
      var BlackTitle, WhiteTitle: string;
      var BlackRating, WhiteRating: integer);
    procedure Welcome(const Version: string; var Rst: _RecordSet);
    procedure ShowCommands(var Connection: TConnection; var CMD: TStrings);
    procedure ReadCommands(SL: TStringList);
    procedure ReadVars;
    procedure CommandAdd(var Connection: TConnection; var CMD: TStrings);
    procedure ShowRoles(var Connection: TConnection; var CMD: TStrings);
    procedure RoleAdd(var Connection: TConnection; var CMD: TStrings);
    procedure DeleteRole(var Connection: TConnection; var CMD: TStrings);
    procedure RoleRelease(var Connection: TConnection; var CMD: TStrings);
    function ReadProcList(
      ProcName: string;
      Params: array of variant;
      Pattern: string;
      Indexes: array of integer;
      SLRes: TStrings;
      var Err: string): Variant;
    function SendProcList(
      Connection: TConnection;
      ProcName: string;
      Params: array of variant;
      Pattern: string;
      Indexes: array of integer;
      Itogi: Boolean): Variant;
    procedure CMD_Allow(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Reject(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Employ(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Dismiss(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Members(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_SetVar(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_ShowVars(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_ShowBanHistory(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_ShowCheats(var Connection: TConnection; var CMD: TStrings);
    function GetEcoDesc(ECO: string): string;
    procedure AddTitleCommand(var Connection: TConnection; var CMD: TStrings);
    procedure RemoveTitleCommand(var Connection: TConnection; var CMD: TStrings);
    procedure TitleCmmands(var Connection: TConnection; var CMD: TStrings);
    function GetEmail(Handle: string): string;
    function GetAuthKey(Handle: string): string;
    function GetPassword(Handle: string): string;
    function UpdateLoginPrivate(login,password,option: string; value: Variant): integer;
    procedure SendAuthKey(Connection: TConnection; CMD: TStrings; ToSendResult: Boolean; Pattern: string);
    procedure KeyConfirm(Connection: TConnection; CMD: TStrings);
    procedure UserSendPassword(Connection: TConnection; CMD: TStrings);
    procedure GetLastBanRecord(const Login: string; const BanType: TBanType;
      var admin: string; var type_: integer;
      var date_: TDateTime; var hours: integer);
    function IsBanned(const Login: string; const BanType: TBanType; var DateUntil: TDateTime): Boolean;
    function EventBan(const Login, Admin: string; Hours, type_: integer): Integer;
    procedure AddChatLog(const dt: TDateTime; Login, PlaceType, SayType, Place, Str: string);
    procedure ChangePassword(var Connection: TConnection; var CMD: TStrings);
    procedure SetAdult(Connection: TConnection; CMD: TStrings);
    procedure ReadStatTypes;
    procedure SendStatTypes(Connection: TConnection);
    procedure CMD_Stat(Connection: TConnection; var CMD: TStrings);
    function GetShoutMessage(Connection: TConnection): string;
    procedure CMD_ShowGreetings(Connection: TConnection; CMD: TStrings);
    procedure CMD_SetGreetings(Connection: TConnection; CMD: TStrings);
    procedure CMD_Clubs(Connection: TConnection; CMD: TStrings);
    procedure CMD_Club(Connection: TConnection; CMD: TStrings);
    procedure CMD_ClubRemove(Connection: TConnection; CMD: TStrings);
    procedure CMD_SetUserClub(Connection: TConnection; CMD: TStrings);
    procedure CMD_ClubMembers(Connection: TConnection; CMD: TStrings);
    procedure CMD_UserClub(Connection: TConnection; CMD: TStrings);
    procedure CMD_ClubStatus(Connection: TConnection; CMD: TStrings);
    procedure CMD_GetClubMembers(Connection: TConnection; CMD: TStrings);
    procedure CMD_ClubOptions(Connection: TConnection; CMD: TStrings);
    procedure CMD_ClubInfo(Connection: TConnection; CMD: TStrings);
    procedure SendClubMembers(Connection: TConnection; ClubId: integer);
    procedure ReadClubs;
    procedure CMD_GameSearch(Connection: TConnection; CMD: TStrings);
    function GetLoginInfo(Login: string; RatedType: TRatedType;
      var LoginId,Rating: integer; var RealLogin,Title: string): Boolean;
    procedure CMD_SetAdminLevel(Connection: TConnection; CMD: TStrings);
    procedure CMD_AdminLevel(Connection: TConnection; CMD: TStrings);
    procedure CMD_Admins(Connection: TConnection; CMD: TStrings);
    procedure CMD_Score(Connection: TConnection; CMD: TStrings);
    procedure GetGameScore(LoginId1,LoginId2: integer; RatedType: TRatedType; var Score: TPersonalScore);
    function IsMemberOf(Login,Role: string): Boolean;
    function SaveEvent(ev: TCSEvent): Boolean;
    procedure EventDelete(ID: integer);
    procedure CMD_ShowNames(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_ShowAddressHistory(var Connection: TConnection; var CMD: TStrings);
    function GetLoginId(Login: string): integer;
    function GetNotes(LoginId: integer): string;
    procedure CMD_BanProfile(Connection: TConnection; CMD: TStrings; Direction: Boolean);
    procedure SetServerOnline;
    procedure SaveUsersOnline;
    procedure SaveCommandsUsage(admin, command: string);
    procedure CMD_MessageSearch(Connection: TConnection; CMD: TStrings);
    procedure CMD_MessageState(Connection: TConnection; CMD: TStrings);
    procedure CMD_MessageRetrieve(Connection: TConnection; CMD: TStrings);
    function CountNewMessages(LoginID: integer): integer;
    procedure CMD_SetImage(Connection: TConnection; CMD: TStrings);
    procedure SendImages(Connection: TConnection);
    procedure CMD_ClientError(Connection: TConnection; CMD: TStrings);
    procedure ReadAccessLevels;
    function IsMasterTitle(title: string): Boolean;
    procedure SendVersionLink(Connection: TConnection; p_FirstLine: Boolean = true);
    procedure CMD_AdminGreetings(Connection: TConnection; CMD: TStrings);
    procedure ReadTimeOddsLimits(Connection: TConnection);
    procedure CMD_FullRecord(Connection: TConnection; CMD: TStrings);
    procedure CMD_Help(Connection: TConnection; CMD: TStrings);
    procedure SaveLectureAction(event_id, num, actiontype, param1: integer; param2: string);
    function GetTitle(Login: string): string;
    procedure SendMembershipTypes(Connection: TConnection);
    procedure ReadActions;
    procedure SendPayments(Connection: TConnection; p_Login: string);
    procedure CMD_TransactionState(Connection: TConnection; CMD: TStrings);
    procedure CMD_Transaction(Connection: TConnection; CMD: TStrings);
    function GetSpecialOffer: string;
    procedure SaveLagStat(p_Initiator, p_Operation, p_Params: string; p_MSec: integer);
    procedure SaveGame(GM: TGame);
    procedure TestingLongCall;
    procedure SaveLogUserAction(p_ActionType: integer; p_Login, p_Info: string);
  end;

var
  fDB: TDB;

const
  DB_ERROR = -10;

implementation

uses CSSocket, CSLib, CSMail, CSConnections, CSRooms, CSClub, CSGames,
  CSCommand, CSAccessLevels, CLRating, CSActions;

//================================================================================
{ TDbConn }
constructor TDbConn.Create;
begin
  try
    CoInitializeEx(nil, COINIT_MULTITHREADED);
    FCon := CoConnection.Create;
    FCmd := CoCommand.Create;
    { Establish Connection to SQL DB }
    with FCon do begin
      ConnectionString := DB_PROVIDER;
      ConnectionTimeout := 10;
      Open('', '', '', -1);
    end;

    with FCmd do begin
      Set_ActiveConnection(FCon);
      CommandType := adCmdStoredProc;
    end;
  except
    on E: Exception do begin
      ErrLog(E.Message,nil);

      FCmd := nil;
      if FCon.State = adStateOpen then FCon.Close;
      FCon := nil;
      CoUnInitialize;
    end;
  end;
end;
//================================================================================
destructor TDbConn.Destroy;
begin
  { Clean up the ADO objects }
  FCmd := nil;
  if Assigned(FCon) then if FCon.State = adStateOpen then FCon.Close;
  FCon := nil;
  CoUnInitialize;
  inherited;
end;
//================================================================================
function TDbConn.ExecSqlProc(
  const p_ProcName: string;
  p_Params: array of variant;
  p_OutParNums: array of integer;
  var pp_OutParValues: Variant;
  var pp_Rst: _RecordSet): integer;
var
  RecsAffected: OleVariant;
  i, CurThreadID: integer;
  slLog: TStrings;
  PutToLog: Boolean;
begin
  try
    slLog := TStringList.Create;
    PutToLog := false;
    slLog.Add('*****************************************');
    slLog.Add(p_ProcName);
    if High(p_Params) < 0 then
      slLog.Add('no params')
    else begin
      slLog.Add(Format('%d params', [High(p_Params) + 1]));
      for i := 0 to High(p_Params) do
        slLog.Add(Format('(#%d) => %s', [i + 1, VarToStr(p_Params[i])]));
    end;

    {CurThreadID := GetCurrentThreadID;
    if CurThreadID <> MAIN_THREAD_ID then begin
      slLog.Add('=== THREAD ERROR ===');
      slLog.Add(Format('main thread = %d, current thread = %d',
        [MAIN_THREAD_ID, CurThreadId]));
      PutToLog := true;
      //raise exception.Create('wrong thread');
    end;}

    critDB.Enter;
    try
      FCMD.CommandText := p_ProcName;
      FCMD.Parameters.Refresh;
      for i:=0 to High(p_Params) do
        FCMD.Parameters[i+1].Value := p_Params[i];
      pp_Rst := FCMD.Execute(RecsAffected, EmptyParam, adCmdStoredProc);

      {if pp_Rst = nil then
        DbLog('nil recordset opened')
      else if (pp_Rst.State <> adStateOpen) or pp_Rst.BOF then
        DbLog('empty recordset opened')
      else
        DbLog(Format('%d records opened', [pp_Rst.RecordCount]));}

      Result := nvl(FCMD.Parameters[0].Value, 0);
      slLog.Add('Result = ' + IntToStr(Result));

      if High(p_OutParNums) > -1 then begin
        pp_OutParValues := VarArrayCreate([0, High(p_OutParNums)], varVariant);
        slLog.Add(Format('%d output params passed', [High(p_OutParNums) + 1]));
        for i  := 0 to High(p_OutParNums) do begin
          pp_OutParValues[i] := FCMD.Parameters[p_OutParNums[i]].Value;
          slLog.Add(Format('(#%d) <= %s', [p_OutParNums[i], VarToStr(pp_OutParValues[i])]));
        end;
      end;

      slLog.Add('success');
    finally
      critDB.Leave;
    end;
  except
    on E:Exception do begin
      slLog.Add('=== ERROR ===');
      slLog.Add('CurThreadID = ' + IntToStr(GetCurrentThreadID));
      slLog.Add(E.Message);
      pp_Rst := nil;
      Result := DB_ERROR;
      PutToLog := true;
    end;
  end;
  if PutToLog then
    for i := 0 to slLog.Count - 1 do
      DbLog(slLog[i]);
  slLog.Free;
end;
//================================================================================
procedure TDbConn.DbLog(p_Line: string);
begin
  if not DB_LOGGING then exit;
  AppendToFile(MAIN_DIR + DB_LOG, '[' + NowLogFormat + ']: ' + p_Line);
end;
//================================================================================
{ TDB }

constructor TDB.Create;
begin
  fDBConn := TDBConn.Create;
  ErrLog('fDBConn created', nil);
  FStatTypes:=TStatTypes.Create;
end;
//================================================================================
destructor TDB.Destroy;
begin
  Logoff(nil);
  fDBConn.Free;
  //FRst := nil;
  SLVars.Free;
  FStatTypes.Free;
  inherited Destroy;
end;
//================================================================================
function TDB.AdjustRating(const Game: TGame;
  var WhiteRating, BlackRating: Integer;
  var WhiteProvisional, BlackProvisional: Boolean): Integer;
const
  PROC_RATINGADJUSTMENT = 'dbo.proc_RatingAdjustment';
var
  RecsAffected: OleVariant;
  V: Variant;
begin
  result := ExecProcOutParams('dbo.proc_RatingAdjustment',
    [Game.WhiteID, Game.BlackID, Game.Rated, Game.RatedType, Game.GameResult,
     BoolTo_(Game.Odds.FAutoTimeOdds,1,0),
     Game.TimeOddsScoreDeviation,
     WhiteRating, BlackRating, WhiteProvisional, BlackProvisional],
     [8, 9, 10, 11], V);

  WhiteRating := V[0];
  BlackRating := V[1];
  WhiteProvisional := V[2];
  BlackProvisional := V[3];
  V := Unassigned;
end;
//================================================================================
function TDB.ChangeTitle(const Login, Title: string): Integer;
begin
  result := ExecProc('dbo.proc_LoginTitleChange', [Login, Title]);
end;
//================================================================================
function TDB.Enable(const Login: string; Enable: Integer): Integer;
begin
  result := ExecProc('dbo.proc_LoginEnable', [Login, Enable]);
end;
//================================================================================
procedure TDB.GetProfile(Login: string; var Result: Integer; var Rst: _Recordset);
begin
  result := OpenRecordSet('dbo.proc_LoginProfile', [Login], Rst);
end;
//================================================================================
function TDB.LibraryAdd(const LoginID, GameID: Integer): Integer;
begin
  result := ExecProc('dbo.proc_LibraryAdd', [LoginID, GameID]);
end;
//================================================================================
function TDB.LibraryRemove(const LoginID, GameID: Integer): Integer;
begin
  result := ExecProc('dbo.proc_LibraryRemove', [LoginID, GameID]);
end;
//================================================================================
procedure TDB.LoadGame(const ID: Integer; var Game: TGame; const DeleteAdjourned: Boolean);
var
  FRst: _Recordset;
  RecsAffected: OleVariant;
  _BlackMSec, _WhiteMSec: Integer;
begin
  OpenRecordSet('dbo.proc_GameLoad', [ID, DeleteAdjourned], FRst);

  { ...read them into the Game object. }
  if (FRst.State = adStateOpen) and not (FRst.BOF) then
    begin
      with Game do
        begin
          BlackLogin := FRst.Fields[2].Value;
          BlackTitle := FRst.Fields[3].Value;
          _BlackMSec := FRst.Fields[4].Value;
          BlackRating := FRst.Fields[5].Value;
          Date := FRst.Fields[6].Value;
          Event := FRst.Fields[8].Value;
          if not VarIsNull(FRst.Fields[9].Value) then FEN := FRst.Fields[9].Value;
          WhiteInitialMSec := FRst.Fields[10].Value;
          WhiteIncMSec := FRst.Fields[11].Value;
          BlackInitialMSec := FRst.Fields[10].Value;
          BlackIncMSec := FRst.Fields[11].Value;
          Rated := FRst.Fields[12].Value;
          RatedType := TRatedType(FRst.Fields[13].Value);
          if not DeleteAdjourned then
            GameResult := TGameResult(FRst.Fields[14].Value);
          Round := FRst.Fields[15].Value;
          Site := FRst.Fields[16].Value;
          WhiteLogin := FRst.Fields[18].Value;
          WhiteTitle := FRst.Fields[19].Value;
          _WhiteMSec := FRst.Fields[20].Value;
          WhiteRating := FRst.Fields[21].Value;
        end;

      { Add moves (if any). }
      FRst := FRst.NextRecordset(RecsAffected);
      if (FRst.State = adStateOpen) and not (FRst.BOF) then
        begin
          while not FRst.EOF do
            begin
              Game.AddMove(FRst.Fields[2].Value, FRst.Fields[3].Value,
                FRst.Fields[4].Value, TMoveType(FRst.Fields[5].Value),
                string(FRst.Fields[6].Value), FRst.Fields[7].Value);

              FRst.MoveNext;
            end;
          FRst.Close;
        end;
      FRst := nil;

      { Set the time. Adding moves or setting a game result (above)
       messes with the MSecs. }
      with Game do
        begin
          BlackMSec := _BlackMSec;
          WhiteMSec := _WhiteMSec;
        end;
    end
  else
    begin
      { Empty GameHeader returned, so return a nil Game object }
      Game.Free;
      Game := nil;
    end;
  FRst := nil;
end;
//================================================================================
procedure TDB.Login(var Connection: TConnection; const Login, Password, MAC: string);
var
  FRst: _Recordset;
  RecsAffected: OleVariant;
  RatedType: TRatedType;
  Return, i: Integer;
  sInitTime, sDim: string;
  ip_address: variant;
  DateUntil: TDateTime;
begin
  { Attempt to execute the login stored procedure on the SQL server. }
   if Assigned(Connection.Socket) then
     ip_address := Connection.Socket.RemoteAddress
   else
     ip_address := null;

  Return := OpenRecordSet('dbo.proc_Login', [Login, Password, MAC, ip_address, 0], FRst);

  { Set the login result here. }
  Connection.LoginID := Return;
  { If the SP executed successfully a recordset will be returned. Use this
    recordset to set all the Connection variables. }
  if Return = 0 then
    begin
      if (FRst.State = adStateOpen) and not (FRst.BOF) then
        with Connection do
          begin
            { See the Stored procedure for field placement. This is less
              readable but faster than using the 'ByName' method. }
            LoginID := FRst.Fields[0].Value;
            Created := FRst.Fields[1].Value;
            Handle := FRst.Fields[2].Value;
            Title := FRst.Fields[4].Value;
            Registered := FRst.Fields[5].Value;
            AdminLevel := TAdminLevel(FRst.Fields[10].Value);
            AutoFlag := FRst.Fields[11].Value;
            Color := FRst.Fields[12].Value;
            GameLimit := FRst.Fields[13].Value;
            sInitTime := IntToStr(FRst.Fields[14].Value);
            IncTime := FRst.Fields[15].Value;
            if CompareVersion(Connection.Version,'7.7j')>-1 then begin
              MaxRating := FRst.Fields[16].Value;
              MinRating := FRst.Fields[17].Value;
            end else begin
              MaxRating := 3000;
              MinRating := 0;
            end;
            OfferLimit := FRst.Fields[18].Value;
            Open := FRst.Fields[19].Value;
            Rated := FRst.Fields[20].Value;
            RatedType := FRst.Fields[21].Value;
            RemoveOffers := FRst.Fields[22].Value;
            Muted := FRst.Fields[23].Value;
            sDim := nvl(FRst.Fields[26].Value,'');
            CReject := FRst.Fields[27].Value = 1;
            PReject := FRst.Fields[28].Value = 1;
            RejectWhilePlaying := FRst.Fields[29].Value = 1;
            BadLagRestrict := FRst.Fields[30].Value = 1;
            Adult := FRst.Fields[31].Value;
            ClubId := nvl(FRst.Fields[32].Value, 1);
            LoseOnDisconnect := FRst.Fields[33].Value;
            SeeTourShoutsEveryRound := FRst.Fields[34].Value = 1;
            BusyStatus := FRst.Fields[35].Value = 1;
            if sDim='S' then InitialTime:='0.'+sInitTime
            else InitialTime:=sInitTime;
            AutoMatch := FRst.Fields[36].Value = 1;
            AutoMatchMinR := nvl(FRst.Fields[37].Value, 0);
            AutoMatchMaxR := nvl(FRst.Fields[38].Value, 0);
            AllowSeekWhilePlaying := FRst.Fields[40].Value = 1;
          end;

      { Attempt to get the ratings }
      FRst := FRst.NextRecordset(RecsAffected);
      if (FRst.State = adStateOpen) and not (FRst.BOF) then
        while not FRst.EOF do
          begin
            RatedType := TRatedType(FRst.Fields[1].Value);
            Connection.Rating[RatedType] := FRst.Fields[2].Value;;
            Connection.Provisional[RatedType] := FRst.Fields[3].Value;
            for i:=0 to 2 do
              Connection.Stats[ord(RatedType),i] := FRst.Fields[4+i].Value;
            FRst.MoveNext;
          end;

      { The next RS are the Notify's. }
      FRst := FRst.NextRecordset(RecsAffected);
      if (FRst.State = adStateOpen) and not (FRst.BOF) then
        while not FRst.EOF do
          begin
            Connection.AddNotify(
              FRst.Fields[0].Value,
              FRst.Fields[1].Value,
              FRst.Fields[2].Value,
              TNotifyType(FRst.Fields[3].Value),
              false, false);
            FRst.MoveNext;
         end;

      FRst := FRst.NextRecordset(RecsAffected);
      if (FRst<>nil) and (FRst.State = adStateOpen) and not (FRst.BOF) and not (FRst.EOF)then begin
        Connection.Email:=nvl(FRst.Fields[1].Value,'');
        Connection.CountryId:=nvl(FRst.Fields[5].Value,-1);
        Connection.SexId:=nvl(FRst.Fields[6].Value,-1);
        Connection.Age:=nvl(FRst.Fields[7].Value,0);
        Connection.Language:=FRst.Fields[8].Value;
        Connection.PublicEmail:=FRst.Fields[9].Value = 1;
        Connection.Birthday := nvl(FRst.Fields[10].Value, 0);
        Connection.ShowBirthday := FRst.Fields[11].Value = '1';
      end else begin
        Connection.Email:='';
        Connection.CountryId:=-1;
        Connection.SexId:=-1;
        Connection.Age:=0;
        Connection.Language:='English';
        Connection.PublicEmail:=false;
        Connection.Birthday := 0;
        Connection.ShowBirthday := false;
      end;

      FRst := FRst.NextRecordset(RecsAffected);
      if (FRst<>nil) and (FRst.State = adStateOpen) and not (FRst.BOF) and not (FRst.EOF) then begin
        Connection.MembershipType := TMembershipType(FRst.Fields[0].Value);
        Connection.MembershipExpireDate := FRst.Fields[2].Value;
      end else begin
        Connection.MembershipType := mmbNone;
        Connection.MembershipExpireDate := 0;
      end;

      //Connection.AchUserList.ReadFromDB(Connection.Handle);

      ReadRoles(Connection); 

      Connection.Muted:=IsBanned(Connection.Handle,banMute,DateUntil);
      Connection.MutedDateUntil:=DateUntil;

      Connection.EVBanned:=IsBanned(Connection.Handle,banEvent,DateUntil);
      Connection.EVBannedDateUntil:=DateUntil;

      //n:=ExecProc('dbo.is_Unbanned',[Login]);
      Connection.Unbanned:=true;//n>0;

      if IsMasterOnlyTitle(Connection.Title) then Connection.ImageIndex := 2
      else if IsGMOnlyTitle(Connection.Title) then Connection.ImageIndex := 3
      else if Connection.AdminLevel > alNone then
        Connection.ImageIndex := 1
      else
        Connection.ImageIndex := 0;

      Connection.Master := IsMasterTitle(Connection.Title);
      Connection.HiddenCompAccount:=IsMemberOf(Connection.Handle,'HiddenCompAccount');
      Connection.AdminGreeted := ExecProc('dbo.proc_IsAdminGreetings',[Connection.LoginID]) > 0;
    end;

  if (FRst<>nil) and (FRst.State = adStateOpen) then FRst.Close;


  Connection.GamesPerDayList.Clear;
  OpenRecordSet('dbo.proc_GetTodayGamesCnt', [Connection.LoginID], FRst);

  if (FRst.State = adStateOpen) and not (FRst.BOF) then
    while not FRst.EOF do begin
      Connection.GamesPerDayList.AddRecord(TRatedType(FRst.Fields[0].Value), FRst.Fields[1].Value);
      FRst.MoveNext;
    end;

  if (FRst<>nil) and (FRst.State = adStateOpen) then FRst.Close;
  FRst := nil;
end;
//================================================================================
function TDB.LoginRegister(const Login, Password, Email, MAC, AuthKey: string;
  CountryId, SexId, Age: integer; Language: string;
  PublicEmail: Boolean; Birthday: TDateTime; ShowBirthday: Boolean): Integer;
var
  RecsAffected: OleVariant;
begin
  result := ExecProc('dbo.proc_LoginRegister',
    [Login,
     Password,
     Email,
     NullIf(MAC, ''),
     AuthKey, CountryID,
     NullIf(SexID, -1),
     NullIf(Age, 0),
     Language,
     BoolTo01(PublicEmail),
     Birthday,
     ShowBirthday]);
end;
//================================================================================
procedure TDB.UpdateLoginSettings(const Connection: TConnection);
var
  n,InitTime: integer;
  sDim: string;
begin
  n:=pos('.',Connection.InitialTime);
  if n=0 then begin
    InitTime:=StrToInt(Connection.InitialTime);
    sDim:='M';
  end else begin
    InitTime:=StrToInt(copy(Connection.InitialTime,n+1,100));
    sDim:='S';
  end;

  ExecProc('dbo.proc_LoginSettingsUpdate',
   [Connection.LoginID, // 1
    Connection.AutoFlag,
    Connection.Color,
    InitTime,
    Connection.IncTime,      // 5
    Connection.MaxRating,
    Connection.MinRating,
    Connection.Open,
    Connection.Rated,
    Connection.RatedType,     // 10
    Connection.RemoveOffers,
    sDim,
    BoolTo01(Connection.CReject),
    BoolTo01(Connection.PReject),
    Connection.Email,                  // 15
    NullIf(Connection.CountryID, -1),
    NullIf(Connection.SexId, -1),
    NullIf(Connection.Age, 0),
    BoolTo01(Connection.RejectWhilePlaying),
    BoolTo01(Connection.BadLagRestrict),      // 20
    BoolTo_(Connection.LoseOnDisconnect,1,0),
    BoolTo_(Connection.SeeTourShoutsEveryRound,1,0),
    BoolTo_(Connection.BusyStatus,1,0),
    Connection.Language,
    BoolTo_(Connection.PublicEmail,1,0),       // 25
    Connection.Birthday,
    BoolTo_(Connection.ShowBirthday,1,0),
    BoolTo_(Connection.AutoMatch,1,0),
    Connection.AutoMatchMinR,
    Connection.AutoMatchMaxR,
    BoolTo_(Connection.AllowSeekWhilePlaying,1,0)]);         // 30
end;
//================================================================================
procedure TDB.Logoff(const Connection: TConnection);
begin
  if Assigned(Connection) then begin
    ExecProc('dbo.proc_Logoff', [Connection.LoginID]);
    UpdateLoginSettings(Connection);
  end else
    ExecProc('dbo.proc_Logoff', [null]);
end;
//================================================================================
function TDB.MessageAdd(const LoginID: Integer; const Login, Subject, Body: string): Integer;
begin
  result := ExecProc('dbo.proc_MessageAdd',
    [LoginID, Login, Subject, Body]);
end;
//================================================================================
function TDB.MessageDelete(const LoginID, MessageID: Integer; Permanently: Boolean): Integer;
begin
  result := ExecProc('dbo.proc_MessageDelete',
    [LoginID, MessageID, BoolTo01(Permanently)]);
end;
//================================================================================
procedure TDB.Messages(const LoginID: Integer; var Rst: _RecordSet);
begin
  OpenRecordset('dbo.proc_Messages', [LoginID], Rst);
end;
//================================================================================
function TDB.Mute(const Login, Admin: string; Action, Hours: integer; reason: string): Integer;
begin
  result := ExecProc('dbo.proc_Mute', [Login, Action, Hours, Admin, reason]);
end;
//================================================================================
function TDB.NotifyAdd(const LoginID: Integer; const Login: string;
  const NotifyType: TNotifyType): Integer;
begin
  result := ExecProc('dbo.proc_NotifyAdd', [LoginID, Login, NotifyType]);
end;
//================================================================================
function TDB.NotifyRemove(const LoginID: Integer; const Login: string;
  const NotifyType: TNotifyType): Integer;
begin
  result := ExecProc('dbo.proc_NotifyRemove', [LoginID, Login, NotifyType]);
end;
//================================================================================
function TDB.OpenRecordSet(const ProcName: string; Params: array of variant;
  var Rst: _RecordSet): Variant;
var
  RecsAffected: OleVariant;
  i: integer;
  V: Variant;
begin
  result := fDBConn.ExecSqlProc(ProcName, Params, [], V, Rst);
  V := Unassigned;
end;
//================================================================================
procedure TDB.VerifyGame(const LoginID, GameID: Integer;
  const IsAdjourned: Boolean;
  var BlackID, WhiteID: integer;
  var Int: string;
  var Inc, Rated, RatedType: Integer;
  var BlackLogin, WhiteLogin: string;
  var BlackTitle, WhiteTitle: string;
  var BlackRating, WhiteRating: integer);
var
  FRst: _Recordset;
begin
  { Initialize variables. }
  BlackID := -1;
  WhiteID := -1;
  OpenRecordSet('dbo.proc_GameVerify', [LoginID, GameID, IsAdjourned], FRst);

    { Assign the results. }
    if (FRst.State = adStateOpen) and not (FRst.BOF) then
      begin
        BlackID := FRst.Fields[1].Value;
        BlackLogin := FRst.Fields[2].Value;
        BlackTitle := FRst.Fields[3].Value;
        BlackRating := FRst.Fields[5].Value;
        WhiteID := FRst.Fields[17].Value;
        WhiteLogin := FRst.Fields[18].Value;
        WhiteTitle := FRst.Fields[19].Value;
        WhiteRating := FRst.Fields[21].Value;
        Int := FRst.Fields[10].Value div MSECS_PER_MINUTE;
        Inc := FRst.Fields[11].Value div MSecs;
        Rated := FRst.Fields[12].Value;
        RatedType := FRst.Fields[13].Value;
        FRst.Close;
        FRst := nil;
      end;
  FRst := nil;
end;
//================================================================================
procedure TDB.Welcome(const Version: string; var Rst: _RecordSet);
begin
  OpenRecordset('dbo.proc_WelcomeMessage', [Version], Rst);
end;
//================================================================================
function TDB.ExecProc(const ProcName: string; Params: array of variant): integer;
var
  Rst: _RecordSet;
  V: Variant;
begin
  result := fDBConn.ExecSqlProc(ProcName, Params, [], V, Rst);
  Rst := nil;
  V := Unassigned;
end;
//================================================================================
function TDB.ExecProcOutParams(const ProcName: string; Params: array of Variant;
  p_OutParNums: array of integer; var pp_OutParValues: Variant): integer;
var
  Rst: _RecordSet;
begin
  result := fDBConn.ExecSqlProc(ProcName, Params, p_OutParNums, pp_OutParValues,
    Rst);
  Rst := nil;
end;
//================================================================================
procedure TDB.Ban(var Connection: TConnection; var CMD: TStrings);
var
  hours, i, res: integer;
  reason, msg: string;
begin
  {if not (Connection.AdminLevel in [alNormal,alSuper]) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
      Exit;
    end;}
  if CMD.Count<4 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    Hours := StrToInt(CMD[2]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number format']);
    Exit;
  end;

  if Hours = 0 then Hours:=UNLIMITED_BAN_TIME;
  if (Connection.AdminLevel<alSuper) and (Hours>MAX_BAN_TIME) then
    Hours:=MAX_BAN_TIME;

  reason := '';
  for i := 3 to CMD.Count-1 do
    reason := reason + CMD[i] + ' ';

  res:=ExecProc('dbo.proc_Ban',[CMD[1], Hours, Connection.Handle, reason]);
  if res=-1 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_USER_NOT_EXISTS,[CMD[1]])])
  else begin
    msg:=DP_MSG_USER_BANNED;
    if Hours = UNLIMITED_BAN_TIME then msg:=msg+' forever'
    else msg:=msg+' for '+IntToStr(Hours)+' hours';

    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, Format(msg,[CMD[1]])]);
  end;
end;
//================================================================================
procedure TDB.Unban(var Connection: TConnection; var CMD: TStrings);
var res: integer;
begin
  {if not (Connection.AdminLevel in [alNormal,alSuper]) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
      Exit;
    end;}
  if CMD.Count<1 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      exit;
    end;

  res:=ExecProc('dbo.proc_Unban',[CMD[1],Connection.Handle]);
  if res=-1 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_USER_NOT_EXISTS,[CMD[1]])])
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, Format(DP_MSG_USER_UNBANNED,[CMD[1]])]);
end;
//================================================================================
procedure TDB.LoginHistory(var Connection: TConnection; var CMD: TStrings);
begin
  //
end;
//================================================================================
procedure TDB.SetRating(var Connection: TConnection; var CMD: TStrings);
var
  Login, sType: string;
  Rating,RatingType, Provisional,lw,hg,i,res: integer;
begin
  {if not (Connection.AdminLevel in [alSuper]) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_SUPER_ADMIN_ONLY]);
      Exit;
    end;}
  if CMD.Count<4 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      exit;
    end;
  if CMD.Count=4 then CMD.Add('0');
  Login:=CMD[1];
  sType:=lowercase(CMD[2]);

  if (sType='st') or (sType='standard') then RatingType := 0
  else if (sType='bl') or (sType='blitz') then RatingType := 1
  else if (sType='bu') or (sType='bullet') then RatingType := 2
  else if (sType='ch') or (sType='crazy') then RatingType := 3
  else if (sType='fr') or (sType='fisher') then RatingType := 4
  else if (sType='ls') or (sType='losers') then RatingType := 5
  else if sType='all' then RatingType := -1
  else begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Unknown rating type']);
    exit;
  end;

  try
    Rating := StrToInt(CMD[3]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Rating must be the number']);
    exit;
  end;

  if (Rating<1) or (Rating>5000) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Rating must be between 1 and 3000']);
      exit;
    end;

  try
    Provisional := StrToInt(CMD[4]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Provisional must be the number']);
    exit;
  end;

  if (Provisional<>0) and (Provisional<>1) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Provisional must be either 0 or 1']);
      exit;
    end;

  if RatingType = -1 then
    begin
      lw:=0; hg:=5;
    end
  else
    begin
      lw:=RatingType; hg:=lw;
    end;

  for i:=lw to hg do
    begin
      res:=ExecProc('dbo.proc_SetRating',[Login,Rating,i,Provisional]);
      if res=-1 then
        begin
          fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_USER_NOT_EXISTS,[Login])]);
          exit;
        end;
    end;

  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Rating is successfully set']);
end;
//================================================================================
procedure TDB.Twins(var Connection: TConnection; var CMD: TStrings);
begin
  if CMD.Count<>2 then
    begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Usage: '+CMD[0]+' <username>']);
      exit;
    end;

  SendProcList(Connection,'dbo.proc_ShowTwins',[Connection.Handle,CMD[1]],'%s',[0],true);
end;
//================================================================================
procedure TDB.LoginErrors(var Connection: TConnection; var CMD: TStrings);
var
  msg, sDate: string;
  date_: TDateTime;
  login: Variant;
  FRst: _Recordset;
begin
  if CMD.Count > 1 then login := CMD[1]
  else login := null;

  OpenRecordset('dbo.proc_ShowLoginErrors', [Login], FRst);

  if not Assigned(FRst) or (FRst.State <> adStateOpen) or (FRst.BOF) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'no records']);
    exit;
  end;

  while not FRst.EOF do begin
    date_:=FRst.Fields[0].Value;
    sDate:=FormatDateTime('mm/dd/yyyy h:mi:ss AM/PM',date_);
    msg:=Format('%s  %s  %s  %s',[sDate, FRst.Fields[1].Value,
      FRst.Fields[2].Value, FRst.Fields[3].Value]);
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, msg]);
    FRst.MoveNext;
  end;
  FRst := nil;
end;
//================================================================================
procedure TDB.CommandAdd(var Connection: TConnection; var CMD: TStrings);
var
  name,FormatMessage: string;
  admlevel: integer;
begin
  FormatMessage:='Format: '+CMD[0]+' <name> <admlevel>';
  if CMD.Count<>3 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, FormatMessage]);
      exit;
    end;

  name:=CMD[1];
  try
    admlevel:=StrToInt(CMD[2]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, FormatMessage]);
    exit;
  end;
  ExecProc('dbo.proc_UpdCommand',[name,admlevel]);
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Command changed']);
end;
//================================================================================
procedure TDB.RoleAdd(var Connection: TConnection; var CMD: TStrings);
var
  err: string;
  n: integer;
begin
  if not TestParams(CMD,[0],0,err) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err]);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]+' <name>']);
    exit;
  end;

  n:=ExecProc('dbo.proc_AddRole', [CMD[1]]);
  if n=-1 then fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,Format('The role %s is already exists',[CMD[1]])])
  else fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'The role is successfully added']);
end;
//================================================================================
procedure TDB.RoleRelease(var Connection: TConnection; var CMD: TStrings);
var
  res: integer;
begin
  if CMD.Count<>2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number of parameters']);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]+' <rolename>']);
    exit;
  end;

  res:=ExecProc('dbo.proc_ReleaseRole',[CMD[1]]);
  if res=0 then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Role '+CMD[1]+' released'])
  else
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'The role '+CMD[1]+' does not exists'])
end;
//================================================================================
procedure TDB.DeleteRole(var Connection: TConnection; var CMD: TStrings);
var
  res: integer;
  msg: string;
begin
  if CMD.Count<>2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Invalid number of parameters']);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]+' <rolename>']);
    exit;
  end;

  res:=ExecProc('dbo.proc_DeleteRole',[CMD[1]]);
  if res=0 then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Role '+CMD[1]+' deleted'])
  else begin
    case res of
      -1: msg:='The role '+CMD[1]+' does not exists';
      -2: msg:='There are some people employed to this role. Release the role first.';
    end;
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,msg])
  end;
end;
//================================================================================
procedure TDB.ShowCommands(var Connection: TConnection; var CMD: TStrings);
var
  proc: string;
begin
  if CMD.Count<>2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: /commands <admlevel>']);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'   or: /commands <rolename>']);
    exit;
  end;

  try
    StrToInt(CMD[1]);
    proc:='dbo.proc_ShowCommands';
  except
    proc:='dbo.proc_ShowRoleCOmmands';
  end;
  if SendProcList(Connection,proc,[CMD[1]],'%s',[0],true) = -1 then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('The role %s is not exists',[CMD[1]])]);
end;
//================================================================================
procedure TDB.ShowRoles(var Connection: TConnection; var CMD: TStrings);
var
  param: Variant;
begin
  if CMD.Count>2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Illegal number of parameters']);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]]);
    exit;
  end;

  if CMD.Count=1 then param:=null
  else param:=CMD[1];

  SendProcList(Connection,'dbo.proc_ShowRoles',[param],'%s',[0],true);
end;
//================================================================================
procedure TDB.ReadCommands(SL: TStringList);
var
  FRst: _Recordset;
begin
  SL.Clear;
  SL.Sorted:=false;
  OpenRecordset('dbo.proc_ShowCommands', [0], FRst);

  if not Assigned(FRst) or (FRst.State <> adStateOpen) or (FRst.BOF) then
    exit;

  while not FRst.EOF do
    begin
      SL.Add(lowercase(FRst.Fields[0].Value));
      FRst.MoveNext;
    end;
  SL.Sorted:=true;
  FRst := nil;
end;
//================================================================================
function TDB.ReadProcList(ProcName: string; Params: array of variant;
  Pattern: string; Indexes: array of integer; SLRes: TStrings;
  var Err: string): Variant;
var
  msg: string;
  i: integer;
  FRst: _Recordset;
begin
  result:=null; err:='';
  SLRes.Clear;
  result := OpenRecordset(ProcName, Params, FRst);

  if not Assigned(FRst) or (FRst.State <> adStateOpen) or (FRst.BOF) then exit;

  while not FRst.EOF do begin
    msg:=FormatRst(FRst,Pattern,Indexes);
    SLRes.Add(msg);
    FRst.MoveNext;
  end;
  FRst := nil;
end;
//================================================================================
function TDB.SendProcList(Connection: TConnection; ProcName: string; Params: array of variant;
  Pattern: string; Indexes: array of integer; Itogi: Boolean): Variant;
var
  SL: TStringList;
  err: string;
  i: integer;
begin
  SL:=TStringList.Create;
  try
    result:=ReadProcList(ProcName, Params, Pattern, Indexes, SL, err);
    if err<>'' then
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'error: '+err])
    else begin
      for i:=0 to SL.Count-1 do
        fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,SL[i]]);
      if Itogi then begin
        fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'---------']);
        fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('%d records',[SL.Count])]);
      end;
    end;
  finally
    SL.Free;
  end;
end;
//================================================================================
procedure TDB.CMD_Allow(var Connection: TConnection; var CMD: TStrings);
var
  err: string;
  res: integer;
begin
  if not TestParams(CMD,[0,0],0,err) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err]);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]+' <role> <command>']);
    exit;
  end;

  res:=ExecProc('dbo.proc_RoleCommands',[CMD[1],CMD[2],1]);
  err:='';
  case res of
    -1: err:='Role '+CMD[1]+' does not exists';
    -2: err:='Command '+CMD[2]+' does not exists';
    -3: err:=Format('Command %s is already allowed to role %s',[CMD[2],CMD[1]]);
  end;
  if err<>'' then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err])
  else
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('Commannd %s is allowed to role %s',[CMD[2],CMD[1]])]);
end;
//================================================================================
procedure TDB.CMD_Dismiss(var Connection: TConnection; var CMD: TStrings);
var
  err: string;
  res: integer;
begin
  if not TestParams(CMD,[0,0],0,err) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err]);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]+' <login> <role>']);
    exit;
  end;

  res:=ExecProc('dbo.proc_LoginRole',[CMD[1],CMD[2],0]);
  err:='';
  case res of
    -1: err:='Role '+CMD[1]+' does not exists';
    -2: err:='Login '+CMD[2]+' does not exists';
    -4: err:=Format('User %s is not employed to role %s',[CMD[1],CMD[2]]);
  end;
  if err<>'' then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err])
  else
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('User %s is dismissed from role %s',[CMD[1],CMD[2]])]);
end;
//================================================================================
procedure TDB.CMD_Employ(var Connection: TConnection; var CMD: TStrings);
var
  err: string;
  res: integer;
begin
  if not TestParams(CMD,[0,0],0,err) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err]);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]+' <login> <role>']);
    exit;
  end;

  res:=ExecProc('dbo.proc_LoginRole',[CMD[1],CMD[2],1]);
  err:='';
  case res of
    -1: err:='User '+CMD[1]+' does not exists';
    -2: err:='Role '+CMD[2]+' does not exists';
    -3: err:=Format('User %s is already employed to role %s',[CMD[1],CMD[2]]);
  end;
  if err<>'' then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err])
  else
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('User %s is employed to role %s',[CMD[1],CMD[2]])]);
end;
//================================================================================
procedure TDB.CMD_Reject(var Connection: TConnection; var CMD: TStrings);
var
  err: string;
  res: integer;
begin
  if not TestParams(CMD,[0,0],0,err) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err]);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]+' <role> <command>']);
    exit;
  end;

  res:=ExecProc('dbo.proc_RoleCommands',[CMD[1],CMD[2],0]);
  err:='';
  case res of
    -1: err:='Role '+CMD[1]+' does not exists';
    -2: err:='Command '+CMD[2]+' does not exists';
    -4: err:=Format('Command %s is not allowed to role %s',[CMD[2],CMD[1]]);
  end;
  if err<>'' then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err])
  else
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('Commannd %s is rejected to role %s',[CMD[2],CMD[1]])]);
end;
//================================================================================
procedure TDB.CMD_Members(var Connection: TConnection; var CMD: TStrings);
begin
  if CMD.Count<>2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[1]+' <rolename>']);
    exit;
  end;

  if SendProcList(Connection,'dbo.proc_ShowMembers',[CMD[1]],'%s',[0],true) = -1 then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('Role %s does not exists',[CMD[1]])]);
end;
//================================================================================
procedure TDB.ReadVars;
var
  err: string;
begin
  SLVars.Clear;
  ReadProcList('dbo.proc_Var',[null],'%s=%s',[0,1],SLVars,err);

  if SLVars.Values['MIN_SUPPORTED_VER']<>'' then
    MIN_SUPPORTED_VER:=SLVars.Values['MIN_SUPPORTED_VER'];

  if SLVars.Values['MAX_GAMES']<>'' then
    try
      MAX_GAMES:=StrToInt(SLVars.Values['MAX_GAMES']);
    except
    end;

  if SLVars.Values['CHEAT_RED_MIN_MOVES']<>'' then
    try
      CHEAT_RED_MIN_MOVES:=StrToInt(SLVars.Values['CHEAT_RED_MIN_MOVES']);
    except
    end;

  if SLVars.Values['CHEAT_YELLOW_DIFF']<>'' then
    try
      CHEAT_YELLOW_DIFF:=StrToInt(SLVars.Values['CHEAT_YELLOW_DIFF']);
    except
    end;

  if SLVars.Values['CHEAT_RED_KOEF']<>'' then
    try
      CHEAT_RED_KOEF:=Str2Float(SLVars.Values['CHEAT_RED_KOEF']);
    except
    end;

  if SLVars.Values['LOG_BUFFER_COUNT']<>'' then
    try
      LOG_BUFFER_COUNT:=StrToInt(SLVars.Values['LOG_BUFFER_COUNT']);
    except
    end;

  if SLVars.Values['']<>'' then
    try
      MAIL_HOST:=SLVars.Values['MAIL_HOST'];
    except
    end;

  if SLVars.Values['MAIL_USER']<>'' then
    try
      MAIL_USER:=SLVars.Values['MAIL_USER'];
    except
    end;

  if SLVars.Values['MAIL_PASSWORD']<>'' then
    try
      MAIL_PASSWORD:=SLVars.Values['MAIL_PASSWORD'];
    except
    end;

  if SLVars.Values['MAIL_FROM_ADDRESS']<>'' then
    try
      MAIL_FROM_ADDRESS:=SLVars.Values['MAIL_FROM_ADDRESS'];
    except
    end;

  if SLVars.Values['MAIL_FROM_NAME']<>'' then
    try
      MAIL_FROM_NAME:=SLVars.Values['MAIL_FROM_NAME'];
    except
    end;

  if SLVars.Values['MAIL_PORT']<>'' then
    try
      MAIL_PORT:=StrToInt(SLVars.Values['MAIL_PORT']);
    except
    end;

  SAVE_CHAT_LOG := SLVars.Values['SAVE_CHAT_LOG']='Y';

  if SLVars.Values['MAX_LOGCHAT_LINES']<>'' then
    try
      MAX_CHATLOG_LINES:=StrToInt(SLVars.Values['MAX_LOGCHAT_LINES']);
    except
    end;

  {if SLVars.Values['NET_TIMEOUT']<>'' then
    try
      NET_TIMEOUT:=StrToInt(SLVars.Values['NET_TIMEOUT'])*1000;
    except
    end;}

  if SLVars.Values['URL_OPEN_ADMINLEVEL'] <> '' then
    try
      URL_OPEN_ADMINLEVEL := StrToInt(SLVars.Values['URL_OPEN_ADMINLEVEL']);
    except
    end;

  if SLVars.Values['ACH_ADMIN_LEVEL'] <> '' then
    try
      ACH_ADMIN_LEVEL := StrToInt(SLVars.Values['ACH_ADMIN_LEVEL']);
    except
    end;

  if SLVars.Values['URL_START'] <> '' then
    URL_START := SLVars.Values['URL_START'];

  if SLVars.Values['URL_START_ADMIN'] <> '' then
    URL_START := SLVars.Values['URL_START_ADMIN'];

  ADMIN_GREETINGS := SLVars.Values['ADMIN_GREETINGS'];

  if SLVars.Values['URL_START_PERIOD'] <> '' then
    try
      URL_START_PERIOD := Str2Float('URL_START_PERIOD');
    except
    end;

  if SLVars.Values['AUTOSHOUTS']<>'' then
    AUTOSHOUTS:=slVars.Values['AUTOSHOUTS']='Y';

  if SLVars.Values['LAST_EXE_LINK'] <> '' then
    LAST_EXE_LINK := SLVars.Values['LAST_EXE_LINK'];

  if SLVars.Values['VERSION_CLIENT_UPDATE'] <> '' then
    VERSION_CLIENT_UPDATE := SLVars.Values['VERSION_CLIENT_UPDATE'];

  if SLVars.Values['AUTOTIMEODDS_RATING_DIFF'] <> '' then
    try
      AUTOTIMEODDS_RATING_DIFF := StrToInt(SLVars.Values['AUTOTIMEODDS_RATING_DIFF']);
    except
    end;


  AUTH_KEY_SEND:=SLVars.Values['AUTH_KEY_SEND'] = '1';
  LOGGING:=SLVars.Values['LOGGING']='Y';
  AUTO_FORFEITS_TIME := SLVars.Values['AUTO_FORFEITS_TIME'] = 'Y';
end;
//================================================================================
procedure TDB.CMD_SetVar(var Connection: TConnection; var CMD: TStrings);
var
  name,value,FormatMessage: string;
  i: integer;
begin
  FormatMessage:='Format: '+CMD[0]+' <name> <value>';
  if CMD.Count<2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, FormatMessage]);
      exit;
    end;

  name := CMD[1];
  value := '';
  for i:=2 to CMD.Count-1 do
    value := value + CMD[i] + ' ';

  if ExecProc('dbo.proc_UpdVar',[name,value])=-1 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Variable '+CMD[1]+' does not exists'])
  else begin
    ReadVars;
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Variable '+CMD[1]+' was successfully set']);
  end;
end;
//================================================================================
procedure TDB.CMD_ShowVars(var Connection: TConnection; var CMD: TStrings);
var
  i: integer;
begin
  for i:=0 to SLVars.Count-1 do
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,SLVars[i]]);
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'---------']);
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('%d records',[SLVars.Count])]);
end;
//================================================================================
procedure TDB.CMD_ShowBanHistory(var Connection: TConnection; var CMD: TStrings);
var
  msg, sDate,admin,sType,s,sReason: string;
  date_: TDateTime;
  nType,nDirection,nHours: integer;
  FRst: _Recordset;
begin
  if CMD.Count<>2 then
    begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Usage: '+CMD[0]+' <username>']);
      exit;
    end;

  OpenRecordset('dbo.proc_ShowBanHistory', [CMD[1]], FRst);

  if not Assigned(FRst) or (FRst.State <> adStateOpen) or (FRst.BOF) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'no records']);
      exit;
    end;

  while not FRst.EOF do
    begin
      admin:=FRst.Fields[2].Value;
      date_:=FRst.Fields[3].Value;
      sDate:=FormatDateTime('mm/dd/yyyy h:mi:ss AM/PM',date_);
      nDirection:=FRst.Fields[4].Value;
      nType:=FRst.Fields[5].Value;
      nHours:=nvl(FRst.Fields[6].Value,0);
      sReason:=nvl(FRst.Fields[7].Value,'');

      if nDirection = 1 then s:=''
      else s:='un';

      case nType of
        1: sType:='banned';
        2: sType:='muted';
        3: sType:='banned for events';
        4: sType:='nuked';
        5: sType:='banned for profile editing';
      else
        sType:='unknown action';
      end;

      sType:=s+sType;

      msg:=Format('%s  %s by %s',[sDate,sType,admin]);
      if nDirection = 1 then begin
        if nHours = 100000 then msg := msg + ' forever'
        else msg := msg + ' for ' + IntToStr(nHours) + ' hours';
      end;

      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, msg]);

      if sReason <> '' then
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, '  Reason: ' + sReason]);
      FRst.MoveNext;
    end;
  FRst := nil;
end;
//================================================================================
procedure TDB.CMD_ShowCheats(var Connection: TConnection;
  var CMD: TStrings);
begin
  if CMD.Count<>2 then
    begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Usage: '+CMD[0]+' <username>']);
      exit;
    end;

  SendProcList(Connection,'dbo.proc_ShowCheats',[CMD[1]],'%t  vs %s',[1,0],true);
end;
//================================================================================
function TDB.GetEcoDesc(ECO: string): string;
var
  sl: TStringList;
  err: string;
begin
  sl:=TStringList.Create;
  try
    ReadProcList('dbo.proc_GetEcoDesc',[ECO],'%s',[0], sl, err);
    if sl.Count=0 then result:=''
    else result:=sl[0];
  finally
    sl.Free;
  end;
end;
//================================================================================
procedure TDB.AddTitleCommand(var Connection: TConnection;
  var CMD: TStrings);
var
  err: string;
  res: integer;
begin
  if not TestParams(CMD,[0],0,err) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err]);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]+' <command>']);
    exit;
  end;

  res:=ExecProc('dbo.proc_UpdCommandTitled',[CMD[1],1]);
  err:='';
  case res of
    -1: err:='Command '+CMD[1]+' does not exists';
  end;
  if res=-1 then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Command '+CMD[1]+' does not exists'])
  else
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('Command %s is allowed to title players',[CMD[1]])]);
end;
//================================================================================
procedure TDB.RemoveTitleCommand(var Connection: TConnection;
  var CMD: TStrings);
var
  err: string;
  res: integer;
begin
  if not TestParams(CMD,[0],0,err) then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,err]);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Usage: '+CMD[0]+' <command>']);
    exit;
  end;

  res:=ExecProc('dbo.proc_UpdCommandTitled',[CMD[1],0]);
  err:='';
  case res of
    -1: err:='Command '+CMD[1]+' does not exists';
  end;
  if res=-1 then
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Command '+CMD[1]+' does not exists'])
  else
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,Format('Command %s is rejected to title players',[CMD[1]])]);
end;
//================================================================================
procedure TDB.TestingLongCall;
var
  Rst1, Rst2: _RecordSet;
begin
  OpenRecordset('dbo.proc_GetAllLogins', [], Rst1);
  while not Rst1.Eof do
  
  Rst1 := nil;
  Rst2 := nil;
end;
//================================================================================
procedure TDB.TitleCmmands(var Connection: TConnection; var CMD: TStrings);
begin
  if CMD.Count<>1 then
    begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Usage: '+CMD[0]]);
      exit;
    end;

  SendProcList(Connection,'dbo.proc_ShowCommandsTitled',[],'%s',[0],true);
end;
//================================================================================
function TDB.GetEmail(Handle: string): string;
var
  err: string;
  sl: TStringList;
begin
  sl:=TStringList.Create;
  ReadProcList('dbo.proc_LoginPrivate',[Handle],
    '%s',[1],sl,err);

  if (err<>'') or (sl.Count = 0) then result:=''
  else result:=sl[0];

  sl.Free;
end;
//================================================================================
function TDB.GetAuthKey(Handle: string): string;
var
  err: string;
  sl: TStringList;
begin
  sl:=TStringList.Create;
  ReadProcList('dbo.proc_LoginPrivate',[Handle],
    '%s',[2],sl,err);

  if (err<>'') or (sl.Count = 0) then result:=''
  else result:=sl[0];

  sl.Free;
end;
//================================================================================
function TDB.UpdateLoginPrivate(login, password, option: string;
  value: Variant): integer;
begin
  result:=ExecProc('dbo.proc_LoginPrivateUpdate',[login,password,option,value]);
end;
//================================================================================
procedure TDB.SendAuthKey(Connection: TConnection; CMD: TStrings; ToSendResult: Boolean; Pattern: string);
var
  Login,password,email,AuthKey,oldemail,errmsg: string;
  res: Boolean;
begin
  if CMD.Count<4 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;
  Login:=CMD[1];
  Password:=CMD[2];
  Email:=CMD[3];
  AuthKey:=GetAuthKey(Login);
  oldemail:=GetEmail(login);
  if oldemail<>email then
    UpdateLoginPrivate(Login,Password,'email',email);
  res:=SendPatternMail(email,Pattern,
    ['%login%',Login,'%password%',Password,'%key%',AuthKey],
    ErrMsg);

  if res then
    fSocket.Send(Connection,[DP_AUTH_KEY_REQ_RESULT,'0','Confirmation key was successfully sent to you email'])
  else
    fSocket.Send(Connection,[DP_AUTH_KEY_REQ_RESULT,'1',
      'Server could not send confirmation key. Your login is temporary activated until server will send it.']);

  UpdateLoginPrivate(Login,Password,'sent',BoolTo_(res,1,0));
end;
//================================================================================
procedure TDB.KeyConfirm(Connection: TConnection; CMD: TStrings);
var
  Login,Password,msg: string;
  res: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login:=CMD[1];
  Password:=GetPassword(Login);
  res:=UpdateLoginPrivate(Login,Password,'confirmed',1);
  case res of
     5: msg:='Login confirmed successfully';
    -1: msg:='Wrong login';
    -2: msg:='Wrong password';
  end;
  fSocket.Send(Connection,[DP_SERVER_MSG,BoolTo_(res=5,DP_ERR_0,DP_ERR_2),msg]);
end;
//================================================================================
function TDB.GetPassword(Handle: string): string;
var
  err: string;
  sl: TStringList;
begin
  sl:=TStringList.Create;
  ReadProcList('dbo.proc_LoginInfo',[Handle],
    '%s',[3],sl,err);

  if (err<>'') or (sl.Count = 0) then result:=''
  else result:=sl[0];

  sl.Free;
end;
//================================================================================
procedure TDB.UserSendPassword(Connection: TConnection; CMD: TStrings);
var
  Login,Password,email,ErrMsg: string;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;
  Login:=CMD[1];
  Password:=GetPassword(Login);
  email:=GetEmail(Login);
  if SendPatternMail(email,'password',
    ['%login%',Login,'%password%',Password], ErrMsg)
  then
    fSocket.Send(Connection,[DP_PASS_FORGOT_RES,'0','Password successfully sent to your email'])
  else
    fSocket.Send(Connection,[DP_PASS_FORGOT_RES,'1','Server temporary cannot send password. Please, try later.']);

end;
//================================================================================
procedure TDB.GetLastBanRecord(const Login: string; const BanType: TBanType;
  var admin: string; var type_: integer;
  var date_: TDateTime; var hours: integer);
var
  err: string;
  FRst: _Recordset;
begin
  OpenRecordset('dbo.proc_LastBanRecord', [Login, BanType], FRst);

  if FRst.Eof then begin
    admin:=''; type_:=-1; date_:=0; hours:=0;
  end else begin
    admin:=FRst.Fields[2].Value;
    type_:=FRst.Fields[4].Value;
    date_:=FRst.Fields[3].Value;
    hours:=nvl(FRst.Fields[6].Value,0);
  end;
  FRst := nil;
end;
//================================================================================
procedure TDB.Init;
begin
  SLVars:=TStringList.Create;
  ReadVars;
  ErrLog('ReadVars completed', nil);
  ReadStatTypes;
  ErrLog('ReadStatTypes completed', nil);
  ReadClubs;
  ErrLog('ReadClubs completed', nil);
  ReadActions;
  ErrLog('ReadActions completed', nil);
  ReadTimeOddsLimits(nil);
  ErrLog('ReadTimeOddsLimits completed', nil);

  Logoff(nil);
  ErrLog('Logoff completed', nil);
  SetServerOnline;
end;
//================================================================================
function TDB.IsBanned(const Login: string; const BanType: TBanType; var DateUntil: TDateTime): Boolean;
var
  admin: string;
  type_,hours: integer;
  date_: TDateTime;
begin
  GetLastBanRecord(Login,BanType,admin,type_,date_,hours);
  result:=(type_ = 1) and (date_+hours/24.0>date+time);

  if not result and (type_ = 1) then
    ExecProc('dbo.proc_BanHistory',[Login,'server',2,BanType,null,null]);

  if result then DateUntil:=date_+hours/24.0
  else DateUntil:=0;
end;
//================================================================================
function TDB.EventBan(const Login, Admin: string; Hours,
  type_: integer): Integer;
begin
  result := ExecProc('dbo.proc_BanHistory',[Login,Admin,type_,3, Hours, null]);
end;
//================================================================================
procedure TDB.AddChatLog(const dt: TDateTime; Login, PlaceType, SayType, Place, Str: string);
begin
  if not SAVE_CHAT_LOG then exit;
  ExecProc('dbo.proc_AddChatLog',
    [dt, Login, PlaceType, SayType, Place, Str]);
end;
//================================================================================
procedure TDB.ChangePassword(var Connection: TConnection; var CMD: TStrings);
var
  Login, OldPassword, NewPassword: string;
  res, TestOldPassword: integer;
begin
  if CMD.Count<4 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login := CMD[1];
  OldPassword := CMD[2];
  NewPassword := CMD[3];
  if Connection.AdminLevel = alSuper then
    TestOldPassword := 0
  else
    TestOldPassword := 1;

  if (lowercase(Login) <> lowercase(Connection.Handle)) and (Connection.AdminLevel < alSuper) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Only superadmins can change password for another user']);
    exit;
  end;

  try
    res:=ExecProc('dbo.proc_ChangePassword', [Login, OldPassword, NewPassword, TestOldPassword]);
    case res of
      0: fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Password changed successfully']);
      -1: fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Login '+login+ ' does not exists']);
      -2: fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Incorrect old password']);
    end;
  except
    on E: Exception do
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Cannot change password because of db error: '+E.Message]);
  end;
end;
//================================================================================
procedure TDB.SetAdult(Connection: TConnection; CMD: TStrings);
var
  Login: string;
  AdultType: TAdultType;
  conn: TConnection;
  admin, res: integer;
begin
  if CMD.Count<3 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login:=CMD[1];
  AdultType:=TAdultType(StrToInt(CMD[2]));

  if (lowercase(Login)<>lowercase(Connection.Handle)) and (Connection.AdminLevel < alNormal) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
    exit;
  end;

  if Connection.AdminLevel >= alNormal then admin:=1
  else admin:=0;

  res:=ExecProc('dbo.proc_SetAdult',[Login,ord(AdultType),admin]);
  case res of
    -1: fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Player '+Login+' does not exist']);
    -2: fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ADMIN_ONLY]);
     0:
      begin
        conn:=fConnections.GetConnection(Login);
        if conn <> nil then begin
          conn.Adult := AdultType;
          {if conn.Adult = adtChild then
            fRooms.ExitRoom(conn,ADULT_ROOM_NUMBER);}
        end;
        if (lowercase(Login)<>lowercase(Connection.Handle)) then
          fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Command successfully completed'])
        else
          fSocket.Send(Connection, [DP_ADULT, IntToStr(ord(AdultType))]);
      end;
  end;
end;
//================================================================================
procedure TDB.ReadStatTypes;
var
  sl, slRes: TStringList;
  err: string;
  i: integer;
  st: TStatType;
begin
  sl:=TStringList.Create;
  slRes:=TStringList.Create;
  try
    ReadProcList('dbo.proc_GetStatTypes',[],'%s@%s@%s@%s',[1,2,3,4],slRes,err);{<>0 then begin
      showmessage(err);
      exit;
    end;}
    fStatTypes.Clear;
    for i:=0 to slRes.Count-1 do begin
      Str2StringList(slRes[i],sl,'@');
      if sl.Count < 4 then begin
        ErrLog('Wrong stat type number '+IntToStr(i), nil, 'fDB.ReadStatTypes');
        continue;
      end;
      st:=TStatType.Create;
      st.Name:=sl[0];
      st.Description:=sl[1];
      st.Params:=sl[2];
      st.ParamNames:=sl[3];
      fStatTypes.Add(st);
    end;
  finally
    sl.Free;
    slRes.Free;
  end;
end;
//================================================================================
procedure TDB.SendStatTypes(Connection: TConnection);
var
  i: integer;
  st: TStatType;
begin
  fSocket.Send(Connection, [DP_STATTYPE_BEGIN]);
  for i:=0 to fStatTypes.Count-1 do begin
    st:=TStatType(fStatTypes[i]);
    fSocket.Send(Connection, [DP_STATTYPE,st.Name,st.Description,st.Params,st.ParamNames]);
  end;
  fSocket.Send(Connection, [DP_STATTYPE_END]);
end;
//================================================================================
procedure TDB.CMD_Stat(Connection: TConnection; var CMD: TStrings);
var
  nType,nFields,i, PaidOnly: integer;
  DateFrom, DateTo: TDateTime;
  sName,sHeaders,sParam: string;
  RecsAffected: OleVariant;
  Par: array of string;
  v: Variant;
  FRst: _Recordset;
begin
  if CMD.Count<4 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;
  nType:=StrToInt(CMD[1]);
  DateFrom:=Str2Float(CMD[2]);
  DateTo:=Str2Float(CMD[3]);

  if (CMD.Count < 5) or (CMD[4] = '%') then sParam := ''
  else sParam := CMD[4];

  if CMD.Count < 6 then PaidOnly := 0
  else PaidOnly := StrToInt(CMD[5]);

  if DateFrom>DateTo then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Second date must be greater then first']);
    exit;
  end;

  OpenRecordset('dbo.proc_GetStat',
    [nType, DateFrom, DateTo, sParam, PaidOnly], FRst);

  if not Assigned(FRst) or (FRst.State <> adStateOpen) or (FRst.BOF) then exit;

  sName:=FRst.Fields[0].Value;
  sHeaders:=FRst.Fields[1].Value;
  nFields:=CountChars(sHeaders,',')+1;
  SetLength(Par,nFields+1);
  Par[0]:=DP_STAT;

  fSocket.Send(Connection,[DP_STAT_BEGIN,sName,sHeaders]);

  while true do begin
    FRst := FRst.NextRecordset(RecsAffected);
    if not Assigned(FRst) or (FRst.State <> adStateOpen) or (FRst.BOF) then break;

    while not FRst.EOF do begin
      for i:=1 to nFields do begin
        v:=FRst.Fields[i-1].Value;
        Par[i]:=Var2String(v);
      end;
      fSocket.Send(Connection,Par);
      FRst.MoveNext;
    end;
  end;
  fSocket.Send(Connection,[DP_STAT_END]);
  FRst := nil;
end;
//================================================================================
function TDB.GetShoutMessage(Connection: TConnection): string;
var
  res: integer;
  FRst: _Recordset;
begin

  res := OpenRecordset('dbo.proc_GetShoutMessage', [Connection.LoginID], FRst);
  if res = -1 then result:=''
  else begin
    if (FRst.State = adStateOpen) and not (FRst.BOF) then
      result:=FRst.Fields[0].Value;
      FRst.Close;
      FRst:=nil;
  end;
  FRst := nil;
end;
//================================================================================
procedure TDB.CMD_SetGreetings(Connection: TConnection; CMD: TStrings);
var
  i,res: integer;
  msg: string;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  msg:='';
  for i:=2 to CMD.Count-1 do
    msg:=msg+CMD[i]+' ';
  res:=ExecProc('dbo.proc_SetGreetings',[CMD[1],msg]);

  if res = -1 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'User '+CMD[1]+' is not found'])
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Greetings message is successfully set']);

end;
//================================================================================
procedure TDB.CMD_ShowGreetings(Connection: TConnection; CMD: TStrings);
var
  par,err: string;
  i: integer;
  res: Variant;
  slRes: TStringList;
begin
  if CMD.Count<2 then
    par:='-'
  else
    par:=CMD[1];

  slRes:=TStringList.Create;

  res:=ReadProcList('dbo.proc_ShowGreetings',[par],
    '%s (%s): %s',[1,2,3],slRes,err);

  if slRes.Count = 0 then
    fSocket.Send(Connection,['No greeting message for this user'])
  else begin
    for i:=0 to slRes.Count-1 do
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,slRes[i]]);
  end;

  slRes.Free;
end;
//================================================================================
procedure TDB.CMD_Clubs(Connection: TConnection; CMD: TStrings);
begin
  SendProcList(Connection, 'dbo.proc_ShowClubs',[],
    '#%d: %s',[0,1],true);
end;
//================================================================================
procedure TDB.CMD_Club(Connection: TConnection; CMD: TStrings);
var
  id, i, nStart, ClubType: integer;
  name: string;
begin
  if CMD.Count < 3 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Incorrect number']);
    exit;
  end;
  name:='';

  if (CMD[2] = '0') or (CMD[2] = '1') then begin
    ClubType := StrToInt(CMD[2]);
    nStart := 3;
  end else begin
    ClubType := 0;
    nStart := 2;
  end;

  for i := nStart to CMD.Count-1 do
    name:=name+CMD[i]+' ';
  try
    ExecProc('dbo.proc_SetClub',[id, name, ClubType]);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Club list is changed successfully']);
  except
    on E:Exception do
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,E.Message]);
  end;
  ReadClubs;
  fConnections.SendClubList(fConnections.Connections);
end;
//================================================================================
procedure TDB.CMD_ClubMembers(Connection: TConnection; CMD: TStrings);
var
  id: integer;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Incorrect number']);
    exit;
  end;

  if id = 1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Cannot show members of main club']);
    exit;
  end;

  SendProcList(Connection,'dbo.proc_ClubMembers',[id],
    '%s %s',[0,1],true);
end;
//================================================================================
procedure TDB.CMD_ClubRemove(Connection: TConnection; CMD: TStrings);
var
  id, res: integer;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    id:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Incorrect number']);
    exit;
  end;

  if id = 1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Cannot delete main club']);
    exit;
  end;

  res:=ExecProc('dbo.proc_DeleteClub',[id]);
  case res of
     0: fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Club is deleted successfully']);
    -2: fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Club does not exists']);
  end;
  ReadClubs;
  fConnections.SendClubList(fConnections.Connections);
end;
//================================================================================
procedure TDB.CMD_UserClub(Connection: TConnection; CMD: TStrings);
var
  name: string;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  name:=CMD[1];
  SendProcList(Connection,'dbo.proc_UserClub',[name],
    'Current club is #%d: %s', [0,1], false);
end;
//================================================================================
procedure TDB.CMD_SetUserClub(Connection: TConnection; CMD: TStrings);
var
  id, res: integer;
  name: string;
begin
  if CMD.Count < 3 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  name:=CMD[1];
  try
    id:=StrToInt(CMD[2]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Incorrect number']);
    exit;
  end;

  if (Connection.AdminLevel < alSuper) and (id <> Connection.ClubId) and (id<>1) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'You can set only your club or main club as parameter.']);
    exit;
  end;

  res:=ExecProc('dbo.proc_SetClubId',[name,id]);
  case res of
     0: fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Club of user '+name+'is successfully set']);
    -1: fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'User does not exists']);
    -2: fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Club does not exists']);
    -3: fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'User is already has this club as current']);
  end;
end;
//================================================================================
procedure TDB.ReadClubs;
var
  res: integer;
  Club: TClub;
  FRst: _Recordset;
begin
  if not Assigned(fClubs) then
      fClubs:=TClubs.Create;

  fClubs.Clear;

  OpenRecordset('dbo.proc_ShowClubs', [], FRst);

  if (FRst.State = adStateOpen) and not (FRst.BOF) then
    while not FRst.EOF do begin
      Club := TClub.Create;
      Club.id := FRst.Fields[0].Value;
      Club.name := FRst.Fields[1].Value;
      Club.info := nvl(FRst.Fields[2].Value, '');
      Club.requests := FRst.Fields[3].Value;
      Club.sponsor := nvl(FRst.Fields[4].Value, '');
      Club.clubtype := TClubType(FRst.Fields[5].Value);
      Club.members := FRst.Fields[6].Value;
      fClubs.Add(Club);
      FRst.MoveNext;
    end;

  if Assigned(fConnections) then
    fConnections.SendClubList(fConnections.Connections);

  FRst := nil;
end;
//================================================================================
procedure TDB.CMD_ClubStatus(Connection: TConnection; CMD: TStrings);
var
  ClubId, StatusId, res: integer;
  name: string;
  conn: TConnection;
begin
  if CMD.Count < 4 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  if Connection.MembershipType = mmbNone then begin
    Connection.SendNoMembershipMsg(DP_MSG_NO_CLUBS);
    exit;
  end;

  name:=CMD[1];
  try
    ClubId:=StrToInt(CMD[2]);
    StatusId:=StrToInt(CMD[3]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Incorrect number']);
    exit;
  end;

  res:=ExecProc('dbo.proc_SetLoginClub',[Connection.LoginId, name, ClubId, StatusId]);
  case res of
     0:
       begin
         //fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'Operation completed successfully']);
         if StatusId = 4 then
           SendClubMembers(Connection,ClubId)
         else
           fSocket.Send(Connection,[DP_CLUB_STATUS,name,IntToStr(ClubId),IntToStr(StatusId)]);
         if lowercase(Connection.Handle) <> lowercase(name) then begin
           conn:=fConnections.GetConnection(name);
           if conn<>nil then
             fSocket.Send(conn,[DP_CLUB_STATUS,name,IntToStr(ClubId),IntToStr(StatusId)]);
         end;
       end;
    -1: fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Club does not exists']);
    -2: fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'User does not exists']);
    -3: fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Insufficient privileges']);
  end;
end;
//================================================================================
procedure TDB.CMD_GetClubMembers(Connection: TConnection; CMD: TStrings);
var
  ClubId: integer;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    ClubId:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number']);
    exit;
  end;
  SendClubMembers(Connection,ClubId);
end;
//================================================================================
procedure TDB.SendClubMembers(Connection: TConnection; ClubId: integer);
var
  slRes,sl: TStringList;
  res,i: integer;
  err: string;
begin
  slRes:=TStringList.Create;
  sl:=TStringList.Create;
  try
    res:=ReadProcList('dbo.proc_ClubMembers',[ClubId],'%d,%s,%s,%d',
      [0,1,2,3],slRes,err);

    if err<>'' then begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, err]);
      exit;
    end;

    if res = -1 then begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Club does not exists']);
      exit;
    end;

    fSocket.Send(Connection,[DP_CLUB_MEMBERS_BEGIN,IntToStr(ClubId)]);
    for i:=0 to slRes.Count-1 do begin
      Str2StringList(slRes[i],sl);
      fSocket.Send(Connection,[DP_CLUB_MEMBER,IntToStr(ClubId),
        sl[0],sl[1],sl[2],sl[3]]);
    end;
    fSocket.Send(Connection,[DP_CLUB_MEMBERS_END,IntToStr(ClubId)]);

  finally
    slRes.Free;
    sl.Free;
  end;
end;
//================================================================================
procedure TDB.CMD_ClubInfo(Connection: TConnection; CMD: TStrings);
var
  ClubId, StatusId, res, i,n: integer;
  info: string;
begin
  if CMD.Count < 3 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    ClubId:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Incorrect number']);
    exit;
  end;
  info:=CMD[2];
  for i:=3 to CMD.Count-1 do
    info:=info+' '+CMD[i];

  repeat
    n:=pos('|',info);
    if n>0 then
      info:=copy(info,1,n-1)+#13#10+copy(info,n+1,length(info));
    until n = 0;

  res:=ExecProc('dbo.proc_SetClubInfo',[Connection.LoginId, ClubId, info]);
  fSocket.Send(fConnections.Connections,[DP_CLUB_INFO,IntToStr(ClubId),info],nil);
end;
//================================================================================
procedure TDB.CMD_ClubOptions(Connection: TConnection; CMD: TStrings);
var
  ClubId, StatusId, res, i,n: integer;
  requests: Boolean;
  sponsor: string;
begin
  if CMD.Count < 3 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    ClubId:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Incorrect number']);
    exit;
  end;
  requests := CMD[2] = '1';

  if CMD.Count < 4 then sponsor := ''
  else sponsor := Replace(CMD[3], '_', ' ');

  res:=ExecProc('dbo.proc_SetClubOptions',[Connection.LoginId, ClubId, CMD[2], sponsor]);
  if res = 0 then
    fSocket.Send(fConnections.Connections,[DP_CLUB_OPTIONS,IntToStr(ClubId),CMD[2],sponsor],nil);
end;
//================================================================================
procedure TDB.CMD_GameSearch(Connection: TConnection; CMD: TStrings);
var
  dtFrom,dtTo: TDateTime;
  res,nColor,nResult,nType,nPage: integer;
  ECO, Login, Opponent, ECODesc: string;
  RecsAffected: OleVariant;
  FRst: _Recordset;
begin
  if CMD.Count < 9 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    Login:=CMD[1];
    dtFrom:=StrToInt(CMD[2]);
    dtTo:=StrToInt(CMD[3]);
    nColor:=StrToInt(CMD[4]);
    nResult:=StrToInt(CMD[5]);
    nType:=StrToInt(CMD[6]);
    ECO:=CMD[7];
    Opponent:=CMD[8];
    nPage:=StrToInt(CMD[9]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Incorrect parameters datatype']);
    exit;
  end;

  try
    res := OpenRecordSet('dbo.proc_GameSearch',
     [Login, dtFrom, dtTo, nColor, nResult, nType, ECO, Opponent, nPage], FRst);
    if res = -1 then begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Login '+Login+' does not exists']);
      exit;
    end;
    if res = -2 then begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Login '+Opponent+' does not exists']);
      exit;
    end;

    fSocket.Send(Connection, [DP_PROFILE_RECENT_CLEAR, Login]);
    if (FRst.State = adStateOpen) and not (FRst.BOF) then
      while not FRst.EOF do
        begin
          EcoDesc:=fDB.GetEcoDesc(FRst.Fields[8].Value);
          fSocket.Send(Connection, [DP_PROFILE_GAME, '0', Login, '',
            IntToStr(FRst.Fields[0].Value),
            IntToStr(FRst.Fields[1].Value),
            FRst.Fields[19].value, FRst.Fields[20].value,
            IntToStr(FRst.Fields[22].Value),
            IntToStr(FRst.Fields[21].Value),
            FRst.Fields[3].Value, FRst.Fields[4].Value,
            IntToStr(FRst.Fields[6].Value),
            IntToStr(FRst.Fields[5].Value),
            IntToStr(FRst.Fields[14].Value),
            IntToStr(FRst.Fields[11].Value),
            IntToStr(FRst.Fields[12].Value),
            IntToStr(FRst.Fields[13].Value),
            IntToStr(FRst.Fields[15].Value),
            FRst.Fields[8].Value,
            FRst.Fields[7].Value,
            IntToStr(FRst.Fields[23].Value),
            EcoDesc]);

          FRst.MoveNext;
        end;
    { Send the Pages Count }
    FRst := FRst.NextRecordset(RecsAffected);
    if (FRst.State = adStateOpen) and not (FRst.BOF) then
      fSocket.Send(Connection, [DP_PROFILE_PAGES, Login,
        IntToStr(FRst.Fields[0].Value)]);
  except
    on E: Exception do
      exit;
  end;
  FRst := nil;
end;
//================================================================================
function TDB.GetLoginInfo(Login: string; RatedType: TRatedType; var LoginId, Rating: integer;
  var RealLogin, Title: string): Boolean;
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
  res: integer;
begin
  result:=false;
  res := OpenRecordset('dbo.proc_GetLoginInfo', [Login, RatedType], Rst);

  if res = -1 then exit;

  if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then exit;

  LoginId := Rst.Fields[0].Value;
  RealLogin := Rst.Fields[1].Value;
  Title := Rst.Fields[2].Value;
  Rating := Rst.Fields[3].Value;
  Rst := nil;
  result := true;
end;
//================================================================================
procedure TDB.CMD_AdminLevel(Connection: TConnection; CMD: TStrings);
var
  Login: string;
  res: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login:=CMD[1];

  res:=ExecProc('dbo.proc_AdminLevel',[Login]);
  if res = -1 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Login does not exists'])
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, Login+' has admin level '+IntToStr(res)]);
end;
//================================================================================
procedure TDB.CMD_Admins(Connection: TConnection; CMD: TStrings);
var
  AdminLevel,res: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    AdminLevel:=StrToInt(CMD[1]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number']);
    exit;
  end;

  if (AdminLevel < 1) or (AdminLevel>3) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Admin level must be between 1 and 3']);
    exit;
  end;

  SendProcList(Connection,'dbo.proc_Admins',[AdminLevel],'%s',[0],true);
end;
//================================================================================
procedure TDB.CMD_SetAdminLevel(Connection: TConnection; CMD: TStrings);
var
  Login: string;
  AdminLevel, res: integer;
begin
  if CMD.Count<3 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login:=CMD[1];
  try
    AdminLevel:=StrToInt(CMD[2]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number']);
    exit;
  end;

  if (AdminLevel < 0) or (AdminLevel>3) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Admin level must be between 0 and 3']);
    exit;
  end;

  res:=ExecProc('dbo.proc_SetAdminLevel',[Login,AdminLevel]);
  if res = -1 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Login does not exists'])
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Admin level set successfully']);
end;
//================================================================================
procedure TDB.CMD_Score(Connection: TConnection; CMD: TStrings);
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
  Login1, Login2: string;
  res,Win,Lost,Draw,WinTotal,LostTotal,DrawTotal: integer;
  RatedType: TRatedType;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  if CMD.Count < 3 then begin
    Login1:=Connection.Handle;
    Login2:=CMD[1];
  end else begin
    Login1:=CMD[1];
    Login2:=CMD[2];
  end;

  res := OpenRecordset('dbo.proc_GetScore', [Login1, Login2], Rst);

  if res = -1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'User '+Login1+' does not exist']);
    exit;
  end;

  if res = -2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'User '+Login2+' does not exist']);
    exit;
  end;

  if not Assigned(Rst) or (Rst.State <> adStateOpen) then exit;

  if Rst.Eof then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Login1+' did not play with '+Login2]);
    exit;
  end;

  WinTotal:=0; LostTotal:=0; DrawTotal:=0;
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, Login1+' vs '+Login2+' score']);
  while not Rst.Eof do begin
    RatedType:=TRatedType(Rst.Fields[0].Value);
    Win:=Rst.Fields[1].Value;
    Lost:=Rst.Fields[2].Value;
    Draw:=Rst.Fields[3].Value;

    WinTotal:=WinTotal+Win;
    LostTotal:=LostTotal+Lost;
    DrawTotal:=DrawTotal+Draw;
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, Format('%s: +%d -%d =%d',
      [RatedType2Str(RatedType),Win,Lost,Draw])]);
    Rst.MoveNext;
  end;
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, '----------------------']);
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, Format('%s: +%d -%d =%d',
    ['Total',WinTotal,LostTotal,DrawTotal])]);
  Rst:=nil;
end;
//================================================================================
procedure TDB.GetGameScore(LoginId1, LoginId2: integer; RatedType: TRatedType; var Score: TPersonalScore);
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
begin
  Score.Defined:=false;
  try
    OpenRecordset('dbo.proc_GetScore2', [LoginId1, LoginId2, RatedType], Rst);

    if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then exit;
    Score.Win := nvl(Rst.Fields[0].Value, 0);
    Score.Lost := nvl(Rst.Fields[1].Value, 0);
    Score.Draw := nvl(Rst.Fields[2].Value, 0);
    Score.Defined:=true;
  except
  end;
end;
//================================================================================
function TDB.IsMemberOf(Login, Role: string): Boolean;
var
  sl: TStringList;
  err: string;
  i: integer;
begin
  result:=false;
  sl:=TStringList.Create;
  Role:=lowercase(role);
  if ReadProcList('dbo.proc_ShowRoles',[Login],'%s',[0],sl,err) then exit;
  for i:=0 to sl.Count-1 do
    if lowercase(sl[i]) = role then begin
      result:=true;
      exit;
    end;
  sl.Free;
end;
//================================================================================
function TDB.SaveEvent(ev: TCSEvent): Boolean;
var
  i, id: integer;
  odds: TCSOdds;
begin
  try
    if ev.ID<0 then id:=0
    else id:=ev.ID;

    id:=ExecProc('dbo.proc_events',
      [id,
       ev.name,
       ord(ev.type_),
       ev.StartTime,
       ev.Leaders.CommaText,
       ev.Description,
       ev.MinRating,
       ev.MaxRating,
       ev.MaxGamesCount,
       ev.InitialTime,
       ev.IncTime,
       ev.TimeLimit,
       ev.ShoutStart,
       ev.ShoutInc,
       ev.ShoutMsg,
       ord(ev.RatedType),
       ev.Creator,
       BoolTo_(ev.Rated,1,0),
       BoolTo_(ev.ProvisionalAllowed,1,0),
       ev.MinPeople,
       ev.MaxPeople,
       BoolTo_(ev.AdminTitledOnly,1,0),
       ev.CongrMsg,
       ev.ClubList
      ]);
    if ev.ID <= 0 then ev.ID:=id;

    for i:=0 to ev.OddsList.Count-1 do begin
      odds:=TCSOdds(ev.OddsList[i]);
      fDB.ExecProc('dbo.proc_ev_odds',
        [id,
         odds.Rating,
         odds.InitTime,
         odds.IncTime,
         odds.Pieces]);
    end;

    for i:=0 to ev.Tickets.Count-1 do begin
      fDB.ExecProc('dbo.proc_ev_tickets',
        [id,
         ev.Tickets[i].Login]);
    end;
    result:=true;
  except
    on E:Exception do
      result:=false;
  end;
end;
//================================================================================
procedure TDB.SaveGame(GM: TGame);
const
  PROC_ADDGAME = 'dbo.proc_GameHeaderAdd';
  PROC_ADDMOVE = 'dbo.proc_GameMoveAdd';
  PROC_ECOUPDATE = 'dbo.proc_GameECOUpdate';
var
  Move: TMove;
  GameID, i: integer;
begin
  GameID := ExecProc('dbo.proc_GameHeaderAdd',
   [GM.BlackId, GM.BlackMSec, GM.BlackRating,
    GM.Date, GM.Event, GM.FEN,
    GM.WhiteInitialMSec, GM.WhiteIncMSec,
    GM.Rated, GM.RatedType, GM.GameResult,
    GM.Round, GM.Site,
    GM.WhiteID, GM.WhiteMSec, GM.WhiteRating,
    GM.BlackInitialMSec, GM.BlackIncMSec,
    GM.StartTime, GM.EndTime
   ]);

  if GameID < 1 then exit;

  for i := 1 to GM.Moves.Count - 1 do begin
    Move := GM.Moves[i];
    ExecProc('dbo.proc_GameMoveAdd',
     [GameID, i, Move.FFrom, Move.FTo, Move.Promo,
      Move.FType, Move.FPGN, MOve.FMSec2]);
  end;

  ExecProc('dbo.proc_GameECOUpdate', [GameID]);
  if GM.Odds.Defined or GM.Odds.FAutoTimeOdds then
    ExecProc('dbo.proc_GameOdds',
     [GameID, BoolTo01(GM.Odds.FAutoTimeOdds),
      GM.Odds.FInitMin, GM.Odds.FInitSec,
      GM.Odds.FInc, GM.Odds.FPiece,
      GM.Odds.FTimeDirection, GM.Odds.FPieceDirection,
      GM.Odds.FInitiator, GM.TimeOddsScoreDeviation]);
end;
//================================================================================
procedure TDB.EventDelete(ID: integer);
begin
  fDB.ExecProc('dbo.proc_ev_delete',[ID]);
end;
//================================================================================
procedure TDB.CMD_ShowNames(var Connection: TConnection;
  var CMD: TStrings);
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
  login,s,sDate1,sDate2: string;
  dt1,dt2: TDateTime;
  res,n,cnt: integer;
begin
  if CMD.Count<>2 then
    begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Usage:']);
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,CMD[0]+' <ip_address>']);
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,CMD[0]+' <mac-address>']);
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,CMD[0]+' <username>']);
      exit;
    end;

  res := OpenRecordset('dbo.proc_ShowNames', [CMD[1]], Rst);

  if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'no records']);
      exit;
    end;

  n:=0;
  while not Rst.EOF do
    begin
      Login:=Rst.Fields[0].Value;
      dt1:=Rst.Fields[1].Value;
      dt2:=Rst.Fields[2].Value;
      cnt:=Rst.Fields[3].Value;
      sDate1:=FormatDateTime('mm/dd/yyyy',dt1);
      sDate2:=FormatDateTime('mm/dd/yyyy',dt2);
      s:=Format('%s: %d times from %s to %s',[Login,cnt,sDate1,sDate2]);
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,s]);
      inc(n);
      Rst.MoveNext;
    end;
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'------------------']);
    fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,IntToStr(n)+' logins total']);
  Rst := nil;
end;
//================================================================================
procedure TDB.CMD_ShowAddressHistory(var Connection: TConnection;
  var CMD: TStrings);
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
  name,s,sDate1,sDate2: string;
  dt1,dt2: TDateTime;
  res,n,cnt: integer;
begin
  if CMD.Count<>2 then
    begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_2,'Usage:'+CMD[0]+' <username>']);
      exit;
    end;

  res := OpenRecordset('dbo.proc_ShowAddressHistory', [CMD[1]], Rst);

  if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'no records']);
      exit;
    end;

  n:=0;
  while not Rst.EOF do
    begin
      name:=Rst.Fields[0].Value;
      dt1:=Rst.Fields[1].Value;
      dt2:=Rst.Fields[2].Value;
      cnt:=Rst.Fields[3].Value;
      sDate1:=FormatDateTime('mm/dd/yyyy',dt1);
      sDate2:=FormatDateTime('mm/dd/yyyy',dt2);
      s:=Format('%s: %d times from %s to %s',[name,cnt,sDate1,sDate2]);
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,s]);
      inc(n);
      Rst.MoveNext;
    end;
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'------------------']);
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,IntToStr(n)+' ip_addresses total']);

  Rst := Rst.NextRecordset(RecsAffected);
  if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'no records']);
      exit;
    end;

  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,' ']);
  n:=0;
  while not Rst.EOF do
    begin
      name:=Rst.Fields[0].Value;
      dt1:=Rst.Fields[1].Value;
      dt2:=Rst.Fields[2].Value;
      cnt:=Rst.Fields[3].Value;
      sDate1:=FormatDateTime('mm/dd/yyyy',dt1);
      sDate2:=FormatDateTime('mm/dd/yyyy',dt2);
      s:=Format('%s: %d times from %s to %s',[name,cnt,sDate1,sDate2]);
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,s]);
      inc(n);
      Rst.MoveNext;
    end;
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,'------------------']);
  fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_0,IntToStr(n)+' mac-addresses total']);

  Rst := nil;
end;
//================================================================================
function TDB.GetLoginId(Login: string): integer; // -1 if login does not exists
begin
  result := ExecProc('dbo.proc_GetLoginId',[Login]);
end;
//================================================================================
function TDB.GetNotes(LoginId: integer): string;
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
begin
  OpenRecordset('dbo.proc_GetLoginNotes', [LoginId], Rst);

  if not Assigned(Rst) or (Rst.State <> adStateOpen) or (Rst.BOF) then
    result := ''
  else
    result := nvl(Rst.Fields[0].Value,'');

  Rst := nil;
end;
//================================================================================
procedure TDB.CMD_BanProfile(Connection: TConnection; CMD: TStrings;
  Direction: Boolean);
var
  s, Login: string;
  Hours: integer;
  conn: TConnection;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login := CMD[1];
  if GetLoginId(Login) = -1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'User '+Login+' does not exists']);
    exit;
  end;

  if CMD.Count < 3 then Hours:=UNLIMITED_BAN_TIME
  else
    try
      Hours := StrToInt(CMD[2]);
    except
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number format']);
      Exit;
    end;

  if (Connection.AdminLevel<alSuper) and (Hours>MAX_BAN_TIME) then
    Hours:=MAX_BAN_TIME;


  ExecProc('dbo.proc_BanHistory',[Login, Connection.Handle, BoolTo_(Direction, '1', '2'),
    ord(banProfile), Hours]);


  s:=BoolTo_(Direction,'','un');
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'User '+Login+' was '+s+'banned for editing profile successfully']);

  conn := fConnections.GetConnection(Login);
  if conn <> nil then begin
    conn.Rights.SelfProfile := not Direction;
    conn.SendRights;
  end;
end;
//================================================================================
procedure TDB.SetServerOnline;
begin
  ExecProc('dbo.proc_ServerOnline', []);
end;
//================================================================================
procedure TDB.SaveUsersOnline;
var
  i, total, admins, games: integer;
  game: TGame;
  conn: TConnection;
begin

  total := 0; admins := 0; games := 0;
  for i:=0 to fConnections.Connections.Count-1 do begin
    conn := TConnection(fConnections.Connections[i]);
    if conn <> nil then begin
      inc(total);
      if conn.AdminLevel > alNone then
        inc(admins);
    end;
  end;

  for i:=0 to fGames.Games.Count-1 do begin
    game := TGame(fGames.Games[i]);
    if (game.GameMode = gmLive) and (game.GameResult = grNone) then
      inc(games);
  end;

  ExecProc('dbo.proc_UsersOnline',[total, admins, games]);
end;
//================================================================================
procedure TDB.SaveCommandsUsage(admin, command: string);
var
  name, params: string;
  n: integer;
begin
  if (command = '') or (command[1] <> '/') then exit;
  n := pos(' ', command);
  if n = 0 then begin
    name := copy(command, 2, length(command));
    params := '';
  end else begin
    name := copy(command, 2, n-2);
    params := copy(command, n+1, length(command));
  end;

  name := lowercase(name);
  if fCommand.CommandsZero.IndexOf(name) = -1 then
    ExecProc('dbo.proc_CommandsUsage',[admin, name, params]);
end;
//================================================================================
procedure TDB.CMD_MessageSearch(Connection: TConnection; CMD: TStrings);
var
  Login, Sender, Txt: string;
  nState, Page, res: integer;
  dtFrom,dtTo: TDateTime;
  RecsAffected: OleVariant;
  Rst: _RecordSet;
begin
  Login := CMD[1];
  Sender := CMD[2];
  nState := StrToInt(CMD[3]);
  dtFrom := StrToInt(CMD[4]);
  dtTo := StrToInt(CMD[5]);
  Txt := CMD[6];
  Page := StrToInt(CMD[7]);

  res := OpenRecordset('dbo.proc_MessageSearch',
    [Login, Sender, nState, dtFrom, dtTo, Txt, Page], Rst);

  fSocket.Send(Connection, [DP_MESSAGE_CLEAR]);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do
      begin
        fSocket.Send(Connection, [DP_MESSAGE2,
          IntToStr(Rst.Fields[0].Value),
          IntToStr(Rst.Fields[1].Value),
          Rst.Fields[2].Value,
          Rst.Fields[3].Value,
          IntToStr(Rst.Fields[4].Value),
          Rst.Fields[5].Value,
          Rst.Fields[6].Value,
          Rst.Fields[7].Value,
          Rst.Fields[8].Value,
          FormatDateTime('dd mmm yyyy',Rst.Fields[9].Value),
          IntToStr(Rst.Fields[10].Value)]);

        Rst.MoveNext;
      end;
  { Send the Pages Count }
  Rst := Rst.NextRecordset(RecsAffected);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    fSocket.Send(Connection, [DP_MESSAGE_PAGES, IntToStr(Rst.Fields[0].Value)]);
end;
//================================================================================
procedure TDB.CMD_MessageState(Connection: TConnection; CMD: TStrings);
var
  nMessageID, nState, res: integer;
begin
  if CMD.Count<3 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;
  nMessageID := StrToInt(CMD[1]);
  nState := StrToInt(CMD[2]);
  res:=ExecProc('dbo.proc_MessageState',[nMessageID, nState]);
  if res = -1 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'There is no message with id = '+IntToStr(nMessageID)]);
end;
//================================================================================
procedure TDB.CMD_MessageRetrieve(Connection: TConnection; CMD: TStrings);
var
  nMessageID, res: integer;
begin
  if CMD.Count<2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;
  nMessageID := StrToInt(CMD[1]);
  res:=ExecProc('dbo.proc_MessageRetrieve',[nMessageID]);
end;
//================================================================================
function TDB.CountNewMessages(LoginID: integer): integer;
begin
  result := ExecProc('dbo.proc_MessagesCountNew',[LoginID]);
end;
//================================================================================
procedure TDB.SendImages(Connection: TConnection);
var
  RecsAffected: OleVariant;
  Rst: _RecordSet;
begin
  OpenRecordset('dbo.proc_GetImages', [], Rst);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do begin
      fSocket.Send(Connection, [DP_IMAGE,
        IntToStr(Rst.Fields[0].Value),
        IntToStr(Rst.Fields[1].Value),
        IntToStr(Rst.Fields[2].Value),
        Rst.Fields[3].Value]);
      Rst.MoveNext;
    end;
  Rst := nil;
end;
//================================================================================
procedure TDB.CMD_SetImage(Connection: TConnection; CMD: TStrings);
var
  id, size_ver, size_hor: integer;
  img_ascii: string;
begin
  if CMD.Count < 5 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    id := StrToInt(CMD[1]);
    size_ver := StrToInt(CMD[2]);
    size_hor := StrToInt(CMD[3]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number']);
    exit;
  end;

  img_ascii := CMD[4];
  ExecProc('dbo.proc_SetImage',[id,size_ver,size_hor,img_ascii]);
end;
//================================================================================
procedure TDB.CMD_ClientError(Connection: TConnection; CMD: TStrings);
var
  i,source: integer;
  msg: string;
begin
  if CMD.Count < 6 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;
  try
    source := StrToInt(CMD[1]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number']);
    exit;
  end;

  msg := '';
  for i:=5 to CMD.Count-1 do
    msg:=msg+CMD[i]+' ';

  ExecProc('dbo.proc_ClientError',
    [Connection.Handle,
     Connection.Version,
     source,
     CMD[2], //procname
     CMD[3], //addr
     msg, //msg
     CMD[4]  //command
    ]);
end;
//================================================================================
procedure TDB.ReadAccessLevels;
var
  RecsAffected: OleVariant;
  Rst: _RecordSet;
begin
  fAccessLevels.Clear;
  OpenRecordset('dbo.proc_GetAccessLevels', [], Rst);

  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do begin
      fAccessLevels.AddLevel(Rst.Fields[0].Value,Rst.Fields[1].Value,Rst.Fields[2].Value);
      Rst.MoveNext;
    end;

  Rst := Rst.NextRecordset(RecsAffected);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do begin
      fAccessLevels.AddType(Rst.Fields[0].Value,Rst.Fields[1].Value,Rst.Fields[2].Value);
      Rst.MoveNext;
    end;

  Rst := Rst.NextRecordset(RecsAffected);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do begin
      fAccessLevels.AddLink(Rst.Fields[1].Value,Rst.Fields[2].Value,
        Rst.Fields[3].Value,Rst.Fields[4].Value);
      Rst.MoveNext;
    end;
  Rst := nil;
end;
//================================================================================
function TDB.IsMasterTitle(title: string): Boolean;
begin
  result := ExecProc('dbo.proc_IsMastertitle',[title]) = 1;
end;
//================================================================================
procedure TDB.SendVersionLink(Connection: TConnection; p_FirstLine: Boolean = true);
var
  RecsAffected: OleVariant;
  Rst: _RecordSet;
  version, weblink, exelink: string;
  i, res: integer;
  sl: TStringList;
begin
  res := OpenRecordset('dbo.proc_LastClientVersion', [Connection.Handle], Rst);
  if res <> 0 then exit;

  version := Rst.Fields[0].Value;
  weblink := Rst.Fields[1].Value;
  Connection.ProperVersion := version;
  Connection.IsOldVersion := (version > Connection.Version);
  if Connection.IsOldVersion then begin
    sl := TStringList.Create;
    if p_FirstLine then
      sl.Add('You use old version of infinia client!');
    sl.Add('1. Click here to download new version '+version+': "'+weblink+'"');
    sl.Add('2. Close the client');
    sl.Add('3. Click run and install the new update');
    sl.Add('4. Log in to Infinia Chess');

    for i := 0 to sl.Count - 1 do begin
      fSocket.Send(Connection,[DP_SERVER_MSG,DP_ERR_1,sl[i]]);
      fSocket.Send(Connection, [DP_TELL_ROOM, '2',
        'Server', '', sl[i], IntToStr(clYellow)]);
    end;

    if CompareVersion(Connection.Version, VERSION_CLIENT_UPDATE) >= 0 then
      fSocket.Send(Connection,[DP_CLIENT_UPDATE, version, weblink]);
    FreeAndNil(sl);
  end;
  Rst := nil;
end;
//================================================================================
procedure TDB.CMD_AdminGreetings(Connection: TConnection; CMD: TStrings);
var
  res: integer;
  Login: string;
  conn: TConnection;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  Login := CMD[1];
  conn := fConnections.GetConnection(Login);
  if conn = nil then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'User '+Login+' is not online']);
    exit;
  end;

  res := ExecProc('proc_AdminGreetings',[conn.LoginID]);
  if res = -1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'User '+Login+' has already got admin greetings']);
    exit;
  end;

  CMD.Add(ADMIN_GREETINGS);
  fConnections.CMD_Tell(Connection, CMD);
  fSocket.Send(fConnections.AdminConnections,[DP_NEWUSER_GREATED, Login], Connection);
end;
//================================================================================
procedure TDB.ReadTimeOddsLimits(Connection: TConnection);
var
  RecsAffected: OleVariant;
  Rst: _RecordSet;
  InitTime, IncTime, MinInitTime, MinIncTime: integer;
  MaxScoreDeviation, ScoreDeviationStart, ScoreDeviationEnd: integer;
begin
  try
    fTimeOddsLimits.Clear;
    OpenRecordset('dbo.proc_GetTimeOddsLimits', [], Rst);

    if (Rst.State = adStateOpen) and not (Rst.BOF) then
      while not Rst.EOF do begin
        InitTime := Rst.Fields[1].Value;
        IncTime := Rst.Fields[2].Value;
        MinInitTime := Rst.Fields[3].Value;
        MinIncTime := Rst.Fields[4].Value;
        MaxScoreDeviation := Rst.Fields[5].Value;
        ScoreDeviationStart := Rst.Fields[6].Value;
        ScoreDeviationEnd := Rst.Fields[7].Value;

        fTimeOddsLimits.AddLimit(InitTime, IncTIme, MinInitTime, MinIncTime,
          MaxScoreDeviation, ScoreDeviationStart, ScoreDeviationEnd);
        Rst.MoveNext;
      end;
    Rst := nil;
    if fConnections <> nil then
      fConnections.SendTimeOddsLimits(fConnections.Connections);
    if Connection <> nil then
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, 'Time odds data was successfully reloaded']);
  except
    on E:Exception do
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Error: ' + E.Message]);
  end;
end;
//================================================================================
procedure TDB.CMD_FullRecord(Connection: TConnection; CMD: TStrings);
var
  login, err: string;
  SL: TStringList;
  i, res: integer;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Usage: '+CMD[0]+' <login>']);
    exit;
  end;

  login := CMD[1];
  SL:=TStringList.Create;

  try
    res:=ReadProcList('dbo.proc_FullRecord', [login], '%s', [0], SL, err);
    if res = -1 then begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'User '+login+' does not exists']);
      exit;
    end;
    for i := 0 to SL.Count - 1 do
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, SL[i]]);
  finally
    SL.Free;
  end;

end;
//================================================================================
procedure TDB.CMD_Help(Connection: TConnection; CMD: TStrings);
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Usage: '+CMD[0]+' <command>']);
    exit;
  end;

  SendProcList(Connection,'dbo.proc_GetHelp',[CMD[1]],'%s',[0],false);
end;
//================================================================================
procedure TDB.SaveLagStat(p_Initiator, p_Operation, p_Params: string;
  p_MSec: integer);
begin
  if p_MSec > BAD_COMMAND_TIME_LIMIT then
    ExecProc('dbo.proc_SaveLagStat', [p_Initiator, p_Operation, p_Params, p_MSec]);
end;
//================================================================================
procedure TDB.SaveLectureAction(event_id, num, actiontype, param1: integer; param2: string);
begin
  ExecProc('dbo.proc_LectureActions',[event_id, num, actiontype, param1, param2]);
end;
//================================================================================
procedure TDB.SaveLogUserAction(p_ActionType: integer; p_Login, p_Info: string);
begin
  ExecProc('dbo.proc_LogUserAction', [p_ActionType, p_Login, p_Info]);
end;
//================================================================================
function TDB.GetTitle(Login: string): string;
var
  V: Variant;

begin
  ExecProcOutParams('dbo.proc_GetTitle', [Login], [2], V);
  result := V[0];
  V := Unassigned;
end;
//================================================================================
procedure TDB.SendMembershipTypes(Connection: TConnection);
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
begin
  OPenRecordset('dbo.proc_ReadMembershipTypes', [], Rst);

  fSocket.Send(Connection, [DP_MEMBERSHIPTYPE_BEGIN]);
  if (Rst <> nil) and (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do begin
      fSocket.Send(Connection, [DP_MEMBERSHIPTYPE, IntToStr(Rst.Fields[0].Value),
        Rst.Fields[1].Value]);
      Rst.MoveNext;
    end;
  Rst := nil;
end;
//================================================================================
procedure TDB.ReadActions;
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
  vAction: TAction;
begin
  OpenRecordset('dbo.proc_ReadActions', [], Rst);

  fActions.Clear;
  if (Rst <> nil) and (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do begin
      vAction := TAction.Create;
      vAction.id := Rst.Fields[0].Value;
      vAction.name := Rst.Fields[1].Value;
      vAction.Abbreviation := Rst.Fields[2].Value;
      vAction.comment := Rst.Fields[3].Value;
      vAction.AdminLevel := Rst.Fields[5].Value;
      vAction.MembershipTypes := nvl(Rst.Fields[6].Value, '');
      vAction.Roles := nvl(Rst.Fields[7].Value, '');
      fActions.Add(vAction);
      Rst.MoveNext;
    end;
  Rst := nil;
end;
//================================================================================
procedure TDB.SendPayments(Connection: TConnection; p_Login: string);
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
begin
  OpenRecordset('dbo.proc_ReadLoginTransactions', [p_Login], Rst);

  fSocket.Send(Connection, [DP_PROFILE_PAYMENT_BEGIN, p_Login]);

  if (Rst <> nil) and (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not RST.EOF do begin
      fSocket.Send(Connection, [DP_PROFILE_PAYMENT, p_Login,
        IntToStr(Rst.Fields[0].Value), // id
        FloatToStr(Rst.Fields[1].Value),  // transactiondate
        IntToStr(Rst.Fields[2].Value), // deleted
        IntToStr(Rst.Fields[3].Value), // MembershipType
        Rst.Fields[4].Value, // MembershipTypeName
        IntToStr(Rst.Fields[5].Value), // SubscribeType,
        Rst.Fields[6].Value, // SubscribeTypeName
        IntToStr(Rst.Fields[7].Value), // SourceType
        Rst.Fields[8].Value, // SourceTypeName,
        FloatToStr(Rst.Fields[9].Value), // ExpireDate
        FloatToStr(Rst.Fields[10].Value), // Amount
        FloatToStr(Rst.Fields[11].Value), // AmountFull
        nvl(Rst.Fields[12].Value, ''), // NameOnCard
        nvl(Rst.Fields[13].Value, ''), // CardType
        nvl(Rst.Fields[14].Value, ''), // CardNumber
        nvl(Rst.Fields[15].Value, ''), // AdminCreated,
        nvl(Rst.Fields[16].Value, ''), // AdminDeleted,
        nvl(Rst.Fields[17].Value, ''), // AdminComment
        IntToStr(nvl(Rst.Fields[18].Value, 0)), // PromoID
        nvl(Rst.Fields[19].Value, '')  // PromoCode
      ]);
      Rst.MoveNext;
    end;

  fSocket.Send(Connection, [DP_PROFILE_PAYMENT_END, p_Login]);
  Rst := nil;
end;
//================================================================================
procedure TDB.CMD_Transaction(Connection: TConnection; CMD: TStrings);
var
  id, MembershipType: integer;
  Login, AdminComment: string;
  ExpireDate: TDateTime;
  Amount, AmountFull: Currency;
begin
  Login := CMD[1];
  id := StrToInt(CMD[2]);
  MembershipType := StrToInt(CMD[3]);
  ExpireDate := Str2Float(CMD[4]);
  Amount := Str2Float(CMD[5]);
  AmountFull := Str2Float(CMD[6]);
  AdminComment := DecryptANSI(CMD[7]);
  if ExecProc('dbo.proc_SetTransaction',
    [id, Login, MembershipType, ExpireDate, Amount, AmountFull, Connection.Handle, AdminComment]) = 0
  then
    SendPayments(Connection, Login)
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Error occured during updating transaction']);
end;
//================================================================================
procedure TDB.CMD_TransactionState(Connection: TConnection; CMD: TStrings);
var
  id, deleted: integer;
  Login, AdminComment: string;
begin
  Login := CMD[1];
  id := StrToInt(CMD[2]);
  deleted := StrToInt(CMD[3]);
  AdminComment := DecryptANSI(CMD[4]);
  if ExecProc('dbo.proc_SetTransactionState',[id, deleted, Connection.Handle, AdminComment]) = 0 then
    SendPayments(Connection, Login)
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Error occured during updating transaction']);
end;
//================================================================================
procedure TDB.ReadRoles(var Connection: TConnection);
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
  s: string;
begin
  OpenRecordset('dbo.proc_GetLoginRoles', [Connection.LoginID], Rst);

  s := '';
  if (Rst <> nil) and (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not RST.EOF do begin
      s := s + Rst.Fields[1].Value + ',';
      Rst.MoveNext;
    end;
  Connection.Roles := s;
end;
//================================================================================
function TDB.GetSpecialOffer: string;
var
  V: Variant;
begin
  ExecProcOutParams('dbo.proc_GetSpecialOffer', [], [1], V);
  result := nvl(V[0], '');
  V := Unassigned;
end;
//================================================================================
end.

{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSProfiles;

interface

uses
  classes, SysUtils, CSConnection, Variants;

type
  TProfiles = class(TObject)
    private
    { Private declarations }

  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    procedure CMD_Profile(var Connection: TConnection; var CMD: TStrings);
end;

var
  fProfiles: TProfiles;

implementation

uses
  ADOInt, CSConnections, CSConst, CSDB, CSSocket, CSLib, CSActions;

type
  TCSBStat = class
    ECO: string;
    ECODesc: string;
    PGN: string;
    WW, WL, WD: integer;
    BW, BL, BD: integer;
  end;

{ TProfiles }
//______________________________________________________________________________
constructor TProfiles.Create;
begin

end;
//______________________________________________________________________________
destructor TProfiles.Destroy;
begin
  inherited;

end;
//______________________________________________________________________________
procedure TProfiles.CMD_Profile(var Connection: TConnection; var CMD: TStrings);
const
  LOGIN = 1;
var
  Rst: _RecordSet;
  RecsAffected: OleVariant;
  _Connection: TConnection;
  MSec, Result, color, res, n: Integer;
  LoginID, Title, FileName, s, EcoDesc: string;
  Email, PublicEmail, Country, SexId, Age, Language: string;
  Created,LoginTS,Birthday,MembershipExpireDate: TDateTime;
  BStat: TCSBStat;
  ShowBirthday: Boolean;
  MembershipType: TMembershipType;
  //*******************************************************************
  procedure SendBStat;
  begin
    with BStat do
      fSocket.Send(Connection,[DP_BEGINNING_STAT,
        CMD[LOGIN], ECO, ECODesc, PGN,
        IntToStr(WW), IntToStr(WL), IntToStr(WD),
        IntToStr(BW), IntToStr(BL), IntToStr(BD),
        IntToStr(WW+WL+WD+BW+BL+BD)]);
  end;
  //*******************************************************************
begin
  { Param check. Assume this Connection if no param passed. }
  if CMD.Count < 2 then CMD.Add(Connection.Handle);
  if (Length(CMD[LOGIN]) > MAX_LOGIN_LENGTH) then
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_LOGIN_EXCEEDS_MAX]);
      Exit;
    end;

  { DB call to: validate login and get games, notes & ratings.  }
  fDB.GetProfile(CMD[LOGIN], Result, Rst);
  case Result of
    DB_ERROR:
      begin
        { The fDB was unable to process the request. }
        { ??? need to send user a response. }
        Exit;
      end;
    -1: { Invalid LoginID }
      begin
        s := Format(DP_MSG_LOGINID_INVALID, [CMD[LOGIN]]);
        fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s]);
        Exit;
      end;
  end;

  { Buffer the info. }
  fSocket.Buffer := True;
  try // fSocket.Buffer := False

  { Get the LoginID, can't be returned via a result param because ADO doesn't
    give them till all the recordsets have been iterated through. }
  if (Rst.State = adStateOpen) and not (Rst.BOF) then begin
    LoginID := IntToStr(Rst.Fields[0].Value);
    Title := Rst.Fields[2].Value;
  end;

  FileName:=MAIN_DIR+PHOTO_USER_DIR+LoginId+'.jpg';
  if FileExists(FileName) then
    s:=ReadStrFromFile(FileName);
  //fSocketMM.Send(Connection,[DPM_PHOTO,CMD[LOGIN],'1',ControlSumm(s),EncryptANSI(s)]);
  s:=EncryptANSI(s);
  fSocket.Send(Connection,[DP_PHOTO,CMD[LOGIN],'1',IntToStr(ControlSumm(s)), s]);

  Rst := Rst.NextRecordset(RecsAffected);

  fSocket.Send(Connection, [DP_PROFILE_BEGIN, LoginID, CMD[LOGIN], Title]);
  { Iterate through the Rst }
  { Send the DP_PROFILE_GAME }
  { DP_PROFILE_GAME: DP#, LoginID, Login, Title, ProfileGameType, GameNumber/ID,
    WhiteName, WhiteTitle, WhiteRating, WhiteMSec,
    BlackName, BlackTitle, BlackRating, BlackMSec,
    RatedType, InitialMSec, IncMSec, Rated, GameResult, ECO, Date, LoggedIn }
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do
      begin
        EcoDesc:=fDB.GetEcoDesc(Rst.Fields[8].Value);
        fSocket.Send(Connection, [DP_PROFILE_GAME, LoginID, CMD[LOGIN], Title,
          IntToStr(Rst.Fields[0].Value),
          IntToStr(Rst.Fields[1].Value),
          Rst.Fields[19].value, Rst.Fields[20].value,
          IntToStr(Rst.Fields[22].Value),
          IntToStr(Rst.Fields[21].Value),
          Rst.Fields[3].Value, Rst.Fields[4].Value,
          IntToStr(Rst.Fields[6].Value),
          IntToStr(Rst.Fields[5].Value),
          IntToStr(Rst.Fields[14].Value),
          IntToStr(Rst.Fields[11].Value),
          IntToStr(Rst.Fields[12].Value),
          IntToStr(Rst.Fields[13].Value),
          IntToStr(Rst.Fields[15].Value),
          Rst.Fields[8].Value,
          Rst.Fields[7].Value,
          IntToStr(Rst.Fields[23].Value),
          EcoDesc]);

        Rst.MoveNext;
      end;
  { Send the Pages Count }
  Rst := Rst.NextRecordset(RecsAffected);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    fSocket.Send(Connection, [DP_PROFILE_PAGES, CMD[LOGIN], IntToStr(Rst.Fields[0].Value)]);

  { Send the DP_PROFILE_NOTES }
  Rst := Rst.NextRecordset(RecsAffected);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    if Rst.Fields[4].Value <> Null then
      fSocket.Send(Connection, [DP_PROFILE_NOTE, LoginID, CMD[LOGIN], Title,
        Rst.Fields[4].Value]);

  { Send the DP_PROFILE_RATINS }
  Rst := Rst.NextRecordset(RecsAffected);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then
    while not Rst.EOF do
      begin
        fSocket.Send(Connection, [DP_PROFILE_RATING, LoginID, CMD[LOGIN], Title,
          IntToStr(Rst.Fields[1].Value),
          IntToStr(Rst.Fields[2].Value),
          IntToStr(Rst.Fields[3].Value),
          IntToStr(Rst.Fields[4].Value),
          IntToStr(Rst.Fields[5].Value),
          IntToStr(Rst.Fields[6].Value),
          IntToStr(Rst.Fields[7].Value),
          IntToStr(Rst.Fields[8].Value),
          IntToStr(Rst.Fields[9].Value),
          IntToStr(Rst.Fields[10].Value),
          IntToStr(Rst.Fields[11].Value),
          Rst.Fields[12].Value,
          Rst.Fields[13].Value]);

        Rst.MoveNext;
      end;

  Rst := Rst.NextRecordset(RecsAffected);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then begin
    Created:=nvl(Rst.Fields[0].Value,0);
    LoginTS:=nvl(Rst.Fields[1].Value,0);
    Email:=nvl(Rst.Fields[2].Value,'');
    PublicEmail:=IntToStr(Rst.Fields[3].Value);
    Country:=nvl(Rst.Fields[4].Value,'');
    SexId:=nvl(Rst.Fields[5].Value,'');
    Age:=nvl(Rst.Fields[6].Value,'');
    Language:=nvl(Rst.Fields[7].Value,'');
    Birthday := Rst.Fields[8].Value;
    ShowBirthday := Rst.Fields[9].Value = '1';
    fSocket.Send(Connection,[DP_PROFILE_DATA,
      LoginID, CMD[LOGIN],
      FormatDateTime('dd mmm yyyy hh:nn am/pm',Created),
      FormatDateTime('dd mmm yyyy hh:nn am/pm',LoginTS),
      Email,
      PublicEmail,
      Country,
      SexId,
      Age,
      Language,
      IntToStr(Trunc(Birthday)),
      BoolTo_(ShowBirthday,'1','0')]);
  end;

  Rst := Rst.NextRecordset(RecsAffected);
  if (Rst.State = adStateOpen) and not (Rst.BOF) then begin
    BStat := TCSBStat.Create;
    while not Rst.EOF do begin
      if BStat.ECO <> Rst.Fields[0].Value then begin
        if BStat.ECO<>'' then SendBStat;
        with BStat do begin
          ECO:=Rst.Fields[0].Value;
          ECODesc:=nvl(Rst.Fields[3].Value,'');
          PGN:=nvl(Rst.Fields[4].Value,'');
          WW:=0; WL:=0; WD:=0;
          BW:=0; BL:=0; BD:=0;
        end;
      end;
      color:=Rst.Fields[1].Value;
      res:=Rst.Fields[2].Value;
      n:=Rst.Fields[5].Value;
      if color = 1 then
        case res of
           1: BStat.WW:=n;
           0: BStat.WD:=n;
          -1: BStat.WL:=n;
        end
      else
        case res of
           1: BStat.BW:=n;
           0: BStat.BD:=n;
          -1: BStat.BL:=n;
        end;
      Rst.MoveNext;
    end;
    if BStat.ECO<>'' then SendBStat;
    BStat.Free;
  end;

  Rst := Rst.NextRecordset(RecsAffected);
  if (Rst<>nil) and (Rst.State = adStateOpen) and not (Rst.BOF) and not (Rst.EOF) then begin
    MembershipType := TMembershipType(Rst.Fields[0].Value);
    MembershipExpireDate := Rst.Fields[2].Value;
  end else begin
    MembershipType := mmbNone;
    MembershipExpireDate := 0;
  end;

  if (lowercase(Connection.Handle) = lowercase(CMD[LOGIN])) or (Connection.AdminLevel >= alHelper) then begin
    fSocket.Send(Connection, [DP_PROFILE_PAY_DATA, LoginID, CMD[LOGIN], IntToStr(ord(MembershipType)),
      FloatToStr(MembershipExpireDate)]);
  end;

  if fActions.HaveRight(Connection, 'PAY') and (Rst.State = adStateOpen) then
    fDB.SendPayments(Connection, CMD[LOGIN]);

  Rst := nil;

  { Send the DP_PROFILE_PING }
  _Connection := fConnections.GetConnection(CMD[LOGIN]);
  if _Connection <> nil then
    begin
      MSec := Trunc((Now - _Connection.LastCmdTS) * MSecsPerDay);
      fSocket.Send(Connection, [DP_PROFILE_PING, LoginID, CMD[LOGIN], Title,
        IntToStr(_Connection.PingAvg), IntToStr(_Connection.PingCount),
        IntToStr(MSec)]);
    end
  else
    fSocket.Send(Connection, [DP_PROFILE_PING, LoginID, CMD[LOGIN], Title,
      '-1', '-1', '-1']);

  if (Connection.AdminLevel = alSuper) or fDB.IsMemberOf(Connection.Handle,'ChatReader') then
    fSocket.Send(Connection, [DP_PROFILE_CHATREADER, LoginId, CMD[LOGIN], Title, '1']);

  { Send the DP_PROFILE_END }
  fSocket.Send(Connection, [DP_PROFILE_END, LoginID, CMD[LOGIN], Title]);
  finally
    { Flush the buffer }
    fSocket.Buffer := False;
    fSocket.Send(Connection, ['']);
  end;
end;
//______________________________________________________________________________
end.

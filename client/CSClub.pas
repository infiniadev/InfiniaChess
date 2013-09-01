{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CSClub;

interface

uses contnrs, SysUtils, CLCLubMembers, classes, forms, CLClubList, graphics;

type
  TClubStatus = (clsNone,clsPretendent,clsMember,clsHelper,clsMaster);
  //-------------------------------------------------------------------------
  TClubMember = class
  private
    function GetStatusName: string;
  public
    LoginId: integer;
    Login: string;
    Title: string;
    Status: TClubStatus;
    property StatusName: string read GetStatusName;
  end;
  //-------------------------------------------------------------------------
  TClubMembers = class(TObjectList)
  private
    function GetClubMember(Index: integer): TClubMember;
    function IndexOfLogin(Login: string): integer;
  public
    Club: TObject;
    property ClubMember[Index: integer]: TClubMember read GetClubMember; default;
    procedure DeleteClubMember(Login: string);
    procedure InsOrUpdMember(LoginId: integer; Login,Title: string; Status: TClubStatus);
    function MemberById(LoginId: integer): TClubMember;
    function MemberByLogin(Login: string): TClubMember;
    procedure UpdateStatus(Login: string; Status: TClubStatus);
  end;
  //-------------------------------------------------------------------------
  TClubType = (cltClub, cltSchool);
  //-------------------------------------------------------------------------
  TClub = class
  private
    function GetStatusName: string;
  public
    id: integer;
    name: string;
    info: string;
    bmpPhoto: TBitMap;
    status: TClubStatus;
    Members: TClubMembers;
    Requests: Boolean;
    Sponsor: string;
    ClubType: TClubType;
    MembersCount: integer;
    fCLClubMembers: TfCLClubMembers;
    function CanGoTo: Boolean;
    function CanJoin: Boolean;
    function CanLeave: Boolean;
    function CanManage: Boolean;
    property StatusName: string read GetStatusName;
    constructor Create;
    destructor Destroy; override;
  end;
  //-------------------------------------------------------------------------
  TClubs = class(TObjectList)
  private
    function GetClub(Index: integer): TClub;
  public
    fCLClubList: TfCLClubList;
    destructor Destroy; override;
    property Clubs[Index: integer]: TClub read GetClub; default;
    procedure AddClub(id: integer; name: string; status: TClubStatus);
    function NameById(id: integer): string;
    function ClubById(id: integer): TClub;
    procedure CMD_MembersBegin(CMD: TStrings);
    procedure CMD_Member(CMD: TStrings);
    procedure CMD_MembersEnd(CMD: TStrings);
    procedure CMD_ClubStatus(CMD: TStrings);
    procedure CMD_ClubInfo(CMD: TStrings);
    procedure CMD_ClubOptions(CMD: TStrings);
    procedure CMD_ClubPhoto(CMD: TStrings);
  end;
  //-------------------------------------------------------------------------
  function ClubStatus2Str(Status: TClubStatus): string;

var
  fClubs: TClubs;

implementation

uses CLSocket, CLLib, CLClubs;
{ TClubs }
//===========================================================================
procedure TClubs.AddClub(id: integer; name: string; status: TClubStatus);
var
  cl: TClub;
begin
  cl:=TClub.Create;
  cl.Id:=id;
  cl.Name:=name;
  cl.Status:=status;
  Add(cl);
end;
//===========================================================================
function TClubs.ClubById(id: integer): TClub;
var
  i: integer;
begin
  for i:=0 to Count-1 do begin
    result:=TClub(Items[i]);
    if result.id = id then exit;
  end;
  result:=nil;
end;
//===========================================================================
procedure TClubs.CMD_ClubInfo(CMD: TStrings);
var
  id: integer;
  cl: TClub;
begin
  if CMD.Count<3 then exit;
  try id:=StrToInt(cmd[1]); except exit; end;
  cl:=ClubById(id);
  if cl = nil then exit;
  cl.info:=CMD[2];
  if fCLClubs.Visible then fCLClubs.Refresh;
end;
//===========================================================================
procedure TClubs.CMD_ClubOptions(CMD: TStrings);
var
  id: integer;
  cl: TClub;
begin
  if CMD.Count<4 then exit;
  try id:=StrToInt(cmd[1]); except exit; end;
  cl:=ClubById(id);
  if cl = nil then exit;
  cl.requests := CMD[2] = '1';
  cl.sponsor := CMD[3];
  if fCLClubs.Visible then fCLClubs.Repaint;
end;
//===========================================================================
procedure TClubs.CMD_ClubPhoto(CMD: TStrings);
var
  id: integer;
  cl: TClub;
  s: string;
begin
  if CMD.Count<3 then exit;
  try id:=StrToInt(cmd[1]); except exit; end;
  cl:=ClubById(id);
  if cl = nil then exit;

  s:=CMD[2];
  if (s='') or (s='@!001!0') then cl.bmpPhoto.Free
  else begin
    cl.BmpPhoto:=TBitMap.Create;
    if not ANSIStringToBitMap(s,cl.BmpPhoto) then exit;
  end;
  if Assigned(cl.fCLClubMembers) then begin
    cl.fCLClubMembers.imgPhoto.Picture.Bitmap.Assign(cl.BmpPhoto);
    cl.fCLClubMembers.imgPhoto.Visible:=true;
  end;
end;
//===========================================================================
procedure TClubs.CMD_ClubStatus(CMD: TStrings);
var
  Login: string;
  ClubId: integer;
  Status: TClubStatus;
  cl: TClub;
begin
  if CMD.Count<4 then exit;
  try
    Login:=CMD[1];
    ClubId:=StrToInt(CMD[2]);
    Status:=TClubStatus(StrToInt(CMD[3]));
  except
    exit;
  end;

  cl:=ClubById(ClubId);
  if cl = nil then exit;
  if lowercase(fCLSocket.MyName) = lowercase(Login) then begin
    cl.status := Status;
    if Assigned(fCLClubList) then
      fCLCLubList.LoadClubs;
  end;
  cl.Members.UpdateStatus(Login,Status);
  if Assigned(cl.fCLClubMembers) then
    cl.fCLClubMembers.UpdateStatus(Login,ClubStatus2Str(Status));
end;
//===========================================================================
procedure TClubs.CMD_Member(CMD: TStrings);
var
  LoginId,ClubId: integer;
  Login, Title: string;
  Status: TClubStatus;
  cl: TClub;
begin
  if CMD.Count<5 then exit;
  try
    ClubId:=StrToInt(cmd[1]);
    LoginId:=StrToInt(cmd[2]);
    Login:=cmd[3];
    Title:=cmd[4];
    Status:=TClubStatus(StrToInt(cmd[5]));
  except
    exit;
  end;
  cl:=ClubById(ClubId);
  if cl = nil then exit;
  cl.Members.InsOrUpdMember(LoginId,Login,Title,Status);
end;
//===========================================================================
procedure TClubs.CMD_MembersBegin(CMD: TStrings);
var
  id: integer;
  cl: TClub;
begin
  if CMD.Count<2 then exit;
  try id:=StrToInt(cmd[1]); except exit; end;
  cl:=ClubById(id);
  if cl = nil then exit;
  cl.Members.Clear;
end;
//===========================================================================
procedure TClubs.CMD_MembersEnd(CMD: TStrings);
var
  id: integer;
  cl: TClub;
begin
  if CMD.Count<2 then exit;
  try id:=StrToInt(cmd[1]); except exit; end;
  cl:=ClubById(id);
  if cl = nil then exit;
  if not Assigned(cl.fCLClubMembers) then begin
    cl.fCLClubMembers:=TfCLCLubMembers.Create(Application);
    cl.fCLCLubMembers.Club := cl;
  end;
  cl.fCLClubMembers.RefreshList;
  if not Assigned(cl.bmpPhoto) then cl.fCLClubMembers.imgPhoto.Visible:=false
  else cl.fCLClubMembers.imgPhoto.Picture.Bitmap.Assign(cl.bmpPhoto);

  cl.fCLClubMembers.lblName.Caption:=cl.name;
  if not cl.fCLClubMembers.Visible then
    cl.fCLClubMembers.ShowModal;
end;
//===========================================================================
destructor TClubs.Destroy;
begin
  inherited;
  fCLCLubList.Free;
end;
//===========================================================================
function TClubs.GetClub(Index: integer): TClub;
begin
  result:=TClub(Items[Index]);
end;
//===========================================================================
function TClubs.NameById(id: integer): string;
var
  i: integer;
begin
  for i:=0 to fClubs.Count-1 do
    if fClubs[i].Id = id then begin
      result:=fClubs[i].Name;
      exit;
    end;
  result:='';
end;
//===========================================================================
//===========================================================================
function ClubStatus2Str(Status: TClubStatus): string;
begin
  case Status of
    clsNone: result:='';
    clsPretendent: result:='Candidate';
    clsMember: result:='Member';
    clsHelper: result:='Helper';
    clsMaster: result:='Manager';
  end;
end;
//===========================================================================
{ TClub }

function TClub.CanGoTo: Boolean;
begin
  result := ((fCLSocket.MyAdminLevel = 3)
    or (id = 1) // main club
    or fCLSocket.MeEmployed('ClubManager')
    or (Status >= clsMember))
    and (fCLSocket.ClubId <> id);
end;
//===========================================================================
function TClub.CanJoin: Boolean;
begin
  result := (id<>1) and (Status = clsNone) and Requests;
end;
//===========================================================================
function TClub.CanLeave: Boolean;
begin
  result := (id<>1) and (Status >= clsMember);
end;
//===========================================================================
function TClub.CanManage: Boolean;
begin
  result := (fCLSocket.MyAdminLevel = 3) or (Status = clsMaster) or fCLSocket.MeEmployed('ClubManager');
end;
//===========================================================================
constructor TClub.Create;
begin
  Members:=TClubMembers.Create;
  Members.Club := Self;
end;
//===========================================================================
destructor TClub.Destroy;
begin
  inherited;
  Members.Free;
  fCLClubMembers.Free;
end;
//===========================================================================
function TClub.GetStatusName: string;
begin
  result:=ClubStatus2Str(status);
end;
//===========================================================================
{ TClubMembers }

procedure TClubMembers.DeleteClubMember(Login: string);
var
  n: integer;
begin
  n:=IndexOfLogin(Login);
  if n <> -1 then
    Delete(n);
end;
//===========================================================================
function TClubMembers.GetClubMember(Index: integer): TClubMember;
begin
  result:=TClubMember(Items[Index]);
end;
//===========================================================================
function TClubMembers.IndexOfLogin(Login: string): integer;
var
  i: integer;
begin
  for i:=0 to Count-1 do
    if lowercase(ClubMember[i].Login) = lowercase(Login) then begin
      result:=i;
      exit;
    end;
  result:=-1;
end;
//===========================================================================
procedure TClubMembers.InsOrUpdMember(LoginId: integer; Login,
  Title: string; Status: TClubStatus);
var
  cm: TClubMember;
begin
  cm:=MemberById(LoginId);
  if cm = nil then begin
    cm:=TClubMember.Create;
    Add(cm);
  end;
  cm.LoginId:=LoginId;
  cm.Login:=Login;
  cm.Title:=Title;
  cm.Status:=Status;
end;
//===========================================================================
function TClubMembers.MemberById(LoginId: integer): TClubMember;
var
  i: integer;
begin
  for i:=0 to Count-1 do begin
    result:=TClubMember(Items[i]);
    if result.LoginId = LoginId then exit;
  end;
  result:=nil;
end;
//===========================================================================
function TClubMembers.MemberByLogin(Login: string): TClubMember;
var
  i: integer;
begin
  for i:=0 to Count-1 do begin
    result:=TClubMember(Items[i]);
    if result.Login = Login then exit;
  end;
  result:=nil;
end;
//===========================================================================
procedure TClubMembers.UpdateStatus(Login: string; Status: TClubStatus);
var
  member: TClubMember;
begin
  member:=MemberByLogin(Login);
  if member = nil then exit
  else member.Status := Status;
end;
//===========================================================================
{ TClubMember }

function TClubMember.GetStatusName: string;
begin
  result:=ClubStatus2Str(status);
end;
//===========================================================================
end.

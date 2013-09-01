{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLLogins;

interface

uses CLObjectList, CLLib, Classes, SysUtils, CLGame;

type
  TOnlineStatus = (onlActive, onlIdle, onlDisconnected);

  TLoginRatingInfoOne = record
    Rating: integer;
    L, W, D: integer;
  end;

  TLoginRatingInfo = array[0..5] of TLoginRatingInfoOne;

  TLogin = class(TObject)
  private
    FRatingString: string;
    FRatingInfo: TLoginRatingInfo;
    function GetLoginWithTitle: string;
    function GetRating(RatedType: integer): integer;
    procedure SetRatingString(const Value: string);
  public
    LoginID: integer;
    Login: string;
    Title: string;
    ProvString: string;
    ImageIndex: integer;
    AdminLevel: integer;
    Master: Boolean;
    Created: TDateTime;
    AdminGreated: Boolean;
    MembershipType: TMembershipType;
    OnlineStatus: TOnlineStatus;
    property RatingString: string read FRatingString write SetRatingString;
    property Rating[RatedType: integer]: integer read GetRating;
    property LoginWithTitle: string read GetLoginWithTitle;
  end;

  TLoginList = class(TTypedObjectList)
  private
    slRequestSent: TStrings;
    SendRequest: Boolean;
    function GetLoginByName(p_Login: string): TLogin;
    function GetLogin(LoginID: integer): TLogin;
  protected
    function GetObjectSortKey(p_Object: TObject): TTOLSortKey; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function Login2(CMD: TStrings; var pp_InsertedNew: Boolean): TLogin;
    property Login[LoginID: integer]: TLogin read GetLogin; default;
    property LoginByName[p_Login: string]: TLogin read GetLoginByName;
  end;

  TLoginFilter = class(TObject)
  public
    LoginID: integer;
    FilterID: integer;
  end;

  TLoginFilterList = class(TTypedObjectList)
  private
    function GetLoginFilter(Index: integer): TLoginFilter;
    function GetSortKey(p_LoginID, p_FilterID: integer): TTOLSortKey;
  protected
    function GetObjectSortKey(p_Object: TObject): TTOLSortKey; override;
  public
    constructor Create;
    function Exists(p_LoginID, p_FilterID: integer): Boolean;
    procedure AddLoginFilter(p_LoginID, p_FilterID: integer);
    procedure ClearLoginID(p_LoginID: integer);
    procedure ClearFilterID(p_FilterID: integer);
    procedure RemoveLoginFilter(p_LoginID, p_FilterID: integer);

    property LoginFilter[Index: integer]: TLoginFilter read GetLoginFilter; default;
  end;

implementation

uses CLSocket, CLConst;

{ TLoginsList }
//==============================================================================
procedure TLoginList.Clear;
begin
  slRequestSent.Clear;
  inherited Clear;
end;
//==============================================================================
constructor TLoginList.Create;
begin
  inherited;
  slRequestSent := TStringList.Create;
  FClassType := TLogin;
  FSorted := true;
  FUnique := true;
  SendRequest := true;
end;
//==============================================================================
destructor TLoginList.Destroy;
begin
  FreeAndNil(slRequestSent);
  inherited;
end;
//==============================================================================
function TLoginList.GetLogin(LoginID: integer): TLogin;
var
  obj: TObject;
  s: string;
begin
  obj := GetObjectByKey(LoginID);
  if Assigned(obj) then result := TLogin(obj)
  else begin
    result := nil;
    s := '#' + IntToStr(LoginID);
    if SendRequest and (slRequestSent.IndexOf(s) = -1) then begin
      fCLSocket.InitialSend([CMD_STR_REQUEST_USER_INFO, s]);
      // stop this as it is filling the log
      // SendErrorToServer('Interface', 'TLoginList.GetLogin(LoginID)', 0, 'Login ' + s + ' has not been found', '');
      slRequestSent.Add(s);
    end;
  end;
end;
//==============================================================================
function TLoginList.GetLoginByName(p_Login: string): TLogin;
var
  i: integer;
begin
  p_Login := lowercase(p_Login);
  result := nil;
  for i := 0 to Count - 1 do
    if lowercase(TLogin(Items[i]).Login) = p_Login then begin
      result := TLogin(Items[i]);
      exit;
    end;
  if SendRequest and (slRequestSent.IndexOf(p_Login) = -1) then begin
    fCLSocket.InitialSend([CMD_STR_REQUEST_USER_INFO, p_Login]);
    // stop this as it is filling the log
    //SendErrorToServer('Interface', 'TLoginList.GetLogin(Login)', 0, 'Login ' + p_Login + ' has not been found', '');
    slRequestSent.Add(p_Login);
  end;
end;
//==============================================================================
function TLoginList.GetObjectSortKey(p_Object: TObject): TTOLSortKey;
begin
  result := (p_Object as TLogin).LoginID;
end;
//==============================================================================
function TLoginList.Login2(CMD: TStrings; var pp_InsertedNew: Boolean): TLogin;
var
  LoginID: integer;
  L: TLogin;
begin
  LoginID := StrToInt(CMD[1]);
  SendRequest := false;
  L := Login[LoginID];
  SendRequest := true;
  pp_InsertedNew := L = nil;

  if L = nil then begin
    L := TLogin.Create;
    L.LoginID := LoginID;
    AddObject(L);
  end;
  result := L;

  L.Login := CMD[2];
  L.Title := CMD[3];
  L.RatingString := CMD[4];
  L.ImageIndex := StrToInt(CMD[5]);
  L.AdminLevel := StrToInt(CMD[6]);
  L.Master := CMD[7] = '1';
  L.Created := Str2Float(CMD[8]);
  L.AdminGreated := CMD[9] = '1';
  L.ProvString := CMD[10];
  L.MembershipType := TMembershipType(StrToInt(CMD[11]));
  if CMD.Count > 12 then L.OnlineStatus := TOnlineStatus(StrToInt(CMD[12]))
  else L.OnlineStatus := onlActive;
end;
//==============================================================================
{ TLoginFilterList }

procedure TLoginFilterList.AddLoginFilter(p_LoginID, p_FilterID: integer);
var
  LF: TLoginFilter;
begin
  if Exists(p_LoginID, p_FilterID) then exit;
  
  LF := TLoginFilter.Create;
  LF.LoginID := p_LoginID;
  LF.FilterID := p_FilterID;
  AddObject(LF);
end;
//==============================================================================
procedure TLoginFilterList.ClearFilterID(p_FilterID: integer);
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    if Self[i].FilterID = p_FilterID then
      Delete(i);
end;
//==============================================================================
procedure TLoginFilterList.ClearLoginID(p_LoginID: integer);
var
  i: integer;
begin
  for i := Count - 1 downto 0 do
    if Self[i].LoginID = p_LoginID then
      Delete(i);
end;
//==============================================================================
constructor TLoginFilterList.Create;
begin
  inherited;
  FClassType := TLoginFilter;
  FSorted := true;
  FUnique := true;
end;
//==============================================================================
function TLoginFilterList.Exists(p_LoginID, p_FilterID: integer): Boolean;
var
  dumb: integer;
begin
  result := BinarySearch(GetSortKey(p_LoginID, p_FilterID), dumb);
end;
//==============================================================================
function TLoginFilterList.GetLoginFilter(Index: integer): TLoginFilter;
begin
  result := TLoginFilter(Items[Index]);
end;
//==============================================================================
function TLoginFilterList.GetObjectSortKey(p_Object: TObject): TTOLSortKey;
var
  LF: TLoginFilter;
begin
  LF := TLoginFilter(p_Object);
  result := GetSortKey(LF.LoginID, LF.FilterID);
end;
//==============================================================================
function TLoginFilterList.GetSortKey(p_LoginID, p_FilterID: integer): TTOLSortKey;
begin
  result := IntToStr(p_LoginID) + ';' + IntToStr(p_FilterID);
end;
//==============================================================================
procedure TLoginFilterList.RemoveLoginFilter(p_LoginID, p_FilterID: integer);
var
  index: integer;
begin
  if BinarySearch(GetSortKey(p_LoginID, p_FilterID), index) then
    Delete(Index);
end;
//==============================================================================
{ TLogin }
//==============================================================================
function TLogin.GetLoginWithTitle: string;
begin
  result := GetNameWithTitle(Login, Title);
end;
//==============================================================================
function TLogin.GetRating(RatedType: integer): integer;
begin
  result := FRatingInfo[RatedType].Rating;
end;
//==============================================================================
procedure TLogin.SetRatingString(const Value: string);
var
  i: integer;
  sl, sl1: TStringList;
begin
  FRatingString := Value;
  sl := TStringList.Create;
  sl1 := TStringList.Create;
  try
    Str2StringList(FRatingString, sl, ';');
    for i := 0 to 5 do begin
      Str2StringList(sl[i], sl1);
      FRatingInfo[i].Rating := StrToInt(sl1[0]);
      FRatingInfo[i].W := StrToInt(sl1[1]);
      FRatingInfo[i].L := StrToInt(sl1[2]);
      FRatingInfo[i].D := StrToInt(sl1[3]);
    end;
  finally
    FreeAndNil(sl);
    FreeAndNil(sl1);
  end;
end;
//==============================================================================
end.

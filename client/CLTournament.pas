unit CLTournament;

interface

uses Forms,Controls,CLEvents,Classes,CSReglament,SysUtils,CLGame,CLAccept;

type
  //----------------------------------------------------------------------------
  TCSTournament=class(TCSEvent)
  private
    FReglament: TCSReglament;
    FAccept: TfCLAccept;
    SLAccepted: TStringList;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure OnMember(Name,Title: string; Rating: integer); override;
    procedure OnMemberStart; override;
    procedure OnMemberEnd; override;
    procedure OnAbandon(Name: string); override;
    procedure CreateFakeData;
    procedure AcceptRequest(rgame_id,sec: integer; partner: string);

    procedure OnDoTurn(Game: TCLGame); override;
    procedure OnGameBorn(Game: TCLGame); override;
    //procedure OnShowGame(Game: TCLGame); virtual;
    procedure OnGameResult(Game: TCLGame); override;
    procedure OnLeaderLocation(GameNum: integer); override;

    property Reglament: TCSReglament read FReglament;
  end;
  //----------------------------------------------------------------------------
implementation

uses CLLib,CLConst,CLEventControl,CLSocket,CLTerminal,CLFilterManager,CLConsole, CLMain;
//==============================================================================
{ TCSTournament }
//==============================================================================
procedure TCSTournament.AcceptRequest(rgame_id, sec: integer; partner: string);
var
  msg: string;
begin
  {msg:=Format('Click "%s %d %d" for starting next game. Another way the game will be started in %d seconds.',
    [CMD_STR_EVENT_GAME_ACCEPT, Self.ID,rgame_id, sec]);

  fCLTerminal.AddLine(fkRoom, RoomNumber, msg, ltServerMsgNormal);}
  if (FAccept<>nil) or (SLAccepted.IndexOf(IntToStr(rgame_id))<>-1) then exit;

  FAccept:=TfCLAccept.Create(Application);
  FAccept.SetParams(partner,sec);
  if FAccept.ShowModal = mrOk then
    fCLSocket.InitialSend([CMD_STR_EVENT_GAME_ACCEPT,IntToStr(Self.ID),IntToStr(rgame_id)]);

  if Assigned(FAccept) then begin
    FAccept.Visible:=false;
    try
      FAccept.Free;
    finally
      FAccept:=nil;
    end;
  end;
  SLAccepted.Add(IntToStr(rgame_id));
end;
//==============================================================================
constructor TCSTournament.Create;
begin
  inherited;
  FReglament:=TCSReglament.Create;
  CreateFakeData;
  SLAccepted:=TStringList.Create;
end;
//==============================================================================
procedure TCSTournament.CreateFakeData;
var
  i,n: integer;
  sl: TStringList;
  s,sWhite,sBlack,score,filename: string;
  rgame: TCSReglGame;
begin
  with Reglament.MemberList do begin
    InsOrUpdUser('Ivanchuk','GM',2750);
    InsOrUpdUser('Topalov','GM',2783);
    InsOrUpdUser('Svidler','GM',2728);
    InsOrUpdUser('Karlsen','GM',2690);
    InsOrUpdUser('Morozevich','GM',2741);
    InsOrUpdUser('Aronyan','GM',2744);
    //InsOrUpdUser('Anand','GM',2779);
    //InsOrUpdUser('Leko','GM',2749);
  end;
  filename:=MAIN_DIR+'!elim.ini';
  if not FileExists(filename) then exit;
  sl:=TStringList.Create;
  sl.LoadFromFile(filename);
  for i:=0 to sl.Count-1 do begin
    rgame:=TCSReglGame.Create;
    s:=sl[i];
    rgame.WhiteNum:=StrToInt(s[1])-1;
    if s[3]='@' then rgame.BlackNum:=-1
    else rgame.BlackNum:=StrToInt(s[3])-1;
    n:=pos(';',sl[i]);
    if n=0 then rgame.result:=rgrNone
    else begin
      score:=copy(s,n+1,length(s));
      if score='1/2' then rgame.result:=rgrDraw
      else if score='1-0' then rgame.result:=rgrWhiteWin
      else rgame.result:=rgrBlackWin;
    end;
    rgame.GameNum:=i;
    if i<8 then rgame.RoundNum:=1
    else if i<12 then rgame.RoundNum:=2
    else rgame.RoundNum:=3;
    {if i<11 then rgame.RoundNum:=1
    else if i<15 then rgame.RoundNum:=2
    else rgame.RoundNum:=3;}
    //rgame.RoundNum:=i div 4 +1;
    rgame.AddNum:=1;
    Reglament.ReglGames.Add(rgame);
  end;
  sl.Free;
end;
//==============================================================================
destructor TCSTournament.Destroy;
begin
  inherited;
  FReglament.Free;
  SLAccepted.Free;
end;
//==============================================================================
procedure TCSTournament.OnAbandon(Name: string);
begin
  inherited;
  Reglament.MemberList.DeleteUser(name);
  fCLEventControl.RefreshMembers;
end;
//==============================================================================
procedure TCSTournament.OnDoTurn(Game: TCLGame);
begin
  if ((Game.WhiteName=fCLSocket.MyName) or (Game.BlackName=fCLSocket.MyName))
    and (fCLEventControl.EVCurrent=Self)
    and (Reglament.RoundByGameNum(Game.GameNumber) = Reglament.CurRound)
  then
    fCLEventControl.SetActiveGame(Game.EventOrdNum-1);
end;
//==============================================================================
procedure TCSTournament.OnGameBorn(Game: TCLGame);
var
  MyGame: TCLGame;
begin
  AddGame(Game);
  if ((Game.WhiteName=fCLSocket.MyName) or (Game.BlackName=fCLSocket.MyName))
    and (fCLEventControl.EVCurrent=Self)
  then
    fCLEventControl.SetActiveGame(Game.EventOrdNum-1);
end;
//==============================================================================
procedure TCSTournament.OnGameResult(Game: TCLGame);
begin
  if ((Game.WhiteName=fCLSocket.MyName) or (Game.BlackName=fCLSocket.MyName))
    and (fCLEventControl.EVCurrent = Self)
  then
    fCLEventControl.tbStandings.Click;
end;
//==============================================================================
procedure TCSTournament.OnLeaderLocation(GameNum: integer);
begin
  //
end;
//==============================================================================
procedure TCSTournament.OnMember(Name, Title: string; Rating: integer);
begin
  inherited;
  Reglament.MemberList.InsOrUpdUser(Name,Title,Rating);
  if fCLEventControl.EVCurrent=Self then
    fCLEventControl.InsOrUpdMember(name,title,rating);
end;
//==============================================================================
procedure TCSTournament.OnMemberEnd;
begin
  inherited;
  fCLEventControl.RefreshMembers;
end;
//==============================================================================
procedure TCSTournament.OnMemberStart;
begin
  Reglament.MemberList.Clear;
end;
//==============================================================================
end.

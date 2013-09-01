{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CSReglament;

interface

uses Classes,SysUtils;

type
  //----------------------------------------------------------------------------
  TCSTournamentType = (trtRound,trtElim,trtSwiss,trtMatch);
  //----------------------------------------------------------------------------
  TCSRoundOrder = (rntNoOrder,rntByOrder,rntByTime);
  //----------------------------------------------------------------------------
  TCSReglStatus = (rgsNotStarted,rgsNoNewGames,rgsNewGames,rgsRoundCompleted,rgsTournamentCompleted);
  //----------------------------------------------------------------------------
  TCSUser = class
  private
    function GetScore: real;
    function GetScoreString: string;
    function GetRankString: string;
  public
    Login: string;
    Title: string;
    Rating: integer;
    DoubleScore: integer;
    RankMin: integer;
    RankMax: integer;
    property Score: real read GetScore;
    property ScoreString: string read GetScoreString;
    property RankString: string read GetRankString;
    procedure Assign(Source : TCSUser);
  end;
  //----------------------------------------------------------------------------
  TCSUserList = class(TList)
  private
    function GetUser(Num: integer): TCSUser;
  public
    function IndexOfUser(p_Login: string): integer;
    procedure InsOrUpdUser(p_Login,p_Title: string; p_Rating: integer);
    procedure DeleteUser(p_Login: string);
    procedure Shuffle;
    procedure Swap(nFrom,nTo: integer);
    function ByeCountElim: integer;

    property User[Index: integer]: TCSUser read GetUser; default;
  end;
  //----------------------------------------------------------------------------
  TCSReglGameResult = (rgrNone,rgrWhiteWin,rgrBlackWin,rgrDraw);
  //----------------------------------------------------------------------------
  TCSReglGame = class
  public
    ID: integer;
    WhiteNum: integer;
    BlackNum: integer;
    InitTime: string;
    IncTime: integer;
    GameNum: integer;
    RoundNum: integer;
    AddNum: integer;
    Result: TCSReglGameResult;
    WhiteAccept: Boolean;
    BlackAccept: Boolean;
    RequestSent: Boolean;
    StartTime: TDateTime;
    function IsByeGame: Boolean;
    function CanStart: Boolean;
    constructor Create;
  end;
  //----------------------------------------------------------------------------
  TCSReglament = class
  private
    FRoundOrder: TCSRoundOrder;
    FTourType: TCSTournamentType;
    FRoundsNumber: integer;
    FENumber: integer;
    FMemberList: TCSUserList;
    FReglGames: TList;
    FInitTime: string;
    FIncTime: integer;
    FCurRound: integer;
    FAcceptTime: integer;
    procedure MakeStartReglamentRound;
    procedure MakeStartReglamentElim;
    procedure MakeStartReglamentMatch;
    function GetGames(Index: integer): TCSReglGame;
    function GetGamesCount: integer;
    function FindGameByID(p_ID: integer): TCSReglGame;
    procedure Results(const p_Login: string; p_Round: integer; var pp_Win,pp_Loss,pp_Draw: integer);
    function CurRoundWins(p_Login: string): integer;
    function RoundWins(const p_Login: string; p_RoundNum: integer): integer;
    function RoundBye(const p_Login: string; p_RoundNum: integer): Boolean;
    procedure NextRoundElim;
    procedure NextRoundMatch;
    procedure NextRoundSwiss;
  public
    RoundByRound: Boolean;
    property InitTime: string read FInitTime write FInitTime;
    property IncTime: integer read FIncTime write FIncTime;
    property RoundOrder: TCSRoundOrder read FRoundOrder write FRoundOrder;
    property TourType: TCSTournamentType read FTourType write FTourType;
    property RoundType: TCSRoundOrder read FRoundOrder write FRoundOrder;
    property NumberOfRounds: integer read FRoundsNumber write FRoundsNumber;
    property ENumber: integer read FENumber write FENumber; // number of rounds between each two people
    property MemberList: TCSUserList read FMemberList;
    property ReglGames: TList read FReglGames;
    property GamesCount: integer read GetGamesCount;
    property Games[Index: integer]: TCSReglGame read GetGames; default;
    property CurRound: integer read FCurRound;
    property AcceptTime: integer read FAcceptTime write FAcceptTime;

    function GetNextReglGame(Login: string; WhiteOnly: Boolean): TCSReglGame;
    procedure CountScore(RoundNum: integer = -1);
    procedure CountRanks(RoundNum: integer = -1);
    procedure CountRanksFinishedRounds;
    function  RoundCount: integer;
    function ElimFullRoundCount: integer;
    function AllGamesCompleted: Boolean;
    function UserIsRoundMember(const p_Login: string; RoundNum: integer): Boolean;
    function GameExists(PlayerNum1,PlayerNum2: integer): Boolean;
    function RoundByGameNum(GameNum: integer): integer;

    constructor Create;
    destructor Destroy;
    procedure MakeStartReglament;
    procedure ClearGames;
    function FindGameByNum(GameNum: integer): TCSReglGame;
    function CurRoundCompleted: Boolean;
    function TournamentCompleted: Boolean;
    procedure NextRound;
    procedure InsOrUpdGame(
      ID: integer;
      WhiteNum: integer;
      BlackNum: integer;
      InitTime: string;
      IncTime: integer;
      GameNum: integer;
      RoundNum: integer;
      AddNum: integer;
      Result: TCSReglGameResult);
    procedure UpdateGame(ID: integer; GameNum: integer; Result: TCSReglGameResult);
    function OnReglGameResult(rgame: TCSReglGame): TCSReglGame;
    procedure CountMatchResult(var pp_Wins0,pp_Wins1: integer);
    function AddNewRGame(const p_WhiteNum,p_BlackNum: integer): TCSReglGame;
  end;
  //----------------------------------------------------------------------------
implementation

uses CLMain;
//==============================================================================
{ TCSUser }
//==============================================================================
procedure TCSUser.Assign(Source: TCSUser);
begin
  Login := Source.Login;
  Title := Source.Title;
  Rating := Source.Rating;
  DoubleScore := Source.DoubleScore;
  RankMin := Source.RankMin;
  RankMax := Source.RankMax;
end;
//==============================================================================
function TCSUser.GetRankString: string;
begin
  if (RankMin=0) or (RankMax=0) then result:=''
  else if RankMin=RankMax then result:=IntToStr(RankMin)
  else result:=Format('%d-%d',[RankMin,RankMax]);
end;
//==============================================================================
function TCSUser.GetScore: real;
begin
  result:=DoubleScore/2;
end;
//==============================================================================
function TCSUser.GetScoreString: string;
begin
  result:=IntToStr(DoubleScore div 2);
  if DoubleScore mod 2 <> 0 then
    result:=result+'.5';
end;
//==============================================================================
{ TCSReglGame }
//==============================================================================
function TCSReglGame.CanStart: Boolean;
begin
  result:=WhiteAccept and BlackAccept or (StartTime<>0) and (StartTime<=Now);
end;
//==============================================================================
constructor TCSReglGame.Create;
begin
  WhiteAccept:=false;
  BlackAccept:=false;
  RequestSent:=false;
  StartTime:=0;
end;
//==============================================================================
function TCSReglGame.IsByeGame: Boolean;
begin
  result:=BlackNum=-1;
end;
//==============================================================================
{ TCSUserList }
//==============================================================================
procedure TCSUserList.Swap(nFrom, nTo: integer);
var
  vUser: TCSUser;
begin
  if nFrom=nTo then exit;
  vUser:=TCSUser.Create;
  vUser.Assign(User[nTo]);
  User[nTo].Assign(User[nFrom]);
  User[nFrom].Assign(vUser);
  vUser.Free;
end;
//==============================================================================
procedure TCSUserList.Shuffle;
var
  i,n: integer;
  user: TCSUser;
begin
  i:=0;
  while i<Count do begin
    n:=Random(Count-i);
    Swap(n,i);
    inc(i);
  end;
end;
//==============================================================================
procedure TCSUserList.DeleteUser(p_Login: string);
var
  n: integer;
begin
  n:=IndexOfUser(p_Login);
  if n<>-1 then Delete(n);
end;
//==============================================================================
function TCSUserList.GetUser(Num: integer): TCSUser;
begin
  result:=TCSUser(Items[Num]);
end;
//==============================================================================
function TCSUserList.IndexOfUser(p_Login: string): integer;
var
  user: TCSUser;
  i: integer;
begin
  for i:=0 to Count-1 do begin
    user:=TCSUser(Items[i]);
    if user.Login=p_Login then begin
      result:=i;
      exit;
    end;
  end;
  result:=-1;
end;
//==============================================================================
procedure TCSUserList.InsOrUpdUser(p_Login, p_Title: string; p_Rating: integer);
var
  user: TCSUser;
  n: integer;
begin
  n:=IndexOfUser(p_Login);
  if n=-1 then begin
    user:=TCSUser.Create;
    Add(user);
  end else
    user:=TCSUser(Items[n]);

  user.Login:=p_Login;
  user.Title:=p_Title;
  user.Rating:=p_Rating;
end;
//==============================================================================
function TCSUserList.ByeCountElim: integer;
var
  n: integer;
begin
  n:=1;
  while n<Count do n:=n*2;
  result:=n-Count;
end;
//==============================================================================
{ TCSReglament }
//==============================================================================
procedure TCSReglament.ClearGames;
begin
  FReglGames.Clear;
end;
//==============================================================================
procedure TCSReglament.CountRanks(RoundNum: integer = -1);
var
  i,j,nLess,nEqual: integer;
  user,user1: TCSUser;
begin
  CountScore(RoundNum);
  for j:=0 to MemberList.Count-1 do begin
    user:=TCSUser(MemberList[j]);
    nLess:=0; nEqual:=0;
    for i:=0 to MemberList.Count-1 do
      if i<>j then begin
        user1:=TCSUser(MemberList[i]);
        if user.DoubleScore=user1.DoubleScore then inc(nEqual)
        else if user.DoubleScore<user1.DoubleScore then inc(nLess);
      end;
    user.RankMin:=nLess+1;
    user.RankMax:=nLess+nEqual+1;
  end;
end;
//==============================================================================
procedure TCSReglament.CountScore(RoundNum: integer = -1);
var
  i,j,n: integer;
  rgame: TCSReglGame;
  user: TCSUser;
begin
  for j:=0 to MemberList.Count-1 do begin
    user:=TCSUser(MemberList[j]);
    n:=0;
    for i:=0 to ReglGames.Count-1 do begin
      rgame:=TCSReglGame(ReglGames[i]);
      if ((rgame.RoundNum<=RoundNum) or (RoundNum=-1))
        and ((rgame.WhiteNum=j) and (rgame.Result=rgrWhiteWin)
        or (rgame.BlackNum=j) and (rgame.Result=rgrBlackWin))
      then
        n:=n+2
      else
        if ((rgame.WhiteNum=j) or (rgame.BlackNum=j)) and (rgame.result=rgrDraw) then
          n:=n+1;
    end;
    user.DoubleScore:=n;
  end;
end;
//==============================================================================
constructor TCSReglament.Create;
begin
  FReglGames:=TList.Create;
  FMemberList:=TCSUserList.Create;
  FCurRound:=1;
  FAcceptTime:=120;
end;
//==============================================================================
function TCSReglament.CurRoundCompleted: Boolean;
var
  i: integer;
begin
  result:=false;
  for i:=0 to GamesCount-1 do
    if (Games[i].RoundNum<=CurRound) and (Games[i].Result=rgrNone)
      and not (Games[i].IsByeGame)
    then
      exit;
  result:=true;
end;
//==============================================================================
function TCSReglament.CurRoundWins(p_Login: string): integer;
var
  win,draw,loss: integer;
begin
  Results(p_Login,CurRound,win,draw,loss);
  result:=win;
end;
//==============================================================================
destructor TCSReglament.Destroy;
begin
  FReglGames.Free;
  FMemberList.Free;
end;
//==============================================================================
function TCSReglament.FindGameByID(p_ID: integer): TCSReglGame;
var
  i: integer;
begin
  for i:=0 to GamesCount-1 do
    if Games[i].ID=p_ID then begin
      result:=Games[i];
      exit;
    end;
  result:=nil;
end;
//==============================================================================
function TCSReglament.FindGameByNum(GameNum: integer): TCSReglGame;
var
  i: integer;
begin
  for i:=0 to GamesCount-1 do
    if Games[i].GameNum=GameNum then begin
      result:=Games[i];
      exit;
    end;
  result:=nil;
end;
//==============================================================================
function TCSReglament.GetGames(Index: integer): TCSReglGame;
begin
  result:=TCSReglGame(FReglGames[Index]);
end;
//==============================================================================
function TCSReglament.GetGamesCount: integer;
begin
  result:=FReglGames.Count;
end;
//==============================================================================
function TCSReglament.GetNextReglGame(Login: string; WhiteOnly: Boolean): TCSReglGame;
var
  i,index: integer;
begin
  index:=MemberList.IndexOfUser(Login);
  for i:=0 to GamesCount-1 do begin
    result:=Games[i];
    if (result.RoundNum=CurRound) and (result.Result=rgrNone)
      and ((index=result.WhiteNum) or (index=result.BlackNum) and not WhiteOnly)
    then
      exit;
  end;
  result:=nil;
end;
//==============================================================================
procedure TCSReglament.InsOrUpdGame(ID, WhiteNum, BlackNum: integer;
  InitTime: string;
  IncTime, GameNum, RoundNum, AddNum: integer; Result: TCSReglGameResult);
var
  rgame: TCSReglGame;
begin
  rgame:=FindGameByID(ID);
  if rgame=nil then begin
    rgame:=TCSReglGame.Create;
    FReglGames.Add(rgame);
  end;
  rgame.ID:=ID;
  rgame.WhiteNum:=WhiteNum;
  rgame.BlackNum:=BlackNum;
  rgame.InitTime:=InitTime;
  rgame.IncTime:=IncTime;
  rgame.GameNum:=GameNum;
  rgame.RoundNum:=RoundNum;
  rgame.AddNum:=AddNum;
  rgame.Result:=Result;
  if CurRound<RoundNum then
    FCurRound:=RoundNum;
end;
//==============================================================================
procedure TCSReglament.MakeStartReglament;
begin
  MemberList.Shuffle;
  FReglGames.Clear;
  case FTourType of
    trtRound: MakeStartreglamentRound;
    trtElim: MakeStartReglamentElim;
    trtMatch: MakeStartReglamentMatch;
    trtSwiss: NextRoundSwiss;
  end;
end;
//==============================================================================
procedure TCSReglament.MakeStartReglamentElim;
var
  i,bye: integer;
  //****************************************************************************
  procedure CreateElimGame(p_WhiteNum,p_BlackNum: integer; p_Result: TCSReglGameResult);
  var
    rgame: TCSReglGame;
  begin
    rgame:=AddNewRGame(p_WhiteNum,p_BlackNum);
    rgame.Result:=p_Result;
  end;
  //****************************************************************************
begin
  bye:=MemberList.ByeCountElim;
  for i:=0 to (MemberList.Count - bye) div 2 - 1 do
    CreateElimGame(i*2,i*2+1,rgrNone);
  for i:=MemberList.Count - bye to MemberList.Count-1 do
    CreateElimGame(i,-1,rgrWhiteWin);
end;
//==============================================================================
var
  RGL_ROUND: array[2..16] of string =
    ('0-1',
     '0-1,2-0,1-2',
     '0-1,2-3,3-0,1-2,0-2,1-3',
     '0-1,2-3,0-2,1-4,4-0,2-1,3-0,2-4,1-2,4-3',
     '0-1,2-3,4-5,3-0,5-1,2-4,0-5,1-2,4-3,2-0,1-4,3-5,0-4,1-3,5-2',
     '1-6,2-5,3-4,0-1,6-2,5-3,2-0,3-6,4-5,0-3,1-2,6-4,4-0,3-1,5-6,0-5,1-4,2-3,6-0,5-1,4-2',
     '1-6,2-5,3-4,0-7,0-1,6-2,5-3,7-4,2-0,3-6,4-5,1-7,0-3,1-2,6-4,7-5,4-0,3-1,5-6,2-7,0-5,1-4,2-3,7-6,6-0,5-1,4-2,3-7',
     '1-8,2-7,3-6,4-5,0-1,8-2,7-3,6-4,2-0,3-8,4-7,5-6,0-3,1-2,8-4,7-5,4-0,3-1,5-8,6-7,0-5,1-4,2-3,8-6,6-0,5-1,4-2,7-8,0-7,1-6,2-5,3-4,8-0,7-1,6-2,5-3',
     '1-8,2-7,3-6,4-5,0-9,0-1,8-2,7-3,6-4,9-5,2-0,3-8,4-7,5-6,1-9,0-3,1-2,8-4,7-5,9-6,4-0,3-1,5-8,6-7,2-9,0-5,1-4,2-3,8-6,9-7,6-0,5-1,4-2,7-8,3-9,0-7,1-6,2-5,3-4,9-8,8-0,7-1,6-2,5-3,4-9',
     '1-10,2-9,3-8,4-7,5-6,0-1,10-2,9-3,8-4,7-5,2-0,3-10,4-9,5-8,6-7,0-3,1-2,10-4,9-5,8-6,4-0,3-1,5-10,6-9,7-8,0-5,1-4,2-3,10-6,9-7,6-0,5-1,4-2,7-10,8-9,0-7,1-6,2-5,3-4,10-8,8-0,7-1,6-2,5-3,9-10,0-9,1-8,2-7,3-6,4-5,10-0,9-1,8-2,7-3,6-4',
     '','','','','');
procedure TCSReglament.MakeStartReglamentRound;
var
  i,j,wht,blk,n,ppl,RoundNum,GamesPerRound,NextID: integer;
  CurRgl,s: string;
  slRgl: TStringList;
  rgame: TCSReglGame;
begin
  RGL_ROUND[12]:='1-10,2-9,3-8,4-7,5-6,0-11,0-1,10-2,9-3,8-4,7-5,11-6,2-0,3-10,4-9,5-8,6-7,1-11,0-3,'+
    '1-2,10-4,9-5,8-6,11-7,4-0,3-1,5-10,6-9,7-8,2-11,0-5,1-4,2-3,10-6,9-7,11-8,6-0,5-1,4-2,7-10,8-9,3-11,0-7,1-6,2-5,3-4,10-8,11-9,8-0,7-1,6-2,5-3,9-10,4-11,0-9,1-8,2-7,3-6,4-5,11-10,10-0,9-1,8-2,7-3,6-4,5-11';
  RGL_ROUND[13]:='1-12,2-11,3-10,4-9,5-8,6-7,0-1,12-2,11-3,10-4,9-5,8-6,2-0,3-12,4-11,5-10,6-9,7-8,0-3,'+
    '1-2,12-4,11-5,10-6,9-7,4-0,3-1,5-12,6-11,7-10,8-9,0-5,1-4,2-3,12-6,11-7,10-8,6-0,5-1,4-2,7-12,8-11,'+
    '9-10,0-7,1-6,2-5,3-4,12-8,11-9,8-0,7-1,6-2,5-3,9-12,10-11,0-9,1-8,2-7,3-6,4-5,12-10,10-0,9-1,8-2,7-3,6-4,11-12,0-11,1-10,2-9,3-8,4-7,5-6,12-0,11-1,10-2,9-3,8-4,7-5';
  RGL_ROUND[14]:='1-12,2-11,3-10,4-9,5-8,6-7,0-13,0-1,12-2,11-3,10-4,9-5,8-6,13-7,2-0,3-12,4-11,5-10,6-9,'+
    '7-8,1-13,0-3,1-2,12-4,11-5,10-6,9-7,13-8,4-0,3-1,5-12,6-11,7-10,8-9,2-13,0-5,1-4,2-3,12-6,11-7,10-8,'+
    '13-9,6-0,5-1,4-2,7-12,8-11,9-10,3-13,0-7,1-6,2-5,3-4,12-8,11-9,13-10,8-0,7-1,6-2,5-3,9-12,10-11,4-13,'+
    '0-9,1-8,2-7,3-6,4-5,12-10,13-11,10-0,9-1,8-2,7-3,6-4,11-12,5-13,0-11,1-10,2-9,3-8,4-7,5-6,13-12,12-0,'+
    '11-1,10-2,9-3,8-4,7-5,6-13';
  RGL_ROUND[15]:='1-14,2-13,3-12,4-11,5-10,6-9,7-8,0-1,14-2,13-3,12-4,11-5,10-6,9-7,2-0,3-14,4-13,5-12,6-11,'+
    '7-10,8-9,0-3,1-2,14-4,13-5,12-6,11-7,10-8,4-0,3-1,5-14,6-13,7-12,8-11,9-10,0-5,1-4,2-3,14-6,13-7,12-8,'+
    '11-9,6-0,5-1,4-2,7-14,8-13,9-12,10-11,0-7,1-6,2-5,3-4,14-8,13-9,12-10,8-0,7-1,6-2,5-3,9-14,10-13,11-12,'+
    '0-9,1-8,2-7,3-6,4-5,14-10,13-11,10-0,9-1,8-2,7-3,6-4,11-14,12-13,0-11,1-10,2-9,3-8,4-7,5-6,14-12,12-0,'+
    '11-1,10-2,9-3,8-4,7-5,13-14,0-13,1-12,2-11,3-10,4-9,5-8,6-7,14-0,13-1,12-2,11-3,10-4,9-5,8-6';
  RGL_ROUND[16]:='1-14,2-13,3-12,4-11,5-10,6-9,7-8,0-15,0-1,14-2,13-3,12-4,11-5,10-6,9-7,15-8,2-0,3-14,4-13,'+
    '5-12,6-11,7-10,8-9,1-15,0-3,1-2,14-4,13-5,12-6,11-7,10-8,15-9,4-0,3-1,5-14,6-13,7-12,8-11,9-10,2-15,0-5,'+
    '1-4,2-3,14-6,13-7,12-8,11-9,15-10,6-0,5-1,4-2,7-14,8-13,9-12,10-11,3-15,0-7,1-6,2-5,3-4,14-8,13-9,12-10,'+
    '15-11,8-0,7-1,6-2,5-3,9-14,10-13,11-12,4-15,0-9,1-8,2-7,3-6,4-5,14-10,13-11,15-12,10-0,9-1,8-2,7-3,6-4,'+
    '11-14,12-13,5-15,0-11,1-10,2-9,3-8,4-7,5-6,14-12,15-13,12-0,11-1,10-2,9-3,8-4,7-5,13-14,6-15,0-13,1-12,'+
    '2-11,3-10,4-9,5-8,6-7,15-14,14-0,13-1,12-2,11-3,10-4,9-5,8-6,7-15';

  ppl:=MemberList.Count;
  if (ppl<2) or (ppl>High(RGL_ROUND)) then
    raise exception.create(Format('Don''t know reglament for %d number of people',[ppl]));

  slRgl:=TStringList.Create;
  try
    CurRgl:=RGL_ROUND[ppl];
    slRgl.CommaText:=CurRgl;

    RoundNum:=0;
    GamesPerRound:=ppl div 2;
    for j:=1 to ENumber do
      for i:=0 to slRgl.Count-1 do begin
        if ReglGames.Count mod GamesPerRound=0 then
          inc(RoundNum);

        s:=slRgl[i];
        n:=pos('-',s);
        wht:=StrToInt(copy(s,1,n-1));
        blk:=StrToInt(copy(s,n+1,length(s)));

        if j mod 2 = 0 then begin
          n:=wht; wht:=blk; blk:=n;
        end;

        rgame:=AddNewRGame(wht,blk);
        rgame.RoundNum:=RoundNum;
      end;
  finally
    slRgl.Free;
  end;
end;
//==============================================================================
procedure TCSReglament.NextRound;
var
  i: integer;
  rgame: TCSReglGame;
begin
  inc(FCurRound);
  for i:=0 to GamesCount-1 do begin
    rgame:=ReglGames[i];
    if rgame.RoundNum=FCurRound then
      rgame.StartTime:=Now+AcceptTime/(24*60*60);
  end;
  case TourType of
    trtElim: NextRoundElim;
    trtMatch: NextRoundMatch;
    trtSwiss: NextRoundSwiss;
  end;
end;
//==============================================================================
procedure TCSReglament.NextRoundElim;
var
  i,whitenum: integer;
begin
  i:=0; whitenum:=-1;
  while i<MemberList.Count do begin
    if (RoundWins(MemberList[i].Login,CurRound-1)>=ENumber)
      or RoundBye(MemberList[i].Login,CurRound-1)
    then begin
      if whitenum=-1 then whitenum:=i
      else begin
        AddNewRGame(whitenum,i);
        whitenum:=-1;
      end;
    end;
    inc(i);
  end;
end;
//==============================================================================
procedure TCSReglament.NextRoundMatch;
var
  n: integer;
begin
  n:=GamesCount mod 2;
  AddNewRGame(n,1-n);
end;
//==============================================================================
function TCSReglament.OnReglGameResult(rgame: TCSReglGame): TCSReglGame;
var
  newrgame: TCSReglGame;
begin
  result:=nil;
  if TourType=trtRound then exit;
  if TourType=trtElim then begin
    if (CurRoundWins(MemberList[rgame.WhiteNum].Login)<ENumber)
      and (CurRoundWins(MemberList[rgame.BlackNum].Login)<ENumber)
    then begin
      newrgame:=AddNewRGame(rgame.BlackNum,rgame.WhiteNum);
      newrgame.AddNum:=rgame.AddNum+1;
      result:=newrgame;
    end;
  end;
end;
//==============================================================================
function TCSReglament.RoundWins(const p_Login: string; p_RoundNum: integer): integer;
var
  draw,loss: integer;
begin
  Results(p_Login,p_RoundNum,result,draw,loss);
end;
//==============================================================================
procedure TCSReglament.Results(const p_Login: string; p_Round: integer;
  var pp_Win, pp_Loss, pp_Draw: integer);
var
  i: integer;
  rgame: TCSReglGame;
  whitename,blackname: string;
begin
  pp_Win:=0; pp_Loss:=0; pp_Draw:=0;
  for i:=0 to GamesCount-1 do begin
    rgame:=Games[i];
    if (rgame.result=rgrNone) or (rgame.IsByeGame) then continue;
    if (rgame.RoundNum<>p_Round) and (p_Round<>-1) then continue;
    whitename:=MemberList[rgame.WhiteNum].Login;
    blackname:=MemberList[rgame.BlackNum].Login;
    if (whitename<>p_Login) and (blackname<>p_Login) then continue;
    if rgame.Result=rgrDraw then inc(pp_Draw)
    else if (rgame.Result=rgrWhiteWIn) and (whitename=p_Login) or
      (rgame.Result=rgrBlackWin) and (blackname=p_Login)
    then
      inc(pp_Win)
    else
      inc(pp_Loss);
  end;
end;
//==============================================================================
function TCSReglament.RoundCount: integer;
var
  i: integer;
begin
  result:=0;
  for i:=0 to GamesCount-1 do
    if Games[i].RoundNum>result then
      result:=Games[i].RoundNum;
end;
//==============================================================================
function TCSReglament.TournamentCompleted: Boolean;
var
  i,wins0,wins1: integer;
begin
  case TourType of
    trtRound: result:=AllGamesCompleted;
    trtElim: result:=AllGamesCompleted and (RoundCount=ElimFullRoundCount);
    trtMatch:
      if NumberOfRounds<>0 then
        result:=AllGamesCompleted and (RoundCount>=NumberOfRounds)
      else begin
        CountMatchResult(wins0,wins1);
        result:=(wins0>=ENumber) or (wins1>=ENumber);
      end;
    trtSwiss:
      result:=AllGamesCompleted and (RoundCount>=NumberOfRounds);
  end;
end;
//==============================================================================
procedure TCSReglament.UpdateGame(ID, GameNum: integer;
  Result: TCSReglGameResult);
var
  rgame: TCSReglGame;
begin
  rgame:=FindGameByID(ID);
  if rgame=nil then exit;
  rgame.GameNum:=GameNum;
  rgame.Result:=Result;
end;
//==============================================================================
function TCSReglament.UserIsRoundMember(const p_Login: string; RoundNum: integer): Boolean;
begin
  result:=(TourType<>trtElim) or (RoundNum=1)
    or (RoundWins(p_Login,RoundNum-1)>=ENumber)
    or RoundBye(p_Login,RoundNum-1);
end;
//==============================================================================
function TCSReglament.RoundBye(const p_Login: string; p_RoundNum: integer): Boolean;
var
  i: integer;
  rgame: TCSReglGame;
begin
  result:=true;
  for i:=0 to ReglGames.Count-1 do begin
    rgame:=TCSReglGame(ReglGames[i]);
    if (rgame.RoundNum=p_RoundNum) and
      (MemberList[rgame.WhiteNum].Login=p_Login) and (rgame.BlackNum=-1)
    then
      exit;
  end;
  result:=false;
end;
//==============================================================================
function TCSReglament.ElimFullRoundCount: integer;
var
  n: integer;
begin
  n:=1;
  result:=0;
  while n<MemberList.Count do begin
    inc(result);
    n:=n*2;
  end;
end;
//==============================================================================
function TCSReglament.AllGamesCompleted: Boolean;
var
  i: integer;
begin
  result:=false;
  for i:=0 to GamesCount-1 do
    if (Games[i].Result=rgrNone) and not (Games[i].IsByeGame) then
      exit;
  result:=true;
end;
//==============================================================================
procedure TCSReglament.MakeStartReglamentMatch;
var
  i: integer;
begin
  if MemberList.Count<>2 then exit;
  AddNewRGame(0,1);
end;
//==============================================================================
procedure TCSReglament.CountMatchResult(var pp_Wins0,pp_Wins1: integer);
var
  i: integer;
  rgame: TCSReglGame;
begin
  pp_Wins0:=0; pp_Wins1:=0;
  for i:=0 to GamesCount-1 do begin
    rgame:=Games[i];
    if rgame.result in [rgrWhiteWin,rgrBlackWin] then
      if (rgame.WhiteNum=0) and (rgame.result=rgrWhiteWin)
        or (rgame.BlackNum=0) and (rgame.result=rgrBlackWin)
      then
        inc(pp_Wins0)
      else
        inc(pp_Wins1);
  end;
end;
//==============================================================================
function TCSReglament.AddNewRGame(const p_WhiteNum, p_BlackNum: integer): TCSReglGame;
var
  rgame: TCSReglGame;
begin
  rgame:=TCSReglGame.Create;
  rgame.ID:=ReglGames.Count;
  rgame.WhiteNum:=p_WhiteNum;
  rgame.BlackNum:=p_BlackNum;
  rgame.InitTime:=InitTime;
  rgame.IncTime:=IncTime;
  rgame.GameNum:=-1;
  rgame.RoundNum:=CurRound;
  rgame.AddNum:=1;
  rgame.Result:=rgrNone;
  rgame.StartTime:=Now+AcceptTime/(24*60*60);

  FReglGames.Add(rgame);
  result:=rgame;
end;
//==============================================================================
procedure TCSReglament.NextRoundSwiss;
var
  slSorted: TStringList;
  StartRGameThisRound: integer;
  //****************************************************************************
  function RealNum(PlayerNum: integer): integer;
  begin
    result:=StrToInt(slSorted[PlayerNum]);
  end;
  //****************************************************************************
  procedure MakeSortedList;
  var
    i,j,n: integer;
    user: TCSUser;
    sl: TStringList;
    s,sRating,sScore: string;
  begin
    slSorted:=TStringList.Create;
    sl:=TStringList.Create;
    for i:=0 to MemberList.Count-1 do begin
      user:=MemberList[i];
      //n:=user.DoubleScore*10000+user.Rating;
      sScore:=IntToStr(user.DoubleScore);
      for j:=length(sScore)+1 to 5 do
        sScore:='0'+sScore;

      sRating:=IntToStr(user.Rating);
      for j:=length(sRating)+1 to 4 do
        sRating:='0'+sRating;
      sl.Add(Format('%s%s-%d',[sScore,sRating,i]));
    end;
    sl.Sort;
    for i:=sl.Count-1 downto 0 do begin
      s:=sl[i];
      n:=pos('-',s);
      s:=copy(s,n+1,length(s));
      slSorted.Add(s);
    end;
    sl.Free;
  end;
  //****************************************************************************
  function GameThisRoundExists(p_Player: integer): Boolean;
  var
    i: integer;
    rgame: TCSReglGame;
  begin
    result:=true;
    for i:=StartRGameThisRound to ReglGames.Count-1 do begin
      rgame:=ReglGames[i];
      if (rgame.WhiteNum=p_Player) or (rgame.BlackNum=p_Player) then
        exit;
    end;
    result:=false;
  end;
  //****************************************************************************
  function FindNextFreePlayer(p_Start: integer): integer;
  var
    i: integer;
    rgame: TCSReglGame;
  begin
    result:=-1;
    for i:=p_Start to slSorted.Count-1 do
      if not GameThisRoundExists(RealNum(i)) then begin
        result:=i;
        exit;
      end;
  end;
  //****************************************************************************
  function LastUserColor(PlayerNum: integer): integer; // -1 - no games, 0 - black, 1 - white
  var
    i: integer;
    rgame: TCSReglGame;
  begin
    result:=-1;
    for i:=ReglGames.Count-1 downto 0 do begin
      rgame:=ReglGames[i];
      if rgame.WhiteNum=PlayerNum then begin
        result:=1;
        exit;
      end else if rgame.BlackNum=PlayerNum then begin
        result:=0;
        exit;
      end;
    end;
  end;
  //****************************************************************************
  function TryToMake(p_Start: integer; p_Repeat: Boolean): Boolean;
  var
    i,PlayerNum1,PlayerNum2: integer;
  begin
    PlayerNum1:=FindNextFreePlayer(p_Start);
    // if all players are already in parring, exit
    if PlayerNum1=-1 then begin
      result:=true;
      exit;
    end;
    PlayerNum2:=FindNextFreePlayer(PlayerNum1+1);
    // if last player rest and number of player is odd, he plays bye if he didn't play bye before
    if PlayerNum2=-1 then begin
      result:=p_Repeat or not GameExists(RealNum(PlayerNum1),-1);
      if result then AddNewRGame(RealNum(PlayerNum1),-1);
      exit;
    end;
    // else we go over all rest players and find for the good parring
    while true do begin
      if p_Repeat or not GameExists(RealNum(PlayerNum1),RealNum(PlayerNum2)) then begin
        if LastUserColor(RealNum(PlayerNum1))=1 then AddNewRGame(RealNum(PlayerNum2),RealNum(PlayerNum1))
        else AddNewRGame(RealNum(PlayerNum1),RealNum(PlayerNum2));
        if TryToMake(PlayerNum1+1,p_Repeat) then begin
          result:=true;
          exit;
        end else begin
          TCSReglGame(ReglGames[ReglGames.Count-1]).Free;
          ReglGames.Delete(ReglGames.Count-1);
        end;
      end;
      PlayerNum2:=FindNextFreePlayer(PlayerNum2+1);
      if PlayerNum2=-1 then begin
        result:=false;
        exit;
      end;
    end;
  end;
  //****************************************************************************
  procedure MakeStartSwiss;
  var
    i: integer;
  begin
    for i:=0 to slSorted.Count div 2 - 1 do begin
      if i mod 2 = 0 then AddNewRGame(RealNum(i),RealNum(slSorted.Count div 2 + i))
      else AddNewRGame(RealNum(slSorted.Count div 2 + i), RealNum(i));
    end;
    if slSorted.Count mod 2 = 1 then
      AddNewRGame(RealNum(slSorted.Count-1),-1);
  end;
  //****************************************************************************
begin
  StartRGameThisRound:=ReglGames.Count;
  CountScore;
  MakeSortedList;
  if CurRound = 1 then MakeStartSwiss
  else
    if not TryToMake(0,false) then
      TryToMake(0,true);
  slSorted.Free;
end;
//==============================================================================
function TCSReglament.GameExists(PlayerNum1, PlayerNum2: integer): Boolean;
var
  i: integer;
  rgame: TCSReglGame;
begin
  result:=true;
  for i:=0 to ReglGames.Count-1 do begin
    rgame:=ReglGames[i];
    if (rgame.WhiteNum=PlayerNum1) and (rgame.BlackNum=PlayerNum2) or
       (rgame.BlackNum=PlayerNum1) and (rgame.WhiteNum=PlayerNum2)
    then
      exit;
  end;
  result:=false;
end;
//==============================================================================
procedure TCSReglament.CountRanksFinishedRounds;
var
  n: integer;
begin
  if TournamentCompleted then n:=-1
  else if CurRoundCompleted then n:=CurRound
  else n:=CurRound-1;
  CountRanks(n);
end;
//==============================================================================
function TCSReglament.RoundByGameNum(GameNum: integer): integer;
var
  i: integer;
  rgame: TCSReglGame;
begin
  for i:=0 to ReglGames.Count-1 do begin
    rgame:=TCSReglGame(ReglGames[i]);
    if (rgame.GameNum = GameNum) then begin
      result:=rgame.RoundNum;
      exit;
    end;
  end;
  result:=-1;
end;
//==============================================================================
end.

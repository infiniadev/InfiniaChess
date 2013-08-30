unit CSLecture;

interface

uses CSEvent,Classes,CSReglament,CSConnection,SysUtils,contnrs;

type
  TCSLectureActionType = (leaLecturerChat, leaStudentChat, leaMove,
    leaBack, leaForward, leaRevert, leaCircle, leaArrow);

  TCSLectureAction = class
    ActionType: TCSLectureActionType;
    Param1: integer;
    Param2: string;
  end;

  TCSLectureActions = class(TObjectList)
  private
    function GetAction(Index: integer): TCSLectureAction;
  public
    property Action[Index: integer]: TCSLectureAction read GetAction;
  end;

  TCSLecture = class(TCSEvent)
  private
    procedure StartGames; override;
    procedure Finish; override;
  public
    Actions: TCSLectureActions;
    procedure CheckEventFinished; override;
    constructor Create; override;
    destructor Destroy; override;
    procedure AddAction(ActionType: TCSLectureActionType; Param1: integer; Param2: string);
  end;

implementation

{ TCSLecture }

uses CSGame, CSGames, CSLib, CSSocket, CSConnections, CSConst, CSDb;

//=============================================================================
destructor TCSLecture.Destroy;
begin
  inherited;
  Actions.Free;
end;
//=============================================================================
constructor TCSLecture.Create;
begin
  inherited;
  Actions := TCSLectureActions.Create;
end;
//=============================================================================
procedure TCSLecture.Finish;
begin
  Status := estFinished;
  fSocket.Send(fConnections.Connections,[DP_EVENT_FINISHED,IntToStr(ID)],Self);
end;
//=============================================================================
procedure TCSLecture.StartGames;
var
  i,GameNum: integer;
  conn: TConnection;
  LeaderWhite: Boolean;
  Game: TGame;
begin
  GameNum:=Games.Count+1;

  Game:=TGame.Create(connLeader,connLeader);
  Game.EventOrdNum:=GameNum;
  Game.EventID := Self.ID;
  Games.Add(Game);
  CSGames.fGames.Games.Add(Game);

  //conn.EventUserState:=eusObserver;
  SendGamesBorn(GameNum);
  for i:=0 to Users.Count-1 do begin
    conn:=TConnection(Users[i]);
    Game.AddConnection(conn);
    conn.AddGame(Game);
  end;
end;
//=============================================================================
procedure TCSLecture.AddAction(ActionType: TCSLectureActionType;
  Param1: integer; Param2: string);
var
  action: TCSLectureAction;
begin
  action := TCSLectureAction.Create;
  action.ActionType := ActionType;
  action.Param1 := Param1;
  action.Param2 := Param2;
  Actions.Add(action);
  fDB.SaveLectureAction(Self.ID, Actions.Count-1, ord(ActionType), Param1, Param2); 
end;
//=============================================================================
procedure TCSLecture.CheckEventFinished;
begin
  //
end;
//=============================================================================
{ TCSLectureActions }

function TCSLectureActions.GetAction(Index: integer): TCSLectureAction;
begin
  result := TCSLectureAction(Items[Index]);
end;
//=============================================================================
end.

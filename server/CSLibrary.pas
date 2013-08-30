{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSLibrary;

interface

uses
  classes, SysUtils, CSConnection;

type
  TLibrary = class(TObject)
    private
    { Private declarations }
    procedure LibraryAdd(var Connection: TConnection; GameID: integer);

  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    procedure CMD_LibraryAdd(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_LibraryRemove(var Connection: TConnection; var CMD: TStrings);
end;

var
  fLibrary: TLibrary;

implementation

uses
  ADOInt, CSConst, CSDB, CSSocket, CSGame, CSGames;

{ TLibrary }
//==============================================================================
constructor TLibrary.Create;
begin

end;
//==============================================================================
destructor TLibrary.Destroy;
begin
  inherited;
end;
//==============================================================================
procedure TLibrary.CMD_LibraryAdd(var Connection: TConnection; var CMD: TStrings);
var
  ID, DbGameID: Integer;
  IdType: string; // 'd' - database, 'g' - gamenumber
  s: string;
  GM: TGame;
begin
  { Verify registered lgoin }
  if not Connection.Registered then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_REGISTERED_ONLY],nil);
      Exit;
    end;

  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Check paramater values }
  try
    ID := StrToInt(CMD[1]);
  except
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE]);
      Exit;
    end;
  end;

  if CMD.Count > 2 then IdType := CMD[2]
  else IdType := 'd';

  if IdType = 'd' then DbGameID := ID
  else begin
    GM := fGames.GetGame(ID);
    if GM = nil then begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
        Format(DP_MSG_GAMEID_NOT_VALID, [IntToStr(ID)])]);
      exit;
    end;

    if GM.DbGameId = 0 then begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
        'This game is not saved to database yet']);
      exit;
    end;

    DbGameID := GM.DbGameID;
  end;

  LibraryAdd(Connection, DbGameID);
end;
//==============================================================================
procedure TLibrary.CMD_LibraryRemove(var Connection: TConnection;
  var CMD: TStrings);
const
  GAMEID = 1;
var
  Index: Integer;
  s: string;
begin
  { Verify registered lgoin }
  if not Connection.Registered then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_REGISTERED_ONLY]);
      Exit;
    end;
  { Parameter check:
    CMD[0] = /Command
    CMD[1] = GameIDID }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
      Exit;
    end;
  { Check paramater values }
  try
    Index := StrToInt(CMD[GAMEID]);
  except
    begin
      fSocket.Send(Connection,
        [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE]);
      Exit;
    end;
  end;
  { Database call. }
  Index := fDB.LibraryRemove(Connection.LoginID, Index);
  { Examine DB call result.}
  case Index of
    -1: { Invalid LoginID. Should never happen in this code. };
    -2: s := DP_MSG_NOT_IN_LIB;
    DB_ERROR: { ??? DB error. Need to send a message to user. };
  else
    s := DP_MSG_LIBRARY_REMOVED;
  end;
  { Format and send message to user. }
  s := Format(s, [CMD[GAMEID]]);
  if Index < 0 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s])
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
end;
//==============================================================================
procedure TLibrary.LibraryAdd(var Connection: TConnection; GameID: integer);
var
  res: integer;
  s: string;
begin
  res := fDB.LibraryAdd(Connection.LoginID, GameID);
  case res of
    -1: { Invalid LoginID. Should never happen in this code. };
    -2: s := DP_MSG_GAMEID_NOT_VALID;
    -3: s := DP_MSG_ALREADY_IN_LIB;
    -4: s := DP_MSG_LIBRARY_FULL;
    DB_ERROR: { ??? DB error. Need to send a message to user. };
  else
    s := DP_MSG_LIBRARY_ADDED;
  end;
  { Format and send message to user. }
  s := Format(s, [IntToStr(GameID)]);
  if res < 0 then
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s])
  else
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s]);
end;
//==============================================================================
end.

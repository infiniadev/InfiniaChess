{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSRooms;

interface

uses
  classes, contnrs, sysutils, CSConnection, CSRoom;

type
  TRooms = class(TObject)
    private
    { Private declarations }
    FRooms: TObjectList;



  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    function IndexOf(const RoomNumber: Integer): Integer;
    procedure CMD_CreateRoom(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Enter(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Exit(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Invite(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_Tell(var Connection: TConnection; var CMD: TStrings);
    procedure CMD_DeleteRoom(var Connection: TConnection; var CMD: TStrings);
    procedure EnterRoom(var Connection: TConnection; const RoomNumber: Integer);
    procedure ExitRoom(var Connection: TConnection; const RoomNumber: Integer; SendMessage: Boolean = true);
    procedure ReEnterRoom(var Connection: TConnection);
    procedure Release(var Connection: TConnection);
    procedure SendRoomDefs(const Connection: TConnection);
    procedure SendRoomSet(const Connection: TConnection);

    {??? Temporary property. Used only for the CLServerService form.
     Remove when a NT Service. }
    property Rooms: TObjectList read FRooms;
end;

var
  fRooms: TRooms;

implementation

uses
  CSConnections, CSConst, CSService, CSSocket, CSEvents, CSLib, CSDb;

const
  ROOM_MOD = 10;
  PRIVATE_ROOM_LIMIT = 25;

{ TRooms }
//______________________________________________________________________________
procedure TRooms.ExitRoom(var Connection: TConnection; const RoomNumber: Integer; SendMessage: Boolean = true);
var
  _Connection: TConnection;
  Room: TRoom;
  Index, RIndex: Integer;
  s: string;
begin
  { Double check room exists. }
  RIndex := IndexOf(RoomNumber);
  { If room does not exist then exit. }
  if RIndex < 0 then
    begin
      s := Format(DP_MSG_NON_EXISTANT_ROOM, [IntToStr(RoomNumber)]);
      if SendMessage then fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Get the Room object }
  Room := TRoom(FRooms[RIndex]);
  { Verify the Connection is actually in the room. }
  Index := Room.IndexOf(Connection);
  if Index < 0 then
    begin
      s := Format(DP_MSG_NOT_IN_ROOM, [IntToStr(RoomNumber)]);
      if SendMessage then fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Remove Connection from RoomList }
  Room.Connections.Delete(Index);

  { Set the Cmd and CmdParam to nothing if this was the last room spoken in. }
  with Connection do
    if (LastCmd = CMD_STR_TELL) and (CmdParam = IntToStr(RoomNumber)) then
      begin
        LastCmd := '';
        CmdParam := '';
      end;

  { Decrement the RoomCount property of the Connection }
  Connection.RoomCount := Connection.RoomCount -1;
  if Connection.RoomCount < 0 then Connection.RoomCount := 0;

  { Send DP_ROOM_I_EXIT to Connection }
  fSocket.Send(Connection, [DP_ROOM_I_EXIT, IntToStr(RoomNumber)],nil);

  { Notify Connections of the Room about this Connections exit. }
  fSocket.Send(Room.Connections, [DP_ROOM_EXIT, IntToStr(RoomNumber),
    IntToStr(Connection.LoginID), Connection.Handle],Connection);

  { if Room is empty then Destroy, Send DP_ROOM_DESTROY }
  if (Room.Connections.Count = 0) and (Room.Creator <> '') then
    begin
      _Connection := fConnections.GetConnection(Room.Creator);
      if Assigned(_Connection) then _Connection.RoomCreated := -1;
      fSocket.Send(Room.Invites,
        [DP_ROOM_DESTROYED, IntToStr(RoomNumber)],nil);
      fSocket.Send(fConnections.AdminConnections,
        [DP_ROOM_DESTROYED, IntToStr(RoomNumber)],nil);
      if Room.Creator = Connection.Handle then Connection.RoomCreated := -1;
      FRooms.Delete(RIndex);
    end;
end;
//______________________________________________________________________________
function TRooms.IndexOf(const RoomNumber: Integer): Integer;
var
  L, H, I, C: Integer;
begin
  { Binary search of the FRooms list. Finds the index of the RoomNumber
    param. -1 if not found. This only works because RoomNumbers are added to
    FRooms in a serially !!!}
  Result := -1;
  L := 0;
  H := FRooms.Count - 1;
  while L <= H do
    begin
      I := (L + H) shr 1;
      C := TRoom(FRooms[I]).RoomNumber - RoomNumber;
      if C < 0 then
        L := I + 1
      else
        begin
          H := I - 1;
          if C = 0 then
            begin
              Result := I;
              Break;
            end;
        end;
    end;
end;
//______________________________________________________________________________
constructor TRooms.Create;
var
  Room: TRoom;
begin
  CSRoom.FCreatedCount := -2;
  FRooms := TObjectList.Create;
  { Create System Rooms }
  Room := TRoom.Create(nil, 'Admin', High(Integer),0,2,true);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Staff', High(Integer),0,1,true);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Help', High(Integer),0,0,true);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Lobby', High(Integer),0,0,true);
  FRooms.Add(Room);
  {Room := TRoom.Create(nil, 'BAR', High(Integer),0,0,false);
  FRooms.Add(Room);}
  Room := TRoom.Create(nil, 'Chess - General', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Chess - Theory', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Chess - Computer', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'World - Current Events', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Tournament Room', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Tournament Room - 1', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Tournament Room - 2', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Tournament Room - 3', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'IHT Tournament Room', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Chess Fight Club', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Park Bench', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'Events', High(Integer),0,0,false);
  FRooms.Add(Room);
  Room := TRoom.Create(nil, 'After School', High(Integer),0,0,false);
  FRooms.Add(Room);
end;
//______________________________________________________________________________
destructor TRooms.Destroy;
begin
  FRooms.Clear;
  FRooms.Free;
  inherited;
end;
//______________________________________________________________________________
procedure TRooms.CMD_CreateRoom(var Connection: TConnection; var CMD: TStrings);
const
  ROOM_DESC = 1;
var
  Room: TRoom;
  s: string;
  i: integer;
  conn: TConnection;
begin
  { Verify members only }
  if not Connection.Registered then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_REGISTERED_ONLY],nil);
      Exit;
    end;
  { Verify invisible }
  if Connection.Invisible then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invisible user cannot create room'],nil);
      Exit;
    end;
  { Verify Connection has not already created a Room. }
  if Connection.RoomCreated > -1 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ROOM_CREATED],nil);
      Exit;
    end;
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Create a Room object. Add it to the Rooms list. }
  s := Copy(CMD[ROOM_DESC], 1, 15);

  Room := TRoom.Create(Connection, s, PRIVATE_ROOM_LIMIT, 0, ord(Connection.AdminLevel),false);
  FRooms.Add(Room);

  { Adjust Room realted Connection variables  }
  Connection.RoomCount := Connection.RoomCount + 1;
  Connection.RoomCreated := Room.RoomNumber;

  { Send DP_ROOM_DEF out to creator and admin }
  s := Room.Creator;
  for i:=0 to fConnections.Connections.Count-1 do begin
    conn := TConnection(fConnections.Connections[i]);
    if (conn = Connection)
      or (conn.AdminLevel >= alNormal) and (conn.AdminLevel >= Connection.AdminLevel)
    then
      fSocket.Send(conn,
        [DP_ROOM_DEF, IntToStr(Room.RoomNumber), Room.Description, s,
        IntToStr(Room.Limit), IntToStr(Room.Connections.Count)],Connection);
  end;
  {if Connection.AdminLevel in [alNone, alHelper] then
    fSocket.Send(Connection, [DP_ROOM_DEF, IntToStr(Room.RoomNumber),
      Room.Description, s, IntToStr(Room.Limit),
      IntToStr(Room.Connections.Count),
      BoolTo_(Room.Eternal,'1','0')],nil);

  { Send DP_ROOM_I_ENTER to Connection }
  fSocket.Send(Connection, [DP_ROOM_I_ENTER, IntToStr(Room.RoomNumber),
    Room.Description],nil);
  { Send DP_ENTER to Connection }
  fSocket.Send(Connection, [DP_ROOM_ENTER, IntToStr(Room.RoomNumber),
    IntToStr(Connection.LoginID), Connection.Handle, Connection.Title, Connection.RatingString],nil);
end;
//______________________________________________________________________________
procedure TRooms.CMD_Enter(var Connection: TConnection; var CMD: TStrings);
const
  ROOM_NUM = 1;
var
  RoomNumber: Integer;
begin
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Verify the RoomNumber value }
  try
    RoomNumber := StrToInt(CMD[ROOM_NUM]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
    Exit;
  end;

  if (RoomNumber > 2) and (Connection.MembershipType = mmbNone) then begin
    Connection.SendNoMembershipMsg(DP_MSG_NO_ROOMS);
    exit;
  end;
  

  if (CompareVersion(Connection.Version,'7.9z')=-1) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Your version of program is too old to enter this room.'],nil);
    Exit;
  end;

  {if (RoomNumber = ADULT_ROOM_NUMBER) and (Connection.AdminLevel<alNormal) and (Connection.Adult=adtChild) then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'You are less then 18 years and cannot enter adult room.'],nil);
    Exit;
  end;}
  { Finish with the Enter routine }
  fSocket.Buffer := True;
  try
    EnterRoom(Connection, RoomNumber);
  finally
    fSocket.Buffer := False;
    fSocket.Send(Connection, [''],nil);
  end;
end;
//______________________________________________________________________________
procedure TRooms.CMD_Exit(var Connection: TConnection; var CMD: TStrings);
const
  ROOM_NUM = 1;
var
  RoomNumber: Integer;
begin
  { Verify param count }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Verify the RoomNumber value }
  try
    RoomNumber := StrToInt(CMD[ROOM_NUM]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_TYPE],nil);
    Exit;
  end;

  { Finish with the Exit routine }
  fSocket.Buffer := True;
  try
    ExitRoom(Connection, RoomNumber);
  finally
    fSocket.Buffer := False;
    fSocket.Send(Connection, [''],nil);
  end;
end;
//______________________________________________________________________________
procedure TRooms.CMD_Invite(var Connection: TConnection; var CMD: TStrings);
const
  INVITEE = 1;
var
  _Connection: TConnection;
  Room: TRoom;
  Index: Integer;
  s: string;
begin
  { Param check }
  if CMD.Count < 2 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Verify the Connection has actually created a Room }
  if Connection.RoomCreated = -1 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_NO_ROOM_CREATED],nil);
      Exit;
    end;

  { Verify the RoomNumber exists }
  Index := IndexOf(Connection.RoomCreated);
  if Index < 0 then
    begin
      s := Format(DP_MSG_NON_EXISTANT_ROOM, [IntToStr(Connection.RoomCreated)]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end
  else
    Room := TRoom(FRooms[Index]);

  { Verify Invitee }
  _Connection := fConnections.GetConnection(CMD[INVITEE]);
  if (_Connection = nil) or (_Connection.Socket = nil) then
    begin
      s := Format(DP_MSG_LOGIN_NOT_LOGGEDIN, [CMD[INVITEE]]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Check to see if the _Connection isn't already in the room. }
  if Room.IndexOf(_Connection) > -1 then
    begin
      s := Format(DP_MSG_ALREADY_IN_ROOM, [_Connection.Handle,
        IntToStr(Room.RoomNumber)]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, s],nil);
      Exit;
    end;

  { Verify the Invitation limit has not been exceeded. }
  if Room.Invites.Count >= Room.Limit then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
        DP_MSG_INVITE_LIMIT_MET],nil);
      Exit;
    end;

  { Censor check }
  if _Connection.Censors[Connection] then
    begin
      s := Format(DP_MSG_CENSORED, [_Connection.Handle]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  if Connection.Censors[_Connection] then
    begin
      s := Format(DP_MSG_CENSORING, [_Connection.Handle]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Add the _Connection to the Invites list and the invitation. }
  if Room.Invites.IndexOf(_Connection) = -1 then Room.Invites.Add(_Connection);
  fSocket.Send(_Connection, [DP_ROOM_DEF, IntToStr(Room.RoomNumber),
    Room.Description, Connection.Handle, IntToStr(Room.Limit),
    IntToStr(Room.Connections.Count),
    BoolTo_(Room.Eternal,'1','0')],Connection);

  { Send response to inviter }
  s := Format(DP_MSG_INVITED_CONNECTION, [CMD[INVITEE]]);
  fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_0, s],nil);
end;
//______________________________________________________________________________
procedure TRooms.CMD_Tell(var Connection: TConnection; var CMD: TStrings);
const
  COLOR_NUM = 1;
  ROOM_NUM = 2;
  TELL_MSG = 3;
var
  _Connection: TConnection;
  Room: TRoom;
  Index: Integer;
  s: string;
begin
  { Verify login not muted }
  if Connection.Muted = True then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_MUTE],nil);
      Exit;
    end;

  if CMD.Count=3 then
    CMD.Insert(1,'-1');

  { Parameter check. }
  if CMD.Count < 4 then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2,
        DP_MSG_INCORRECT_PARAM_COUNT],nil);
      Exit;
    end;

  { Verify the RoomNumber exists. }
  Index := StrToInt(CMD[ROOM_NUM]);
  Index := IndexOf(Index);
  if Index < 0 then
    begin
      s := Format(DP_MSG_NON_EXISTANT_ROOM, [CMD[ROOM_NUM]]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end
  else
    Room := TRoom(FRooms[Index]);

  { Verify the Connection is actually in the room. }
  if Room.IndexOf(Connection) = -1 then
    begin
      s := Format(DP_MSG_NOT_IN_ROOM, [CMD[ROOM_NUM]]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Censor filter }
  for Index := Room.Connections.Count -1 downto 0 do
    begin
      _Connection := TConnection(Room.Connections[Index]);
      _Connection.Send := ((Connection.MembershipType > mmbNone) or (_Connection.AdminLevel > alNone))
        and not _Connection.Censors[Connection];
    end;

  { Passed all the checks, say what you have to say. }
  fSocket.Send(Room.Connections, [DP_TELL_ROOM, CMD[ROOM_NUM],
    Connection.Handle, Connection.Title, CMD[TELL_MSG], CMD[COLOR_NUM]],Connection);

  fDB.AddChatLog(Date+Time,Connection.Handle,'R','S',Room.Description,CMD[TELL_MSG]);

  { Save last room tell was used in. }
  Connection.LastCmd := CMD_STR_TELL;
  Connection.CmdParam := CMD[ROOM_NUM];
end;
//______________________________________________________________________________
procedure TRooms.EnterRoom(var Connection: TConnection;
  const RoomNumber: Integer);
var
  _Connection: TConnection;
  Room: TRoom;
  Index: Integer;
  s: string;
begin
  { Verify room limits }
  if Connection.RoomCount >= Connection.RoomLimit then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_ROOM_LIMIT_MET],nil);
      Exit;
    end;

  { Verify roomnumber }
  Index := IndexOf(RoomNumber);
  if Index < 0 then
    begin
      s := Format(DP_MSG_NON_EXISTANT_ROOM, [IntToStr(RoomNumber)]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Get the Room object }
  Room := TRoom(FRooms[Index]);

  { Verify the Connection was invited. }
  if Assigned(Room.Invites) and (Room.Invites.IndexOf(Connection) = -1)
  and (Connection.AdminLevel in [alNone, alHelper]) then
    begin
      s := Format(DP_MSG_NOT_INVITED, [IntToStr(RoomNumber)]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Verify the (pulic) Room is not full. }
  if (Room.Creator = '') and (Room.Connections.Count >= Room.Limit)
  and (Connection.AdminLevel in [alNone, alHelper]) then
    begin
      s := Format(DP_MSG_ROOM_FULL, [IntToStr(RoomNumber), Room.Description]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  { Verify a non restricted room. Currently only room zero. }
  if (RoomNumber = -1) and (Connection.AdminLevel in [alNone, alHelper]) then
    begin
      s := Format(DP_MSG_RESTRICTED_ROOM, [IntToStr(RoomNumber)]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, s],nil);
      Exit;
    end;

  if (RoomNumber = 0) and (Connection.AdminLevel in [alNone]) then
    begin
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Room 0 is restricted for helper and admins only'],nil);
      Exit;
    end;

  { Verify that the Connection is not already in the Room. }
  Index := Room.IndexOf(Connection);
  if Index > -1 then
    begin
      s := Format(DP_MSG_ALREADY_IN_ROOM, [Connection.Handle,
        IntToStr(RoomNumber)]);
      fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_1, s],nil);
      Exit;
    end;

  { Add the Connection to the Rooms list of Connections }
  Index := Room.InsertIndexOf(Connection);
  Room.Connections.Insert(Index, Connection);

  { Set Connection Room variables }
  Connection.RoomCount := Connection.RoomCount + 1;

  { Send DP_ENTER to Connection }
  fSocket.Send(Connection, [DP_ROOM_I_ENTER, IntToStr(Room.RoomNumber),
    Room.Description],nil);

  { Send list of Logins in Room to Connection }
  fSocket.Send(Connection, [DP_ROOM_SET_BEGIN, IntToStr(RoomNumber)],nil);
  for Index := 0 to Room.Connections.Count -1 do
    begin
      if Room.Connections[Index] = nil then continue;
      _Connection := TConnection(Room.Connections[Index]);
      if not _Connection.Invisible then
        fSocket.Send(Connection, [DP_ROOM_ENTER, IntToStr(RoomNumber),
          IntToStr(_Connection.LoginID), _Connection.Handle, _Connection.Title, _Connection.RatingString],_Connection);
    end;
  fSocket.Send(Connection, [DP_ROOM_SET_END, IntToStr(RoomNumber)],nil);
  { Notify Connections of the Room about this Connection. }
  for Index := 0 to Room.Connections.Count -1 do
    begin
      if Room.Connections[Index] = nil then continue;
      _Connection := TConnection(Room.Connections[Index]);
      with _Connection do Send := not Connection.Invisible;
    end;
  { But don't notify the Connection itself. }
  Connection.Send := False;
  fSocket.Send(Room.Connections, [DP_ROOM_ENTER, IntToStr(RoomNumber),
    IntToStr(Connection.LoginID), Connection.Handle, Connection.Title, Connection.RatingString],Connection);
end;
//______________________________________________________________________________
procedure TRooms.ReEnterRoom(var Connection: TConnection);
var
  _Connection: TConnection;
  Room: TRoom;
  RIndex, Index: Integer;
begin
  { Disconnections do not release Connections from Rooms. Reconnections are
    still in the Room, but the client needs to be told when they re-enter. }

  for RIndex := 0 to FRooms.Count - 1 do
    begin
      Room := TRoom(FRooms[RIndex]);
      { Is the connection in the Room? }
      Index := Room.IndexOf(Connection);
      if Index = -1 then Continue;

      { Send DP_ENTER to Connection }
      fSocket.Send(Connection, [DP_ROOM_I_ENTER, IntToStr(Room.RoomNumber),
        Room.Description],nil);

      { Send list of Logins in Room to Connection }
      with Room do
        begin
          fSocket.Send(Connection, [DP_ROOM_SET_BEGIN, IntToStr(RoomNumber)],nil);
          for Index := 0 to Connections.Count -1 do
            begin
              _Connection := TConnection(Connections[Index]);
              if not _Connection.Invisible then
                fSocket.Send(Connection, [DP_ROOM_ENTER,
                  IntToStr(RoomNumber), IntToStr(_Connection.LoginID),
                  _Connection.Handle, _Connection.Title, _Connection.RatingString],_Connection);
            end;
          fSocket.Send(Connection, [DP_ROOM_SET_END, IntToStr(RoomNumber)],nil);
        end;
    end;
end;
//______________________________________________________________________________
procedure TRooms.Release(var Connection: TConnection);
var
  _Connection: TConnection;
  Room: TRoom;
  Index, RIndex: Integer;
begin
  { Find all the Rooms this Connection might be a member of and remove the
    Connection from the FConnections and Invites List. This is very similar to
    the ExitRoom procedure, except that it also removes a connection from
     the Invites list. }

  { ??? Think about indexing the rooms a Connection is in. }
  for RIndex := FRooms.Count -1 downto 0 do
    begin
      Room := TRoom(FRooms[RIndex]);

      if Assigned(Room.Invites) then Room.Invites.Remove(Connection);

      Index := Room.IndexOf(Connection);
      if Index > -1 then
        begin
          Room.Connections.Delete(Index);

          { Notify others of this Connections departure. }
          fSocket.Send(Room.Connections, [DP_ROOM_EXIT,
            IntToStr(Room.RoomNumber), IntToStr(Connection.LoginID),
            Connection.Handle, Connection.Title],Connection);

          { if Room is empty then Destroy, Send DP_ROOM_DESTROY, release the
            creator of responsibility }
          if (Room.Connections.Count = 0) and (Room.Creator <> '') then
            begin
              _Connection := fConnections.GetConnection(Room.Creator);
              if Assigned(_Connection) then _Connection.RoomCreated := -1;
              fSocket.Send(Room.Invites, [DP_ROOM_DESTROYED,
                IntToStr(Room.RoomNumber)],nil);
              fSocket.Send(fConnections.AdminConnections,
                [DP_ROOM_DESTROYED, IntToStr(Room.RoomNumber)],nil);
              FRooms.Delete(RIndex);
            end;
        end;
    end;
end;
//______________________________________________________________________________
procedure TRooms.SendRoomDefs(const Connection: TConnection);
var
  Room: TRoom;
  Index: Integer;
begin
  { Sent only when logging in. }

  fSocket.Send(Connection, [DP_ROOM_DEF_BEGIN],nil);
  { For each room in FRooms send DP_ROOM_DEF to connection }
  for Index := 1 to FRooms.Count -1 do
    begin
      Room := TRoom(FRooms[Index]);
      if (Room.EventID <> 0) and (fEvents.FindEvent(Room.EventID) = nil) then continue;
      with Room do
        begin
          { The creator is comming back after logging off and there is still
            people in his/her room so add him to his own invites list. }
          if Creator = Connection.Handle then
            begin
              Connection.RoomCreated := RoomNumber;
              if Invites.IndexOf(Connection) = -1 then Invites.Add(Connection);
            end;
          if (Creator = Connection.Handle)
            or (Creator = '') and (ord(Connection.AdminLevel) >= Room.AdminLevel)
            or (Creator <> '') and (Connection.AdminLevel >= alNormal) and (ord(Connection.AdminLevel) >= Room.AdminLevel)
          then
            { Send the RoomDef }
            fSocket.Send(Connection, [DP_ROOM_DEF, IntToStr(RoomNumber),
              Description, Creator, IntToStr(Limit),
              IntToStr(Connections.Count),
              BoolTo_(Room.Eternal,'1','0')],nil);
        end
    end;
  {}
  fSocket.Send(Connection, [DP_ROOM_DEF_END],nil);
end;
//______________________________________________________________________________
procedure TRooms.SendRoomSet(const Connection: TConnection);
var
  _Connection: TConnection;
  Room: TRoom;
  Index, RIndex: Integer;
begin
  { Sends DP_ENTER of each player in each room the Connection is in.
    Designed to be called from fConnections.SetOption only.}
  if Connection.RoomCount < 1 then Exit;

  for RIndex := 0 to FRooms.Count -1 do
    begin
      Room := TRoom(FRooms[RIndex]);
      Index := Room.IndexOf(Connection);
      if Index > -1 then
        begin
          fSocket.Send(Connection, [DP_ROOM_SET_BEGIN,
            IntToStr(Room.RoomNumber)],nil);
          for Index := 0 to Room.Connections.Count -1 do
            begin
              _Connection := TConnection(Room.Connections[Index]);
              if not _Connection.Invisible then
                fSocket.Send(Connection, [DP_ROOM_ENTER,
                  IntToStr(Room.RoomNumber), IntToStr(_Connection.LoginID),
                  _Connection.Handle, _Connection.Title, _Connection.RatingString],_Connection);
            end;
          fSocket.Send(Connection, [DP_ROOM_SET_END,
            IntToStr(Room.RoomNumber)],nil);
        end;
    end;
end;
//______________________________________________________________________________
procedure TRooms.CMD_DeleteRoom(var Connection: TConnection; var CMD: TStrings);
var
  RoomNumber, Index, i: integer;
  Room: TRoom;
begin
  if CMD.Count < 2 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, DP_MSG_INCORRECT_PARAM_COUNT]);
    exit;
  end;

  try
    RoomNumber := StrToInt(CMD[1]);
  except
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'Invalid number']);
    exit;
  end;

  Index := IndexOf(RoomNumber);
  if Index = -1 then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, Format(DP_MSG_NON_EXISTANT_ROOM, [IntToStr(RoomNumber)])]);
    exit;
  end;

  Room := TRoom(FRooms[Index]);

  if Room.Eternal then begin
    fSocket.Send(Connection, [DP_SERVER_MSG, DP_ERR_2, 'The room '+Room.Description+' is eternal and cannot be deleted']);
    exit;
  end;


  fSocket.Send(Room.Connections,[DP_SERVER_MSG, DP_ERR_1,
    'Room '+Room.Description+' is destroyed by administrator '+Connection.Handle],nil);
  for i := 0 to Room.Connections.Count-1 do
    fSocket.Send(TConnection(Room.Connections[i]),[DP_ROOM_I_EXIT, IntToStr(RoomNumber)]);

  fSocket.Send(fConnections.Connections, [DP_ROOM_DESTROYED,
     IntToStr(Room.RoomNumber)],nil);

  FRooms.Delete(Index);
end;
//______________________________________________________________________________
end.

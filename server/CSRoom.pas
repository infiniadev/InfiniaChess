{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSRoom;

interface

uses
  contnrs, CSConnection;

type

  TRoom = class(TObject)
    private
    { Private declarations }
    FConnections: TObjectList;
    FCreator: string;
    FDescription: string;
    FInvites: TObjectList;
    FLimit: Integer;
    FRoomNumber: Integer;
    FEventID: integer;
    FAdminLevel: integer;
    FEternal: Boolean;

  public
    { Public declarations }
    constructor Create(const Connection: TConnection; const Description: string;
      const Limit: Integer;
      const EventID: integer;
      const AdminLevel: integer;
      const Eternal: Boolean);
    destructor Destroy; override;

    function IndexOf(const Connection: TConnection): Integer;
    function InsertIndexOf(const Connection: TConnection): Integer;

    property Connections: TObjectList read FConnections;
    property Creator: string read FCreator;
    property Description: string read FDescription;
    property Invites: TObjectList read FInvites;
    property Limit: Integer read FLimit;
    property RoomNumber: Integer read FRoomNumber;
    property EventID: integer read FEventID write FEventID;
    property AdminLevel: integer read FAdminLevel write FAdminLevel;
    property Eternal: Boolean read FEternal write FEternal;
  end;

var
  FCreatedCount: Integer;

implementation

uses CSConst;

{ TRoom }
//______________________________________________________________________________
constructor TRoom.Create(const Connection: TConnection;
  const Description: string; const Limit: Integer;
  const EventID: integer;
  const AdminLevel: integer;
  const Eternal: Boolean);
const
  MAX_DESC = 30;
var
  Index: Integer;
begin
  Inc(FCreatedCount);

  { Create the list for Connections. }
  FConnections := TObjectList.Create;
  FConnections.OwnsObjects := False;

  { Create the Invites list but only if a private room. }
  if Assigned(Connection) then
    begin
      FInvites := TObjectList.Create;
      FInvites.OwnsObjects := False;
      { Remeber who created the room. }
      FCreator := Connection.Handle;
    end
  else
    { Remeber who created the room. }
    FCreator := '';

  { Assign the Description.  }
  FDescription := Description;
  if Length(FDescription) > MAX_DESC then SetLength(FDescription, MAX_DESC);
  {  }
  FLimit := Limit;
  FRoomNumber := FCreatedCount;
  FEventID := EventID;
  FAdminLevel := AdminLevel;
  FEternal := Eternal;

  { Assign the Creator(Connection) to the list of Connections. A nill
    Connection means the system created the room at start up. }
  if Assigned(Connection) then
    begin
      Index := InsertIndexOf(Connection);
      FConnections.Insert(Index, Connection);
      FInvites.Add(Connection);
    end;
end;
//______________________________________________________________________________
destructor TRoom.Destroy;
begin
  FConnections.Clear;
  FConnections.Free;
  if Assigned(FInvites) then
    begin
      FInvites.Clear;
      FInvites.Free;
    end;
  inherited;
end;
//______________________________________________________________________________
function TRoom.IndexOf(const Connection: TConnection): Integer;
var
  L, H, I, C: Integer;
begin
  { Binary search of the FConnections list. Finds the index of the
    Connection param. -1 if not found. }
  Result := -1;
  L := 0;
  H := FConnections.Count - 1;
  while L <= H do
    begin
      I := (L + H) shr 1;
      C := Integer(FConnections[I]) - Integer(Connection);
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
function TRoom.InsertIndexOf(const Connection: TConnection): Integer;
var
  L, H, I, C: Integer;
begin
  { Binary search of the FConnections list. Finds the correct insert index
    for the Connection param. }
  L := 0;
  H := FConnections.Count - 1;
  while L <= H do
    begin
      I := (L + H) shr 1;
      C := Integer(FConnections[I]) - Integer(Connection);
      if C < 0 then
        L := I + 1
      else
        begin
          H := I - 1;
          if C = 0 then
            begin
              L := I;
              Break;
            end;
        end;
    end;
  Result := L;
end;
//______________________________________________________________________________
initialization
begin
  FCreatedCount := -2;
end;
//______________________________________________________________________________
end.

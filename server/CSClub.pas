unit CSClub;

interface

uses contnrs, CSConnection, classes;

type
  TClubType = (cltClub, cltSchool);
  //-------------------------------------------------------------------------
  TClub = class
    id: integer;
    name: string;
    info: string;
    requests: Boolean;
    sponsor: string;
    clubtype: TClubType;
    members: integer;
    PhotoANSI: string;
  end;
  //-------------------------------------------------------------------------
  TClubs = class(TObjectList)
  private
    function GetClub(Index: integer): TClub;
    procedure CMD_ClubPhoto(Connection: TConnection; CMD: TStrings);
  public
    property Clubs[Index: integer]: TClub read GetClub; default;
    procedure AddClub(id: integer; name: string);
    function NameById(id: integer): string;
    procedure SetPhotoANSI(ClubId: integer; PhotoANSI: string);
  end;
  //-------------------------------------------------------------------------

var
  fClubs: TClubs;

implementation

uses CSSocket, CSConst;

{ TClubs }
//===========================================================================
procedure TClubs.AddClub(id: integer; name: string);
var
  cl: TClub;
begin
  cl:=TClub.Create;
  cl.Id:=id;
  cl.Name:=name;
  Add(cl);
end;
//===========================================================================
procedure TClubs.CMD_ClubPhoto(Connection: TConnection; CMD: TStrings);
begin
  //
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
procedure TClubs.SetPhotoANSI(ClubId: integer; PhotoANSI: string);
begin

end;

end.

{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLMembershipType;

interface

uses SysUtils, contnrs, classes;

type
  TCLMembershipType = class
    id: integer;
    name: string;
  end;

  TCLMembershipTypes = class(TObjectList)
  private
    function GetMembershipType(Index: integer): TCLMembershipType;
  public
    procedure CMD_MembershipTypeBegin(CMD: TStrings);
    procedure CMD_MembershipType(CMD: TStrings);
    function GetName(p_ID: integer): string;
    property MembershipType[Index: integer]: TCLMembershipType read GetMembershipType; default;
  end;

var
  fCLMembershipTypes: TCLMembershipTypes;

implementation
//======================================================================================
{ TCLMembershipTypes }

procedure TCLMembershipTypes.CMD_MembershipType(CMD: TStrings);
var
  mt: TCLMembershipType;
begin
  if CMD.Count < 3 then exit;
  mt := TCLMembershipType.Create;
  mt.id := StrToInt(CMD[1]);
  mt.name := CMD[2];
  Add(mt);
end;
//======================================================================================
procedure TCLMembershipTypes.CMD_MembershipTypeBegin(CMD: TStrings);
begin
  Clear;
end;
//======================================================================================
function TCLMembershipTypes.GetMembershipType(Index: integer): TCLMembershipType;
begin
  result := TCLMembershipType(Items[Index]);
end;
//======================================================================================
function TCLMembershipTypes.GetName(p_ID: integer): string;
var
  i: integer;
begin
  result := '';
  
  for i := 0 to Count - 1 do
    if Self[i].id = p_ID then begin
      result := Self[i].name;
      exit;
    end;
end;
//======================================================================================
end.

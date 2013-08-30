unit CSActions;

interface

uses SysUtils, contnrs, CSConnection;

type
    TAction = class
      id: integer;
      name: string;
      abbreviation: string;
      comment: string;
      AdminLevel: integer;
      MembershipTypes: string;
      Roles: string;
      function HaveRight(p_AdminLevel: TAdminLevel; p_MembershipType: TMembershipType; p_Roles: string): Boolean;
    end;

    TActions = class(TObjectList)
    private
      function GetAction(Index: integer): TAction;
      function ActionByAbbr(p_Abbreviation: string): TAction;
    public
      function HaveRight(Connection: TConnection; p_Abbreviation: string): Boolean;
      property Action[Index: integer]: TAction read GetAction; default;
    end;

var
  fActions: TActions;

implementation

uses CSLib;

{ TActions }
//===============================================================================
function TActions.ActionByAbbr(p_Abbreviation: string): TAction;
var
  i: integer;
begin
  p_Abbreviation := lowercase(p_Abbreviation);
  for i := 0 to Count - 1 do begin
    result := Self[i];
    if lowercase(result.abbreviation) = p_Abbreviation then
      exit;
  end;
  result := nil;
end;
//===============================================================================
function TActions.GetAction(Index: integer): TAction;
begin
  result := TAction(Items[Index]);
end;
//===============================================================================
function TActions.HaveRight(Connection: TConnection; p_Abbreviation: string): Boolean;
var
  action: TAction;
begin
  action := ActionByAbbr(p_Abbreviation);
  if action = nil then result := false
  else result := action.HaveRight(Connection.AdminLevel, Connection.MembershipType, '');
end;
//===============================================================================
{ TAction }

function TAction.HaveRight(p_AdminLevel: TAdminLevel; p_MembershipType: TMembershipType; p_Roles: string): Boolean;
begin
  result := (ord(p_AdminLevel) >= Self.AdminLevel) and
    ((Self.MembershipTypes = '') or InCommaString(Self.MembershipTypes, ord(p_MembershipType)));
end;
//===============================================================================
end.

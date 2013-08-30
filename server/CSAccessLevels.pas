unit CSAccessLevels;

interface

uses contnrs;

type
  TAccessLevel = class
    id: integer;
    name: string;
    description: string;
  end;

  TAccessType = class
    id: integer;
    name: string;
    description: string;
  end;

  TAccessLink = class
    level_id: integer;
    type_id: integer;
    checked: boolean;
    value: integer;
  end;

  TAccessLevels = class
  private
    AccessLevels: TObjectList;
    AccessTypes: TObjectList;
    AccessLinks: TObjectList;
    function GetLevel(Index: integer): TAccessLevel;
    function GetLevelsCount: integer;
    function GetLink(Index: integer): TAccessLink;
    function GetLinksCount: integer;
    function GetType(Index: integer): TAccessType;
    function GetTypesCount: integer;
  public
    constructor Create;
    destructor Destroy;
    procedure Clear;
    procedure AddLevel(p_Id: integer; p_Name,p_Description: string);
    procedure AddType(p_Id: integer; p_Name,p_Description: string);
    procedure AddLink(p_LevelId, p_TypeId: integer; p_Checked: Boolean; p_Value: integer);
    property LevelsCount: integer read GetLevelsCount;
    property TypesCount: integer read GetTypesCount;
    property LinksCount: integer read GetLinksCount;
    property Level[Index: integer]: TAccessLevel read GetLevel;
    property Type_[Index: integer]: TAccessType read GetType;
    property Link[Index: integer]: TAccessLink read GetLink;
  end;

var
  fAccessLevels: TAccessLevels;

implementation

{ TAccessLevels }
//==============================================================================
procedure TAccessLevels.AddLevel(p_Id: integer; p_Name, p_Description: string);
var
  level: TAccessLevel;
begin
  level := TAccessLevel.Create;
  level.id := p_Id;
  level.name := p_Name;
  level.description := p_Description;
  AccessLevels.Add(level);
end;
//==============================================================================
procedure TAccessLevels.AddLink(p_LevelId, p_TypeId: integer; p_Checked: Boolean; p_Value: integer);
var
  lnk: TAccessLink;
begin
  lnk := TAccessLink.Create;
  lnk.level_id := p_LevelId;
  lnk.type_id := p_TypeId;
  lnk.checked := p_Checked;
  lnk.value := p_Value;
  AccessLinks.Add(lnk);
end;
//==============================================================================
procedure TAccessLevels.AddType(p_Id: integer; p_Name, p_Description: string);
var
  t: TAccessType;
begin
  t := TAccessType.Create;
  t.id := p_Id;
  t.name := p_Name;
  t.description := p_Description;
  AccessTypes.Add(t);
end;
//==============================================================================
procedure TAccessLevels.Clear;
begin
  AccessLevels.Clear;
  AccessTypes.Clear;
  AccessLinks.Clear;
end;
//==============================================================================
constructor TAccessLevels.Create;
begin
  AccessLevels := TObjectList.Create;
  AccessTypes := TObjectList.Create;
  AccessLinks := TObjectList.Create;
end;
//==============================================================================
destructor TAccessLevels.Destroy;
begin
  AccessLevels.Free;
  AccessTypes.Free;
  AccessLinks.Free;
end;
//==============================================================================
function TAccessLevels.GetLevel(Index: integer): TAccessLevel;
begin
  result := TAccessLevel(AccessLevels[Index]);
end;
//==============================================================================
function TAccessLevels.GetLevelsCount: integer;
begin
  result := AccessLevels.Count;
end;
//==============================================================================
function TAccessLevels.GetLink(Index: integer): TAccessLink;
begin
  result := TAccessLink(AccessLinks[Index]);
end;
//==============================================================================
function TAccessLevels.GetLinksCount: integer;
begin
  result := AccessLinks.Count;
end;
//==============================================================================
function TAccessLevels.GetType(Index: integer): TAccessType;
begin
  result := TAccessType(AccessTypes[Index]);
end;
//==============================================================================
function TAccessLevels.GetTypesCount: integer;
begin
  result := AccessTypes.Count;
end;
//==============================================================================
end.

unit CLRectMap;

interface

uses Classes,SysUtils,Windows;

type
  //---------------------------------------------------------------
  TCLRectType = (rctNone,rctGame,rctPlayer);
  //---------------------------------------------------------------
  TCLRect = class
  private
    function GetCommand: string;
  public
    ID: integer;
    Type_: TCLRectType;
    Defined: Boolean;
    Tag: integer;
    sTag: string;
    Rect: TRect;
    property Command: string read GetCommand;
    constructor Create;
  end;
  //---------------------------------------------------------------
  TCLRectMap = class(TList)
  private
    function GetRect(Index: integer): TCLRect;
  public
    procedure AddRect(
      p_ID: integer;
      p_Rect: TRect;
      p_Type: TCLRectType;
      p_Tag: integer;
      p_Defined: Boolean;
      p_STag: string);

    procedure UpdateRect(
      p_ID: integer;
      p_Type: TCLRectType;
      p_Tag: integer;
      p_Defined: Boolean);

    function IndexOfRect(p_ID: integer; p_Type: TCLRectType): integer;
    function FindRect(p_ID: integer; p_Type: TCLRectType): TCLRect;
    function IndexByPoint(X,Y: integer; DefinedOnly: Boolean = true): integer;
    procedure ClearByType(Type_: TCLRectType);

    property Rects[Index: integer]: TCLRect read GetRect; default;
  end;
  //---------------------------------------------------------------
implementation

uses CLMain;
//=================================================================
{ TCLRect }
//=================================================================
constructor TCLRect.Create;
begin
  ID:=-1;
  Tag:=-1;
  Defined:=false;
  Rect:=Classes.Rect(0,0,0,0);
  Type_:=rctNone;
end;
//=================================================================
function TCLRect.GetCommand: string;
begin
  //
end;
//=================================================================
{ TCLRectMap }
//=================================================================
procedure TCLRectMap.AddRect(p_ID: integer; p_Rect: TRect;
  p_Type: TCLRectType; p_Tag: integer; p_Defined: Boolean; p_STag: string);
var
  clRect: TCLRect;
begin
  clRect:=TCLRect.Create;
  clRect.ID:=p_ID;
  clRect.Rect:=p_Rect;
  clRect.Type_:=p_Type;
  clRect.sTag := p_STag;
  clRect.Tag:=p_Tag;
  clRect.Defined:=p_Defined;
  Add(clRect);
end;
//=================================================================
procedure TCLRectMap.ClearByType(Type_: TCLRectType);
var
  i: integer;
begin
  for i:=Count-1 downto 0 do begin
    if Rects[i].Type_ = Type_ then
      Delete(i);
  end;
end;
//=================================================================
function TCLRectMap.FindRect(p_ID: integer; p_Type: TCLRectType): TCLRect;
var
  i: integer;
begin
  for i:=0 to Count-1 do begin
    result:=Rects[i];
    if (result.Type_=p_Type) and (result.ID=p_ID) then
      exit;
  end;
  result:=nil;
end;
//=================================================================
function TCLRectMap.GetRect(Index: integer): TCLRect;
begin
  result:=TCLRect(Items[Index]);
end;
//=================================================================
function TCLRectMap.IndexByPoint(X, Y: integer; DefinedOnly: Boolean = true): integer;
var
  i: integer;
begin
  for i:=0 to Count-1 do
    if (Rects[i].Defined or not DefinedOnly) and PtInRect(Rects[i].Rect,Point(X,Y)) then begin
      result:=i;
      exit;
    end;
  result:=-1;
end;
//=================================================================
function TCLRectMap.IndexOfRect(p_ID: integer;
  p_Type: TCLRectType): integer;
var
  i: integer;
begin
  for i:=0 to Count-1 do
    if (Rects[i].Type_=p_Type) and (Rects[i].ID=p_ID) then begin
      result:=i;
      exit;
    end;
  result:=-1;
end;
//=================================================================
procedure TCLRectMap.UpdateRect(p_ID: integer; p_Type: TCLRectType;
  p_Tag: integer; p_Defined: Boolean);
begin

end;
//=================================================================
end.

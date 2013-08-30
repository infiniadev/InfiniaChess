unit CLObjectList;

interface

uses contnrs, sysutils, Variants;

type
  TOLWrongTypeException = class(Exception);
  TOLInsertExistingException = class(Exception);

  TTOLSortKey = variant;
  TTOLCompareResult = (cmrLess, cmrEqual, cmrMore);

  TTypedObjectList = class(TObjectList)
  private
    procedure AddObjectToSortedList(p_Object: TObject);
    function CompareKeys(p_Key1, p_Key2: TTOLSortKey): TTOLCompareResult;
  protected
    FClassType: TClass;
    FSorted: Boolean;
    FUnique: Boolean;
    function GetObjectSortKey(p_Object: TObject): TTOLSortKey; virtual;
    function SortKeyByIndex(p_Index: integer): TTOLSortKey;
    function GetObjectByKey(Key: TTOLSortKey): TObject;
    function BinarySearch(p_Key: TTOLSortKey; var pp_Index: integer): Boolean;
  public
    constructor Create;
    procedure AddObject(p_Object: TObject);
    procedure DeleteByKey(p_Key: TTOLSortKey);
  end;

implementation

{ TTypedObjectList }
//==============================================================================
procedure TTypedObjectList.AddObject(p_Object: TObject);
begin
  if not (p_Object is FClassType) then
    raise {TOLWrongTypeException}Exception.Create(ClassName + '.AddObject: argument must be ' +
      FClassType.ClassName +', but it is ' + p_Object.ClassName);

  if FSorted then AddObjectToSortedList(p_Object)
  else Add(p_Object);
end;
//==============================================================================
procedure TTypedObjectList.AddObjectToSortedList(p_Object: TObject);
var
  index: integer;
  found: Boolean;
  key: TTOLSortKey;
begin
  key := GetObjectSortKey(p_Object);
  found := BinarySearch(key, index);
  if found and FUnique then
    raise {TOLInsertExistingException.}Exception.Create(ClassName + '.AddObjectToSortedList: ' +
      'adding existing object ' + FClassType.ClassName + ' with key = ' + VarToStr(key));

  Insert(index, p_Object);
end;
//==============================================================================
function TTypedObjectList.BinarySearch(p_Key: TTOLSortKey; var pp_Index: integer): Boolean;
// if result is true, exact match found; if false - only place for insert found
var
  lo, hi: integer;
  CompareResult: TTOLCompareResult;
begin
  lo := 0; hi := Count - 1;
  if hi < lo then begin
    pp_Index := 0;
    result := false;
    exit;
  end;

  // testing high bound
  CompareResult := CompareKeys(p_Key, SortKeyByIndex(hi));
  if CompareResult = cmrMore then begin
    pp_Index := hi + 1;
    result := false;
    exit;
  end else if CompareResult = cmrEqual then begin
    pp_Index := hi;
    result := true;
    exit;
  end;
  // testing low bound
  CompareResult := CompareKeys(p_Key, SortKeyByIndex(lo));
  if CompareResult <> cmrMore then begin
    pp_Index := lo;
    result := CompareResult = cmrEqual;
    exit;
  end;
  // binary search
  result := true;
  while hi - lo > 1 do begin
    pp_Index := (lo + hi) div 2;

    CompareResult := CompareKeys(p_Key, SortKeyByIndex(pp_Index));
    if CompareResult = cmrEqual then exit;

    if CompareResult = cmrLess then hi := pp_Index
    else lo := pp_Index;
  end;
  // item not found
  pp_Index := hi;
  result := false;
end;
//==============================================================================
function TTypedObjectList.CompareKeys(p_Key1, p_Key2: TTOLSortKey): TTOLCompareResult;
begin
  if p_Key1 < p_Key2 then result := cmrLess
  else if p_Key1 = p_Key2 then result := cmrEqual
  else result := cmrMore;
end;
//==============================================================================
constructor TTypedObjectList.Create;
begin
  inherited;
  FClassType := TObject;
  FSorted := true;
  FUnique := true;
end;
//==============================================================================
procedure TTypedObjectList.DeleteByKey(p_Key: TTOLSortKey);
var
  index: integer;
begin
  if BinarySearch(p_Key, index) then
    Delete(index);
end;
//==============================================================================
function TTypedObjectList.GetObjectByKey(Key: TTOLSortKey): TObject;
var
  index: integer;
begin
  if BinarySearch(Key, index) then
    result := Items[index] as FClassType
  else
    result := nil;
end;
//==============================================================================
function TTypedObjectList.GetObjectSortKey(p_Object: TObject): TTOLSortKey;
begin
  result := low(integer);
end;
//==============================================================================
function TTypedObjectList.SortKeyByIndex(p_Index: integer): TTOLSortKey;
begin
  result := GetObjectSortKey(Items[p_Index]);
end;
//==============================================================================
end.

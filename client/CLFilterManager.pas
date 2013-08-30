{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLFilterManager;

interface

uses
  contnrs;

type
  TCLFilterKey = (fkConsole, fkRoom, fkTell, fkGame, fkEvent);

  TCLFilter = class(TObject)
  private
    { Private declarations }
    FDirty: Boolean;
    FFilter: Integer;
    FKey1: TCLFilterKey;
    FKey2: Integer;
    FParentFilter: TCLFilter;
    function GetVisible: Boolean;

  public
    { Public declarations }
    property Dirty: Boolean read FDirty write FDirty;
    property Filter: Integer read FFilter write FFilter;
    property Key1: TCLFilterKey read FKey1 write FKey1;
    property Key2: Integer read FKey2 write FKey2;
    property Parentfilter: TCLFilter read FParentFilter write FParentFilter;
    property Visible: Boolean read GetVisible;
  end;

  TCLFilterManager = class(TObject)
  private
    { Private declarations }
    FFilter: Integer;
    FFilters: TObjectList;

  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    function CreateFilter(const Key1: TCLFilterKey; const Key2: Integer;
      var Position: Integer): TCLFilter;
    function CreateChildFilter(const Key1: TCLFilterKey; const Key2: Integer;
      const ParentKey1: TCLFilterKey; const ParentKey2: Integer): TCLFilter;
    function GetFilter(Key1: TCLFilterKey; Key2: Integer): TCLFilter;
    function GetFilterByNum(Num: integer): TCLFilter;
    function HasChildren(Filter: TCLFilter): Boolean;

    property Filters: TObjectList read FFilters;
  end;

implementation

{ TCLFilterManager }

uses CLMain;
//______________________________________________________________________________
constructor TCLFilterManager.Create;
begin
  inherited;
  FFilter := -1;
  FFilters := TObjectList.Create;
end;
//______________________________________________________________________________
destructor TCLFilterManager.Destroy;
begin
  FFilters.Free;
  inherited;
end;
//______________________________________________________________________________
function TCLFilterManager.CreateFilter(const Key1: TCLFilterKey;
  const Key2: Integer; var Position: Integer): TCLFilter;
var
  CLFilter: TCLFilter;
  n,Index: Integer;
begin
  Position := FFilters.Count;

  { Don't create duplicate filters. }
  Result := GetFilter(Key1, Key2);
  if Result <> nil then Exit;

  { Create the object. }
  CLFilter := TCLFilter.Create;
  Inc(FFilter);
  CLFilter.FDirty := False;
  CLFilter.FFilter := FFilter;
  CLFilter.FKey1 := Key1;
  CLFilter.FKey2 := Key2;
  CLFilter.Parentfilter := nil;

  { Determine the position to place the filter. }
  for Index := 0 to FFilters.Count -1 do
    if TCLFilter(FFilters[Index]).Key1 > CLFilter.Key1 then
      begin
        Position := Index;
        Break;
      end;

  // finding last visible filter
  {n:=FFilters.Count-1;
  while (n>=0) and not TCLFilter(FFilters[Index]).Visible do
    dec(n);

  if Index>n+1}

  { Add the filter to the FFilters list. }
  FFilters.Insert(Position, CLFilter);

  Result := CLFilter;
end;
//______________________________________________________________________________
function TCLFilterManager.GetFilter(Key1: TCLFilterKey;
  Key2: Integer): TCLFilter;
var
  Index: Integer;
begin
  { Find the filter. }
  Result := nil;
  for Index := 0 to FFilters.Count -1 do
    begin
      Result := TCLFilter(FFilters[Index]);
      if (Result.Key1 = Key1) and (Result.Key2 = Key2) then
        Break
      else
        Result := nil;
    end;
end;
//______________________________________________________________________________
{ TCLFilter }
function TCLFilter.GetVisible: Boolean;
begin
  result:=FParentFilter=nil;
end;
//______________________________________________________________________________
function TCLFilterManager.CreateChildFilter(const Key1: TCLFilterKey; const Key2: Integer;
  const ParentKey1: TCLFilterKey; const ParentKey2: Integer): TCLFilter;
var
  ParentKey: TCLFilter;
  dumb: integer;
begin
  result:=nil;
  ParentKey:=GetFilter(ParentKey1,ParentKey2);
  if ParentKey = nil then
    ParentKey := CreateFilter(ParentKey1,ParentKey2,dumb);

  result:=CreateFilter(Key1,Key2,dumb);
  if result<>nil then
    result.FParentFilter:=ParentKey;
end;
//______________________________________________________________________________
function TCLFilterManager.HasChildren(Filter: TCLFilter): Boolean;
var
  i: integer;
  flt: TCLFilter;
begin
  result:=true;
  for i:=0 to FFilters.Count-1 do begin
    flt:=TCLFilter(FFilters[i]);
    if flt.ParentFilter = Filter then exit;
  end;
  result:=false;
end;
//______________________________________________________________________________
function TCLFilterManager.GetFilterByNum(Num: integer): TCLFilter;
var
  i: integer;
begin
  for i:=0 to FFilters.Count-1 do begin
    result:=TCLFilter(FFilters[i]);
    if result.FFilter=Num then exit;
  end;
  result:=nil;
end;
//______________________________________________________________________________
end.

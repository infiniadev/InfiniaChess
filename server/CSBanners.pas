unit CSBanners;

interface

uses contnrs, classes, sysutils;

type
  TBanner = class
  public
    name: string;
    ext: string;
    image: string;
    www: string;
    priority: integer;
  end;

  TBanners = class(TObjectList)
  private
    function GetBanner(Index: integer): TBanner;
  public
    procedure ReadBanners;
    procedure ClearBanners;

    property Banner[Index: integer]: TBanner read GetBanner; default;
  end;

implementation

uses CSConst, CSLib;

{ TBanners }
//===========================================================================
procedure TBanners.ClearBanners;
begin
  Clear;
end;
//===========================================================================
function TBanners.GetBanner(Index: integer): TBanner;
begin
  result:=TBanner(Items[Index]);
end;
//===========================================================================
procedure TBanners.ReadBanners;
var
  slFile, sl: TStringList;
  ConfFile,s,name,www: string;
  i, priority: integer;
begin
  ClearBanners;

  ConfFile:=MAIN_DIR+BANNERS_DIR+'banners.conf';
  if not FileExists(ConfFile) then exit;

  slFile:=TStringList.Create;
  sl:=TStringList.Create;
  slFile.LoadFromFile(ConfFile);
  for i:=0 to slFile.Count-1 do begin
    s:=slFile[i];
    Str2StringList(s,sl,';');
    try
      //name:=
    except
    end;
  end;

  slFile.Free;
  sl.Free;
end;
//===========================================================================
end.

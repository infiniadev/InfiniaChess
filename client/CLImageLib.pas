{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLImageLib;

interface

uses
  Graphics,classes,SysUtils;

type
  TLoginImage = class
  public
    Login: string;
    Photo: TBitMap;
    constructor Create(Login: string);
    destructor Destroy;
  end;

  TLoginImages = class(TList)
  private
    function GetImage(Login: string): TLoginImage;
    function GetPhoto(Login: string): TBitMap;
    procedure SetPhoto(Login: string; const Value: TBitMap);
  public
    property Image[Login: string]: TLoginImage read GetImage; default;
    property Photo[Login: string]: TBitMap read GetPhoto write SetPhoto;
    function AddLoginImage(Login: string): TLoginImage;
    procedure DeleteImage(Login: string);
  end;

var
  fLoginImages: TLoginImages;

implementation

uses CLLib, CLMain;

{ TLoginImage }
//====================================================================
constructor TLoginImage.Create(Login: string);
begin
  inherited Create;
  Self.Login:=Login;
end;
//====================================================================
destructor TLoginImage.Destroy;
begin
  //Photo.Free;
end;
//====================================================================
{ TLoginImages }
//====================================================================
function TLoginImages.AddLoginImage(Login: string): TLoginImage;
begin
  result:=TLoginImage.Create(Login);
  Add(result);
end;
//====================================================================
procedure TLoginImages.DeleteImage(Login: string);
var
  i: integer;
  LImg: TLoginImage;
begin
  for i:=0 to Count-1 do begin
    LImg:=TLoginImage(Items[i]);
    if LImg.Login=Login then begin
      Self.Delete(i);
      exit;
    end;
  end;
end;
//====================================================================
function TLoginImages.GetImage(Login: string): TLoginImage;
var
  i: integer;
  LImg: TLoginImage;
begin
  result:=nil;
  for i:=0 to Count-1 do begin
    LImg:=TLoginImage(Items[i]);
    if lowercase(LImg.Login)=lowercase(Login) then begin
      result:=LImg;
      exit;
    end;
  end;
end;
//====================================================================
function TLoginImages.GetPhoto(Login: string): TBitMap;
var
  LImg: TLoginImage;
begin
  LImg:=Image[Login];
  if LImg = nil then result:=nil
  else result:=LImg.Photo;
end;
//====================================================================
procedure TLoginImages.SetPhoto(Login: string; const Value: TBitMap);
var
  LImg: TLoginImage;
begin
  LImg:=Image[Login];
  if LImg = nil then LImg:=AddLoginImage(Login);
  if LImg.Photo = nil then
    LImg.Photo:=TBitmap.Create;
  CopyBitMap(Value,LImg.Photo);
end;
//====================================================================
end.

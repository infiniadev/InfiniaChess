unit CLCombo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
{ TCLFontSizesCombo }
  TCLFontSizesCombo = class(TCustomComboBox)
  private
    FOnChange: TNotifyEvent;
    FUpdate: Boolean;
    FFontName: string;
    function GetFontName: TFontName;
    procedure SetFontName(NewFontName: TFontName);
  protected
    procedure BuildList; virtual;
    procedure Click; override;
    procedure DoChange; dynamic;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property FontName: TFontName read GetFontName write SetFontName;
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDrag;
  end;

{ TCLFontNamesCombo }
  TCLFontDevice = (fdScreen, fdPrinter, fdBoth);
  TCLFontListOptions = set of (foAnsiOnly, foTrueTypeOnly, foFixedPitchOnly,
                               foNoOEMFonts, foOEMFontsOnly, foScalableOnly);

  TCLFontNamesCombo = class(TCustomComboBox)
  private
    FFontSizesCombo: TCLFontSizesCombo;

    FTrueTypeBMP: TBitmap;
    FDeviceBMP: TBitmap;
    FOnChange: TNotifyEvent;
    FDevice: TCLFontDevice;
    FUpdate: Boolean;
    FOptions: TCLFontListOptions;
    procedure SetFontName(const NewFontName: TFontName);
    function GetFontName: TFontName;
    procedure SetDevice(Value: TCLFontDevice);
    procedure SetOptions(Value: TCLFontListOptions);
    procedure ResetItemHeight;
    procedure Reset;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure WMFontChange(var Message: TMessage); message WM_FONTCHANGE;
  protected
    procedure BuildList; virtual;
    procedure Click; override;
    procedure DoChange; dynamic;
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Text;
  published
    property FontSizesCombo: TCLFontSizesCombo read  FFontSizesCombo write FFontSizesCombo;
    property Device: TCLFontDevice read FDevice write SetDevice default fdScreen;
    property FontName: TFontName read GetFontName write SetFontName;
    property Options: TCLFontListOptions read FOptions write SetOptions default [];
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDrag;
  end;

procedure Register;

implementation

uses Printers;
{$R *.RES}

procedure Register;
begin
  RegisterComponents('ChessLink', [TCLFontNamesCombo, TCLFontSizesCombo]);
end;

function GetItemHeight(Font: TFont): Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  try
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;
  Result := Metrics.tmHeight + 1;
end;

{ TCLFontSizesCombo }
{ Big thanx for Alexander Fyodorov, 2:5030/613.6. }
const szSizeArray = 16;
      PointSizes: array[0..szSizeArray-1] of Integer =
        (8, 9, 10, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 36, 48, 72);
var boolTrueType: Boolean;

function SetFontTypeFlag(var LogFont: TEnumLogFont; var ptm: TNewTextMetric;
      FontType: integer; Data: Pointer): Integer; stdcall;
begin
  boolTrueType := (ptm.tmPitchAndFamily and TMPF_TRUETYPE) = TMPF_TRUETYPE;
  Result := 0;
end;

function IsTrueType(FontName : string) : boolean;
var DC: HDC;
begin
  DC := GetDC(0);
  EnumFontFamilies(DC, PChar(FontName), @SetFontTypeFlag, 0);
  Result := boolTrueType;
  ReleaseDC(0, DC);
end;

function FillFontSizes(var LogFont: TEnumLogFont; var ptm: TNewTextMetric;
                     FontType: Integer; Data: Pointer): Integer; stdcall;
var s: string;
    i: Integer;
begin
  i := MulDiv(LogFont.elfLogFont.lfHeight, 72, Screen.PixelsPerInch { PPI});
  s := IntToStr(i);
  if TStrings(Data).IndexOf(s) = -1 then
    TStrings(Data).Add(s);
  Result := 1;
end;

constructor TCLFontSizesCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

//  Sorted := True;
  FUpdate := False;
end;

procedure TCLFontSizesCombo.BuildList;
var DC: hDC;
    i: Integer;
begin
  Items.Clear;
  if IsTrueType(FFontName) then
  begin
    for i := 0 to szSizeArray-1 do
      Items.Add(IntToStr(PointSizes[i]));
  end
  else
  begin
    DC := GetDC(0);
    EnumFontFamilies(DC, PChar(FFontName), @FillFontSizes, Longint(Items));
    ReleaseDC(0, DC);
  end;
end;

procedure TCLFontSizesCombo.SetFontName(NewFontName: TFontName);
begin
  if (FontName <> NewFontName) then
  begin
    FFontName := NewFontName;
    BuildList;
  end;
end;

function TCLFontSizesCombo.GetFontName: TFontName;
begin
  Result := FFontName;
end;

procedure TCLFontSizesCombo.Click;
begin
  inherited Click;

  DoChange;
end;

procedure TCLFontSizesCombo.DoChange;
begin
  if not FUpdate and Assigned(FOnChange) then
    FOnChange(Self);
end;


{ TLCFontNamesCombo }

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; export;
  {$IFDEF WIN32} stdcall; {$ENDIF}
var
  Box: TCLFontNamesCombo;
  FontName: string;

  function IsValidFont: Boolean;
  begin
    Result := True;
    if foAnsiOnly in Box.Options then
      Result := Result and (LogFont.lfCharSet = ANSI_CHARSET);
    if foTrueTypeOnly in Box.Options then
      Result := Result and (FontType and TRUETYPE_FONTTYPE = TRUETYPE_FONTTYPE);
    if foFixedPitchOnly in Box.Options then
      Result := Result and (LogFont.lfPitchAndFamily and FIXED_PITCH = FIXED_PITCH);
    if foOEMFontsOnly in Box.Options then
      Result := Result and (LogFont.lfCharSet = OEM_CHARSET);
    if foNoOEMFonts in Box.Options then
      Result := Result and (LogFont.lfCharSet <> OEM_CHARSET);
    if foScalableOnly in Box.Options then
      Result := Result and (FontType and RASTER_FONTTYPE = 0);
  end;

begin
  Box := TCLFontNamesCombo(Data);
  FontName := StrPas(LogFont.lfFaceName);
  if (Box.Items.IndexOf(FontName) < 0) and IsValidFont then
    Box.Items.AddObject(FontName, TObject(FontType));
  Result := 1;
end;

constructor TCLFontNamesCombo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FFontSizesCombo := nil;

  FTrueTypeBMP := TBitmap.Create;
  try
    FTrueTypeBMP.LoadFromResourceName(hInstance, 'TRUETYPE_FNT');
  except
    FTrueTypeBMP.Free;
    FTrueTypeBMP := nil;
  end;

  FDeviceBMP := TBitmap.Create;
  try
    FDeviceBMP.LoadFromResourceName(hInstance, 'DEVICE_FNT');
  except
    FDeviceBMP.Free;
    FDeviceBMP := nil;
  end;

  FDevice := fdScreen;
  Style := csOwnerDrawFixed;
  Sorted := True;
  FUpdate := False;
  ResetItemHeight;
end;

destructor TCLFontNamesCombo.Destroy;
begin
  FTrueTypeBMP.Free;
  FDeviceBMP.Free;

  inherited Destroy;
end;

procedure TCLFontNamesCombo.BuildList;
var DC: HDC;
    Proc: TFarProc;
    i: integer;
begin
  Clear;
  for i:=0 to Screen.Fonts.Count-1 do
    Items.AddObject(Screen.Fonts[i],TObject(4));
  exit;
  //Items.Assign(Screen.Fonts);
  //exit;
  if not HandleAllocated then Exit;
  Clear;
  DC := GetDC(0);
  try
    Proc := MakeProcInstance(@EnumFontsProc, HInstance);
    try
      if (FDevice = fdScreen) or (FDevice = fdBoth) then
        EnumFonts(DC, nil, Proc, Pointer(Self));
      if (FDevice = fdPrinter) or (FDevice = fdBoth) then
        try
          EnumFonts(Printer.Handle, nil, Proc, Pointer(Self));
        except
          { skip any errors }
        end;
    finally
      FreeProcInstance(Proc);
    end;
  finally
    ReleaseDC(0, DC);
  end;
end;

procedure TCLFontNamesCombo.SetFontName(const NewFontName: TFontName);
var i, Item: Integer;
begin
  if (FontName <> NewFontName) then
  begin
    HandleNeeded;
    { change selected item }
    i := -1;
    for Item := 0 to Items.Count - 1 do
      if (AnsiUpperCase(Items[Item]) = AnsiUpperCase(NewFontName)) then
      begin
        i := Item;
        Break;
      end;
    ItemIndex := i;
    DoChange;
  end;
end;

function TCLFontNamesCombo.GetFontName: TFontName;
begin
  Result := Text;
end;

procedure TCLFontNamesCombo.SetOptions(Value: TCLFontListOptions);
begin
  if (Value <> Options) then
  begin
    FOptions := Value;
    Reset;
  end;
end;

procedure TCLFontNamesCombo.SetDevice(Value: TCLFontDevice);
begin
  if (Value <> FDevice) then
  begin
    FDevice := Value;
    Reset;
  end;
end;

procedure TCLFontNamesCombo.CreateWnd;
var OldFont: TFontName;
begin
  OldFont := FontName;

  inherited CreateWnd;

  BuildList;
  SetFontName(OldFont);
end;

procedure TCLFontNamesCombo.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  Bitmap: TBitmap;
  BmpWidth: Integer;
  Text: array[0..255] of Char;
begin
  with Canvas do
  begin
    FillRect(Rect);
    BmpWidth  := 20;
    if (Integer(Items.Objects[Index]) and TRUETYPE_FONTTYPE) <> 0 then
      Bitmap := FTrueTypeBMP
    else
     if (Integer(Items.Objects[Index]) and DEVICE_FONTTYPE) <> 0 then
       Bitmap := FDeviceBMP
     else
       Bitmap := nil;
    if Bitmap <> nil then
    begin
      BmpWidth := Bitmap.Width;
      BrushCopy(Bounds(Rect.Left + 2, (Rect.Top + Rect.Bottom - Bitmap.Height) div 2,
                Bitmap.Width, Bitmap.Height), Bitmap,
                Bounds(0, 0, Bitmap.Width, Bitmap.Height), Bitmap.TransparentColor);
    end;
    StrPCopy(Text, Items[Index]);
    Rect.Left := Rect.Left + BmpWidth + 6;
    DrawText(Canvas.Handle, Text, StrLen(Text), Rect,
             DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
  end;
end;

procedure TCLFontNamesCombo.WMFontChange(var Message: TMessage);
begin
  inherited;

  Reset;
end;

procedure TCLFontNamesCombo.CMFontChanged(var Message: TMessage);
begin
  inherited;

  ResetItemHeight;
  RecreateWnd;
end;

procedure TCLFontNamesCombo.ResetItemHeight;

  function MaxInteger(const Values: array of Longint): Longint;
  var i: Cardinal;
  begin
    Result := Values[0];
    for i := 0 to High(Values) do
      if Values[i] > Result then
        Result := Values[i];
  end;

begin
  ItemHeight := MaxInteger([GetItemHeight(Font), FTrueTypeBMP.Height - 1, 9]);
end;

procedure TCLFontNamesCombo.Click;
begin
  inherited Click;

  DoChange;
end;

procedure TCLFontNamesCombo.DoChange;
begin
  if Assigned(FFontSizesCombo) then
    FFontSizesCombo.FontName := FontName;

  if not FUpdate and Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TCLFontNamesCombo.Reset;
var SaveName: TFontName;
begin
  if HandleAllocated then
  begin
    FUpdate := True;
    try
      SaveName := FontName;
      BuildList;
      FontName := SaveName;
    finally
      FUpdate := False;
      if (FontName <> SaveName) then
        DoChange;
    end;
  end;
end;

end.

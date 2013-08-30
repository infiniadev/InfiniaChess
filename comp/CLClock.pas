unit CLClock;

interface

uses
  Windows, Classes, ExtCtrls, Graphics, Controls, SysUtils, MMSystem;

type
  TCLClock = class(TGraphicControl)
  private
    { Private declarations }
    FColor: TColor;
    FEnabled: Boolean;
    FOnZeroTime: TNotifyEvent;
    FSibling: TCLClock;
    FTime: Integer;
    FTS: TDateTime;
    FSoundEnabled: Boolean;
    FSoundFile: string;
    FSoundPlayed: Boolean;
    FSoundLimit: integer;

    procedure SetColor(const Value: TColor);
    procedure SetClockEnabled(const Value: Boolean);
    procedure SetFont(const Value: TFont);
    procedure SetTime(const Value: Integer);
    procedure SetSibling(const Value: TCLClock);
    procedure DrawTime;
    function GetFont: TFont;
    procedure DevideTime(Time: integer; var Minute, Second, MSecond: integer);
    procedure SetSoundLimit(const Value: integer);

  protected
    { Protected declarations }
    procedure Paint; override;

  public
    { Public declarations }
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Tick;

  published
    { Published declarations }
    property Anchors;
    property Color: TColor read FColor write SetColor default clWhite;
    property Enabled: Boolean read FEnabled write SetClockEnabled default False;
    property Font: TFont read GetFont write SetFont;
    property Time: Integer read FTime write SetTime default 0;
    property Sibling: TCLClock read FSibling write SetSibling;
    property SoundFile: string read FSoundFile write FSoundFile;
    property SoundEnabled: Boolean read FSoundEnabled write FSoundEnabled;
    property SoundLimit: integer read FSoundLimit write SetSoundLimit default 10;

    property OnZeroTime: TNotifyEvent read FOnZeroTime write FOnZeroTime;
  end;

procedure Register;

implementation

//______________________________________________________________________________
constructor TCLClock.Create (AOwner: TComponent);
begin
  inherited Create (AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  SetBounds(0, 0, 50, 50);
  FColor := clWhite;
  FEnabled := False;
  Canvas.Brush.Color := clBtnFace;
  FTime := 0;
  FSoundPlayed:=false;
end;
//______________________________________________________________________________
destructor TCLClock.Destroy;
begin
  inherited Destroy;
end;
//______________________________________________________________________________
procedure TCLClock.Paint;
var
  r: TRect;
begin
  r := ClientRect;
  Frame3D(Canvas, r, clBtnShadow, clBtnHighlight, 1);
  DrawTime;
end;
//______________________________________________________________________________
procedure TCLClock.Tick;
var
  Minute,Second,OldMinute,OldSecond,Dummy: integer;
begin
  if FEnabled then
    begin
      DevideTime(FTime,OldMinute,OldSecond,Dummy);
      FTime := FTime - Round((Now - FTS) * MSecsPerDay);
      FTS := Now;
      DrawTime;
      if FTime = 0 then
        if Assigned(FOnZeroTime) then FOnZeroTime(Self)
      else begin
        {DevideTime(FTime,Minute,Second,Dummy);
        if (Minute = 0) and (Second < 10) and
          ((OldMinute>0) or (OldSecond < 10)) and
          SoundEnabled and FileExists(SoundFile)
        then
          PlaySound(PChar(SoundFile), 0, snd_ASYNC);}
      end;

    end;
end;
//______________________________________________________________________________
procedure TCLClock.SetColor(const Value: TColor);
begin
  if Value = FColor then Exit;
  FColor := Value;
  if not FEnabled then Exit;
  Canvas.Brush.Color := Value;
  Invalidate;
end;
//______________________________________________________________________________
procedure TCLClock.SetClockEnabled(const Value: Boolean);
begin
  if Value = FEnabled then Exit;

  FEnabled := Value;
  FTS := Now;
  if Value = True then
    Canvas.Brush.Color := FColor
  else
    Canvas.Brush.Color := clBtnFace;

  Invalidate;

  if Value = True then
    if Assigned(FSibling) then FSibling.Enabled := False;

end;
//______________________________________________________________________________
procedure TCLClock.SetFont(const Value: TFont);
begin
  if Value = Canvas.Font then Exit;
  Canvas.Font.Assign(Value);
  Invalidate;
end;
//______________________________________________________________________________
function TCLClock.GetFont: TFont;
begin
  Result := Canvas.Font;
end;
//______________________________________________________________________________
procedure TCLClock.SetSibling(const Value: TCLClock);
begin
  if Value = FSibling then Exit;
  FSibling := Value;
end;
//______________________________________________________________________________
procedure TCLClock.SetTime(const Value: Integer);
begin
  if Value = FTime then Exit;
  FTime := Value;
  FTS := Now;
  Invalidate;
end;
//______________________________________________________________________________
procedure TCLClock.DrawTime;
var
  r: TRect;
  s: string;
  Minute, Second, MSecond: Integer;
begin
  r := ClientRect;
  InflateRect(r, -1, -1);
  DevideTime(FTime,Minute,Second,MSecond);
  if (Minute=0) and (Second<=10) then
      s := Format('%d:%.2d:%d', [Abs(Minute), Abs(Second), Abs(MSecond div 100)])
  else
    s := Format('%d:%.2d', [Abs(Minute), Abs(Second)]);
  if Minute*60+Second < FSoundLimit then begin
    if SoundEnabled and FileExists(SoundFile) and not FSoundPlayed then begin
      PlaySound(PChar(SoundFile), 0, snd_ASYNC);
      FSoundPlayed:=true;
    end
  end else
    if FSoundPlayed then FSoundPlayed:=false;

  if FTime < 0 then s := '-' + s;

  with Canvas do
    begin
      FillRect(r);
      TextOut((Width - TextWidth(s)) div 2,
        (Height - TextHeight(s)) div 2, s);
    end;
end;
//______________________________________________________________________________
procedure TCLClock.DevideTime(Time: integer; var Minute, Second, MSecond: integer);
const
  MSecsPerMinute = 60000;
  MSecs = 1000;
begin
  Minute := Trunc(FTime / MSecsPerMinute);
  Second := Trunc((FTime - Minute * MSecsPerMinute) div MSecs);
  MSecond := Trunc(FTime - Minute * MSecsPerMinute - Second*MSecs);
end;
//______________________________________________________________________________
procedure Register;
begin
  RegisterComponents('ChessLink', [TCLClock]);
end;
//______________________________________________________________________________
procedure TCLClock.SetSoundLimit(const Value: integer);
begin
  if Value < 1 then FSoundLimit:=1
  else
    FSoundLimit := Value;
end;

end.


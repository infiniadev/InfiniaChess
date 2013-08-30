unit CLColorButton;

interface

uses
  Controls, Graphics, Messages, Classes, Windows, Extctrls;

type

  TCLColorButton = class(TGraphicControl)
  private
    { Private declarations }
    FAutoSize: Boolean;
    FBorder: Integer;
    FBorderColor: TColor;
    FButtonColor: TColor;
    FDown: Boolean;
    FEnabled: Boolean;
    FHighLightColor: TColor;
    FMouseDown: Boolean;
    FMouseInControl: Boolean;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FShadowColor: TColor;

    procedure SetAutoSize(value: Boolean);
    procedure SetBorder(value: Integer);
    procedure SetBorderColor(value: TColor);
    procedure SetButtonColor(value: TColor);
    procedure SetDown(value: Boolean);
    procedure SetHighLightColor(value: TColor);
    procedure SetShadowColor(value: TColor);

  protected
    { Protected declarations }
    procedure CMFontChanged(var Msg: TWmNoParams); message CM_FontChanged;
    procedure CMMouseEnter(var Msg: TMessage); message CM_MouseEnter;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MouseLeave;
    procedure CMTextChanged(var Msg: TWmNoParams); message CM_TextChanged;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;

  published
    { Published declarations }
    property Caption;
    property Constraints;
    property Font;
    property Visible;
    property OnClick;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property Border: Integer read FBorder write SetBorder;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property ButtonColor: TColor read FButtonColor write SetButtonColor;
    property Down: Boolean read FDown write SetDown;
    property Enabled: Boolean read FEnabled write FEnabled;
    property HighLightColor: TColor read FHighLightColor write SetHighLightColor;
    property ShadowColor: TColor read FShadowColor write SetShadowColor;
    property OnMouseEnter : TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave : TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

procedure Register;

implementation

const
  TEXT_BUFF = 4;

//______________________________________________________________________________
procedure TCLColorButton.SetAutoSize(value: Boolean);
begin
  if value = FAutoSize then exit;
  FAutoSize := value;
  if FAutoSize then invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.SetBorder(value: Integer);
begin
  if value = FBorder then exit;
  FBorder := value;
  invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.SetBorderColor(value: TColor);
begin
  if value = FBorderColor then exit;
  FBorderColor := value;
  invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.SetButtonColor(value: TColor);
begin
  if value = FButtonColor then exit;

  FButtonColor := value;
  Invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.SetDown(value: Boolean);
begin
  if value = FDown then exit;

  FDown := value;
  Invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.SetHighLightColor(value: TColor);
begin
  if value = FHighLightColor then exit;
  FHighLightColor := value;
  invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.SetShadowColor(value: TColor);
begin
  if value = FShadowColor then exit;
  FShadowColor := value;
  invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.CMTextChanged(var Msg: TWmNoParams);
begin
  inherited;
  if FAutoSize then Width := Canvas.TextWidth(Caption) + (FBorder * 2) +
    (TEXT_BUFF * 2);
  invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.CMFontChanged(var Msg: TWmNoParams);
begin
  inherited;
  Canvas.Font.Assign(Font);
  if FAutoSize then Width := Canvas.TextWidth(Caption) + 2;
  Invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.CMMouseEnter(var Msg: TMessage);
begin
  FMouseInControl := True;
  if not FEnabled then exit;
  Invalidate;
  if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;
//______________________________________________________________________________
procedure TCLColorButton.CMMouseLeave(var Msg: TMessage);
begin
  FMouseInControl := False;
  if not FEnabled then exit;
  Invalidate;
  if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;
//______________________________________________________________________________
procedure TCLColorButton.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not FEnabled then exit;
  FMouseDown := True;
  Invalidate;
end;
//______________________________________________________________________________
procedure TCLColorButton.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseDown := False;
  if not FEnabled then exit;
  Invalidate;
  if FMouseInControl then Click;
end;
//______________________________________________________________________________
procedure TCLColorButton.Paint;
var
  Face: TRect;
begin

  { Draw the boarder if needed }
  Face := ClientRect;
  if ((FMouseInControl or FDown) and FEnabled)
  or (csDesigning in ComponentState) then
    begin
      if FMouseDown or FDown then
        Frame3D(Canvas, Face, FShadowColor, FHighLightColor, 1)
      else
        Frame3D(Canvas, Face, FHighLightColor, FShadowColor, 1);
    end
  else
    begin
      Frame3D(Canvas, Face, FBorderColor, FBorderColor, 1);
    end;

  with Canvas do
    begin
      Pen.Color := FBorderColor;

      Brush.Color := FBorderColor;
      Rectangle(Face);

      InflateRect(Face, -FBorder, - FBorder);
      {if (FMouseDown and FMouseInControl) or (FDown and FEnabled) then
        OffsetRect(Face, 1, 1);}
      Brush.Color := FButtonColor;
      Rectangle(Face);

      { ??? Still need Disabled Text Code }
      if Caption <> '' then
        begin
          Face.Left := TEXT_BUFF + FBorder;
          Face.Top := (Height - TextHeight(Caption)) div 2 -1;
          { if (FMouseDown and FMouseInControl) or (FDown and FEnabled) then
            OffsetRect(Face, 1, 1); }
          Brush.Style := bsClear;
          DrawText(Handle, PChar(Caption), Length(Caption), Face, 0);
          Brush.Style := bsSolid;
        end;
    end;
end;
//______________________________________________________________________________
constructor TCLColorButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetBounds(0, 0, 22, 22);
  ControlStyle := [csCaptureMouse, csOpaque];
  FBorder := 1;
  FBorderColor := clBtnFace;
  FButtonColor := clBtnFace;
  FDown := False;
  FEnabled := True;
  FHighLightColor := clBtnHighLight;
  FShadowColor := clBtnShadow;
end;
//______________________________________________________________________________
destructor TCLColorButton.Destroy;
begin
  inherited Destroy;
end;
//______________________________________________________________________________
procedure TCLColorButton.Click;
begin
  inherited;
end;
//______________________________________________________________________________
procedure Register;
begin
  RegisterComponents('ChessLink', [TCLColorButton]);
end;
//______________________________________________________________________________
end.

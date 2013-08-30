unit CLBaseDraw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, contnrs, ComCtrls;

type
  TCLBaseDrawButton = class
    R: TRect;
    Tag: integer;
    CanBePressed: Boolean;
    MouseRespond: Boolean;
    ButtonType: integer;
    MouseOn: Boolean;
    State: integer;
  end;

  TCLBaseDrawButtons = class(TObjectList)
  private
    function GetButton(Index: integer): TCLBaseDrawButton;
  public
    function ButtonByXY(X, Y: integer): TCLBaseDrawButton;
    function ButtonIndexByXY(X, Y: integer): integer;
    function ButtonByTag(p_Tag: integer): TCLBaseDrawButton;
    property Button[Index: integer]: TCLBaseDrawButton read GetButton; default;
  end;

  TfCLBaseDraw = class(TForm)
    sbHor: TScrollBar;
    sbVer: TScrollBar;
    lvDumb: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure sbVerScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    BMP: TBitMap;
    FVerScrollBarAlwaysVisible: Boolean;
    PaintExceptionDetected: Boolean;
    procedure ResizeScrollBars(FullWidth, FullHeight: integer);
  protected
    Buttons: TCLBaseDrawButtons;
    MouseButtonIndex: integer;
    procedure OnBaseDrawButtonCilck(btn: TCLBaseDrawButton); virtual;
    procedure AddBaseDrawButton(R: TRect; p_ButtonType, p_Tag: integer;
      p_CanBePressed, p_MouseRespond: Boolean);
  public
    { Public declarations }
    procedure VirtualDraw(cnv: TCanvas; X,Y: integer; var pp_FullWidth, pp_FullHeight: integer); virtual; abstract;
    property VerScrollBarAlwaysVisible: Boolean read FVerScrollBarAlwaysVisible write FVerScrollBarAlwaysVisible;
  end;

var
  fCLBaseDraw: TfCLBaseDraw;

implementation

uses CLLib, CLGlobal, CLMain;

{$R *.DFM}
//==============================================================================================
procedure TfCLBaseDraw.FormCreate(Sender: TObject);
begin
  BMP := TBitMap.Create;
  BMP.Width := Width;
  BMP.Height := Height;

  Buttons := TCLBaseDrawButtons.Create;

  DoubleBuffered := true;
end;
//==============================================================================================
procedure TfCLBaseDraw.FormDestroy(Sender: TObject);
begin
  BMP.Free;
  Buttons.Free;
end;
//==============================================================================================
procedure TfCLBaseDraw.FormResize(Sender: TObject);
begin
  BMP.Width := Width;
  BMP.Height := Height;
  Repaint;
end;
//==============================================================================================
procedure TfCLBaseDraw.FormPaint(Sender: TObject);
var
  i, FullHeight, FullWidth: integer;
begin
  try
    BMP.Canvas.Brush.Color := fGL.DefaultBackgroundColor;
    BMP.Canvas.FillRect(ClientRect);
    VirtualDraw(BMP.Canvas, sbHor.Position, sbVer.Position, FullWidth, FullHeight);
  except
    on E:Exception do begin
      SendErrorToServer('Interface', fCLMain.GetExceptionStack, 0, E.Message, '');
      PaintExceptionDetected := true;
      if fsModal in FormState then ModalResult := mrOk;      
    end;
  end;
  Canvas.CopyRect(Rect(0, 0, Width, Height), BMP.Canvas, Rect(0,0,Width,Height));
  ResizeScrollBars(FullWidth, FullHeight);
end;
//==============================================================================================
procedure TfCLBaseDraw.ResizeScrollBars(FullWidth, FullHeight: integer);
var
  oldVisible: Boolean;
begin
  oldVisible := sbVer.Visible;
  sbVer.Visible := VerScrollBarAlwaysVisible or (FullHeight > Height);
  if sbVer.Visible then
    if FullHeight > Height then sbVer.Max := FullHeight - Height
    else sbVer.Max := sbVer.Min;

  sbVer.Enabled := FullHeight > Height;

  if oldVisible and not sbVer.Visible and (sbVer.Position > 0) then
    sbVer.Position := 0;

  oldVisible := sbHor.Visible;
  sbHor.Visible := FullWidth > Width;
  if sbHor.Visible then sbHor.Max := FullWidth - Width;

  if oldVisible and not sbHor.Visible and (sbHor.Position > 0) then
    sbHor.Position := 0; 
end;
//==============================================================================================
procedure TfCLBaseDraw.sbVerScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  Repaint;
end;
//==============================================================================================
{ TCLBaseDrawButtons }

function TCLBaseDrawButtons.ButtonByTag(p_Tag: integer): TCLBaseDrawButton;
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := Self[i];
    if result.Tag = p_Tag then exit;
  end;
  result := nil;
end;
//==============================================================================================
function TCLBaseDrawButtons.ButtonByXY(X, Y: integer): TCLBaseDrawButton;
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := Self[i];
    if PointInRect(result.R, X, Y) then exit;
  end;
  result := nil;
end;
//==============================================================================================
function TCLBaseDrawButtons.ButtonIndexByXY(X, Y: integer): integer;
var
  i: integer;
begin
  for i := 0 to Count - 1 do begin
    result := i;
    if PointInRect(Self[i].R, X, Y) then exit;
  end;
  result := -1;
end;
//==============================================================================================
function TCLBaseDrawButtons.GetButton(Index: integer): TCLBaseDrawButton;
begin
  result := TCLBaseDrawButton(Items[Index]);
end;
//==============================================================================================
procedure TfCLBaseDraw.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  index: integer;
  ToRepaint: Boolean;
begin
  lvDumb.SetFocus;
  index := Buttons.ButtonIndexByXY(X, Y);
  if index <> -1 then Cursor := 1
  else Cursor := 0;

  {ToRepaint := false;
  index := Buttons.ButtonIndexByXY(X, Y);
  if MouseButtonIndex = index then exit;

  if MouseButtonIndex <> -1 then begin
    Buttons[MouseButtonIndex].MouseOn := false;
    MouseButtonIndex := -1;
    ToRepaint := true;
  end;

  if (index <> -1) and Buttons[index].MouseRespond then begin
    Buttons[index].MouseOn := true;
    MouseButtonIndex := index;
    ToRepaint := true;
  end;

  if ToRepaint then Repaint;}
end;
//==============================================================================================
procedure TfCLBaseDraw.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  btn: TCLBaseDrawButton;
  n: integer;
begin
  Resize;
  //sbVer.OnScroll(sbVer, scTrack, n);
  if Button <> mbLeft then exit;
  btn := Buttons.ButtonByXY(X, Y);
  if (btn <> nil) and (btn.CanBePressed) then
    OnBaseDrawButtonCilck(btn);
  if (btn = nil) and (fsModal in FormState) and PaintExceptionDetected then
    ModalResult := mrOk;
end;
//==============================================================================================
procedure TfCLBaseDraw.OnBaseDrawButtonCilck(btn: TCLBaseDrawButton);
begin
  //
end;
//==============================================================================================
procedure TfCLBaseDraw.AddBaseDrawButton(R: TRect; p_ButtonType, p_Tag: integer;
  p_CanBePressed, p_MouseRespond: Boolean);
var
  Btn: TCLBaseDrawButton;
begin
  Btn := TCLBaseDrawButton.Create;
  Btn.R := R;
  Btn.ButtonType := p_ButtonType;
  Btn.Tag := p_Tag;
  Btn.CanBePressed := p_CanBePressed;
  Btn.MouseRespond := p_MouseRespond;
  Buttons.Add(btn);
end;
//==============================================================================================
procedure TfCLBaseDraw.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if sbVer.Visible and sbVer.Enabled then begin
    sbVer.Position := sbVer.Position - sbVer.LargeChange * sign(WheelDelta);
    Repaint;
  end;
end;
//==============================================================================================
procedure TfCLBaseDraw.FormShow(Sender: TObject);
begin
  lvDumb.SetFocus;
end;

end.

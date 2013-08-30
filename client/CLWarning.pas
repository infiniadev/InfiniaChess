unit CLWarning;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CLBaseDraw, StdCtrls, ExtCtrls, Buttons, ShellAPI, math;

type
  TfCLWarning = class(TForm)
    pnlRenew: TPanel;
    SpeedButton1: TSpeedButton;
    pnlContinue: TPanel;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    procedure FormPaint(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    function DrawText: integer;
  private
    { Private declarations }
    WarningText: string;
    WarningType: string;
  public
    { Public declarations }
    procedure Init(p_Text, p_Type: string);
  end;

var
  fCLWarning: TfCLWarning;

procedure ShowServerWarning(Datapack: TStrings);

implementation

{$R *.DFM}

uses CLConst, CLLib, CLGlobal;

//==============================================================================
procedure ShowServerWarning(Datapack: TStrings);
begin
  if (Datapack.Count < 3) or Assigned(fCLWarning) then exit;
  fCLWarning := TfCLWarning.Create(Application);
  fCLWarning.Init(Datapack[2], Datapack[1]);
  fCLWarning.ShowModal;
  fCLWarning.Free;
  fCLWarning := nil;
end;
//==============================================================================
{ TfCLWarning }

procedure TfCLWarning.Init(p_Text, p_Type: string);
var
  vBottom: integer;
begin
  WarningText := p_Text;
  WarningType := p_Type;
  pnlRenew.Visible := (p_Type = SW_END_MEMBERSHIP) or (p_Type = SW_TRIAL_MEMBERSHIP);
  Canvas.Font.Name := 'Arial';
  vBottom := DrawText;

  Height := vBottom + pnlContinue.Height + 20;
end;
//==============================================================================
procedure TfCLWarning.FormPaint(Sender: TObject);
var
  vBottom: integer;
begin
  //Canvas.Brush.Color := fGL.DefaultBackgroundColor;
  Canvas.Rectangle(ClientRect);
  Canvas.Font.Name := 'Arial';
  DrawText;
  //TextOutMultiline(Canvas, Image1.Left + Image1.Width + 10, Width - 10, 10, 0, WarningText, clBlack, 14, [fsBold], vBottom, true);
end;
//==============================================================================
procedure TfCLWarning.SpeedButton2Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;
//==============================================================================
procedure TfCLWarning.SpeedButton1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('http://www.infiniachess.com/customer-login.aspx'), '', '', SW_SHOWNORMAL)
end;
//==============================================================================
function TfCLWarning.DrawText: integer;
var
  vBottom: integer;
  R: TRect;
begin
  TextOutMultiline(Canvas, Image1.Left + Image1.Width + 8, Width - 10, 10, 0, WarningText, clBlack, 14, [fsBold], vBottom, true);
  vBottom := max(vBottom, Image1.Top + Image1.Height) + 10;

  if SPECIAL_OFFER <> '' then begin
    R := Rect(8, vBottom, Width - 8, pnlContinue.Top - 6);
    DrawFrame(Canvas, R, clBlue, 2, 3);
    Canvas.Pen.Color := clBlack;
    TextOutMultiline(Canvas, 12, Width - 12, vBottom + 6, 0, SPECIAL_OFFER, clBlue, 14, [fsBold], vBottom, true);
  end;
  result := vBottom;
end;
//==============================================================================
end.

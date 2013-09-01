{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLAchGroups;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CLBaseDraw, StdCtrls, Mask, ComCtrls;

type
  TfCLAchGroups = class(TfCLBaseDraw)
  private
    FGroupIDChoosen: integer;
    { Private declarations }
    function GetVisibleRect(p_Hor, p_Ver: Boolean): TRect;
    procedure SetGroupIDChoosen(const Value: integer);
  protected
    procedure OnBaseDrawButtonCilck(btn: TCLBaseDrawButton); override;
  public
    { Public declarations }
    procedure VirtualDraw(cnv: TCanvas; X,Y: integer; var pp_FullWidth, pp_FullHeight: integer); override;
    property GroupIDChoosen: integer read FGroupIDChoosen write SetGroupIDChoosen;
  end;

var
  fCLAchGroups: TfCLAchGroups;

implementation

{$R *.DFM}

uses CLAchievementClass, CLLib, CLAchievements, CLGlobal;

{ TfCLAchGroups }
//==============================================================================================
function TfCLAchGroups.GetVisibleRect(p_Hor, p_Ver: Boolean): TRect;
var
  r, b: integer;
begin
  if p_Ver then r := Width - sbVer.Width
  else r := Width;

  if p_Hor then b := Height - sbHor.Height
  else b := Height;

  result := Rect(1, 1, r, b);
end;
//==============================================================================================
procedure TfCLAchGroups.OnBaseDrawButtonCilck(btn: TCLBaseDrawButton);
begin
  if btn.Tag <> GroupIDChoosen then begin
    GroupIDChoosen := btn.Tag;
    Repaint;
  end;
end;
//==============================================================================================
procedure TfCLAchGroups.SetGroupIDChoosen(const Value: integer);
begin
  if FGroupIDChoosen = Value then exit;

  FGroupIDChoosen := Value;
  if Assigned(Parent) and (Parent is TfCLAchievements) then
    TfCLAchievements(Parent).OnGroupIDChange(Value);
end;
//==============================================================================================
procedure TfCLAchGroups.VirtualDraw(cnv: TCanvas; X, Y: integer; var pp_FullWidth, pp_FullHeight: integer);
var
  i, CurY, shift, textshift, textWidth, interval, biVer, YDistance: integer;
  RectLeft, RectRight, RectWidth, TextLeft: integer;
  colButton, colButtonPressed: TColor;
  slButtons: TStringList;
  //********************************************************************************************
  procedure InitVars;
  begin
    shift := 10; // distance between button and left (right) edges of form
    textshift := 4; // distance between left (right) side of button and text
    interval := 10; // vertical distance between buttons
    biVer := 6; // distance between top (bottom) side of button and text

    textWidth := Width - 2 * shift - 2 * textshift - sbVer.Width; // full text width
    YDistance := 4; // distance between lines of text inside one button

    colButton := RGB(240,240,240); // color of non-pressed button
    colButtonPressed := RGB(120, 230, 120); // color of pressed button
  end;
  //********************************************************************************************
  procedure CountFullHeight;
  var
    i, h: integer;
  begin
    pp_FullHeight := interval;
    for i := 0 to slButtons.Count - 1 do begin
      h := TextHeightMultiline(cnv, textWidth, YDistance, slButtons.Names[i], clBlack, 8, [fsBold]);
      pp_FullHeight := pp_FullHeight + h + interval + 2 * biVer;
    end;
  end;
  //********************************************************************************************
  procedure CreateSLButtons;
  var
    i: integer;
  begin
    slButtons := TStringList.Create;
    slButtons.Add('Common and Statistics=0');
    for i := 0 to AchList.GroupCount - 1 do
      slButtons.Add(Format('%s=%d',[AchList.Group[i].Name,AchList.Group[i].ID]));
  end;
  //********************************************************************************************
  procedure DefineParams;
  begin
    CurY := interval - Y;

    if pp_FullHeight > Height then RectRight := Width - sbVer.Width - shift
    else RectRight := Width - shift;

    RectLeft := shift;
    RectWidth := RectRight - RectLeft + 1;
    TextLeft := RectLeft + (RectWidth - textWidth) div 2;
  end;
  //********************************************************************************************
  procedure AddBaseDrawButton(R: TRect; GroupID: integer);
  var
    Btn: TCLBaseDrawButton;
  begin
    Btn := TCLBaseDrawButton.Create;
    Btn.R := R;
    Btn.Tag := GroupID;
    Btn.CanBePressed := true;
    Btn.MouseRespond := true;
    Btn.ButtonType := 1;
    Buttons.Add(btn);
  end;
  //********************************************************************************************
  procedure DrawButton(p_Caption: string; p_GroupID: integer);
  var
    h: integer;
    R: TRect;
    col: TColor;
  begin
    h := TextHeightMultiline(cnv, textWidth, YDistance, p_Caption, clBlack, 8, [fsBold]);
    R := Rect(RectLeft, CurY, RectRight, CurY + h + biVer*2);

    if p_GroupID = GroupIDChoosen then col := colButtonPressed
    else col := colButton;

    DrawFilledFrame(cnv, IncRect(R, 2, 2), clGray, clGray, 1, 3);
    DrawFilledFrame(cnv, R, clBlack, col, 2, 3);
    AddBaseDrawButton(R, p_GroupID);

    TextOutMultiLine(cnv, TextLeft - X, TextLeft + TextWidth - X,
      CurY + biVer, 4, p_Caption, clBlack, 8, [fsBold], CurY, true);

    CurY := CurY + biVer + interval;
  end;
  //********************************************************************************************
begin
  InitVars;
  CreateSLButtons; // creating full list of buttons, it consists of "Common" and List of Groups
  CountFullHeight;
  DefineParams;

  cnv.Brush.Color := fGL.DefaultBackgroundColor;//TForm(Parent).Color;
  cnv.FillRect(ClientRect);

  Buttons.Clear;

  for i := 0 to slButtons.Count - 1 do
    DrawButton(slButtons.Names[i], StrToInt(slButtons.Values[slButtons.Names[i]]));

  pp_FullWidth := Width;
  DrawFrame(cnv, GetVisibleRect(pp_FullWidth > Width, pp_FullHeight > Height), clBlack, 2, 3);

  slButtons.Free;
end;
//==============================================================================================
end.

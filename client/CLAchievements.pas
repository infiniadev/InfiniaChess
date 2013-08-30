unit CLAchievements;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CLAchievementClass, Math, CLAchGroups, CLAchList;

type
  TfCLAchievements = class(TForm)
    sbVer: TScrollBar;
    pnlFilter: TPanel;
    sbHor: TScrollBar;
    cmbFilter: TComboBox;
    edName: TEdit;
    Label1: TLabel;
    pnlHeader: TPanel;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbVerChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbVerScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
  private
    { Private declarations }
    bmpFull: TBitMap;
    COLOR_GROUP: TColor;
    COLOR_PI_GREEN: TColor;
    GROUP_HEIGHT: integer;
    REDRAW: Boolean;

    GroupsForm: TFCLAchGroups;
    AchListForm: TfCLAchList;

    procedure DrawAchievements;
    function TopYImage: integer;
  public
    { Public declarations }
    CurAchUserList: TCLAchUserList;
    procedure SetChildrenParams;
    procedure OnGroupIDChange(p_GroupID: integer);
  end;

var
  fCLAchievements: TfCLAchievements;

implementation

{$R *.DFM}

uses CLLib;
//===============================================================================
procedure TfCLAchievements.FormPaint(Sender: TObject);
var
  TopY: integer;
begin
  try
    GroupsForm.Repaint;
    AchListForm.Repaint;

    {if REDRAW then DrawAchievements;

    TopY := pnlFilter.Top + pnlFilter.Height;
    //Canvas.Draw(0, 0, bmpFull);
    Canvas.CopyRect(Rect(0, TopY, Self.Width, self.Height),bmpFull.Canvas,
      Rect(0,0,Self.Width,self.Height - TopY));}
  except
    on E:Exception do
      showmessage(E.Message);
  end;
end;
//===============================================================================
procedure TfCLAchievements.FormCreate(Sender: TObject);
begin
  try
    bmpFull := TBitmap.Create;
    bmpFull.Width := Self.Width;
    bmpFull.Height := Self.Height;

    REDRAW := true;
    COLOR_GROUP := RGB(119,181,43);
    COLOR_PI_GREEN := RGB(119,181,43);
    GROUP_HEIGHT := 40;

    CurAchUserList := MyAchUserList;

    GroupsForm := TfCLAchGroups.Create(Application);
    GroupsForm.Parent := Self;
    GroupsForm.Visible := true;
    GroupsForm.Align := alRight;

    AchListForm := TfCLAchList.Create(Application);
    AchListForm.Parent := Self;
    AchListForm.Visible := true;
    AchListForm.Align := alClient;

    DoubleBuffered := true;

  except
    on E:Exception do
      showmessage(E.Message);
  end;
end;
//===============================================================================
procedure TfCLAchievements.DrawAchievements;
var
  i, StartX, StartY, curY, fullWidth, PiWidth, PiHeight, PiX, PiY, nSB: integer;
  vAch: TCLAchievement;
  curGroup, group: TCLAchGroup;
  cnv: TCanvas;
  bmpPI: TBitMap;
  //*****************************************************************************
  function OnScreen(R: TRect): Boolean;
  begin
    result := (R.Left < Self.Width) and (R.Right > 0) and (R.Bottom > TopYImage) and (R.Top < Self.Height)
  end;
  //*****************************************************************************
  procedure DrawGroup(group: TCLAchGroup);
  var
    btn: TCLAchButton;
    s: string;
  begin
    cnv.Brush.Color := COLOR_GROUP;
    cnv.FillRect(Rect(-StartX, CurY-StartY, FullWidth - StartX, CurY + GROUP_HEIGHT - StartY));

    btn := TCLAchButton.Create;
    btn.R := Rect(10 - StartX, CurY + 8 - StartY + TopYImage, 26 - StartX, CurY + 24 - StartY + TopYImage);
    btn.ButtonType := abtGroup;
    btn.Tag := group.ID;
    btn.TurnedOn := CurAchUserList.GetButtonState(group);
    if OnScreen(btn.R) then CurAchUserList.Buttons.Add(btn);

    if btn.TurnedOn then s := '-' else s := '+';

    TextOut(cnv, 10 - StartX, CurY + 8 - StartY, s, clSilver, 16, [fsBold]);
    TextOut(cnv, 30 - StartX, CurY + 10 - StartY, UpperCase(group.Name), clBlack, 12, [fsBold]);
    cnv.Brush.Color := clBlack;
    cnv.FillRect(Rect(-StartX, CurY + GROUP_HEIGHT - 3 - StartY, FullWidth - StartX, CurY + GROUP_HEIGHT - StartY));
    CurY := CurY + GROUP_HEIGHT;
  end;
  //*****************************************************************************
  procedure DrawPIOne(Canvas: TCanvas; Color: TColor; R: TRect; Progress, MaxCount: integer);
  var
    s: string;
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect(R);
    Canvas.Pen.Width := 2;
    Canvas.Pen.Color := clBlack;
    Canvas.Rectangle(R);

    s := Format('%d / %d', [Progress,MaxCount]);
    TextOutCenter(Canvas, R, s, clBlack, 12, [fsBold]);
  end;
  //*****************************************************************************
  procedure DrawProgressIndicator(R: TRect; Progress, MaxCount: integer);
  var
    greenWidth: integer;
    RGreen: TRect;
  begin
    RGreen := Rect(0,0,R.Right - R.Left,R.Bottom - R.Top);
    DrawPIOne(bmpPI.Canvas, COLOR_PI_GREEN, RGreen, Progress, MaxCount);
    DrawPIOne(cnv, clGray, R, Progress, MaxCount);
    greenWidth := Round(Progress * 1.0 * PiWidth / MaxCount);
    cnv.CopyRect(Rect(R.Left,R.Top,R.Left + greenWidth, R.Bottom), bmpPI.Canvas,
      Rect(0,0,greenWidth,R.Bottom-R.Top));
  end;
  //*****************************************************************************
  procedure DrawAch(ach: TCLAchievement);
  var
    AchHeight, i, TextLeft, TextRight, TextCurY: integer;
    AU: TCLAchUser;
    AUI: TCLAchUserInfo;
  begin
    AU := CurAchUserList.AchUserByID[Ach.ID];
    if AU = nil then AchHeight := 60
    else AchHeight := 60 + AU.InfoList.Count * 24;

    cnv.Brush.Color := clSilver; //RGB(86, 126, 137);
    cnv.FillRect(Rect(-StartX, curY - StartY, FullWidth - StartX, curY + AchHeight - StartY));

    cnv.Brush.Color := clGray;
    cnv.FillRect(Rect(14 - StartX, CurY + 14 - StartY, 46 - StartX, CurY + 46 - StartY));

    //cnv.Brush.Color := Parent.Color;

    PiWidth := 200;
    PiHeight := 26;
    PiX := FullWidth - PiWidth - 50;
    PiY := CurY + 15;
    DrawProgressIndicator(Rect(PiX - StartX,PiY - StartY,PiX + PiWidth - StartX,PiY + PiHeight - StartY),
      CurAchUserList.ProgressByID(ach.ID), ach.MaxCount);

    TextLeft := 72 - StartX;
    TextRight := PiX - 20;
    TextCurY := CurY + 10;

    cnv.Brush.Color := clSilver;
    TextOutMultiLine(cnv, TextLeft, TextRight, TextCurY, 4, UpperCase(ach.Name), clBlack, 10, [fsBold], TextCurY);
    if ach.Description <> '' then
      TextOutMultiLine(cnv, TextLeft, TextRight, TextCurY, 4, ach.Description, clBlack, 10, [fsBold], TextCurY);

    if AU <> nil then
      for i := 0 to AU.InfoList.Count - 1 do begin
        AUI := AU.InfoList[i];
        TextOutMultiLine(cnv, TextLeft, TextRight, TextCurY, 4, AUI.Text, clBlack, 10, [fsBold], TextCurY);
      end;

    cnv.Brush.Color := clBlack;
    cnv.FillRect(Rect(-StartX, CurY + AchHeight - 3 - StartY, FullWidth - StartX, CurY + AchHeight - StartY));

    {if ach.Progress > ach.MaxCount then
      ach.Progress := ach.MaxCount;}

    curY := curY + AchHeight;
  end;
  //*****************************************************************************
begin
  StartX := 0; StartY := 0;
  fullWidth := Self.Width;
  cnv := bmpFull.Canvas;

  bmpPI := TBitMap.Create;
  bmpPI.Width := Self.Width;
  bmpPI.Height := Self.Height;

  CurAchUserList.Buttons.Clear;
  if CurAchUserList.stGroup = '' then
    CurAchUserList.FillStateStrings;

  nSB := 0;
  curGroup := nil;
  curY := 0;
  for i := 0 to AchList.Count - 1 do begin
    vAch := AchList[i];
    if not Assigned(curGroup) or (curGroup.ID <> vAch.GroupID) then begin
      group := AchList.GroupByID[vAch.GroupID];
      curGroup := group;
      if (nSB >= sbVer.Position) and (curY <= Self.Height) then
        DrawGroup(group);
      inc(nSB);
    end;
    if CurAchUserList.GetButtonState(curGroup) then begin
      if (nSB >= sbVer.Position) and (curY <= Self.Height) {and CurAchUserList.InfoExists(vAch.ID)} then
        DrawAch(vAch);
      inc(nSB);
    end;
  end;

  sbVer.Max := nSB; //max(sbVer.min, CurY - (Self.Height - (pnlFilter.Top + pnlFilter.Height)));
  bmpPI.Free;
end;
//===============================================================================
procedure TfCLAchievements.sbVerChange(Sender: TObject);
begin
  //REDRAW := true;
  //Repaint;
end;
//===============================================================================
procedure TfCLAchievements.FormResize(Sender: TObject);
begin
  bmpFull.Width := Self.Width;
  bmpFull.Height := Self.Height;
end;
//===============================================================================
function TfCLAchievements.TopYImage: integer;
begin
  result := pnlFilter.Top + pnlFilter.Height;
end;
//===============================================================================
procedure TfCLAchievements.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  btn: TCLAchButton;
  State: Boolean;
begin
  btn := CurAchUserList.Buttons.ButtonByXY(X,Y);
  if btn = nil then exit;
  CurAchUserList.SwapButtonState(btn.ButtonType, btn.Tag);
  Repaint;
end;
//===============================================================================
procedure TfCLAchievements.sbVerScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  Repaint;
  //if ScrollCode <> scTrack then Repaint;
end;
//===============================================================================
procedure TfCLAchievements.SetChildrenParams;
begin
  GroupsForm.Color := Color;
  AchListForm.Color := Color;
end;
//===============================================================================
procedure TfCLAchievements.OnGroupIDChange(p_GroupID: integer);
begin
  if GroupsForm.GroupIDChoosen <> p_GroupID then begin
    GroupsForm.GroupIDChoosen := p_GroupID;
    GroupsForm.Repaint;
  end else begin
    AchListForm.GroupIDChoosen := p_GroupID;
    AchListForm.Repaint;
  end;
end;
//===============================================================================
end.

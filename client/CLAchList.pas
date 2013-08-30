unit CLAchList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CLBaseDraw, StdCtrls, jpeg, ExtCtrls, ImgList, CLAchievementClass, ShellAPI,
  ComCtrls;

type
  TfCLAchList = class(TfCLBaseDraw)
    ilCoins: TImageList;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure DrawAchievement(cnv: TCanvas; AchID, p_Left, p_Right, p_Top: integer; p_Details: Boolean; var pp_Height: integer);
    function GetCurAchUserList: TCLAchUserList;
    function GetBackgroundColor: TColor;
  protected
    procedure OnBaseDrawButtonCilck(btn: TCLBaseDrawButton); override;
  public
    { Public declarations }
    GroupIDChoosen: integer;
    AchIDChoosen: integer;
    procedure VirtualDraw(cnv: TCanvas; X,Y: integer; var pp_FullWidth, pp_FullHeight: integer); override;
    procedure DrawStatisticsPage(cnv: TCanvas; X,Y: integer; var pp_FullWidth, pp_FullHeight: integer);
    procedure DrawCongratulations(cnv: TCanvas; X,Y: integer; var pp_FullWidth, pp_FullHeight: integer);
    function GetAchStatus(AchID: integer): TAchUserStatus;
    procedure SetCongratulationParams(p_AchID: integer);

    property CurAchUserList: TCLAchUserList read GetCurAchUserList;
    property BackgroundColor: TColor read GetBackgroundColor;
  end;

var
  fCLAchList: TfCLAchList;

implementation

{$R *.DFM}

uses CLLib, CLAchievements, CLGlobal, CLSocket;

const
  BTN_ACHIEVEMENT = 1;
  BTN_GROUP = 2;
  BTN_CLOSE = 3;
  BTN_TOP100 = 4;

{ TfCLAchList }
//==============================================================================================
procedure TfCLAchList.DrawAchievement(cnv: TCanvas; AchID, p_Left, p_Right,
  p_Top: integer; p_Details: Boolean; var pp_Height: integer);
var
  TextLeft, TextRight, TextWidth, coinShift, PiWidth, PiHeight: integer;
  CornerShift, BorderWidth, Progress, n: integer;
  rectCoin, rectPi, rectMain: TRect;
  Ach: TCLAchievement;
  clPiGreen, clMain, clBorder, clName: TColor;
  aus: TAchUserStatus;
  bmpCorner: TBitMap;
  AchieveDate: TDateTime;
  NameStyle: TFontStyles;
  AU: TCLAchUser;
  PiOptions: TProgressIndicatorOptions;
  desc: string;
  //********************************************************************************************
  procedure InitVars;
  var
    n: integer;
  begin
    Ach := AchList.AchByID[AchID];
    aus := GetAchStatus(AchID);

    if CurAchUserList = nil then AU := nil
    else AU := CurAchUserList.AchUserByID[AchID];

    if GroupIDChoosen = -1 then begin
      Progress := 0;
      AchieveDate := Date + Time;
    end else if AU = nil then begin
      Progress := 0;
      AchieveDate := 0;
    end else begin
      Progress := AU.Progress;
      AchieveDate := AU.AchieveDate;
    end;

    cnv.Font.Size := 12;
    cnv.Font.Style := [fsBold];
    PiWidth := cnv.TextWidth('88888 / 88888') + 10;
    PiHeight := cnv.TextHeight('8') + 4;
    n := 10;
    rectPI := Rect(p_Right - n - PiWidth, p_Top + n, p_Right - n, p_Top + n + PiHeight);
    clPiGreen := RGB(120, 230, 120);

    cnv.Font.Size := 14;
    cnv.Font.Style := [fsBold];
    coinShift := 3;
    rectCoin := Rect(p_Left + coinShift, p_Top + coinShift, p_Left + coinShift + 64, p_Top + coinShift + 64);aus := GetAchstatus(AchID);
    TextLeft := rectCoin.Right + 20;
    TextRight := rectPI.Left - 20;
    TextWidth := TextRight - TextLeft + 1;

    if (Ach.ID = AchIDChoosen) and (GroupIDChoosen <> -1) then begin
      BorderWidth := 3;
      clBorder := clBlack;
    end else begin
      BorderWidth := 2;
      clBorder := RGB(64, 64, 64);
    end;
    CornerShift := 4;

    if aus = ausDisabled then NameStyle := []
    else NameStyle := [fsBold];

    if aus = ausFinished then clName := RGB(0,0,160)
    else if aus = ausDisabled then clName := RGB(150, 150, 150)
    else clName := clBlack;

    case aus of
      ausFinished: clMain := RGB(120, 230, 120);
      ausDisabled: clMain := RGB(120, 120, 120);
      ausNotStarted: clMain := RGB(200, 200, 200);
      ausInProgress: clMain := RGB(228, 228, 154);
    end;

    PiOptions := TProgressIndicatorOptions.Create;
    PiOptions.GreenColor := clPiGreen;
    PiOptions.EmptyColor := clMain;
    PiOptions.TextColor := clBlack;
    PiOptions.EdgeColor := clGray;
    PiOptions.BackgroundColor := clMain;
    PiOptions.CornerShift := 3;
  end;
  //********************************************************************************************
  procedure DrawCoin;
  var
    index, size: integer;
    color: TColor;
    style: TFontStyles;
    oldName: string;
  begin
    case aus of
      ausDisabled:
        begin
          index := 2;
          color := RGB(200, 200, 200);
          style := [];
        end;
      ausFinished:
        begin
          index := 0;
          color := RGB(0,0,160); //clGreen; //RGB(230, 27, 11);
          style := [fsBold];
        end
    else
      begin
        index := 1;
        color := clBlack;
        style := [fsBold];
      end;
    end;

    ilCoins.Draw(cnv, rectCoin.Left, rectCoin.Top, index);
    oldName := cnv.Font.Name;
    cnv.Font.Name := 'Arial Black';
    if ach.Score < 10 then size := 28
    else if ach.Score < 100 then size := 22
    else size := 18;

    TextOutCenter(cnv, rectCoin, IntToStr(ach.Score), color, size, style);
    cnv.Font.Name := oldName;
  end;
  //*****************************************************************************
  procedure DrawProgressInfo;
  var
    vBottom: integer;
  begin
    if aus = ausDisabled then
      TextOutCenter(cnv, rectPI, 'Disabled', clBlack, 12, [])
    else if aus = ausFinished then begin
      TextOutMultiline(cnv, rectPI.Left, rectPI.Right, rectPI.Top, 4,
        'Achieved on ', clName, 12, [fsBold], vBottom, true);
      TextOutMultiline(cnv, rectPI.Left, rectPI.Right, vBottom, 4,
        Date2Str(AchieveDate), clName, 12, [fsBold], vBottom, true);
    end else if aus = ausInProgress then begin
      DrawProgressIndicator(cnv, rectPI, '', Progress, Ach.MaxCount, PiOptions);
    end;
  end;
  //*****************************************************************************
  procedure CreateCornerBmp;
  begin
    bmpCorner := TBitMap.Create;
    bmpCorner.Width := rectMain.Right - rectMain.Left + 20;
    bmpCorner.Height := rectMain.Bottom - rectMain.Top + 20;  
    with bmpCorner.Canvas do begin
      Brush.Color := BackgroundColor;
      FillRect(Rect(0, 0, bmpCorner.Width, bmpCorner.Height));
    end;
    DrawFilledFrame(bmpCorner.Canvas, Rect(10, 10, 10 + rectMain.Right - rectMain.Left, 10 + rectMain.Bottom - rectMain.Top),
      clBorder, clMain, BorderWidth, CornerShift);
  end;
  //*****************************************************************************
  procedure FixCorners(R: TRect);
  begin
    cnv.CopyRect(Rect(R.Left, R.Top, R.Left + CornerShift, R.Top + CornerShift),
      bmpCorner.Canvas,
      Rect(10, 10, 10 + CornerShift, 10 + CornerShift));
    cnv.CopyRect(Rect(R.Left, R.Bottom - CornerShift, R.Left + CornerShift, R.Bottom),
      bmpCorner.Canvas,
      Rect(10, bmpCorner.Height - 10 - CornerShift, 10 + CornerShift, bmpCorner.Height - 10));
    cnv.CopyRect(Rect(R.Right - CornerShift, R.Top, R.Right, R.Top + CornerShift),
      bmpCorner.Canvas,
      Rect(bmpCorner.Width - 10 - CornerShift, 10, bmpCorner.Width - 10, 10 + CornerShift));
    cnv.CopyRect(Rect(R.Right - CornerShift, R.Bottom - CornerShift, R.Right, R.Bottom),
      bmpCorner.Canvas,
      Rect(bmpCorner.Width - 10 - CornerShift, bmpCorner.Height - 10 - CornerShift,
        bmpCorner.Width - 10, bmpCorner.Height - 10));
  end;
  //*****************************************************************************
  procedure AddBaseDrawButton(R: TRect; AchID: integer);
  var
    Btn: TCLBaseDrawButton;
  begin
    Btn := TCLBaseDrawButton.Create;
    Btn.R := R;
    Btn.Tag := AchID;
    Btn.CanBePressed := true;
    Btn.MouseRespond := false;
    Btn.ButtonType := 1;
    Buttons.Add(btn);
  end;
  //*****************************************************************************
  procedure DrawAddInfo;
  var
    i, n, PiWidth, MaxCount: integer;
    AUI: TCLAchUserInfo;
    s: string;
  begin
    if AU = nil then exit;
    PiWidth := 0;
    for i := 0 to AU.InfoList.Count - 1 do begin
      AUI := AU.InfoList[i];
      if AUI.Progress <> - 1 then begin
        if AUI.MaxCount = -1 then MaxCount := Ach.MaxCountOne
        else MaxCount := AUI.MaxCount;

        s := Format('%s   %d / %d', [AUI.Text, AUI.Progress, MaxCount]);
        n := CLLib.TextWidth(cnv, s, PiOptions.FontSize, PiOptions.FontStyle);
        if n > PiWidth then PiWidth := n;
      end;
    end;
    if PiWidth < 250 then PiWidth := 250;
    if PiWidth > TextRight - TextLeft then
      PiWidth := TextRight - TextLeft;

    if (AU <> nil) and (aus = ausInProgress) then
      for i := 0 to AU.InfoList.Count - 1 do begin
        AUI := AU.InfoList[i];

        if AUI.MaxCount = -1 then MaxCount := Ach.MaxCountOne
        else MaxCount := AUI.MaxCount;

        if AUI.Progress = -1 then
          TextOutMultiLine(cnv, TextLeft, TextRight, pp_Height, 4, AUI.ScreenText, clGray, 10, [fsBold], pp_Height)
        else begin
          PiOptions.FontSize := 10;
          PiOptions.FontStyle := [fsBold];
          PiOptions.TextColor := clBlack;
          DrawProgressIndicator(cnv, Rect(TextLeft, pp_Height, TextLeft + PiWidth, pp_Height + 26),
            AUI.Text, AUI.Progress, MaxCount, PiOptions);
          pp_Height := pp_Height + 30;
        end;
      end;
  end;
  //*****************************************************************************

begin
  InitVars;

  cnv.Font.Name := 'Comic Sans MS';

  cnv.Brush.Color := clMain;
  cnv.Pen.Color := clMain;
  cnv.FillRect(Rect(p_Left, p_Top, p_Right, Self.Height));

  DrawCoin;

  TextOutMultiline(cnv, TextLeft, TextRight, p_Top + 10, 4, Ach.Name, clName, 12, NameStyle, pp_Height);
  Desc := Ach.Description;
  if (Ach.ID <> AchIDChoosen) and CurAchUserList.InfoExists(Ach.ID) then Desc := Desc + ' ... >>';
  TextOutMultiline(cnv, TextLeft, TextRight, pp_Height, 4, Desc, clName, 10, [], pp_Height);
  if p_Details then DrawAddInfo;

  pp_Height := pp_Height + 10;

  if rectCoin.Bottom + coinShift > pp_Height then pp_Height := rectCoin.Bottom + coinShift;

  DrawProgressInfo;

  rectMain := Rect(p_Left, p_Top, p_Right, pp_Height);
  CreateCornerBmp;
  DrawFrame(cnv, rectMain, clBorder, BorderWidth, CornerShift);
  FixCorners(rectMain);
  if GroupIDChoosen > 0 then AddBaseDrawButton(rectMain, Ach.ID);

  cnv.Brush.Color := BackgroundColor;
  cnv.Pen.Color := BackgroundColor;

  if Ach.ID = AchIDChoosen then n := 1
  else n := 0;

  cnv.FillRect(Rect(p_Left, pp_Height + n, p_Right, Self.Height));

  pp_Height := pp_Height + 4;

  bmpCorner.Free;
  PiOptions.Free;

  //cnv.FrameRect(Rect(p_Left, p_Top, p_Right, pp_Height));
end;
//==============================================================================================
procedure TfCLAchList.DrawStatisticsPage(cnv: TCanvas; X, Y: integer;
  var pp_FullWidth, pp_FullHeight: integer);
var
  CurY, StatShift, StatHeight, StatHalfWidth, Column1Left, Column2Left, ColumnCenterLeft: integer;
  l, i, StatVerShift: integer;
  R: TRect;
  PiOptions: TProgressIndicatorOptions;
  //********************************************************************************************
  procedure InitVars;
  begin
    StatShift := 10;
    cnv.Font.Name := 'Comic Sans MS';
    cnv.Font.Size := 14;
    cnv.Font.Style := [fsBold];
    StatHeight := cnv.TextHeight('0') + 4;
    StatVerShift := 12;
    CurY := StatVerShift - Y;

    PiOptions := TProgressIndicatorOptions.Create;
    PiOptions.EdgeColor := clGray;
    PiOptions.TextColor := clBlack;
    PiOptions.GreenColor := RGB(120, 230, 120);
    PiOptions.EmptyColor := RGB(200, 200, 200);
    PiOptions.ShadowColor := clGray;
    PiOptions.BackgroundColor := BackgroundColor;
    PiOptions.ShadowShift := 5;
    PiOptions.CornerShift := 3;
  end;
  //********************************************************************************************
  procedure DrawScore;
  var
    R: TRect;
    h, w, l, size: integer;
    oldName, sScore: string;
  begin
    oldName := cnv.Font.Name;
    size := 32;
    cnv.Font.Name := 'Arial Black';
    cnv.Font.Size := size;
    cnv.Font.Style := [fsBold];

    sScore := IntToStr(CurAchUserList.Score);
    h := ilCoins.Height + 6;
    w := ilCoins.Width + 8 + cnv.TextWidth(sScore) + 8;
    l := (Width - sbVer.Width - w) div 2;
    R := Rect(l, CurY, l + w, CurY + h);
    DrawFilledFrame(cnv, IncRect(R, 4, 4), clGray, clGray, 1, 6);
    DrawFilledFrame(cnv, R, clGray, RGB(120, 230, 120), 1, 6);
    ilCoins.Draw(cnv, R.Left + 4, R.Top + 4, 0);

    TextOut(cnv, R.Left + 72, R.Top + 4, sScore, RGB(0,0,160), size, [fsBold]);
    cnv.Font.Name := oldName;

    CurY := CurY + h + 10;
  end;
  //********************************************************************************************
  procedure DrawNonActiveAchievements;
  var
    R: TRect;
    h, w, l, size: integer;
    msg: string;
  begin
    w := 260;
    l := (Width - sbVer.Width - w) div 2;
    msg := 'You membership has ended.\nYou cannot obtain new achievements.';
    h := TextHeightMultiLine(cnv, w, 0, msg, clRed, 10, [fsBold]) + 8;
    R := Rect(l, CurY, l + w, CurY + h);
    DrawFilledFrame(cnv, IncRect(R, 4, 4), clGray, clGray, 1, 6);
    DrawFilledFrame(cnv, R, clGray, fGL.DefaultBackgroundColor, 1, 6);
    TextOutMultiLine(cnv, l, l + w, CurY + 4, 0, msg, clRed, 10, [fsBold], CurY, true);
    CurY := CurY + 16;
  end;
  //********************************************************************************************
procedure DrawStatistics;
  var
    i: integer;
    R: TRect;
    col: TColor;
  begin
    CurY := CurY + StatShift;
    R := Rect(StatShift, CurY, Self.Width - sbVer.Width - StatShift, CurY + StatHeight);

    if CurAchUserList.StatProgress[0] > 0 then PiOptions.EmptyColor := RGB(228, 228, 154)
    else PiOptions.EmptyColor := RGB(200, 200, 200);

    DrawProgressIndicator(cnv, R, CurAchUserList.StatName[0], CurAchUserList.StatProgress[0],
      CurAchUserList.StatMaxcount[0], PiOptions);
    CurY := CurY + StatHeight + StatShift;

    StatHalfWidth := (Width - sbVer.Width - StatShift * 3) div 2;
    Column1Left := StatShift;
    Column2Left := StatShift * 2 + StatHalfWidth;
    ColumnCenterLeft := (Width - sbVer.Width - StatHalfWidth) div 2;

    for i := 1 to CurAchUserList.StatCount - 1 do begin
      if i mod 2 = 1 then
        if i = CurAchUserList.StatCount - 1 then l := ColumnCenterLeft
        else l := Column1Left
      else l := Column2Left;

      if CurAchUserList.StatProgress[i] > 0 then PiOptions.EmptyColor := RGB(228, 228, 154)
      else PiOptions.EmptyColor := RGB(200, 200, 200);

      R := Rect(l, CurY, l + StatHalfWidth, CurY + StatHeight);
      DrawProgressIndicator(cnv, R, CurAchUserList.StatName[i], CurAchUserList.StatProgress[i],
        CurAchUserList.StatMaxcount[i], PiOptions);

      AddBaseDrawButton(R, BTN_GROUP, CurAchUserList.StatGroupID[i], true, false);
      if (i mod 2 = 0) or (i = CurAchUserList.StatCount - 1) then
        CurY := CurY + StatHeight + StatVerShift;
    end;
    PiOptions.Free;
  end;
  //********************************************************************************************
  procedure DrawRecent;
  var
    w, h, l, i, AchID: integer;
    R: TRect;
    text: string;
  begin
    if CurAchUserList.RecentCount = 0 then exit;
    cnv.Brush.Color := clGray;
    CurY := CurY + 20;

    text := 'Recent 5 Achievements';
    GetTextParams(cnv, text, 12, [fsBold], w, h);
    w := w + 100;
    if w > Width - sbVer.Width then
      w := Width - sbVer.Width;
    h := h + 4;
    l := (Width - sbVer.Width - w) div 2;
    R := Rect(l, CurY, l + w, CurY + h);

    DrawFilledFrame(cnv, IncRect(R, 4, 4), clGray, clGray, 1, 4);
    DrawFilledFrame(cnv, R, clGray, RGB(120, 230, 120), 1, 4);
    TextOutCenter(cnv, R, text, RGB(0,0,160), 12, [fsBold]);
    CurY := CurY + h + StatShift;

    for i := 0 to CurAchUserList.RecentCount - 1 do begin
      AchID := CurAchUserList.RecentAchID[i];
      DrawAchievement(cnv, AchID, StatShift, Width - sbVer.Width - StatShift, CurY, false, CurY);
    end;
  end;
  //********************************************************************************************
  procedure DrawTop100Button;
  var
    R: TRect;
  begin
    R := Rect(10, 10 - Y, 120, 10 - Y + 40);
    DrawFilledFrame(cnv, IncRect(R, 4, 4), clGray, clGray, 1, 3);
    DrawFilledFrame(cnv, R, clBlack, fGL.DefaultBackgroundColor, 2, 3);
    TextOutCenter(cnv, R, 'TOP 100', RGB(0,0,160), 16, [fsBold]);
    AddBaseDrawButton(R, BTN_TOP100, 0, true, false);
  end;
  //********************************************************************************************
begin
  if not Assigned(CurAchUserList) then exit;
  Buttons.Clear;
  InitVars;
  if not fCLSocket.Rights.AchievementsActive then
    DrawNonActiveAchievements;
  DrawScore;
  DrawStatistics;
  DrawRecent;
  DrawTop100Button;
  pp_FullHeight := CurY + Y;
end;
//==============================================================================================
function TfCLAchList.GetAchStatus(AchID: integer): TAchUserStatus;
begin
  if CurAchUserList <> nil then result := CurAchUserList.GetStatus(AchID)
  else result := ausFinished;
end;
//==============================================================================================
function TfCLAchList.GetBackgroundColor: TColor;
begin
  result := fGL.DefaultBackgroundColor;
  //result := RGB(240,240,240);
  exit;
  if Assigned(Parent) and (Parent is TForm) then result := TForm(Parent).Color
  else result := fGL.DefaultBackgroundColor;
end;
//==============================================================================================
function TfCLAchList.GetCurAchUserList: TCLAchUserList;
begin
  if Assigned(Parent) and (Parent is TfCLAchievements) then
    result := TfCLAchievements(Parent).CurAchUserList
  else
    result := MyAchUserList;
end;
//==============================================================================================
procedure TfCLAchList.OnBaseDrawButtonCilck(btn: TCLBaseDrawButton);
begin
  case btn.ButtonType of
    BTN_CLOSE: ModalResult := mrOk;
    BTN_ACHIEVEMENT:
      begin
        if btn.Tag <> AchIDChoosen then AchIDChoosen := btn.Tag
        else AchIDChoosen := -1;
        Repaint;
      end;
    BTN_GROUP:
      if Assigned(Parent) and (Parent is TfCLAchievements) then
        TfCLAchievements(Parent).OnGroupIDChange(btn.Tag);
    BTN_TOP100:
      ShellExecute(Handle, 'open', PChar('http://www.infiniachess.com/achievements-top.aspx'), '', '', SW_SHOWNORMAL);
  end;
end;
//==============================================================================================
procedure TfCLAchList.VirtualDraw(cnv: TCanvas; X, Y: integer; var pp_FullWidth, pp_FullHeight: integer);
var
  i, CurY: integer;
begin
  if AchList.Count = 0 then cnv.Brush.Color := Self.Color
  else cnv.Brush.Color := BackgroundColor;
  
  cnv.FillRect(ClientRect);
  if AchList.Count = 0 then exit;

  if GroupIDChoosen = -1 then begin
    DrawCongratulations(cnv, X, Y, pp_FullWidth, pp_FullHeight)
  end else if GroupIDChoosen = 0 then
    DrawStatisticsPage(cnv, X, Y, pp_FullWidth, pp_FullHeight)
  else begin
    CurY := 4 - Y;

    Buttons.Clear;

    for i := 0 to AchList.Count - 1 do begin
      if AchList[i].GroupID = GroupIDChoosen then
        DrawAchievement(cnv, AchList[i].ID, 4, Width - sbVer.Width - 4, CurY, AchList[i].ID = AchIDChoosen, CurY);
    end;
    pp_FullHeight := CurY + Y;
    pp_FullWidth := Width;
  end;
end;
//==============================================================================================
procedure TfCLAchList.FormCreate(Sender: TObject);
begin
  inherited;
  VerScrollBarAlwaysVisible := true;
end;
//==============================================================================================
procedure TfCLAchList.SetCongratulationParams(p_AchID: integer);
var
  R: TRect;
  w, h: integer;
begin
  GroupIDChoosen := -1;
  AchIDChoosen := p_AchID;
  Visible := false;
  VerScrollBarAlwaysVisible := false;
  Width := 600;
  DrawCongratulations(Canvas, 0, -1000, w, h);
  Height := h;
end;
//==============================================================================================
procedure TfCLAchList.DrawCongratulations(cnv: TCanvas; X, Y: integer; var pp_FullWidth, pp_FullHeight: integer);
var
  R: TRect;
  CurY, w, n, h, textShift: integer;
  text: string;
  //********************************************************************************************
  procedure DrawCross;
  begin
    cnv.Pen.Color := RGB(60,60,60);
    cnv.Pen.Width := 1;
    w := 20;
    R := Rect(ClientRect.Right - 8 - w, ClientRect.Top + 8, ClientRect.Right - 8, ClientRect.Top + 8 + w);

    cnv.Brush.Color := clGray;
    cnv.FillRect(IncRect(R, 2, 2));
    cnv.Brush.Color := BackgroundColor;
    cnv.Rectangle(R);

    cnv.Pen.Width := 2;
    n := 5;
    cnv.MoveTo(R.Left + n, R.Top + n);
    cnv.LineTo(R.Right - n, R.Bottom - n);
    cnv.MoveTo(R.Right - n, R.Top + n);
    cnv.LineTo(R.Left + n, R.Bottom - n);
    cnv.Pen.Width := 1;

    AddBaseDrawButton(R, BTN_CLOSE, 1, true, true);
  end;
  //********************************************************************************************
begin
  cnv.Brush.Color := BackgroundColor; //RGB(220,220,220);
  cnv.FillRect(ClientRect);
  Buttons.Clear;

  cnv.Font.Name := 'Arial';

  CurY := 14 - Y;
  textShift := 20;

  text := 'Congratulations! You have completed new achievement!';
  TextOutMultiline(cnv, textShift + 2, Width - textShift + 2, CurY + 2, 0, text,
    clLtGray, 14, [fsBold], h, true);
  TextOutMultiline(cnv, textShift, Width - textShift, CurY, 0, text,
    RGB(0,0,160), 14, [fsBold], CurY, true);

  DrawAchievement(cnv, AchIDChoosen, 8, Width - 8, CurY + 12, false, CurY);
  DrawCross;

  text := 'You score is ' + IntToStr(CurAchUserList.Score);
  TextOutMultiline(cnv, textShift + 2, Width - textShift + 2, CurY + 2, 0, text,
    clLtGray, 14, [fsBold], h, true);
  TextOutMultiline(cnv, textShift, Width - textShift, CurY, 0, text,
    RGB(0,0,160), 14, [fsBold], CurY, true);

  DrawFrame(cnv, Rect(0, 0, Width - 1, Height - 1), clGray, 1, 0);
  DrawFrame(cnv, Rect(2, 2, Width - 3, Height - 3), clGray, 1, 0);

  pp_FullWidth := Width;
  pp_FullHeight := CurY + Y + 10;
end;
//==============================================================================================
end.

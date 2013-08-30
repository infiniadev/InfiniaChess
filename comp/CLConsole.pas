{*******************************************************}
{                                                       }
{       ChessLink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLConsole;

interface

uses
  classes, contnrs, controls, graphics, messages, windows, sysutils;

type
  TLineTrait = (ltShout, ltNotifyArrived, ltNotifyDeparted, ltTellLogin,
    ltTellRoom, ltSays, ltKibitz, ltWhisper, ltMessage, ltServerMsgNormal,
    ltServerMsgWarning, ltServerMsgError, ltUser);

  TLine = class(TObject)
    private
      FLine: string;
      FLineTrait: TLineTrait;
      FMarkerCount: Integer;
      FColor: TColor;
    public
      procedure Assign(const Source: TLine);
  end;

  TLink = class(TObject)
    FLink: string;
    FLinkRect: TRect;
  end;

  TFilter = class(TObject)
    FFilterID: Integer;
    FLines: TList;

    constructor Create(const FilterID: Integer);
    destructor Destroy; override;
  end;

  TFontTrait = class(TObject)
  private
    { Private declarations }
    FBackColor: TColor;
    FForeColor: TColor;
    FFontStyle: TFontStyles;

  public
    { Public declarations }
    procedure Assign(Source: TFontTrait);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);

  published
    { Published declarations }
    property BackColor: TColor read FBackColor write FBackColor;
    property ForeColor: TColor read FForeColor write FForeColor;
    property FontStyle: TFontStyles read FFontStyle write FFontStyle;
  end;

  TBorderStyle = (bsNone, bsSingle);

  TCLConsole = class(TCustomControl)
  private
    { Private declarations }
    FBorderStyle: TBorderStyle;
    FBuffer: Integer;
    FCharHeight: Integer;
    FCharWidth: Integer;
    FCustomCursor: TCursor;
    FFilter: TFilter; { Current TFilter }
    FFilters: TObjectList; { List of TFilters }
    FFontTraits: array[0..12] of TFontTrait;
    FLines: TObjectList; { Measured TLines of the current TFilter }
    FLink: TLink; { Active link }
    FLinks: TObjectList; { List of TLinks }
    FModified: Boolean; { True if lines added were to the current TFilter }
    FUpdating: Boolean;
    FWidth: Integer; { Holder to tell if Width had changed }
    FWordWrap: Boolean;
    FUserColor: Boolean;

    procedure AddFLines(Index: Integer);
    procedure AddLink(var Link: string; LinkRect: TRect);
    procedure AddMarkers(var Line: TLine);
    procedure CMColorChanged(var Msg: TMessage); message CM_ColorChanged;
    procedure CMFontChanged(var Msg: TWmNoParams); message CM_FontChanged;
    function GetFilter(const FilterID: Integer): TFilter;
    function GetFilterID: Integer;
    function GetHyperlink: string;
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetFilterID(const FilterID: Integer);
    procedure SetFontTrait(Index: TLineTrait; Value: TFontTrait);
    procedure WMEraseBkGnd(var Msg: TMessage); message WM_ERASEBKGND;
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Msg: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;

  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure Resize; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddLine(FilterID: Integer; Line: string; LineTrait: TLineTrait; Color: TColor = -1);
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure FreeFilterID(const FilterID: Integer);
    procedure DrawText;
    procedure ClearText;
    function GetText: string;
    function TextWidth(Str: string): integer;
    function TextHeight(Str: string): integer;

    property FilterID: Integer read GetFilterID write SetFilterID;
    property FontTraits[Index: TLineTrait]: TFontTrait write SetFontTrait;
    property Hyperlink: string read GetHyperlink;
    property UserColor: Boolean read FUserColor write FUserColor;

  published
    { Published declarations }
    property Align;
    property Anchors;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
    property Buffer: Integer read FBuffer write FBuffer;
    property Color;
    property CustomCursor: TCursor read FCustomCursor write FCustomCursor;
    property DoubleBuffered;
    property Font;
    property PopupMenu;
    property TabOrder;
    property TabStop;
    property WordWrap: Boolean read FWordWrap write FWordWrap default True;
    property OnClick;
    property OnDblClick;
    property OnEnter;
    property OnKeyPress;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

{ TLine }
procedure TLine.Assign(const Source: TLine);
begin
  FLine := Source.FLine;
  FLineTrait := Source.FLineTrait;
  FMarkerCount := Source.FMarkerCount;
  FColor := Source.FColor;
end;
//______________________________________________________________________________
{ TFilter }
//______________________________________________________________________________
constructor TFilter.Create(const FilterID: Integer);
begin
  FFilterID := FilterID;
  FLines := TList.Create;
end;
//______________________________________________________________________________
destructor TFilter.Destroy;
begin
  while FLines.Count > 0 do
    begin
      TLine(FLines[0]).Free;
      FLines.Delete(0);
    end;
  inherited;
end;

{ TFontTrait }
//______________________________________________________________________________
procedure TFontTrait.Assign(Source: TFontTrait);
begin
  BackColor := Source.BackColor;
  ForeColor := Source.ForeColor;
  FontStyle := Source.FontStyle;
end;
//______________________________________________________________________________
procedure TFontTrait.LoadFromStream(Stream: TStream);
var
  B: Boolean;
  L: TColor;
begin
  with Stream do
    begin
      FontStyle := [];
      Read(L, SizeOf(L));
      BackColor := L;
      Read(L, SizeOf(L));
      ForeColor := L;
      Read(B, SizeOf(B));
      if B then FontStyle := FontStyle + [fsBold];
      Read(B, SizeOf(B));
      if B then FontStyle := FontStyle + [fsItalic];
      Read(B, SizeOf(B));
      //if B then FontStyle := FontStyle + [fsUnderline];
      Read(B, SizeOf(B));
      //if B then FontStyle := FontStyle + [fsStrikeout];
    end;
end;
//______________________________________________________________________________
procedure TFontTrait.SaveToStream(Stream: TStream);
var
  B: Boolean;
begin
  with Stream do
    begin
      Write(BackColor, SizeOf(BackColor));
      Write(ForeColor, SizeOf(ForeColor));
      B := fsBold in FontStyle;
      Write(B, SizeOf(B));
      B := fsItalic in FontStyle;
      Write(B, SizeOf(B));
      B := fsUnderline in FontStyle;
      Write(B, SizeOf(B));
      B := fsStrikeout in FontStyle;
      Write(B, SizeOf(B));
    end;
end;

{ TCLTerm }
//______________________________________________________________________________
procedure Register;
begin
  RegisterComponents('ChessLink', [TCLConsole]);
end;
//______________________________________________________________________________
constructor TCLConsole.Create(AOwner: TComponent);
var
  Index: Integer;
begin
  inherited Create(AOwner);
  FBuffer := 500;
  FCharHeight := 1;
  FFilter := nil;
  FFilters := TObjectList.Create;
  FLines := TObjectList.Create;
  FLink := nil;
  FLinks := TObjectList.Create;
  FModified := False;
  FUpdating := False;
  FWordWrap := True;

  for Index := 0 to High(FFontTraits) do
    begin
      FFontTraits[Index] := TFontTrait.Create;
      FFontTraits[Index].FBackColor := clWindowText;
      FFontTraits[Index].FForeColor := clWindow;
    end;
end;
//______________________________________________________________________________
destructor TCLConsole.Destroy;
var
  Index: Integer;
begin
  FFilters.Free;
  FLines.Clear;
  FLines.Free;
  FLinks.Free;
  for Index := 0 to High(FFontTraits) do FFontTraits[Index].Free;
  inherited;
end;
//______________________________________________________________________________
procedure TCLConsole.AddFLines(Index: Integer);
var
  Line: TLine;
  LineTrait: TLineTrait;
  Len, LastDelimiter, MarkerCount: Integer;
  Color: TColor;
  InLink: Boolean;
  LineSlice: string;
begin
  { Calculates the word wrap lengths for each line (or lines). Adds each string
    slice to FLines for speedy recall. Necessary to know page size. }

  { If -1, recalculate all lines for the current TFilter. }
  if Index = -1 then
    begin
      FLines.Clear;
      Index := 0;
    end;

  { Can't continue without a assigned Filter. }
  if FFilter = nil then Exit;

  { Iterate through the lines. }
  for Index := Index to FFilter.FLines.Count -1 do
    begin
      { Acquire the current line. }
      with TLine(FFilter.FLines[Index]) do
        begin
          LineSlice := FLine;
          LineTrait := FLineTrait;
          MarkerCount := FMarkerCount;
          Color := FColor;
        end;

      Len := Length(LineSlice);
      LastDelimiter := Len;

      { Start to measure the line. }
      while LineSlice <> '' do
        if ((LastDelimiter - MarkerCount) * FCharWidth <= ClientWidth)
        or (Len = 0) or not FWordWrap then
          begin
            { The string slice fits, so add it to the FLines. }
            Line := TLine.Create;
            Line.FLine := Copy(LineSlice, 1, LastDelimiter);
            Line.FLineTrait := LineTrait;
            Line.FColor := Color;
            FLines.Add(Line);

            { Reduce the line by the amount stored off. }
            Delete(LineSlice, 1, LastDelimiter);
            Len := Length(LineSlice);
            LastDelimiter := Len;
          end
        else
          begin
            { String segmet does not fit so working backwards attempt to find
              a delimiter (space, hyperlink marker) and measure again. }
            InLink := False;
            while Len > 0 do
              begin
                Dec(Len);
                case LineSlice[Len] of
                  #14:
                    begin
                      if Len -1  > 1 then LastDelimiter := Len - 1;
                      Dec(MarkerCount);
                      Break;
                    end;
                  #15:
                    begin
                      InLink := True;
                      Dec(MarkerCount);
                    end;
                  #32:
                    if InLink then
                      Continue
                    else
                      begin
                        LastDelimiter := Len;
                        Break;
                      end;
                end;
              end;
          end;
    end;
end;
//______________________________________________________________________________
procedure TCLConsole.AddLink(var Link: string; LinkRect: TRect);
var
  NewLink: TLink;
begin
  { Add a hyperlink command and the Rect to a list. See MouseMove. }
  NewLink := TLink.Create;
  NewLink.FLink := Link;
  NewLink.FLinkRect := LinkRect;
  FLinks.Add(NewLink);
end;
//______________________________________________________________________________
procedure TCLConsole.AddMarkers(var Line: TLine);
var
  Pos1, Pos2, OffSet: Integer;
  LineSlice: string;
begin
  { Search incoming string for double quotes or urls and place markers around
    them. See DrawText. }

  Line.FMarkerCount := 0;

  { Search for quoted strings. Replace quotes with hyperlink markers. }
  OffSet := 0;
  LineSlice := Line.FLine;
  repeat
    { #34 = quote character }
    Pos1 := Pos(#34, LineSlice);
    if Pos1 > 0 then
      begin
        Delete(LineSlice, 1, Pos1);
        OffSet := OffSet + Pos1;
        Pos1 := 1;
        Pos2 := Pos(#34, LineSlice);
        if Pos2 > 0 then
          begin
            Line.FLine[Pos1 + Offset -1] := #14;
            Line.FLine[Pos2 + Offset] := #15;
            OffSet := OffSet + Pos2;
            Inc(Line.FMarkerCount, 2);
            Delete(LineSlice, 1, Pos2);
          end
        else
          LineSlice := '';
      end
    else
      LineSlice := '';
  until LineSlice = '';

  { Find find url's }
  OffSet := 0;
  LineSlice := LowerCase(Line.FLine);
  repeat
    Pos1 := Pos('http://', LineSlice);
    Pos2 := Pos('www.', LineSlice);
    { Determine which came first, assign it to Pos1. }
    if ((Pos2 > 0) and (Pos1 = 0))
    or ((Pos2 > 0) and (Pos2 < Pos1)) then Pos1 := Pos2;

    if Pos1 > 0 then
      begin
        Pos2 := Pos(#14, LineSlice);
        if (Pos2 > 0) and (Pos2 < Pos1) then
          begin
            { Reduce line by previous markers to ensure this url is not inside
              an existing marker. }
            Pos2 := Pos(#15, LineSlice);
            Delete(LineSlice, 1, Pos2);
            OffSet := OffSet + Pos2;
          end
        else
          begin
            Delete(LineSlice, 1, Pos1 -1);
            OffSet := OffSet + Pos1 -1;
            { Find an ending delimiter. }
            Pos1 := Pos(#32, LineSlice);
            Pos2 := Pos(#15, LineSlice);
            { Calculate the first ending delimiter. }
            if ((Pos2 > 0) and (Pos1 = 0))
            or ((Pos2 < Pos1) and (Pos2 > 0)) then Pos1 := Pos2;

            if Pos1 = 0 then Pos1 := Length(LineSlice) + 1;

            Insert(#14, Line.FLine, 1 + OffSet);
            Insert(#15, Line.FLine, Pos1 + OffSet + 1);
            Inc(Line.FMarkerCount, 2);
            OffSet := OffSet + Pos1 + 2;
            Delete(LineSlice, 1, Pos1)
          end;
      end
    else
      LineSlice := '';
  until LineSlice = '';
end;
//______________________________________________________________________________
procedure TCLConsole.CMColorChanged(var Msg: TMessage);
begin
  Canvas.Brush.Color := Self.Color;
  Invalidate;
end;
//______________________________________________________________________________
procedure TCLConsole.CMFontChanged(var Msg: TWmNoParams);
begin
  Canvas.Font.Assign(Font);
  Canvas.Font.Style := [fsBold..fsUnderline];
  FCharHeight := Canvas.TextHeight('Äg') + 1;
  FCharWidth := Canvas.TextWidth('H');
  AddFLines(-1);
  Resize;
  Invalidate;
end;
//______________________________________________________________________________
procedure TCLConsole.DrawText;
var
  si: TScrollInfo;
  Line: TLine;
  Index, Link, Y: Integer;
  LineDraw, LineSlice: string;
begin
  { Calculate the FLines index position based on the thumb position. }
  si.cbSize := Sizeof(TscrollInfo);
  si.fMask := SIF_ALL;
  GetScrollInfo(Handle, SB_VERT, si);
  Index := si.nPos + si.nPage -1;
  if Index >= (FLines.Count) then Index := (FLines.Count -1);

  { Draws from the bottom up. Find and go to the starting position. }
  Y := ClientHeight - FCharHeight;
  Canvas.MoveTo(0, Y);

  { Clear the link Rects. }
  FLinks.Clear;

  { Start to draw text. }
  while (Y > 0) and (Index > -1) do
    begin
      Line := TLine(FLines[Index]);
      LineSlice := Line.FLine;

      Canvas.Brush.Color := FFontTraits[Ord(Line.FLineTrait)].BackColor;
      if not FUserColor or (Line.FColor = -1) or (Line.FColor = FFontTraits[Ord(Line.FLineTrait)].BackColor) then
        Canvas.Font.Color := FFontTraits[Ord(Line.FLineTrait)].ForeColor
      else
        Canvas.Font.Color := Line.FColor;
      Canvas.Font.Style := FFontTraits[Ord(Line.FLineTrait)].FontStyle;

      { Clear the the line }
      with Canvas do
        FillRect(Rect(0, PenPos.Y, ClientWidth, PenPos.Y + FCharHeight));

      repeat
        { Attempt to find a hyperlink marker. }
        Link := Pos(#14, LineSlice);
        if Link = 1 then
          begin
            { Marker found at the first position. Slice the string to contain
              only the hyperlink text. }
            Link := Pos(#15, LineSlice);
            LineDraw := Copy(LineSlice, 1, Link);

            { Remove the markers before drawing or adding to Links list. }
            Delete(LineDraw, 1, 1);
            Link := Length(LineDraw);
            Delete(LineDraw, Link, 1);
            Dec(Link); { now equals length of link minus control characters. }

            { Reduce the LineSlice by the length of what's begin drawn }
            Delete(LineSlice, 1, Link + 2);

            { Add the drawing rect to the Links list. }
            with Canvas do AddLink(LineDraw, Rect(PenPos.x, PenPos.Y,
              PenPos.x + Link * FCharWidth, PenPos.Y + FCharHeight));

            { Assign the Hyperlink underline style. }
            Canvas.Font.Style :=
              FFontTraits[Ord(Line.FLineTrait)].FontStyle + [fsUnderline];
          end
        else
          begin
            if Link > 1 then
              { Marker found, but non marker must be drawn first. }
              LineDraw := Copy(LineSlice, 1, Link -1)
            else
              { No markers. Draw the entire line. }
              LineDraw := LineSlice;

            { Reduce the LineSlice by the length of what's begin drawn }
            Link := Length(LineDraw);
            Delete(LineSlice, 1, Link);

            { Reset the font }
            Canvas.Font.Style :=
              FFontTraits[Ord(Line.FLineTrait)].FontStyle - [fsUnderline];
          end;

        { Draw the text }
        with Canvas do TextOut(PenPos.x+4, PenPos.Y, LineDraw);
      until LineSlice = '';

      { Move to the starting position for the next line }
      with Canvas do
        MoveTo(0, PenPos.Y - FCharHeight);

      { Done drawing when we've moved off screen. }
      Dec(Index);
      Dec(Y, FCharHeight);
    end;

  { After all lines have been drawn, if theres space left at the top of the
    screen, fill it in. }
  Inc(Y, FCharHeight);
  if Y > 0 then
    begin
      Canvas.Brush.Color := Self.Color;
      Canvas.FillRect(Rect(0, 0, ClientWidth, Y));
    end;
end;
//______________________________________________________________________________
function TCLConsole.GetFilter(const FilterID: Integer): TFilter;
var
  Index: Integer;
begin
  { Return a TFilter from ID. Create one if non exists for the ID. }
  Result := nil;
  for Index := 0 to FFilters.Count -1 do
    begin
      Result := TFilter(FFilters[Index]);
      if Result.FFilterID = FilterID then
        Break
      else
        Result := nil
    end;

  if Result = nil then
    begin
      Result := TFilter.Create(FilterID);
      FFilters.Add(Result);
    end;
end;
//______________________________________________________________________________
function TCLConsole.GetFilterID: Integer;
begin
  { Returns the FilterID of the current TFilter. }
  if FFilter <> nil then
    Result := TFilter(FFilter).FFilterID
  else
    Result := -1;
end;
//______________________________________________________________________________
function TCLConsole.GetHyperlink: string;
begin
  if FLink = nil then
    Result := ''
  else
    Result := FLink.FLink;
end;
//______________________________________________________________________________
procedure TCLConsole.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    RecreateWnd;
  end;
end;
//______________________________________________________________________________
procedure TCLConsole.SetFilterID(const FilterID: Integer);
begin
  { Change filters. Load Lines and redraw. }
  FFilter := GetFilter(FilterID);
  AddFLines(-1);
  Resize;
  Invalidate;
end;
//______________________________________________________________________________
procedure TCLConsole.SetFontTrait(Index: TLineTrait; Value: TFontTrait);
begin
  FFontTraits[Ord(Index)].Assign(Value);
end;
//______________________________________________________________________________
procedure TCLConsole.WMEraseBkGnd(var Msg: TMessage);
begin
  if FFilter = nil then
    inherited
  else
    Msg.Result := 1;
end;
//______________________________________________________________________________
procedure TCLConsole.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  Msg.Result := DLGC_WANTARROWS;
end;
//______________________________________________________________________________
procedure TCLConsole.WMMouseWheel(var Msg: TWMMouseWheel);
var
  TSMsg: TWMVScroll;
begin
  TSMsg.Msg := WM_VSCROLL;
  if Msg.WheelDelta > 0 then
    TSMsg.ScrollCode := SB_LINEUP
  else
    TSMsg.ScrollCode := SB_LINEDOWN;
  if GetAsyncKeyState(VK_CONTROL) <> 0 then
    begin
      if TSMsg.ScrollCode = SB_LINEUP then
        TSMsg.ScrollCode := SB_PAGEUP
      else
        TSMsg.ScrollCode := SB_PAGEDOWN;
    end;
  WMVScroll(TSMsg);
end;
//______________________________________________________________________________
procedure TCLConsole.WMVScroll(var Msg: TWMVScroll);
var
  si: TScrollInfo;
begin
  Msg.Result := 0;
  si.cbSize := Sizeof(TScrollInfo);
  si.fMask := SIF_ALL;
  GetScrollInfo(Handle, SB_VERT, si);
  si.fMask := SIF_POS;

  case Msg.ScrollCode of
    SB_TOP: si.nPos := si.nMin;
    SB_BOTTOM: si.nPos := si.nMax;
    SB_LINEUP: Dec(si.nPos);
    SB_LINEDOWN: Inc(si.nPos);
    SB_PAGEUP: Dec(si.nPos, si.nPage);
    SB_PAGEDOWN: Inc(si.nPos, si.nPage);
    SB_THUMBTRACK, SB_THUMBPOSITION: si.nPos := Msg.Pos;
    SB_ENDSCROLL: Exit;
  end;

  si.fMask:= SIF_POS;
  if si.nPos < si.nMin then si.nPos := si.nMin;
  if si.nPos > si.nMax then si.nPos := si.nMax;
  SetScrollInfo(Handle, SB_VERT, si, True);

  Invalidate;
end;
//______________________________________________________________________________
procedure TCLConsole.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    begin
      Style := Style or WS_VSCROLL and not WS_BORDER;
      if (FBorderStyle = bsSingle) then ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
end;
//______________________________________________________________________________
procedure TCLConsole.CreateWnd;
begin
  inherited;
  FWidth := ClientWidth;
  Perform(CM_FontChanged, 0, 0);
  Perform(CM_ColorChanged, 0, 0);
end;
//______________________________________________________________________________
procedure TCLConsole.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  { Ignoring shift state for arrow keys here for simplicities sake }
  case Key of
    VK_UP: Perform(WM_VSCROLL, SB_LINEUP, 0);
    VK_DOWN: Perform(WM_VSCROLL, SB_LINEDOWN, 0);
    VK_NEXT: Perform(WM_VSCROLL, SB_PAGEDOWN, 0);
    VK_PRIOR: Perform(WM_VSCROLL, SB_PAGEUP, 0);
    VK_HOME: Perform(WM_VSCROLL, SB_TOP, 0);
    VK_END: Perform(WM_VSCROLL, SB_BOTTOM, 0);
  end;
  Key := 0;
end;
//______________________________________________________________________________
procedure TCLConsole.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited;
  if (Button = mbLeft) and CanFocus and not Focused then SetFocus;
end;
//______________________________________________________________________________
procedure TCLConsole.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
begin
  inherited;
  { See if we're in a Rect that represents a link. }
  for Index := 0 to FLinks.Count -1 do
    begin
      FLink := TLink(FLinks[Index]);
      if PtInRect(FLink.FLinkRect, Point(X, Y)) then
        begin
          Cursor := FCustomCursor;
          Exit;
        end;
    end;
  Cursor := crDefault;
  FLink := nil;
end;
//______________________________________________________________________________
procedure TCLConsole.Paint;
begin
  if FFilter = nil then Exit;
  DrawText;
end;
//______________________________________________________________________________
procedure TCLConsole.Resize;
var
  si: TScrollInfo;
begin
  inherited;

  { If the ClientWidth changes re-calculate the word-wraps. }
  if FWidth <> ClientWidth then
    begin
      FWidth := ClientWidth;
      AddFLines(-1);
    end;

  { Recalculate the thumb size. }
  if (FFilter <> nil) and HandleAllocated then
    begin
      si.cbSize := Sizeof(TscrollInfo);
      si.fMask := SIF_ALL or SIF_DISABLENOSCROLL;
      GetScrollInfo(Handle, SB_VERT, si);
      if si.nPos + si.nPage > si.nMax then si.nPos := FLines.Count;
      si.nMin := 0;
      si.nMax := FLines.Count -1;
      si.nPage := ClientHeight div FCharHeight;
      SetScrollInfo(Handle, SB_VERT, si, True);
    end;
end;
//______________________________________________________________________________
procedure TCLConsole.AddLine(FilterID: Integer; Line: string;
  LineTrait: TLineTrait; Color: TColor = -1);
var
  Filter: TFilter;
  NewLine, CopyLine: TLine;
  Index: Integer;
begin
  NewLine := TLine.Create;
  NewLine.FLine := Line;
  NewLine.FLineTrait := LineTrait;
  NewLine.FColor := Color;

  AddMarkers(NewLine);

  Filter := nil;
  { -1 means add the line to all filters. }
  if FilterID = -1 then
    begin
      for Index := 0 to FFilters.Count -1 do
        begin
          CopyLine := TLine.Create;
          CopyLine.Assign(NewLine);
          Filter := TFilter(FFilters[Index]);
          Filter.FLines.Add(CopyLine);
          if Filter.FLines.Count > FBuffer then Filter.FLines.Delete(0);
        end;
      NewLine.Free;
    end
  else
    { Add the line to just the FilterID sent. }
    begin
      Filter := GetFilter(FilterID);
      Filter.FLines.Add(NewLine);
      if Filter.FLines.Count > FBuffer then Filter.FLines.Delete(0);
    end;

  FModified := (Filter = FFilter) or (FilterID = -1); { ??? and ThumbPosition at Max };
  if FModified then AddFLines(FFilter.FLines.Count -1);
  Resize;
  if FModified and not FUpdating then Invalidate;
end;
//______________________________________________________________________________
procedure TCLConsole.BeginUpdate;
begin
  FUpdating := True;
end;
//______________________________________________________________________________
procedure TCLConsole.EndUpdate;
begin
  FUpdating := False;
  if FModified then DrawText;
end;
//______________________________________________________________________________
procedure TCLConsole.FreeFilterID(const FilterID: Integer);
var
  Filter: TFilter;
begin
  Filter := GetFilter(FilterID);
  if Filter = FFilter then FFilter := nil;
  FFilters.Remove(Filter);
end;
//______________________________________________________________________________
procedure TCLConsole.ClearText;
var
  Filter: TFilter;
begin
  Filter := GetFilter(FilterId);
  if Filter=nil then exit;
  Filter.FLines.Clear;
  FModified := (Filter = FFilter) or (FilterID = -1);
  if FModified then AddFLines(FFilter.FLines.Count -1);
  Resize;
  if FModified and not FUpdating then Invalidate;
end;
//______________________________________________________________________________
function TCLConsole.GetText: string;
var
  Filter: TFilter;
  i: integer;
begin
  result:='';
  Filter := GetFilter(FilterId);
  if Filter=nil then exit;
  for i:=0 to Filter.FLines.Count-1 do
    result:=result+TLine(Filter.FLines[i]).FLine+#13#10;
end;
//______________________________________________________________________________
function TCLConsole.TextWidth(Str: string): integer;
begin
  result := Canvas.TextWidth(Str);
end;
//______________________________________________________________________________
function TCLConsole.TextHeight(Str: string): integer;
begin
  result := Canvas.TextHeight(Str);
end;
//______________________________________________________________________________
end.

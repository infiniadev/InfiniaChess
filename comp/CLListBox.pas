{*******************************************************}
{                                                       }
{       ChessLink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLListBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TCLListBox = class(TCustomListBox)
  private
    { Private declarations }
    FTextHeight: Integer;
    FSelectedFont: TFont;
    FSmallFontSize: integer;
    FLargeFontSize: integer;
    FDifferentFonts: Boolean;
    FCustomDraw: Boolean;
    FTextBuff: integer;
    FPlainText: Boolean;

    procedure SetSelectedFont(const Value: TFont);
    procedure CNDrawItem(var Msg: TWMDrawItem); message CN_DRAWITEM;
    //procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;

  protected
    { Protected declarations }
    procedure CreateWnd; override;

  public
    { Public declarations }
    constructor Create (AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Next;
    procedure Previous;

  published
    { Published declarations }
    property Align;
    property Anchors;
    property BorderStyle;
    property Color;
    property Enabled;
    property CustomDraw: Boolean read FCustomDraw write FCustomDraw;
    property DifferentFonts: Boolean read FDifferentFonts write FDifferentFonts default False;
    property Font;
    property PlainText: Boolean read FPlainText write FPlainText default false;
    property ItemHeight;
    property Items;
    property MultiSelect;
    property OnClick;
    property OnDrawItem;
    property OnKeyDown;
    property PopupMenu;
    property SelectedFont: TFont read FSelectedFont write SetSelectedFont;
    property SmallFontSize: integer read FSmallFontSize write FSmallFontSize default 8;
    property LargeFontSize: integer read FLargeFontSize write FLargeFontSize default 8;
    property Sorted;
    property Style;
    property TabOrder;
    property TextBuff: integer read FTextBuff write FTextBuff default 50;
    property Visible;

  end;

procedure Register;

implementation

//______________________________________________________________________________
procedure Register;
begin
  RegisterComponents('ChessLink', [TCLListBox]);
end;
//______________________________________________________________________________
procedure TCLListBox.SetSelectedFont(const Value: TFont);
begin
  FSelectedFont.Assign(Value);
end;
//______________________________________________________________________________
procedure TCLListBox.CNDrawItem(var Msg: TWMDrawItem);
var
  State: TOwnerDrawState;
  Index, h: Integer;
  Caption: string;
begin
  with Msg.DrawItemStruct^ do
    begin
      Index := Integer(itemID);
      if Index < 0 then Exit;
      Caption := Items[Index];

      State := TOwnerDrawState(LongRec(itemState).Lo);
      Canvas.Handle := hDC;

      { Bold if selected }
      if (Index >= 0) and (odSelected in State) and not FPlainText then
        Canvas.Font.Assign(SelectedFont)
      else
        Canvas.Font.Assign(Font);

      { Clean the area to draw }
      Canvas.Brush.Color:=Self.Color;
      Canvas.FillRect(rcItem);

      if not CustomDraw then begin
        { Custom draw the text. Two lines if Caption contains a #10 }
        if Pos(#10, Caption) > 0 then
          begin
            if FDifferentFonts then begin
              Canvas.Font.Size := 8;
              Canvas.Font.Style := [];
            end;
            h := Canvas.TextHeight(Caption);
            Canvas.TextOut(rcItem.Left + TextBuff,
              rcItem.Top + (ItemHeight - h * 2) div 2,
              Copy(Caption, 1, Pos(#10, Caption)-1));
            Delete(Caption, 1, Pos(#10, Caption));
            Canvas.TextOut(rcItem.Left + TextBuff,
              rcItem.Top + (ItemHeight - h * 2) div 2 + FTextHeight,
              Caption);
          end
        else begin
          if FDifferentFonts then begin
            Canvas.Font.Size := 12;
            Canvas.Font.Style := [fsBold];
          end;
          h := Canvas.TextHeight(Caption);
          Canvas.TextOut(rcItem.Left + TextBuff,
            rcItem.Top + (ItemHeight - h) div 2, Caption);
      end;
      end;

      { Call the OnDrawEvent. If style is lsOwnerDraw this event must exist! }
      if Integer(itemID) >= 0 then DrawItem(itemID, rcItem, State);

      { Draw focus rect }
      if (odFocused in State) then
        with Canvas do
          begin
            if Color = clWindow then
              Pen.Color := cl3DDkShadow
            else
              Pen.Color := clBtnShadow;
            PolyLine([Point(rcItem.Left, rcItem.Bottom -1), Point(rcItem.Left,
              rcItem.Top), Point(rcItem.Right -1, rcItem.Top)]);
            if Color = clWindow then
              Pen.Color := cl3DLight
            else
              Pen.Color := clBtnHighLight;
            PolyLine([Point(rcItem.Right -1, rcItem.Top), Point(rcItem.Right -1,
            rcItem.Bottom -1), Point(rcItem.Left -1, rcItem.Bottom -1)]);
          end;

      Canvas.Handle := 0;
    end;
end;
//______________________________________________________________________________
{rocedure TCLListBox.WMEraseBkgnd(var Msg: TWMEraseBkgnd);
var
  R: TRect;
begin
  // Fill in the empty space, if any
  R := ItemRect(Items.Count -1);
  R.Top := R.Bottom;
  R.Bottom := 1000;//Self.Height;
  Canvas.FillRect(R);
  Msg.Result := 1;
end;}
//______________________________________________________________________________
procedure TCLListBox.CreateWnd;
begin
  inherited;
  Canvas.Font.Assign(Font);
  Canvas.Brush.Color := Color;
  FTextHeight := Canvas.TextHeight('X');
  { ItemHeight := FTexTop * ITEM_HEIGHT_FACTOR
    For some reason this does not work. The ListBox does not get displayed.
    And the ItemHeight does not get set properly. So use the line below.

    Perform(LB_SETITEMHEIGHT, 0, FTextHeight * ITEM_HEIGHT_FACTOR);

    The above line was commented out in favor of assigning the ItemHeight after
    the control is created }
end;
//______________________________________________________________________________
constructor TCLListBox.Create(AOwner: TComponent);
begin
  FSelectedFont := TFont.Create;
  TextBuff := 50;
  PlainText := false;
  inherited Create (AOwner);
  Multiselect := False;
end;
//______________________________________________________________________________
destructor TCLListBox.Destroy;
begin
  FSelectedFont.Free;
  inherited;
end;
//______________________________________________________________________________
procedure TCLListBox.Next;
begin
  if ItemIndex = Items.Count -1 then
    ItemIndex := 0
  else
    ItemIndex := ItemIndex + 1;
  Click;
end;
//______________________________________________________________________________
procedure TCLListBox.Previous;
begin
  if ItemIndex = 0 then
    ItemIndex := Items.Count -1
  else
    ItemIndex := ItemIndex - 1;
  Click;
end;
//______________________________________________________________________________
end.


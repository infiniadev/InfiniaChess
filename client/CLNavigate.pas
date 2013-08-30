{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLNavigate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, Buttons, CLListBox, Menus, CLGame, CLProfile;

type
  TfCLNavigate = class(TForm)
    bvlHeader: TBevel;
    lblFrames: TLabel;
    sbPin: TSpeedButton;
    clNavigate: TCLListBox;
    procedure clNavigateClick(Sender: TObject);
    procedure clNavigateDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure sbPinClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);

  private
    { Private declarations }
    LastItemIndex: integer;
  public
    { Public declarations }
    procedure AddGame(const Game: TCLGame);
    procedure AddProfile(const Profile: TCLProfile);
    procedure CreateParams(var Params: TCreateParams); override;
    procedure PinGlyph(const Down: boolean);
    procedure RemoveObject(const Obj: TObject);
    procedure SetSwitchedAllGames;
    procedure SetAchievements(p_Visible: Boolean);
  end;

var
  fCLNavigate: TfCLNavigate;

implementation

uses
  CLBoard, CLMain, CLTerminal, CLAchievements;

{$R *.DFM}
//______________________________________________________________________________
procedure TfCLNavigate.AddGame(const Game: TCLGame);
begin
  { Called as the last statement from any procedure that creates a new game }
  with clNavigate do
    begin
      if Items.IndexOfObject(Game) > -1 then Exit;
      Items.AddObject(Game.GameModeString, Game);
      ItemIndex := clNavigate.Items.Count -1;
      OnClick(nil);
    end;
end;
//______________________________________________________________________________
procedure TfCLNavigate.AddProfile(const Profile: TCLProfile);
var
  Index: Integer;
begin
  with clNavigate do
    begin
      if Items.IndexOfObject(Profile) > -1 then Exit;
      for Index := Items.Count -1 downto 0 do
        if not (Items.Objects[Index] is TCLGame) then
          begin
            Items.InsertObject(Index + 1, 'Profile of' + #10 + Profile.FLogin,
              Profile);
            ItemIndex := Index + 1;
            OnClick(nil);
            Break;
          end;
    end;
end;
//______________________________________________________________________________
procedure TfCLNavigate.CreateParams(var Params: TCreateParams);
begin
  inherited;
  { Leave the border but remove the caption for when the Chesslink Bar is
    clicked. }
  with Params do begin
    Style := Style and not WS_CAPTION;
  end;
end;
//______________________________________________________________________________
procedure TfCLNavigate.PinGlyph(const Down: boolean);
begin
  if fCLMain.FrameAttached then
    begin
      sbPin.Hint := 'Close';
      sbPin.Glyph.LoadFromResourceName(HInstance, 'CLOSE_X')
    end
  else
    begin
      sbPin.Hint := 'Pin Down';
      sbPin.Glyph.LoadFromResourceName(HInstance, 'PIN');
    end;
end;
//______________________________________________________________________________
procedure TfCLNavigate.RemoveObject(const Obj: TObject);
var
  ObjIndex, Index: Integer;
begin
  { Called from fCLBoard OnClose to remove itself from the list }
  with clNavigate do
    begin
      ObjIndex := Items.IndexOfObject(Obj);
      //Index := ItemIndex;
      if ObjIndex > -1 then begin
        if ItemIndex <> LastItemIndex then begin
          ItemIndex := LastItemIndex;
          OnClick(nil);
        end;
        //if Index > ObjIndex then ItemIndex := -1;
        try Items.Delete(ObjIndex); except end;
        {if Index > ObjIndex then Dec(Index);
          if (Index<Items.Count-1) or (Index > Items.Count -1) then Index := Items.Count -1;
          ItemIndex := Index;
          if Index > -1 then OnClick(nil);}
      end;
    end;
end;
//______________________________________________________________________________
procedure TfCLNavigate.clNavigateClick(Sender: TObject);
begin
  with clNavigate do
    begin
      if ItemIndex < 7 then LastItemIndex := ItemIndex;
      fCLMain.SetActivePane(ItemIndex, Items.Objects[ItemIndex]);
      if Items.Objects[ItemIndex] is TCLGame
        then fCLTerminal.ShowTab(TCLGame(Items.Objects[ItemIndex]));
    end;
end;
//______________________________________________________________________________
{procedure TfCLNavigate.clNavigateDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
const
  BITMAP_BUFF = 4;
var
  GM: TCLGame;
  il: TImageList;
begin
  if (clNavigate.Items.Objects[Index] is TCLGame) then begin
    GM:=TCLGame(clNavigate.Items.Objects[Index]);
    case GM.GameMode of
      gmCLSObserve,gmCLSObEx: Index:=9;
      gmCLSExamine: Index:=10;
    else
      Index := 8
    end;
  end else if (clNavigate.Items.Objects[Index] is TCLProfile) then
    Index := 7//fCLProfile.Tag
  else begin
    Index := TForm(clNavigate.Items.Objects[Index]).Tag;
    case Index of
       4: Index:=0;
       7: Index:=1;
       3: Index:=2;
       9: Index:=3;
      10: Index:=6;
      11: Index:=5;
      12: Index:=5;
      13: Index:=4;
      //10: Index:=10;
      //11: Index:=5;
      //12: Index:=4;
      //13: Index:=9;
    end;
  end;
  il:=fCLMain.ilNavigate64;
  if Index<il.Count then
    il.Draw(clNavigate.Canvas, BITMAP_BUFF, Rect.Top +
      (clNavigate.ItemHeight - il.Height) div 2, Index);
end;}
procedure TfCLNavigate.clNavigateDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
const
  BITMAP_BUFF = 4;
var
  GM: TCLGame;
  FormTag, ImageIndex: integer;
  FormName: string;
begin
  if (clNavigate.Items.Objects[Index] is TCLGame) then begin
    GM:=TCLGame(clNavigate.Items.Objects[Index]);
    case GM.GameMode of
      gmCLSObserve,gmCLSObEx: ImageIndex := 7;
      gmCLSExamine: ImageIndex := 8;
    else
      ImageIndex := 5
    end;
  end else if (clNavigate.Items.Objects[Index] is TCLProfile) then
    ImageIndex := 6//fCLProfile.Tag
  else begin
    FormTag := TForm(clNavigate.Items.Objects[Index]).Tag;
    case FormTag of
       4: ImageIndex:=0;
       7: ImageIndex:=1;
       3: ImageIndex:=2;
       9: ImageIndex:=3;
      10: ImageIndex:=10;
      11: ImageIndex:=5;
      12: ImageIndex:=4;
      13: ImageIndex:=9;
      21: ImageIndex:=11;
      22:
        begin
          FormName := TForm(clNavigate.Items.Objects[Index]).Name;
          if FormName = 'fCLClubs' then ImageIndex := 12
          else if FormName = 'fCLSchools' then ImageIndex := 14;
        end;
      23: ImageIndex:=13;
    end;
  end;
  if Index<fCLMain.ilMain32.Count then
    fCLMain.ilMain32.Draw(clNavigate.Canvas, BITMAP_BUFF, Rect.Top +
      (clNavigate.ItemHeight - fCLMain.ilMain32.Height) div 2, ImageIndex);
end;
//______________________________________________________________________________
procedure TfCLNavigate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { This is interesting. A Windows component (TListBox) has a dual life,
    Delphi's and Windows. Even though Action is set to caFree, clNavigate may
    live for a while. This can cause problems if we free objects that are
    referenced in Items.Objects and clNavigate fires a event which looks for
    those freed objects. The solutions:

      1) Subclass the TListbox handling the CreateWnd and DestroyWnd messages
        to managing a local TList used to properly reload Items.Objects on
        CreateWnd (Too much overhead for our needs).
      2) Explicitly free the TListBox first.
      3) Clear the Items list first.
      4) Set TListbox events to nil. }
  clNavigate.OnDrawItem := nil;
  fCLNavigate := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLNavigate.FormCreate(Sender: TObject);
begin
  { Necessary. For some reason the property set at design time does not work. }
  clNavigate.ItemHeight := 40;
  LastItemIndex := 3; // seeks
end;
//______________________________________________________________________________
procedure TfCLNavigate.FormDeactivate(Sender: TObject);
begin
  if not fCLMain.FrameAttached then Hide;
end;
//______________________________________________________________________________
procedure TfCLNavigate.sbPinClick(Sender: TObject);
begin
  fCLMain.FrameAttached := not fCLMain.FrameAttached;
end;
//______________________________________________________________________________
procedure TfCLNavigate.SetSwitchedAllGames;
var
  i: integer;
begin
  with clNavigate do
    for i:=0 to Items.Count-1 do
      if Items.Objects[i].ClassName='TCLGame' then
        TCLGame(Items.Objects[i]).Switched:=true;
end;
//______________________________________________________________________________
procedure TfCLNavigate.FormPaint(Sender: TObject);
begin
  clNavigate.Color:=Color;
end;
//______________________________________________________________________________
procedure TfCLNavigate.SetAchievements(p_Visible: Boolean);
var
  vIndex: integer;
  vText: string;
begin
  vText := 'Achievements';
  vIndex := clNavigate.Items.IndexOf(vText);
  if p_Visible = (vIndex > -1) then exit;

  if p_Visible then clNavigate.Items.AddObject('Achievements', fCLAchievements)
  else clNavigate.Items.Delete(vIndex);
end;
//______________________________________________________________________________
end.

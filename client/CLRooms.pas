{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLRooms;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, StdCtrls, ExtCtrls, Menus;

type
  TRoomHeader = (rhNumber, rhDescription, rhCreator, rhCount);

  TRoom = class(TObject)
    FCount: Integer;
    FCreator: string;
    FDescription: string;
    FInRoom: Boolean;
    FLimit: Integer;
    FNumber: Integer;
    FEternal: Boolean;
  end;

  TfCLRooms = class(TForm)
    bvlHeader: TBevel;
    lblRooms: TLabel;
    lblRooms2: TLabel;
    lvRooms: TListView;
    miCreateRoom: TMenuItem;
    miEnterRoom: TMenuItem;
    miExitRoom: TMenuItem;
    N1: TMenuItem;
    pmRooms: TPopupMenu;
    sbMax: TSpeedButton;
    miDeleteRoom: TMenuItem;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lvRoomsClick(Sender: TObject);
    procedure lvRoomsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvRoomsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvRoomsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvRoomsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miCreateRoomClick(Sender: TObject);
    procedure miEnterRoomClick(Sender: TObject);
    procedure miExitRoomClick(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);
    procedure pmRoomsPopup(Sender: TObject);
    procedure miDeleteRoomClick(Sender: TObject);

  private
    { Private declarations }
    FColumnToSort: TRoomHeader;
    FReverseSort: Boolean;
    FRoomCreator: Boolean;

    procedure RoomIEnterExit(const Datapack: TStrings);

  public
    { Public declarations }
    procedure Clear;
    procedure RoomCount(const Datapack: TStrings);
    procedure RoomDef(const Datapack: TStrings);
    procedure RoomDefBegin;
    procedure RoomDefEnd;
    procedure RoomDestroyed(const Datapack: TStrings);
    procedure RoomIEnter(const Datapack: TStrings);
    procedure RoomIExit(const Datapack: TStrings);
    procedure SetMenuState;    
    procedure ShowInviteDialog(const Login: string);

    property RoomCreator: Boolean read FRoomCreator;
  end;

var
  fCLRooms: TfCLRooms;

implementation

uses
  CLConst, CLGlobal, CLMain, CLSocket, CLTerminal, CLConsole, CLFilterManager,
  CLNavigate;

{$R *.DFM}
//______________________________________________________________________________
{ DP_ROOM_I_ENTER, DP_ROOM_I_EXIT: DP#, RoomNumber }
procedure TfCLRooms.RoomIEnterExit(const Datapack: TStrings);
var
  Item: TListItem;
begin
  { Attempt to find the RoomNumber. }
  Item := lvRooms.FindCaption(0, Datapack[1], False, True, True);
  if Assigned(Item) then
    begin
      TRoom(Item.Data).FInRoom := StrToInt(Datapack[0]) = DP_ROOM_I_ENTER;
      lvRooms.UpdateItems(Item.Index, Item.Index);
    end;
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLRooms.Clear;
var
  Index: Integer;
begin
  { Clear the memory. }
  for Index := 0 to lvRooms.Items.Count -1 do
    TRoom(lvRooms.Items[Index].Data).Free;
  lvRooms.Items.Clear;
end;
//______________________________________________________________________________
{ DP_ROOM_COUNT: DP#, RoomNumber, Count }
procedure TfCLRooms.RoomCount(const Datapack: TStrings);
var
  Item: TListItem;
begin
  { Attempt to find the RoomNumber. }
  Item := lvRooms.FindCaption(0, Datapack[1], False, True, True);
  { If found then change the count }
  if Assigned(Item) then
    begin
      { Change the TRoom to match }
      TRoom(Item.Data).FCount := StrToInt(Datapack[2]);
      { Change the associated lvRooms entry }
      Item.SubItems[2] := Datapack[2];
    end;
end;
//______________________________________________________________________________
{ DP_ROOM_DEF: DP#, RoomNumber, Description, Creator, Limit, Count }
procedure TfCLRooms.RoomDef(const Datapack: TStrings);
var
  Item: TListItem;
  Room: TRoom;
begin
  { Ignore duplicates. }
  if lvRooms.FindCaption(0, Datapack[1], False, True, True) <> nil then Exit;

  { Create a new TRoom }
  Room := TRoom.Create;
  with Room do
    begin
      FCount := StrToInt(Datapack[5]);
      FCreator := Datapack[3];
      FDescription := Datapack[2];
      FInRoom := False;
      FLimit := StrToInt(Datapack[4]);
      FNumber := StrToInt(Datapack[1]);
      FEternal := (Datapack.Count > 6) and (Datapack[6] = '1');
    end;

  { Create a new Item }
  Item := lvRooms.Items.Add;
  { }
  with Item do
    begin
      Caption := Datapack[1];
      Data := Room;
      ImageIndex := Tag;
      SubItems.Add(Datapack[2]);
      SubItems.Add(Datapack[3]);
      SubItems.Add(Datapack[5]);
      lvRooms.UpdateItems(Index, Index);
    end;

  if (Room.FCreator = fCLSocket.MyName) and (fCLSocket.MyName <> '') then
    begin
      FRoomCreator := True;
      SetMenuState;
    end;

  if (Room.FCreator <> fCLSocket.MyName)
  and (fCLSocket.InitState >= isLoginComplete) then
    begin
      fGL.PlayCLSound(SI_INVITE);
      fCLTerminal.ccConsole.AddLine(-1, 'You have been invited into a room. Click "/enter ' + Datapack[1] + '" to enter.' ,ltShout);
    end;
end;
//______________________________________________________________________________
{ DP_ROOM_DEF_BEGIN: DP# }
procedure TfCLRooms.RoomDefBegin;
begin
  FRoomCreator := False;
  with lvRooms.Items do
    begin
      BeginUpdate;
      Clear;
    end;
end;
//______________________________________________________________________________
{ DP_ROOM_DEF_End: DP# }
procedure TfCLRooms.RoomDefEnd;
begin
  lvRooms.Items.EndUpdate;
end;
//______________________________________________________________________________
{ DP_ROOM_DESTROYED: DP#, RoomNumber }
procedure TfCLRooms.RoomDestroyed(const Datapack: TStrings);
var
  Item: TListItem;
begin
  { Attempt to find the RoomNumber being destroyed. }
  Item := lvRooms.FindCaption(0, Datapack[1], False, True, True);
  { If found then Free the associated TRoom and the Item. }
  if Assigned(Item) then
    begin
      if TRoom(Item.Data).FCreator = fCLSocket.MyName then
        begin
          FRoomCreator := False;
          SetMenuState;
        end;
      TRoom(Item.Data).Free;
      Item.Free;
    end;
end;
//______________________________________________________________________________
{ DP_ROOM_I_ENTER: DP#, RoomNumber, Description }
procedure TfCLRooms.RoomIEnter(const Datapack: TStrings);
begin
  fCLTerminal.CreateFilter(Datapack[2], fkRoom, StrToInt(Datapack[1]));
  RoomIEnterExit(Datapack);
end;
//______________________________________________________________________________
{ DP_ROOM_ENTER: DP#, RoomNumber }
procedure TfCLRooms.RoomIExit(const Datapack: TStrings);
begin
  fCLTerminal.CloseTab(fkRoom, StrToInt(Datapack[1]));
  RoomIEnterExit(Datapack);
end;
//______________________________________________________________________________
procedure TfCLRooms.SetMenuState;
var
  Room: TRoom;
begin
  if fCLNavigate.CLNavigate.ItemIndex <> 2 then exit;
  { Automatically disabled if no item selected. }
  if lvRooms.Selected = nil then
    begin
      miEnterRoom.Enabled := False;
      miExitRoom.Enabled := False;
    end
  else
    begin
      { Enabled is bases upon the InRoom flag. }
      Room := TRoom(lvRooms.Selected.Data);
      miEnterRoom.Enabled := not Room.FInRoom;
      miExitRoom.Enabled := Room.FInRoom;
    end;
  miCreateRoom.Enabled := not FRoomCreator and (fCLSocket.InitState >= isLoginComplete);
  { Syncronize the Main forms menu. }
  fCLMain.miEnterRoom.Enabled := miEnterRoom.Enabled;
  fCLMain.miExitRoom.Enabled := miExitRoom.Enabled;
  fCLMain.miCreateRoom.Enabled := miCreateRoom.Enabled;
  fCLMain.tbEnterRoom.Visible := miEnterRoom.Enabled;
  fCLMain.tbExitRoom.Visible := miExitRoom.Enabled;
  fCLMain.tbCreateRoom.Visible := miCreateRoom.Enabled;
end;
//______________________________________________________________________________
procedure TfCLRooms.ShowInviteDialog(const Login: string);
var
  s: string;
begin
  { Semd an invitation to a friend. }
  s := 'Invite ' + Login + ' to your room?';
  if MessageDlg(s, mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
    fCLSocket.InitialSend([CMD_STR_INVITE, Login]);
end;
//______________________________________________________________________________
procedure TfCLRooms.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fCLRooms := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLRooms.FormCreate(Sender: TObject);
begin
  FRoomCreator := False;
  FReverseSort := False;
end;
//______________________________________________________________________________
procedure TfCLRooms.lvRoomsClick(Sender: TObject);
begin
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLRooms.lvRoomsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  { Prepare to call custom sort }
  FReverseSort := not FReverseSort;
  FColumnToSort := TRoomHeader(Column.Index);
  lvRooms.CustomSort(nil, 0);
end;
//______________________________________________________________________________
procedure TfCLRooms.lvRoomsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  Room1, Room2: TRoom;
begin
  Room1 := TRoom(Item1.Data);
  Room2 := TRoom(Item2.Data);

  case FColumnToSort of
    rhNumber:
      Compare := Room1.FNumber - Room2.FNumber;
    rhDescription:
      Compare := AnsiCompareText(Room1.FDescription, Room2.FDescription);
    rhCreator:
      Compare := AnsiCompareText(Room1.FCreator, Room2.FCreator);
    rhCount:
      Compare := Room1.FCount - Room2.FCount;
  end;

  if FReverseSort then Compare := -Compare;
end;
//______________________________________________________________________________
procedure TfCLRooms.lvRoomsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item = nil then Exit;
  if TRoom(Item.Data).FInRoom = False then
    lvRooms.Canvas.Font.Style := lvRooms.Font.Style - [fsBold]
  else
    lvRooms.Canvas.Font.Style := lvRooms.Font.Style + [fsBold];
end;
//______________________________________________________________________________
procedure TfCLRooms.lvRoomsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  SetMenuState;
end;
//______________________________________________________________________________
procedure TfCLRooms.miCreateRoomClick(Sender: TObject);
var
  s: string;
begin
  s := InputBox('Create Room', 'Enter the description of your private room.', '');
  if s <> '' then fCLSocket.InitialSend([CMD_STR_CREATE_ROOM, s]);
end;
//______________________________________________________________________________
procedure TfCLRooms.miEnterRoomClick(Sender: TObject);
var
  Room: TRoom;
begin
  { Just in case }
  if lvRooms.Selected = nil then Exit;
  Room := TRoom(lvRooms.Selected.Data);
  fCLSocket.InitialSend([CMD_STR_ENTER, IntToStr(Room.FNumber)]);
end;
//______________________________________________________________________________
procedure TfCLRooms.miExitRoomClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_EXIT, lvRooms.Selected.Caption]);
end;
//______________________________________________________________________________
procedure TfCLRooms.sbMaxClick(Sender: TObject);
begin
  Self.SetFocus;
  fCLMain.miMaximizeTop.Click;
end;
//______________________________________________________________________________
procedure TfCLRooms.pmRoomsPopup(Sender: TObject);
var
  Room: TRoom;
begin
  miDeleteRoom.Visible := fCLSocket.MyAdminLevel = 3;
  if not miDeleteRoom.Visible then exit;
  if lvRooms.Selected = nil then Exit;
  Room := TRoom(lvRooms.Selected.Data);
  miDeleteRoom.Enabled := not Room.FEternal;
end;
//______________________________________________________________________________
procedure TfCLRooms.miDeleteRoomClick(Sender: TObject);
var
  Room: TRoom;
begin
  if lvRooms.Selected = nil then Exit;
  Room := TRoom(lvRooms.Selected.Data);
  if MessageDlg('Are you sure you want to delete room '+Room.FDescription+'?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    fCLSocket.InitialSend([CMD_STR_DELETEROOM, IntToStr(Room.FNumber)]);
end;
//______________________________________________________________________________
end.

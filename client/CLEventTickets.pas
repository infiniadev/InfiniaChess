{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLEventTickets;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, ComCtrls, StdCtrls, CLEvents;

type
  TfCLEventTickets = class(TForm)
    lv: TListView;
    Panel5: TPanel;
    Panel11: TPanel;
    sbOk: TSpeedButton;
    btnAdd: TBitBtn;
    btnDelete: TBitBtn;
    lblPlayersCount: TLabel;
    procedure sbOkClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure lvKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
    procedure ShowCount;
  public
    { Public declarations }
    procedure Init(ev: TCSEvent; Editing: Boolean);
  end;

var
  fCLEventTickets: TfCLEventTickets;

implementation

{$R *.DFM}
//=================================================================================
procedure TfCLEventTickets.sbOkClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;
//=================================================================================
procedure TfCLEventTickets.btnAddClick(Sender: TObject);
var
  itm: TListItem;
begin
  itm:=lv.Items.Add;
  itm.EditCaption;
  ShowCount;
end;
//=================================================================================
procedure TfCLEventTickets.lvKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = ord('n')) or (Key = ord('N'))) and (ssCtrl in Shift) then
    btnAdd.Click;
end;
//=================================================================================
procedure TfCLEventTickets.Init(ev: TCSEvent; Editing: Boolean);
var
  ticket: TEventTicket;
  i: integer;
  itm: TListItem;
begin
  lv.Items.Clear;
  for i:=0 to ev.Tickets.Count-1 do begin
    ticket:=ev.Tickets[i];
    itm:=lv.Items.Add;
    itm.Caption:=ticket.Login;
    itm.SubItems.Add(ticket.Title);
    itm.SubItems.Add(IntToStr(ticket.Rating));
    if ev.UserIsJoined(ticket.Login) then
      itm.SubItems.Add('1')
    else
      itm.SubItems.Add('0');
  end;
  btnAdd.Visible:=Editing; 
  btnDelete.Visible:=Editing;
  lv.ReadOnly:=not Editing;
  ShowCount;
end;
//=================================================================================
procedure TfCLEventTickets.lvDrawItem(Sender: TCustomListView;
  Item: TListItem; Rect: TRect; State: TOwnerDrawState);
var
  i,n: integer;
  txt: string;
begin
  n:=Rect.Left;
  if lv.Selected = Item then begin
    lv.Canvas.Brush.Color := clBlue;
    lv.Canvas.FillRect(Rect);//(Rect.Left+2,Rect.Top+2,Rect.Right-2,Rect.Bottom-2);
    lv.Canvas.Font.Color := clWhite;
  end else begin
    lv.Canvas.Brush.Color := lv.Color;
    lv.Canvas.FillRect(Rect);
    //lv.Canvas.Rectangle(Rect.Left+2,Rect.Top+2,Rect.Right-2,Rect.Bottom-2);
    lv.Canvas.Font.Color := clBlack;
  end;

  for i:=0 to Item.SubItems.Count do begin
    if i=0 then txt:=Item.Caption
    else txt:=Item.SubItems[i-1];

    if (Item.SubItems.Count>=3) and (Item.SubItems[2] = '1') then
      lv.Canvas.Font.Style := [fsBold]
    else
      lv.Canvas.Font.Style := [];

    lv.Canvas.TextOut(n+4,Rect.Top,Txt);
    n:=n+lv.Columns[i].Width;                    
  end;
end;
//=================================================================================
procedure TfCLEventTickets.btnDeleteClick(Sender: TObject);
begin
  if lv.Selected = nil then exit;
  lv.Items.Delete(lv.Items.IndexOf(lv.Selected));
  ShowCount;
end;
//=================================================================================
procedure TfCLEventTickets.ShowCount;
begin
  lblPlayersCount.Caption:=IntToStr(lv.Items.Count)+' players';
end;
//=================================================================================
end.

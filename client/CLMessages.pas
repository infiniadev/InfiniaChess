{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLMessages;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, Buttons, StdCtrls, ExtCtrls, Menus;

type
  TMessageHeader = (mhSender, mhDate, mhSubject);

  TCLMessage = class(TObject)
    FMessageID: Integer;
    FLoginID: integer;
    FLogin: string;
    FTitle: string;
    FSenderID: integer;
    FSender: string;
    FSenderTitle: string;
    FDate: string;
    FSubject: string;
    FBody: string;
    FRead: Boolean;
  end;

  TfCLMessages = class(TForm)
    bvlMessages: TBevel;
    lblMessages: TLabel;
    lblMessages2: TLabel;
    lvMessages: TListView;
    miDeleteMessage: TMenuItem;
    miNewMessage: TMenuItem;
    miReply: TMenuItem;
    pmMessages: TPopupMenu;
    sbMax: TSpeedButton;
    Panel4: TPanel;
    Label7: TLabel;
    lblSender: TLabel;
    sbClearSender: TSpeedButton;
    Label12: TLabel;
    sbClearText: TSpeedButton;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lblPagesCount: TLabel;
    cmbFolder: TComboBox;
    edtSender: TEdit;
    edtText: TEdit;
    dtFilterFrom: TDateTimePicker;
    dtFilterTo: TDateTimePicker;
    edPage: TEdit;
    udPage: TUpDown;
    pnlClear: TPanel;
    sbClear: TSpeedButton;
    pnlSearch: TPanel;
    sbMessageSearch: TSpeedButton;
    miStoreMessage: TMenuItem;
    miDeletePerm: TMenuItem;
    procedure miDeletePermClick(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvMessagesClick(Sender: TObject);
    procedure lvMessagesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvMessagesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvMessagesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvMessagesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miDeleteMessageClick(Sender: TObject);
    procedure miNewMessageClick(Sender: TObject);
    procedure miReplyClick(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);
    procedure sbMessageSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miStoreMessageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbClearTextClick(Sender: TObject);
    procedure sbClearSenderClick(Sender: TObject);
    procedure dtFilterFromClick(Sender: TObject);
    procedure cmbFolderChange(Sender: TObject);
    procedure sbClearClick(Sender: TObject);

  private
    { Private declarations }
    FColumnToSort: TMessageHeader;
    FReverseSort: Boolean;
    FShown: Boolean;
    FNewMessageExists: Boolean;

    procedure SetPageOf(Num: integer);
    procedure Clear;
    procedure FindMessage(const MessageID: Integer; var CLMessage: TCLMessage;
      var Item: TListItem);

  public
    { Public declarations }
    procedure MessageAdd(const Datapack: TStrings);
    procedure MessageDelete(const Datapack: TStrings);
    procedure SetMenuState;
    procedure ShowMessageDialog(const Login, Subject: string);
    procedure CMD_MessageClear;
    procedure CMD_MessagePages(const Datapack: TStrings);
    procedure CMD_Message2(const Datapack: TStrings);
  end;

var
  fCLMessages: TfCLMessages;

implementation

uses
  CLConst, CLGlobal, CLMain, CLMessage, CLSocket, CLTerminal, CLConsole,
  CLFilterManager, CLLib;

{$R *.DFM}
//=========================================================================================
procedure TfCLMessages.Clear;
var
  Index: Integer;
begin
  { Clear the message memory. }
  for Index := 0 to lvMessages.Items.Count -1 do
    TCLMessage(lvMessages.Items[Index].Data).Free;
  lvMessages.Items.Clear;
end;
//=========================================================================================
procedure TfCLMessages.FindMessage(const MessageID: Integer;
  var CLMessage: TCLMessage; var Item: TListItem);
var
  Index: Integer;
begin
  CLMessage := nil;
  Item := nil;

  { Attempt to find the MessageID in the current list. }
  for Index := 0 to lvMessages.Items.Count -1 do
    begin
      CLMessage := TCLMessage(lvMessages.Items[Index].Data);
      if CLMessage.FMessageID = MessageID then
        begin
          Item := lvMessages.Items[Index];
          Break;
        end
      else
        CLMessage := nil;
    end;
end;
//=========================================================================================
{ DP_MESSAGE: DP#, MessageID, Sender, Title, Date, Subject, [Body] }
procedure TfCLMessages.MessageAdd(const Datapack: TStrings);
var
  Item: TListItem;
  CLMessage: TCLMessage;
  s: string;
begin
  exit;
  FindMessage(StrToInt(Datapack[1]), CLMessage, Item);

  { If found exit the procedure }
  if Assigned(CLMessage) then Exit;

  { Create a TCLMessage and ListView entry. }
  { Create a new TCLMessage to hold the message. }
  CLMessage := TCLMessage.Create;
  with CLMessage do
    begin
      FMessageID := StrToInt(Datapack[1]);
      FSender := Datapack[2];
      { The server sends dates with a / separator. StrToDate requires the locale
        seperator. Make the adjustment. }
      s := Datapack[4];
      if Pos('/', s) > 0 then s[Pos('/', s)] := DateSeparator;
      if Pos('/', s) > 0 then s[Pos('/', s)] := DateSeparator;
      FDate := s;
      FSubject := Datapack[5];
      FBody := Datapack[6];
    end;
  { Create a new ListView entry. }
  Item := lvMessages.Items.Add;
  with Item do
    begin
      Data := CLMessage;
      ImageIndex := Tag;
      Caption := Datapack[2];
      SubItems.Add(s);
      SubItems.Add(Datapack[5]);
      SubItems.Add(Datapack[6]);
    end;

  if fCLSocket.InitState >= isLoginComplete then fGL.PlayCLSound(SI_MESSAGE);
end;
//=========================================================================================
{ DP_MESSAGE_DELETE: DP#, MessageID }
procedure TfCLMessages.MessageDelete(const Datapack: TStrings);
var
  Item: TListItem;
  CLMessage: TCLMessage;
begin
  FindMessage(StrToInt(Datapack[1]), CLMessage, Item);
  if Assigned(CLMessage) then CLMessage.Free;
  if Assigned(Item) then Item.Free;
end;
//=========================================================================================
procedure TfCLMessages.SetMenuState;
begin
  miReply.Enabled := (lvMessages.Selected <> nil) and
    (fCLSocket.InitState >= isLoginComplete);
  miDeleteMessage.Enabled := (lvMessages.Selected <> nil) and
    (fCLSocket.InitState >= isLoginComplete) and (cmbFolder.ItemIndex in [0,2]);
  miStoreMessage.Enabled := (lvMessages.Selected <> nil) and
    (fCLSocket.InitState >= isLoginComplete) and (cmbFolder.ItemIndex in [0]);
  fCLMain.miReply.Enabled := miReply.Enabled;
  fCLMain.miDeleteMessage.Enabled := miDeleteMessage.Enabled;
  fCLMain.tbReply.Visible := miReply.Enabled;
  fCLMain.tbDeleteMessage.Visible := miDeleteMessage.Enabled;
  miDeletePerm.Enabled := (lvMessages.Selected <> nil) and
     (fCLSocket.InitState >= isLoginComplete) and
     (cmbFolder.ItemIndex in [3]);

end;
//=========================================================================================
procedure TfCLMessages.ShowMessageDialog(const Login, Subject: string);
begin
  fCLMessage := TfCLMessage.Create(nil);
  with fCLMessage do
    begin
      cmbTo.Text := Login;
      edtSubject.Text := Subject;
      ShowModal;
    end;
end;
//=========================================================================================
procedure TfCLMessages.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Clear;
  fCLMessages := nil;
  Action := caFree;
end;
//=========================================================================================
procedure TfCLMessages.lvMessagesClick(Sender: TObject);
var
  Msg: TCLMessage;
begin
  SetMenuState;
  if lvMessages.Selected <> nil then
    begin
      Msg := TCLMessage(lvMessages.Selected.Data);
      fCLTerminal.AddLine(fkConsole, 0, '--From: ' + Msg.FSender +
      ' (' + Msg.FDate + ') ' + Msg.FBody, ltMessage);
      fCLTerminal.ccConsole.EndUpdate;
      fCLSocket.InitialSend([CMD_STR_MESSAGE_RETRIEVE, IntToStr(Msg.FMessageID)]);
      if not Msg.FRead then lvMessages.Selected.ImageIndex := 7;
      fCLTerminal.tcMain.TabIndex := 0;
      fCLTerminal.tcMain.OnChange(fCLTerminal.tcMain);
    end;
end;
//=========================================================================================
procedure TfCLMessages.lvMessagesColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  { Prepare to call custom sort }
  FReverseSort := not FReverseSort;
  FColumnToSort := TMessageHeader(Column.Index);
  lvMessages.CustomSort(nil, 0);
end;
//=========================================================================================
procedure TfCLMessages.lvMessagesCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  Message1, Message2: TCLMessage;
begin
  Message1 := TCLMessage(Item1.Data);
  Message2 := TCLMessage(Item2.Data);

  case FColumnToSort of
    mhSender:
      Compare := AnsiCompareText(Message1.FSender, Message2.FSender);
    mhDate:
      Compare := AnsiCompareText(Message1.FDate, Message2.FDate);
    mhSubject:
      Compare := AnsiCompareText(Message1.FSubject, Message2.FSubject);
  end;

  if FReverseSort then Compare := -Compare;
end;
//=========================================================================================
procedure TfCLMessages.lvMessagesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then miDeleteMessage.Click;
end;
//=========================================================================================
procedure TfCLMessages.lvMessagesSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  SetMenuState;
end;
//=========================================================================================
procedure TfCLMessages.miDeleteMessageClick(Sender: TObject);
var
  MessageID: string;
begin
  if lvMessages.Selected = nil then Exit;
  MessageID := IntToStr(TCLMessage(lvMessages.Selected.Data).FMessageID);
  fCLSocket.InitialSend([CMD_STR_DELETE_MESSAGE, MessageID, '0']);
end;
//=========================================================================================
procedure TfCLMessages.miNewMessageClick(Sender: TObject);
begin
  if not fCLSocket.Rights.Messages then begin
    MessageDlg('Your membership has ended. You cannot send messages.',
      mtWarning, [mbOk], 0);
    exit;
  end;
  if lvMessages.Selected <> nil then
    ShowMessageDialog(lvMessages.Selected.Caption, '')
  else
    ShowMessageDialog('', '');
end;
//=========================================================================================
procedure TfCLMessages.miReplyClick(Sender: TObject);
var
  Item: TListItem;
begin
  if not fCLSocket.Rights.Messages then begin
    MessageDlg('Your membership has ended. You cannot send messages.',
      mtWarning, [mbOk], 0);
    exit;
  end;
  Item := lvMessages.Selected;
  if Item <> nil then ShowMessageDialog(Item.Caption, 'RE:' + Item.SubItems[1]);
end;
//=========================================================================================
procedure TfCLMessages.sbMaxClick(Sender: TObject);
begin
  Self.SetFocus;
  fCLMain.miMaximizeTop.Click;
end;
//=========================================================================================
procedure TfCLMessages.sbMessageSearchClick(Sender: TObject);
var
  Login, sSender, State, Txt: string;
begin
  FNewMessageExists := false;
  if cmbFolder.ItemIndex = 1 then begin // outbox
    Login := edtSender.Text;
    if Login = '' then Login := '-';
    sSender := fCLSocket.MyName;
  end else begin
    Login := fCLSocket.MyName;
    sSender := edtSender.Text;
    if sSender = '' then sSender := '-';
  end;

  case cmbFolder.ItemIndex of
    0: State := '1';  // inbox
    1: State := '0'; // outbox
    2: State := '2'; // stored
    3: State := '3'; // deleted
  end;

  Txt := edtText.Text;
  if Txt = '' then Txt := '%';

  fCLSocket.InitialSend([CMD_STR_MESSAGESEARCH,
    Login,
    sSender,
    State,
    IntToStr(trunc(dtFilterFrom.Date)),
    IntToStr(trunc(dtFilterTo.Date)),
    Txt,
    edPage.Text]);
end;
//=========================================================================================
procedure TfCLMessages.CMD_Message2(const Datapack: TStrings);
var
  Item: TListItem;
  CLMessage: TCLMessage;
  s: string;
begin

  FindMessage(StrToInt(Datapack[1]), CLMessage, Item);

  { If found exit the procedure }
  if Assigned(CLMessage) then Exit;

  { Create a TCLMessage and ListView entry. }
  { Create a new TCLMessage to hold the message. }
  CLMessage := TCLMessage.Create;
  with CLMessage do
    begin
      FMessageID := StrToInt(Datapack[1]);
      FLoginID := StrToInt(Datapack[2]);
      FLogin := Datapack[3];
      FTitle := Datapack[4];
      FSenderID := StrToInt(Datapack[5]);
      FSender := Datapack[6];
      FSenderTitle := Datapack[7];
      FSubject := Datapack[8];
      FBody := Datapack[9];
      FDate := Datapack[10];
      FRead := Datapack[11] = '1';
    end;
  if not CLMessage.FRead then FNewMessageExists := true;
  { Create a new ListView entry. }
  Item := lvMessages.Items.Insert(0);
  with Item do
    begin
      Data := CLMessage;
      ImageIndex := BoolTo_(CLMessage.FRead,7,6);
      Caption := CLMessage.FSender;
      SubItems.Add(CLMessage.FDate);
      SubItems.Add(CLMessage.FSubject);
      SubItems.Add(CLMessage.FBody);
    end;

end;
//=========================================================================================
procedure TfCLMessages.CMD_MessageClear;
begin
  lvMessages.Items.Clear;
end;
//=========================================================================================
procedure TfCLMessages.CMD_MessagePages(const Datapack: TStrings);
begin
  try
    SetPageOf(StrToInt(Datapack[1]));
    if FNewMessageExists then fGL.PlayCLSound(SI_MESSAGE);
  except
  end;
end;
procedure TfCLMessages.miDeletePermClick(Sender: TObject);
var
  MessageID: string;
begin
  if lvMessages.Selected = nil then Exit;
  MessageID := IntToStr(TCLMessage(lvMessages.Selected.Data).FMessageID);
  fCLSocket.InitialSend([CMD_STR_DELETE_MESSAGE, MessageID, '1']);
end;

//=========================================================================================
procedure TfCLMessages.FormCreate(Sender: TObject);
begin
  cmbFolder.ItemIndex := 0;
  dtFilterFrom.DateTime := 39083; // 01/01/2007
  dtFilterTo.DateTime := Date;
  FShown := false;
end;
//=========================================================================================
procedure TfCLMessages.miStoreMessageClick(Sender: TObject);
var
  MessageID: string;
begin
  if lvMessages.Selected = nil then Exit;
  MessageID := IntToStr(TCLMessage(lvMessages.Selected.Data).FMessageID);
  fCLSocket.InitialSend([CMD_STR_MESSAGE_STATE, MessageID, '2']);
  sbMessageSearch.Click;
end;
//=========================================================================================
procedure TfCLMessages.FormShow(Sender: TObject);
begin
  if not FShown then begin
    sbMessageSearch.Click;
    FShown := true;
  end;
end;
//=========================================================================================
procedure TfCLMessages.SetPageOf(Num: integer);
begin
  udPage.Max:=Num;
  lblPagesCount.Caption:='of '+IntToStr(Num);
end;
//=========================================================================================
procedure TfCLMessages.sbClearTextClick(Sender: TObject);
begin
  edtText.Clear;
end;
//=========================================================================================
procedure TfCLMessages.sbClearSenderClick(Sender: TObject);
begin
  edtSender.Clear;
end;
//=========================================================================================
procedure TfCLMessages.dtFilterFromClick(Sender: TObject);
begin
  SetPageOf(1);
end;
//=========================================================================================
procedure TfCLMessages.cmbFolderChange(Sender: TObject);
begin
  SetPageOf(1);
  sbMessageSearch.Click;
end;
//=========================================================================================
procedure TfCLMessages.sbClearClick(Sender: TObject);
begin
  dtFilterFrom.Date := 39083; //StrToDate('01/01/2007');
  dtFilterTo.DateTime := Date;
  sbClearSender.Click;
  sbClearText.Click;
end;
//=========================================================================================
end.

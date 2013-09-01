{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLMessage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfCLMessage = class(TForm)
    btnCancel: TButton;
    btnSend: TButton;
    cmbTo: TComboBox;
    edtSubject: TEdit;
    lblMessage: TLabel;
    lblNewMessage2: TLabel;
    lblSubject: TLabel;
    lblTo: TLabel;
    memoMessage: TMemo;
    pnlType: TPanel;
    rbPerson: TRadioButton;
    rbGroup: TRadioButton;
    pnlGroups: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;

    procedure btnSendClick(Sender: TObject);
    procedure edtMessageChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FillPersonList;
    procedure FillGroupList;
    procedure rbPersonClick(Sender: TObject);
    procedure rbGroupClick(Sender: TObject);
    procedure cmbToKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    procedure ArrangePanels;
    function SelectedGroupList: string;
  public
    { Public declarations }
  end;

var
  fCLMessage: TfCLMessage;

implementation

uses
  CLConst, CLMessages, CLNotify, CLSocket, CLMain;

{$R *.DFM}

//==============================================================================
procedure TfCLMessage.ArrangePanels;
begin
  pnlGroups.Visible := rbGroup.Checked;
  cmbTo.Enabled := rbPerson.Checked;
  if rbPerson.Checked then begin
    FillPersonList;
    cmbTo.Font.Style := [];
  end else begin
    cmbTo.Text := 'Selected Groups';
    cmbTo.Font.Style := [fsItalic];
  end;
end;
//==============================================================================
procedure TfCLMessage.btnSendClick(Sender: TObject);
var
  s, param: string;
begin
  s := edtSubject.Text;
  if s <> '' then s := s + '||';
  s := s + StringReplace(memoMessage.Text, #13#10, '',
    [rfReplaceAll, rfIgnoreCase]);
  if rbPerson.Checked then
    fCLSocket.InitialSend([CMD_STR_MESSAGE, cmbTo.Text, s])
  else begin
    param := SelectedGroupList;
    if param = '' then begin
      MessageDlg('Select at least one group first', mtWarning, [mbOk], 0);
      exit;
    end else begin
      fCLSocket.InitialSend([CMD_STR_MESSAGEGROUP, '-1', param, s]);
    end;
  end;
  ModalResult := mrOk;
end;
//==============================================================================
procedure TfCLMessage.edtMessageChange(Sender: TObject);
begin
  btnSend.Enabled := ((edtSubject.Text <> '') and (memoMessage.Text <> ''))
  and (cmbTo.Text <> '')
  and (fCLSocket.InitState >= isLoginComplete);
end;
//==============================================================================
procedure TfCLMessage.FillGroupList;
begin
  cmbTo.Items.Clear;
  cmbTo.Items.Add('Admins level 2+');
  cmbTo.Items.Add('All admins');
  cmbTo.Items.Add('Masters and GM''s');
  cmbTo.ItemIndex := -1;
  cmbTo.Text := '';
end;
//==============================================================================
procedure TfCLMessage.FillPersonList;
var
  Index: Integer;
begin
  cmbTo.Items.Clear;
  { Get names list from Notify list }
  if Assigned(fCLNotify) then
    with fCLNotify.clNotify do
      for Index := 0 to Items.Count -1 do
        if cmbTo.Items.IndexOf(Items[Index]) = -1 then
          cmbTo.Items.Add(Items[Index]);

  { Add the names from the senders of messages received. }
  if Assigned(fCLMessages) then
    for Index := 0 to fCLMessages.lvMessages.Items.Count -1 do
      if cmbTo.Items.IndexOf(fCLMessages.lvMessages.Items[Index].Caption) = -1
        then cmbTo.Items.Add(fCLMessages.lvMessages.Items[Index].Caption);

  cmbTo.ItemIndex := -1;
  cmbTo.Text := '';
end;
//==============================================================================
procedure TfCLMessage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fCLMessage := nil;
  Action := caFree;
end;
//==============================================================================
procedure TfCLMessage.FormCreate(Sender: TObject);
begin
  pnlType.Visible := fCLSocket.MyAdminLevel = 3;
  rbPersonClick(nil);
end;
//==============================================================================
procedure TfCLMessage.rbPersonClick(Sender: TObject);
begin
  ArrangePanels;
end;
//==============================================================================
function TfCLMessage.SelectedGroupList: string;
var
  i: integer;
begin
  result := '';
  for i := 0 to pnlGroups.ControlCount - 1 do begin
    if pnlGroups.Controls[i] is TCheckBox and TCheckBox(pnlGroups.Controls[i]).Checked then
      result := result + IntToStr(TCheckBox(pnlGroups.Controls[i]).Tag) + ',';
  end;
  if result <> '' then
    result := copy(result, 1, length(result) - 1);
end;
//==============================================================================
procedure TfCLMessage.rbGroupClick(Sender: TObject);
begin
  ArrangePanels;
end;
//==============================================================================
procedure TfCLMessage.cmbToKeyPress(Sender: TObject; var Key: Char);
begin
  if rbGroup.Checked then Key := #0;
end;
//==============================================================================
end.

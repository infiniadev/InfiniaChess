{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}


unit CLPaymentEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, ComCtrls, CLProfile;

type
  TfCLPaymentEdit = class(TForm)
    Panel5: TPanel;
    Panel10: TPanel;
    SpeedButton3: TSpeedButton;
    Panel11: TPanel;
    sbOk: TSpeedButton;
    cmbRights: TPanel;
    reComments: TRichEdit;
    Label9: TLabel;
    Panel1: TPanel;
    Label10: TLabel;
    lblNameOnCard: TLabel;
    Label11: TLabel;
    lblCardType: TLabel;
    Label13: TLabel;
    lblCardNumber: TLabel;
    pnlEditableData: TPanel;
    Label7: TLabel;
    edtAmountFull: TEdit;
    Label8: TLabel;
    edtAmount: TEdit;
    Label12: TLabel;
    Label14: TLabel;
    lblPromoCode: TLabel;
    lblPromoAmount: TLabel;
    Label5: TLabel;
    cmbRightsLevel: TComboBox;
    lblExpire: TLabel;
    dtExpire: TDateTimePicker;
    Panel3: TPanel;
    lblID: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    lblDate: TLabel;
    lblSubscription_: TLabel;
    lblSubscription: TLabel;
    lblSource_: TLabel;
    lblSource: TLabel;
    Panel4: TPanel;
    Label16: TLabel;
    lblAdminCreated: TLabel;
    Label17: TLabel;
    lblAdminDeleted: TLabel;
    lblTransactionState: TLabel;
    Panel6: TPanel;
    sbState: TSpeedButton;
    procedure sbOkClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbStateClick(Sender: TObject);
    procedure cmbRightsLevelChange(Sender: TObject);
  private
    { Private declarations }
    oldComment: string;
    Login: string;
    Deleted: Boolean;

    procedure SetRightsLevelByID(p_ID: integer);
    function TestInput: Boolean;
    procedure FormatFields;
  public
    { Public declarations }
    procedure Initialize(P: TCLPayment);
    procedure InitNew(p_Login: string);
  end;

var
  fCLPaymentEdit: TfCLPaymentEdit;

implementation

uses CLMembershipType, CLSocket, CLConst, CLLib;

{$R *.DFM}
//===========================================================================
{ TfCLPaymentEdit }

procedure TfCLPaymentEdit.Initialize(P: TCLPayment);
var
  vPromoAmount: Currency;
begin
  Login := P.Login;
  Deleted := P.Deleted;
  lblID.Caption := IntToStr(P.ID);
  lblDate.Caption := FormatDateTime('mm/dd/yyyy hh:nn am/pm', P.TransactionDate);
  lblSubscription.Caption := P.SubscribeTypeName;
  lblSource.Caption := P.SourceTypeName;
  SetRightsLevelByID(P.MembershipType);
  cmbRightsLevel.OnChange(nil);
  dtExpire.Date := P.ExpireDate;
  edtAmountFull.Text := FloatToStr(P.AmountFull);
  edtAmount.Text := FloatToStr(P.Amount);
  lblNameOnCard.Caption := P.NameOnCard;
  lblCardType.Caption := P.CardType;
  lblCardNumber.Caption := '**** ' + P.CardNumber;
  lblPromoCode.Caption := P.PromoCode;

  vPromoAmount := P.AmountFull - P.Amount;
  if vPromoAmount <> 0 then lblPromoAmount.Caption := FloatToStr(vPromoAmount)
  else lblPromoAmount.Caption := '';

  reComments.Text := P.AdminComment;
  oldComment := P.AdminComment;

  lblAdminCreated.Caption := P.AdminCreated;
  lblAdminDeleted.Caption := P.AdminDeleted;

  pnlEditableData.Enabled := not P.Deleted and (P.SourceType <> 1);
  sbOk.Enabled := not P.Deleted and (P.SourceType = 2);

  if P.Deleted then begin
    lblTransactionState.Caption := 'Transaction is deleted';
    lblTransactionState.Font.Color := clPurple;
    sbState.Caption := 'Restore';
  end else begin
    lblTransactionState.Caption := 'Transaction is actual';
    lblTransactionState.Font.Color := clGreen;
    sbState.Caption := 'Delete';
  end;
  FormatFields;
end;
//===========================================================================
procedure TfCLPaymentEdit.sbOkClick(Sender: TObject);
var
  mt: TCLMembershipType;
  vExpire: TDateTime;
begin
  if not TestInput then exit;

  mt := TCLMembershipType(cmbRightsLevel.Items.Objects[cmbRightsLevel.ItemIndex]);
  vExpire := dtExpire.Date;
  {if dtExpire.Visible then vExpire := dtExpire.Date
  else vExpire := StrToDate('01.01.2020');}

  fCLSocket.InitialSend([CMD_STR_TRANSACTION, Login, lblID.Caption, IntToStr(mt.ID),
    FloatToStr(vExpire), edtAmount.Text, edtAmountFull.Text,
    EncryptANSI(reComments.Text)]);
  ModalResult := mrOk;
end;
//===========================================================================
procedure TfCLPaymentEdit.SpeedButton3Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
//===========================================================================
procedure TfCLPaymentEdit.FormCreate(Sender: TObject);
var
  i: integer;
begin
  cmbRightsLevel.Items.Clear;
  for i := 0 to fCLMembershipTypes.Count - 1 do
    cmbRightsLevel.Items.AddObject(fCLMembershipTypes[i].name, fCLMembershipTypes[i]);
end;
//===========================================================================
procedure TfCLPaymentEdit.SetRightsLevelByID(p_ID: integer);
var
  i: integer;
  mt: TCLMembershipType;
begin
  for i := 0 to cmbRightsLevel.Items.Count - 1 do begin
    mt := TCLMembershipType(cmbRightsLevel.Items.Objects[i]);
    if mt.id = p_ID then begin
      cmbRightsLevel.ItemIndex := i;
      exit;
    end;
  end;
  cmbRightsLevel.ItemIndex := -1;
end;
//===========================================================================
procedure TfCLPaymentEdit.sbStateClick(Sender: TObject);
begin
  if not TestInput then exit;

  fCLSocket.InitialSend([CMD_STR_TRANSACTION_STATE, Login, lblID.Caption, BoolTo_(Deleted, 0, 1),
    EncryptANSI(reComments.Text)]);
  ModalResult := mrOk;
end;
//===========================================================================
procedure TfCLPaymentEdit.InitNew(p_Login: string);
begin
  Login := p_Login;
  Deleted := false;
  lblID.Caption := '0';
  lblDate.Caption := FormatDateTime('mm/dd/yyyy hh:nn am/pm', Date + Time);
  lblSubscription.Caption := 'No subscription';
  lblSource.Caption := 'Admin Command';
  cmbRightsLevel.ItemIndex := -1;
  dtExpire.Date := Date;
  edtAmountFull.Text := '0';
  edtAmount.Text := '0';
  lblNameOnCard.Caption := '';
  lblCardType.Caption := '';
  lblCardNumber.Caption := '';
  lblPromoCode.Caption := '';
  lblPromoAmount.Caption := '';

  reComments.Text := '';
  oldComment := '';

  lblAdminCreated.Caption := fCLSocket.MyName;;
  lblAdminDeleted.Caption := '';

  pnlEditableData.Enabled := true;
  lblTransactionState.Caption := 'New Transaction';
  sbState.Enabled := false;
  FormatFields;
end;
//===========================================================================
function TfCLPaymentEdit.TestInput: Boolean;
var
  msg: string;
begin
  if cmbRightsLevel.ItemIndex = -1 then msg := 'Please, choose rights level'
  else if dtExpire.Visible and (dtExpire.DateTime < Date + Time) then msg := 'Please, enter expire date more then current date'
  else if not IsRightNumber(edtAmount.Text) then msg := 'Please, enter correct number to the field "Money Paid"'
  else if not IsRightNumber(edtAmountFull.Text) then msg := 'Please, enter correct number to the field "Full Price"'
  else if reComments.Text = oldComment then msg := 'Please, edit admin comment'
  else msg := '';

  result := msg = '';
  if msg <> '' then MessageDlg(msg, mtError, [mbOk], 0);
end;
//===========================================================================
procedure TfCLPaymentEdit.FormatFields;
begin
  lblSubscription_.Left := lblSubscription.Left - lblSubscription_.Width - 4;
  lblSource_.Left := lblSource.Left - lblSource_.Width - 4;
end;
//===========================================================================
procedure TfCLPaymentEdit.cmbRightsLevelChange(Sender: TObject);
var
  mt: TCLMembershipType;
begin
  mt := TCLMembershipType(cmbRightsLevel.Items.Objects[cmbRightsLevel.ItemIndex]);
  {lblExpire.Visible := not (mt.id in [3,4]);
  dtExpire.Visible := lblExpire.Visible;}
end;
//===========================================================================
end.

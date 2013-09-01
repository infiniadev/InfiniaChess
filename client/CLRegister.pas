{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLRegister;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfCLRegister = class(TForm)
    btnCancel: TButton;
    btnRegister: TButton;
    edtEmail: TEdit;
    edtLogin: TEdit;
    edtPassword1: TEdit;
    edtPassword2: TEdit;
    lblAccount: TLabel;
    lblEmail: TLabel;
    lblInfo: TLabel;
    lblInstruction2: TLabel;
    lblInstruction3: TLabel;
    lblLogin: TLabel;
    lblPassword1: TLabel;
    lblPassword2: TLabel;
    Label1: TLabel;
    cbCountry: TComboBox;
    Label2: TLabel;
    cbSex: TComboBox;
    Label4: TLabel;
    cbLanguage: TComboBox;
    chkShowEmail: TCheckBox;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    cmbDay: TComboBox;
    cmbMonth: TComboBox;
    cmbYear: TComboBox;

    procedure btnCancelClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function Test: Boolean;
    function CurrentBirthday: TDateTime;

  private
    { Private declarations }
  public
    { Public declarations }
    procedure EnableRegister;
    procedure RegisterResult(const FDatapack: TStrings);
    procedure SendRegister;
  end;

var
  fCLRegister: TfCLRegister;

implementation

uses
  CLMain, CLGlobal, CLConst, CLSocket, CLNet, CLLib;

{$R *.DFM}

//______________________________________________________________________________
procedure TfCLRegister.btnCancelClick(Sender: TObject);
begin
  Close;
end;
//______________________________________________________________________________
procedure TfCLRegister.btnRegisterClick(Sender: TObject);
begin
  { Disable controls for visual indication of processing. }
  if not Test then exit;
  
  Cursor := crHourGlass;
  edtLogin.Enabled := False;
  edtPassword1.Enabled := False;
  edtPassword2.Enabled := False;
  edtEmail.Enabled := False;
  //btnCancel.Enabled := False;
  btnRegister.Enabled := False;

  if fCLSocket.InitState = isDisconnect then
    begin
      { Establish a connection to the server. Wait for InitState to change
        then call SendRegister. }
      if DebugHook = 0 then fCLSocket.Account.Server := CHESSLINK_SERVER
      else fCLSocket.Account.Server := '127.0.0.1';
      
      fCLSocket.Account.Port := CHESSLINK_PORT;
      fCLSocket.InitState := isConnect;
    end
  else
    { If already connected then call SendRegister right away. }
    SendRegister;
end;
//______________________________________________________________________________
procedure TfCLRegister.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Disconnect if user not offically logged in. }
  if fCLSocket.MyName = '' then fCLSocket.InitState := isDisconnect;
  Hide;
  fCLRegister := nil;
  Action := caFree;
  { Show the Login dialog if the user successfully registered a login and was
    not already logged in. }
  if (fGL.Accounts.Count > 0) and not(btnRegister.Visible)
  and (fCLSocket.InitState = isDisconnect) then fCLMain.miLogin.Click;
end;
//______________________________________________________________________________
procedure TfCLRegister.EnableRegister;
begin
  { Called if the registration request was invalid, lets the user try again. }
  Cursor := crDefault;
  edtLogin.Enabled := btnRegister.Visible;
  edtPassword1.Enabled := btnRegister.Visible;
  edtPassword2.Enabled := btnRegister.Visible;
  edtEmail.Enabled := btnRegister.Visible;
  //btnCancel.Enabled := btnRegister.Visible;
  btnRegister.Enabled := btnRegister.Visible;
end;
//______________________________________________________________________________
procedure TfCLRegister.RegisterResult(const FDatapack: TStrings);
begin
  { Called from CLCLS when a request result is sent from the server. }
  lblInfo.Caption := FDatapack[2];
  { If successful}
  if StrToInt(FDatapack[1]) = DP_CODE_REGISTER_SUCCESS then
    begin
      Cursor := crDefault;
      btnRegister.Visible := False;
      btnCancel.Caption := 'Close';
    end
  else
    EnableRegister;
end;
//______________________________________________________________________________
procedure TfCLRegister.SendRegister;
var
  s: string;
begin
  { Send the Regisster request. }
  lblInfo.Caption := 'Verifying Request...';
  s := CLNet.GetMACAdress;
  fCLSocket.InitialSend([CMD_STR_REGISTER, edtLogin.Text, edtPassword1.Text,
    edtEmail.Text, s,
    IntToStr(cbCountry.ItemIndex),
    IntToStr(cbSex.ItemIndex),
    '0',
    cbLanguage.Text,
    BoolTo_(chkShowEmail.Checked,'1','0'),
    IntToStr(Trunc(CurrentBirthday))
    ]);
end;
//______________________________________________________________________________
procedure TfCLRegister.FormPaint(Sender: TObject);
begin
  with Canvas do
    begin
      Brush.Color := clWhite;
      Pen.Color := clWhite;
      Rectangle(0, 0, Width, lblAccount.Height);
    end;
end;
//______________________________________________________________________________
procedure TfCLRegister.FormCreate(Sender: TObject);
var
  i: integer;
  y, m, d: word;
begin
  cbLanguage.ItemIndex := 10; // english
  cmbDay.Items.Clear;
  for i := 1 to 31 do
    cmbDay.Items.Add(IntToStr(i));

  DecodeDate(Date,y,m,d);
  cmbYear.Items.Clear;
  for i := y - 6 downto 1900 do
    cmbYear.Items.Add(IntToStr(i));
  {if DebugHook = 1 then begin
    edtLogin.Text:='test1';
    edtPassword1.Text:='qwerty';
    edtPassword2.Text:='qwerty';
    edtEmail.Text:='urise@mail.ru';
  end;}
end;
//______________________________________________________________________________
function TfCLRegister.Test: Boolean;
var
  msg: string;
begin
  msg := '';
  if length(trim(edtLogin.Text)) < 3 then
    msg := 'Login must consist of at least 3 characters'
  else if length(trim(edtPassword1.Text)) < 6 then
    msg := 'Password must consist of at least 6 characters'
  else if Trim(edtPassword1.Text) <> Trim(edtPassword2.Text) then
    msg := 'Passwords are different in "password" and "confirm password" fields'
  else if (Length(Trim(edtEmail.Text)) < 6) or (pos('@',edtEmail.Text) = 0) then
    msg := 'You must enter legal email'
  else if cbCountry.ItemIndex = -1 then
    msg := 'Country is not defined'
  else if cbSex.ItemIndex = -1 then
    msg := 'Sex is not defined'
  else if (cmbYear.ItemIndex = -1) or (cmbMonth.ItemIndex = -1) or (cmbDay.ItemIndex = -1) then
    msg := 'Birthday is not defined'
  else if CurrentBirthday = 0 then
    msg := 'Birthday is not legal date';

  if msg <> '' then
    MessageDlg(msg, mtError, [mbOk], 0);

  result := msg = '';
end;
//______________________________________________________________________________
function TfCLRegister.CurrentBirthday: TDateTime;
begin
  result := GetOptionsDate(StrToInt(cmbYear.Text),cmbMonth.ItemIndex + 1, cmbDay.ItemIndex + 1);
end;
//______________________________________________________________________________
end.

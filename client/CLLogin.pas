{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLLogin;

interface

uses
  Classes, Forms, Controls, StdCtrls, Graphics, ExtCtrls, Windows, Sysutils,
  jpeg, Buttons;

type
  TfCLLogin = class(TForm)
    btnCancel: TButton;
    btnLogin: TButton;
    cbLogin: TComboBox;
    edtPassword: TEdit;
    lblInfo: TLabel;
    lblLogin: TLabel;
    lblPassword: TLabel;
    cbRemember: TCheckBox;
    btnForgot: TBitBtn;
    Image1: TImage;
    Label1: TLabel;

    procedure btnCancelClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure cbLoginChange(Sender: TObject);
    procedure edtPasswordChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure btnForgotClick(Sender: TObject);

  private
    { Private declarations }
    OldRemember: Boolean;
    OldPassword: string;
  public
    { Public declarations }
    ButtonPressed: integer; // 0 - login, 1 - forgot password
    procedure EnableLogin;
    procedure AskAuthKey(email: string);
    procedure AuthKeyResult(res: integer; msg: string);
  end;

var
  fCLLogin: TfCLLogin;

implementation

uses
  CLConst, CLGlobal, CLSocket, CLAuthKey, CLMain;

{$R *.DFM}
//______________________________________________________________________________
procedure TfCLLogin.btnCancelClick(Sender: TObject);
begin
  { Canceling a login, close the socket and then the form. }
  CURRENT_PASSWORD := '';
  fCLSocket.InitState := isDisconnect;
  Close;
end;
//______________________________________________________________________________
procedure TfCLLogin.btnLoginClick(Sender: TObject);
var
  account: TAccount;
begin
  { Give visual indication, set fSocket property, initiate login. }
  Cursor := crHourGlass;
  cbLogin.Enabled := False;
  edtPassword.Enabled := False;
  btnLogin.Enabled := False;
  account:=TAccount(cbLogin.Items.Objects[cbLogin.ItemIndex]);
  fCLSocket.Account := account;
  fCLSocket.Account.Password := edtPassword.Text;

  if (OldRemember<>cbRemember.Checked) or (OldPassword<>edtPassword.Text) then begin
    if cbRemember.Checked then account.Password:=edtPassword.Text
    else account.Password:='';

    fGL.RememberPassword:=cbRemember.Checked;
    fGL.Save;
  end;

  if (Sender as TComponent).Name = 'btnLogin' then ButtonPressed:=0
  else ButtonPressed:=1;
  CURRENT_PASSWORD := edtPassword.Text;
  fCLSocket.InitState := isConnect;
end;
//______________________________________________________________________________
procedure TfCLLogin.cbLoginChange(Sender: TObject);
begin
  { Change the Password when the Login changes. }
  edtPassword.Text :=
    TAccount(cbLogin.Items.Objects[cbLogin.ItemIndex]).Password;
end;
//______________________________________________________________________________
procedure TfCLLogin.edtPasswordChange(Sender: TObject);
begin
  { Enable the Login button only if there's a passsword entered. }
  btnLogin.Enabled := (Trim(edtPassword.Text) <> '')
    and (cbLogin.ItemIndex > -1);
end;
//______________________________________________________________________________
procedure TfCLLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fCLLogin := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLLogin.FormCreate(Sender: TObject);
var
  Account: TAccount;
  Index: Integer;
  y, m, d: word;
begin
  { Load all the accounts from fGL into the combobox. }
  for Index := 0 to fGL.Accounts.Count -1 do
    begin
      Account := TAccount(fGL.Accounts[Index]);
      cbLogin.Items.AddObject(Account.Name, Account);
    end;
  { Set the ItemIndex, call cbLoginChange to force the password to populate. }
  if cbLogin.Items.Count > 0 then
    begin
      cbLogin.ItemIndex := 0;
      cbLoginChange(nil);
    end;
  cbRemember.Checked:=fGL.RememberPassword;
  OldRemember:=cbRemember.Checked;
  OldPassword:=edtPassword.Text;

  DecodeDate(Date, y, m, d);
  //imgChristmas.Visible := (m = 12) and (d >= 23) or (m = 1) and (d <= 2);
  //imgMain.Visible := not imgChristmas.Visible;


end;
//______________________________________________________________________________
procedure TfCLLogin.FormPaint(Sender: TObject);
begin
  { Draw the white heading. }
  with Canvas do
    begin
      Brush.Color := clWhite;
      Pen.Color := clWhite;
      Rectangle(0, 0, Width, 33);
    end;

end;
//______________________________________________________________________________
procedure TfCLLogin.EnableLogin;
begin
  { Called from fSocket.SetInitState if/when a login fails. }
  Cursor := crDefault;
  cbLogin.Enabled := True;
  edtPassword.Enabled := True;
  btnLogin.Enabled := (Trim(edtPassword.Text) <> '')
    and (cbLogin.ItemIndex > -1);
end;
//______________________________________________________________________________
procedure TfCLLogin.AskAuthKey(email: string);
var
  F: TfCLAuthKey;
begin
  F:=TfCLAuthKey.Create(Application);
  F.edEmail.Text:=email;
  if F.ShowModal = mrOk then begin
    if F.ButtonPressed=0 then
      fCLSocket.InitialSend([CMD_STR_AUTH_KEY,cbLogin.Text,edtPassword.Text,F.edKey.Text])
    else
      fCLSocket.InitialSend([CMD_STR_AUTH_KEY_REQ,cbLogin.Text,edtPassword.Text,F.edEmail.Text]);
  end;
  F.Free;
  //Cursor := crDefault;
end;
//______________________________________________________________________________
procedure TfCLLogin.AuthKeyResult(res: integer; msg: string);
begin
  lblInfo.Caption:=msg;
  fCLSocket.InitState:=isDisconnect;
  Cursor := crDefault;
  btnLogin.Enabled:=true;
  cbLogin.Enabled:=true;
  edtPassword.Enabled:=true;
end;
//______________________________________________________________________________
procedure TfCLLogin.btnForgotClick(Sender: TObject);
begin
end;
//______________________________________________________________________________
end.



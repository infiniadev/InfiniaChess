{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLAccount;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CLGlobal, ComCtrls;

type
  TfCLAccount = class(TForm)  
    btnCancel: TButton;
    btnOK: TButton;
    cbServer: TComboBox;
    edtCommands: TEdit;
    edtLogin: TEdit;
    edtName: TEdit;
    edtPassword: TEdit;
    edtPort: TEdit;
    lbCommands: TLabel;
    lblAccountEdit: TLabel;
    lblLogin: TLabel;
    lblName: TLabel;
    lbPassword: TLabel;
    lbPort: TLabel;
    lbServer: TLabel;
    udPort: TUpDown;
    cbRemember: TCheckBox;

    procedure btnOKClick(Sender: TObject);
    procedure ControlChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbRememberClick(Sender: TObject);

  private
    { Private declarations }
    FAccount: TAccount;
    FIsNew: Boolean;

  public
    { Public declarations }
    procedure LoadAccount(Account: TAccount);

    property IsNew: Boolean read FIsNew write FIsNew;
  end;

var
  fCLAccount: TfCLAccount;

implementation

uses CLAccounts, CLOptions, CLMain;

{$R *.DFM}

//______________________________________________________________________________
procedure TfCLAccount.LoadAccount(Account: TAccount);
begin
  FAccount := Account;
  with Account do
    begin
      edtName.Text := Name;
      edtLogin.Text := Login;
      edtPassword.Text := Password;
      cbServer.Text := Server;
      udPort.Position := Port;
      { Removed for now. edtProxy.Text := Proxy; }
      edtCommands.Text := Command;
    end;
//  ControlChanged;
end;
//______________________________________________________________________________
procedure TfCLAccount.btnOKClick(Sender: TObject);
begin
  with FAccount do
    begin
      Name := Trim(edtName.Text);
      Login := Trim(edtLogin.Text);
      Password := Trim(edtPassword.Text);
      Server := Trim(cbServer.Text);
      Port := StrToInt(edtPort.Text);
      {Removed for now. Proxy := edtProxy.Text; }
      Command := Trim(edtCommands.Text);
    end;
  { Only if the Options form is NOT displayed. }
  if fCLOptions = nil then
    begin
      fGL.Accounts.Add(FAccount);
      fGL.Save;
      Hide;
      fCLMain.miLogin.Click;
    end;
end;
//______________________________________________________________________________
procedure TfCLAccount.ControlChanged(Sender: TObject);
begin
  btnOK.Enabled := (Trim(edtName.Text) <> '')
    and (Trim(edtLogin.Text) <> '') and
    ((Trim(edtPassword.Text) <> '') or not cbRemember.Checked)
    and (Trim(cbServer.Text) <> '') and (Trim(edtPort.Text) <> '');
end;
//______________________________________________________________________________
procedure TfCLAccount.FormCreate(Sender: TObject);
begin
  FAccount := nil;
  FIsNew := False;
  SetWindowLong(edtPort.Handle, GWL_STYLE,
    GetWindowLong(edtPort.Handle, GWL_STYLE) or ES_NUMBER);
end;
//______________________________________________________________________________
procedure TfCLAccount.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fCLAccount := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLAccount.FormPaint(Sender: TObject);
begin
  with Canvas do
    begin
      Brush.Color := clWhite;
      Pen.Color := clWhite;
      Rectangle(0, 0, Width, lblAccountEdit.Height);
    end;
end;
//______________________________________________________________________________
procedure TfCLAccount.btnCancelClick(Sender: TObject);
begin
  if IsNew then FAccount.Free;
end;
//______________________________________________________________________________
procedure TfCLAccount.cbRememberClick(Sender: TObject);
begin
  edtPassword.Enabled:=cbRemember.Checked;
  if not cbRemember.Checked then
    edtPassword.Clear;
end;
//______________________________________________________________________________
end.

{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}


unit CLPassword;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfCLPassword = class(TForm)
    edtOldPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtNewPassword: TEdit;
    Label3: TLabel;
    edtNewPassword2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCLPassword: TfCLPassword;

implementation

uses CLConst;

{$R *.DFM}
//=========================================================================
procedure TfCLPassword.BitBtn1Click(Sender: TObject);
var
  msg: string;
begin
  if edtOldPassword.Text = '' then msg:='Enter old password'
  else if edtOldPassword.Text <> CURRENT_PASSWORD then msg:='You entered incorrect old password'
  else if edtNewPassword.Text = '' then msg:='Enter new password'
  else if edtNewPassword.Text <> edtNewPassword2.Text then msg:='New passwords does not match'
  else if length(edtNewPassword.Text)<6 then msg:='New password must be at least 6 symbols length'
  else if length(edtNewPassword.Text)>15 then msg:='New password must not be greater then 15 symbols lengths'
  else msg:='';

  if msg<>'' then MessageDlg(msg,mtError,[mbOk],0)
  else ModalResult := mrOk;
end;
//=========================================================================
end.

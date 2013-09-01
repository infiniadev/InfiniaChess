{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLAccounts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI;

type
  TfCLAccounts = class(TForm)
    btnCancel: TButton;
    bntNext: TButton;
    lblAccounts: TLabel;
    rbExisting: TRadioButton;
    rbNew: TRadioButton;

    procedure bntNextClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses CLGlobal, CLAccount, CLRegister, CLMain;

{$R *.DFM}

//______________________________________________________________________________
procedure TfCLAccounts.bntNextClick(Sender: TObject);
 var
  Account: TAccount;
begin
  Hide;
  if rbExisting.Checked then
    begin
      Account := TAccount.Create;
      fCLAccount := TfCLAccount.Create(nil);
      with fCLAccount do
        begin
          IsNew := True;
          LoadAccount(Account);
          ShowModal;
        end;
    end
  else
    begin
      ShellExecute(Handle, 'open', PChar('http://www.perpetualchess.com'), '', '', SW_SHOWNORMAL);
  exit;
      //fCLRegister := TfCLRegister.Create(nil);
      //fCLRegister.ShowModal;
    end;
end;
//______________________________________________________________________________
procedure TfCLAccounts.FormPaint(Sender: TObject);
begin
  with Canvas do
    begin
      Brush.Color := clWhite;
      Pen.Color := clWhite;
      Rectangle(0, 0, Width, lblAccounts.Height);
    end;
end;
//______________________________________________________________________________
end.

{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLAuthKey;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls, Buttons;

type
  TfCLAuthKey = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    pnlEmail: TPanel;
    Label1: TLabel;
    edKey: TEdit;
    btnOk: TBitBtn;
    btnAdditional: TBitBtn;
    lblEmail: TLabel;
    edEmail: TEdit;
    btnEmail: TBitBtn;
    procedure btnAdditionalClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnEmailClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ButtonPressed: integer; // 0 - okey, 1 - send
  end;

var
  fCLAuthKey: TfCLAuthKey;

implementation

uses CLMain;

{$R *.DFM}
//==============================================================================
procedure TfCLAuthKey.btnAdditionalClick(Sender: TObject);
var
  b: Boolean;
begin
  btnAdditional.Tag:=1-btnAdditional.Tag;

  b:=btnAdditional.Tag=1;
  pnlEmail.Visible:=b;

  if b then btnAdditional.Caption:='<< Additional'
  else btnAdditional.Caption:='Additional >>';
end;
//==============================================================================
procedure TfCLAuthKey.btnOkClick(Sender: TObject);
begin
  ButtonPressed:=0;
  ModalResult:=mrOk;
end;
//==============================================================================
procedure TfCLAuthKey.btnEmailClick(Sender: TObject);
begin
  ButtonPressed:=1;
  ModalResult:=mrOk;
end;
//==============================================================================
end.

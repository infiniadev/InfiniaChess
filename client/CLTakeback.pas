{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLTakeback;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfCLTakeback = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    edtOther: TEdit;
    lblRequest: TLabel;
    rbOneAndOneHalf: TRadioButton;
    rbOneHalf: TRadioButton;
    rbOther: TRadioButton;
    rbTwo: TRadioButton;
    rbOne: TRadioButton;

    procedure edtOtherChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButtonClick(Sender: TObject);
    procedure rbOtherClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetMoves: string;
  end;

var
  fCLTakeback: TfCLTakeback;

implementation

{$R *.DFM}

uses CLMain;
//______________________________________________________________________________
function TfCLTakeback.GetMoves: string;
begin
  if rbOneHalf.Checked then Result := '1';
  if rbOne.Checked then Result := '2';
  if rbOneAndOneHalf.Checked then Result := '3';
  if rbTwo.Checked then Result := '4';
  if rbOther.Checked then Result := edtOther.Text;
end;
//______________________________________________________________________________
procedure TfCLTakeback.edtOtherChange(Sender: TObject);
begin
  rbOther.Checked := True;
  btnOK.Enabled := edtOther.Text <> '';
end;
//______________________________________________________________________________
procedure TfCLTakeback.FormCreate(Sender: TObject);
begin
  { Set edit boxes to accept only 0..9 }
  SetWindowLong(edtOther.Handle, GWL_STYLE,
    GetWindowLong(edtOther.Handle, GWL_STYLE) or ES_NUMBER);
end;
//______________________________________________________________________________
procedure TfCLTakeback.RadioButtonClick(Sender: TObject);
begin
 edtOther.Text := '';
 btnOK.Enabled := True;
end;
//______________________________________________________________________________
procedure TfCLTakeback.rbOtherClick(Sender: TObject);
begin
  btnOK.Enabled := False;
end;
//______________________________________________________________________________
end.

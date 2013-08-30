unit CLClubNew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TfClubNew = class(TForm)
    pnlButtons: TPanel;
    Panel11: TPanel;
    sbOk: TSpeedButton;
    pnlCancel: TPanel;
    SpeedButton3: TSpeedButton;
    Panel1: TPanel;
    edId: TEdit;
    lblID: TLabel;
    chkAuto: TCheckBox;
    udID: TUpDown;
    edName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cmbType: TComboBox;
    procedure chkAutoClick(Sender: TObject);
    procedure sbOkClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function CurrentID: integer;
  end;

var
  fClubNew: TfClubNew;

implementation

uses CLClubList;

{$R *.DFM}
//============================================================================
procedure TfClubNew.chkAutoClick(Sender: TObject);
begin
  lblID.Visible := not chkAuto.Checked;
  edID.Visible := not chkAuto.Checked;
  udID.Visible := not chkAuto.Checked;
end;
//============================================================================
function TfClubNew.CurrentID: integer;
begin
  if chkAuto.Checked then result := -1
  else result := udID.Position;
end;
//============================================================================
procedure TfClubNew.sbOkClick(Sender: TObject);
begin
  if trim(edName.Text) = '' then MessageDlg('Name is not defined!',mtError,[mbOk],0)
  else if udID.Visible and udID.Enabled {and fCLClubList.IDisBusy(udID.Position) }then
    MessageDlg('This number is defined for another club!',mtError,[mbOk],0)
  else if cmbType.ItemIndex = -1 then
    MessageDlg('Club type is not defined!',mtError,[mbOk],0)
  else ModalResult := mrOk;
end;
//============================================================================
procedure TfClubNew.SpeedButton3Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
//============================================================================
end.

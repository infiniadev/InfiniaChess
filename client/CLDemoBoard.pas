unit CLDemoBoard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfCLDemoBoard = class(TForm)
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    Panel2: TPanel;
    Label4: TLabel;
    edBlack: TEdit;
    Label5: TLabel;
    cmbBlackTitle: TComboBox;
    Label6: TLabel;
    edBlackRating: TEdit;
    Panel3: TPanel;
    Label1: TLabel;
    edWhite: TEdit;
    Label3: TLabel;
    cmbWhiteTitle: TComboBox;
    Label2: TLabel;
    edWhiteRating: TEdit;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fCLDemoBoard: TfCLDemoBoard;

implementation

uses CLMain;

{$R *.DFM}
//=============================================================================
procedure TfCLDemoBoard.SpeedButton1Click(Sender: TObject);
begin
  if edBlack.Text='' then raise exception.create('Enter name of black player');
  if edWhite.Text='' then raise exception.create('Enter name of white player');
  if edBlackRating.Text<>'' then
    try
      StrToInt(edBlackRating.Text);
    except
      raise exception.create('Black rating is incorrect');
    end;
  if edWhiteRating.Text<>'' then
    try
      StrToInt(edWhiteRating.Text);
    except
      raise exception.create('White rating is incorrect');
    end;
  ModalResult:=mrOk;
end;
//=============================================================================
end.

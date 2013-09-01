{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLSeek;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls,
  IniFiles, ComCtrls, Graphics, Dialogs, Buttons;

type
  TSeekMode = (smSeek, smMatch);

  TfCLSeek = class(TForm)
    Panel1: TPanel;
    lblStyle: TLabel;
    cbGameType: TComboBox;
    lblRated: TLabel;
    pnlColor: TPanel;
    rbWhite: TRadioButton;
    rbBlack: TRadioButton;
    rbServer: TRadioButton;
    lblColor: TLabel;
    lblMin: TLabel;
    edtMin: TEdit;
    udMin: TUpDown;
    lblMax: TLabel;
    edtMax: TEdit;
    udMax: TUpDown;
    pnlRated: TPanel;
    rbRated: TRadioButton;
    rbUnrated: TRadioButton;
    Panel2: TPanel;
    lblAutoTimeOdds: TLabel;
    chkTimeOdds: TCheckBox;
    pnlTimeOdds: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    edtOddsInitMin: TEdit;
    udOddsInitMin: TUpDown;
    edtOddsInitSec: TEdit;
    udOddsInitSec: TUpDown;
    edtOddsInc: TEdit;
    udOddsInc: TUpDown;
    Panel3: TPanel;
    cmbPieceOdds: TComboBox;
    chkPieceOdds: TCheckBox;
    Panel4: TPanel;
    btnIssue: TButton;
    btnCancel: TButton;
    pnlPieceOddsDirection: TPanel;
    rbPieceOddsGive: TRadioButton;
    rbPieceOddsAsk: TRadioButton;
    lblSeek: TLabel;
    lblInital: TLabel;
    edtInitial: TEdit;
    udInitial: TUpDown;
    lblInc: TLabel;
    edtInc: TEdit;
    udInc: TUpDown;
    Label2: TLabel;
    edtInitSec: TEdit;
    udInitSec: TUpDown;
    Label6: TLabel;
    sbTimeChange: TSpeedButton;
    lblOpponent: TLabel;
    edtOpponent: TEdit;
    procedure btnIssueClick(Sender: TObject);
    procedure ControlKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure TimeControlChange(Sender: TObject);
    procedure TimeControlChanging(Sender: TObject; var AllowChange: Boolean);
    procedure SetEnabled;
    procedure rbRatedClick(Sender: TObject);
    procedure chkPieceOddsClick(Sender: TObject);
    procedure chkTimeOddsClick(Sender: TObject);
    procedure sbTimeChangeClick(Sender: TObject);
    private
    FSeekMode: TSeekMode;
    procedure SetSeekMode(const Value: TSeekMode);
    { Private declarations }

  public
    { Public declarations }
    property SeekMode: TSeekMode read FSeekMode write SetSeekMode;
  end;

var
  fCLSeek: TfCLSeek;

implementation

{$R *.DFM}
uses
  CLCLS, CLConst, CLGlobal, CLSocket, CLLib, CLMain, CLRating;

//______________________________________________________________________________
procedure TfCLSeek.btnIssueClick(Sender: TObject);
var
  s, InitTime, IncTime, OddsInitMin, OddsInitSec, OddsInc, RatedType: string;
begin

  if chkTimeOdds.Checked and rbUnrated.Checked then begin
    if udOddsInitSec.Position = 0 then InitTime := edtOddsInitMin.Text
    else InitTime := '0.' + IntToStr(udOddsInitMin.Position * 60 + udOddsInitSec.Position);

    IncTime := edtOddsInc.Text;
    OddsInitMin := edtInitial.Text;
    OddsInitSec := edtInitSec.Text;
    OddsInc := edtInc.Text;
  end else begin
    if udInitSec.Position = 0 then InitTime := edtInitial.Text
    else InitTime := '0.' + IntToStr(udInitial.Position * 60 + udInitSec.Position);

    IncTime := edtInc.Text;
    OddsInitMin := '-1';
    OddsInitSec := '-1';
    OddsInc := '-1';
  end;

  if cbGameType.ItemIndex=0 then RatedType:='0'
  else RatedType:=IntToStr(cbGameType.ItemIndex+2);

  if SeekMode = smSeek then
    fCLSocket.InitialSend([CMD_STR_SEEK,InitTime,IncTime,
      BoolTo_(rbRated.Checked,'1','0'),
      RatedType,
      BoolTo_(rbWhite.Checked,'1',BoolTo_(rbBlack.Checked,'-1','0')),
      IntToStr(udMin.Position),
      IntToStr(udMax.Position),
      BoolTo_(fGL.CReject,'1','0'),
      BoolTo_(chkTimeOdds.Checked and rbRated.Checked,'1','0'),
      OddsInitMin, OddsInitSec, OddsInc,
      IntToStr(cmbPieceOdds.ItemIndex),
      '0', //BoolTo_(rbTimeOddsGive.Checked, '0', '1'),
      BoolTo_(rbPieceOddsGive.Checked, '0', '1')
      ])
  else
    fCLSocket.InitialSend([CMD_STR_MATCH, edtOpponent.Text, InitTime, IncTime,
      BoolTo_(rbRated.Checked,'1','0'),
      RatedType,
      BoolTo_(rbWhite.Checked,'1',BoolTo_(rbBlack.Checked,'-1','0')),
      BoolTo_(chkTimeOdds.Checked and rbRated.Checked, '1', '0'),
      OddsInitMin, OddsInitSec, OddsInc,
      IntToStr(cmbPieceOdds.ItemIndex),
      '0',
      BoolTo_(rbPieceOddsGive.Checked, '0', '1')
    ]);

end;
//______________________________________________________________________________
procedure TfCLSeek.ControlKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #8, #45, #48..#57:;
  else
    Key := #0;
  end;
end;
//______________________________________________________________________________
procedure TfCLSeek.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fCLSeek := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLSeek.FormCreate(Sender: TObject);
var
  initmin,initsec,dim: integer;
begin
  TimeToComponents(fGL.SeekInitial,initmin,initsec,dim);
  udInitial.Position:=initmin;
  udInitSec.Position := initsec;
  udInc.Position := fGL.SeekInc;
  if fGL.SeekType < 3 then
    cbGameType.ItemIndex := 0
  else
    cbGameType.ItemIndex := fGL.SeekType - 2;
  rbRated.Checked := fGL.SeekRated;
  rbUnrated.Checked := not fGL.SeekRated;
  rbWhite.Checked := fGL.SeekColor = 1;
  rbBlack.Checked := fGL.SeekColor = -1;
  rbServer.Checked := fGL.SeekColor = 0;
  udMin.Position := fGL.SeekMinimum;
  udMax.Position := fGL.SeekMaximum;
  SetEnabled;

  btnIssue.Enabled := Assigned(fCLCLS);
end;
//______________________________________________________________________________
procedure TfCLSeek.FormPaint(Sender: TObject);
begin
  with Canvas do
    begin
      Brush.Color := clWhite;
      Pen.Color := clWhite;
      Rectangle(0, 0, Width, lblSeek.Height);
    end;
end;
//______________________________________________________________________________
procedure TfCLSeek.SetEnabled;
begin
  if rbRated.Checked then
    rbServer.Checked:=true;
  rbWhite.Enabled:=not rbRated.Checked;
  rbBlack.Enabled:=not rbRated.Checked;
  rbServer.Enabled:=not rbRated.Checked;

  lblAutoTimeOdds.Visible := rbRated.Checked;
  chkPieceOdds.Enabled := rbUnrated.Checked;
  if rbRated.Checked then chkPieceOdds.Checked := false;
  pnlTimeOdds.Visible := chkTimeOdds.Checked and rbUnrated.Checked;
  edtOddsInitMin.Enabled := chkTimeOdds.Checked;
  udOddsInitMin.Enabled := chkTimeOdds.Checked;
  edtOddsInitSec.Enabled := chkTimeOdds.Checked;
  udOddsInitSec.Enabled := chkTimeOdds.Checked;
  edtOddsInc.Enabled := chkTimeOdds.Checked;
  udOddsInc.Enabled := chkTimeOdds.Checked;

  //pnlTimeOddsDirection.Visible := chkTimeOdds.Checked and rbUnrated.Checked;
  pnlPieceOddsDirection.Visible := chkPieceOdds.Checked;
  cmbPieceOdds.Visible := chkPieceOdds.Checked;
  sbTimeChange.Visible := pnlTimeOdds.Visible;

end;
//______________________________________________________________________________
procedure TfCLSeek.TimeControlChange(Sender: TObject);
begin
  Caption :=
    RATED_TYPES[Ord(TimeToRatedType(udInitial.Position, udInc.Position))];
end;
//______________________________________________________________________________
procedure TfCLSeek.TimeControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  TimeControlChange(nil);
end;
//______________________________________________________________________________
procedure TfCLSeek.rbRatedClick(Sender: TObject);
begin
  SetEnabled;
end;
//______________________________________________________________________________
procedure TfCLSeek.chkPieceOddsClick(Sender: TObject);
begin
  cmbPieceOdds.ItemIndex := BoolTo_(chkPieceOdds.Checked,0,-1);
  SetEnabled;
end;
//______________________________________________________________________________
procedure TfCLSeek.chkTimeOddsClick(Sender: TObject);
var
  sec: integer;
  msg: string;
begin
  if rbRated.Checked and chkTimeOdds.Checked then begin
    {if cbDimension.ItemIndex = 0 then sec := udInitial.Position * 60
    else sec := udInitial.Position;}

    if fTimeOddsLimits.GetLimit(udInitial.Position * 60 + udInitSec.Position, udInc.Position) = nil then begin
      chkTimeOdds.Checked := false;
      msg := 'You cannot play nonstandard rated time odds game.'+#13#10;
      msg := msg + 'Available game types: '+fTimeOddsLimits.GetMessageList;
      MessageDlg(msg, mtError, [mbOk], 0);
      exit;
    end;
  end;
  SetEnabled;

  if pnlTimeOdds.Visible then begin
    udOddsInitMin.Position := udInitial.Position;
    udOddsInitSec.Position := udInitSec.Position;
    udOddsInc.Position := udInc.Position;
  end;
end;
//______________________________________________________________________________
procedure TfCLSeek.sbTimeChangeClick(Sender: TObject);
var
  initMin, initSec, Inc: integer;
begin
  initMin := udOddsInitMin.Position;
  initSec := udOddsInitSec.Position;
  Inc := udOddsInc.Position;
  udOddsInitMin.Position := udInitial.Position;
  udOddsInitSec.Position := udInitSec.Position;
  udOddsInc.Position := udInc.Position;
  udInitial.Position := InitMin;
  udInitSec.Position := InitSec;
  udInc.Position := Inc;
end;
//______________________________________________________________________________
procedure TfCLSeek.SetSeekMode(const Value: TSeekMode);
var
  b: Boolean;
begin
  FSeekMode := Value;

  b := FSeekMode = smSeek;

  lblSeek.Visible := b;
  lblMin.Visible := b;
  lblMax.Visible := b;
  edtMin.Visible := b;
  edtMax.Visible := b;
  udMin.Visible := b;
  udMax.Visible := b;
  lblOpponent.Visible := not b;
  edtOpponent.Visible := not b;
end;
//______________________________________________________________________________
end.

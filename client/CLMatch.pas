{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLMatch;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls,
  IniFiles, ComCtrls, Graphics, Dialogs;

type
  TfCLMatch = class(TForm)
    lblMatch: TLabel;
    Panel3: TPanel;
    btnIssue: TButton;
    btnCancel: TButton;
    Panel4: TPanel;
    lblOpponent: TLabel;
    edtOpponent: TEdit;
    lblInital: TLabel;
    edtInitial: TEdit;
    udInitial: TUpDown;
    cbDimension: TComboBox;
    lblInc: TLabel;
    edtInc: TEdit;
    udInc: TUpDown;
    lblInc2: TLabel;
    lblStyle: TLabel;
    cbGameType: TComboBox;
    lblRated: TLabel;
    pnlRated: TPanel;
    rbRated: TRadioButton;
    rbUnrated: TRadioButton;
    lblColor: TLabel;
    pnlColor: TPanel;
    rbWhite: TRadioButton;
    rbBlack: TRadioButton;
    rbServer: TRadioButton;
    Panel1: TPanel;
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
    Panel2: TPanel;
    cmbPieceOdds: TComboBox;
    chkPieceOdds: TCheckBox;
    pnlTimeOddsDirection: TPanel;
    rbTimeOddsGive: TRadioButton;
    rbTimeOddsAsk: TRadioButton;
    pnlPieceOddsDirection: TPanel;
    rbPieceOddsGive: TRadioButton;
    rbPieceOddsAsk: TRadioButton;

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

    private
    { Private declarations }
    public
    { Public declarations }
  end;

var
  fCLMatch: TfCLMatch;

implementation

{$R *.DFM}
uses
  CLCLS, CLConst, CLGlobal, CLSocket, CLLib, CLMain, CLRating;

//______________________________________________________________________________
procedure TfCLMatch.btnIssueClick(Sender: TObject);
var
  s,InitTime,RatedType: string;
begin
  if cbDimension.ItemIndex=0 then InitTime:=edtInitial.Text
  else InitTime:='0.'+edtInitial.Text;

  if cbGameType.ItemIndex=0 then RatedType:='0'
  else RatedType:=IntToStr(cbGameType.ItemIndex+2);

  fCLSocket.InitialSend([CMD_STR_MATCH,edtOpponent.Text,InitTime,edtInc.Text,
    BoolTo_(rbRated.Checked,'1','0'),
    RatedType,
    BoolTo_(rbWhite.Checked,'1',BoolTo_(rbBlack.Checked,'-1','0')),
    BoolTo_(chkTimeOdds.Checked and rbRated.Checked, '1', '0'),
    BoolTo_(chkTimeOdds.Checked, edtOddsInitMin.Text, '-1'),
    BoolTo_(chkTimeOdds.Checked, edtOddsInitSec.Text, '-1'),
    BoolTo_(chkTimeOdds.Checked, edtOddsInc.Text, '-1'),
    IntToStr(cmbPieceOdds.ItemIndex),
    BoolTo_(rbTimeOddsGive.Checked, '0', '1'),
    BoolTo_(rbPieceOddsGive.Checked, '0', '1')
  ]);
end;
//______________________________________________________________________________
procedure TfCLMatch.ControlKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #8, #45, #48..#57:;
  else
    Key := #0;
  end;
end;
//______________________________________________________________________________
procedure TfCLMatch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fCLMatch := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLMatch.FormCreate(Sender: TObject);
var
  InitTime,Index: integer;
begin
  TimeToComponents(fGL.SeekInitial,inittime,index);
  udInitial.Position:=inittime;
  cbDimension.ItemIndex:=index;
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
  SetEnabled;

  btnIssue.Enabled := Assigned(fCLCLS);
end;
//______________________________________________________________________________
procedure TfCLMatch.FormPaint(Sender: TObject);
begin
  with Canvas do
    begin
      Brush.Color := clWhite;
      Pen.Color := clWhite;
      Rectangle(0, 0, Width, lblMatch.Height);
    end;
end;
//______________________________________________________________________________
procedure TfCLMatch.SetEnabled;
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

  pnlTimeOddsDirection.Visible := chkTimeOdds.Checked and rbUnrated.Checked;
  pnlPieceOddsDirection.Visible := chkPieceOdds.Checked;
  cmbPieceOdds.Visible := chkPieceOdds.Checked;

end;
//______________________________________________________________________________
procedure TfCLMatch.TimeControlChange(Sender: TObject);
begin
  Caption :=
    RATED_TYPES[Ord(TimeToRatedType(udInitial.Position, udInc.Position))];
end;
//______________________________________________________________________________
procedure TfCLMatch.TimeControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  TimeControlChange(nil);
end;
//______________________________________________________________________________
procedure TfCLMatch.rbRatedClick(Sender: TObject);
begin
  SetEnabled;
end;
//______________________________________________________________________________
procedure TfCLMatch.chkPieceOddsClick(Sender: TObject);
begin
  cmbPieceOdds.ItemIndex := BoolTo_(chkPieceOdds.Checked,0,-1);
  SetEnabled;
end;
//______________________________________________________________________________
procedure TfCLMatch.chkTimeOddsClick(Sender: TObject);
var
  sec: integer;
  msg: string;
begin
  if rbRated.Checked and chkTimeOdds.Checked then begin
    if cbDimension.ItemIndex = 0 then sec := udInitial.Position * 60
    else sec := udInitial.Position;

    if fTimeOddsLimits.GetLimit(sec, udInc.Position) = nil then begin
      chkTimeOdds.Checked := false;
      msg := 'You cannot play nonstandard rated time odds game.'+#13#10;
      msg := msg + 'Available game types: '+fTimeOddsLimits.GetMessageList;
      MessageDlg(msg, mtError, [mbOk], 0);
      exit;
    end;
  end;

  SetEnabled;
  if pnlTimeOdds.Visible then begin
    if cbDimension.ItemIndex = 0 then begin
       udOddsInitMin.Position := udInitial.Position;
       udOddsInitSec.Position := 0;
    end else begin
       udOddsInitMin.Position := udInitial.Position div 60;
       udOddsInitSec.Position := udInitial.Position mod 60;
    end;
    udOddsInc.Position := udInc.Position;
  end;
end;
//______________________________________________________________________________
end.

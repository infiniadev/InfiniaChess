{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLEventNew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Buttons, CLOdds, CLEvents, CLClubList, CLEventTickets;

type
  TfCLEventNew = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edName: TEdit;
    edDescription: TEdit;
    pnlLeader: TPanel;
    lblLeader: TLabel;
    edLeader: TEdit;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    dtDate: TDateTimePicker;
    Label5: TLabel;
    Label6: TLabel;
    dtTime: TDateTimePicker;
    edGames: TEdit;
    udGames: TUpDown;
    lblGames: TLabel;
    Label8: TLabel;
    edSec: TEdit;
    udSec: TUpDown;
    Label9: TLabel;
    edMin: TEdit;
    udMin: TUpDown;
    Panel8: TPanel;
    Panel10: TPanel;
    SpeedButton3: TSpeedButton;
    Panel11: TPanel;
    sbOk: TSpeedButton;
    lblLeaderColor: TLabel;
    cbLeaderColor: TComboBox;
    pnlOdds: TPanel;
    btnOdds: TSpeedButton;
    Panel9: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    edMinRating: TEdit;
    edMaxRating: TEdit;
    cbOneGame: TCheckBox;
    Panel12: TPanel;
    cbShout: TCheckBox;
    edShoutStart: TEdit;
    udShoutStart: TUpDown;
    lblShoutStart: TLabel;
    lblShoutInc: TLabel;
    cbTimeLimit: TCheckBox;
    edShoutInc: TEdit;
    udShoutInc: TUpDown;
    edTimeLimit: TEdit;
    udTimeLimit: TUpDown;
    edShoutMsg: TEdit;
    lblShoutMsg: TLabel;
    Label4: TLabel;
    cbType: TComboBox;
    pnlTournament: TPanel;
    Label3: TLabel;
    cbTourType: TComboBox;
    Label7: TLabel;
    cbRoundsOrder: TComboBox;
    lblRounds: TLabel;
    edRounds: TEdit;
    udRounds: TUpDown;
    lblStyle: TLabel;
    cbRatedType: TComboBox;
    Label12: TLabel;
    edPause: TEdit;
    udPause: TUpDown;
    sbRoundWins: TSpeedButton;
    cbProvisional: TCheckBox;
    cbRated: TCheckBox;
    Label13: TLabel;
    edMinPeople: TEdit;
    udMinPeople: TUpDown;
    Label14: TLabel;
    edMaxPeople: TEdit;
    udMaxPeople: TUpDown;
    cbAdminOnly: TCheckBox;
    cbDimension: TComboBox;
    cbAutoStart: TCheckBox;
    Label15: TLabel;
    edCongMsg: TEdit;
    Panel3: TPanel;
    SpeedButton1: TSpeedButton;
    pnlTickets: TPanel;
    sbInvited: TSpeedButton;
    cbShoutEveryRound: TCheckBox;
    cbLagRestriction: TCheckBox;
    procedure cbTypeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnOddsClick(Sender: TObject);
    procedure sbOkClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure cbTimeLimitClick(Sender: TObject);
    procedure sbRoundWinsClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure sbInvitedClick(Sender: TObject);
  private
    { Private declarations }
    NameChanged: Boolean;
    procedure ArrangePanels;
    function CurrentEventType: TCSEventType;
  public
    { Public declarations }
    ID: integer;
    Odds: TfCLOdds;
    Clubs: TfCLClubList;
    Tickets: TfCLEventTickets;
    procedure Init(ev: TCSEvent);
  end;

var
  fCLEventNew: TfCLEventNew;

implementation

uses CLSocket,CLGame,CLTournament,CSReglament,CLMain;

{$R *.DFM}
//========================================================================
procedure TfCLEventNew.cbTypeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key:=0;
end;
//========================================================================
procedure TfCLEventNew.FormCreate(Sender: TObject);
begin
  dtDate.DateTime:=Date;
  dtTime.DateTime:=Time+1/24;
  edLeader.Text:=fCLSocket.MyName;
  Odds:=TfCLOdds.Create(Self);
  Clubs:=TfCLClubList.Create(Self);
  Clubs.ListType:=cltCheckBoxes;
  Tickets:=TfCLEventTickets.Create(Self);
  cbType.ItemIndex:=0;
  cbLeaderColor.ItemIndex:=0;
  NameChanged:=false;
  cbTourType.ItemIndex:=0;
  cbRoundsOrder.ItemIndex:=0;
  cbRatedType.ItemIndex:=0;
  cbDimension.ItemIndex:=0;
end;
//========================================================================
procedure TfCLEventNew.btnOddsClick(Sender: TObject);
begin
  Odds.ShowModal;
end;
//========================================================================
procedure TfCLEventNew.sbOkClick(Sender: TObject);
begin
  if edName.Text='' then raise exception.create('Enter name');
  if (CurrentEventType in ETLeader) and (edLeader.Text='') then raise exception.create('Enter leader');
  if udMin.Position<0 then raise exception.create('Minutes must be greater than zero');
  if udSec.Position<0 then raise exception.create('Seconds must be greater than zero');
  if udGames.Position<0 then raise exception.create('Game number must be greater than zero');
  try
    StrToInt(edMinRating.Text);
    StrToInt(edMaxRating.Text);
  except
    raise exception.create('Minimum and maximum rating must be the numbers');
  end;
  ModalResult:=mrOk;
end;
//========================================================================
procedure TfCLEventNew.SpeedButton3Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;
//========================================================================
procedure TfCLEventNew.cbTypeChange(Sender: TObject);
begin
  ArrangePanels;
  if not NameChanged then
    edName.Text:=cbType.Text;
end;
//========================================================================
procedure TfCLEventNew.ArrangePanels;
var
  EventType: TCSEventType;
  b: Boolean;
begin
  EventType:=CurrentEventType;

  b:=EventType in ETLeader;
  lblLeader.Visible:=b;
  edLeader.Visible:=b;

  //lblLeaderColor.Visible:=b;
  //cbLeaderColor.Visible:=b;
  if EventType=evtKing then lblLeaderColor.Caption:='King''s color'
  else lblLeaderColor.Caption:='Leader''s color';

  pnlOdds.Visible:=EventType in ETOdds;

  b:=EventType in ETMaxGames;
  lblGames.Visible:=b;
  edGames.Visible:=b;
  udGames.Visible:=b;

  cbOneGame.Visible:=EventType = evtChallenge;

  b:=cbTimeLimit.Checked;
  edTimeLimit.Visible:=b;
  udTimeLimit.Visible:=b;

  b:=cbShout.Checked;
  lblShoutStart.Visible:=b;
  edShoutStart.Visible:=b;
  udShoutStart.Visible:=b;
  lblShoutInc.Visible:=b;
  edShoutInc.Visible:=b;
  udShoutInc.Visible:=b;
  lblShoutMsg.Visible:=b;
  edShoutMsg.Visible:=b;
  cbShoutEveryRound.Visible:=b;

  b:=EventType=evtTournament;
  pnlLeader.Visible:=not b;
  pnlTournament.Visible:=b;
  pnlLeader.Align:=alClient;
  pnlTournament.Align:=alClient;

  sbRoundWins.Visible:=cbTourType.ItemIndex=3; // Match

  b:=cbTourType.ItemIndex=0; // round robin
  lblRounds.Visible:=not b;
  edRounds.Visible:=not b;
  udRounds.Visible:=not b;

  //edReserved.Visible := cbTourType.ItemIndex = 3;

  case cbTourType.ItemIndex of
    0: udRounds.Max:=2; // round robin
    1: udRounds.Max:=3; // elimination
    2: udRounds.Max:=1000; // swiss
    3: udRounds.Max:=1000; // max
  end;

  cbRated.Visible:=not (EventType in ETNoRated);
end;
//========================================================================
function TfCLEventNew.CurrentEventType: TCSEventType;
begin
  case cbType.ItemIndex of
    0: result:=evtSimul;
    1: result:=evtChallenge;
    2: result:=evtKing;
    3: result:=evtTournament;
  end;
end;
//========================================================================
procedure TfCLEventNew.FormShow(Sender: TObject);
begin
  ArrangePanels;
end;
//========================================================================
procedure TfCLEventNew.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if not NameChanged then NameChanged:=true;
end;
//========================================================================
procedure TfCLEventNew.cbTimeLimitClick(Sender: TObject);
begin
  ArrangePanels;
end;
//========================================================================
procedure TfCLEventNew.sbRoundWinsClick(Sender: TObject);
begin
  if sbRoundWins.Caption = 'W' then begin
    lblRounds.Caption:='Number of Wins';
    sbRoundWins.Caption:='R';
  end else begin
    lblRounds.Caption:='Number of Rounds';
    sbRoundWins.Caption:='W';
  end;
end;
//========================================================================
procedure TfCLEventNew.Init(ev: TCSEvent);
var
  Reglament: TCSReglament;
  i,n: integer;
  vOdds: TCSOdds;
  vInitTime,vDim: string;
begin
  ID:=ev.ID;
  cbType.Enabled:=false;

  edName.Text:=ev.Name;
  edDescription.Text:=ev.Description;
  cbType.ItemIndex:=ord(ev.Type_);
  ArrangePanels;

  n:=pos('.',ev.InitialTime);
  if n=0 then udMin.Position:=StrToInt(ev.InitialTime)
  else udMin.Position:=StrToInt(copy(ev.InitialTime,n+1,100));

  if n=0 then cbDimension.ItemIndex:=0
  else cbDimension.ItemIndex:=1; 

  udSec.Position:=ev.IncTime;
  udGames.Position:=ev.MaxGamesCount;
  if ev.RatedType in [rtBullet,rtBlitz,rtStandard] then cbRatedType.ItemIndex:=0
  else cbRatedType.ItemIndex:=ord(ev.RatedType)-2;

  dtDate.Date:=ev.StartTime;
  dtTime.Time:=ev.StartTime;

  edLeader.Text:=ev.Leaders.CommaText;
  cbLeaderColor.ItemIndex:=ord(ev.LeaderColor);
  edMinRating.Text:=IntToStr(ev.MinRating);
  edMaxRating.Text:=IntToStr(ev.MaxRating);
  cbProvisional.Checked:=ev.ProvisionalAllowed;
  cbAdminOnly.Checked:=ev.AdminTitledOnly;
  cbOneGame.Checked:=ev.OneGame;
  cbTimeLimit.Checked:=ev.TimeLimit<>-1;
  udTimeLimit.Position:=ev.TimeLimit;

  cbShout.Checked:=ev.ShoutStart<>-1;
  udShoutStart.Position:=ev.ShoutStart;
  udShoutInc.Position:=ev.ShoutInc;
  edShoutMsg.Text:=ev.ShoutMsg;

  udMinPeople.Position:=ev.MinPeople;
  udMaxPeople.Position:=ev.MaxPeople;

  if ev is TCSTournament then begin
    Reglament:=(ev as TCSTournament).Reglament;
    cbTourType.ItemIndex:=ord(Reglament.TourType);
    ArrangePanels;
    cbRoundsOrder.ItemIndex:=ord(Reglament.RoundOrder);
    udRounds.Position:=Reglament.NumberOfRounds;
    udPause.Position:=Reglament.AcceptTime;
  end;

  for i:=0 to ev.Odds.Count-1 do begin
    vOdds:=TCSOdds(ev.Odds[i]);
    vInitTime:=vOdds.InitTime;
    if pos('s',vInitTime)=0 then vDim:='M'
    else begin
      vDim:='S';
      vInitTime:=copy(vInitTime,1,length(vInitTime)-1);
    end;
    Odds.AddToLV(vOdds.Rating,StrToInt(vInitTime),vOdds.IncTime,vOdds.Pieces,vDim);
  end;

  cbAutoStart.Checked:=ev.AutoStart;
  //edReserved.Text:=ev.Reserv;
  edCongMsg.Text:=ev.CongrMsg;

  Clubs.Init(ev.ClubList);
  Tickets.Init(ev,true);

  sbOk.Enabled:=ev.Status=estWaited;
end;
//========================================================================
procedure TfCLEventNew.SpeedButton1Click(Sender: TObject);
begin
  Clubs.ShowModal;
end;
//========================================================================
procedure TfCLEventNew.sbInvitedClick(Sender: TObject);
begin
  Tickets.ShowModal;
end;
//========================================================================
end.

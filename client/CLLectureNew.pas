{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLLectureNew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, CLClubList, CLEvents;

type
  TfCLLectureNew = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edName: TEdit;
    edLecturer: TEdit;
    Panel5: TPanel;
    Panel10: TPanel;
    SpeedButton3: TSpeedButton;
    Panel11: TPanel;
    sbOk: TSpeedButton;
    Panel2: TPanel;
    Panel6: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    dtDate: TDateTimePicker;
    dtTime: TDateTimePicker;
    cbAdminOnly: TCheckBox;
    cbAutoStart: TCheckBox;
    Panel12: TPanel;
    lblShoutStart: TLabel;
    lblShoutInc: TLabel;
    lblShoutMsg: TLabel;
    cbShout: TCheckBox;
    edShoutStart: TEdit;
    udShoutStart: TUpDown;
    edShoutInc: TEdit;
    udShoutInc: TUpDown;
    edShoutMsg: TEdit;
    Label3: TLabel;
    edDescription: TEdit;
    Panel3: TPanel;
    sbClubs: TSpeedButton;
    procedure sbOkClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbClubsClick(Sender: TObject);
    procedure cbShoutClick(Sender: TObject);
  private
    { Private declarations }
    procedure ArrangePanels;
  public
    { Public declarations }
    ID: integer;
    Clubs: TfCLClubList;
    procedure Init(EV: TCSEvent);
  end;

var
  fCLLectureNew: TfCLLectureNew;

implementation

uses CLMain;

{$R *.DFM}
//==========================================================================
procedure TfCLLectureNew.sbOkClick(Sender: TObject);
begin
  if trim(edName.Text) = '' then MessageDlg('Name is not defined',mtError,[mbOk],0)
  else if trim(edLecturer.Text) = '' then MessageDlg('Lecturer is not defined',mtError,[mbOk],0)
  else ModalResult := mrOk;
end;
//==========================================================================
procedure TfCLLectureNew.SpeedButton3Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
//==========================================================================
procedure TfCLLectureNew.FormCreate(Sender: TObject);
begin
  Clubs:=TfCLClubList.Create(Self);
  Clubs.ListType:=cltCheckBoxes;
  ArrangePanels;

  if DebugHook <> 0 then begin
    edDescription.Text := 'Lecture about french defence';
    edName.Text := 'French Defence';
    edLecturer.Text := 'urise';
  end;

  dtDate.DateTime := trunc(fCLMain.ServerTime);
  dtTime.DateTime := fCLMain.ServerTime - trunc(fCLMain.ServerTime);
end;
//==========================================================================
procedure TfCLLectureNew.sbClubsClick(Sender: TObject);
begin
  Clubs.ShowModal;
end;
//==========================================================================
procedure TfCLLectureNew.ArrangePanels;
var
  b: Boolean;
begin
  b:=cbShout.Checked;
  lblShoutStart.Visible:=b;
  edShoutStart.Visible:=b;
  udShoutStart.Visible:=b;
  lblShoutInc.Visible:=b;
  edShoutInc.Visible:=b;
  udShoutInc.Visible:=b;
  lblShoutMsg.Visible:=b;
  edShoutMsg.Visible:=b;
end;
//==========================================================================
procedure TfCLLectureNew.cbShoutClick(Sender: TObject);
begin
  ArrangePanels;
end;
//==========================================================================
procedure TfCLLectureNew.Init(EV: TCSEvent);
var
  i,n: integer;
begin
  ID:=ev.ID;

  edName.Text:=ev.Name;
  edDescription.Text:=ev.Description;
  ArrangePanels;

  dtDate.Date:=ev.StartTime;
  dtTime.Time:=ev.StartTime;

  edLecturer.Text:=ev.Leaders.CommaText;
  cbAdminOnly.Checked:=ev.AdminTitledOnly;

  cbShout.Checked:=ev.ShoutStart<>-1;
  udShoutStart.Position:=ev.ShoutStart;
  udShoutInc.Position:=ev.ShoutInc;
  edShoutMsg.Text:=ev.ShoutMsg;

  cbAutoStart.Checked:=ev.AutoStart;

  Clubs.Init(ev.ClubList);
  sbOk.Enabled:=ev.Status=estWaited;
end;
//==========================================================================
end.

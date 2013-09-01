{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLAccept;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls, jpeg;

type
  TfCLAccept = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    lblPartner: TLabel;
    Label3: TLabel;
    lblSeconds: TLabel;
    Label5: TLabel;
    SpeedButton1: TSpeedButton;
    Timer: TTimer;
    procedure SpeedButton1Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetParams(name: string; sec: integer);
  end;

var
  fCLAccept: TfCLAccept;

implementation

uses CLMain;

{$R *.DFM}

{ TfCLAccept }
//====================================================================
procedure TfCLAccept.SetParams(name: string; sec: integer);
begin
  lblPartner.Caption:=name;
  lblSeconds.Caption:=IntToStr(sec);
end;
//====================================================================
procedure TfCLAccept.SpeedButton1Click(Sender: TObject);
begin
  ModalResult:=mrOk;
end;
//====================================================================
procedure TfCLAccept.TimerTimer(Sender: TObject);
var
  n: integer;
begin
  n:=StrToInt(lblSeconds.Caption);
  dec(n);
  lblSeconds.Caption:=IntToStr(n);
  if n=0 then ModalResult:=mrOk;
end;
//====================================================================
procedure TfCLAccept.FormPaint(Sender: TObject);
begin
  Canvas.Brush.Color:=clBlack;
  Canvas.FrameRect(Rect(0,0,Width,Height));
  Canvas.FrameRect(Rect(1,1,Width-1,Height-1)); 
end;
//====================================================================
end.

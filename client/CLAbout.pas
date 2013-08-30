{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLAbout;

interface

uses
  Classes, Forms, Controls, StdCtrls, Graphics, ExtCtrls, ShellApi, Windows,
  jpeg;

type
  TfCLAbout = class(TForm)
    btnOK: TButton;
    lblSheeres: TLabel;
    lblURL: TLabel;
    lblVersion: TLabel;
    imgChesslink: TImage;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblURLClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  CLConst, CLMain;

{$R *.DFM}
//______________________________________________________________________________
procedure TfCLAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLAbout.FormCreate(Sender: TObject);
begin
  lblURL.Cursor := crIEHand;
  lblVersion.Caption := 'Version '+CLIENT_VERSION;
end;
//______________________________________________________________________________
procedure TfCLAbout.FormPaint(Sender: TObject);
begin
  with Canvas do
    begin
      Brush.Color := clWhite;
      Pen.Color := clWhite;
      Rectangle(0, 0, Width, 33);
    end;
end;
//______________________________________________________________________________
procedure TfCLAbout.lblURLClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(CHESSLINK_WEB), '', '', SW_SHOWNORMAL);
end;
//______________________________________________________________________________
end.



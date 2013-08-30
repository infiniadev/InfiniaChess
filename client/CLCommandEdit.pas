{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLCommandEdit;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, CLGlobal;

type
  TfCLCommandEdit = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    edtCaption: TEdit;
    edtCommand: TEdit;
    lblCaption: TLabel;
    lblCommand: TLabel;
    procedure ContentsChanged(Sender: TObject);
    procedure btnOKClick(Sender: TObject);

  private
    { Private declarations }
    FCommand: TCommand;

  public
    { Public delarations }
    procedure LoadCommand(Command: TCommand);
  end;

var
  fCLCommandEdit: TfCLCommandEdit;

implementation

{$R *.DFM}

uses CLMain;

//______________________________________________________________________________
procedure TfCLCommandEdit.LoadCommand(Command: TCommand);
begin
  FCommand := Command;
  edtCaption.Text := Command.Caption;
  edtCommand.Text := Command.Command;
end;
//______________________________________________________________________________
procedure TfCLCommandEdit.btnOKClick(Sender: TObject);
begin
  FCommand.Caption := edtCaption.Text;
  FCommand.Command := edtCommand.Text;
end;
//______________________________________________________________________________
procedure TfCLCommandEdit.ContentsChanged(Sender: TObject);
begin
  btnOK.Enabled := (Length(edtCaption.Text) > 0)
    and (Length(edtCommand.Text) >0);
end;
//______________________________________________________________________________
end.

{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLMoretime;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfCLMoretime = class(TForm)
    btnCancel: TButton;
    btnOK: TButton;
    edtOther: TEdit;
    lblRequest: TLabel;
    rbFive: TRadioButton;
    rbOne: TRadioButton;
    rbOther: TRadioButton;
    rbTen: TRadioButton;
    rbTwenty: TRadioButton;

    procedure edtOtherChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButtonClick(Sender: TObject);
    procedure rbOtherClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetSeconds: string;
  end;

var
  fCLMoretime: TfCLMoretime;

implementation

{$R *.DFM}

uses CLMain;
//______________________________________________________________________________
function TfCLMoretime.GetSeconds: string;
begin
  { Return the number of seconds }
  if rbOne.Checked then Result := '60';
  if rbFive.Checked then Result := '300';
  if rbTen.Checked then Result := '600';
  if rbTwenty.Checked then Result := '1200';
  if rbOther.Checked then Result := edtOther.Text;
end;
//______________________________________________________________________________
procedure TfCLMoretime.edtOtherChange(Sender: TObject);
begin
  rbOther.Checked := True;
  btnOK.Enabled := edtOther.Text <> '';
end;
//______________________________________________________________________________
procedure TfCLMoretime.FormCreate(Sender: TObject);
begin
  { Set edit boxes to accept only 0..9 }
  SetWindowLong(edtOther.Handle, GWL_STYLE,
    GetWindowLong(edtOther.Handle, GWL_STYLE) or ES_NUMBER);
end;
//______________________________________________________________________________
procedure TfCLMoretime.RadioButtonClick(Sender: TObject);
begin
 edtOther.Text := '';
 btnOK.Enabled := True;
end;
//______________________________________________________________________________
procedure TfCLMoretime.rbOtherClick(Sender: TObject);
begin
  btnOK.Enabled := False;
end;
//______________________________________________________________________________
end.

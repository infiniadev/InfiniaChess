{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLPromotion;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfCLPromotion = class(TForm)
    btnBishop: TBitBtn;
    btnKnight: TBitBtn;
    btnQueen: TBitBtn;
    btnRook: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    {Private declarations }
  public
    { Public declarations }
  end;

var
  fCLPromotion: TfCLPromotion;

implementation

{$R *.DFM}

uses CLMain;
//______________________________________________________________________________
procedure TfCLPromotion.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fCLPromotion := nil;
  Action := caFree;
end;
//______________________________________________________________________________
end.

unit CLConsole1L;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CLConsole;

type
  TCLConsole1L = class(TCLConsole)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
    procedure SetText(Str: string);
  published
    { Published declarations }
  end;

procedure Register;

implementation

//===============================================================================
procedure Register;
begin
  RegisterComponents('ChessLink', [TCLConsole1L]);
end;
//===============================================================================
procedure TCLConsole1L.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style and not WS_VSCROLL and not WS_HSCROLL;
end;
//===============================================================================
procedure TCLConsole1L.SetText(Str: string);
begin
  BeginUpdate;
  ClearText;
  AddLine(0, Str, ltShout);
  EndUpdate;
end;
//===============================================================================
end.

{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSServiceForm;

interface

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ShellAPI, ExtCtrls, StdCtrls, ComCtrls, Registry, Buttons,
  FileCtrl;

type
  TCLServerForm = class(TForm)
    btnEnable: TButton;
    btnTerminate: TButton;

    procedure btnEnableClick(Sender: TObject);
    procedure btnTerminateClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SetIcon;
  private
    FIconData: TNotifyIconData;
  protected
    { Protected declarations }
    procedure WndProc(var Msg: TMessage); override;
  end;

var
  CLServerForm: TCLServerForm;

implementation

uses CSInit, CSLib, CSConst;

{$R *.DFM}
{$R Icons.res}

//==============================================================================
procedure TCLServerForm.SetIcon;
begin
  if fInit.ServiceEnabled then begin
    FIconData.hIcon := LoadIcon(HInstance, 'SERVERON');
    btnEnable.Caption := '&Stop Server';
  end else begin
    FIconData.hIcon := LoadIcon(HInstance, 'SERVEROFF');
    btnEnable.Caption := '&Start Server';
  end;
  Application.Icon.Handle := FIconData.hIcon;
  Shell_NotifyIcon(NIM_MODIFY, @FIconData);
end;
//==============================================================================
procedure TCLServerForm.btnEnableClick(Sender: TObject);
begin
  Cursor := crDefault;
  fInit.ServiceEnabled := not fInit.ServiceEnabled;
  SetIcon;
  Cursor := crDefault;
end;
//==============================================================================
procedure TCLServerForm.btnTerminateClick(Sender: TObject);
begin
  fInit.ServiceEnabled := False;
  SetIcon;
  fInit.Free;

  Shell_NotifyIcon(NIM_DELETE, @FIconData);
  Application.ProcessMessages;
  ErrLog('Stopped.',nil);
  ErrLog('====================================',nil);
  Application.Terminate;
end;
//==============================================================================
procedure TCLServerForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  Self.Hide;
end;
//==============================================================================
procedure TCLServerForm.FormCreate(Sender: TObject);
begin
  ControlStyle := [csOpaque];
  { Tray Icon stuff }
  FIconData.cbSize := SizeOf(FIconData);
  FIconData.Wnd := Handle;
  FIconData.uID := 100;
  FIconData.uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
  FIconData.uCallbackMessage := WM_USER + 1;
  FIconData.hIcon := Application.Icon.Handle;
  StrPCopy(FIconData.szTip, Application.Title);
  Shell_NotifyIcon(NIM_ADD, @FIconData);

  fInit.ServiceEnabled := True;
  SetIcon;
  ErrLog('====================================',nil);
  ErrLog('Started...',nil);
end;
//==============================================================================
procedure TCLServerForm.WndProc(var Msg : TMessage);
begin
  case Msg.Msg of
    WM_USER:
      Self.Show;

    WM_USER + 1:
      case Msg.lParam of
        WM_LBUTTONUP:
          begin
            Self.Show;
            ShowWindow(Application.Handle, SW_HIDE); { Taskbar }
            SetForegroundWindow(Application.Handle);
          end
      end;
  end;

  inherited;
end;
//==============================================================================
begin
  ShowWindow(Application.Handle, SW_HIDE);
end.

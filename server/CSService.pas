{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

unit CSService;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, extctrls,
  IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze, CSAccessLevels, CSAchievements;

type
  TCLServerService = class(TService)
    procedure ServiceShutdown(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetServiceController: TServiceController; override;
  end;

var
  CLServerService: TCLServerService;

implementation

uses CSInit, CSLib, CSConst;

{$R *.DFM}
//______________________________________________________________________________
procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  CLServerService.Controller(CtrlCode);
end;
//______________________________________________________________________________
function TCLServerService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;
//______________________________________________________________________________
procedure TCLServerService.ServiceShutdown(Sender: TService);
var
  Stopped: Boolean;
begin
  fInit.ServiceEnabled := False;
  ServiceStop(Self, Stopped);
end;
//______________________________________________________________________________
procedure TCLServerService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  fInit.ServiceEnabled := true;
  Started := True;
  CLServerService.LogMessage('Service Started.',
    EVENTLOG_INFORMATION_TYPE, 0, 2);
end;
//______________________________________________________________________________
procedure TCLServerService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  fInit.ServiceEnabled := False;
  CLServerService.LogMessage('Service Stopping.',
    EVENTLOG_INFORMATION_TYPE, 0, 3);
  Stopped := True;
end;
//______________________________________________________________________________
end.

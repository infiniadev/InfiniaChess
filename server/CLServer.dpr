{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

program CLServer;

{%ToDo 'CLServer.todo'}
{%TogetherDiagram 'ModelSupport_CLServer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_CLServer\CSService\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_CLServer\CLServer\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_CLServer\CSLib\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_CLServer\CSService\default.txvpck'}
{%TogetherDiagram 'ModelSupport_CLServer\CSInit\default.txaPackage'}
{%TogetherDiagram 'ModelSupport_CLServer\CLServer\default.txvpck'}

{$WARNINGS ON}
{$HINTS ON}
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses
  Forms,
  Windows,
  Messages,
  syncobjs,
  CSServiceForm in 'CSServiceForm.pas' {CLServerForm},
  CSConnection in 'CSConnection.pas',
  CSConnections in 'CSConnections.pas',
  CSConst in 'CSConst.pas',
  CSCommand in 'CSCommand.pas',
  CSGames in 'CSGames.pas',
  CSGame in 'CSGame.pas',
  CSOffer in 'CSOffer.pas',
  CSOffers in 'CSOffers.pas',
  CSSocket in 'CSSocket.pas',
  CSGameSaveThread in 'CSGameSaveThread.pas',
  CSDb in 'CSDb.pas',
  CSMessages in 'CSMessages.pas',
  CSRoom in 'CSRoom.pas',
  CSRooms in 'CSRooms.pas',
  CSLibrary in 'CSLibrary.pas',
  CSProfiles in 'CSProfiles.pas',
  CSLib in 'CSLib.pas',
  CSEvent in 'CSEvent.pas',
  CSEvents in 'CSEvents.pas',
  CSReglament in 'CSReglament.pas',
  CSTournament in 'CSTournament.pas',
  CSMail in 'CSMail.pas',
  CSTimeStat in 'CSTimeStat.pas',
  CSSocket2 in 'CSSocket2.pas',
  CSClub in 'CSClub.pas',
  CSBanners in 'CSBanners.pas',
  CLRating in 'CLRating.pas',
  CLOfferOdds in 'CLOfferOdds.pas',
  CSLecture in 'CSLecture.pas',
  CSAchievements in 'CSAchievements.pas',
  CSActions in 'CSActions.pas',
  CSEngine in 'CSEngine.pas',
  CSDataStructures in 'CSDataStructures.pas',
  DosCommand in 'DosCommand.pas',
  CSInit in 'CSInit.pas',
  CSService in 'CSService.pas' {CLServerService: TService},
  CSBot in 'CSBot.pas',
  CSTypes in 'CSTypes.pas',
  CSDbTestThread in 'CSDbTestThread.pas';

{$R *.RES}
{$R CLEventMessages.RES}

//______________________________________________________________________________
procedure RunApp;
begin
  Application.Initialize;

  MAIN_THREAD_ID := GetCurrentThreadID;
  Application.ShowMainForm := False;
  Application.Title := 'CLServer';
  fTimeStat:=TCSTimeStat.Create;
  csERRLOG := TCriticalSection.Create;
  csLAG_STAT := TCriticalSection.Create;
  critDB := TCriticalSection.Create;

  Init;
  fInit := TCSInit.Create;

  if LAUNCH_MODE = lncApplication then begin
    ErrLog('LAUNCH_MODE = APPLICATION', nil);
    Application.CreateForm(TCLServerForm, CLServerForm);
  end else begin
    ErrLog('LAUNCH_MODE = SERVICE', nil);
    Application.CreateForm(TCLServerService, CLServerService);
  end;

  ShowWindow(Application.Handle, SW_HIDE);
  Application.Run;
end;
//______________________________________________________________________________
begin
  csERRLOG:=TCriticalSection.Create;
  csLAG_STAT:=TCriticalSection.Create;
  RunApp;
end.

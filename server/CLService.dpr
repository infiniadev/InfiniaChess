{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

program CLServer;

uses
  SvcMgr,
  syncobjs,
  CSService in 'CSService.pas' {CLServerService: TService},
  CSCommand in 'CSCommand.pas',
  CSConnection in 'CSConnection.pas',
  CSConnections in 'CSConnections.pas',
  CSConst in 'CSConst.pas',
  CSDb in 'CSDb.pas',
  CSGame in 'CSGame.pas',
  CSGames in 'CSGames.pas',
  CSGameSaveThread in 'CSGameSaveThread.pas',
  CSLibrary in 'CSLibrary.pas',
  CSMessages in 'CSMessages.pas',
  CSOffer in 'CSOffer.pas',
  CSOffers in 'CSOffers.pas',
  CSRoom in 'CSRoom.pas',
  CSRooms in 'CSRooms.pas',
  CSSocket in 'CSSocket.pas',
  CSProfiles in 'CSProfiles.pas',
  CSLib in 'CSLib.pas',
  CSTournament in 'CSTournament.pas',
  CSEvent in 'CSEvent.pas',
  CSEvents in 'CSEvents.pas',
  CSReglament in 'CSReglament.pas',
  CSTimeStat in 'CSTimeStat.pas',
  CSSocket2 in 'CSSocket2.pas',
  CSClub in 'CSClub.pas',
  CSBanners in 'CSBanners.pas',
  CLOfferOdds in 'CLOfferOdds.pas',
  CLRating in 'CLRating.pas',
  CSAccessLevels in 'CSAccessLevels.pas',
  CSAchievements in 'CSAchievements.pas',
  CSActions in 'CSActions.pas',
  CSCommandMM in 'CSCommandMM.pas',
  CSLecture in 'CSLecture.pas',
  CSMail in 'CSMail.pas',
  CSInit in 'CSInit.pas',
  CSBot in 'CSBot.pas',
  CSEngine in 'CSEngine.pas';

{$R *.RES}
{$R CLEventMessages.RES}

begin
  Application.Initialize;
  csErrLog := TCriticalSection.Create;
  csLAG_STAT := TCriticalSection.Create;
  critDB := TCriticalSection.Create;
  Init;
  fInit := TCSInit.Create;
  fTimeStat:=TCSTimeStat.Create;
  Application.CreateForm(TCLServerService, CLServerService);
  Application.Run;
end.

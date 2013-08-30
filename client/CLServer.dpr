{*******************************************************}
{                                                       }
{       Chesslink Server                                }
{       Brian Sheeres                                   }
{       Copyright (c) 2002                              }
{                                                       }
{*******************************************************}

program CLServer;

{%ToDo 'CLServer.todo'}

uses
  Forms,
  Windows,
  Messages,
  CSService in 'CSService.pas' {CLServerService},
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
  CSTournament in 'CSTournament.pas';

{$R *.RES}

//______________________________________________________________________________
procedure RunApp;
begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.Title := 'CLServer';
  Application.CreateForm(TCLServerService, CLServerService);
  ShowWindow(Application.Handle, SW_HIDE);
  Application.Run;
end;
//______________________________________________________________________________
var
  Hwnd: THandle;
begin
  { Check to see if the code is being run from inside the IDE. If so go ahead
    and check for an existing instance. }
  if DebugHook = 0 then
    begin
      Hwnd := FindWindow('TCLServerService', 'CLServer');
      if Hwnd = 0 then
        RunApp
      else
        PostMessage (Hwnd, wm_User, 0, 0);
    end
  else
    { Inside the IDE, so checking for Findwindow won't work. Just run the App. }
    RunApp;
//______________________________________________________________________________
end.

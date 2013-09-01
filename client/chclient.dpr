{*******************************************************}
{                                                       }
{       Chclient by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

program chclient;



uses
  Forms,
  Windows,
  Messages,
  Dialogs,
  SysUtils,
  Classes,
  CLMain in 'CLMain.pas' {fCLMain},
  CLGlobal in 'CLGlobal.pas',
  CLOptions in 'CLOptions.pas' {fCLOptions},
  CLCommandEdit in 'CLCommandEdit.pas' {fCLCommandEdit},
  CLTerminal in 'CLTerminal.pas' {fCLTerminal},
  CLNavigate in 'CLNavigate.pas' {fCLNavigate},
  CLGame in 'CLGame.pas',
  CLBoard in 'CLBoard.pas' {fCLBoard},
  CLPromotion in 'CLPromotion.pas' {fCLPromotion},
  CLPgn in 'CLPgn.pas',
  CLAbout in 'CLAbout.pas' {fCLAbout},
  CLSeek in 'CLSeek.pas' {fCLSeek},
  CLAccount in 'CLAccount.pas' {fCLAccount},
  CLPGNLib in 'CLPGNLib.pas' {fCLPGNLib},
  CLSocket in 'CLSocket.pas',
  CLCLS in 'CLCLS.pas',
  CLOffers in 'CLOffers.pas' {fCLOffers},
  CLConst in 'CLConst.pas',
  CLNotify in 'CLNotify.pas' {fCLNotify},
  CLMessages in 'CLMessages.pas' {fCLMessages},
  CLMessage in 'CLMessage.pas' {fCLMessage},
  CLRooms in 'CLRooms.pas' {fCLRooms},
  CLGames in 'CLGames.pas' {fCLGames},
  CLLogin in 'CLLogin.pas' {fCLLogin},
  CLRegister in 'CLRegister.pas' {fCLRegister},
  CLAccounts in 'CLAccounts.pas' {fCLAccounts},
  CLFilterManager in 'CLFilterManager.pas',
  CLProfile in 'CLProfile.pas' {fCLProfile},
  CLTakeback in 'CLTakeback.pas' {fCLTakeback},
  CLMoretime in 'CLMoretime.pas' {fCLMoretime},
  CLCrypt in 'CLCrypt.pas',
  CLNet in 'CLNet.pas',
  CLLib in 'CLLib.pas',
  CLBan in 'CLBan.pas',
  CLMessageDlg in 'CLMessageDlg.pas',
  CLDemoBoard in 'CLDemoBoard.pas' {fCLDemoBoard},
  CLEventControl in 'CLEventControl.pas' {fCLEventControl},
  CLEvents in 'CLEvents.pas' {fCLEvents},
  CLEventNew in 'CLEventNew.pas' {fCLEventNew},
  CLOdds in 'CLOdds.pas' {fCLOdds},
  CLTournament in 'CLTournament.pas',
  CLTable in 'CLTable.pas' {fCLTable},
  CSReglament in 'CSReglament.pas',
  CLRectMap in 'CLRectMap.pas',
  CLAccept in 'CLAccept.pas' {fCLAccept},
  CLAuthKey in 'CLAuthKey.pas' {fCLAuthKey},
  CLImageLib in 'CLImageLib.pas',
  CLFileLib in 'CLFileLib.pas',
  CLMediaPlayer in 'CLMediaPlayer.pas',
  CLSocket2 in 'CLSocket2.pas',
  CLPassword in 'CLPassword.pas' {fCLPassword},
  CLStat in 'CLStat.pas' {fCLStat},
  CSClub in 'CSClub.pas',
  CLClubList in 'CLClubList.pas' {fCLClubList},
  CLClubMembers in 'CLClubMembers.pas' {fCLClubMembers},
  CLCLubOptions in 'CLCLubOptions.pas' {fCLCLubOptions},
  CLClubInfo in 'CLClubInfo.pas' {fCLClubInfo},
  CLEventTickets in 'CLEventTickets.pas' {fCLEventTickets},
  CLRating in 'CLRating.pas',
  CLOfferOdds in 'CLOfferOdds.pas',
  CLAutoUpdate in 'CLAutoUpdate.pas' {FCLAutoUpdate},
  CLLectures in 'CLLectures.pas' {fCLLectures},
  CLLectureNew in 'CLLectureNew.pas' {fCLLectureNew},
  CLLecture in 'CLLecture.pas',
  CLClubNew in 'CLClubNew.pas' {fClubNew},
  CLAchievementClass in 'CLAchievementClass.pas',
  CLAchievements in 'CLAchievements.pas' {fCLAchievements},
  CLAchGroups in 'CLAchGroups.pas',
  CLBaseDraw in 'CLBaseDraw.pas' {fCLBaseDraw},
  CLAchList in 'CLAchList.pas' {fCLAchList},
  CLClubs in 'CLClubs.pas' {fCLClubs},
  CLWarning in 'CLWarning.pas' {fCLWarning},
  CLMembershipType in 'CLMembershipType.pas',
  CLPaymentEdit in 'CLPaymentEdit.pas' {fCLPaymentEdit},
  CLSeeks in 'CLSeeks.pas' {fCLSeeks},
  CLObjectList in 'CLObjectList.pas',
  CLLogins in 'CLLogins.pas',
  CLAutoUpdateThread in 'CLAutoUpdateThread.pas';

{$R *.RES}

//______________________________________________________________________________
procedure RunApp;
var
  Semaphore: THandle;
  fname, AutoUpdateExe, CurrentExeName: string;
begin
  Log('RunApp Started...');
  Application.Initialize;

  CurrentExeName := ExtractFileName(Application.ExeName);
  if copy(CurrentExeName, 1, 3) = 'upd' then begin
    DeleteFile('chclient.exe');
    CopyFile(PAnsiChar(CurrentExeName), 'chclient.exe', false);
    Application.Terminate;
    CreateProcessSimple('chclient.exe');
    exit;
  end;

  {if ParamCount > 0 then
    if ParamStr(1) = '-ru' then
      DeleteAutoUpdates;}

  AutoUpdateExe := GetAutoUpdateExe;
  if AutoUpdateExe <> '' then begin
    Application.Terminate;
    CreateProcessSimple(AutoUpdateExe);
    exit;
  end;

  if not MultiKeyExists and not DEBUGGING then
    begin
      Semaphore := CreateSemaphore(nil, 0, 1, 'chclient.exe');
      if ((Semaphore <> 0) and (GetLastError = ERROR_ALREADY_EXISTS)) then begin
         CloseHandle(Semaphore);
         MessageDlg('Program is already started.',mtError,[mbOk],0);
         Application.Terminate;
         Exit;
      end;
    end;

  SL_DP_CODES:=TStringList.Create;
  if FileExists(MAIN_DIR+'dp_codes.ini') then
    SL_DP_CODES.LoadFromFile(MAIN_DIR+'dp_codes.ini');


  fSquareLib := TCLPngLib.Create;
  fname:=MAIN_DIR+'boards.flb';
  if FileExists(fname) then begin
    fSquareLib.FileName:=fname;
    fSquareLib.Load;
  end;

  fSoundMovesLib := TCLSoundMovesLib.Create;
  fname:=MAIN_DIR+'sndmoves.flb';
  {if FileExists(fname) then begin
    fSoundMovesLib.FileName:=fname;
    fSoundMovesLib.Load;
  end;}

  slMP3List:=TStringList.Create;

  fGL := TCLGlobal.Create;
  Log('fGL created');
  fCLSocket := TCLSocket.Create;
  Log('fCLSocket created');
  fCLSocket2 := TCLSocket2.Create;
  Log('fCLSocket2 created');
  Application.Title := 'Perpetual Chess';
  Application.CreateForm(TfCLMain, fCLMain);
  Log('fCLMain created.');
  Application.Run;
end;
//______________________________________________________________________________
var
  Hwnd: THandle;
begin
  { Check to see if the code is being run from inside the IDE. If so go ahead
    and check for an existing instance. }
  Log('Started...');
  MAIN_DIR := ExtractFileDir(Application.ExeName)+'\';
  {if DebugHook = 0 then
    begin
      Hwnd := FindWindow('TfCLMain', 'Perpetual Chess');
      if Hwnd = 0 then
        RunApp
      else
        PostMessage (Hwnd, wm_User, 0, 0);
    end
  else}
    { Inside the IDE, so checking for Findwindow won't work. Just run the App. }
    RunApp;
//______________________________________________________________________________
end.

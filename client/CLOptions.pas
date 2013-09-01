{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, FileCtrl, Buttons, CLGlobal, CLColorButton,
  MMSystem, CLConsole, CLCombo, JPEG, ShellAPI;

type
  TfCLOptions = class(TForm)
    btnAddAccount: TButton;
    btnAddCommand: TButton;
    btnApply: TButton;
    btnBackColor: TButton;
    btnBrowse: TButton;
    btnCancel: TButton;
    btnClear: TButton;
    btnDeleteAccount: TButton;
    btnDeleteCommand: TButton;
    btnEditAccount: TButton;
    btnEditCommand: TButton;
    btnFontColor: TButton;
    btnMoveDown: TButton;
    btnMoveUp: TButton;
    btnOK: TButton;
    bvlAccount: TBevel;
    bvlSound: TBevel;
    bvlText: TBevel;
    bvlUser: TBevel;
    cbConsoleColor: TCLColorButton;
    cbConsoleTextColor: TCLColorButton;
    cbFontName: TCLFontNamesCombo;
    cbFontSize: TCLFontSizesCombo;
    chkBold: TCheckBox;
    chkItalics: TCheckBox;
    chkMute: TCheckBox;
    ColorDialog1: TColorDialog;
    lbConsoleColor: TLabel;
    lblAccount: TLabel;
    lblAttributes: TLabel;
    lblBaseFont: TLabel;
    lblConsoleTextColor: TLabel;
    lblSound: TLabel;
    lblText: TLabel;
    lblUser: TLabel;
    lstText: TListBox;
    lvAccounts: TListView;
    lvCommands: TListView;
    lvSoundEvents: TListView;
    OpenDialog1: TOpenDialog;
    pgMain: TPageControl;
    pnlSample: TPanel;
    tsAccounts: TTabSheet;
    tsBoard: TTabSheet;
    tsCommands: TTabSheet;
    tsGeneral: TTabSheet;
    tsServer: TTabSheet;
    tsSounds: TTabSheet;
    tsText: TTabSheet;
    chkUserColor: TCheckBox;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    pnlPieces: TPanel;
    tsGame: TTabSheet;
    Panel1: TPanel;
    clLegal: TCLColorButton;
    lblLegal: TLabel;
    clIllegal: TCLColorButton;
    lblIllegal: TLabel;
    chkMoveSquare: TCheckBox;
    Panel2: TPanel;
    Label8: TLabel;
    cmbMoveStyle: TComboBox;
    clClick: TCLColorButton;
    lblClick: TLabel;
    Panel3: TPanel;
    chkShowCoordinates: TCheckBox;
    chkShowLegal: TCheckBox;
    chkShowArrows: TCheckBox;
    chkSmartMove: TCheckBox;
    Panel4: TPanel;
    cbHighLight: TCLColorButton;
    lblHightLight: TLabel;
    cbGameClock: TCLColorButton;
    Label6: TLabel;
    cbLightPieces: TCLColorButton;
    lblLightPieces: TLabel;
    cbDarkPieces: TCLColorButton;
    lblDarkPieces: TLabel;
    Panel5: TPanel;
    chkQueen: TCheckBox;
    chkShowCaptured: TCheckBox;
    lblPGNOptions: TLabel;
    cmboLogGames: TComboBox;
    Panel6: TPanel;
    chkPremove: TCheckBox;
    cmbPremoveStyle: TComboBox;
    clPremove: TCLColorButton;
    lblPremove: TLabel;
    chkAggressive: TCheckBox;
    tsColor: TTabSheet;
    Panel7: TPanel;
    clFrames: TCLColorButton;
    Label7: TLabel;
    clNotify: TCLColorButton;
    Label9: TLabel;
    clDefaultBackground: TCLColorButton;
    Label10: TLabel;
    clBoardBackground: TCLColorButton;
    Label11: TLabel;
    GroupBox1: TGroupBox;
    clBullet: TCLColorButton;
    Label12: TLabel;
    clBlitz: TCLColorButton;
    Label13: TLabel;
    clStandard: TCLColorButton;
    Label14: TLabel;
    clLoosers: TCLColorButton;
    Label15: TLabel;
    clFisher: TCLColorButton;
    Label16: TLabel;
    clCrazy: TCLColorButton;
    Label17: TLabel;
    clTitleC: TCLColorButton;
    Label18: TLabel;
    Panel8: TPanel;
    SpeedButton3: TSpeedButton;
    cbDrawBoardLines: TCheckBox;
    Label19: TLabel;
    clBoardLines: TCLColorButton;
    clEvent: TCLColorButton;
    Label20: TLabel;
    GroupBox2: TGroupBox;
    clSimulCurrentGame: TCLColorButton;
    Label21: TLabel;
    clSimulLeaderGame: TCLColorButton;
    Label22: TLabel;
    cbRemember: TCheckBox;
    tbPrivate: TTabSheet;
    Panel9: TPanel;
    lblEmail: TLabel;
    edtEmail: TEdit;
    Label23: TLabel;
    cbCountry: TComboBox;
    Label24: TLabel;
    cbSex: TComboBox;
    Label25: TLabel;
    Panel10: TPanel;
    btnPhoto: TBitBtn;
    Label26: TLabel;
    odPhoto: TOpenDialog;
    pnlPhoto: TPanel;
    imgPhoto: TImage;
    pnlSquareColor: TPanel;
    pnlPlainColor: TPanel;
    cbLightSquares: TCLColorButton;
    lblDarkSquares: TLabel;
    lblLightSquares: TLabel;
    cbDarkSquares: TCLColorButton;
    pnlThemeColor: TPanel;
    cmbTheme: TComboBox;
    imgSquare: TImage;
    Panel12: TPanel;
    rbPlainColor: TRadioButton;
    rbThemeColor: TRadioButton;
    cmbLastMove: TComboBox;
    GroupBox3: TGroupBox;
    chkOPen: TCheckBox;
    chkRejectWhilePlaying: TCheckBox;
    cbCReject: TCheckBox;
    cbPReject: TCheckBox;
    chkRemove: TCheckBox;
    GroupBox4: TGroupBox;
    lblInital: TLabel;
    lblPlus: TLabel;
    lblInc: TLabel;
    lblStyle: TLabel;
    lblRated: TLabel;
    lblColor: TLabel;
    lblMin: TLabel;
    lblMax: TLabel;
    edtInitial: TEdit;
    udInitial: TUpDown;
    cbDimension: TComboBox;
    edtInc: TEdit;
    cbGameType: TComboBox;
    edtMin: TEdit;
    udMin: TUpDown;
    edtMax: TEdit;
    udMax: TUpDown;
    pnlRated: TPanel;
    rbRated: TRadioButton;
    rbUnrated: TRadioButton;
    pnlColor: TPanel;
    rbWhite: TRadioButton;
    rbBlack: TRadioButton;
    rbServer: TRadioButton;
    udInc: TUpDown;
    tsMultimedia: TTabSheet;
    GroupBox6: TGroupBox;
    Label27: TLabel;
    cmbVideoDevices: TComboBox;
    Label28: TLabel;
    cmbAudioDevices: TComboBox;
    chkBadLagRestrict: TCheckBox;
    chkLoseOnDisconnect: TCheckBox;
    Panel13: TPanel;
    chkTimeEnding: TCheckBox;
    edtTimeEnding: TEdit;
    udTimeEnding: TUpDown;
    Label29: TLabel;
    GroupBox7: TGroupBox;
    chkTourShoutsEveryRound: TCheckBox;
    Panel14: TPanel;
    Label30: TLabel;
    reNotes: TRichEdit;
    lblBanNotes: TLabel;
    chkBusyStatus: TCheckBox;
    reColors: TRichEdit;
    btnShowColors: TBitBtn;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    lblPGNLocation: TLabel;
    edtPGNDirectory: TEdit;
    btnPGNDirectory: TButton;
    lblPGNFile: TLabel;
    edtPGNFile: TEdit;
    btnPGNFile: TButton;
    Label1: TLabel;
    Label3: TLabel;
    cbRatingType: TComboBox;
    Label4: TLabel;
    cbOrdType: TComboBox;
    Label5: TLabel;
    cbOrdDirection: TComboBox;
    Label31: TLabel;
    edAnnBlinkCount: TEdit;
    udAnnBlinkCount: TUpDown;
    Label32: TLabel;
    cbAnnAutoscroll: TCheckBox;
    chkPublicEmail: TCheckBox;
    Label33: TLabel;
    cbLanguage: TComboBox;
    cmbColorSchema: TComboBox;
    Label34: TLabel;
    Panel11: TPanel;
    btnPassword: TSpeedButton;
    cbShout: TCheckBox;
    chkShoutDuringGame: TCheckBox;
    chkAutoFlag: TCheckBox;
    chkPhotoChat: TGroupBox;
    chkPhotoPlayerList: TCheckBox;
    chkPhotoTournament: TCheckBox;
    chkPhotoGame: TCheckBox;
    lblAge: TLabel;
    Label35: TLabel;
    cbShowBirthday: TCheckBox;
    cmbDay: TComboBox;
    cmbMonth: TComboBox;
    cmbYear: TComboBox;
    Panel18: TPanel;
    lblMinAutoMatch: TLabel;
    edtMinAutoMatch: TEdit;
    udMinAutoMatch: TUpDown;
    lblMaxAutoMatch: TLabel;
    edtMaxAutoMatch: TEdit;
    udMaxAutoMatch: TUpDown;
    chkAutoMatch: TCheckBox;
    chkSeekWhilePlaying: TCheckBox;

    procedure btnAddAccountClick(Sender: TObject);
    procedure btnAddCommandClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnBackColorClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnDeleteAccountClick(Sender: TObject);
    procedure btnDeleteCommandClick(Sender: TObject);
    procedure btnEditAccountClick(Sender: TObject);
    procedure btnEditCommandClick(Sender: TObject);
    procedure btnFontColorClick(Sender: TObject);
    procedure btnMoveClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnPGNDirectoryClick(Sender: TObject);
    procedure btnPGNFileClick(Sender: TObject);
    procedure cbColorButtonClick(Sender: TObject);
    procedure cbFontNameChange(Sender: TObject);
    procedure cbFontSizeChange(Sender: TObject);
    procedure chkAttributeClick(Sender: TObject);
    procedure ControlChanged(Sender: TObject);
    procedure ControlChanged2(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lstTextClick(Sender: TObject);
    procedure lvAccountsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvCommandsDblClick(Sender: TObject);
    procedure lvCommandsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvSoundEventsDblClick(Sender: TObject);
    procedure lvSoundEventsEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure lvSoundEventsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure tsServerShow(Sender: TObject);
    procedure cbRatingTypeKeyPress(Sender: TObject; var Key: Char);
    procedure SpeedButton2Click(Sender: TObject);
    procedure cbOrdTypeChange(Sender: TObject);
    procedure cmbMoveStyleKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cmbMoveStyleKeyPress(Sender: TObject; var Key: Char);
    procedure chkPremoveClick(Sender: TObject);
    procedure cmbMoveStyleChange(Sender: TObject);
    procedure rbRatedClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure btnPhotoClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure rbPlainColorClick(Sender: TObject);
    procedure rbThemeColorClick(Sender: TObject);
    procedure PutThemeSquareImages;
    procedure cmbThemeChange(Sender: TObject);
    procedure btnPasswordClick(Sender: TObject);
    procedure chkTimeEndingClick(Sender: TObject);
    procedure reNotesChange(Sender: TObject);
    procedure btnShowColorsClick(Sender: TObject);
    procedure cmbColorSchemaChange(Sender: TObject);
    procedure dtBirthdayChange(Sender: TObject);
    procedure cmbMonthChange(Sender: TObject);
    procedure chkAutoMatchClick(Sender: TObject);

  private
  { Private declarations }
    FCreationComplete: Boolean;
    FGLTemp: TCLGlobal;
    FServerSettingChanged: Boolean;
    FPhotoChanged: Boolean;
    FClientSettingChanged: Boolean;
    imgPieces: TImage;
    SortingChanged: Boolean;
    NewPassword: string;
    FNotesChanged: Boolean;

    procedure UpdateCurrentPieces;
    procedure PlayTempSound;
    procedure ReadAccount(const Account: TAccount);
    procedure ReadCommand(const Command: TCommand);
    procedure DoEnabled;
    procedure DoEnabled2;
    procedure SendServerSettings;
    procedure SendPhoto;
    procedure MakeDevicesList;
    procedure SetDate(dt: TDateTime);
    function CurrentBirthday: TDateTime;

  public
  { Public declarations }
  end;

var
  fCLOptions: TfCLOptions;

implementation

uses
  CLAccount, CLCommandEdit, CLConst, CLSocket, CLTerminal, CLBoard, CLMain, CLLib, CLSocket2,
  CLPassword;

{$R *.DFM}

//______________________________________________________________________________
procedure TfCLOptions.PlayTempSound;
var
  Item: TListItem;
begin
  Item := lvSoundEvents.Selected;
  if Item <> nil then
    if Item.SubItems[0] <> '' then
      PlaySound(PChar(Item.SubItems[0]), 0, snd_ASYNC);
end;
//______________________________________________________________________________
procedure TfCLOptions.ReadAccount(const Account: TAccount);
var
  Item: TListItem;
begin
  Item := lvAccounts.FindData(0, Account, True, True);
  if Item = nil then
    begin
      Item := lvAccounts.Items.Add;
      Item.Data := Account;
      Item.SubItems.Add('');
      Item.SubItems.Add('');
      Item.SubItems.Add('');
      Item.SubItems.Add('');
      Item.SubItems.Add('');
      Item.SubItems.Add('');
    end;

  Item.Caption := Account.Name;
  Item.SubItems[0] := Account.Login;
  if Account.Password <> '' then Item.SubItems[1] := '******';
  Item.SubItems[2] := Account.Server;
  Item.SubItems[3] := IntToStr(Account.Port);
  { Removed for now. Item.SubItems[3] := _Account.Proxy; }
  Item.SubItems[4] := Account.Command;
end;
//______________________________________________________________________________
procedure TfCLOptions.ReadCommand(const Command: TCommand);
var
  Item: TListItem;
begin
  Item := lvCommands.FindData(0, Command, True, True);
  if Item = nil then
    begin
      Item := lvCommands.Items.Add;
      Item.Data := Command;
      Item.SubItems.Add('');
    end;

  Item.Caption := Command.Caption;
  Item.SubItems[0] := Command.Command;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnAddAccountClick(Sender: TObject);
var
  Account: TAccount;
begin
  Account := TAccount.Create;
  fCLAccount := TfCLAccount.Create(nil);
  fCLAccount.LoadAccount(Account);
  fCLAccount.IsNew := True;
  if fCLAccount.ShowModal = mrOK then
    begin
      FGLTemp.Accounts.Add(Account);
      ReadAccount(Account);
      ControlChanged(nil);
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnAddCommandClick(Sender: TObject);
var
  Command: TCommand;
begin
  Command := TCommand.Create;
  fCLCommandEdit := TfCLCommandEdit.Create(nil);
  fCLCommandEdit.LoadCommand(Command);
  if fCLCommandEdit.ShowModal = mrOK then
    begin
      ReadCommand(Command);
      FGLTemp.Commands.Add(Command);
      ControlChanged(nil);
    end
  else
    Command.Free;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnApplyClick(Sender: TObject);
var
  Index: Integer;
  s: string;
begin
  { Temporary Account, Command and Font variable are kept in sync during normal
    operations of this unit. }

  {if (cmbDay.ItemIndex = -1) or (cmbMonth.ItemIndex = -1) or (cmbYear.ItemIndex = -1) then begin
    showmessage('Define your birthday on the Profile page first!');
    exit;
  end;}

  if FClientSettingChanged then
    begin
      { Board Settings }
      FGLTemp.AutoQueen := chkQueen.Checked;
      FGLTemp.SmartMove := chkSmartMove.Checked;
      FGLTemp.ShowArrows := chkShowArrows.Checked;
      FGLTemp.ShowCaptured := chkShowCaptured.Checked;
      FGLTemp.ShowCoordinates := chkShowCoordinates.Checked;
      FGLTemp.ShowLegal := chkShowLegal.Checked;
      FGLTemp.ShowLastMove := cmbLastMove.ItemIndex<>2;
      FGLTemp.ShowLastMoveType := cmbLastMove.ItemIndex;
      FGLTemp.LogGames := TLogGame(cmboLogGames.ItemIndex);
      FGLTemp.LightSquare := cbLightSquares.ButtonColor;
      FGLTemp.DarkSquare := cbDarkSquares.ButtonColor;
      FGLTemp.LightPiece := cbLightPieces.ButtonColor;
      FGLTemp.DarkPiece := cbDarkPieces.ButtonColor;
      FGLTemp.HighLight := cbHighLight.ButtonColor;
      FGLTemp.ClockColor := cbGameClock.ButtonColor;
      FGLTemp.PieceSetNumber := pnlPieces.Tag;

      { General }
      edtPGNDirectory.Text := Trim(edtPGNDirectory.Text);
      if DirectoryExists(edtPGNDirectory.Text)
      or  (edtPGNDirectory.Text = '') then
        FGLTemp.PGNDirectory := edtPGNDirectory.Text;

      edtPGNFile.Text := Trim(edtPGNFile.Text);
      if FileExists(edtPGNFile.Text)
      or (edtPGNFile.Text = '') then
        FGLTemp.PGNFile := Trim(edtPGNFile.Text);

      { Text }
      FGLTemp.ConsoleColor := cbConsoleColor.ButtonColor;
      FGLTemp.ConsoleTextColor := cbConsoleTextColor.ButtonColor;

      { Sounds }
      FGLTemp.MuteSounds := chkMute.Checked;
      for Index := Low(FGLTemp.Sounds) to High(FGLTemp.Sounds) do
        FGLTemp.Sounds[Index] := lvSoundEvents.Items[Index].SubItems[0];

      FGLTemp.RatingType := cbRatingType.ItemIndex;
      FGLTemp.UserColorChat := chkUserColor.Checked;
      FGLTemp.CReject := cbCReject.Checked;
      FGLTemp.Shout := cbShout.Checked;
      FGLTemp.Premove := chkPremove.Checked;

      FGLTemp.OrdType := cbOrdType.ItemIndex;
      FGLTemp.OrdDirection := cbOrdDirection.ItemIndex;
      FGLTemp.MoveStyle := cmbMoveStyle.ItemIndex;
      FGLTemp.PremoveColor := clPremove.ButtonColor;
      FGLTemp.ClickColor := clClick.ButtonColor;

      fGLTemp.PremoveStyle:=cmbPremoveStyle.ItemIndex;
      fGLTemp.MoveSquare:=chkMoveSquare.Checked;
      fGLTemp.LegalMoveColor:=clLegal.ButtonColor;
      fGLTemp.IllegalMoveColor:=clIllegal.ButtonColor;
      fGLTemp.AggressivePremove:=chkAggressive.Checked;

      fGLTemp.FramesColor := clFrames.ButtonColor;
      fGLTemp.NotifyColor := clNotify.ButtonColor;
      fGLTemp.EventColor := clEvent.ButtonColor;
      fGLTemp.DefaultBackgroundColor := clDefaultBackground.ButtonColor;
      fGLTemp.BoardBackgroundColor := clBoardBackground.ButtonColor;
      fGLTemp.SeekBulletColor := clBullet.ButtonColor;
      fGLTemp.SeekBlitzColor := clBlitz.ButtonColor;
      fGLTemp.SeekStandardColor := clStandard.ButtonColor;
      fGLTemp.SeekLoosersColor := clLoosers.ButtonColor;
      fGLTemp.SeekFisherColor := clFisher.ButtonColor;
      fGLTemp.SeekCrazyColor := clCrazy.ButtonColor;
      fGLTemp.SeekTitleCColor := clTitleC.ButtonColor;
      FGLTemp.DrawBoardLines := cbDrawBoardLines.Checked;
      FGLTemp.BoardLinesColor := clBoardLines.ButtonColor;
      FGLTemp.SimulCurrentGameColor := clSimulCurrentGame.ButtonColor;
      FGLTemp.SimulLeaderGameColor := clSimulLeaderGame.ButtonColor;
      FGLTemp.RememberPassword := cbRemember.Checked;
      FGLTemp.PReject := cbPReject.Checked;
      FGLTemp.ShoutDuringGame := chkShoutDuringGame.Checked;
      FGLTemp.PhotoPlayerList := chkPhotoPlayerList.Checked;
      FGLTemp.PhotoGame := chkPhotoGame.Checked;
      FGLTemp.PhotoTournament := chkPhotoTournament.Checked;
      FGLTemp.BadLagRestrict := chkBadLagRestrict.Checked;

      if rbPlainColor.Checked then FGLTemp.ThemeSquareIndex:=-1
      else FGLTemp.ThemeSquareIndex:=cmbTheme.ItemIndex;

      FGLTemp.VideoInputDevice := cmbVideoDevices.Text;
      FGLTemp.AudioInputDevice := cmbAudioDevices.Text;
      FGLTemp.LoseOnDisconnect := chkLoseOnDisconnect.Checked;
      FGLTemp.AllowSeekWhilePlaying := chkSeekWhilePlaying.Checked;

      FGLTemp.TimeEndingEnabled := chkTimeEnding.Checked;
      FGLTemp.TimeEndingLimit := udTimeEnding.Position;
      FGLTemp.SeeTourShoutsEveryRound := chkTourShoutsEveryRound.Checked;
      FGLTemp.BusyStatus := chkBusyStatus.Checked;

      fGLTemp.AnnouncementBlinkCount := udAnnBlinkCount.Position;
      fGLTemp.AnnouncementAutoscroll := cbAnnAutoscroll.Checked;
      FGLTemp.SchemaIndex := cmbColorSchema.ItemIndex;

      FGLTemp.Save;
      fGL.Load;

      fCLTerminal.AssignFont;
      fCLTerminal.CreateMenuItems;
      fCLTerminal.CurrentRType:=fGL.RatingType;
      fCLTerminal.ccConsole.UserColor:=fGL.UserColorChat;
      fCLTerminal.ccConsole.DrawText;
      fCLBoard.ColorizePieces;
      fCLBoard.FormResize(fclBoard);
      { ??? need to force repaint of the board if color is changed. }
    end;

  { Server }
  { The FGLTemp.Save and fGL.Load above must happen before sending a setall
    command to the server. }
  if FServerSettingChanged then
    SendServerSettings;

  if FPhotoChanged then begin
    CopyBitMap(imgPhoto.Picture.Bitmap,fGL.Photo64);
    SendPhoto;
  end;

  if FNotesChanged then
    fCLSocket.InitialSend([CMD_STR_NOTES, EncryptANSI(reNotes.Text)]);

  if SortingChanged then begin
    fCLTerminal.LoadLogins;
    SortingChanged := false;
  end;
  btnApply.Enabled := False;
  fCLTerminal.SetFontSize(fGL.ConsoleFont.Size);
end;
//______________________________________________________________________________
procedure TfCLOptions.btnBackColorClick(Sender: TObject);
begin
  ColorDialog1.Color := FGLTemp.FontTraits[lstText.ItemIndex].BackColor;
  if ColorDialog1.Execute then
    begin
      FGLTemp.FontTraits[lstText.ItemIndex].BackColor := ColorDialog1.Color;
      pnlSample.Color := ColorDialog1.Color;
      ControlChanged(nil);
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnBrowseClick(Sender: TObject);
var
  Len: Integer;
  WinDir: string;
begin
    Len := GetWindowsDirectory(nil, 0);
    SetLength(WinDir, Len - 1);
    GetWindowsDirectory(PChar(WinDir), Len);
    if DirectoryExists(WinDir + '\Media') then WinDir := WinDir + '\Media';

  with OpenDialog1 do
    begin
      DefaultExt := 'wav';
      Filter := 'Sounds (*.wav)|*.wav';
      if InitialDir = '' then InitialDir := WinDir;
      Title := 'Browse for ' + lvSoundEvents.Selected.Caption + ' Sound';
      if Execute then
        begin
          lvSoundEvents.Selected.SubItems[0] := OpenDialog1.FileName;
          FGLTemp.Sounds[lvSoundEvents.Selected.Index] := OpenDialog1.FileName;
          PlayTempSound;
          ControlChanged(btnBrowse);
        end;
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnClearClick(Sender: TObject);
begin
  lvSoundEvents.Selected.SubItems[0] := '';
  ControlChanged(btnClear);
end;
//______________________________________________________________________________
procedure TfCLOptions.btnDeleteAccountClick(Sender: TObject);
var
  Item: TListItem;
begin
  Item := lvAccounts.Selected;
  if Item = nil then Exit;
  TAccount(Item.Data).Free;
  FGLTemp.Accounts.Remove(Item.Data);
  Item.Free;
  ControlChanged(nil);
end;
//______________________________________________________________________________
procedure TfCLOptions.btnDeleteCommandClick(Sender: TObject);
var
  Item: TListItem;
begin
  Item := lvCommands.Selected;
  if Item = nil then Exit;
  TCommand(Item.Data).Free;
  FGLTemp.Commands.Remove(Item.Data);
  Item.Free;
  ControlChanged(nil);
end;
//______________________________________________________________________________
procedure TfCLOptions.btnEditAccountClick(Sender: TObject);
var
  Account: TAccount;
  Item: TListItem;
begin
  Item := lvAccounts.Selected;
  if Item = nil then Exit;
  Account := Item.Data;
  fCLAccount := TfCLAccount.Create(nil);
  fCLAccount.LoadAccount(Account);
  if fCLAccount.ShowModal = mrOK then
    begin
      ReadAccount(Account);
      ControlChanged(nil);
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnEditCommandClick(Sender: TObject);
var
  Command: TCommand;
  Item: TListItem;
begin
  Item := lvCommands.Selected;
  if Item = nil then Exit;
  Command := Item.Data;
  fCLCommandEdit := TfCLCommandEdit.Create(nil);
  fCLCommandEdit.LoadCommand(Command);
  if fCLCommandEdit.ShowModal = mrOK then
    begin
      ReadCommand(Command);
      ControlChanged(nil);
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnFontColorClick(Sender: TObject);
begin
  ColorDialog1.Color := FGLTemp.FontTraits[lstText.ItemIndex].ForeColor;
  if ColorDialog1.Execute then
    begin
      FGLTemp.FontTraits[lstText.ItemIndex].ForeColor := ColorDialog1.Color;
      pnlSample.Font.Color := ColorDialog1.Color;
      ControlChanged(nil);
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnMoveClick(Sender: TObject);
var
  _Index, Direction: Integer;
  Item: TListItem;
begin
  Direction := TButton(Sender).Tag;

  with lvCommands do
    begin
      _Index := Selected.Index;
      Item := TListItem.Create(Items);
      Item.Assign(Selected);
      Items[_Index] := Items[_Index + Direction];
      Items[_Index + Direction].Assign(Item);
      Items[_Index + Direction].Selected := True;
    end;
  Item.Free;
  FGLTemp.Commands.Exchange(_Index, _Index + Direction);
  ControlChanged(Sender);
end;
//______________________________________________________________________________
procedure TfCLOptions.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then btnApplyClick(btnOK);
  fCLMain.SetFormColors;
  Close;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnPGNDirectoryClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectDirectory('Open', '', Dir) then edtPGNDirectory.Text := Dir;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnPGNFileClick(Sender: TObject);
var
  TempFileName: string;
begin
  with OpenDialog1 do
    begin
      DefaultExt := 'pgn';
      TempFileName := FileName;
      FileName := FGLTemp.PGNFile;
      Filter := 'Portable Game Notation (*.pgn, *.txt)|*.pgn;*.txt';
      Title := 'Choose PGN file for logging games';
      if Execute then edtPGNFile.Text := FileName;
      FileName := TempFileName;
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.cbColorButtonClick(Sender: TObject);
begin
  ColorDialog1.Color := TCLColorButton(Sender).ButtonColor;
  if ColorDialog1.Execute then
    begin
      TCLColorButton(Sender).ButtonColor := ColorDialog1.Color;
      ControlChanged(Sender);
      cmbColorSchema.ItemIndex := 0;
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.cbFontNameChange(Sender: TObject);
begin
  FGLTemp.ConsoleFont.Name := cbFontName.FontName;
  pnlSample.Font.Name := cbFontName.FontName;
  ControlChanged(nil);
end;
//______________________________________________________________________________
procedure TfCLOptions.cbFontSizeChange(Sender: TObject);
begin
  FGLTemp.ConsoleFont.Size := StrToInt(cbFontSize.Text);
  pnlSample.Font.Size := FGLTemp.ConsoleFont.Size;
  ControlChanged(nil);
end;
//______________________________________________________________________________
procedure TfCLOptions.chkAttributeClick(Sender: TObject);
var
  FontStyles: TFontStyles;
begin
  if (Sender as TWinControl) <> ActiveControl then Exit;

  FontStyles := FGLTemp.FontTraits[lstText.ItemIndex].FontStyle;
  FontStyles := [];
  if chkBold.Checked then Include(FontStyles, fsBold);
  if chkItalics.Checked then Include(FontStyles, fsItalic);
  FGLTemp.FontTraits[lstText.ItemIndex].FontStyle := FontStyles;
  pnlSample.Font.Style := FontStyles;
  ControlChanged(nil);
end;
//______________________________________________________________________________
procedure TfCLOptions.ControlChanged(Sender: TObject);
begin
  FClientSettingChanged := FCreationComplete;
  btnApply.Enabled := FCreationComplete;
end;
//______________________________________________________________________________
procedure TfCLOptions.ControlChanged2(Sender: TObject);
begin
  FServerSettingChanged := FCreationComplete;
  btnApply.Enabled := FCreationComplete;
end;
//______________________________________________________________________________
procedure TfCLOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FGLTemp.Free;
  fCLOptions := nil;
  Action := caFree;
end;
//______________________________________________________________________________
procedure TfCLOptions.FormCreate(Sender: TObject);
var
  Index,i,initmin,initsec,dimindex,n: Integer;
  y, m, d: word;
  b: Boolean;
begin
  cmbDay.Items.Clear;
  for i := 1 to 31 do
    cmbDay.Items.Add(IntToStr(i));

  DecodeDate(Date,y,m,d);
  cmbYear.Items.Clear;
  for i := y - 6 downto 1900 do
    cmbYear.Items.Add(IntToStr(i));


  Screen.Cursor := crHourGlass;
  SortingChanged := false;

  FServerSettingChanged := False;
  FClientSettingChanged := False;
  FPhotoChanged := False;

  FGLTemp := TCLGlobal.Create;

  { Accounts }
  for Index := 0 to FGLTemp.Accounts.Count -1 do
    ReadAccount(FGLTemp.Accounts[Index]);

  { Board Settings }
  chkQueen.Checked := FGLTemp.AutoQueen;
  chkSmartMove.Checked := FGLTemp.SmartMove;
  chkShowCoordinates.Checked := FGLTemp.ShowCoordinates;
  chkShowLegal.Checked := FGLTemp.ShowLegal;
  cmbLastMove.ItemIndex := FGLTemp.ShowLastMoveType;
  chkShowArrows.Checked := FGLTemp.ShowArrows;
  chkShowCaptured.Checked := FGLTemp.ShowCaptured;
  cmboLogGames.ItemIndex := Ord(FGLTemp.LogGames);
  cbLightSquares.ButtonColor := FGLTemp.LightSquare;
  cbDarkSquares.ButtonColor := FGLTemp.DarkSquare;
  cbLightPieces.ButtonColor := FGLTemp.LightPiece;
  cbDarkPieces.ButtonColor := FGLTemp.DarkPiece;
  cbHighLight.ButtonColor := FGLTemp.HighLight;
  cbGameClock.ButtonColor := FGLTemp.ClockColor;
  cbCReject.Checked :=FGLTemp.CReject;
  cbPReject.Checked :=FGLTemp.PReject;
  cbOrdType.ItemIndex := FGLTemp.OrdType;
  cbOrdDirection.ItemIndex := FGLTemp.OrdDirection;

  { Commands }
  for Index := 0 to FGLTemp.Commands.Count -1 do
    ReadCommand(FGLTemp.Commands[Index]);

  { General }
  edtPGNDirectory.Text := FGLTemp.PGNDirectory;
  edtPGNFile.Text := FGLTemp.PGNFile;

  { Sounds }
  chkMute.Checked := FGLTemp.MuteSounds;
  for Index := Low(FGLTemp.Sounds) to High(FGLTemp.Sounds) do
    lvSoundEvents.Items[Index].SubItems[0] := FGLTemp.Sounds[Index];

  { Fonts }
  cbFontName.FontName := FGLTemp.ConsoleFont.Name;
  cbFontSize.Text := IntToStr(FGLTemp.ConsoleFont.Size);
  cbConsoleColor.ButtonColor := FGLTemp.ConsoleColor;
  cbConsoleTextColor.ButtonColor := FGLTemp.ConsoleTextColor;
  pnlSample.Font.Name := FGLTemp.ConsoleFont.Name;
  pnlSample.Font.Size := FGLTemp.ConsoleFont.Size;
  lstText.ItemIndex := 0;
  lstText.OnClick(nil);

  { Server }
  { Set edit boxes to accept only 0..9 }
  SetWindowLong(edtInitial.Handle, GWL_STYLE,
    GetWindowLong(edtInitial.Handle, GWL_STYLE) or ES_NUMBER);
  SetWindowLong(edtInc.Handle, GWL_STYLE,
    GetWindowLong(edtInc.Handle, GWL_STYLE) or ES_NUMBER);
  SetWindowLong(edtMin.Handle, GWL_STYLE,
    GetWindowLong(edtMin.Handle, GWL_STYLE) or ES_NUMBER);
  SetWindowLong(edtMax.Handle, GWL_STYLE,
    GetWindowLong(edtMax.Handle, GWL_STYLE) or ES_NUMBER);

  chkAutoFlag.Checked := fGL.AutoFlag;
  chkOpen.Checked := fGL.Open;
  chkRemove.Checked := fGL.RemoveOffers;
  TimeToComponents(fGL.SeekInitial,initmin,initsec,dimindex);
  if dimindex = 0 then
    udInitial.Position:=initmin
  else
    udInitial.Position := initmin * 60 + initsec;
  cbDimension.ItemIndex:=dimindex;

  udInc.Position := fGL.SeekInc;
  edtInc.Text := IntToStr(fGL.SeekInc);
  if fGL.SeekType < 3 then
    cbGameType.ItemIndex := 0
  else
    cbGameType.ItemIndex := fGL.SeekType - 2;
  rbRated.Checked := fGL.SeekRated;
  rbUnrated.Checked := not fGL.SeekRated;
  rbWhite.Checked := fGL.SeekColor = 1;
  rbBlack.Checked := fGL.SeekColor = -1;
  rbServer.Checked := fGL.SeekColor = 0;
  udMin.Position := fGL.SeekMinimum;
  edtMin.Text := IntToStr(fGL.SeekMinimum);
  udMax.Position := fGL.SeekMaximum;
  edtMax.Text := IntToStr(fGL.SeekMaximum);

  cbRatingType.ItemIndex := fGL.RatingType;
  chkUserColor.Checked := fGL.UserColorChat;
  cbCReject.Checked := fGL.CReject;
  cbPReject.Checked := fGL.PReject;
  cbShout.Checked := fGL.Shout;
  chkPremove.Checked := fGL.Premove;
  cmbMoveStyle.ItemIndex := fGL.MoveStyle;
  clPremove.ButtonColor := fGL.PremoveColor;
  clClick.ButtonColor := fGL.ClickColor;

  cmbPremoveStyle.ItemIndex:=fGL.PremoveStyle;
  chkMoveSquare.Checked:=fGL.MoveSquare;
  clLegal.ButtonColor:=fGL.LegalMoveColor;
  clIllegal.ButtonColor:=fGL.IllegalMoveColor;
  chkAggressive.Checked:=fGL.AggressivePremove;

  clFrames.ButtonColor:=fGL.FramesColor;
  clNotify.ButtonColor:=fGL.NotifyColor;
  clEvent.ButtonColor:=fGL.EventColor;
  clDefaultBackground.ButtonColor:=fGL.DefaultBackgroundColor;
  clBoardBackground.ButtonColor:=fGL.BoardBackgroundColor;
  clBullet.ButtonColor:=fGL.SeekBulletColor;
  clBlitz.ButtonColor:=fGL.SeekBlitzColor;
  clStandard.ButtonColor:=fGL.SeekStandardColor;
  clLoosers.ButtonColor:=fGL.SeekLoosersColor;
  clFisher.ButtonColor:=fGL.SeekFisherColor;
  clCrazy.ButtonColor:=fGL.SeekCrazyColor;
  clTitleC.ButtonColor:=fGL.SeekTitleCColor;
  cbDrawBoardLines.Checked:=fGL.DrawBoardLines;
  clBoardLines.ButtonColor:=fGL.BoardLinesColor;
  clSimulCurrentGame.ButtonColor:=fGL.SimulCurrentGameColor;
  clSimulLeaderGame.ButtonColor:=fGL.SimulLeaderGameColor;
  cbRemember.Checked:=fGL.RememberPassword;

  edtEmail.Text:=fGL.Email;
  cbCountry.ItemIndex:=fGL.CountryId;
  cbSex.ItemIndex:=fGL.SexId;
  SetDate(fGL.Birthday);
  cbShowBirthday.Checked := fGL.ShowBirthday;
  lblAge.Caption := AgeByBirthday(fGL.Birthday);
  chkPublicEmail.Checked:=fGL.PublicEmail;
  n:=cbLanguage.Items.IndexOf(fGL.Language);
  cbLanguage.ItemIndex:=n;


  FCreationComplete := True;

  pnlPieces.Tag:=fGL.PieceSetNumber;
  UpdateCurrentPieces;
  DoEnabled;
  DoEnabled2;

  Screen.Cursor := crDefault;

  imgPhoto.Visible:=not fGL.Photo64.Empty;
  if not fGL.Photo64.Empty then begin
    pnlPhoto.Caption:='';
    CopyBitMap(fGL.Photo64,imgPhoto.Picture.Bitmap)
  end else
    pnlPhoto.Caption:='NO PHOTO';

  rbThemeColor.Enabled:=fSquareLib.Schemas.Count>0;
  rbPlainColor.Enabled:=rbThemeColor.Enabled;

  cmbTheme.Clear;
  for i:=0 to fSquareLib.Schemas.Count-1 do begin
    cmbTheme.Items.Add(fSquareLib.Schemas[i].Name);
  end;

  if fGL.ThemeSquareIndex=-1 then
    rbPlainColor.Checked:=true
  else begin
    rbThemeColor.Checked:=true;
    cmbTheme.ItemIndex:=fGL.ThemeSquareIndex;
    PutThemeSquareImages;
  end;
  chkShoutDuringGame.Checked:=fGL.ShoutDuringGame;
  chkRejectWhilePlaying.Checked:=fGL.RejectWhilePlaying;

  chkPhotoPlayerList.Checked:=fGL.PhotoPlayerList;
  chkPhotoGame.Checked:=fGL.PhotoGame;
  chkPhotoTournament.Checked:=fGL.PhotoTournament;
  chkBadLagRestrict.Checked:=fGL.BadLagRestrict;
  chkLoseOnDisconnect.Checked:=fGL.LoseOnDisconnect;
  chkSeekWhilePlaying.Checked := fGL.AllowSeekWhilePlaying;
  chkTimeEnding.Checked:=fGL.TimeEndingEnabled;
  udTimeEnding.Position:=fGL.TimeEndingLimit;
  chkTourShoutsEveryRound.Checked:=fGL.SeeTourShoutsEveryRound;
  chkBusyStatus.Checked:=fGL.BusyStatus;

  reNotes.Text := fCLSocket.MyNotes;
  FNotesChanged := false;

  reNotes.Enabled := fCLSocket.Rights.SelfProfile;
  lblBanNotes.Visible := not fCLSocket.Rights.SelfProfile;

  MakeDevicesList;

  reColors.Visible := DebugHook <> 0;
  btnShowColors.Visible := DebugHook <> 0;

  udAnnBlinkCount.Position := fGL.AnnouncementBlinkCount;
  cbAnnAutoscroll.Checked := fGL.AnnouncementAutoscroll;

  cmbColorSchema.ItemIndex := fGL.SchemaIndex;

  chkAutoMatch.Checked := fGL.AutoMatch;
  udMinAutoMatch.Position := fGL.AutoMatchMinR;
  udMaxAutoMatch.Position := fGL.AutoMatchMaxR;
  chkAutoMatch.OnClick(nil);

end;
//______________________________________________________________________________
procedure TfCLOptions.lstTextClick(Sender: TObject);
var
  T: TFontTrait;
begin
  T := FGLTemp.FontTraits[lstText.ItemIndex];
  chkBold.Checked := fsBold in T.FontStyle;
  chkItalics.Checked := fsItalic in T.FontStyle;
  with pnlSample do
    begin
      Color := T.BackColor;
      Font.Color := T.ForeColor;
      Font.Style := T.FontStyle;
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.lvAccountsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  btnEditAccount.Enabled := Selected;
  btnDeleteAccount.Enabled := Selected;
end;
//______________________________________________________________________________
procedure TfCLOptions.lvCommandsDblClick(Sender: TObject);
begin
  if lvCommands.Selected <> nil then btnEditCommand.Click;
end;
//______________________________________________________________________________
procedure TfCLOptions.lvCommandsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  btnEditCommand.Enabled := Selected;
  btnDeleteCommand.Enabled := Selected;
  btnMoveUp.Enabled := Selected and (Item.Index > 0);
  btnMoveDown.Enabled := Selected and (Item.Index < lvCommands.Items.Count -1);
end;
//______________________________________________________________________________
procedure TfCLOptions.lvSoundEventsDblClick(Sender: TObject);
begin
  if lvSoundEvents.Selected <> nil then btnBrowse.Click;
end;
//______________________________________________________________________________
procedure TfCLOptions.lvSoundEventsEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  { This is necessary because design-time populated Items of a READONLY Listview
    are not available during form creation which is when we set the values.
    The solution is to leave it as NOT READONLY and not allow editing.
    A ReadOnly listview requires a new handle at creation time which frees the
    Items just when we need them. The alternative is to create the ListView
    Items at runtime. }
  AllowEdit := False;
end;
//______________________________________________________________________________
procedure TfCLOptions.lvSoundEventsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if Selected then PlayTempSound;
  btnBrowse.Enabled := Selected;
  btnClear.Enabled := Selected;
end;
//______________________________________________________________________________
procedure TfCLOptions.tsServerShow(Sender: TObject);
begin
  { Work-around. If the Associate property is set at design time it will cause
    an OnChange event of the TEdits to fire when the TTabSheet page is first
    displayed. }
  if udInitial.Associate = nil then
    begin
      udInitial.Associate := edtInitial;
      udInc.Associate := edtInc;
      udMin.Associate := edtMin;
      udMax.Associate := edtMax;
    end;
end;
//______________________________________________________________________________
procedure TfCLOptions.cbRatingTypeKeyPress(Sender: TObject; var Key: Char);
begin
  Key:=#0;
end;
//______________________________________________________________________________
procedure TfCLOptions.UpdateCurrentPieces;
begin
  if Assigned(imgPieces) then begin
    pnlPieces.RemoveControl(imgPieces);
    imgPieces.Free;
  end;
  imgPieces:=TImage.Create(pnlPieces);
  imgPieces.Width:=pnlPieces.Width;
  imgPieces.Height:=pnlPieces.Height;
  imgPieces.Transparent:=false;
  pnlPieces.InsertControl(imgPieces);
  pnlPieces.Color:=cbLightSquares.ButtonColor;
  GetPieceSet(pnlPieces.Tag,imgPieces.Height div 2,imgPieces.Picture.Bitmap);
  cbLightPieces.Visible:=pnlPieces.Tag=0;
  cbDarkPieces.Visible:=pnlPieces.Tag=0;
  lblLightPieces.Visible:=pnlPieces.Tag=0;
  lblDarkPieces.Visible:=pnlPieces.Tag=0;
end;
//______________________________________________________________________________
procedure TfCLOptions.SpeedButton2Click(Sender: TObject);
begin
  pnlPieces.Tag:=pnlPieces.Tag+(Sender as TSpeedButton).Tag;
  if pnlPieces.Tag>fGL.MaxPieceSetNumber then
    pnlPieces.Tag:=0
  else if pnlPieces.Tag<0 then
    pnlPieces.Tag:=fGL.MaxPieceSetNumber;
  UpdateCurrentPieces;
  ControlChanged(Sender);
end;
//______________________________________________________________________________
procedure TfCLOptions.cbOrdTypeChange(Sender: TObject);
begin
  FClientSettingChanged := FCreationComplete;
  btnApply.Enabled := FCreationComplete;
  SortingChanged:=true;
end;
//______________________________________________________________________________
procedure TfCLOptions.cmbMoveStyleKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key:=0;
end;
//______________________________________________________________________________
procedure TfCLOptions.cmbMoveStyleKeyPress(Sender: TObject; var Key: Char);
begin
  Key:=#0;
end;
//______________________________________________________________________________
procedure TfCLOptions.DoEnabled;
begin
  clClick.Enabled:=cmbMoveStyle.ItemIndex = 1;
  lblClick.Enabled := clClick.Enabled;
  clPremove.Enabled := chkPremove.Checked;
  lblPremove.Enabled := clPremove.Enabled;
  cmbPremoveStyle.Enabled := chkPremove.Checked;
  clLegal.Enabled:=chkMoveSquare.Checked;
  lblLegal.Enabled:=chkMoveSquare.Checked;
  clIllegal.Enabled:=chkMoveSquare.Checked;
  lblIllegal.Enabled:=chkMoveSquare.Checked;
end;
//______________________________________________________________________________
procedure TfCLOptions.chkPremoveClick(Sender: TObject);
begin
  ControlChanged(Sender);
  DoEnabled;
end;
//______________________________________________________________________________
procedure TfCLOptions.cmbMoveStyleChange(Sender: TObject);
begin
  ControlChanged(Sender);
  DoEnabled;
end;
//______________________________________________________________________________
procedure TfCLOptions.DoEnabled2;
begin
  if rbRated.Checked then
    rbServer.Checked:=true;
  rbWhite.Enabled:=not rbRated.Checked;
  rbBlack.Enabled:=not rbRated.Checked;
  rbServer.Enabled:=not rbRated.Checked;
end;
//______________________________________________________________________________
procedure TfCLOptions.rbRatedClick(Sender: TObject);
begin
  DoEnabled2;
  ControlChanged2(Sender);
end;
//______________________________________________________________________________
procedure TfCLOptions.SpeedButton3Click(Sender: TObject);
begin
  clFrames.ButtonColor :=  DefFramesColor;
  clNotify.ButtonColor :=  DefNotifyColor;
  clEvent.ButtonColor := DefEventColor;
  clDefaultBackground.ButtonColor :=  DefDefaultBackgroundColor;
  clBoardBackground.ButtonColor :=  DefBoardBackgroundColor;
  clBullet.ButtonColor :=  DefSeekBulletColor;
  clBlitz.ButtonColor :=  DefSeekBlitzColor;
  clStandard.ButtonColor :=  DefSeekStandardColor;
  clLoosers.ButtonColor :=  DefSeekLoosersColor;
  clFisher.ButtonColor :=  DefSeekFisherColor;
  clCrazy.ButtonColor :=  DefSeekCrazyColor;
  clTitleC.ButtonColor :=  DefSeekTitleCColor;
  clSimulCurrentGame.ButtonColor := DefSimulCurrentGameColor;
  clSimulLeaderGame.ButtonColor := DefSimulLeaderGameColor;
  ControlChanged(Sender);
end;
//______________________________________________________________________________
procedure TfCLOptions.SendServerSettings;
var
  sColor,sInitial,sRatedType: string;
begin
  if fCLSocket.InitState < isLoginComplete then begin
    Application.MessageBox('Server setting changes made while disconnected from the server will be ignored.',
      'Warning', MB_ICONWARNING);
    exit;
  end;

  if cbDimension.ItemIndex=0 then sInitial:=edtInitial.Text
  else
    if udInitial.Position<10 then sInitial:='0.10'
    else sInitial:='0.'+edtInitial.Text;

  if rbWhite.Checked then sColor:='1'
  else if rbBlack.Checked then sColor:='-1'
  else sColor:='0';

  if cbGameType.ItemIndex = 0 then sRatedType:='0'
  else sRatedType:=IntToStr(cbGameType.ItemIndex+2);

  fCLSocket.InitialSend([CMD_STR_SET_ALL,
    BoolTo_(chkAutoFlag.Checked,'1','0'),
    BoolTo_(chkOpen.Checked,'1','0'),
    BoolTo_(chkRemove.Checked,'1','0'),
    sInitial,
    edtInc.Text,
    sColor,
    BoolTo_(rbRated.Checked,'1','0'),
    sRatedType,
    edtMax.Text,
    edtMin.Text,
    BoolTo_(cbCReject.Checked,'1','0'),
    BoolTo_(cbPReject.Checked,'1','0'),
    edtEmail.Text,
    IntToStr(cbCountry.ItemIndex),
    IntToStr(cbSex.ItemIndex),
    '0',
    BoolTo_(chkRejectWhilePlaying.Checked,'1','0'),
    BoolTo_(chkBadLagRestrict.Checked,'1','0'),
    BoolTo_(chkLoseOnDisconnect.Checked,'1','0'),
    BoolTo_(chkTourShoutsEveryRound.Checked,'1','0'),
    BoolTo_(chkBusyStatus.Checked,'1','0'),
    cbLanguage.Text,
    BoolTo_(chkPublicEmail.Checked,'1','0'),
    IntToStr(Trunc(CurrentBirthday)),
    BoolTo_(cbShowBirthday.Checked, '1', '0'),
    BoolTo_(chkAutoMatch.Checked,'1','0'),
    edtMinAutoMatch.Text,
    edtMaxAutoMatch.Text,
    BoolTo_(chkSeekWhilePlaying.Checked,'1','0')]);

  if NewPassword<>'' then
    fCLSocket.InitialSend([CMD_STR_CHANGE_PASSWORD,fCLSocket.MyName,CURRENT_PASSWORD,NewPassword]);
end;
//______________________________________________________________________________
procedure TfCLOptions.btnPhotoClick(Sender: TObject);
var
  st: TStringStream;
  s, ext: string;
  bmp: TBitMap;
  jpg: TJpegImage;
begin

  if not fCLSocket.Rights.SelfProfile then begin
    MessageDlg('You are banned and cannot edit photo in profile!', mtError, [mbOk], 0);
    exit;
  end;

  if not odPhoto.Execute then exit;

  ext:=GetExtension(odPhoto.FileName);

  bmp:=TBitMap.Create;
  if ext='bmp' then
    bmp.LoadFromFile(odPhoto.FileName)
  else begin
    jpg:=TJpegImage.Create;
    try
      jpg.LoadFromFile(odPhoto.FileName);
      bmp.Assign(jpg);
    finally
      jpg.Free;
    end;
  end;

  if (bmp.Width>96) or (bmp.Height>96) then
    CompressImageSpecifiedSize(bmp,96,96,bmp.PixelFormat);
  CopyBitMap(bmp,imgPhoto.Picture.Bitmap);
  
  //imgPhoto.Picture.LoadFromFile(odPhoto.FileName);
  imgPhoto.Visible:=true;
  FPhotoChanged:=true;
end;
//______________________________________________________________________________
procedure TfCLOptions.SendPhoto;
var
  s: string;
begin
  if fGL.Photo64.Empty then
    if fCLSocket2.Connected then
      fCLSocket2.Send([CMM_PHOTO,'1','-'])
    else
      fCLSocket.InitialSend([CMD_STR_PHOTO_SEND,'1','jpg','-'])
  else begin
    s:=BitMapToANSIString(fGL.Photo64);
    if fCLSocket2.Connected then
      fCLSocket2.Send([CMM_PHOTO,'1','jpg',s])
    else
      fCLSocket.InitialSend([CMD_STR_PHOTO_SEND,'1','jpg',s])
  end;
end;
//______________________________________________________________________________
procedure TfCLOptions.BitBtn1Click(Sender: TObject);
var
  st: TStringStream;
begin
  {st:=TStringStream.Create('');

  imgPhoto.Picture.Bitmap.SaveToStream(st);
  SaveStrToFile('d:\photo.bmp',st.DataString);
  imgPhoto.Canvas.Rectangle(0,0,63,63);
  imgPhoto.Picture.Bitmap.LoadFromFile('d:\photo.bmp');
  {imgPhoto.Picture.Bitmap.SaveToFile('d:\1.bmp');
  imgPhoto.Canvas.Rectangle(0,0,63,63);
  imgPhoto.Picture.Bitmap.LoadFromFile('d:\1.bmp');
  st.Free;}

  {CopyBitmap(imgPhoto.Picture.Bitmap,fGL.Photo64);
  imgPhoto.Canvas.Rectangle(0,0,63,63);
  CopyBitmap(fGL.Photo64,imgPhoto.Picture.Bitmap);}

  SendPhoto;
end;
//______________________________________________________________________________
procedure TfCLOptions.rbPlainColorClick(Sender: TObject);
begin
  pnlPlainColor.Visible:=true;
  pnlThemeColor.Visible:=false;
  FClientSettingChanged := FCreationComplete;
  btnApply.Enabled := FCreationComplete;
end;
//______________________________________________________________________________
procedure TfCLOptions.rbThemeColorClick(Sender: TObject);
begin
  pnlPlainColor.Visible:=false;
  pnlThemeColor.Visible:=true;
  if cmbTheme.ItemIndex<>-1 then
    cmbTheme.ItemIndex:=0;
  FClientSettingChanged := FCreationComplete;
  btnApply.Enabled := FCreationComplete;
end;
//______________________________________________________________________________
procedure TfCLOptions.PutThemeSquareImages;
var
  bmp: Graphics.TBitMap;
  h,w: integer;
begin
  bmp:=Graphics.TBitMap.Create;
  h:=imgSquare.Height;
  w:=imgSquare.Width div 2;
  fSquareLib.ReadBitMap('light',cmbTheme.ItemIndex,bmp);
  CompressImageSpecifiedSize(bmp,w+1,h+1,pf24bit);
  imgSquare.Canvas.CopyRect(Rect(0,0,w,h),bmp.Canvas,Rect(0,0,w,h));
  fSquareLib.ReadBitMap('dark',cmbTheme.ItemIndex,bmp);
  CompressImageSpecifiedSize(bmp,w+1,h+1,pf24bit);
  imgSquare.Canvas.CopyRect(Rect(w,0,2*w,h),bmp.Canvas,Rect(0,0,w,h));
  bmp.Free;
end;
//______________________________________________________________________________
procedure TfCLOptions.cmbThemeChange(Sender: TObject);
begin
  PutThemeSquareImages;
  FClientSettingChanged := FCreationComplete;
  btnApply.Enabled := FCreationComplete;
end;
//______________________________________________________________________________
procedure TfCLOptions.MakeDevicesList;
var
  i,n: integer;
begin
  {VideoDevices:=TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
  cmbVideoDevices.Items.Add(DEVICE_NONE);
  for i:=0 to VideoDevices.CountFilters-1 do
    cmbVideoDevices.Items.Add(VideoDevices.Filters[i].FriendlyName);
  AudioDevices:=TSysDevEnum.Create(CLSID_AudioInputDeviceCategory);
  cmbAudioDevices.Items.Add(DEVICE_NONE);
  for i:=0 to AudioDevices.CountFilters-1 do
    cmbAudioDevices.Items.Add(AudioDevices.Filters[i].FriendlyName);

  n:=cmbVideoDevices.Items.IndexOf(fGL.VideoInputDevice);
  if n=-1 then n:=0;
  cmbVideoDevices.ItemIndex:=n;

  n:=cmbAudioDevices.Items.IndexOf(fGL.AudioInputDevice);
  if n=-1 then n:=0;
  cmbAudioDevices.ItemIndex:=n;
  }
end;
//______________________________________________________________________________
procedure TfCLOptions.btnPasswordClick(Sender: TObject);
var
  F: TfCLPassword;
begin
  ShellExecute(Handle, 'open', PChar('http://www.perpetualchess.com'), '', '', SW_SHOWNORMAL);
  exit;

  if fCLSocket.InitState < isLoginComplete then begin
    MessageDlg('You cannot change password while disconnected from the server.',mtError,[mbOk],0);
    exit;
  end;

  F:=TfCLPassword.Create(Application);
  if F.ShowModal = mrOk then begin
    FServerSettingChanged := true;
    btnApply.Enabled := true;
    btnPassword.Font.Style := btnPassword.Font.Style + [fsBold];
    NewPassword := F.edtNewPassword.Text;
  end;
  F.Free;
end;
//______________________________________________________________________________
procedure TfCLOptions.chkTimeEndingClick(Sender: TObject);
begin
  edtTimeEnding.Enabled:=chkTimeEnding.Checked;
  udTimeEnding.Enabled:=chkTimeEnding.Checked;
  ControlChanged(Sender);
end;
//______________________________________________________________________________
procedure TfCLOptions.reNotesChange(Sender: TObject);
begin
  FNotesChanged := true;
end;
//______________________________________________________________________________
procedure TfCLOptions.btnShowColorsClick(Sender: TObject);
var
  i,j: integer;
  control, control2: TControl;
  btn: TCLColorButton;
begin
  reColors.Lines.Clear;
  try
  for i:=0 to tsColor.ControlCount-1 do begin
    control := tsColor.Controls[i];
    if (control is TPanel) or (control is TGroupBox) then begin
       for j:=0 to (control as TWinControl).ControlCount-1 do begin
         control2 := (control as TWinControl).Controls[j];
         if control2 is TCLColorButton then begin
           btn := control2 as TCLColorButton;
           //reColors.Lines.Add(Format('%s = %x',[btn.Name, btn.ButtonColor]));
           reColors.Lines.Add(Format('%s.ButtonColor:=$%x;',[btn.Name,btn.ButtonColor]));
         end;
       end;
    end;
  end;
  except
    on E:Exception do showmessage(E.Message);
  end;
end;
//______________________________________________________________________________
procedure TfCLOptions.cmbColorSchemaChange(Sender: TObject);
begin
  if cmbColorSchema.ItemIndex = 1 then begin
    clFrames.ButtonColor:=$C8C8C8;
    clNotify.ButtonColor:=$C8C8C8;
    clDefaultBackground.ButtonColor:=$C8C8C8;
    clBoardBackground.ButtonColor:=$C8C8C8;
    clEvent.ButtonColor:=$C8C8C8;
    clBullet.ButtonColor:=$8080FF;
    clBlitz.ButtonColor:=$80FFFF;
    clStandard.ButtonColor:=$80FF80;
    clLoosers.ButtonColor:=$8000FF;
    clFisher.ButtonColor:=$FFFF00;
    clCrazy.ButtonColor:=$FF8080;
    clTitleC.ButtonColor:=$8000FF;
    clSimulCurrentGame.ButtonColor:=$30C030;
    clSimulLeaderGame.ButtonColor:=$FF2000;
  end else if cmbColorSchema.ItemIndex = 2 then begin
    clFrames.ButtonColor:=$9ED7E0;
    clNotify.ButtonColor:=$AEAEF7;
    clDefaultBackground.ButtonColor:=$8DADD8;
    clBoardBackground.ButtonColor:=$B3D9FF;
    clEvent.ButtonColor:=$9ED7E0;
    clBullet.ButtonColor:=$8080FF;
    clBlitz.ButtonColor:=$80FFFF;
    clStandard.ButtonColor:=$80FF80;
    clLoosers.ButtonColor:=$8000FF;
    clFisher.ButtonColor:=$FFFF00;
    clCrazy.ButtonColor:=$FF8080;
    clTitleC.ButtonColor:=$8000FF;
    clSimulCurrentGame.ButtonColor:=$30C030;
    clSimulLeaderGame.ButtonColor:=$FF2000;
  end else if cmbColorSchema.ItemIndex = 3 then begin
    clFrames.ButtonColor:=$E0D79E;
    clNotify.ButtonColor:=$FFDFDF;
    clDefaultBackground.ButtonColor:=$D8AD8D;
    clBoardBackground.ButtonColor:=$FF8D9D;
    clEvent.ButtonColor:=$E0D79E;
    clBullet.ButtonColor:=$8080FF;
    clBlitz.ButtonColor:=$80FFFF;
    clStandard.ButtonColor:=$80FF80;
    clLoosers.ButtonColor:=$8000FF;
    clFisher.ButtonColor:=$FFFF00;
    clCrazy.ButtonColor:=$FF8080;
    clTitleC.ButtonColor:=$8000FF;
    clSimulCurrentGame.ButtonColor:=$30C030;
    clSimulLeaderGame.ButtonColor:=$FF2000;
  end;
  ControlChanged(Sender);
end;
//______________________________________________________________________________
procedure TfCLOptions.dtBirthdayChange(Sender: TObject);
begin
  //
  ControlChanged2(nil);
end;
//______________________________________________________________________________
function TfCLOptions.CurrentBirthday: TDateTime;
begin
  if (cmbYear.Text = '') then result := 0
  else result := GetOptionsDate(
    StrToInt(cmbYear.Text),
    cmbMonth.ItemIndex + 1,
    cmbDay.ItemIndex + 1);
end;
//______________________________________________________________________________
procedure TfCLOptions.SetDate(dt: TDateTime);
var
  y, m, d: word;
  n: integer;
begin
  if dt = 0 then begin
    cmbDay.ItemIndex := -1;
    cmbMonth.ItemIndex := -1;
    cmbYear.ItemIndex := -1;
  end else begin
    DecodeDate(dt, y, m, d);
    cmbDay.ItemIndex := d - 1;
    cmbMonth.ItemIndex := m - 1;
    n := cmbYear.Items.IndexOf(IntToStr(y));
    if n = 0 then begin
      cmbYear.Items.Insert(0, IntToStr(y));
      cmbYear.ItemIndex := 0;
    end else
      cmbYear.ItemIndex := n;
  end;
end;
//______________________________________________________________________________
procedure TfCLOptions.cmbMonthChange(Sender: TObject);
var
  dt: TDateTime;
begin
  dt := CurrentBirthday;
  lblAge.Caption := AgeByBirthday(dt);
  ControlChanged2(nil);
end;
//______________________________________________________________________________
procedure TfCLOptions.chkAutoMatchClick(Sender: TObject);
var
  b: Boolean;
begin
  b := chkAutoMatch.Checked;
  lblMinAutoMatch.Visible := b;
  lblMaxAutoMatch.Visible := b;
  edtMinAutoMatch.Visible := b;
  edtMaxAutoMatch.Visible := b;
  udMinAutoMatch.Visible := b;
  udMaxAutoMatch.Visible := b;
  ControlChanged2(Sender);
end;
//______________________________________________________________________________
end.



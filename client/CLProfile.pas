{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLProfile;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, ExtCtrls, ComCtrls, Menus, Buttons, contnrs, clipbrd,
  CLAchievements, CLAchievementClass, ImgList, ShellAPI, CLLib;

const
  LEFT_INDENT = 20;
  TOP_INDENT = 70;
  SMALL_INDENT = 5;

  COLOR_WIN = clGreen;
  COLOR_DRAW = clBlue;
  COLOR_LOST = clRed;
  COLOR_UNKNOWN = clMaroon;

  PAGE_PROFILE_CAPTION = 'Profile';
  PAGE_RECENT_CAPTION = 'Recent';
  PAGE_LIBRARY_CAPTION = 'Library';
  PAGE_ADJOURNED_CAPTION = 'Adjourned';
  PAGE_ECO_CAPTION = 'ECO';
  PAGE_CHATLOG_CAPTION = 'Chat Log';
  PAGE_ACH_CAPTION = 'Achievements';
  PAGE_PAYMENT_CAPTION = 'Payments';

type
  TGamesHeader = (ghIndex, ghWhiteName, ghWhiteRating, ghBlackName,
    ghBlackRating, ghRatedType, ghTime, ghRated, ghResult, ghECO, ghDate);

  TCLProfileGame = class(TObject)
    FType: Integer;
    FLocalIndex: Integer;
    FServerIndex: Integer;
    FWhiteName: string;
    FWhiteRating: Integer;
    FBlackName: string;
    FBlackRating: Integer;
    FRatedType: string;
    FInitialMSec: integer;
    FIncMSec: Integer;
    FRated: Integer;
    FResult: string;
    FECO: string;
    FDate: string;
    FLoggedIn: Boolean;
    FEcoDesc: string;
  end;

  TCLRating = class(TObject)
    FRatedName: string;
    FRating: string;
    FWins: string;
    FLosses: string;
    FDraws: string;
    FBest: string;
    FDate: string;
  end;

  TCLBStat = class
    ECO: string;
    ECODesc: string;
    PGN: string;
    WW, WL, WD: string;
    BW, BL, BD: string;
    cnt: integer;
  end;

  TCLPayment = class
    id: integer;
    Login: string;
    TransactionDate: TDateTime;
    Deleted: Boolean;
    MembershipType: integer;
    MembershipTypeName: string;
    SubscribeType: integer;
    SubscribeTypeName: string;
    SourceType: integer;
    SourceTypeName: string;
    ExpireDate: TDateTime;
    Amount: Currency;
    AmountFull: Currency;
    NameOnCard: string;
    CardType: string;
    CardNumber: string;
    AdminCreated: string;
    AdminDeleted: string;
    AdminComment: string;
    PromoID: integer;
    PromoCode: string;
  end;

  TCLPayments = class(TObjectList)
  private
    function GetPayment(Index: integer): TCLPayment;
  public
    property Payment[Index: integer]: TCLPayment read GetPayment; default;
  end;

  TCLProfile = class(TObject)
    FLogin: string;
    FPing: string;
    FNote: string;
    FRatings: TObjectList;
    FGames: TObjectList;
    FCreated: string;
    FLoginTS: string;
    BStats: TObjectList;
    ChatLog: TStringList;
    FPage: integer;
    FPageCount: integer;
    FdtFrom: TDateTime;
    FdtTo: TDateTime;
    FFullChat: Boolean;
    FRoomName: string;
    FText: string;
    FPagesCount: integer;
    FChatVisible: Boolean;
    FEmail: string;
    FPublicEmail: Boolean;
    FCountry: string;
    FSexID: integer;
    FAge: string;
    FLanguage: string;
    FBirthday: TDateTime;
    FShowBirthday: Boolean;
    FSearchPressed: Boolean;
    AUL_AlreadyGet: Boolean;
    AchUserList: TCLAchUserList;
    FPayments: TCLPayments;
    FPaymentTransferred: Boolean;
    FMembershipVisible: Boolean;
    FMembershipType: TMembershipType;
    FMembershipExpireDate: TDateTime;
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
  end;

  TfCLProfile = class(TForm)
    pnlProfile: TPanel;
    pmProfile: TPopupMenu;
    miRefresh: TMenuItem;
    N1: TMenuItem;
    miExamine: TMenuItem;
    miResume: TMenuItem;
    miAddLibrary: TMenuItem;
    miRemoveLibrary: TMenuItem;
    pnlMain: TPanel;
    sbMax: TSpeedButton;
    sbClose: TSpeedButton;
    lblProfile: TLabel;
    tcMain: TTabControl;
    scbVer: TScrollBar;
    scbHor: TScrollBar;
    pnlChatLog: TPanel;
    Panel1: TPanel;
    reChatLog: TRichEdit;
    dtFrom: TDateTimePicker;
    dtTo: TDateTimePicker;
    Label2: TLabel;
    Label4: TLabel;
    rbThisUserOnly: TRadioButton;
    rbFullChat: TRadioButton;
    Label5: TLabel;
    Label6: TLabel;
    edtRoomName: TEdit;
    edtText: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel2: TPanel;
    sbSearch: TSpeedButton;
    edtPage: TEdit;
    udPage: TUpDown;
    lblPageCount: TLabel;
    sbPageLast: TSpeedButton;
    sbPageFirst: TSpeedButton;
    Label8: TLabel;
    pnlGames: TPanel;
    pnlFilters: TPanel;
    Panel4: TPanel;
    Label7: TLabel;
    cmbColor: TComboBox;
    Label9: TLabel;
    edtOpponent: TEdit;
    sbClearOpponent: TSpeedButton;
    Label10: TLabel;
    cmbType: TComboBox;
    Label11: TLabel;
    cmbResult: TComboBox;
    Label12: TLabel;
    edtEco: TEdit;
    sbClearEco: TSpeedButton;
    Label13: TLabel;
    dtFilterFrom: TDateTimePicker;
    Label14: TLabel;
    dtFilterTo: TDateTimePicker;
    lvGames: TListView;
    edGamesPage: TEdit;
    Label15: TLabel;
    udGamesPage: TUpDown;
    lblPagesCount: TLabel;
    pnlClear: TPanel;
    pnlSearch: TPanel;
    sbClear: TSpeedButton;
    sbGamesSearch: TSpeedButton;
    sbClearResult: TSpeedButton;
    sbClearColor: TSpeedButton;
    sbClearType: TSpeedButton;
    pmDate: TPopupMenu;
    miToday: TMenuItem;
    miLastWeek: TMenuItem;
    miLastMonth: TMenuItem;
    miYesterday: TMenuItem;
    miLast10Years: TMenuItem;
    pm1: TPopupMenu;
    miDeletePhoto: TMenuItem;
    miChangeNotes: TMenuItem;
    reNotes: TRichEdit;
    pnlRatings: TPanel;
    lblGameType: TLabel;
    lblRating: TLabel;
    lblWins: TLabel;
    lblLosses: TLabel;
    lblDraws: TLabel;
    lblBest: TLabel;
    lblDate: TLabel;
    lblGameType0: TLabel;
    lblRating0: TLabel;
    lblWins0: TLabel;
    lblLosses0: TLabel;
    lblDraws0: TLabel;
    lblBest0: TLabel;
    lblDate0: TLabel;
    lblGameType1: TLabel;
    lblRating1: TLabel;
    lblWins1: TLabel;
    lblLosses1: TLabel;
    lblDraws1: TLabel;
    lblBest1: TLabel;
    lblDate1: TLabel;
    lblGameType2: TLabel;
    lblRating2: TLabel;
    lblWins2: TLabel;
    lblLosses2: TLabel;
    lblDraws2: TLabel;
    lblBest2: TLabel;
    lblDate2: TLabel;
    lblGameType3: TLabel;
    lblRating3: TLabel;
    lblWins3: TLabel;
    lblLosses3: TLabel;
    lblDraws3: TLabel;
    lblBest3: TLabel;
    lblDate3: TLabel;
    lblGameType4: TLabel;
    lblRating4: TLabel;
    lblWins4: TLabel;
    lblLosses4: TLabel;
    lblDraws4: TLabel;
    lblBest4: TLabel;
    lblDate4: TLabel;
    lblGameType5: TLabel;
    lblRating5: TLabel;
    lblWins5: TLabel;
    lblLosses5: TLabel;
    lblDraws5: TLabel;
    lblBest5: TLabel;
    lblDate5: TLabel;
    bvlStandard: TBevel;
    bvlBlitz: TBevel;
    bvlBullet: TBevel;
    bvlCrazy: TBevel;
    bvlFischer: TBevel;
    pnlInfo: TPanel;
    lblLogin: TLabel;
    lblLoginData: TLabel;
    Label16: TLabel;
    lblCountry: TLabel;
    Label17: TLabel;
    lblLanguage: TLabel;
    Label18: TLabel;
    lblSex: TLabel;
    Label19: TLabel;
    lblAge: TLabel;
    Label20: TLabel;
    lblEmail: TLabel;
    Label1: TLabel;
    lblCreated: TLabel;
    Label3: TLabel;
    lblLoginTS: TLabel;
    lblPing: TLabel;
    lblPingData: TLabel;
    pnlPhoto: TPanel;
    imgPhoto: TImage;
    pmChatLog: TPopupMenu;
    Copy1: TMenuItem;
    Label21: TLabel;
    lblBirthday: TLabel;
    pnlPayment: TPanel;
    lvPayment: TListView;
    pmPayment: TPopupMenu;
    Edit1: TMenuItem;
    ilPayment: TImageList;
    NewTransaction1: TMenuItem;
    Label22: TLabel;
    btnChatLogURL: TBitBtn;
    pnlPayInfo: TPanel;
    lblMembershipType: TLabel;
    lblExpireText: TLabel;
    lblExpireDate: TLabel;
    pnlSpecialOffer: TPanel;
    imgSpecialOffer: TImage;
    pnlRenew: TPanel;
    sbPayHere: TSpeedButton;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure sbCloseClick(Sender: TObject);
    procedure sbMaxClick(Sender: TObject);
    procedure tcMainChange(Sender: TObject);
    procedure lvGamesColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvGamesCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lvGamesCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvGamesDblClick(Sender: TObject);
    procedure lvGamesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lvGamesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure miAddLibraryClick(Sender: TObject);
    procedure miExamineClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);
    procedure miRemoveLibraryClick(Sender: TObject);
    procedure miResumeClick(Sender: TObject);
    procedure scbHorChange(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sbSearchClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbPageFirstClick(Sender: TObject);
    procedure sbPageLastClick(Sender: TObject);
    procedure edtRoomNameChange(Sender: TObject);
    procedure sbClearColorClick(Sender: TObject);
    procedure sbClearResultClick(Sender: TObject);
    procedure sbClearTypeClick(Sender: TObject);
    procedure sbClearEcoClick(Sender: TObject);
    procedure sbClearOpponentClick(Sender: TObject);
    procedure miTodayClick(Sender: TObject);
    procedure miYesterdayClick(Sender: TObject);
    procedure miLastWeekClick(Sender: TObject);
    procedure miLastMonthClick(Sender: TObject);
    procedure sbClearClick(Sender: TObject);
    procedure sbGamesSearchClick(Sender: TObject);
    procedure FilterChange(Sender: TObject);
    procedure miLast10YearsClick(Sender: TObject);
    procedure pm1Popup(Sender: TObject);
    procedure miDeletePhotoClick(Sender: TObject);
    procedure miChangeNotesClick(Sender: TObject);
    procedure dtFromChange(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure lvPaymentDblClick(Sender: TObject);
    procedure NewTransaction1Click(Sender: TObject);
    procedure btnChatLogURLClick(Sender: TObject);
    procedure sbPayHereClick(Sender: TObject);

  private
    { Private declarations }
    FColumnToSort: TGamesHeader;
    FProfile: TCLProfile;
    FProfiles: TObjectList;
    FReverseSort: Boolean;
    BitMap: TBitMap;
    StartX, StartY: integer;
    PictureWidth,PictureHeight: integer;
    RowHeight, FirstRow: integer;
    TableRight,TableBottom: integer;

    AchForm: TFCLAchievements;

    function GetProfile(const Login: string): TCLProfile;
    procedure KillProfile(const Profile: TCLProfile);
    procedure LoadGames;
    procedure AddLVGame(Game: TCLProfileGame);
    procedure LoadProfile;
    procedure LoadPayments;
    procedure SetProfile(const Profile: TCLProfile);
    procedure WMEraseBkgnd(var Msg: TMessage); message WM_ERASEBKGND;
    procedure DrawBeginningStat;
    procedure SetScrollBars;
    function GetHintIndex(x,y: integer): integer;
    procedure DeleteChatTab;
    procedure AddChatTab;
    procedure AddTab(p_Caption: string);
    procedure CreateTabs;
    function IsCurrentPage(Caption: string): Boolean;
    function CurrentGameType: integer;
    procedure EditPayment;
    procedure NewPayment;
    procedure DrawSpecialOffer;

  public
    { Public declarations }

    procedure ProfileBegin(const CMD: TStrings);
    procedure ProfileEnd(const CMD: TStrings);
    procedure ProfileGame(const CMD: TStrings);
    procedure ProfileNote(const CMD: TStrings);
    procedure ProfileData(const CMD: TStrings);
    procedure ProfilePing(const CMD: TStrings);
    procedure ProfileRating(const CMD: TStrings);
    procedure BeginningStat(const CMD: TStrings);
    procedure SetMenuState;
    procedure ProfileChatLogStart(const CMD: TStrings);
    procedure ProfileChatLog(const CMD: TStrings);
    procedure ProfileChatLogEnd(const CMD: TStrings);
    procedure ProfileChatLogPage(const CMD: TStrings);
    procedure ProfilePages(const CMD: TStrings);
    procedure RecentClear(const CMD: TStrings);
    procedure ProfileChatReader(const CMD: TStrings);
    function GetAchUserList(Login: string): TCLAchUserList;
    procedure CMD_AchSendEnd(CMD: TStrings);
    procedure CMD_PaymentBegin(CMD: TStrings);
    procedure CMD_Payment(CMD: TStrings);
    procedure CMD_PaymentEnd(CMD: TStrings);
    procedure CMD_ProfilePayData(const CMD: TStrings);

    property Profile: TCLProfile read FProfile write SetProfile;
  end;

var
  fCLProfile: TfCLProfile;

implementation

uses CLConst, CLMain, CLNavigate, CLSocket, CLGlobal, CLImageLib, CLPaymentEdit,
     CLMembershipType;

{$R *.DFM}

//==================================================================================================
function CompareBStat(Item1, Item2: Pointer): Integer;
var
  bs1,bs2: TCLBStat;
begin
  bs1:=Item1;
  bs2:=Item2;
  if bs1.cnt<bs2.cnt then result:=1
  else if bs1.cnt=bs2.cnt then result:=0
  else result:=-1;
end;
//==================================================================================================
{ TCLProfile }
constructor TCLProfile.Create;
begin
  FRatings := TObjectList.Create;
  FGames := TObjectList.Create;
  BStats := TObjectList.Create;
  ChatLog:=TStringList.Create;
  FPayments := TCLPayments.Create;
  FPage:=1;
  FPageCount:=1;
  FdtFrom:=Date;
  FdtTo:=Date;
  FChatVisible:=false;
  FSearchPressed := false;
  FMembershipVisible := false;
  AchUserList := TCLAchUserList.Create;
  AUL_AlreadyGet := false;
end;
//==================================================================================================
destructor TCLProfile.Destroy;
begin
  FRatings.Free;
  FGames.Free;
  BStats.Free;
  ChatLog.Free;
  AchUserList.Free;
  FPayments.Free;
  inherited;
end;
//==================================================================================================
procedure TfCLProfile.KillProfile(const Profile: TCLProfile);
begin
  if Profile = nil then exit;
  fCLNavigate.RemoveObject(Profile);
  if FProfile = Profile then FProfile := nil;
  FProfiles.Remove(Profile);
end;
//==================================================================================================
{ TfCLProfile }
function TfCLProfile.GetProfile(const Login: string): TCLProfile;
var
  Index: Integer;
begin
  Result := nil;
  for Index := 0 to FProfiles.Count -1 do
    begin
      Result := TCLProfile(FProfiles[Index]);
      if lowercase(Result.FLogin) = lowercase(Login) then
        Break
      else
        Result := nil;
    end;
end;
//==================================================================================================
procedure TfCLProfile.LoadGames;
var
  Game: TCLProfileGame;
  Index: Integer;
begin
  with lvGames.Items do
    begin
      BeginUpdate;
      Clear;
      EndUpdate;
    end;
  if FProfile = nil then Exit;

  lvGames.Items.BeginUpdate;
  for Index := 0 to FProfile.FGames.Count -1 do
    begin
      Game := TCLProfileGame(FProfile.FGames[Index]);
      if Game = nil then Break;

      if Game.FType = CurrentGameType then
        AddLVGame(Game);
    end;
  lvGames.Items.EndUpdate;
end;
//==================================================================================================
procedure TfCLProfile.LoadProfile;
var
  Lbl: TLabel;
  Rating: TCLRating;
  Index: Integer;
  bmp: Graphics.TBitMap;
begin
  if FProfile = nil then exit;

  Caption := 'Profile of ' + FProfile.FLogin;
  lblProfile.Caption := Caption;
  lblLoginData.Caption := FProfile.FLogin;
  lblPingData.Caption := FProfile.FPing;
  lblCreated.Caption := FProfile.FCreated;
  lblLoginTS.Caption := FProfile.FLoginTS;
  reNotes.Text := FProfile.FNote;

  if (fLoginImages[FProfile.FLogin]<>nil)
    and (fLoginImages[FProfile.FLogin].Photo<>nil)
  then begin
    CopyBitmap(fLoginImages[FProfile.FLogin].Photo,imgPhoto.Picture.Bitmap);
    imgPhoto.Visible:=true;
    pnlPhoto.Caption:='';
    pnlPhoto.Width := imgPhoto.Picture.Bitmap.Width+4;
    pnlPhoto.Height := imgPhoto.Picture.Bitmap.Height+4;
  end else begin
    imgPhoto.Visible:=false;
    pnlPhoto.Caption:='NO PHOTO';
    pnlPhoto.Color := fGL.DefaultBackgroundColor;
    pnlPhoto.Width := 96;
    pnlPhoto.Height := 96;
  end;

  pnlPayInfo.Visible := Profile.FMembershipVisible;
  pnlSpecialOffer.Visible := pnlPayInfo.Visible and (SPECIAL_OFFER <> '')
    and (Profile.FMembershipType in [mmbNone, mmbTrial]);
  if pnlPayInfo.Visible then begin
    if Profile.FMembershipType = mmbNone then lblMembershipType.Caption := 'No Current Membership'
    else lblMembershipType.Caption := fCLMembershipTypes.GetName(ord(Profile.FMembershipType));

    if Profile.FMembershipExpireDate = 0 then lblExpireDate.Caption := '-'
    else lblExpireDate.Caption := FormatDateTime('mm/dd/yyyy', Profile.FMembershipExpireDate);

    if Profile.FMembershipType in [mmbEmployee, mmbVIP] then lblExpireDate.Font.Color := clBlue
    else lblExpireDate.Font.Color := clBlack;

    case Profile.FMembershipType of
      mmbNone: lblMembershipType.Font.Color := clPurple;
      mmbTrial: lblMembershipType.Font.Color := clBlack;
    else
      lblMembershipType.Font.Color := clBlue;
    end;
  end;

  for Index := 0 to FProfile.FRatings.Count - 1 do
    begin
      Rating := TCLRating(FProfile.FRatings[Index]);
      Lbl := TLabel(FindComponent('lblGameType' + IntToStr(Index)));
      Lbl.Caption := Rating.FRatedName;
      Lbl := TLabel(FindComponent('lblRating' + IntToStr(Index)));
      Lbl.Caption := Rating.FRating;
      Lbl := TLabel(FindComponent('lblWins' + IntToStr(Index)));
      Lbl.Caption := Rating.FWins;
      Lbl := TLabel(FindComponent('lblLosses' + IntToStr(Index)));
      Lbl.Caption := Rating.FLosses;
      Lbl := TLabel(FindComponent('lblDraws' + IntToStr(Index)));
      Lbl.Caption := Rating.FDraws;
      Lbl := TLabel(FindComponent('lblBest' + IntToStr(Index)));
      Lbl.Caption := Rating.FBest;
      Lbl := TLabel(FindComponent('lblDate' + IntToStr(Index)));
      Lbl.Caption := Rating.FDate;
    end;
  LoadGames;
  DrawBeginningStat;
  reChatLog.Lines.Text:=FProfile.ChatLog.Text;

  udPage.Position:=FProfile.FPage;
  udPage.Max:=FProfile.FPageCount;
  lblPageCount.Caption:='of '+IntToStr(FProfile.FPageCount);

  dtFrom.Date:=FProfile.FdtFrom;
  dtTo.Date:=FProfile.FdtTo;
  rbFullChat.Checked:=FProfile.FFullChat;
  edtRoomName.Text:=FProfile.FRoomName;
  edtText.Text:=FProfile.FText;
  lblPagesCount.Caption:='of '+IntToStr(FProfile.FPagesCount);
  udGamesPage.Max:=FProfile.FPagesCount;

  lblCountry.Caption := FProfile.FCountry;
  lblLanguage.Caption := FProfile.FLanguage;
  lblSex.Caption := BoolTo_(FProfile.FSexID=0,'M','F');

  if FProfile.FBirthday = 0 then
    lblBirthday.Caption := '-'
  else if FProfile.FShowBirthday then
    lblBirthday.Caption := DateToStr(FProfile.FBirthday)
  else if fCLSocket.MyAdminLevel >= 2 then
    lblBirthday.Caption := DateToStr(FProfile.FBirthday) + ' (hidden)'
  else
    lblBirthday.Caption := '';

  if FProfile.FBirthday = 0 then lblAge.Caption := FProfile.FAge
  else lblAge.Caption := AgeByBirthday(FProfile.FBirthday);

  if FProfile.FPublicEmail then
    lblEmail.Caption := FProfile.FEmail
  else if fCLSocket.MyAdminLevel >= 2 then
    lblEmail.Caption := FProfile.FEmail + ' (hidden)'
  else
    lblEmail.Caption := '';

  if FProfile.FChatVisible then AddChatTab
  else DeleteChatTab;

  AchForm.CurAchUserList := FProfile.AchUserList;

  LoadPayments;
  DrawSpecialOffer;

  tcMain.OnChange(nil);
  repaint;
end;
//==================================================================================================
procedure TfCLProfile.SetProfile(const Profile: TCLProfile);
begin
  FProfile := Profile;
  LoadProfile;
end;
//==================================================================================================
procedure TfCLProfile.WMEraseBkgnd(var Msg: TMessage);
begin
  { Trap and do not erase }
end;
//==================================================================================================
procedure TfCLProfile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FProfiles.Free;
  fCLProfile := nil;
  Bitmap.Free;
  AchForm.Free;
  Action := caFree;
end;
//==================================================================================================
procedure TfCLProfile.FormCreate(Sender: TObject);
begin
  FProfiles := TObjectList.Create;
  FReverseSort := False;
  BitMap:=TBitMap.Create;
  BitMap.PixelFormat:=pfDevice;
  BitMap.Width:=1500;
  BitMap.Height:=5000;
  dtFrom.Date:=Date;
  dtTo.Date:=Date;
  miLastWeek.Click;
  CreateTabs;
  pnlInfo.Tag := pnlInfo.Top;
  pnlRatings.Tag := pnlRatings.Top;
  reNotes.Tag := reNotes.Top;

  AchForm := TFCLAchievements.Create(Application);
  AchForm.Parent := Self;
  AchForm.Align := alClient;
  DrawSpecialOffer;
end;
//==================================================================================================
procedure TfCLProfile.FormPaint(Sender: TObject);
begin
  if IsCurrentPage(PAGE_ECO_CAPTION) then begin
    Canvas.Brush.Color := fGL.DefaultBackgroundColor;
    lvGames.Color := fGL.DefaultBackgroundColor;
    Canvas.FillRect(Rect(0, 41, ClientWidth, ClientHeight));
    pnlProfile.Color := fGL.DefaultBackgroundCOlor;
    Self.Canvas.CopyRect(Rect(0,0,Width-1,Height-1),Bitmap.Canvas,
      Rect(StartX,StartY,StartX+Width,StartY+Height));
  end else begin
    pnlInfo.Top := pnlInfo.Tag - StartY;
    pnlRatings.Top := pnlRatings.Tag - StartY;
    reNotes.Top := reNotes.Tag - StartY;
  end;
  SetScrollBars;
end;
//==================================================================================================
procedure TfCLProfile.FormResize(Sender: TObject);
begin
  //lblNotes.Width := clientwidth - 16;
  { Force Resize of the label. }
  //lblNotes.AutoSize := False;
  //lblNotes.AutoSize := True;
end;
//==================================================================================================
procedure TfCLProfile.lvGamesColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  { Prepare to call custom sort }
  FReverseSort := not FReverseSort;
  FColumnToSort := TGamesHeader(Column.Index);
  lvGames.CustomSort(nil, 0);
end;
//==================================================================================================
procedure TfCLProfile.lvGamesCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  CLGame1, CLGame2: TCLProfileGame;
begin
  CLGame1 := TCLProfileGame(Item1.Data);
  CLGame2 := TCLProfileGame(Item2.Data);

  case FColumnToSort of
    ghIndex:
      Compare := CLGame1.FLocalIndex - CLGame2.FLocalIndex;
    ghWhiteName:
      Compare := AnsiCompareText(CLGame1.FWhiteName, CLGame2.FWhiteName);
    ghWhiteRating:
      Compare := CLGame1.FWhiteRating - CLGame2.FWhiteRating;
    ghBlackName:
      Compare := AnsiCompareText(CLGame1.FBlackName, CLGame2.FBlackName);
    ghBlackRating:
      Compare := CLGame1.FBlackRating - CLGame2.FBlackRating;
    ghRatedType:
      Compare := AnsiCompareText(CLGame1.FRatedType, CLGame2.FRatedType);
    ghTime:
      Compare := ((CLGame1.FIncMSec div 3) * 2 + CLGame1.FInitialMSec) -
        ((CLGame2.FIncMSec div 3) * 2 + CLGame2.FInitialMSec);
    ghRated:
      Compare := CLGame1.FRated - CLGame2.FRated;
    ghResult:
      Compare := AnsiCompareText(CLGame1.FResult, CLGame2.FResult);
    ghECO:
      Compare := AnsiCompareText(CLGame1.FECO, CLGame2.FECO);
    ghDate:
      Compare := AnsiCompareText(CLGame1.FDate, CLGame2.FDate);
  end;

  if FReverseSort then Compare := -Compare;
end;
//==================================================================================================
procedure TfCLProfile.lvGamesCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  try
    if Item = nil then Exit;
    if TCLProfileGame(Item.Data).FLoggedIn = False then
      lvGames.Canvas.Font.Style := lvGames.Font.Style - [fsBold]
    else
      lvGames.Canvas.Font.Style := lvGames.Font.Style + [fsBold];
  except
  end;
end;
//==================================================================================================
procedure TfCLProfile.lvGamesDblClick(Sender: TObject);
begin
  if lvGames.Selected <> nil then miExamine.Click;
end;
//==================================================================================================
procedure TfCLProfile.lvGamesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE: miRemoveLibrary.Click;
    VK_INSERT: miAddLibrary.Click;
  end;
end;
//==================================================================================================
procedure TfCLProfile.lvGamesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  SetMenuState;
end;
//==================================================================================================
procedure TfCLProfile.sbCloseClick(Sender: TObject);
begin
  KillProfile(FProfile);
end;
//==================================================================================================
procedure TfCLProfile.sbMaxClick(Sender: TObject);
begin
  fCLMain.miMaximizeTop.Click;
end;
//==================================================================================================
procedure TfCLProfile.tcMainChange(Sender: TObject);
begin
  LoadGames;
  if IsCurrentPage(PAGE_ACH_CAPTION) and not Profile.AUL_AlreadyGet then begin
    fCLSocket.InitialSend([CMD_STR_PROFILE_ACH, Profile.FLogin]);
    Profile.AUL_AlreadyGet := true;
  end;

  pnlGames.Visible := IsCurrentPage(PAGE_RECENT_CAPTION) or IsCurrentPage(PAGE_LIBRARY_CAPTION)
    or IsCurrentPage(PAGE_ADJOURNED_CAPTION);
  pnlProfile.Visible := IsCurrentPage(PAGE_PROFILE_CAPTION);
  pnlChatLog.Visible := IsCurrentPage(PAGE_CHATLOG_CAPTION);
  pnlFilters.Visible := IsCurrentPage(PAGE_RECENT_CAPTION);
  miRefresh.Enabled := not IsCurrentPage(PAGE_RECENT_CAPTION);
  if pnlChatLog.Visible then
    pnlChatLog.BringToFront;
  if IsCurrentPage(PAGE_RECENT_CAPTION) and not Profile.FSearchPressed then
    sbGamesSearch.Click;
  AchForm.Visible := IsCurrentPage(PAGE_ACH_CAPTION);
  pnlPayment.Visible := IsCurrentPage(PAGE_PAYMENT_CAPTION);
end;
//==================================================================================================
{ DP_PROFILE_BEGIN: DP#, LoginID, Login, Title }
procedure TfCLProfile.ProfileBegin(const CMD: TStrings);
var
  Profile: TCLProfile;
begin
  Profile := GetProfile(CMD[2]);
  if Profile = nil then
    begin
      Profile := TCLProfile.Create;
      Profile.FLogin := CMD[2];
      FProfiles.Add(Profile);
    end
  else
    begin
      Profile.FRatings.Clear;
      Profile.FGames.Clear;
      FProfile.BStats.Clear;
    end;
end;
//==================================================================================================
{ DP_PROFILE_END: DP#, LoginID, Login, Title }
procedure TfCLProfile.ProfileEnd(const CMD: TStrings);
var
  Profile: TCLProfile;
begin
  Profile := GetProfile(CMD[2]);
  if fCLNavigate.clNavigate.Items.IndexOfObject(Profile) = -1 then
    fCLNavigate.AddProfile(Profile)
  else
    LoadProfile;
end;
//==================================================================================================
{ DP_PROFILE_GAME: DP#, LoginID, Login, Title, ProfileGameType, GameNumber/ID,
  WhiteName, WhiteTitle, WhiteRating, WhiteMSec,
  BlackName, BlackTitle, BlackRating, BlackMSec,
  RatedType, InitialMSec, IncMSec, Rated, GameResult, ECO, Date, LoggedIn }
procedure TfCLProfile.ProfileGame(const CMD: TStrings);
var
  Game: TCLProfileGame;
  Profile: TCLProfile;
  Index: Integer;
begin
  Profile := GetProfile(CMD[2]);
  if Profile = nil then Exit;

  { Create a TCLGames. }
  Index := Profile.FGames.Count + (udGamesPage.Position-1)*20;
  Game := TCLProfileGame.Create;
  with Game do
    begin
      FType := StrToInt(CMD[4]);
      FLocalIndex := Index;
      FServerIndex := StrToInt(CMD[5]);
      FWhiteName := CMD[6];
      FWhiteRating := StrToInt(CMD[8]);
      FBlackName := CMD[10];
      FBlackRating := StrToInt(CMD[12]);
      FRatedType := RATED_TYPES[StrToInt(CMD[14])];
      FInitialMSec := StrToInt(CMD[15]);
      FIncMSec := StrToInt(CMD[16]);
      FRated := Abs(StrToInt(CMD[17]));
      FResult := RESULTCODES[StrToInt(CMD[18])];
      FECO := CMD[19];
      FDate := CMD[20];
      FLoggedIn := Boolean(StrToInt(CMD[21]));
      if CMD.Count<23 then FEcoDesc:=''
      else FEcoDesc := CMD[22];
    end;
  Profile.FGames.Add(Game);
  if (FProfile = Profile) and (Game.FType = CurrentGameType) then
    AddLVGame(Game);
end;
//==================================================================================================
{ DP_PROFILE_NOTES: DP#, LoginID, Login, Title, Note }
procedure TfCLProfile.ProfileNote(const CMD: TStrings);
var
  Profile: TCLProfile;
begin
  Profile := GetProfile(CMD[2]);
  if Profile = nil then Exit;
  Profile.FNote := CMD[4];
end;
//==================================================================================================
{ DP_PROFILE_PING: DP#, LoginID, Login, Title, AvgPingMSec, PingCount, IdleMSec }
procedure TfCLProfile.ProfilePing(const CMD: TStrings);
var
  Profile: TCLProfile;
  Minute, Second: Integer;
begin
  Profile := GetProfile(CMD[2]);
  if Profile = nil then Exit;

  if CMD[4] = '-1' then
    Profile.FPing := 'Not logged in'
  else
    begin
      Second := StrToInt(CMD[6]);
      Minute := Trunc(Second / MSecsPerMinute);
      Second := Trunc((Second - Minute * MSecsPerMinute) div MSecs);

      Profile.FPing := CMD[4] + ' / ' + CMD[5] + ' / ' +
        Format('%d:%.2d', [Abs(Minute), Abs(Second)]);
    end;
end;
//==================================================================================================
{ DP_PROFILE_RATING: DP#, LoginID, Login, Title, RatedType, Rating, Provisional,
  RatedWins, RatedLoses, RatedDraws, UnratedWins, UnratedLoses, UnratedDraws,
  EP, Best, Date, RatedName, RatedName }
procedure TfCLProfile.ProfileRating(const CMD: TStrings);
var
  Rating: TCLRating;
  Profile: TCLProfile;
begin
  Profile := GetProfile(CMD[2]);
  if Profile = nil then Exit;

  Rating := TCLRating.Create;
  with Rating do
    begin
      FRatedName := CMD[16];
      FRating := CMD[5];
      FWins := CMD[7];
      FLosses := CMD[8];
      FDraws := CMD[9];
      FBest := CMD[14];
      FDate := CMD[15];
    end;
  Profile.FRatings.Add(Rating);
end;
//==================================================================================================
procedure TfCLProfile.miAddLibraryClick(Sender: TObject);
var
  Game: TCLProfileGame;
begin
  Game := TCLProfileGame(lvGames.Selected.Data);
  fCLSocket.InitialSend([CMD_STR_LIBRARY_ADD, IntToStr(Game.FServerIndex),'d']);
end;
//==================================================================================================
procedure TfCLProfile.miExamineClick(Sender: TObject);
var
  Game: TCLProfileGame;
begin
  Game := TCLProfileGame(lvGames.Selected.Data);
  fCLSocket.InitialSend([CMD_STR_LOAD, IntToStr(Game.FServerIndex)]);
end;
//==================================================================================================
procedure TfCLProfile.miRefreshClick(Sender: TObject);
begin
  fCLSocket.InitialSend([CMD_STR_PROFILE, FProfile.FLogin]);
end;
//==================================================================================================
procedure TfCLProfile.miRemoveLibraryClick(Sender: TObject);
var
  Game: TCLProfileGame;
begin
  if lvGames.Selected = nil then Exit;
  Game := TCLProfileGame(lvGames.Selected.Data);
  fCLSocket.InitialSend([CMD_STR_LIBRARY_REMOVE, IntToStr(Game.FServerIndex)]);
  FProfile.FGames.Remove(Game);
  lvGames.Selected.Delete;
end;
//==================================================================================================
procedure TfCLProfile.miResumeClick(Sender: TObject);
var
  Game: TCLProfileGame;
  s: string;
begin
  Game := TCLProfileGame(lvGames.Selected.Data);
  if Game.FWhiteName = fCLSocket.MyName then
    s := Format(QRY_SEND_RESUME_REQUEST, [Game.FBlackName])
  else
    s := Format(QRY_SEND_RESUME_REQUEST, [Game.FWhiteName]);

  if MessageDlg(s, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    fCLSocket.InitialSend([CMD_STR_RESUME, IntToStr(Game.FServerIndex)]);
end;
//==================================================================================================
procedure TfCLProfile.SetMenuState;
var
  Game: TCLProfileGame;
  LoggedIn, Selected: Boolean;
begin
  LoggedIn := fCLSocket.InitState >= isLoginComplete;
  Selected := lvGames.Selected <> nil;
  if Selected then Game := TCLProfileGame(lvGames.Selected.Data)
  else Game:=nil;

  miRefresh.Enabled := LoggedIn;
  miExamine.Enabled := LoggedIn and Selected;
  try
    miResume.Enabled := LoggedIn and Selected and (Game<>nil)
      and (FProfile.FLogin = fCLSocket.MyName)
      and (Game.FType = DP_PROFILE_GAMETYPE_ADJOURNED)
      and (Game.FLoggedIn = True);
    miAddLibrary.Enabled := LoggedIn and Selected and (Game<>nil)
      and (Game.FType <> DP_PROFILE_GAMETYPE_ADJOURNED)
      and ((Game.FType <> DP_PROFILE_GAMETYPE_LIBRARY)
        or (FProfile.FLogin <> fCLSocket.MyName));

    miRemoveLibrary.Enabled := LoggedIn and Selected and (Game<>nil)
      and (FProfile.FLogin = fCLSocket.MyName)
      and (Game.FType = DP_PROFILE_GAMETYPE_LIBRARY);
  except
    miResume.Enabled:=false;
    miAddLibrary.Enabled:=false;
    miRemoveLibrary.Enabled:=false;
  end;

  fCLMain.miRefresh.Enabled := miRefresh.Enabled;
  fCLMain.miExamine.Enabled := miExamine.Enabled;
  fCLMain.miResume.Enabled := miResume.Enabled;
  fCLMain.miAddLibrary.Enabled := miAddLibrary.Enabled;
  fCLMain.miRemoveLibrary.Enabled := miRemoveLibrary.Enabled;
  fCLMain.tbRefresh.Visible := miRefresh.Enabled;
  fCLMain.tbExamine.Visible := miExamine.Enabled;
  fCLMain.tbResume.Visible := miResume.Enabled;
  fCLMain.tbAddLibrary.Visible := miAddLibrary.Enabled;
  fCLMain.tbRemoveLibrary.Visible := miRemoveLibrary.Enabled;
end;
//==================================================================================================
procedure TfCLProfile.ProfileData(const CMD: TStrings);
var
  Profile: TCLProfile;
begin
  Profile := GetProfile(CMD[2]);
  if Profile = nil then Exit;
  Profile.FCreated := CMD[3];
  Profile.FLoginTS := CMD[4];
  Profile.FEmail := CMD[5];
  Profile.FPublicEmail := CMD[6] = '1';
  Profile.FCountry := CMD[7];
  Profile.FSexId := StrToInt(CMD[8]);
  Profile.FAge := CMD[9];
  Profile.FLanguage := CMD[10];
  if CMD.Count > 11 then begin
    Profile.FBirthday := StrToInt(CMD[11]);
    Profile.FShowBirthday := CMD[12] = '1';
  end;
end;
//==================================================================================================
procedure TfCLProfile.BeginningStat(const CMD: TStrings);
var
  bs: TCLBStat;
  Profile: TCLProfile;
begin
  if CMD.Count<12 then exit;
  bs:=TCLBStat.Create;
  Profile := GetProfile(CMD[1]);
  bs.ECO:=CMD[2];
  bs.ECODesc:=CMD[3];
  bs.PGN:=CMD[4];
  bs.WW:=CMD[5];
  bs.WL:=CMD[6];
  bs.WD:=CMD[7];
  bs.BW:=CMD[8];
  bs.BL:=CMD[9];
  bs.BD:=CMD[10];
  bs.cnt:=StrToInt(CMD[11]);
  Profile.BStats.Add(bs);
end;
//==================================================================================================
procedure TfCLProfile.DrawBeginningStat;
var
  ECOWidth, DescWidth, TotalWidth, ColWidth: integer;
  DescStart, WhiteStart, BlackStart, TotalStart,
  Middle: integer;
  sArr: array[0..2] of string;
  sCnt: array[0..5] of string;
  colArr: array[0..2] of TColor;
  C: TCanvas;
  i,j,n,k,len: integer;
  bs: TCLBStat;
  s: string;
begin
  // table params, width of columns, height of rows
  C:=Bitmap.Canvas;
  C.Font.Size := 10;
  C.Font.Style := [fsBold];
  ECOWidth:=C.TextWidth('ECO')+2*SMALL_INDENT;
  TotalWidth:=C.TextWidth('TOTAL')+2*SMALL_INDENT;
  ColWidth:=C.TextWidth('LOSS')+2*SMALL_INDENT;
  DescStart:=LEFT_INDENT+ECOWidth;
  C.Font.Style := [];
  DescWidth:=C.TextWidth(lpad('',40,'O'))+2*SMALL_INDENT;
  WhiteStart:=DescStart+DescWidth;
  BlackStart:=WhiteStart+ColWidth*3;
  RowHeight:=C.TextHeight('A')*2+8;
  FirstRow := TOP_INDENT+RowHeight;

  Profile.BStats.Sort(CompareBStat);
  n:=(Bitmap.Height - FirstRow - 160) div RowHeight;
  for i:=Profile.BStats.Count-1 downto n+1 do
    Profile.BStats.Delete(i);

  TotalStart:=WhiteStart+6*ColWidth;
  TableRight:=TotalStart+TotalWidth;
  TableBottom:=TOP_INDENT+(Profile.BStats.Count+1)*RowHeight;
  Middle := TOP_INDENT+RowHeight div 2;

  C.Brush.Color:=fGL.DefaultBackgroundColor;
  C.FillRect(Rect(0,0,Bitmap.Width-1,Bitmap.Height-1));
  C.Pen.Width:=2;
  C.Rectangle(LEFT_INDENT,TOP_INDENT,TableRight,TableBottom);
  C.MoveTo(WhiteStart,TOP_INDENT);
  C.LineTo(WhiteStart,TableBottom-1);
  C.MoveTo(BlackStart,TOP_INDENT);
  C.LineTo(BlackStart,TableBottom-1);
  C.MoveTo(TotalStart,TOP_INDENT);
  C.LineTo(TotalStart,TableBottom-1);
  C.MoveTo(LEFT_INDENT,TOP_INDENT+RowHeight);
  C.LineTo(TableRight-1,TOP_INDENT+RowHeight);

  C.Pen.Width:=1;
  C.MoveTo(WhiteStart,Middle);
  C.LineTo(TotalStart, Middle);
  C.MoveTo(DescStart,TOP_INDENT);
  C.LineTo(DescStart,TableBottom);
  {C.MoveTo(DescStart,TOP_INDENT);
  C.LineTo(DescStart,TableBottom);}
  for i:=1 to 5 do begin
    C.MoveTo(WhiteStart+i*ColWidth,Middle);
    C.LineTo(WhiteStart+i*ColWidth,TableBottom);
  end;

  C.Font.Style := [fsBold];
  TextOutCenter(C,Rect(LEFT_INDENT,TOP_INDENT,DescStart,FirstRow),'ECO',clBlack,10,[fsBold]);
  TextOutCenter(C,Rect(DescStart,TOP_INDENT,WhiteStart,Firstrow),'Description',clBlack,10,[fsBold]);
  TextOutCenter(C,Rect(TotalStart,TOP_INDENT,TableRight,FirstRow),'Total',clBlack,10,[fsBold]);
  TextOutCenter(C,Rect(WhiteStart,TOP_INDENT,BlackStart,Middle),'White',clBlack,10,[fsBold]);
  TextOutCenter(C,Rect(BlackStart,TOP_INDENT,TotalStart,Middle),'Black',clBlack,10,[fsBold]);
  sArr[0]:='win'; sArr[1]:='loss'; sArr[2]:='draw';
  colArr[0]:=COLOR_WIN; colArr[1]:=COLOR_LOST; colArr[2]:=COLOR_DRAW;
  for i:=0 to 1 do
    for j:=0 to 2 do begin
      n:=WhiteStart+(i*3+j)*ColWidth;
      TextOutCenter(C,Rect(n,Middle,n+ColWidth,FirstRow),sArr[j],colArr[j],10,[fsBold]);
    end;

  for i:=0 to Profile.BStats.Count-1 do begin
    bs:=TCLBStat(Profile.BStats[i]);
    sCnt[0]:=bs.WW; sCnt[1]:=bs.WL; sCnt[2]:=bs.WD;
    sCnt[3]:=bs.BW; sCnt[4]:=bs.BL; sCnt[5]:=bs.BD;
    n:=FirstRow+i*RowHeight;
    if i<>0 then begin
      C.MoveTo(LEFT_INDENT,n);
      C.LineTo(TableRight,n);
    end;
    TextOutCenter(C,Rect(LEFT_INDENT,n,DescStart,n+RowHeight),bs.ECO,clBlack,10,[]);
    for j:=0 to 5 do
      if sCnt[j]<>'0' then
        TextOutCenter(C,Rect(WhiteStart+j*ColWidth,n,WhiteStart+(j+1)*ColWidth,n+RowHeight),sCnt[j],colArr[j mod 3],10,[]);
    TextOutCenter(C,Rect(TotalStart,n,TableRight,n+RowHeight),IntToStr(bs.cnt),clBlack,10,[fsBold]);
    // description
    len:=C.TextWidth(bs.ECODesc);
    if len<=DescWidth-2*SMALL_INDENT then
      TextOutCenter(C,Rect(DescStart,n,WhiteStart,n+RowHeight),bs.ECODesc,clBlack,10,[])
    else begin
      k:=length(bs.ECODesc)*DescWidth div len;
      s:=copy(bs.ECODesc,1,k);
      TextOutCenter(C,Rect(DescStart,n,WhiteStart,n+RowHeight div 2),s,clBlack,10,[]);
      s:=copy(bs.ECODesc,k+1,256);
      TextOutCenter(C,Rect(DescStart,n+RowHeight div 2,WhiteStart,n+RowHeight),s,clBlack,10,[]);
    end;
  end;
  PictureWidth:=TableRight+40;
  PictureHeight:=TableBottom+40;
end;
//==================================================================================================
procedure TfCLProfile.SetScrollBars;
begin
  scbHor.Visible:= (PictureWidth>Self.Width) and IsCurrentPage(PAGE_ECO_CAPTION);
  if scbHor.Visible then begin
    scbHor.Max:=PictureWidth-Self.Width;
    scbHor.SmallChange:=scbHor.Max div 10;
    scbHor.LargeChange:=scbHor.Max div 3;
    //scbHor.PageSize:=scbHor.Max*Self.Width div PictureWidth;
  end;

  scbVer.Visible:=(PictureHeight>Self.Height) and IsCurrentPage(PAGE_ECO_CAPTION)
    or (reNotes.Tag + reNotes.Height > Self.Height) and IsCurrentPage(PAGE_PROFILE_CAPTION);
  if scbVer.Visible then begin
    if IsCurrentPage(PAGE_ECO_CAPTION) then
      scbVer.Max:=PictureHeight-Self.Height
    else if IsCurrentPage(PAGE_PROFILE_CAPTION) then
      scbVer.Max := reNotes.Tag + reNotes.Height - Self.Height;

    scbVer.SmallChange:=scbVer.Max div 10;
    scbVer.LargeChange:=scbVer.Max div 3;
  end;

end;
//==================================================================================================
procedure TfCLProfile.scbHorChange(Sender: TObject);
begin
  StartX:=scbHor.Position;
  StartY:=scbVer.Position;
  Repaint;
end;
//==================================================================================================
procedure TfCLProfile.FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
  n: integer;
  s: string;
begin
  n:=GetHintIndex(X,Y);
  if (Profile <> nil) and (n=-1) or (n>=Profile.BStats.Count) and IsCurrentPage(PAGE_ECO_CAPTION)
  then
    fCLProfile.ShowHint:=false
  else begin
    s:=TCLBStat(Profile.BStats[n]).PGN;
    if s<>fCLProfile.Hint then begin
      fCLProfile.ShowHint:=false;
      fCLProfile.ShowHint:=true;
      fCLProfile.Hint:=s;
    end;
  end;
end;
//==================================================================================================
function TfCLProfile.GetHintIndex(x, y: integer): integer;
var
  n: integer;
begin
  result := -1;
  if (Profile=nil) or (Profile.BStats = nil) or not IsCurrentPage(PAGE_ECO_CAPTION) then exit;
  x:=StartX+x;
  y:=StartY+y;
  result:=-1;
  if (x<LEFT_INDENT) or (x>TableRight) or (y<FirstRow) or (y>TableBottom) then exit;
  n:=(y-FirstRow) div RowHeight;
  if (n<0) or (n>=Profile.BStats.Count) then exit;
  result:=n;
end;
//==================================================================================================
procedure TfCLProfile.sbSearchClick(Sender: TObject);
var
  roomname,str,login: string;
begin
  if edtRoomName.Text='' then roomname:='%'
  else roomname:=edtRoomName.Text;

  if edtText.Text='' then str:='%'
  else str:=edtText.Text;

  if rbThisUserOnly.Checked then login:=lblLoginData.Caption
  else login:='%';

  FProfile.FdtFrom:=dtFrom.Date;
  FProfile.FdtTo:=dtTo.Date;
  FProfile.FFullChat:=rbFullChat.Checked;
  FProfile.FRoomName:=edtRoomName.Text;
  FProfile.FText:=edtText.Text;

  fCLSocket.InitialSend([CMD_STR_CHATLOG,
    lblLoginData.Caption,
    IntToStr(trunc(dtFrom.Date)),
    IntToStr(trunc(dtTo.Date)+1),
    login, roomname, edtPage.Text, str]);
end;
//==================================================================================================
procedure TfCLProfile.SpeedButton1Click(Sender: TObject);
begin
  edtRoomName.Text:='';
end;
//==================================================================================================
procedure TfCLProfile.SpeedButton2Click(Sender: TObject);
begin
  edtText.Text:='';
end;
//==================================================================================================
procedure TfCLProfile.FormShow(Sender: TObject);
begin
  {if (fCLSocket.MyAdminLevel<3) and (tcMain.Tabs.Count>5) then
    tcMain.Tabs.Delete(5);}
end;
//==================================================================================================
procedure TfCLProfile.ProfileChatLog(const CMD: TStrings);
var
  Profile: TCLProfile;
  dt: TDateTime;
  sDate,s: string;
begin
  Profile:=GetProfile(CMD[1]);
  if Profile = nil then exit;
  dt:=Str2Float(CMD[2]);
  sDate:=FormatDateTime('mm/dd/yyyy h:nn:ss AM/PM',dt);
  s:=Format('%s [%s] %s: %s',[sDate,CMD[6],CMD[3],CMD[7]]);
  Profile.ChatLog.Add(s);
end;
//==================================================================================================
procedure TfCLProfile.ProfileChatLogEnd(const CMD: TStrings);
begin
  LoadProfile;
end;
//==================================================================================================
procedure TfCLProfile.ProfileChatLogPage(const CMD: TStrings);
var
  Profile: TCLProfile;
begin
  Profile:=GetProfile(CMD[1]);
  if Profile = nil then exit;
  Profile.FPage:=StrToInt(CMD[2]);
  Profile.FPageCount:=StrToInt(CMD[3]);
end;
//==================================================================================================
procedure TfCLProfile.ProfileChatLogStart(const CMD: TStrings);
var
  Profile: TCLProfile;
begin
  Profile:=GetProfile(CMD[1]);
  if Profile = nil then exit;
  Profile.ChatLog.Clear;
end;
//==================================================================================================
procedure TfCLProfile.sbPageFirstClick(Sender: TObject);
begin
  udPage.Position:=1;
end;
//==================================================================================================
procedure TfCLProfile.sbPageLastClick(Sender: TObject);
begin
  udPage.Position:=udPage.Max;
end;
//==================================================================================================
procedure TfCLProfile.edtRoomNameChange(Sender: TObject);
begin
  udPage.Position:=1;

end;
//==================================================================================================
procedure TfCLProfile.sbClearColorClick(Sender: TObject);
begin
  cmbColor.ItemIndex:=-1;
end;
//==================================================================================================
procedure TfCLProfile.sbClearResultClick(Sender: TObject);
begin
  cmbResult.ItemIndex:=-1;
end;
//==================================================================================================
procedure TfCLProfile.sbClearTypeClick(Sender: TObject);
begin
  cmbType.ItemIndex:=-1;
end;
//==================================================================================================
procedure TfCLProfile.sbClearEcoClick(Sender: TObject);
begin
  edtEco.Clear;
end;
//==================================================================================================
procedure TfCLProfile.sbClearOpponentClick(Sender: TObject);
begin
  edtOpponent.Clear;
end;
//==================================================================================================
procedure TfCLProfile.miTodayClick(Sender: TObject);
begin
  dtFilterFrom.Date:=Date;
  dtFilterTo.Date:=Date;
end;
//==================================================================================================
procedure TfCLProfile.miYesterdayClick(Sender: TObject);
begin
  dtFilterFrom.Date:=Date-1;
  dtFilterTo.Date:=Date-1;
end;
//==================================================================================================
procedure TfCLProfile.miLastWeekClick(Sender: TObject);
begin
  dtFilterFrom.Date:=Date-6;
  dtFilterTo.Date:=Date;
end;
//==================================================================================================
procedure TfCLProfile.miLastMonthClick(Sender: TObject);
begin
  dtFilterFrom.Date:=Date-30;
  dtFilterTo.Date:=Date;
end;
//==================================================================================================
procedure TfCLProfile.sbClearClick(Sender: TObject);
begin
  sbClearColor.Click;
  sbClearResult.Click;
  sbClearType.Click;
  sbClearECO.Click;
  sbClearOpponent.Click;
  miLast10Years.Click;
  udGamesPage.Position:=1;
end;
//==================================================================================================
procedure TfCLProfile.ProfilePages(const CMD: TStrings);
var
  Profile: TCLProfile;
begin
  if CMD.Count<3 then exit;
  Profile := GetProfile(CMD[1]);
  if Profile = nil then Exit;
  Profile.FPagesCount:=StrToInt(CMD[2]);
  if FProfile = Profile then begin
    lblPagesCount.Caption:='of '+CMD[2];
    udGamesPage.Max:=Profile.FPagesCount;
  end;
end;
//==================================================================================================
procedure TfCLProfile.sbGamesSearchClick(Sender: TObject);
var
  ECO, Opponent: string;
begin
  if FProfile = nil then exit;
  if pos(' ',trim(edtECO.Text))>0 then begin
    MessageDlg('ECO must not contain spaces',mtError,[mbOk],0);
    exit;
  end;
  if pos(' ',trim(edtOpponent.Text))>0 then begin
    MessageDlg('Opponent''s name must not contain spaces',mtError,[mbOk],0);
    exit;
  end;

  ECO:=trim(edtECO.Text);
  if ECO = '' then ECO:='-';
  Opponent:=trim(edtOpponent.Text);
  if Opponent = '' then Opponent:='-';

  fCLSocket.InitialSend([CMD_STR_GAMESEARCH,
    FProfile.FLogin,
    IntToStr(trunc(dtFilterFrom.Date)),
    IntToStr(trunc(dtFilterTo.Date)),
    IntToStr(cmbColor.ItemIndex),
    IntToStr(cmbResult.ItemIndex),
    IntToStr(cmbType.ItemIndex),
    ECO,
    Opponent,
    edGamesPage.Text]);
end;
//==================================================================================================
procedure TfCLProfile.FilterChange(Sender: TObject);
begin
  udGamesPage.Position:=1;
  udGamesPage.Max:=1;
  lblPagesCount.Caption:='';
end;
//==================================================================================================
procedure TfCLProfile.RecentClear(const CMD: TStrings);
var
  Profile: TCLProfile;
  Index: integer;
  Game: TCLProfileGame;
begin
  if CMD.Count<2 then exit;
  Profile := GetProfile(CMD[1]);
  if Profile = nil then Exit;
  for Index := FProfile.FGames.Count-1 downto 0 do
    begin
      Game := TCLProfileGame(FProfile.FGames[Index]);
      if (Game = nil) or (Game.FType = 0) then
        FProfile.FGames.Delete(Index);
    end;

  if (FProfile = Profile) and IsCurrentPage(PAGE_RECENT_CAPTION) then
    lvGames.Items.Clear;
end;
//==================================================================================================
procedure TfCLProfile.AddLVGame(Game: TCLProfileGame);
var
  Item: TListItem;
begin
  Item := lvGames.Items.Add;
  with Item do
    begin
      Data := Game;
      ImageIndex := 11;
      Caption := IntToStr(Game.FLocalIndex);
      SubItems.Add(Game.FWhiteName);
      SubItems.Add(IntToStr(Game.FWhiteRating));
      SubItems.Add(Game.FBlackName);
      SubItems.Add(IntToStr(Game.FBlackRating));
      SubItems.Add(Game.FRatedType);
      SubItems.Add(MSecToGridStr(Game.FInitialMSec,Game.FIncMSec));

      if Game.FRated = 1 then
        SubItems.Add('Yes')
      else
        SubItems.Add('No');
      SubItems.Add(Game.FResult);
      SubItems.Add(Game.FECO);
      SubItems.Add(Game.FDate);
      SubItems.Add(Game.FEcoDesc);
    end;
end;
//==================================================================================================
procedure TfCLProfile.miLast10YearsClick(Sender: TObject);
begin
  dtFilterFrom.Date:=Date-365*10;
  dtFilterTo.Date:=Date;
end;
//==================================================================================================
procedure TfCLProfile.AddChatTab;
begin
  if tcMain.Tabs.IndexOf(PAGE_CHATLOG_CAPTION)=-1 then
    tcMain.Tabs.Add(PAGE_CHATLOG_CAPTION);
end;
//==================================================================================================
procedure TfCLProfile.DeleteChatTab;
var
  n: integer;
begin
  n := tcMain.Tabs.IndexOf(PAGE_CHATLOG_CAPTION);
  if n <> -1 then
    tcMain.Tabs.Delete(n);
end;
//==================================================================================================
procedure TfCLProfile.ProfileChatReader(const CMD: TStrings);
var
  Rating: TCLRating;
  Profile: TCLProfile;
begin
  if CMD.Count<5 then exit;
  Profile := GetProfile(CMD[2]);
  if Profile = nil then Exit;

  Profile.FChatVisible := CMD[4]='1';
end;
//==================================================================================================
procedure TfCLProfile.pm1Popup(Sender: TObject);
begin
  miDeletePhoto.Visible := fCLSocket.MyAdminLevel >= 2;
  miChangeNotes.Visible := fCLSocket.MyAdminLevel >= 2;
end;
//==================================================================================================
procedure TfCLProfile.miDeletePhotoClick(Sender: TObject);
begin
  if MessageDlg('Do you really want to delete photo?',mtConfirmation,[mbYes,mbNo],0) = mrYes then begin
    fCLSocket.InitialSend([CMD_STR_DELETEPROFILEPHOTO, FProfile.FLogin]);
    imgPhoto.Visible:=false;
    pnlPhoto.Caption:='NO PHOTO';
    pnlPhoto.Color := fGL.DefaultBackgroundColor;
  end;
end;
//==================================================================================================
procedure TfCLProfile.miChangeNotesClick(Sender: TObject);
var
  s: string;
begin
  s := InputBox('Changing notes', 'Enter new notes', '');
  fCLSocket.InitialSend([CMD_STR_SETPROFILENOTES, FProfile.FLogin, s]);
  reNotes.Text := s;
end;
//==================================================================================================
procedure TfCLProfile.dtFromChange(Sender: TObject);
begin
  udPage.Position:=1;
  dtTo.DateTime := dtFrom.DateTime;
end;
//==================================================================================================
procedure TfCLProfile.CreateTabs;
begin
  tcMain.Tabs.Clear;
  tcMain.Tabs.Add(PAGE_PROFILE_CAPTION);
  tcMain.Tabs.Add(PAGE_RECENT_CAPTION);
  tcMain.Tabs.Add(PAGE_LIBRARY_CAPTION);
  tcMain.Tabs.Add(PAGE_ADJOURNED_CAPTION);
  tcMain.Tabs.Add(PAGE_ECO_CAPTION);
  tcMain.Tabs.Add(PAGE_ACH_CAPTION);
end;
//==================================================================================================
function TfCLProfile.IsCurrentPage(Caption: string): Boolean;
begin
  result := (tcMain.TabIndex >= 0) and (tcMain.Tabs[tcMain.TabIndex] = Caption);
end;
//==================================================================================================
function TfCLProfile.CurrentGameType: integer;
begin
  if IsCurrentPage(PAGE_RECENT_CAPTION) then result := 0
  else if IsCurrentPage(PAGE_LIBRARY_CAPTION) then result := 1
  else if IsCurrentPage(PAGE_ADJOURNED_CAPTION) then result := 2
  else result := -1;
end;
//==================================================================================================
procedure TfCLProfile.Copy1Click(Sender: TObject);
begin
  if reChatLog.SelLength > 0 then
    ClipBoard.AsText:=reChatLog.SelText
  else
    ClipBoard.AsText:=reChatLog.Lines.Text;
end;
//==================================================================================================
function TfCLProfile.GetAchUserList(Login: string): TCLAchUserList;
var
  Profile: TCLProfile;
begin
  Profile := GetProfile(Login);
  if Profile = nil then result := nil
  else result := Profile.AchUserList;
end;
//==================================================================================================
procedure TfCLProfile.CMD_AchSendEnd(CMD: TStrings);
var
  Login: string;
begin
  if CMD.Count < 2 then exit;
  Login := CMD[1];
  if (FProfile <> nil) and (FProfile.FLogin = Login) and IsCurrentPage(PAGE_ACH_CAPTION) then
    AchForm.Repaint;
end;
//==================================================================================================
procedure TfCLProfile.CMD_PaymentBegin(CMD: TStrings);
var
  Profile: TCLProfile;
  Login: string;
begin
  if CMD.Count < 2 then exit;
  Login := CMD[1];
  Profile := GetProfile(Login);
  if Profile = nil then exit;

  Profile.FPaymentTransferred := true;
  Profile.FPayments.Clear;
end;
//==================================================================================================
procedure TfCLProfile.CMD_Payment(CMD: TStrings);
var
  Profile: TCLProfile;
  Login: string;
  P: TCLPayment;
begin
  if CMD.Count < 22 then exit;
  Login := CMD[1];
  Profile := GetProfile(Login);
  if Profile = nil then exit;

  P := TCLPayment.Create;

  P.id := StrToInt(CMD[2]);
  P.Login := Profile.FLogin;
  P.TransactionDate := Str2Float(CMD[3]);
  P.Deleted := CMD[4] = '1';
  P.MembershipType := StrToInt(CMD[5]);
  P.MembershipTypeName := CMD[6];
  P.SubscribeType := StrToInt(CMD[7]);
  P.SubscribeTypeName := CMD[8];
  P.SourceType := StrToInt(CMD[9]);
  P.SourceTypeName := CMD[10];
  P.ExpireDate := Str2Float(CMD[11]);
  P.Amount := Str2Float(CMD[12]);
  P.AmountFull := Str2Float(CMD[13]);
  P.NameOnCard := CMD[14];
  P.CardType := CMD[15];
  P.CardNumber := CMD[16];
  P.AdminCreated := CMD[17];
  P.AdminDeleted := CMD[18];
  P.AdminComment := CMD[19];
  P.PromoID := StrToInt(CMD[20]);
  P.PromoCode := CMD[21];

  Profile.FPayments.Add(P);
end;
//==================================================================================================
procedure TfCLProfile.AddTab(p_Caption: string);
begin
  if tcMain.Tabs.IndexOf(p_Caption)=-1 then
    tcMain.Tabs.Add(p_Caption);
end;
//==================================================================================================
procedure TfCLProfile.CMD_PaymentEnd(CMD: TStrings);
var
  Login: string;
begin
  if CMD.Count < 2 then exit;
  Login := lowercase(CMD[1]);
  if (FProfile <> nil) and (lowercase(FProfile.FLogin) = Login) then
    LoadPayments;
  {if IsCurrentPage(PAGE_PAYMENT_CAPTION) then
    tcMain.OnChange(nil);}
end;
//==================================================================================================
procedure TfCLProfile.LoadPayments;
var
  i: integer;
  P: TCLPayment;
  itm: TListItem;
begin
  if FProfile.FPaymentTransferred then begin
    AddTab(PAGE_PAYMENT_CAPTION);
    lvPayment.Items.Clear;
    for i := 0 to FProfile.FPayments.Count - 1 do begin
      P := FProfile.FPayments[i];
      itm := lvPayment.Items.Add;
      itm.Caption := IntToStr(P.id);
      itm.SubItems.Add(FormatDateTime('MM/dd/yyyy',P.TransactionDate));
      itm.SubItems.Add(P.MembershipTypeName);
      itm.SubItems.Add(P.SubscribeTypeName);
      itm.SubItems.Add(P.SourceTypeName);
      itm.SubItems.Add(FormatDateTime('MM/dd/yyyy',P.ExpireDate));
      itm.SubItems.Add(FloatToStr(P.Amount));
      itm.SubItems.Add(FloatToStr(P.AmountFull));
      itm.SubItems.Add(P.NameOnCard);
      itm.SubItems.Add(P.CardType);
      itm.SubItems.Add(P.CardNumber);
      itm.SubItems.Add(P.AdminCreated);
      itm.SubItems.Add(P.AdminDeleted);
      itm.SubItems.Add(P.AdminComment);
      itm.SubItems.Add(P.PromoCode);
      if P.Deleted then itm.ImageIndex := 1
      else itm.ImageIndex := 0;
      itm.Data := P;
    end;
  end;
end;
//==================================================================================================
procedure TfCLProfile.EditPayment;
var
  F: TfCLPaymentEdit;
begin
  if lvPayment.Selected = nil then exit;

  F := TfCLPaymentEdit.Create(Self);
  F.Initialize(lvPayment.Selected.Data);
  F.ShowModal;
  F.Free;
end;
//==================================================================================================
procedure TfCLProfile.NewPayment;
var
  F: TfCLPaymentEdit;
begin
  F := TfCLPaymentEdit.Create(Self);
  F.InitNew(FProfile.FLogin);
  F.ShowModal;
  F.Free;
end;
//==================================================================================================
procedure TfCLProfile.CMD_ProfilePayData(const CMD: TStrings);
var
  Profile: TCLProfile;
  Login: string;
begin
  if CMD.Count < 5 then exit;
  Login := CMD[2];
  Profile := GetProfile(Login);
  if Profile = nil then exit;

  Profile.FMembershipVisible := true;
  Profile.FMembershipType := TMembershipType(StrToInt(CMD[3]));
  Profile.FMembershipExpireDate := Str2Float(CMD[4]);
end;
//==================================================================================================
procedure TfCLProfile.DrawSpecialOffer;
var
  vBottom, h: integer;
  cnv: TCanvas;
begin
  cnv := imgSpecialOffer.Canvas;
  cnv.Brush.Color := fGL.DefaultBackgroundColor;
  cnv.FillRect(imgSpecialOffer.ClientRect);
  imgSpecialOffer.Canvas.Font.Name := 'Arial';
  TextOutMultiline(imgSpecialOffer.Canvas, 12, imgSpecialOffer.Width - 12, 6, 0, SPECIAL_OFFER, clBlue, 12, [fsBold], vBottom, true);
  //DrawFrame(cnv, imgSpecialOffer.ClientRect, clBlue, 2, 3);
end;
//==================================================================================================
{ TCLPayments }

function TCLPayments.GetPayment(Index: integer): TCLPayment;
begin
  result := TCLPayment(Items[Index]);
end;
//==================================================================================================
procedure TfCLProfile.Edit1Click(Sender: TObject);
begin
  EditPayment;
end;
//==================================================================================================
procedure TfCLProfile.lvPaymentDblClick(Sender: TObject);
begin
  EditPayment;
end;
//==================================================================================================
procedure TfCLProfile.NewTransaction1Click(Sender: TObject);
begin
  NewPayment;
end;
//==================================================================================================
procedure TfCLProfile.btnChatLogURLClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar('www.perpetualchess.com'), '', '', SW_SHOWNORMAL);
end;
//==================================================================================================
procedure TfCLProfile.sbPayHereClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar('http://www.perpetualchess.com'), '', '', SW_SHOWNORMAL)
end;
//==================================================================================================
end.


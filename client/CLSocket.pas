{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLSocket;

interface

uses
  Forms, Messages, SysUtils, Classes, Windows, winsock, ScktComp,
  CLGame, CLGlobal, controls, CLConst, CLTerminal;

const
  STD_BYTES = 1024;
  MAX_BYTES = 4096;

type
  TInitState = (isDisconnect, isConnect, isLookUp, isConnecting, isConnected,
               isBeginLogin, isFinishLogin, isLoginComplete, isRequestSent,
               isReceivingData, isRequestComplete, isForgotPassword);

  TCLSocket = class(TControl)
    procedure FinalSend(var Data: string; Size: Integer);

  private
    { Private declarations }
    FAccount: TAccount;
    FInitState: TInitState;
    FMyName: string;
    FSocket: TClientSocket;
    FMyAdminLevel: integer;
    FMyTitle: string;
    FClubName: string;
    FClubId: integer;
    FMyNotes: string;
    FMyRatingInfo: TRatingInfo;
    FMyRoles: string;
    FMyLoginID: integer;

    procedure CloseSocket;
    procedure Connect;
    procedure SetInitState(const State: TInitState);

    procedure FSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure FSocketConnecting(Sender: TObject; Socket: TCustomWinSocket);
    procedure FSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure FSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure FSocketLookup(Sender: TObject; Socket: TCustomWinSocket);
    procedure FSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure SetAccount(const Account: TAccount);
    function WSAEDesc(Error: Integer): string;
    procedure Log(CMDElements: array of string);
    function GetRatedGamesNumber(const Value: TRatedType): Integer;
    function GetRating(const Value: TRatedType): Integer;
    function GetRatingProv(const Value: TRatedType): Boolean;
    function GetRatingInitialized: Boolean;
    procedure ClearMyInfo; 

  public
    { Public declarations }
    Rights: TUserRights;

    constructor Create;
    destructor Destroy; override;

    function MeEmployed(p_Role: string): Boolean;
    procedure AckPing;
    procedure InitialSend(CMDElements: array of string);
    procedure SetMyRating(const RatingString, ProvString: string);

    property Account: TAccount read FAccount write SetAccount;
    property InitState: TInitState read FInitState write SetInitState;
    property MyName: string read FMyName write FMyName;
    property MyTitle: string read FMyTitle write FMyTitle;
    property MyAdminLevel: integer read FMyAdminLevel write FMyAdminLevel;
    property MyRating[const Value: TRatedType]: Integer read GetRating;
    property MyRatingProv[const Value: TRatedType]: Boolean read GetRatingProv;
    property MyRatedGamesNumber[const Value: TRatedType]: Integer read GetRatedGamesNumber;
    property MyNotes: string read FMyNotes write FMyNotes;
    property MyRoles: string read FMyRoles write FMyRoles;
    property ClubId: integer read FClubId write FClubId;
    property ClubName: string read FClubName write FClubName;
    property RatingInitialized: Boolean read GetRatingInitialized;
    property MyLoginID: integer read FMyLoginID write FMyLoginID;
  end;

var
  fCLSocket: TCLSocket;

implementation

uses
  CLBoard, CLCLS, CLGames, CLLogin, CLMain, CLMessages,
  CLNotify, CLSeeks, CLRooms, CLSeek, CLRegister, CLConsole,
  CLMessage, CLProfile, CLCrypt, CLNet, CLLib, CLEventControl, CLEvents,
  CLSocket2, CLLectures, CSClub, CLAchievementClass, CLClubs, CLAchievements;
//______________________________________________________________________________
procedure TCLSocket.CloseSocket;
begin
  if FSocket.Active then FSocket.Active := False;
  if fCLCLS <> nil then fCLCLS.Free;
end;
//______________________________________________________________________________
procedure TCLSocket.Connect;
begin
  try
    with FSocket do
      begin
        if Active then Active := False;
        Host := FAccount.Server;
        Port := FAccount.Port;
        Active := True;
      end;
  except
    on E: ESocketError do
      begin
        fCLTerminal.ccConsole.AddLine(0, E.message, ltServerMsgNormal);
        InitState := isDisconnect;
      end;
  end;
end;
//______________________________________________________________________________
procedure TCLSocket.SetInitState(const State: TInitState);
var
  s: string;
begin
  if ((State <> isConnect) and (FInitState = isDisconnect))
  or (State = FInitState) then Exit;

  FInitState := State;

  case State of
    isConnect:
      begin
        FMyName := '';
        fCLMain.InitState := isConnect;
        if fCLLogin <> nil then
          fCLLogin.lblInfo.Caption := 'Connecting...';
        if fCLRegister <> nil then
          fCLRegister.lblInfo.Caption := 'Connecting...';
        Connect;
      end;
    isLookUp:
      begin
        if fCLLogin <> nil then
          fCLLogin.lblInfo.Caption := 'Looking Up Host...';
        if fCLRegister <> nil then
          fCLRegister.lblInfo.Caption := 'Looking Up Host...';
      end;
    isConnecting:
      begin
        if fCLLogin <> nil then
          fCLLogin.lblInfo.Caption := 'Connecting...';
        if fCLRegister <> nil then
          fCLRegister.lblInfo.Caption := 'Connecting...';
      end;
    isConnected:
      begin
        if fCLLogin <> nil then
          fCLLogin.lblInfo.Caption := 'Connected';
        if fCLRegister <> nil then
          fCLRegister.lblInfo.Caption := 'Connected.';
        fCLCLS := TCLCLS.Create;
      end;
    isBeginLogin:
      begin
        if fCLLogin <> nil then
          begin
            s := CLNet.GetMACAdress;
            InitialSend([CMD_STR_LOGIN, FAccount.Login, FAccount.Password,
              '15', CLIENT_VERSION, s, BoolTo_(IS_BANNED,'1','0')]);
            fCLLogin.lblInfo.Caption := 'Verifying Name...';
        end;
        if fCLRegister <> nil then fCLRegister.SendRegister;
      end;

    isForgotPassword:
      begin
        fCLSocket.InitialSend([CMD_STR_PASS_FORGOT,FAccount.Login]);
        fCLLogin.lblInfo.Caption := 'Requesting password...';
      end;

    isFinishLogin:;

    isLoginComplete:
      begin
        fCLMain.InitState := isLoginComplete;
        fCLTerminal.SetMenuState;
        //fCLNotify.SetMenuState;
        fCLMessages.SetMenuState;
        fCLProfile.SetMenuState;
        fCLRooms.SetMenuState;
        if fCLSeek <> nil then fCLSeek.btnIssue.Enabled := True;
        if fCLLogin <> nil then fCLLogin.Close;
      end;

    isRequestSent:
      fCLMain.InitState := isRequestSent;

    isReceivingData:
      fCLMain.InitState := isReceivingData;

    isRequestComplete:
      fCLMain.InitState := isRequestComplete;

    isDisconnect:
      begin
        if FSocket.Active then InitialSend([CMD_STR_BYE]);
        FMyName := '';
        CloseSocket;
        ClearMyInfo;
        fCLMain.InitState := isDisconnect;
        fCLBoard.Disconnect;
        fCLTerminal.ccConsole.EndUpdate;
        fCLTerminal.SetMenuState;
        fCLTerminal.ClearLogins;
        fCLNotify.ClearAll;
        //fCLNotify.SetMenuState;
        //fCLOffers.Clear;
        fCLSeeks.Clear;
        fCLRooms.Clear;
        fCLRooms.SetMenuState;
        fCLGames.Clear;
        fCLMessages.SetMenuState;
        fCLProfile.SetMenuState;
        if fCLEventControl.Visible then
          fCLEventControl.CloseEventControl;
        fCLEvents.lvEvents.Items.Clear;
        fCLLectures.lvLectures.Items.Clear;
        fClubs.Clear;
        AchList.Clear;
        if fCLCLubs.Visible then fCLClubs.Repaint;
        if fCLAchievements.Visible then fCLAchievements.Repaint;
        { Dynamically created forms }
        if fCLSeek <> nil then fCLSeek.btnIssue.Enabled := False;
        if fCLLogin <> nil then fCLLogin.EnableLogin;
        if fCLRegister <> nil then fCLRegister.EnableRegister;
        if fCLMessage <> nil then fCLMessage.btnSend.Enabled := False;
        fCLSocket2.Disconnect;
      end;
  end;
end;
//______________________________________________________________________________
constructor TCLSocket.Create;
begin
  FSocket := TClientSocket.Create(nil);
  FSocket.OnConnect := FSocketConnect;
  FSocket.OnConnecting := FSocketConnecting;
  FSocket.OnDisconnect := FSocketDisconnect;
  FSocket.OnError := FSocketError;
  FSocket.OnLookup := FSocketLookup;
  FSocket.OnRead := FSocketRead;

  FAccount := TAccount.Create;
  FMyRatingInfo := TRatingInfo.Create('');
end;
//______________________________________________________________________________
destructor TCLSocket.Destroy;
begin
  FAccount.Free;
  FSocket.Free;
  inherited;
end;
//______________________________________________________________________________
procedure TCLSocket.AckPing;
begin
  InitialSend([CMD_STR_ACK_PING]);
end;
//______________________________________________________________________________
procedure TCLSocket.Log(CMDElements: array of string);
var
  LogName: string;
  F: TextFile;
  i: integer;
begin
  if DebugHook = 0 then exit;
  LogName:=ExtractFileDir(Application.ExeName)+'\socket.log';
  AssignFile(F,LogName);
  if FileExists(LogName) then Append(F)
  else Rewrite(F);
  try
    writeln(F,'>>>>>> '+CMDElements[0]);
    for i:=1 to high(CMDElements) do
      writeln(F,CMDElements[i]);
  finally
    Close(F);
  end;
end;
//______________________________________________________________________________
procedure TCLSocket.InitialSend(CMDElements: array of string);
var
  Index: Integer;
  Data: string;
begin
  if not FSocket.Socket.Connected  then
    begin
      fCLTerminal.ccConsole.AddLine(0, 'Not connected to server', ltServerMsgError);
      fCLTerminal.ccConsole.EndUpdate;
    end
  else
    begin
      { Build the space delimited data to send. }
      Log(CMDElements);
      Data := '';
      for Index := 0 to High(CMDElements) do
        Data := Data + CMDElements[Index] + #32;
      { !!! Don't use the Trim fuction. It strips control characters. }
      Index := Length(Data);
      if Index > 0 then Data[Index] := #10;

      { Encrypt.
      Key := CIPHER_KEY;
      for Index := 1 to Length(Data) do
        begin
          Data[Index] := Char(Byte(Data[Index]) xor (Key shr 8));
          Key := (Byte(Data[Index]) + Key) * CIPHER1 + CIPHER2;
        end;
      }
     CLCrypt.Encrypt(Data);

      { Send the data }
      Index := Length(Data);
      if Index > 0 then FinalSend(Data, Index);
    end;
end;
//______________________________________________________________________________
procedure TCLSocket.FSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  CLCrypt.Reset;
  InitState := isConnected;
end;
//______________________________________________________________________________
procedure TCLSocket.FSocketConnecting(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  InitState := isConnecting;
end;
//______________________________________________________________________________
procedure TCLSocket.FSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  fGL.PlayCLSound(SI_DISCONNECT);
  InitState := isDisconnect;
end;
//______________________________________________________________________________
procedure TCLSocket.FSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var
  s: string;
begin
  s := 'There was an error in establishing or maintaining a connection. The reason given is: '
    + IntToStr(ErrorCode) + '-' + WSAEDesc(ErrorCode)
    + '.  Please check your account settings and network connection and try again.';
  if fCLLogin <> nil then
    fCLLogin.lblInfo.Caption := s
  else if fCLRegister <> nil then
    fCLRegister.lblInfo.Caption := s
  else
    Application.MessageBox(pchar(s), 'Socket Error', MB_OK + MB_ICONERROR);

  if ErrorCode > 0 then InitState := isDisconnect;
  ErrorCode := 0;
  fCLTerminal.ccConsole.EndUpdate;
end;
//______________________________________________________________________________
procedure TCLSocket.FSocketLookup(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  InitState := isLookUp;
end;
//______________________________________________________________________________
procedure TCLSocket.FSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  BytesRead, TotalBytes, n: Integer;
  Data, DecryptedData, s: string;
begin
  { Just for future reference, never, ever do this: FData[FTotalBytes] := #0;
    It'll introduce more bugs 'n you can ever hunt down! }

  try
    DecryptedData := '';
    TotalBytes := 0;
    repeat
      { Read from socket }
      SetLength(Data, TotalBytes + MAX_BYTES);
      BytesRead := Socket.ReceiveBuf(Data[TotalBytes + 1], MAX_BYTES);
      if BytesRead > -1 then TotalBytes := TotalBytes + BytesRead;
    until (BytesRead = -1) or (BytesRead < MAX_BYTES);

    CLCrypt.Decrypt(Data, TotalBytes, DecryptedData);

  { Process the data }
    fCLCLS.Receive(DecryptedData, TotalBytes);
  except
    on E: Exception do begin
      {CLLib.Log(DecryptedData,'errors.log');
      CLLib.Log(E.Message,'errors.log');
      CLLib.Log('---------','errors.log');}
      if DecryptedData = '' then s:=''
      else begin
        // trying to get command from DecryptedData
        if DecryptedData[1] = DP_START then s:=copy(DecryptedData,2,length(DecryptedData))
        else s:=DecryptedData;
        n := pos(DP_DELIMITER, s);
        if (n = 0) or (n>30) then n:=30;
        SetLength(s, n - 1);
      end;
      ProcessError('Socket', fCLMain.GetExceptionStack,
        integer(ErrorAddr), E.Message, s);
    end;
  end;
end;
//______________________________________________________________________________
procedure TCLSocket.SetAccount(const Account: TAccount);
begin
  FAccount.Assign(Account);
end;
//______________________________________________________________________________
function TCLSocket.WSAEDesc(Error: Integer) : string;
begin
  case error of
    0:
      Result := 'No Error';
    WSAEINTR:
      Result := 'Interrupted system call';
    WSAEBADF:
      Result := 'Bad file number';
    WSAEACCES:
      Result := 'Permission denied';
    WSAEFAULT:
      Result := 'Bad address';
    WSAEINVAL:
      Result := 'Invalid argument';
    WSAEMFILE:
      Result := 'Too many open files';
    WSAEWOULDBLOCK:
      Result := 'Operation would block';
    WSAEINPROGRESS:
      Result := 'Operation now in progress';
    WSAEALREADY:
      Result := 'Operation already in progress';
    WSAENOTSOCK:
      Result := 'Socket operation on non-socket';
    WSAEDESTADDRREQ:
      Result := 'Destination address required';
    WSAEMSGSIZE:
      Result := 'Message too long';
    WSAEPROTOTYPE:
      Result := 'Protocol wrong type for socket';
    WSAENOPROTOOPT:
      Result := 'Protocol not available';
    WSAEPROTONOSUPPORT:
      Result := 'Protocol not supported';
    WSAESOCKTNOSUPPORT:
      Result := 'Socket type not supported';
    WSAEOPNOTSUPP:
      Result := 'Operation not supported on socket';
    WSAEPFNOSUPPORT:
      Result := 'Protocol family not supported';
    WSAEAFNOSUPPORT:
      Result := 'Address family not supported by protocol family';
    WSAEADDRINUSE:
      Result := 'Address already in use';
    WSAEADDRNOTAVAIL:
      Result := 'Address not found';
    WSAENETDOWN:
      Result := 'Network is down';
    WSAENETUNREACH:
      Result := 'Network is unreachable';
    WSAENETRESET:
      Result := 'Network dropped connection on reset';
    WSAECONNABORTED:
      Result := 'Connection aborted';
    WSAECONNRESET:
      Result := 'Connection reset by peer';
    WSAENOBUFS:
      Result := 'No buffer space available';
    WSAEISCONN:
      Result := 'Socket is already connected';
    WSAENOTCONN:
      Result := 'Socket is not connected';
    WSAESHUTDOWN:
      Result := 'Can''t send after socket shutdown';
    WSAETOOMANYREFS:
      Result := 'Too many references: can''t splice';
    WSAETIMEDOUT:
      Result := 'Connection timed out';
    WSAECONNREFUSED:
      Result := 'Connection refused';
    WSAELOOP:
      Result := 'Too many levels of symbolic links';
    WSAENAMETOOLONG:
      Result := 'File name too long';
    WSAEHOSTDOWN:
      Result := 'Host is down';
    WSAEHOSTUNREACH:
      Result := 'No route to host';
    WSAENOTEMPTY:
      Result := 'Directory not empty';
    WSAEPROCLIM:
      Result := 'Too many processes';
    WSAEUSERS:
      Result := 'Too many users';
    WSAEDQUOT:
      Result := 'Disc quota exceeded';
    WSAESTALE:
      Result := 'Stale NFS file handle';
    WSAEREMOTE:
      Result := 'Too many levels of remote in path';
    WSASYSNOTREADY:
      Result := 'Network sub-system is unusable';
    WSAVERNOTSUPPORTED:
      Result := 'WinSock DLL cannot support this application';
    WSANOTINITIALISED:
      Result := 'WinSock not initialized';
    WSAHOST_NOT_FOUND:
      Result := 'Host not found';
    WSATRY_AGAIN:
      Result := 'Non-authoritative host not found';
    WSANO_RECOVERY:
      Result := 'Non-recoverable error';
    WSANO_DATA:
      Result := 'No Data';
    else
      Result := 'Unknown error';
  end;
end;
//______________________________________________________________________________
procedure TCLSocket.FinalSend(var Data: string; Size: Integer);
begin
  if FSocket.Socket.Connected then FSocket.Socket.SendBuf(Data[1], Size);
end;
//______________________________________________________________________________
procedure TCLSocket.SetMyRating(const RatingString, ProvString: string);
begin
  FMyRatingInfo.SetRatingString(RatingString);
  FMyRatingInfo.ProvString := ProvString;
end;
//______________________________________________________________________________
function TCLSocket.GetRatedGamesNumber(const Value: TRatedType): Integer;
begin
  result := FMyRatingInfo.NumberOfGames(Value);
end;
//______________________________________________________________________________
function TCLSocket.GetRating(const Value: TRatedType): Integer;
begin
  result := FMyRatingInfo.Rating[Value];
end;
//______________________________________________________________________________
function TCLSocket.GetRatingProv(const Value: TRatedType): Boolean;
begin
  result := FMyRatingInfo.IsProv[Value];
end;
//______________________________________________________________________________
function TCLSocket.GetRatingInitialized: Boolean;
begin
  result := FMyRatingInfo.IsOk;
end;
//______________________________________________________________________________
procedure TCLSocket.ClearMyInfo;
begin
  MyName := '';
  MyTitle := '';
  MyAdminLevel := 0;
  MyNotes := '';
  FMyRatingInfo.Clear;
end;
//______________________________________________________________________________
function TCLSocket.MeEmployed(p_Role: string): Boolean;
begin
  result := InCommaString(lowercase(MyRoles), lowercase(p_Role));
end;
//______________________________________________________________________________
end.

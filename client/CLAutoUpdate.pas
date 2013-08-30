unit CLAutoUpdate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Wininet,
  StdCtrls, ComCtrls;

type
  TFCLAutoUpdate = class(TForm)
    PB1: TProgressBar;
    lbl1: TLabel;
    btnUpdate: TButton;
    btnSkip: TButton;
    procedure btnUpdateClick(Sender: TObject);
    procedure btnSkipClick(Sender: TObject);
  private
    { Private declarations }
    DownloadStarted: Boolean;
    function GetInetFile(const fileURL, FileName: String): boolean;
  public
    { Public declarations }
    URL: string;
    function DownloadUpdate(url: string): Boolean;
  end;

var
  FCLAutoUpdate: TFCLAutoUpdate;

implementation

{$R *.DFM}

uses CLConst, CLMain;

{ TFCLAutoUpdate }
//================================================================
function CreateProcessSimple(
  sExecutableFilePath : string )
    : string;
var
  pi: TProcessInformation;
  si: TStartupInfo;
begin
  FillMemory( @si, sizeof( si ), 0 );
  si.cb := sizeof( si );

  CreateProcess(
    Nil,

    // path to the executable file:
    PChar( sExecutableFilePath ),

    Nil, Nil, False,
    NORMAL_PRIORITY_CLASS, Nil, Nil,
    si, pi );

  // "after calling code" such as
  // the code to wait until the
  // process is done should go here

  CloseHandle( pi.hProcess );
  CloseHandle( pi.hThread );
end;
//============================================================================
function TFCLAutoUpdate.DownloadUpdate(url: string): Boolean;
begin
  result := GetInetFile(url, AUTOUPDATE_FILE_NAME);
end;
//============================================================================
function TFCLAutoUpdate.GetInetFile(const fileURL, FileName: String): boolean;
const
  BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: File;
  sAppName: string;
  FullLength: integer;
begin
   Result:=False;
   sAppName := ExtractFileName(Application.ExeName);
   hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG,
         nil, nil, 0);
   try
      hURL := InternetOpenURL(hSession,
      PChar(fileURL),nil,0,0,0);
      FullLength := 0;
      try
         AssignFile(f, FileName);
         Rewrite(f,1);
         repeat
            InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
            BlockWrite(f, Buffer, BufferLen);
            FullLength := FullLength + BufferLen;
            PB1.Position := FullLength;
            Refresh;
            Application.ProcessMessages;
         until BufferLen = 0;
         CloseFile(f);
         PB1.Position := PB1.Max;
         Result:=True;
      finally
      InternetCloseHandle(hURL)
      end
   finally
   InternetCloseHandle(hSession)
   end
end;
//================================================================
procedure TFCLAutoUpdate.btnUpdateClick(Sender: TObject);
begin
  if DownloadStarted then exit;
  DownloadStarted := true;
  if DownloadUpdate(URL) then begin
    CreateProcessSimple(AUTOUPDATE_FILE_NAME);
    //fCLMain.CloseAndExit;
    Application.Terminate;
  end else begin
    lbl1.Caption := 'Download is not complete, update cancelled.'+#13#10+'Try it next time';
    lbl1.Font.Color := clRed;
    ModalResult := mrCancel;
  end;
end;
//================================================================
procedure TFCLAutoUpdate.btnSkipClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;
//================================================================
end.

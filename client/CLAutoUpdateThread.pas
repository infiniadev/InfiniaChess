unit CLAutoUpdateThread;

interface

uses
  Classes, WinInet, Windows, forms, sysutils;

type
  TAutoUpdateThread = class(TThread)
  private
    { Private declarations }
    function GetInetFile(const fileURL, p_FileName: String): boolean;
  protected
    procedure Execute; override;
  public
    URL: string;
    FileName: string;
  end;

implementation

//==============================================================================
{ TAutoUpdateThread }

procedure TAutoUpdateThread.Execute;
var
  TempFileName: string;
begin
  TempFileName := FileName + '.tmp';
  if GetInetFile(URL, TempFileName) then
    RenameFile(TempFileName, FileName);
end;
//==============================================================================
function TAutoUpdateThread.GetInetFile(const fileURL, p_FileName: String): boolean;
const
  BufferSize = 1024;
var
  hSession, hURL: HInternet;
  Buffer: array[1..BufferSize] of Byte;
  BufferLen: DWORD;
  f: File;
  sAppName: string;
  FullLength, size: integer;
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
         AssignFile(f, p_FileName);
         Rewrite(f,1);
         size := 0;
         repeat
            InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
            BlockWrite(f, Buffer, BufferLen);
            FullLength := FullLength + BufferLen;
            Application.ProcessMessages;
            size := size + BufferLen;
         until BufferLen = 0;
         CloseFile(f);
         Result := size > 1000000;
      finally
      InternetCloseHandle(hURL)
      end
   finally
   InternetCloseHandle(hSession)
   end
end;
//==============================================================================
end.

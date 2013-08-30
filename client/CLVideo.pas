unit CLVideo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DSPack, DSUtil, DirectShow9, Buttons;

type
  TfCLVideo = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    chkBroadCast: TCheckBox;
    VideoWindow: TVideoWindow;
    FilterGraph: TFilterGraph;
    FilterSource: TFilter;
    FilterDivX: TFilter;
    btnPlay: TBitBtn;
    SampleGrabber: TSampleGrabber;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    ASFWriter: TASFWriter;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    NFile: integer;
    MainAviName: string;
    procedure CreateNextFile;
  public
    { Public declarations }
  end;

var
  fCLVideo: TfCLVideo;

implementation

uses CLSocket, CLSocket2, CLLib, CLGlobal, CLConst;

{$R *.DFM}
//=============================================================================
procedure TfCLVideo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;
//=============================================================================
procedure TfCLVideo.FormCreate(Sender: TObject);
begin
  Caption:=GetNameWithTitle(fCLSocket.MyName,fCLSocket.MyTitle);
  CreateDirectoryTree(MAIN_DIR+TEMP_AVI_DIR);
  MainAviName:=MAIN_DIR+TEMP_AVI_DIR+'!!!.avi';
  ClearDirectory(MAIN_DIR+TEMP_AVI_DIR,'avi');
  {if FileExists(MainAviName) then
    DeleteFile(MainAviName);}
end;
//=============================================================================
procedure TfCLVideo.btnPlayClick(Sender: TObject);
var
  SysDev: TSysDevEnum;
  SourceFilter,DivXFilter,WindowFilter,SampleFilter,FileFilter,ASFFilter: IBaseFilter;
  CaptureGraph: ICaptureGraphBuilder2;
  FileSink: IFileSinkFilter;
  MNumber: integer;
begin
  try
    SysDev:=TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);
    MNumber := MonikerNumber(SysDev, fGL.VideoInputDevice);
    if MNumber = -1 then begin
      MessageDlg(MSG_VIDEO_DEVICE_NOT_DEFINED,mtInformation,[mbOk],0);
      exit;
    end;
    FilterGraph.ClearGraph;
    FilterGraph.Active:=false;
    FilterSource.BaseFilter.Moniker:=SysDev.GetMoniker(MNumber);
    FilterGraph.Active:=true;
    FilterGraph.QueryInterface(ICaptureGraphBuilder2, CaptureGraph);
    FilterSource.QueryInterface(IBaseFilter, SourceFilter);
    ASFWriter.QueryInterface(IBaseFilter, ASFFilter);
    VideoWindow.QueryInterface(IBaseFilter,WindowFilter);

    with CaptureGraph as ICaptureGraphBuilder2 do begin
      CheckDSError(RenderStream(@PIN_CATEGORY_CAPTURE , nil, SourceFilter, nil, ASFFilter));
      CheckDSError(RenderStream(@PIN_CATEGORY_PREVIEW , nil, SourceFilter, nil, WindowFilter));
    end;

    {FilterGraph.QueryInterface(ICaptureGraphBuilder2, CaptureGraph);
    FilterSource.QueryInterface(IBaseFilter, SourceFilter);

    //SampleGrabber.QueryInterface(IBaseFilter,SampleFilter);

    //VideoWindow.QueryInterface(IBaseFilter,WindowFilter);

    if chkBroadCast.Checked then begin
      FilterDivX.QueryInterface(IBaseFilter, DivXFilter);
      //ShowFilterPropertyPage(Self.Handle, DivXFilter, ppVFWCompConfig);
      CaptureGraph.SetOutputFileName(MEDIASUBTYPE_Avi,StringToOLEStr(MainAviName),FileFilter,FileSink);
      CaptureGraph.RenderStream(@PIN_CATEGORY_CAPTURE,nil,SourceFilter,DivXFilter,FileFilter);
    end;
    //CaptureGraph.RenderStream(@PIN_CATEGORY_PREVIEW,nil,SourceFilter,nil,WindowFilter);}


    FilterGraph.Play;
    CaptureGraph:=nil;
    SourceFilter:=nil;
    DivXFilter:=nil;
    WindowFilter:=nil;
    FileFilter:=nil;
    FileSink:=nil;
  except
    on E:Exception do
      showmessage(E.Message);
  end;
end;
//=============================================================================
procedure TfCLVideo.BitBtn1Click(Sender: TObject);
begin
  //FilterGraph.Active:=false;
  Timer1.Enabled:=true;
  //ASFWriter-.FileName:='d:\tmp1.asf';

  {FilterGraph.Stop;
  CreateNextFile;
  FilterGraph.Play;}
  //Timer1.Enabled:=not Timer1.Enabled;
end;
//=============================================================================
procedure TfCLVideo.Timer1Timer(Sender: TObject);
begin
  FilterGraph.Pause;
  exit;
  if FilterGraph.Active then begin
    FilterGraph.Stop;
    CreateNextFile;
    FilterGraph.Play;
  end;
end;
//=============================================================================
procedure TfCLVideo.CreateNextFile;
var
  FileName: string;
  f: file of byte;
  size: integer;
begin
  if not FileExists(MainAviName) then exit;
  FileName:=MAIN_DIR+TEMP_AVI_DIR+lpad(IntToStr(NFile),8,'0')+'.avi';
  AssignFile(f,MainAviName);
  Reset(f);
  size:=FileSize(f);
  CloseFile(f);
  if size<=65536 then DeleteFile(MainAviName)
  else begin
    RenameFile(MainAviName,FileName);
    inc(NFile);
  end;
end;
//=============================================================================
end.

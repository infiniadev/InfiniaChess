unit CLCLubOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, Jpeg;

type
  TfCLCLubOptions = class(TForm)
    PageControl1: TPageControl;
    btnOK: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    reInformation: TRichEdit;
    Panel10: TPanel;
    Label26: TLabel;
    btnPhoto: TBitBtn;
    pnlPhoto: TPanel;
    imgPhoto: TImage;
    Label1: TLabel;
    edtClubName: TEdit;
    chkRequests: TCheckBox;
    odPhoto: TOpenDialog;
    Label2: TLabel;
    edtSponsor: TEdit;
    procedure btnPhotoClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure ControlChanged(Sender: TObject);
    procedure reInformationChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    InfoChanged: Boolean;
    PhotoChanged: Boolean;
    procedure SendPhoto;
  public
    { Public declarations }
    ClubId: integer;
  end;

var
  fCLCLubOptions: TfCLCLubOptions;

implementation

uses CLLib, CLGlobal, CLSocket, CLConst;

{$R *.DFM}
//============================================================================
procedure TfCLCLubOptions.btnPhotoClick(Sender: TObject);
var
  st: TStringStream;
  s, ext: string;
  bmp: TBitMap;
  jpg: TJpegImage;
begin
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
  PhotoChanged:=true;
  ControlChanged(Sender);
end;
//============================================================================
procedure TfCLCLubOptions.btnApplyClick(Sender: TObject);
var
  s: string;
  n: integer;
begin
  if InfoChanged then begin
    s:=reInformation.Lines.Text;
    repeat
      n:=pos(#13#10,s);
      if n>0 then
        s:=copy(s,1,n-1)+'|'+copy(s,n+2,length(s));
    until n=0;
    fCLSocket.InitialSend([CMD_STR_CLUBINFO,IntToStr(ClubId),s]);
    InfoChanged:=false;
  end;

  if PhotoChanged then begin
    SendPhoto;
    PhotoChanged:=false;
  end;

  fCLSocket.InitialSend([CMD_STR_CLUBOPTIONS,IntToStr(ClubId),
    BoolTo_(chkRequests.Checked,'1','0'),
    Replace(edtSponsor.Text, ' ', '_')]);
  btnApply.Enabled:=false;
end;
//============================================================================
procedure TfCLCLubOptions.ControlChanged(Sender: TObject);
begin
  btnApply.Enabled:=true;
end;
//============================================================================
procedure TfCLCLubOptions.reInformationChange(Sender: TObject);
begin
  InfoChanged:=true;
  ControlChanged(Sender);
end;
//============================================================================
procedure TfCLCLubOptions.SendPhoto;
var
  s: string;
begin
  if not imgPhoto.Visible then
    fCLSocket.InitialSend([CMD_STR_PHOTO_SEND,'0','jpg','-',IntToStr(ClubId)])
  else begin
    s:=BitMapToANSIString(imgPhoto.Picture.Bitmap);
    fCLSocket.InitialSend([CMD_STR_PHOTO_SEND,'0','jpg',s,IntToStr(ClubId)])
  end;
end;
//============================================================================
procedure TfCLCLubOptions.FormCreate(Sender: TObject);
begin
  InfoChanged:=false;
  PhotoChanged:=false;
end;
//============================================================================
procedure TfCLCLubOptions.btnOKClick(Sender: TObject);
begin
  if btnApply.Enabled then btnApply.Click;
  ModalResult := mrOk;
end;
//============================================================================
end.

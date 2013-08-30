unit CLStat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Buttons;

type
  TfCLStat = class(TForm)
    pg: TPageControl;
    tsQuery: TTabSheet;
    tsResult: TTabSheet;
    pnlHead: TPanel;
    lvRes: TListView;
    Panel1: TPanel;
    lblDateFrom: TLabel;
    dateFrom: TDateTimePicker;
    lblDateTo: TLabel;
    dateTo: TDateTimePicker;
    lblStrParam: TLabel;
    edStrParam: TRichEdit;
    SpeedButton1: TSpeedButton;
    chkPaidOnly: TCheckBox;
    Panel3: TPanel;
    btnGetStat: TSpeedButton;
    lvTypes: TListView;
    reDescription: TRichEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnGetStatClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure lvTypesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lvTypesDrawItem(Sender: TCustomListView; Item: TListItem;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Private declarations }
    FComments: TStringList;
    FParams: TStringList;
    FParamNames: TStringList;
  public
    { Public declarations }
    procedure CMD_StatTypeBegin(Datapack: TStrings);
    procedure CMD_StatType(Datapack: TStrings);
    procedure CMD_StatTypeEnd(Datapack: TStrings);
    procedure CMD_StatBegin(Datapack: TStrings);
    procedure CMD_Stat(Datapack: TStrings);
    procedure CMD_StatEnd(Datapack: TStrings);
    procedure SetParamNames(Params,ParamNames: string);
  end;

var
  fCLStat: TfCLStat;

implementation

uses CLSocket, CLConst, CLLib;

{$R *.DFM}
//==========================================================================
procedure TfCLStat.CMD_StatTypeBegin(Datapack: TStrings);
begin
  FComments.Clear;
  FParams.Clear;
  FParamNames.Clear;
  lvTypes.Items.Clear;
end;
//==========================================================================
procedure TfCLStat.CMD_StatType(Datapack: TStrings);
var
  itm: TListItem;
begin
  if Datapack.Count<5 then exit;
  itm := lvTypes.Items.Add;
  itm.Caption := Datapack[1];
  itm.SubItems.Add(IntToStr(lvTypes.Items.Count));

  FComments.Add(Datapack[2]);
  FParams.Add(Datapack[3]);
  FParamNames.Add(Datapack[4]);
end;
//==========================================================================
procedure TfCLStat.FormCreate(Sender: TObject);
begin
  FComments:=TStringList.Create;
  FParams:=TStringList.Create;
  FParamNames:=TStringList.Create;
  dateFrom.DateTime:=Date;
  dateTo.DateTime:=Date;
  pg.ActivePage:=tsQuery;
  tsResult.TabVisible:=false;
  {if cmbType.Items.Count>0 then
    cmbType.ItemIndex:=0;}
end;
//==========================================================================
procedure TfCLStat.CMD_StatTypeEnd(Datapack: TStrings);
begin
  if lvTypes.Items.Count > 0 then
    lvTypes.Items[0].Selected := true;
  lvTypes.OnSelectItem(lvTypes, lvTypes.Items[0], true);
end;
//==========================================================================
procedure TfCLStat.btnGetStatClick(Sender: TObject);
var
  s: string;
  itm: TListItem;
begin
  if lvTypes.Items.Count = 0 then exit;

  if edStrParam.Text = '' then s:='%'
  else s:=edStrParam.Text;

  itm := lvTypes.Selected;

  fCLSocket.InitialSend([CMD_STR_STAT,itm.SubItems[0],
    FloatToStr(dateFrom.Date), FloatToStr(dateTo.Date), s,
    BoolTo_(chkPaidOnly.Checked, '1', '0')]);
end;
//==========================================================================
procedure TfCLStat.CMD_StatBegin(Datapack: TStrings);
var
  sName,sHeaders: string;
  slHeaders: TStringList;
  i: integer;
  col: TListColumn;
begin
  if Datapack.Count<3 then exit;
  sName:=Datapack[1];
  sHeaders:=Datapack[2];
  slHeaders:=TStringList.Create;
  Str2StringList(sHeaders,slHeaders);

  pnlHead.Caption:=sName;
  lvRes.Items.Clear;
  lvRes.Columns.Clear;

  for i:=0 to slHeaders.Count-1 do begin
    col:=lvRes.Columns.Add;
    col.Caption:=slHeaders[i];
    col.AutoSize:=true;
  end;

  slHeaders.Free;
end;
//==========================================================================
procedure TfCLStat.CMD_Stat(Datapack: TStrings);
var
  i: integer;
  itm: TListItem;
begin
  if Datapack.Count<2 then exit;
  itm:=lvRes.Items.Add;
  itm.Caption:=Datapack[1];
  for i:=2 to Datapack.Count-1 do
    itm.SubItems.Add(Datapack[i]);
end;
//==========================================================================
procedure TfCLStat.CMD_StatEnd(Datapack: TStrings);
begin
  Self.Show;
  tsResult.TabVisible:=true;
  pg.ActivePage:=tsResult;
end;
//==========================================================================
procedure TfCLStat.SetParamNames(Params, ParamNames: string);
var
  sl: TStringList;
begin
  sl:=TStringList.Create;
  try
    Str2StringList(ParamNames,sl,';');
    lblDateFrom.Visible := params[1] = '1';
    DateFrom.Visible := params[1] = '1';
    lblDateTo.Visible := params[2] = '1';
    DateTo.Visible := params[2] = '1';
    lblStrParam.Visible := params[3] = '1';
    edStrParam.Visible := params[3] = '1';
    chkPaidOnly.Visible := params[4] = '1';

    if sl.Count > 0 then lblDateFrom.Caption := sl[0]
    else lblDateFrom.Caption := 'From';

    if sl.Count > 1 then lblDateTo.Caption := sl[1]
    else lblDateTo.Caption := 'To';

    if sl.Count > 2 then lblStrParam.Caption := sl[2]
    else lblStrParam.Caption := '';

    if sl.Count > 3 then chkPaidOnly.Caption := sl[3]
    else chkPaidOnly.Caption := '';
  finally
    sl.Free;
  end;
end;
//==========================================================================
procedure TfCLStat.SpeedButton1Click(Sender: TObject);
begin
  PutListViewToExcel(lvRes, pnlHead.Caption);
end;
//==========================================================================
procedure TfCLStat.lvTypesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  StatID: integer;
begin
  if Item = nil then begin
    lvTypes.Hint:='';
    exit;
  end;

  StatID := StrToInt(Item.SubItems[0]);

  lvTypes.Hint:=FComments[StatID];
  reDescription.Lines.Text := lvTypes.Hint;
  SetParamNames(FParams[StatID],FParamNames[StatID]);
end;
//==========================================================================
procedure TfCLStat.lvTypesDrawItem(Sender: TCustomListView; Item: TListItem; Rect: TRect; State: TOwnerDrawState);
begin
  if odSelected in State then begin
    Sender.Canvas.Brush.Color := clBlue;
    Sender.Canvas.Font.Color := clWhite;
  end else begin
    Sender.Canvas.Brush.Color := clWhite;
    Sender.Canvas.Font.Color := clBlack;
  end;

  Sender.Canvas.FillRect(Rect);
  Sender.Canvas.Font.Name := 'Arial';
  Sender.Canvas.Font.Size := 8;


  Sender.Canvas.TextOut(Rect.Left+4, Rect.Top, Item.Caption);
end;
//==========================================================================
end.

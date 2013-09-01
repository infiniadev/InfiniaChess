{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLMediaPlayer;

interface

uses MPlayer,classes,FileCtrl,SysUtils, forms, dialogs;

type
  TCLMPlayerThread = class(TThread)
  private
    frm: TForm;
    Player: TMediaPlayer;
    procedure PlayAll;
  public
    //slMP3List: TStringList;
    procedure Init;
    destructor Destroy; override;
    procedure Execute; override;
  end;


  TCLMediaPlayer = class(TMediaPlayer)
  private
    slMP3List: TStringList;
    procedure NotifyPlayer(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddFile(filename: string);
    procedure PlayNextFileIfNeed;
  end;

var
  slMP3List: TStringList;

implementation

uses CLMain;

procedure Log(Str: string);
var
  F: TextFile;
  filename: string;
begin
  if DebugHook = 0 then exit;
  filename:='c:\!.log';
  AssignFile(F,filename);
  if FileExists(filename) then Append(F)
  else rewrite(F);
  writeln(F,Str);
  CloseFile(F);
end;

{ TCLMediaPlayer }

procedure TCLMediaPlayer.AddFile(filename: string);
begin
  //log('AddFile('+filename+')');
  //slMP3List.Add(filename);
  //if slMP3List.Count=1 then PlayNextFileIfNeed;
end;
//==============================================================================
constructor TCLMediaPlayer.Create(AOwner: TComponent);
begin
  inherited;
  //Parent:=AOwner;
  Visible:=false;
  slMP3List:=TStringList.Create;
  OnNotify:=NotifyPlayer;
end;
//==============================================================================
destructor TCLMediaPlayer.Destroy;
begin
  inherited;
  slMP3List.Free;
end;
//==============================================================================
procedure TCLMediaPlayer.NotifyPlayer(Sender: TObject);
begin
  log('NotifyPlayer');
  if slMP3List.Count>0 then
    slMP3List.Delete(0);
  Close;
  PlayNextFileIfNeed;
end;
//==============================================================================
procedure TCLMediaPlayer.PlayNextFileIfNeed;
begin
  log('PlayNextFileIfNeed');
  if (Mode=mpPlaying) or (slMP3List.Count=0) then exit;
  FileName:=slMP3List[0];
  log('... filename='+filename);
  Notify:=false;
  Close;
  Open;
  Notify:=true;
  //Wait:=true;
  Play;
  {if slMP3List.Count>0 then
    slMP3List.Delete(0);}
end;

{ TCLMPlayerThread }

destructor TCLMPlayerThread.Destroy;
begin
  inherited;
  //slMP3List.Free;
  player.Free;
  frm.Free;
end;
//==============================================================================
procedure TCLMPlayerThread.Execute;
var
  i,n,k: integer;
begin
  exit;
  Init;
  PlayAll;
end;
//==============================================================================
procedure TCLMPlayerThread.Init;
begin
  frm:=TForm.Create(Application);
  frm.Visible:=false;
  player:=TMediaPlayer.Create(frm);
  player.Parent:=frm;
  player.Shareable:=false;
  //slMP3List:=TStringList.Create;
  FreeOnTerminate:=true;
end;
//==============================================================================
procedure TCLMPlayerThread.PlayAll;
var
  i: integer;
begin
  while slMP3List.Count>0 do begin
    Player.FileName:=slMP3List[0];
    Player.Close;
    Player.Open;
    Player.Wait:=true;
    Player.Play;
    DeleteFile(slMP3List[0]);
    slMP3List.Delete(0);
  end;
end;
//==============================================================================
end.

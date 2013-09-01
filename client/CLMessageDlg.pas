{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Perpetual Chess LLC                             }
{       Copyright (c) 1995-2013                         }
{                                                       }
{*******************************************************}

unit CLMessageDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, Buttons, ExtCtrls, Dialogs;

type
  TMessageForm = class(TForm)
  private
  protected
      procedure ButtonClick(Sender: TObject);
  public
    constructor CreateNew(AOwner: TComponent); reintroduce;
  end;

function MessageDlgExt(const Msg: string; DlgType: TMsgDlgType;
  ButtonCaptions: array of string; DefaultButton : integer=1): Integer;
{
  Msg - Мессага
  DlgType - тип диалога (mtWarning, mtError, mtInformation, mtConfirmation, mtCustom);
  ButtonCaptions - массив названий кнопок
  DefaultButton - княпка по умолчанию
  Результат - номер нажатой кнопки или
              -1 если никакая не нажата
  Пример:
  MessageDlgExt('Пива ?', mtConfirmation, ['Да !','Конечно !','Само собой!','Уже...'],2);
}
var
  Captions: array[TMsgDlgType] of PChar = ('Предостережение', 'Ошибка', 'Информация',
     'Подтверждение', nil);

  IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
    IDI_ASTERISK, IDI_QUESTION, nil);

implementation

uses CLMain;

constructor TMessageForm.CreateNew(AOwner: TComponent);
var
  NonClientMetrics: TNonClientMetrics;
begin
  inherited CreateNew(AOwner);
  NonClientMetrics.cbSize := sizeof(NonClientMetrics);
  if SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0) then
    Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);
end;

procedure TMessageForm.ButtonClick(Sender: TObject);
begin
  Tag := (Sender as TButton).Tag;
  Close;
end;

function Max(I, J: Integer): Integer;
begin
  if I > J then Result := I else Result := J;
end;

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function MessageDlgExt(const Msg: string; DlgType: TMsgDlgType;
  ButtonCaptions: array of string; DefaultButton : integer=1): integer;
const
  mcHorzMargin = 8;
  mcVertMargin = 8;
  mcHorzSpacing = 15;
  mcVertSpacing = 15;
  mcButtonWidth = 60;
  mcButtonHeight = 14;
  mcButtonSpacing = 4;
var
  DialogUnits: TPoint;
  HorzMargin, VertMargin, HorzSpacing, VertSpacing, ButtonWidth,
  ButtonHeight, ButtonSpacing, ButtonCount, ButtonGroupWidth,
  IconTextWidth, IconTextHeight, X, ALeft: Integer;
  IconID: PChar;
  TextRect: TRect;
  i : integer;
  ButtonWidths : array of integer;
  ResForm : TMessageForm;
  TempButton : TButton;
begin
  ButtonCount := Round(SizeOf(ButtonCaptions)/SizeOf(String));
  SetLength(ButtonWidths, ButtonCount);
  ResForm := TMessageForm.CreateNew(Application);
  try
  with ResForm do
  begin
    BiDiMode := Application.BiDiMode;
    BorderStyle := bsDialog;
    Canvas.Font := Font;
    DialogUnits := GetAveCharSize(Canvas);
    HorzMargin := MulDiv(mcHorzMargin, DialogUnits.X, 4);
    VertMargin := MulDiv(mcVertMargin, DialogUnits.Y, 8);
    HorzSpacing := MulDiv(mcHorzSpacing, DialogUnits.X, 4);
    VertSpacing := MulDiv(mcVertSpacing, DialogUnits.Y, 8);
    ButtonWidth := MulDiv(mcButtonWidth, DialogUnits.X, 4);
    Position := poScreenCenter;
    Tag := -1;
    for i:= 0 to ButtonCount-1 do
    begin
      if ButtonWidths[i] = 0 then
      begin
        TextRect := Rect(0,0,0,0);
        Windows.DrawText( canvas.handle,
          PChar(ButtonCaptions[i]), -1,
          TextRect, DT_CALCRECT or DT_LEFT or DT_SINGLELINE or
          DrawTextBiDiModeFlagsReadingOnly);
        with TextRect do ButtonWidths[i] := Right - Left + 8;
      end;
      if ButtonWidths[i] > ButtonWidth then
        ButtonWidth := ButtonWidths[i];
    end;
    ButtonHeight := MulDiv(mcButtonHeight, DialogUnits.Y, 8);
    ButtonSpacing := MulDiv(mcButtonSpacing, DialogUnits.X, 4);
    SetRect(TextRect, 0, 0, Screen.Width div 2, 0);
    DrawText(Canvas.Handle, PChar(Msg), Length(Msg)+1, TextRect,
      DT_EXPANDTABS or DT_CALCRECT or DT_WORDBREAK or
      DrawTextBiDiModeFlagsReadingOnly);
    IconID := IconIDs[DlgType];
    IconTextWidth := TextRect.Right;
    IconTextHeight := TextRect.Bottom;
    if IconID <> nil then
    begin
      Inc(IconTextWidth, 32 + HorzSpacing);
      if IconTextHeight < 32 then IconTextHeight := 32;
    end;
    ButtonGroupWidth := 0;
    if ButtonCount <> 0 then
      ButtonGroupWidth := ButtonWidth * ButtonCount +
        ButtonSpacing * (ButtonCount - 1);
    ClientWidth := Max(IconTextWidth, ButtonGroupWidth) + HorzMargin * 2;
    ClientHeight := IconTextHeight + ButtonHeight + VertSpacing +
      VertMargin * 2;
    Left := (Screen.Width div 2) - (Width div 2);
    Top := (Screen.Height div 2) - (Height div 2);
    if DlgType <> mtCustom then
      Caption := Captions[DlgType] else
      Caption := Application.Title;
    if IconID <> nil then
      with TImage.Create(ResForm) do
      begin
        Name := 'Image';
        Parent := ResForm;
        Picture.Icon.Handle := LoadIcon(0, IconID);
        SetBounds(HorzMargin, VertMargin, 32, 32);
      end;
    with TLabel.Create(ResForm) do
    begin
      Name := 'Message';
      Parent := ResForm;
      WordWrap := True;
      Caption := Msg;
      BoundsRect := TextRect;
      BiDiMode := ResForm.BiDiMode;
      ALeft := IconTextWidth - TextRect.Right + HorzMargin;
      if UseRightToLeftAlignment then
        ALeft := ResForm.ClientWidth - ALeft - Width;
      SetBounds(ALeft, VertMargin,
        TextRect.Right, TextRect.Bottom);
    end;
    X := (ClientWidth - ButtonGroupWidth) div 2;
    for i:= 0 to ButtonCount - 1 do
    Begin
      TempButton := TButton.Create(ResForm);
      with TempButton do
      begin
        Name := 'MsgBtn'+IntToStr(i);
        Parent := ResForm;
        Caption := ButtonCaptions[i];
        Tag := i+1;
        OnClick := ResForm.ButtonClick;

        if i+1 = DefaultButton then
          ResForm.ActiveControl := TempButton;

        SetBounds(X, IconTextHeight + VertMargin + VertSpacing,
          ButtonWidth, ButtonHeight);
        Inc(X, ButtonWidth + ButtonSpacing);
      end;
    end;
    ResForm.ShowModal;
  end;
  Result := ResForm.Tag;
  finally
    ResForm.Free;
  end;
end;

end.

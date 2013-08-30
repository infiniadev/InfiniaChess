{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLPgn;

interface

uses
  classes, SysUtils, CLGame;

type
  TPGNMode = (pmRead, pmWrite);

  TCLPgn = class(TObject)
    private
      { Private declarations }
      FEOPF: Boolean;
      FEOPM: Boolean;
      FFile: TextFile;
      FLineNo: Integer;
      FGameLoc: Integer;
      FGameNo: Integer;
      FMoveMaster: string;
      FMoveSlave: string;
      FPGN: string;
      FPly: Integer;
      FTags: string;

      procedure ClearWhiteSpace(var Data: string);

    public
      { Public declarations }
      constructor Create(const PGNFile: string; Mode: TPGNMode);
      destructor Destroy; override;

      class function ValidFEN(const Value: string): Boolean;
      
      function Tag(const TagName: string): string;

      procedure FirstMove;
      procedure LogGame(const Game: TCLGame);
      procedure MoveFirst;
      procedure MoveNext;
      procedure NextMove;
      procedure Seek(const Position: Integer);

      property EOPF: Boolean read FEOPF;
      property EOPM: Boolean read FEOPM;
      property GameLoc: Integer read FGameLoc;
      property GameNo: Integer read FGameNo;
      property PGN: string read FPGN;
      property Ply: Integer read FPly;

  end;

implementation

uses CLConst;
//______________________________________________________________________________
class function TCLPgn.ValidFEN(const Value: string): Boolean;
var
  Index, Section, Total: Integer;
  FEN: TStringList;
label CleanUp;
begin
  { Checks the FORMAT of a FEN string. Not the legitimacy of caslte rights,
    etc..}
    
  { Must prove true }
  Result := False;

  { Break apart the FEN string }
  FEN := TStringList.Create;
  FEN.CommaText := Value;

  { FEN must contain six sections }
  if FEN.Count <> 6 then goto CleanUp;

  Section := 0;
  Total := 0;
  { Examine the first paramter. Each subsection must total 8. The whole section
  must total 64.}
  for Index := 1 to Length(FEN[0]) do
    begin
      case FEN[0][Index] of
        'K', 'Q', 'B', 'N', 'R', 'P', 'k', 'q', 'b', 'n', 'r', 'p': Inc(Section);
        '/': if Section = 8 then Section := 0 else goto CleanUp;
        '1'..'8': Section := Section + StrToInt(Value[Index]);
      else
        { Invalid character }
        goto CleanUp;
      end; { Case Of }
      Inc(Total);
      if (Section > 8) or (Total > 64) then goto CleanUp;
    end;
  if Section < 8 then goto CleanUp;

  { Color }
  case FEN[1][1] of
    'w', 'b': { Correct. Do Nothing };
  else
    goto CleanUp;
  end;

  { Castle rights }
  for Index := 1 to Length(FEN[2]) -1 do
    case FEN[2][Index] of
      'K', 'Q', 'k', 'q', '-': { Correct. Do Noting };
    else
      goto CleanUp;
    end;

  { Enpassent }
  case Length(FEN[3]) of
    1: if FEN[3][1] <> '-' then goto CleanUp;
    2: if not (FEN[3][1] in ['a'..'h']) or not (FEN[3][2] in ['3', '6']) then
        goto CleanUp;
  else
    goto CleanUp;
  end;

  { Repeatable move count, do nothing }
  Val(FEN[4][1], Total, Index);
  if Index <> 0 then goto CleanUp;

  { Full move number, do nothing }
  Val(FEN[5][1], Total, Index);
  if Index <> 0 then goto CleanUp;

  Result := True;

CleanUp:
  if Assigned(FEN) then
    begin
      FEN.Clear;
      FEN.Free;
    end;
end;
//______________________________________________________________________________
constructor TCLPgn.Create(const PGNFile: string; Mode: TPGNMode);
begin
  //if NO_IO then exit;
  FEOPF := True;
  AssignFile(FFile, PGNFile);
  case Mode of
    pmWrite: if FileExists(PGNFile) then Append(FFile) else ReWrite(FFile);
    pmRead: if FileExists(PGNFile) then Seek(0);
  end;
end;
//______________________________________________________________________________
destructor TCLPgn.Destroy;
begin
  //if NO_IO then exit;
  {$I-}
   CloseFile(FFile);
   IOResult;
  {$I+}
end;
//______________________________________________________________________________
procedure TCLPgn.ClearWhiteSpace(var Data: string);
var
  Pos1: Integer;
begin
  { Convert Tabs to Spaces }
  Pos1 := Pos(#9, Data);
    while Pos1 > 0 do
      begin
        Data[Pos1] := #32;
        Pos1 := Pos(#9, Data);
      end;
  { Remove all #32#32 combos. Single #32 Delimiter is desired }
  Pos1 := Pos(#32#32, Data);
  while Pos1 > 0 do
    begin
      Delete(Data, Pos1, 1);
      Pos1 := Pos(#32#32, Data);
    end;
end;
//______________________________________________________________________________
function TCLPgn.Tag(const TagName: string): string;
var
  Pos1, Pos2: Integer;
begin
  Result := '';
  Pos1 := Pos('[' + TagName, LowerCase(FTags));
  if Pos1 > 0 then
    begin
      { Put the TagName at the beginning of the Result }
      Result := Copy(FTags, Pos1, Length(FTags));

      Pos2 := Pos(']', Result);
      if Pos2 > 0 then
        begin
          Pos1 := Length(TagName) + 2;
          Result := Copy(Result, Pos1 , Pos2 - Pos1);

          if Pos(#32, Result) = 1 then Delete(Result, 1, 1);
          if Pos('"', Result) = 1 then Delete(Result, 1, 1);
          Pos1 := Length(Result);
          if Pos1 > 0 then if Result[Pos1] = '"' then Delete(Result, Pos1, 1);
          Result := Trim(Result);
        end;
    end;
end;
//______________________________________________________________________________
procedure TCLPgn.FirstMove;
var
  Data: string;
  Pos1: Integer;

procedure StripComments(OpenChar, CloseChar: Char; var PGN: string); var
  PrevPGN: string;
  Pos1, Pos2, Min: Integer;
begin
  PrevPGN := PGN;
  Pos1 := Pos(OpenChar, PGN);
  Pos2 := Pos(CloseChar, PGN);
  Min := -1;

  while Pos1 + Pos2 > 0 do
    begin
      if (Pos1 = 0) or ((Pos1 > Pos2) and (Pos2 > 0)) then Pos1 := 1;
      if (Pos2 = 0) then Pos2 := Length(PGN);

      if Pos1 < Min then Pos1 := Min;
      Delete(PGN, Pos1, Pos2 - Pos1 + 1);
      Min := Pos1;

      Pos1 := Pos(OpenChar, PGN);
      Pos2 := Pos(CloseChar, PGN);

      if PGN = PrevPGN then Break;
      PrevPGN := PGN;
    end;
end;

begin
  FPly := 0;
  if FMoveMaster = '' then
    begin
      while not EOF(FFile) do
        begin
          Inc(FLineNo);
          ReadLn(FFile, Data);
          ClearWhiteSpace(Data);

          if (Data = #32) or (Data = '') or (Pos('[', Data) > 0) then Break;
          if Data[1] = '%' then Continue;

          Pos1 := Pos(';', Data);
          if Pos1 > 0 then Delete(Data, Pos1, Length(Data));

          if not ((Data = #32) or (Data = '')) then
            FMoveMaster := FMoveMaster + #32 + Data;
        end;

      { Clear out the comments }
      StripComments('(', ')', FMoveMaster);
      StripComments('{', '}', FMoveMaster);
      StripComments('<', '>', FMoveMaster);

      { Convert zero-zero-zero to O-O-O }
      while Pos('0-0-0', FMoveMaster) > 0 do
        begin
          Pos1 := Pos('0-0-0', FMoveMaster);
          Insert('O-O-O', FMoveMaster, Pos1);
          Delete(FMoveMaster, Pos1 + 5, 5);
        end;
      { Convert zero-zero to O-O }
      while Pos('0-0', FMoveMaster) > 0 do
        begin
          Pos1 := Pos('0-0', FMoveMaster);
          Insert('O-O', FMoveMaster, Pos1);
          Delete(FMoveMaster, Pos1 + 3, 3);
        end;
    end;
  FMoveSlave := FMoveMaster;
  FEOPM := FMoveSlave = '';
  NextMove;
end;
//______________________________________________________________________________
procedure TCLPgn.LogGame(const Game: TCLGame);
const
  MAX_LEN = 80;
var
  Move: TMove;
  Index, TotalLen: Integer;
  s: string;
begin
  { Seven tag roster plus a few. }
  //if NO_IO then exit;
  WriteLn(FFile, '[Event "' + Game.Event + '"]');
  WriteLn(FFile, '[Site "' + Game.Site + '"]');
  WriteLn(FFile, '[Date "' + Game.Date + '"]');
  WriteLn(FFile, '[Round "' + Game.Round + '"]');
  WriteLn(FFile, '[White "' + Game.WhiteName + '"]');
  WriteLn(FFile, '[Black "' + Game.BlackName + '"]');
  WriteLn(FFile, '[Result "' + Game.GameResult + '"]');
  WriteLn(FFile, '[WhiteCRX "' + Game.WhiteRating + '"]');
  WriteLn(FFile, '[BlackCRX "' + Game.BlackRating + '"]');
  if Game.FEN <> '' then WriteLn(FFile, '[FEN "' + Game.FEN + '"]');
  WriteLn(FFile, '[Termination "' + Game.GameResultDesc + '"]');
  WriteLn(FFile);

  { Write the moves. }
  Index := 1;
  TotalLen := 0;
  while Index < Game.Moves.Count do
    begin
      { Get Whites move. }
      Move := TMove(Game.Moves[Index]);
      s := IntToStr(Index div 2 + 1) + '.' + Move.FPGN;
      Inc(Index);
      { Get Blacks move. }
      if Index < Game.Moves.Count then
        begin
          Move := TMove(Game.Moves[Index]);
          s := s + #32 + Move.FPGN;
          Inc(Index);
        end;

      { Write a EOL if the lenght of the line plus the new move > MAX_LEN. }
      if TotalLen + Length(s) + 1 > MAX_LEN then
        begin
          WriteLn(FFile);
          TotalLen := 0;
        end;
      if TotalLen > 0 then s := #32 + s;
      Write(FFile, s);
      TotalLen := TotalLen + Length(s);
    end;
  { Write the Result }
  s := Game.GameResult;
  if TotalLen + Length(s) + 1 > MAX_LEN then
    begin
      WriteLn(FFile);
      TotalLen := 0;
    end;
  if TotalLen > 0 then s := #32 + s;
  WriteLn(FFile, s);
  WriteLn(FFile);
end;
//______________________________________________________________________________
procedure TCLPgn.MoveFirst;
begin
  Seek(0);
end;
//______________________________________________________________________________
procedure TCLPgn.MoveNext;
var
  Data, TempTags: string;
  Pos1, TagLen: Integer;
  OpenTag: Boolean;
begin
  { Code parses: multiple tags on a line, tags that span lines, tag values with
  or w/o quote marks (note it's tag VALUES and not tag NAMES) and extraneous
  white spaces (#9, #32) }
  FMoveMaster := '';
  FTags := '';
  TempTags := '';
  OpenTag := False;

  while not EOF(FFile) do
    begin
      Inc(FLineNo);
      Readln(FFile, Data);

      if not OpenTag then
        begin
          Pos1 := Pos('[', Data);
        	if Pos1 > 0 then
            begin
              OpenTag := True;
            	Inc(FGameNo);
          		FGameLoc := FLineNo;
        	  end
        end;

      if OpenTag then
        begin
          { Specs allow for white spaces to be #9 and/or #32. Easiest to parse
            when they're all #32 so change them }
          ClearWhiteSpace(Data);

          { Remove all #32']' combos. Single ']' Token is needed  }
          Pos1 := Pos(#32']', FTags);
          while Pos1 > 0 do
            begin
              Delete(FTags, Pos1, 1);
              Pos1 := Pos(#32']', FTags);
            end;

      	  if ((Data = #32) or (Data = '')) and (TempTags = '') then Break;

        	TempTags := TempTags + Data;
          TagLen := Length(TempTags);
          if TempTags[TagLen] = ']' then
            begin
              FTags := FTags + TempTags;
        	  	TempTags := '';
          	end;
          if (TagLen > 255) then Break;
        end;
    end;

  { Remove all '['#32 combos. Single '[' Token is desired }
  Pos1 := Pos('['#32, FTags);
  while Pos1 > 0 do
    begin
      Delete(FTags, Pos1 + 1, 1);
      Pos1 := Pos('['#32, FTags);
    end;
  { Remove all #32'[' combos. Single '[' Token is desired }
  Pos1 := Pos(#32'[', FTags);
  while Pos1 > 0 do
    begin
      Delete(FTags, Pos1, 1);
      Pos1 := Pos(#32'[', FTags);
    end;

  { Remove all #47#47 combos. Single #47 Token is desired }
  Pos1 := Pos('//', FTags);
  while Pos1 > 0 do
    begin
      Delete(FTags, Pos1, 1);
      Pos1 := Pos('//' , FTags);
    end;
  { Remove all #47'"' combos. Single '"' Token is desired }
  Pos1 := Pos('/"', FTags);
  while Pos1 > 0 do
    begin
      Delete(FTags, Pos1, 1);
      Pos1 := Pos('/"' , FTags);
    end;

  //FTags := AnsiLowerCase(FTags);
  { Set the EOF marker for the class }
  FEOPF := SeekEOF(FFile);

end;
//______________________________________________________________________________
procedure TCLPgn.NextMove;
begin
  FPGN := '';
  while Length(FMoveSlave) > 0 do
    begin
      case FMoveSlave[1] of
        'A'..'Z', 'a'..'z':
          FPGN := FPGN + FMoveSlave[1];
        '0'..'9', '-', '+', '#', '=', '@':
          if not (FPGN = '') then FPGN := FPGN + FMoveSlave[1];
        #32: if not (FPGN = '') then Break;
      end;
      Delete(FMoveSlave, 1, 1);
    end;
  FEOPM := FMoveSlave = '';
  Inc(FPly);
end;
//______________________________________________________________________________
procedure TCLPgn.Seek(const Position: Integer);
begin
  FEOPF := False;
  FLineNo := 0;
  FGameNo := 0;
  try
    Reset(FFile);

    while (not EOF(FFile)) and (FLineNo < Position -1) do
      begin
        Inc(FLineNo);
        ReadLn(FFile);
      end;

    MoveNext;
  finally
  end;
end;
//______________________________________________________________________________

end.

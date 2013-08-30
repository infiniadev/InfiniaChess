{*******************************************************}
{                                                       }
{       Chesslink by                                    }
{       Brian Sheeres                                   }
{       Copyright (c) 1995-2001                         }
{                                                       }
{*******************************************************}

unit CLCrypt;

interface

procedure Decrypt (var Data: string; TotalBytes: Integer;
  var DecryptedData: string);
procedure Encrypt(var Data: string);
procedure ReSet;

implementation

uses
  CLConst, CLMain;

const
  { Needs to match CLServer!!! }
  CIPHER_KEY: Word = 26484;
  CIPHER1: Word = 49574;
  CIPHER2: Word = 19756;

var
  FKey: Word;

//______________________________________________________________________________
procedure Decrypt (var Data: string; TotalBytes: Integer;
  var DecryptedData: string);
var
  Index: Integer;
begin
 { Decrypt }
  SetLength(DecryptedData, TotalBytes);
  for Index := 1 to TotalBytes do
    begin
      DecryptedData[Index] := Char(Byte(Data[Index]) xor (FKey shr 8));
      FKey := ((Byte(Data[Index]) + FKey) * CIPHER1 + CIPHER2) mod 65536;
      { Reset the Key }
      if DecryptedData[Index] = DP_END then FKey := CIPHER_KEY;
    end;
end;
//______________________________________________________________________________
procedure Encrypt(var Data: string);
var
  Index: Integer;
  Key: Word;
begin
  { Encrypt. }
  Key := CIPHER_KEY;
  for Index := 1 to Length(Data) do
    begin
      Data[Index] := Char(Byte(Data[Index]) xor (Key shr 8));
      Key := ((Byte(Data[Index]) + Key) * CIPHER1 + CIPHER2) mod 65536;
    end;
end;
//______________________________________________________________________________
procedure Reset;
begin
  FKey := CIPHER_KEY;
end;
//______________________________________________________________________________
end.

// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorlexer.pas' rev: 10.00

#ifndef JclpreprocessorlexerHPP
#define JclpreprocessorlexerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Jclstrhashmap.hpp>	// Pascal unit
#include <Jclstrings.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessorlexer
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TJppToken { ptEof, ptComment, ptText, ptEol, ptDefine, ptUndef, ptIfdef, ptIfndef, ptIfopt, ptElse, ptEndif, ptInclude, ptJppDefineMacro, ptJppExpandMacro, ptJppUndefMacro, ptJppGetStrValue, ptJppGetIntValue, ptJppGetBoolValue, ptJppSetStrValue, ptJppSetIntValue, ptJppSetBoolValue, ptJppLoop, ptJppDefine, ptJppUndef };
#pragma option pop

class DELPHICLASS EJppLexerError;
class PASCALIMPLEMENTATION EJppLexerError : public Jclbase::EJclError 
{
	typedef Jclbase::EJclError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EJppLexerError(const AnsiString Msg) : Jclbase::EJclError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EJppLexerError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Jclbase::EJclError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EJppLexerError(int Ident)/* overload */ : Jclbase::EJclError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EJppLexerError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Jclbase::EJclError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EJppLexerError(const AnsiString Msg, int AHelpContext) : Jclbase::EJclError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EJppLexerError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Jclbase::EJclError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EJppLexerError(int Ident, int AHelpContext)/* overload */ : Jclbase::EJclError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EJppLexerError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Jclbase::EJclError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EJppLexerError(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJppLexer;
class PASCALIMPLEMENTATION TJppLexer : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	AnsiString FBuf;
	Jclstrhashmap::TStringHashMap* FTokenHash;
	char *FCurrPos;
	int FCurrLine;
	TJppToken FCurrTok;
	AnsiString FTokenAsString;
	AnsiString FRawComment;
	bool FIgnoreUnterminatedStrings;
	
public:
	__fastcall TJppLexer(const AnsiString ABuffer, bool AIgnoreUnterminatedStrings);
	__fastcall virtual ~TJppLexer(void);
	void __fastcall Error(const AnsiString AMsg);
	void __fastcall NextTok(void);
	void __fastcall Reset(void);
	__property TJppToken CurrTok = {read=FCurrTok, nodefault};
	__property AnsiString TokenAsString = {read=FTokenAsString};
	__property AnsiString RawComment = {read=FRawComment};
	__property bool IgnoreUnterminatedStrings = {read=FIgnoreUnterminatedStrings, write=FIgnoreUnterminatedStrings, nodefault};
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorlexer */
using namespace Jclpreprocessorlexer;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorlexer

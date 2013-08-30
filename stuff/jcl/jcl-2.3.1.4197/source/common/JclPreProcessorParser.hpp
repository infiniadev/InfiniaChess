// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorparser.pas' rev: 10.00

#ifndef JclpreprocessorparserHPP
#define JclpreprocessorparserHPP

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
#include <Jclcontainerintf.hpp>	// Pascal unit
#include <Jclpreprocessorlexer.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessorparser
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EPppParserError;
class PASCALIMPLEMENTATION EPppParserError : public Jclbase::EJclError 
{
	typedef Jclbase::EJclError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EPppParserError(const AnsiString Msg) : Jclbase::EJclError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EPppParserError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Jclbase::EJclError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EPppParserError(int Ident)/* overload */ : Jclbase::EJclError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EPppParserError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Jclbase::EJclError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EPppParserError(const AnsiString Msg, int AHelpContext) : Jclbase::EJclError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EPppParserError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Jclbase::EJclError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EPppParserError(int Ident, int AHelpContext)/* overload */ : Jclbase::EJclError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EPppParserError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Jclbase::EJclError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EPppParserError(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJppParser;
class DELPHICLASS TPppState;
class DELPHICLASS TPppProvider;
#pragma option push -b-
enum TTriState { ttUnknown, ttUndef, ttDefined };
#pragma option pop

class PASCALIMPLEMENTATION TPppProvider : public Classes::TPersistent 
{
	typedef Classes::TPersistent inherited;
	
protected:
	virtual bool __fastcall GetBoolValue(const AnsiString Name) = 0 ;
	virtual TTriState __fastcall GetDefine(const AnsiString ASymbol) = 0 ;
	virtual int __fastcall GetIntegerValue(const AnsiString Name) = 0 ;
	virtual AnsiString __fastcall GetStringValue(const AnsiString Name) = 0 ;
	virtual void __fastcall SetBoolValue(const AnsiString Name, bool Value) = 0 ;
	virtual void __fastcall SetDefine(const AnsiString ASymbol, const TTriState Value) = 0 ;
	virtual void __fastcall SetIntegerValue(const AnsiString Name, int Value) = 0 ;
	virtual void __fastcall SetStringValue(const AnsiString Name, const AnsiString Value) = 0 ;
	
public:
	__property TTriState Defines[AnsiString ASymbol] = {read=GetDefine, write=SetDefine};
	__property bool BoolValues[AnsiString Name] = {read=GetBoolValue, write=SetBoolValue};
	__property AnsiString StringValues[AnsiString Name] = {read=GetStringValue, write=SetStringValue};
	__property int IntegerValues[AnsiString Name] = {read=GetIntegerValue, write=SetIntegerValue};
public:
	#pragma option push -w-inl
	/* TPersistent.Destroy */ inline __fastcall virtual ~TPppProvider(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TPppProvider(void) : Classes::TPersistent() { }
	#pragma option pop
	
};


#pragma option push -b-
enum TPppOption { poProcessIncludes, poProcessDefines, poStripComments, poProcessMacros, poProcessValues, poNoWarningHeader, poKeepTabAndSpaces, poIgnoreUnterminatedStrings };
#pragma option pop

typedef Set<TPppOption, poProcessIncludes, poIgnoreUnterminatedStrings>  TPppOptions;

typedef TMetaClass* TPppStateItemClass;

class DELPHICLASS TPppStateItem;
class PASCALIMPLEMENTATION TPppState : public TPppProvider 
{
	typedef TPppProvider inherited;
	
private:
	Jclcontainerintf::_di_IJclStack FStateStack;
	TPppOptions FOptions;
	Jclcontainerintf::_di_IJclAnsiStrMap __fastcall InternalPeekDefines();
	Jclcontainerintf::_di_IJclAnsiStrList __fastcall InternalPeekExcludedFiles();
	Jclcontainerintf::_di_IJclAnsiStrIntfMap __fastcall InternalPeekMacros();
	Jclcontainerintf::_di_IJclAnsiStrList __fastcall InternalPeekSearchPath();
	TTriState __fastcall InternalPeekTriState(void);
	void __fastcall InternalSetTriState(TTriState Value);
	
protected:
	#pragma option push -w-inl
	/* virtual class method */ virtual TMetaClass* __fastcall StateItemClass() { return StateItemClass(__classid(TPppState)); }
	#pragma option pop
	/*         class method */ static TMetaClass* __fastcall StateItemClass(TMetaClass* vmt);
	virtual void __fastcall InternalPushState(TPppStateItem* FromStateItem, TPppStateItem* ToStateItem);
	TPppStateItem* __fastcall PeekStateItem(void);
	TPppOptions __fastcall GetOptions(void);
	void __fastcall SetOptions(TPppOptions AOptions);
	Jclcontainerintf::_di_IJclAnsiStrList __fastcall FindMacro(const AnsiString AMacroName);
	Jclbase::TDynWideStringArray __fastcall AssociateParameters(const Jclcontainerintf::_di_IJclAnsiStrList ParamNames, const Jclbase::TDynStringArray ParamValues);
	virtual bool __fastcall GetBoolValue(const AnsiString Name);
	virtual TTriState __fastcall GetDefine(const AnsiString ASymbol);
	virtual int __fastcall GetIntegerValue(const AnsiString Name);
	virtual AnsiString __fastcall GetStringValue(const AnsiString Name);
	virtual void __fastcall SetBoolValue(const AnsiString Name, bool Value);
	virtual void __fastcall SetDefine(const AnsiString ASymbol, const TTriState Value);
	virtual void __fastcall SetIntegerValue(const AnsiString Name, int Value);
	virtual void __fastcall SetStringValue(const AnsiString Name, const AnsiString Value);
	
public:
	__fastcall TPppState(void);
	__fastcall virtual ~TPppState(void);
	virtual void __fastcall AfterConstruction(void);
	void __fastcall PushState(void);
	void __fastcall PopState(void);
	__property TTriState TriState = {read=InternalPeekTriState, write=InternalSetTriState, nodefault};
	void __fastcall Define(const AnsiString ASymbol);
	void __fastcall Undef(const AnsiString ASymbol);
	Classes::TStream* __fastcall FindFile(const AnsiString AName);
	void __fastcall AddToSearchPath(const AnsiString AName);
	void __fastcall AddFileToExclusionList(const AnsiString AName);
	bool __fastcall IsFileExcluded(const AnsiString AName);
	virtual AnsiString __fastcall ExpandMacro(const AnsiString AName, const Jclbase::TDynStringArray ParamValues);
	void __fastcall DefineMacro(const AnsiString AName, const Jclbase::TDynStringArray ParamNames, const AnsiString Value);
	void __fastcall UndefMacro(const AnsiString AName, const Jclbase::TDynStringArray ParamNames);
	__property TPppOptions Options = {read=GetOptions, write=SetOptions, nodefault};
};


class PASCALIMPLEMENTATION TJppParser : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	Jclpreprocessorlexer::TJppLexer* FLexer;
	TPppState* FState;
	AnsiString FResult;
	int FResultLen;
	int FLineBreakPos;
	bool FAllWhiteSpaceIn;
	bool FAllWhiteSpaceOut;
	
protected:
	void __fastcall AddResult(const AnsiString S, bool FixIndent = false, bool ForceRecurseTest = false);
	bool __fastcall IsExcludedInclude(const AnsiString FileName);
	void __fastcall NextToken(void);
	void __fastcall ParseText(void);
	void __fastcall ParseCondition(Jclpreprocessorlexer::TJppToken Token);
	AnsiString __fastcall ParseInclude();
	void __fastcall ParseDefine(bool Skip);
	void __fastcall ParseUndef(bool Skip);
	void __fastcall ParseDefineMacro(void);
	void __fastcall ParseExpandMacro(void);
	void __fastcall ParseUndefMacro(void);
	void __fastcall ParseGetBoolValue(void);
	void __fastcall ParseGetIntValue(void);
	void __fastcall ParseGetStrValue(void);
	void __fastcall ParseLoop(void);
	void __fastcall ParseSetBoolValue(void);
	void __fastcall ParseSetIntValue(void);
	void __fastcall ParseSetStrValue(void);
	
public:
	__fastcall TJppParser(const AnsiString ABuffer, TPppState* APppState);
	__fastcall virtual ~TJppParser(void);
	AnsiString __fastcall Parse();
	__property Jclpreprocessorlexer::TJppLexer* Lexer = {read=FLexer};
	__property TPppState* State = {read=FState};
};


class DELPHICLASS EPppState;
class PASCALIMPLEMENTATION EPppState : public Jclbase::EJclError 
{
	typedef Jclbase::EJclError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EPppState(const AnsiString Msg) : Jclbase::EJclError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EPppState(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Jclbase::EJclError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EPppState(int Ident)/* overload */ : Jclbase::EJclError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EPppState(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Jclbase::EJclError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EPppState(const AnsiString Msg, int AHelpContext) : Jclbase::EJclError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EPppState(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Jclbase::EJclError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EPppState(int Ident, int AHelpContext)/* overload */ : Jclbase::EJclError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EPppState(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Jclbase::EJclError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EPppState(void) { }
	#pragma option pop
	
};


class PASCALIMPLEMENTATION TPppStateItem : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	Jclcontainerintf::_di_IJclAnsiStrMap DefinedKeywords;
	Jclcontainerintf::_di_IJclAnsiStrList ExcludedFiles;
	Jclcontainerintf::_di_IJclAnsiStrIntfMap Macros;
	Jclcontainerintf::_di_IJclAnsiStrList SearchPath;
	TTriState TriState;
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TPppStateItem(void) : System::TObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TPppStateItem(void) { }
	#pragma option pop
	
};


typedef TMetaClass* TPppStateClass;

//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorparser */
using namespace Jclpreprocessorparser;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorparser

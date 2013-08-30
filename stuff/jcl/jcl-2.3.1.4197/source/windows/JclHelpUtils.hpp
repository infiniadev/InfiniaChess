// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclhelputils.pas' rev: 10.00

#ifndef JclhelputilsHPP
#define JclhelputilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Mshelpservices_tlb.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Jclsysutils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclhelputils
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EJclHelpUtilsException;
class PASCALIMPLEMENTATION EJclHelpUtilsException : public Jclbase::EJclError 
{
	typedef Jclbase::EJclError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EJclHelpUtilsException(const AnsiString Msg) : Jclbase::EJclError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EJclHelpUtilsException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Jclbase::EJclError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EJclHelpUtilsException(int Ident)/* overload */ : Jclbase::EJclError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EJclHelpUtilsException(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Jclbase::EJclError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EJclHelpUtilsException(const AnsiString Msg, int AHelpContext) : Jclbase::EJclError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EJclHelpUtilsException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Jclbase::EJclError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EJclHelpUtilsException(int Ident, int AHelpContext)/* overload */ : Jclbase::EJclError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EJclHelpUtilsException(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Jclbase::EJclError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EJclHelpUtilsException(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclBorlandOpenHelp;
class PASCALIMPLEMENTATION TJclBorlandOpenHelp : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	AnsiString FHelpPrefix;
	AnsiString FRootDirectory;
	AnsiString __fastcall GetContentFileName();
	AnsiString __fastcall GetIndexFileName();
	AnsiString __fastcall GetLinkFileName();
	AnsiString __fastcall GetGidFileName();
	AnsiString __fastcall GetProjectFileName();
	AnsiString __fastcall ReadFileName(const AnsiString FormatName);
	
public:
	__fastcall TJclBorlandOpenHelp(const AnsiString ARootDirectory, const AnsiString AHelpPrefix);
	bool __fastcall AddHelpFile(const AnsiString HelpFileName, const AnsiString IndexName);
	bool __fastcall RemoveHelpFile(const AnsiString HelpFileName, const AnsiString IndexName);
	__property AnsiString ContentFileName = {read=GetContentFileName};
	__property AnsiString GidFileName = {read=GetGidFileName};
	__property AnsiString HelpPrefix = {read=FHelpPrefix};
	__property AnsiString IndexFileName = {read=GetIndexFileName};
	__property AnsiString LinkFileName = {read=GetLinkFileName};
	__property AnsiString ProjectFileName = {read=GetProjectFileName};
	__property AnsiString RootDirectory = {read=FRootDirectory};
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBorlandOpenHelp(void) { }
	#pragma option pop
	
};


#pragma option push -b-
enum TJclHelp2Object { hoRegisterSession, hoRegister, hoPlugin };
#pragma option pop

typedef Set<TJclHelp2Object, hoRegisterSession, hoPlugin>  TJclHelp2Objects;

class DELPHICLASS TJclHelp2Manager;
class PASCALIMPLEMENTATION TJclHelp2Manager : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	Mshelpservices_tlb::_di_IHxRegisterSession FHxRegisterSession;
	Mshelpservices_tlb::_di_IHxRegister FHxRegister;
	Mshelpservices_tlb::_di_IHxPlugIn FHxPlugin;
	WideString FIdeNameSpace;
	bool __fastcall RequireObject(TJclHelp2Objects HelpObjects);
	Mshelpservices_tlb::_di_IHxPlugIn __fastcall GetHxPlugin();
	Mshelpservices_tlb::_di_IHxRegister __fastcall GetHxRegister();
	Mshelpservices_tlb::_di_IHxRegisterSession __fastcall GetHxRegisterSession();
	
public:
	__fastcall TJclHelp2Manager(int IDEVersionNumber);
	__fastcall virtual ~TJclHelp2Manager(void);
	bool __fastcall CreateTransaction(void);
	bool __fastcall CommitTransaction(void);
	bool __fastcall RegisterNameSpace(const WideString Name, const WideString Collection, const WideString Description);
	bool __fastcall UnregisterNameSpace(const WideString Name);
	bool __fastcall RegisterHelpFile(const WideString NameSpace, const WideString Identifier, const int LangId, const WideString HxSFile, const WideString HxIFile);
	bool __fastcall UnregisterHelpFile(const WideString NameSpace, const WideString Identifier, const int LangId);
	bool __fastcall PlugNameSpaceIn(const WideString SourceNameSpace, const WideString TargetNameSpace);
	bool __fastcall UnPlugNameSpace(const WideString SourceNameSpace, const WideString TargetNameSpace);
	bool __fastcall PlugNameSpaceInBorlandHelp(const WideString NameSpace);
	bool __fastcall UnPlugNameSpaceFromBorlandHelp(const WideString NameSpace);
	__property Mshelpservices_tlb::_di_IHxRegisterSession HxRegisterSession = {read=GetHxRegisterSession};
	__property Mshelpservices_tlb::_di_IHxRegister HxRegister = {read=GetHxRegister};
	__property Mshelpservices_tlb::_di_IHxPlugIn HxPlugin = {read=GetHxPlugin};
	__property WideString IdeNamespace = {read=FIdeNameSpace};
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclhelputils */
using namespace Jclhelputils;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclhelputils

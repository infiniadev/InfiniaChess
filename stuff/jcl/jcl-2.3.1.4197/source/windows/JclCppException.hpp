// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclcppexception.pas' rev: 10.00

#ifndef JclcppexceptionHPP
#define JclcppexceptionHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#include <typeinfo>
#include <exception>

namespace Jclcppexception
{

typedef std::exception* PJclCppStdException;

} /* namespace Jclcppexception */

namespace Jclcppexception
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EJclCppException;
class PASCALIMPLEMENTATION EJclCppException : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
private:
	AnsiString FTypeName;
	void *FExcDesc;
	__fastcall EJclCppException(char * ATypeName, void * ExcDesc)/* overload */;
	void * __fastcall GetCppExceptionObject(void);
	int __fastcall GetThrowLine(void);
	AnsiString __fastcall GetThrowFile();
	
public:
	__property void * CppExceptionObject = {read=GetCppExceptionObject};
	__property int ThrowLine = {read=GetThrowLine, nodefault};
	__property AnsiString ThrowFile = {read=GetThrowFile};
	__property AnsiString TypeName = {read=FTypeName};
	bool __fastcall IsCppClass(void)/* overload */;
	void * __fastcall AsCppClass(AnsiString CppClassName)/* overload */;
	__fastcall virtual ~EJclCppException(void);
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EJclCppException(const AnsiString Msg) : Sysutils::Exception(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EJclCppException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EJclCppException(int Ident)/* overload */ : Sysutils::Exception(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EJclCppException(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EJclCppException(const AnsiString Msg, int AHelpContext) : Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EJclCppException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EJclCppException(int Ident, int AHelpContext)/* overload */ : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EJclCppException(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
};


class DELPHICLASS EJclCppStdException;
class PASCALIMPLEMENTATION EJclCppStdException : public EJclCppException 
{
	typedef EJclCppException inherited;
	
private:
	void *FExcObj;
	__fastcall EJclCppStdException(PJclCppStdException AExcObj, AnsiString Msg, char * ATypeName, void * ExcDesc)/* overload */;
	PJclCppStdException __fastcall GetStdException(void);
	
public:
	__property PJclCppStdException StdException = {read=GetStdException};
public:
	#pragma option push -w-inl
	/* EJclCppException.Destroy */ inline __fastcall virtual ~EJclCppStdException(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EJclCppStdException(const AnsiString Msg) : EJclCppException(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EJclCppStdException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : EJclCppException(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EJclCppStdException(int Ident)/* overload */ : EJclCppException(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EJclCppStdException(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : EJclCppException(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EJclCppStdException(const AnsiString Msg, int AHelpContext) : EJclCppException(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EJclCppStdException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : EJclCppException(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EJclCppStdException(int Ident, int AHelpContext)/* overload */ : EJclCppException(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EJclCppStdException(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : EJclCppException(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
};


#pragma option push -b-
enum JclCppException__3 { cefPrependCppClassName };
#pragma option pop

typedef Set<JclCppException__3, cefPrependCppClassName, cefPrependCppClassName>  TJclCppExceptionFlags;

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TJclCppExceptionFlags JclCppExceptionFlags;
extern PACKAGE void __fastcall JclInstallCppExceptionFilter(void);
extern PACKAGE void __fastcall JclUninstallCppExceptionFilter(void);
extern PACKAGE bool __fastcall JclCppExceptionFilterInstalled(void);

}	/* namespace Jclcppexception */
using namespace Jclcppexception;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclcppexception

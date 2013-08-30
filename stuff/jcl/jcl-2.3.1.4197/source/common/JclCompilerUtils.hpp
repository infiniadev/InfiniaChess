// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclcompilerutils.pas' rev: 10.00

#ifndef JclcompilerutilsHPP
#define JclcompilerutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Inifiles.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Jclsysutils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclcompilerutils
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EJclCompilerUtilsException;
class PASCALIMPLEMENTATION EJclCompilerUtilsException : public Jclbase::EJclError 
{
	typedef Jclbase::EJclError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EJclCompilerUtilsException(const AnsiString Msg) : Jclbase::EJclError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EJclCompilerUtilsException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Jclbase::EJclError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EJclCompilerUtilsException(int Ident)/* overload */ : Jclbase::EJclError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EJclCompilerUtilsException(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Jclbase::EJclError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EJclCompilerUtilsException(const AnsiString Msg, int AHelpContext) : Jclbase::EJclError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EJclCompilerUtilsException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Jclbase::EJclError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EJclCompilerUtilsException(int Ident, int AHelpContext)/* overload */ : Jclbase::EJclError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EJclCompilerUtilsException(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Jclbase::EJclError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EJclCompilerUtilsException(void) { }
	#pragma option pop
	
};


#pragma option push -b-
enum TJclCompilerSettingsFormat { csfDOF, csfBDSProj, csfMsBuild };
#pragma option pop

class DELPHICLASS TJclBorlandCommandLineTool;
typedef void __fastcall (__closure *TJclBorlandCommandLineToolEvent)(TJclBorlandCommandLineTool* Sender);

class PASCALIMPLEMENTATION TJclBorlandCommandLineTool : public System::TInterfacedObject 
{
	typedef System::TInterfacedObject inherited;
	
private:
	AnsiString FBinDirectory;
	TJclCompilerSettingsFormat FCompilerSettingsFormat;
	bool FLongPathBug;
	Classes::TStringList* FOptions;
	Jclsysutils::TTextHandler FOutputCallback;
	AnsiString FOutput;
	TJclBorlandCommandLineToolEvent FOnAfterExecute;
	TJclBorlandCommandLineToolEvent FOnBeforeExecute;
	void __fastcall OemTextHandler(const AnsiString Text);
	
protected:
	void __fastcall CheckOutputValid(void);
	AnsiString __fastcall GetFileName();
	bool __fastcall InternalExecute(const AnsiString CommandLine);
	
public:
	__fastcall TJclBorlandCommandLineTool(const AnsiString ABinDirectory, bool ALongPathBug, TJclCompilerSettingsFormat ACompilerSettingsFormat);
	__fastcall virtual ~TJclBorlandCommandLineTool(void);
	virtual AnsiString __fastcall GetExeName();
	Classes::TStrings* __fastcall GetOptions(void);
	AnsiString __fastcall GetOutput();
	Jclsysutils::TTextHandler __fastcall GetOutputCallback();
	void __fastcall AddPathOption(const AnsiString Option, const AnsiString Path);
	virtual bool __fastcall Execute(const AnsiString CommandLine);
	void __fastcall SetOutputCallback(const Jclsysutils::TTextHandler CallbackMethod);
	__property AnsiString BinDirectory = {read=FBinDirectory};
	__property TJclCompilerSettingsFormat CompilerSettingsFormat = {read=FCompilerSettingsFormat, nodefault};
	__property AnsiString ExeName = {read=GetExeName};
	__property bool LongPathBug = {read=FLongPathBug, nodefault};
	__property Classes::TStrings* Options = {read=GetOptions};
	__property Jclsysutils::TTextHandler OutputCallback = {write=SetOutputCallback};
	__property AnsiString Output = {read=GetOutput};
	__property AnsiString FileName = {read=GetFileName};
	__property TJclBorlandCommandLineToolEvent OnAfterExecute = {read=FOnAfterExecute, write=FOnAfterExecute};
	__property TJclBorlandCommandLineToolEvent OnBeforeExecute = {read=FOnBeforeExecute, write=FOnBeforeExecute};
private:
	void *__IJclCommandLineTool;	/* Jclsysutils::IJclCommandLineTool */
	
public:
	operator IJclCommandLineTool*(void) { return (IJclCommandLineTool*)&__IJclCommandLineTool; }
	
};


class DELPHICLASS TJclBCC32;
class PASCALIMPLEMENTATION TJclBCC32 : public TJclBorlandCommandLineTool 
{
	typedef TJclBorlandCommandLineTool inherited;
	
public:
	virtual AnsiString __fastcall GetExeName();
public:
	#pragma option push -w-inl
	/* TJclBorlandCommandLineTool.Create */ inline __fastcall TJclBCC32(const AnsiString ABinDirectory, bool ALongPathBug, TJclCompilerSettingsFormat ACompilerSettingsFormat) : TJclBorlandCommandLineTool(ABinDirectory, ALongPathBug, ACompilerSettingsFormat) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TJclBorlandCommandLineTool.Destroy */ inline __fastcall virtual ~TJclBCC32(void) { }
	#pragma option pop
	
};


struct TProjectOptions
{
	
public:
	bool UsePackages;
	AnsiString UnitOutputDir;
	AnsiString SearchPath;
	AnsiString DynamicPackages;
	AnsiString SearchDcpPath;
	AnsiString Conditionals;
	AnsiString Namespace;
} ;

class DELPHICLASS TJclDCC32;
class PASCALIMPLEMENTATION TJclDCC32 : public TJclBorlandCommandLineTool 
{
	typedef TJclBorlandCommandLineTool inherited;
	
private:
	AnsiString FDCPSearchPath;
	AnsiString FLibrarySearchPath;
	AnsiString FLibraryDebugSearchPath;
	AnsiString FCppSearchPath;
	bool FSupportsNoConfig;
	bool FSupportsPlatform;
	
protected:
	void __fastcall AddProjectOptions(const AnsiString ProjectFileName, const AnsiString DCPPath);
	bool __fastcall Compile(const AnsiString ProjectFileName);
	
public:
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall GetPlatform() { return GetPlatform(__classid(TJclDCC32)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall GetPlatform(TMetaClass* vmt);
	__fastcall TJclDCC32(const AnsiString ABinDirectory, bool ALongPathBug, TJclCompilerSettingsFormat ACompilerSettingsFormat, bool ASupportsNoConfig, bool ASupportsPlatform, const AnsiString ADCPSearchPath, const AnsiString ALibrarySearchPath, const AnsiString ALibraryDebugSearchPath, const AnsiString ACppSearchPath);
	virtual AnsiString __fastcall GetExeName();
	virtual bool __fastcall Execute(const AnsiString CommandLine);
	bool __fastcall MakePackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath, AnsiString ExtraOptions = "", bool ADebug = false);
	bool __fastcall MakeProject(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString DcpSearchPath, AnsiString ExtraOptions = "", bool ADebug = false);
	virtual void __fastcall SetDefaultOptions(bool ADebug);
	bool __fastcall AddBDSProjOptions(const AnsiString ProjectFileName, TProjectOptions &ProjectOptions);
	bool __fastcall AddDOFOptions(const AnsiString ProjectFileName, TProjectOptions &ProjectOptions);
	bool __fastcall AddDProjOptions(const AnsiString ProjectFileName, TProjectOptions &ProjectOptions);
	__property AnsiString CppSearchPath = {read=FCppSearchPath};
	__property AnsiString DCPSearchPath = {read=FDCPSearchPath};
	__property AnsiString LibrarySearchPath = {read=FLibrarySearchPath};
	__property AnsiString LibraryDebugSearchPath = {read=FLibraryDebugSearchPath};
	__property bool SupportsNoConfig = {read=FSupportsNoConfig, nodefault};
	__property bool SupportsPlatform = {read=FSupportsPlatform, nodefault};
public:
	#pragma option push -w-inl
	/* TJclBorlandCommandLineTool.Destroy */ inline __fastcall virtual ~TJclDCC32(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclDCC64;
class PASCALIMPLEMENTATION TJclDCC64 : public TJclDCC32 
{
	typedef TJclDCC32 inherited;
	
public:
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall GetPlatform() { return GetPlatform(__classid(TJclDCC64)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall GetPlatform(TMetaClass* vmt);
	virtual AnsiString __fastcall GetExeName();
public:
	#pragma option push -w-inl
	/* TJclDCC32.Create */ inline __fastcall TJclDCC64(const AnsiString ABinDirectory, bool ALongPathBug, TJclCompilerSettingsFormat ACompilerSettingsFormat, bool ASupportsNoConfig, bool ASupportsPlatform, const AnsiString ADCPSearchPath, const AnsiString ALibrarySearchPath, const AnsiString ALibraryDebugSearchPath, const AnsiString ACppSearchPath) : TJclDCC32(ABinDirectory, ALongPathBug, ACompilerSettingsFormat, ASupportsNoConfig, ASupportsPlatform, ADCPSearchPath, ALibrarySearchPath, ALibraryDebugSearchPath, ACppSearchPath) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TJclBorlandCommandLineTool.Destroy */ inline __fastcall virtual ~TJclDCC64(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclDCCIL;
class PASCALIMPLEMENTATION TJclDCCIL : public TJclDCC32 
{
	typedef TJclDCC32 inherited;
	
private:
	AnsiString FMaxCLRVersion;
	
protected:
	AnsiString __fastcall GetMaxCLRVersion();
	
public:
	virtual AnsiString __fastcall GetExeName();
	HIDESBASE bool __fastcall MakeProject(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString ExtraOptions, bool ADebug = false);
	virtual void __fastcall SetDefaultOptions(bool ADebug);
	__property AnsiString MaxCLRVersion = {read=GetMaxCLRVersion};
public:
	#pragma option push -w-inl
	/* TJclDCC32.Create */ inline __fastcall TJclDCCIL(const AnsiString ABinDirectory, bool ALongPathBug, TJclCompilerSettingsFormat ACompilerSettingsFormat, bool ASupportsNoConfig, bool ASupportsPlatform, const AnsiString ADCPSearchPath, const AnsiString ALibrarySearchPath, const AnsiString ALibraryDebugSearchPath, const AnsiString ACppSearchPath) : TJclDCC32(ABinDirectory, ALongPathBug, ACompilerSettingsFormat, ASupportsNoConfig, ASupportsPlatform, ADCPSearchPath, ALibrarySearchPath, ALibraryDebugSearchPath, ACppSearchPath) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TJclBorlandCommandLineTool.Destroy */ inline __fastcall virtual ~TJclDCCIL(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclBpr2Mak;
class PASCALIMPLEMENTATION TJclBpr2Mak : public TJclBorlandCommandLineTool 
{
	typedef TJclBorlandCommandLineTool inherited;
	
public:
	virtual AnsiString __fastcall GetExeName();
public:
	#pragma option push -w-inl
	/* TJclBorlandCommandLineTool.Create */ inline __fastcall TJclBpr2Mak(const AnsiString ABinDirectory, bool ALongPathBug, TJclCompilerSettingsFormat ACompilerSettingsFormat) : TJclBorlandCommandLineTool(ABinDirectory, ALongPathBug, ACompilerSettingsFormat) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TJclBorlandCommandLineTool.Destroy */ inline __fastcall virtual ~TJclBpr2Mak(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclBorlandMake;
class PASCALIMPLEMENTATION TJclBorlandMake : public TJclBorlandCommandLineTool 
{
	typedef TJclBorlandCommandLineTool inherited;
	
public:
	virtual AnsiString __fastcall GetExeName();
public:
	#pragma option push -w-inl
	/* TJclBorlandCommandLineTool.Create */ inline __fastcall TJclBorlandMake(const AnsiString ABinDirectory, bool ALongPathBug, TJclCompilerSettingsFormat ACompilerSettingsFormat) : TJclBorlandCommandLineTool(ABinDirectory, ALongPathBug, ACompilerSettingsFormat) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TJclBorlandCommandLineTool.Destroy */ inline __fastcall virtual ~TJclBorlandMake(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
#define AsmExeName "tasm32.exe"
#define BCC32ExeName "bcc32.exe"
#define DCC32ExeName "dcc32.exe"
#define DCC64ExeName "dcc64.exe"
#define DCCILExeName "dccil.exe"
#define Bpr2MakExeName "bpr2mak.exe"
#define MakeExeName "make.exe"
#define BinaryExtensionPackage ".bpl"
#define BinaryExtensionLibrary ".dll"
#define BinaryExtensionExecutable ".exe"
#define SourceExtensionDelphiPackage ".dpk"
#define SourceExtensionBCBPackage ".bpk"
#define SourceExtensionDelphiProject ".dpr"
#define SourceExtensionBCBProject ".bpr"
#define SourceExtensionDProject ".dproj"
#define SourceExtensionBDSProject ".bdsproj"
#define SourceExtensionDOFProject ".dof"
#define SourceExtensionConfiguration ".cfg"
extern PACKAGE void __fastcall GetDPRFileInfo(const AnsiString DPRFileName, /* out */ AnsiString &BinaryExtension, const System::PAnsiString LibSuffix = (void *)(0x0));
extern PACKAGE void __fastcall GetBPRFileInfo(const AnsiString BPRFileName, /* out */ AnsiString &BinaryFileName, const System::PAnsiString Description = (void *)(0x0));
extern PACKAGE void __fastcall GetDPKFileInfo(const AnsiString DPKFileName, /* out */ bool &RunOnly, const System::PAnsiString LibSuffix = (void *)(0x0), const System::PAnsiString Description = (void *)(0x0));
extern PACKAGE void __fastcall GetBPKFileInfo(const AnsiString BPKFileName, /* out */ bool &RunOnly, const System::PAnsiString BinaryFileName = (void *)(0x0), const System::PAnsiString Description = (void *)(0x0));
extern PACKAGE AnsiString __fastcall BinaryFileName(const AnsiString OutputPath, const AnsiString ProjectFileName);
extern PACKAGE bool __fastcall IsDelphiPackage(const AnsiString FileName);
extern PACKAGE bool __fastcall IsDelphiProject(const AnsiString FileName);
extern PACKAGE bool __fastcall IsBCBPackage(const AnsiString FileName);
extern PACKAGE bool __fastcall IsBCBProject(const AnsiString FileName);

}	/* namespace Jclcompilerutils */
using namespace Jclcompilerutils;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclcompilerutils

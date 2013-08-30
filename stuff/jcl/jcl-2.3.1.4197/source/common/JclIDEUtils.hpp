// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclideutils.pas' rev: 10.00

#ifndef JclideutilsHPP
#define JclideutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Shlobj.hpp>	// Pascal unit
#include <Jclhelputils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Inifiles.hpp>	// Pascal unit
#include <Contnrs.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Jclsysutils.hpp>	// Pascal unit
#include <Jclcompilerutils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclideutils
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EJclBorRADException;
class PASCALIMPLEMENTATION EJclBorRADException : public Jclbase::EJclError 
{
	typedef Jclbase::EJclError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EJclBorRADException(const AnsiString Msg) : Jclbase::EJclError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EJclBorRADException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Jclbase::EJclError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EJclBorRADException(int Ident)/* overload */ : Jclbase::EJclError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EJclBorRADException(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Jclbase::EJclError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EJclBorRADException(const AnsiString Msg, int AHelpContext) : Jclbase::EJclError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EJclBorRADException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Jclbase::EJclError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EJclBorRADException(int Ident, int AHelpContext)/* overload */ : Jclbase::EJclError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EJclBorRADException(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Jclbase::EJclError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EJclBorRADException(void) { }
	#pragma option pop
	
};


#pragma option push -b-
enum TJclBorRADToolKind { brDelphi, brCppBuilder, brBorlandDevStudio };
#pragma option pop

#pragma option push -b-
enum TJclBorRADToolEdition { deSTD, dePRO, deCSS, deARC };
#pragma option pop

typedef AnsiString TJclBorRADToolPath;

#pragma option push -b-
enum TJclBorPersonality { bpDelphi32, bpDelphi64, bpBCBuilder32, bpBCBuilder64, bpDelphiNet32, bpDelphiNet64, bpCSBuilder32, bpCSBuilder64, bpVisualBasic32, bpVisualBasic64, bpDesign, bpUnknown };
#pragma option pop

typedef Set<TJclBorPersonality, bpDelphi32, bpUnknown>  TJclBorPersonalities;

#pragma option push -b-
enum TJclBorDesigner { bdVCL, bdCLX };
#pragma option pop

typedef Set<TJclBorDesigner, bdVCL, bdCLX>  TJclBorDesigners;

#pragma option push -b-
enum TJclBDSPlatform { bpWin32, bpWin64, bpOSX32 };
#pragma option pop

typedef AnsiString JclIDEUtils__2[12];

typedef AnsiString JclIDEUtils__3[2];

typedef AnsiString JclIDEUtils__4[2];

class DELPHICLASS TJclBorRADToolInstallationObject;
class DELPHICLASS TJclBorRADToolInstallation;
class DELPHICLASS TJclBorRADToolIdePackages;
class PASCALIMPLEMENTATION TJclBorRADToolInstallationObject : public System::TInterfacedObject 
{
	typedef System::TInterfacedObject inherited;
	
private:
	TJclBorRADToolInstallation* FInstallation;
	
public:
	__fastcall TJclBorRADToolInstallationObject(TJclBorRADToolInstallation* AInstallation);
	__property TJclBorRADToolInstallation* Installation = {read=FInstallation};
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBorRADToolInstallationObject(void) { }
	#pragma option pop
	
};


class PASCALIMPLEMENTATION TJclBorRADToolIdePackages : public TJclBorRADToolInstallationObject 
{
	typedef TJclBorRADToolInstallationObject inherited;
	
private:
	Classes::TStringList* FDisabledPackages;
	Classes::TStringList* FKnownPackages;
	Classes::TStringList* FKnownIDEPackages;
	Classes::TStringList* FExperts;
	int __fastcall GetCount(void);
	int __fastcall GetIDECount(void);
	int __fastcall GetExpertCount(void);
	AnsiString __fastcall GetPackageDescriptions(int Index);
	AnsiString __fastcall GetIDEPackageDescriptions(int Index);
	AnsiString __fastcall GetExpertDescriptions(int Index);
	bool __fastcall GetPackageDisabled(int Index);
	AnsiString __fastcall GetPackageFileNames(int Index);
	AnsiString __fastcall GetIDEPackageFileNames(int Index);
	AnsiString __fastcall GetExpertFileNames(int Index);
	
protected:
	AnsiString __fastcall PackageEntryToFileName(const AnsiString Entry);
	void __fastcall ReadPackages(void);
	void __fastcall RemoveDisabled(const AnsiString FileName);
	
public:
	__fastcall TJclBorRADToolIdePackages(TJclBorRADToolInstallation* AInstallation);
	__fastcall virtual ~TJclBorRADToolIdePackages(void);
	bool __fastcall AddPackage(const AnsiString FileName, const AnsiString Description);
	bool __fastcall AddIDEPackage(const AnsiString FileName, const AnsiString Description);
	bool __fastcall AddExpert(const AnsiString FileName, const AnsiString Description);
	bool __fastcall RemovePackage(const AnsiString FileName);
	bool __fastcall RemoveIDEPackage(const AnsiString FileName);
	bool __fastcall RemoveExpert(const AnsiString FileName);
	__property int Count = {read=GetCount, nodefault};
	__property int IDECount = {read=GetIDECount, nodefault};
	__property int ExpertCount = {read=GetExpertCount, nodefault};
	__property AnsiString PackageDescriptions[int Index] = {read=GetPackageDescriptions};
	__property AnsiString IDEPackageDescriptions[int Index] = {read=GetIDEPackageDescriptions};
	__property AnsiString ExpertDescriptions[int Index] = {read=GetExpertDescriptions};
	__property AnsiString PackageFileNames[int Index] = {read=GetPackageFileNames};
	__property AnsiString IDEPackageFileNames[int Index] = {read=GetIDEPackageFileNames};
	__property AnsiString ExpertFileNames[int Index] = {read=GetExpertFileNames};
	__property bool PackageDisabled[int Index] = {read=GetPackageDisabled};
};


class DELPHICLASS TJclBorRADToolIdeTool;
class PASCALIMPLEMENTATION TJclBorRADToolIdeTool : public TJclBorRADToolInstallationObject 
{
	typedef TJclBorRADToolInstallationObject inherited;
	
private:
	AnsiString FKey;
	int __fastcall GetCount(void);
	AnsiString __fastcall GetParameters(int Index);
	AnsiString __fastcall GetPath(int Index);
	AnsiString __fastcall GetTitle(int Index);
	AnsiString __fastcall GetWorkingDir(int Index);
	void __fastcall SetCount(const int Value);
	void __fastcall SetParameters(int Index, const AnsiString Value);
	void __fastcall SetPath(int Index, const AnsiString Value);
	void __fastcall SetTitle(int Index, const AnsiString Value);
	void __fastcall SetWorkingDir(int Index, const AnsiString Value);
	
protected:
	void __fastcall CheckIndex(int Index);
	
public:
	__fastcall TJclBorRADToolIdeTool(TJclBorRADToolInstallation* AInstallation);
	__property int Count = {read=GetCount, write=SetCount, nodefault};
	int __fastcall IndexOfPath(const AnsiString Value);
	int __fastcall IndexOfTitle(const AnsiString Value);
	void __fastcall RemoveIndex(const int Index);
	__property AnsiString Key = {read=FKey};
	__property AnsiString Title[int Index] = {read=GetTitle, write=SetTitle};
	__property AnsiString Path[int Index] = {read=GetPath, write=SetPath};
	__property AnsiString Parameters[int Index] = {read=GetParameters, write=SetParameters};
	__property AnsiString WorkingDir[int Index] = {read=GetWorkingDir, write=SetWorkingDir};
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBorRADToolIdeTool(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclBorRADToolPalette;
class PASCALIMPLEMENTATION TJclBorRADToolPalette : public TJclBorRADToolInstallationObject 
{
	typedef TJclBorRADToolInstallationObject inherited;
	
private:
	AnsiString FKey;
	Classes::TStringList* FTabNames;
	AnsiString __fastcall GetComponentsOnTab(int Index);
	AnsiString __fastcall GetHiddenComponentsOnTab(int Index);
	int __fastcall GetTabNameCount(void);
	AnsiString __fastcall GetTabNames(int Index);
	void __fastcall ReadTabNames(void);
	
public:
	__fastcall TJclBorRADToolPalette(TJclBorRADToolInstallation* AInstallation);
	__fastcall virtual ~TJclBorRADToolPalette(void);
	void __fastcall ComponentsOnTabToStrings(int Index, Classes::TStrings* Strings, bool IncludeUnitName = false, bool IncludeHiddenComponents = true);
	bool __fastcall DeleteTabName(const AnsiString TabName);
	bool __fastcall TabNameExists(const AnsiString TabName);
	__property AnsiString ComponentsOnTab[int Index] = {read=GetComponentsOnTab};
	__property AnsiString HiddenComponentsOnTab[int Index] = {read=GetHiddenComponentsOnTab};
	__property AnsiString Key = {read=FKey};
	__property AnsiString TabNames[int Index] = {read=GetTabNames};
	__property int TabNameCount = {read=GetTabNameCount, nodefault};
};


class DELPHICLASS TJclBorRADToolRepository;
class PASCALIMPLEMENTATION TJclBorRADToolRepository : public TJclBorRADToolInstallationObject 
{
	typedef TJclBorRADToolInstallationObject inherited;
	
private:
	Inifiles::TIniFile* FIniFile;
	AnsiString FFileName;
	Classes::TStringList* FPages;
	Inifiles::TIniFile* __fastcall GetIniFile(void);
	Classes::TStrings* __fastcall GetPages(void);
	
public:
	__fastcall TJclBorRADToolRepository(TJclBorRADToolInstallation* AInstallation);
	__fastcall virtual ~TJclBorRADToolRepository(void);
	void __fastcall AddObject(const AnsiString FileName, const AnsiString ObjectType, const AnsiString PageName, const AnsiString ObjectName, const AnsiString IconFileName, const AnsiString Description, const AnsiString Author, const AnsiString Designer, const AnsiString Ancestor = "");
	void __fastcall CloseIniFile(void);
	AnsiString __fastcall FindPage(const AnsiString Name, int OptionalIndex);
	void __fastcall RemoveObjects(const AnsiString PartialPath, const AnsiString FileName, const AnsiString ObjectType);
	__property AnsiString FileName = {read=FFileName};
	__property Inifiles::TIniFile* IniFile = {read=GetIniFile};
	__property Classes::TStrings* Pages = {read=GetPages};
};


#pragma option push -b-
enum TCommandLineTool { clAsm, clBcc32, clDcc32, clDcc64, clDccIL, clMake, clProj2Mak };
#pragma option pop

typedef Set<TCommandLineTool, clAsm, clProj2Mak>  TCommandLineTools;

class PASCALIMPLEMENTATION TJclBorRADToolInstallation : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	Inifiles::TCustomIniFile* FConfigData;
	AnsiString FConfigDataLocation;
	unsigned FRootKey;
	Classes::TStringList* FGlobals;
	AnsiString FRootDir;
	AnsiString FBinFolderName;
	Jclcompilerutils::TJclBCC32* FBCC32;
	Jclcompilerutils::TJclDCC32* FDCC;
	Jclcompilerutils::TJclDCC32* FDCC32;
	Jclcompilerutils::TJclBpr2Mak* FBpr2Mak;
	Jclsysutils::_di_IJclCommandLineTool FMake;
	AnsiString FEditionStr;
	TJclBorRADToolEdition FEdition;
	Classes::TStringList* FEnvironmentVariables;
	TJclBorRADToolIdePackages* FIdePackages;
	TJclBorRADToolIdeTool* FIdeTools;
	int FInstalledUpdatePack;
	Jclhelputils::TJclBorlandOpenHelp* FOpenHelp;
	TJclBorRADToolPalette* FPalette;
	TJclBorRADToolRepository* FRepository;
	int FVersionNumber;
	AnsiString FVersionNumberStr;
	int FIDEVersionNumber;
	AnsiString FIDEVersionNumberStr;
	bool FMapCreate;
	bool FJdbgCreate;
	bool FJdbgInsert;
	bool FMapDelete;
	TCommandLineTools FCommandLineTools;
	TJclBorPersonalities FPersonalities;
	Jclsysutils::TTextHandler FOutputCallback;
	bool __fastcall GetSupportsLibSuffix(void);
	Jclcompilerutils::TJclBCC32* __fastcall GetBCC32(void);
	Jclcompilerutils::TJclDCC32* __fastcall GetDCC(void);
	Jclcompilerutils::TJclDCC32* __fastcall GetDCC32(void);
	Jclcompilerutils::TJclBpr2Mak* __fastcall GetBpr2Mak(void);
	Jclsysutils::_di_IJclCommandLineTool __fastcall GetMake();
	AnsiString __fastcall GetDescription();
	AnsiString __fastcall GetEditionAsText();
	AnsiString __fastcall GetIdeExeFileName();
	Classes::TStrings* __fastcall GetGlobals(void);
	AnsiString __fastcall GetIdeExeBuildNumber();
	TJclBorRADToolIdePackages* __fastcall GetIdePackages(void);
	bool __fastcall GetIsTurboExplorer(void);
	int __fastcall GetLatestUpdatePack(void);
	TJclBorRADToolPalette* __fastcall GetPalette(void);
	TJclBorRADToolRepository* __fastcall GetRepository(void);
	bool __fastcall GetUpdateNeeded(void);
	AnsiString __fastcall GetDefaultBDSCommonDir();
	void __fastcall SetDCC(const Jclcompilerutils::TJclDCC32* Value);
	
protected:
	bool __fastcall ProcessMapFile(const AnsiString BinaryFileName);
	virtual bool __fastcall CompileDelphiPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath)/* overload */;
	virtual bool __fastcall CompileDelphiPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath, const AnsiString ExtraOptions)/* overload */;
	virtual bool __fastcall CompileDelphiProject(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString DcpSearchPath);
	virtual bool __fastcall CompileBCBPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall CompileBCBProject(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString DcpSearchPath);
	virtual bool __fastcall InstallDelphiPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall UninstallDelphiPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall InstallBCBPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall UninstallBCBPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall InstallDelphiIdePackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall UninstallDelphiIdePackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall InstallBCBIdePackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall UninstallBCBIdePackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall InstallDelphiExpert(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString DcpSearchPath);
	virtual bool __fastcall UninstallDelphiExpert(const AnsiString ProjectName, const AnsiString OutputDir);
	virtual bool __fastcall InstallBCBExpert(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString DcpSearchPath);
	virtual bool __fastcall UninstallBCBExpert(const AnsiString ProjectName, const AnsiString OutputDir);
	void __fastcall ReadInformation(void);
	bool __fastcall RemoveFromPath(AnsiString &Path, const AnsiString ItemsToRemove);
	virtual AnsiString __fastcall GetDCPOutputPath(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetBPLOutputPath(TJclBDSPlatform APlatform);
	virtual Classes::TStrings* __fastcall GetEnvironmentVariables(void);
	virtual AnsiString __fastcall GetVclIncludeDir(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetName();
	void __fastcall OutputString(const AnsiString AText);
	bool __fastcall OutputFileDelete(const AnsiString FileName);
	virtual void __fastcall SetOutputCallback(const Jclsysutils::TTextHandler Value);
	virtual AnsiString __fastcall GetDebugDCUPath(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetRawDebugDCUPath(TJclBDSPlatform APlatform);
	virtual void __fastcall SetRawDebugDCUPath(TJclBDSPlatform APlatform, const AnsiString Value);
	virtual AnsiString __fastcall GetLibrarySearchPath(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetRawLibrarySearchPath(TJclBDSPlatform APlatform);
	virtual void __fastcall SetRawLibrarySearchPath(TJclBDSPlatform APlatform, const AnsiString Value);
	virtual AnsiString __fastcall GetLibraryBrowsingPath(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetRawLibraryBrowsingPath(TJclBDSPlatform APlatform);
	virtual void __fastcall SetRawLibraryBrowsingPath(TJclBDSPlatform APlatform, const AnsiString Value);
	virtual AnsiString __fastcall GetLibFolderName(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetObjFolderName(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetLibDebugFolderName(TJclBDSPlatform APlatform);
	virtual bool __fastcall GetValid(void);
	bool __fastcall GetLongPathBug(void);
	Jclcompilerutils::TJclCompilerSettingsFormat __fastcall GetCompilerSettingsFormat(void);
	bool __fastcall GetSupportsNoConfig(void);
	bool __fastcall GetSupportsPlatform(void);
	void __fastcall CheckWin32Only(TJclBDSPlatform APlatform);
	
public:
	__fastcall virtual TJclBorRADToolInstallation(const AnsiString AConfigDataLocation, unsigned ARootKey);
	__fastcall virtual ~TJclBorRADToolInstallation(void);
	/*         class method */ static void __fastcall ExtractPaths(TMetaClass* vmt, const AnsiString Path, Classes::TStrings* List);
	#pragma option push -w-inl
	/* virtual class method */ virtual int __fastcall GetLatestUpdatePackForVersion(int Version) { return GetLatestUpdatePackForVersion(__classid(TJclBorRADToolInstallation), Version); }
	#pragma option pop
	/*         class method */ static int __fastcall GetLatestUpdatePackForVersion(TMetaClass* vmt, int Version);
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall PackageSourceFileExtension() { return PackageSourceFileExtension(__classid(TJclBorRADToolInstallation)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall PackageSourceFileExtension(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall ProjectSourceFileExtension() { return ProjectSourceFileExtension(__classid(TJclBorRADToolInstallation)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall ProjectSourceFileExtension(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual TJclBorRADToolKind __fastcall RadToolKind() { return RadToolKind(__classid(TJclBorRADToolInstallation)); }
	#pragma option pop
	/*         class method */ static TJclBorRADToolKind __fastcall RadToolKind(TMetaClass* vmt);
	virtual AnsiString __fastcall RadToolName();
	bool __fastcall AnyInstanceRunning(void);
	bool __fastcall AddToDebugDCUPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall AddToLibrarySearchPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall AddToLibraryBrowsingPath(const AnsiString Path, TJclBDSPlatform APlatform);
	int __fastcall FindFolderInPath(AnsiString Folder, Classes::TStrings* List);
	virtual bool __fastcall CompilePackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall InstallPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall UninstallPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall InstallIDEPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall UninstallIDEPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual bool __fastcall CompileProject(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString DcpSearchPath);
	virtual bool __fastcall InstallExpert(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString DcpSearchPath);
	virtual bool __fastcall UninstallExpert(const AnsiString ProjectName, const AnsiString OutputDir);
	virtual bool __fastcall RegisterPackage(const AnsiString BinaryFileName, const AnsiString Description)/* overload */;
	virtual bool __fastcall RegisterPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString Description)/* overload */;
	virtual bool __fastcall UnregisterPackage(const AnsiString BinaryFileName)/* overload */;
	virtual bool __fastcall UnregisterPackage(const AnsiString PackageName, const AnsiString BPLPath)/* overload */;
	virtual bool __fastcall RegisterIDEPackage(const AnsiString BinaryFileName, const AnsiString Description)/* overload */;
	virtual bool __fastcall RegisterIDEPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString Description)/* overload */;
	virtual bool __fastcall UnregisterIDEPackage(const AnsiString BinaryFileName)/* overload */;
	virtual bool __fastcall UnregisterIDEPackage(const AnsiString PackageName, const AnsiString BPLPath)/* overload */;
	virtual bool __fastcall RegisterExpert(const AnsiString BinaryFileName, const AnsiString Description)/* overload */;
	virtual bool __fastcall RegisterExpert(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString Description)/* overload */;
	virtual bool __fastcall UnregisterExpert(const AnsiString BinaryFileName)/* overload */;
	virtual bool __fastcall UnregisterExpert(const AnsiString ProjectName, const AnsiString OutputDir)/* overload */;
	virtual AnsiString __fastcall GetDefaultProjectsDir();
	virtual AnsiString __fastcall GetCommonProjectsDir();
	bool __fastcall RemoveFromDebugDCUPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall RemoveFromLibrarySearchPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall RemoveFromLibraryBrowsingPath(const AnsiString Path, TJclBDSPlatform APlatform);
	AnsiString __fastcall SubstitutePath(const AnsiString Path);
	bool __fastcall SupportsVisualCLX(void);
	bool __fastcall SupportsVCL(void);
	__property AnsiString LibFolderName[TJclBDSPlatform APlatform] = {read=GetLibFolderName};
	__property AnsiString ObjFolderName[TJclBDSPlatform APlatform] = {read=GetObjFolderName};
	__property AnsiString LibDebugFolderName[TJclBDSPlatform APlatform] = {read=GetLibDebugFolderName};
	__property TCommandLineTools CommandLineTools = {read=FCommandLineTools, nodefault};
	__property Jclcompilerutils::TJclBCC32* BCC32 = {read=GetBCC32};
	__property Jclcompilerutils::TJclDCC32* DCC = {read=GetDCC, write=SetDCC};
	__property Jclcompilerutils::TJclDCC32* DCC32 = {read=GetDCC32};
	__property Jclcompilerutils::TJclBpr2Mak* Bpr2Mak = {read=GetBpr2Mak};
	__property Jclsysutils::_di_IJclCommandLineTool Make = {read=GetMake};
	__property AnsiString BinFolderName = {read=FBinFolderName};
	__property AnsiString BPLOutputPath[TJclBDSPlatform APlatform] = {read=GetBPLOutputPath};
	__property AnsiString DebugDCUPath[TJclBDSPlatform APlatform] = {read=GetDebugDCUPath, write=SetRawDebugDCUPath};
	__property AnsiString RawDebugDCUPath[TJclBDSPlatform APlatform] = {read=GetRawDebugDCUPath, write=SetRawDebugDCUPath};
	__property AnsiString DCPOutputPath[TJclBDSPlatform APlatform] = {read=GetDCPOutputPath};
	__property AnsiString DefaultProjectsDir = {read=GetDefaultProjectsDir};
	__property AnsiString CommonProjectsDir = {read=GetCommonProjectsDir};
	__property AnsiString Description = {read=GetDescription};
	__property TJclBorRADToolEdition Edition = {read=FEdition, nodefault};
	__property AnsiString EditionAsText = {read=GetEditionAsText};
	__property Classes::TStrings* EnvironmentVariables = {read=GetEnvironmentVariables};
	__property TJclBorRADToolIdePackages* IdePackages = {read=GetIdePackages};
	__property TJclBorRADToolIdeTool* IdeTools = {read=FIdeTools};
	__property AnsiString IdeExeBuildNumber = {read=GetIdeExeBuildNumber};
	__property AnsiString IdeExeFileName = {read=GetIdeExeFileName};
	__property int InstalledUpdatePack = {read=FInstalledUpdatePack, nodefault};
	__property int LatestUpdatePack = {read=GetLatestUpdatePack, nodefault};
	__property AnsiString LibrarySearchPath[TJclBDSPlatform APlatform] = {read=GetLibrarySearchPath, write=SetRawLibrarySearchPath};
	__property AnsiString RawLibrarySearchPath[TJclBDSPlatform APlatform] = {read=GetRawLibrarySearchPath, write=SetRawLibrarySearchPath};
	__property AnsiString LibraryBrowsingPath[TJclBDSPlatform APlatform] = {read=GetLibraryBrowsingPath, write=SetRawLibraryBrowsingPath};
	__property AnsiString RawLibraryBrowsingPath[TJclBDSPlatform APlatform] = {read=GetRawLibraryBrowsingPath, write=SetRawLibraryBrowsingPath};
	__property Jclhelputils::TJclBorlandOpenHelp* OpenHelp = {read=FOpenHelp};
	__property bool MapCreate = {read=FMapCreate, write=FMapCreate, nodefault};
	__property bool JdbgCreate = {read=FJdbgCreate, write=FJdbgCreate, nodefault};
	__property bool JdbgInsert = {read=FJdbgInsert, write=FJdbgInsert, nodefault};
	__property bool MapDelete = {read=FMapDelete, write=FMapDelete, nodefault};
	__property Inifiles::TCustomIniFile* ConfigData = {read=FConfigData};
	__property AnsiString ConfigDataLocation = {read=FConfigDataLocation};
	__property Classes::TStrings* Globals = {read=GetGlobals};
	__property AnsiString Name = {read=GetName};
	__property TJclBorRADToolPalette* Palette = {read=GetPalette};
	__property TJclBorRADToolRepository* Repository = {read=GetRepository};
	__property AnsiString RootDir = {read=FRootDir};
	__property bool UpdateNeeded = {read=GetUpdateNeeded, nodefault};
	__property bool Valid = {read=GetValid, nodefault};
	__property AnsiString VclIncludeDir[TJclBDSPlatform APlatform] = {read=GetVclIncludeDir};
	__property int IDEVersionNumber = {read=FIDEVersionNumber, nodefault};
	__property AnsiString IDEVersionNumberStr = {read=FIDEVersionNumberStr};
	__property int VersionNumber = {read=FVersionNumber, nodefault};
	__property AnsiString VersionNumberStr = {read=FVersionNumberStr};
	__property TJclBorPersonalities Personalities = {read=FPersonalities, nodefault};
	__property bool SupportsLibSuffix = {read=GetSupportsLibSuffix, nodefault};
	__property Jclsysutils::TTextHandler OutputCallback = {read=FOutputCallback, write=SetOutputCallback};
	__property bool IsTurboExplorer = {read=GetIsTurboExplorer, nodefault};
	__property unsigned RootKey = {read=FRootKey, nodefault};
	__property bool LongPathBug = {read=GetLongPathBug, nodefault};
	__property Jclcompilerutils::TJclCompilerSettingsFormat CompilerSettingsFormat = {read=GetCompilerSettingsFormat, nodefault};
	__property bool SupportsNoConfig = {read=GetSupportsNoConfig, nodefault};
	__property bool SupportsPlatform = {read=GetSupportsPlatform, nodefault};
};



typedef TMetaClass* TJclBorRADToolInstallationClass;

class DELPHICLASS TJclBCBInstallation;
class PASCALIMPLEMENTATION TJclBCBInstallation : public TJclBorRADToolInstallation 
{
	typedef TJclBorRADToolInstallation inherited;
	
protected:
	virtual Classes::TStrings* __fastcall GetEnvironmentVariables(void);
	
public:
	__fastcall virtual TJclBCBInstallation(const AnsiString AConfigDataLocation, unsigned ARootKey);
	__fastcall virtual ~TJclBCBInstallation(void);
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall PackageSourceFileExtension() { return PackageSourceFileExtension(__classid(TJclBCBInstallation)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall PackageSourceFileExtension(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall ProjectSourceFileExtension() { return ProjectSourceFileExtension(__classid(TJclBCBInstallation)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall ProjectSourceFileExtension(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual TJclBorRADToolKind __fastcall RadToolKind() { return RadToolKind(__classid(TJclBCBInstallation)); }
	#pragma option pop
	/*         class method */ static TJclBorRADToolKind __fastcall RadToolKind(TMetaClass* vmt);
	virtual AnsiString __fastcall RadToolName();
	#pragma option push -w-inl
	/* virtual class method */ virtual int __fastcall GetLatestUpdatePackForVersion(int Version) { return GetLatestUpdatePackForVersion(__classid(TJclBCBInstallation), Version); }
	#pragma option pop
	/*         class method */ static int __fastcall GetLatestUpdatePackForVersion(TMetaClass* vmt, int Version);
};


class DELPHICLASS TJclDelphiInstallation;
class PASCALIMPLEMENTATION TJclDelphiInstallation : public TJclBorRADToolInstallation 
{
	typedef TJclBorRADToolInstallation inherited;
	
protected:
	virtual Classes::TStrings* __fastcall GetEnvironmentVariables(void);
	
public:
	__fastcall virtual TJclDelphiInstallation(const AnsiString AConfigDataLocation, unsigned ARootKey);
	__fastcall virtual ~TJclDelphiInstallation(void);
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall PackageSourceFileExtension() { return PackageSourceFileExtension(__classid(TJclDelphiInstallation)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall PackageSourceFileExtension(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall ProjectSourceFileExtension() { return ProjectSourceFileExtension(__classid(TJclDelphiInstallation)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall ProjectSourceFileExtension(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual TJclBorRADToolKind __fastcall RadToolKind() { return RadToolKind(__classid(TJclDelphiInstallation)); }
	#pragma option pop
	/*         class method */ static TJclBorRADToolKind __fastcall RadToolKind(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual int __fastcall GetLatestUpdatePackForVersion(int Version) { return GetLatestUpdatePackForVersion(__classid(TJclDelphiInstallation), Version); }
	#pragma option pop
	/*         class method */ static int __fastcall GetLatestUpdatePackForVersion(TMetaClass* vmt, int Version);
	HIDESBASE bool __fastcall InstallPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath);
	virtual AnsiString __fastcall RadToolName();
};


class DELPHICLASS TJclBDSInstallation;
class PASCALIMPLEMENTATION TJclBDSInstallation : public TJclBorRADToolInstallation 
{
	typedef TJclBorRADToolInstallation inherited;
	
private:
	bool FDualPackageInstallation;
	Jclhelputils::TJclHelp2Manager* FHelp2Manager;
	Jclcompilerutils::TJclDCCIL* FDCCIL;
	Jclcompilerutils::TJclDCC64* FDCC64;
	bool FPdbCreate;
	void __fastcall SetDualPackageInstallation(const bool Value);
	AnsiString __fastcall GetCppPathsKeyName();
	AnsiString __fastcall GetCppBrowsingPath(TJclBDSPlatform APlatform);
	AnsiString __fastcall GetRawCppBrowsingPath(TJclBDSPlatform APlatform);
	AnsiString __fastcall GetCppSearchPath(TJclBDSPlatform APlatform);
	AnsiString __fastcall GetRawCppSearchPath(TJclBDSPlatform APlatform);
	AnsiString __fastcall GetCppLibraryPath(TJclBDSPlatform APlatform);
	AnsiString __fastcall GetRawCppLibraryPath(TJclBDSPlatform APlatform);
	AnsiString __fastcall GetCppIncludePath(TJclBDSPlatform APlatform);
	AnsiString __fastcall GetRawCppIncludePath(TJclBDSPlatform APlatform);
	void __fastcall SetRawCppBrowsingPath(TJclBDSPlatform APlatform, const AnsiString Value);
	void __fastcall SetRawCppSearchPath(TJclBDSPlatform APlatform, const AnsiString Value);
	void __fastcall SetRawCppLibraryPath(TJclBDSPlatform APlatform, const AnsiString Value);
	void __fastcall SetRawCppIncludePath(TJclBDSPlatform APlatform, const AnsiString Value);
	AnsiString __fastcall GetMaxDelphiCLRVersion();
	Jclcompilerutils::TJclDCC64* __fastcall GetDCC64(void);
	Jclcompilerutils::TJclDCCIL* __fastcall GetDCCIL(void);
	AnsiString __fastcall GetMsBuildEnvOptionsFileName();
	AnsiString __fastcall GetMsBuildEnvironmentFileName();
	AnsiString __fastcall GetMsBuildEnvOption(const AnsiString OptionName, TJclBDSPlatform APlatform, bool Raw);
	void __fastcall SetMsBuildEnvOption(const AnsiString OptionName, const AnsiString Value, TJclBDSPlatform APlatform);
	AnsiString __fastcall GetBDSPlatformStr(TJclBDSPlatform APlatform);
	
protected:
	virtual AnsiString __fastcall GetDCPOutputPath(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetBPLOutputPath(TJclBDSPlatform APlatform);
	virtual Classes::TStrings* __fastcall GetEnvironmentVariables(void);
	virtual bool __fastcall CompileDelphiPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath, const AnsiString ExtraOptions)/* overload */;
	virtual bool __fastcall CompileDelphiProject(const AnsiString ProjectName, const AnsiString OutputDir, const AnsiString DcpSearchPath);
	virtual AnsiString __fastcall GetVclIncludeDir(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetName();
	virtual void __fastcall SetOutputCallback(const Jclsysutils::TTextHandler Value);
	virtual AnsiString __fastcall GetLibDebugFolderName(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetLibFolderName(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetDebugDCUPath(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetRawDebugDCUPath(TJclBDSPlatform APlatform);
	virtual void __fastcall SetRawDebugDCUPath(TJclBDSPlatform APlatform, const AnsiString Value);
	virtual AnsiString __fastcall GetLibrarySearchPath(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetRawLibrarySearchPath(TJclBDSPlatform APlatform);
	virtual void __fastcall SetRawLibrarySearchPath(TJclBDSPlatform APlatform, const AnsiString Value);
	virtual AnsiString __fastcall GetLibraryBrowsingPath(TJclBDSPlatform APlatform);
	virtual AnsiString __fastcall GetRawLibraryBrowsingPath(TJclBDSPlatform APlatform);
	virtual void __fastcall SetRawLibraryBrowsingPath(TJclBDSPlatform APlatform, const AnsiString Value);
	virtual bool __fastcall GetValid(void);
	
public:
	__fastcall virtual TJclBDSInstallation(const AnsiString AConfigDataLocation, unsigned ARootKey);
	__fastcall virtual ~TJclBDSInstallation(void);
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall PackageSourceFileExtension() { return PackageSourceFileExtension(__classid(TJclBDSInstallation)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall PackageSourceFileExtension(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual AnsiString __fastcall ProjectSourceFileExtension() { return ProjectSourceFileExtension(__classid(TJclBDSInstallation)); }
	#pragma option pop
	/*         class method */ static AnsiString __fastcall ProjectSourceFileExtension(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual TJclBorRADToolKind __fastcall RadToolKind() { return RadToolKind(__classid(TJclBDSInstallation)); }
	#pragma option pop
	/*         class method */ static TJclBorRADToolKind __fastcall RadToolKind(TMetaClass* vmt);
	#pragma option push -w-inl
	/* virtual class method */ virtual int __fastcall GetLatestUpdatePackForVersion(int Version) { return GetLatestUpdatePackForVersion(__classid(TJclBDSInstallation), Version); }
	#pragma option pop
	/*         class method */ static int __fastcall GetLatestUpdatePackForVersion(TMetaClass* vmt, int Version);
	virtual AnsiString __fastcall GetDefaultProjectsDir();
	virtual AnsiString __fastcall GetCommonProjectsDir();
	/*         class method */ static AnsiString __fastcall GetDefaultProjectsDirectory(TMetaClass* vmt, const AnsiString RootDir, int IDEVersionNumber);
	/*         class method */ static AnsiString __fastcall GetCommonProjectsDirectory(TMetaClass* vmt, const AnsiString RootDir, int IDEVersionNumber);
	virtual AnsiString __fastcall RadToolName();
	bool __fastcall AddToCppSearchPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall AddToCppBrowsingPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall AddToCppLibraryPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall AddToCppIncludePath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall RemoveFromCppSearchPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall RemoveFromCppBrowsingPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall RemoveFromCppLibraryPath(const AnsiString Path, TJclBDSPlatform APlatform);
	bool __fastcall RemoveFromCppIncludePath(const AnsiString Path, TJclBDSPlatform APlatform);
	__property AnsiString CppSearchPath[TJclBDSPlatform APlatform] = {read=GetCppSearchPath, write=SetRawCppSearchPath};
	__property AnsiString RawCppSearchPath[TJclBDSPlatform APlatform] = {read=GetRawCppSearchPath, write=SetRawCppSearchPath};
	__property AnsiString CppBrowsingPath[TJclBDSPlatform APlatform] = {read=GetCppBrowsingPath, write=SetRawCppBrowsingPath};
	__property AnsiString RawCppBrowsingPath[TJclBDSPlatform APlatform] = {read=GetRawCppBrowsingPath, write=SetRawCppBrowsingPath};
	__property AnsiString CppLibraryPath[TJclBDSPlatform APlatform] = {read=GetCppLibraryPath, write=SetRawCppLibraryPath};
	__property AnsiString RawCppLibraryPath[TJclBDSPlatform APlatform] = {read=GetRawCppLibraryPath, write=SetRawCppLibraryPath};
	__property AnsiString CppIncludePath[TJclBDSPlatform APlatform] = {read=GetCppIncludePath, write=SetRawCppIncludePath};
	__property AnsiString RawCppIncludePath[TJclBDSPlatform APlatform] = {read=GetRawCppIncludePath, write=SetRawCppIncludePath};
	virtual bool __fastcall RegisterPackage(const AnsiString BinaryFileName, const AnsiString Description)/* overload */;
	virtual bool __fastcall UnregisterPackage(const AnsiString BinaryFileName)/* overload */;
	bool __fastcall CleanPackageCache(const AnsiString BinaryFileName);
	bool __fastcall CompileDelphiDotNetProject(const AnsiString ProjectName, const AnsiString OutputDir, TJclBDSPlatform PEFormat = (TJclBDSPlatform)(0x0), const AnsiString ExtraOptions = "");
	__property bool DualPackageInstallation = {read=FDualPackageInstallation, write=SetDualPackageInstallation, nodefault};
	__property Jclhelputils::TJclHelp2Manager* Help2Manager = {read=FHelp2Manager};
	__property Jclcompilerutils::TJclDCC64* DCC64 = {read=GetDCC64};
	__property Jclcompilerutils::TJclDCCIL* DCCIL = {read=GetDCCIL};
	__property AnsiString MaxDelphiCLRVersion = {read=GetMaxDelphiCLRVersion};
	__property bool PdbCreate = {read=FPdbCreate, write=FPdbCreate, nodefault};
	
/* Hoisted overloads: */
	
protected:
	inline bool __fastcall  CompileDelphiPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString DCPPath){ return TJclBorRADToolInstallation::CompileDelphiPackage(PackageName, BPLPath, DCPPath); }
	
public:
	inline bool __fastcall  RegisterPackage(const AnsiString PackageName, const AnsiString BPLPath, const AnsiString Description){ return TJclBorRADToolInstallation::RegisterPackage(PackageName, BPLPath, Description); }
	inline bool __fastcall  UnregisterPackage(const AnsiString PackageName, const AnsiString BPLPath){ return TJclBorRADToolInstallation::UnregisterPackage(PackageName, BPLPath); }
	
};


typedef bool __fastcall (__closure *TTraverseMethod)(TJclBorRADToolInstallation* Installation);

class DELPHICLASS TJclBorRADToolInstallations;
class PASCALIMPLEMENTATION TJclBorRADToolInstallations : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	TJclBorRADToolInstallation* operator[](int Index) { return Installations[Index]; }
	
private:
	Contnrs::TObjectList* FList;
	TJclBorRADToolInstallation* __fastcall GetBDSInstallationFromVersion(int VersionNumber);
	bool __fastcall GetBDSVersionInstalled(int VersionNumber);
	int __fastcall GetCount(void);
	TJclBorRADToolInstallation* __fastcall GetInstallations(int Index);
	bool __fastcall GetBCBVersionInstalled(int VersionNumber);
	bool __fastcall GetDelphiVersionInstalled(int VersionNumber);
	TJclBorRADToolInstallation* __fastcall GetBCBInstallationFromVersion(int VersionNumber);
	TJclBorRADToolInstallation* __fastcall GetDelphiInstallationFromVersion(int VersionNumber);
	
protected:
	void __fastcall ReadInstallations(void);
	
public:
	__fastcall TJclBorRADToolInstallations(void);
	__fastcall virtual ~TJclBorRADToolInstallations(void);
	bool __fastcall AnyInstanceRunning(void);
	bool __fastcall AnyUpdatePackNeeded(AnsiString &Text);
	bool __fastcall Iterate(TTraverseMethod TraverseMethod);
	__property int Count = {read=GetCount, nodefault};
	__property TJclBorRADToolInstallation* Installations[int Index] = {read=GetInstallations/*, default*/};
	__property TJclBorRADToolInstallation* BCBInstallationFromVersion[int VersionNumber] = {read=GetBCBInstallationFromVersion};
	__property TJclBorRADToolInstallation* DelphiInstallationFromVersion[int VersionNumber] = {read=GetDelphiInstallationFromVersion};
	__property TJclBorRADToolInstallation* BDSInstallationFromVersion[int VersionNumber] = {read=GetBDSInstallationFromVersion};
	__property bool BCBVersionInstalled[int VersionNumber] = {read=GetBCBVersionInstalled};
	__property bool DelphiVersionInstalled[int VersionNumber] = {read=GetDelphiVersionInstalled};
	__property bool BDSVersionInstalled[int VersionNumber] = {read=GetBDSVersionInstalled};
};


//-- var, const, procedure ---------------------------------------------------
#define SupportedDelphiVersions (Set<Byte, 0, 255> () << 0x5 << 0x6 << 0x7 << 0x8 << 0x9 << 0xa << 0xb << 0xc << 0xe << 0xf << 0x10 )
#define SupportedBCBVersions (Set<Byte, 0, 255> () << 0x5 << 0x6 << 0xa << 0xb << 0xc << 0xe << 0xf << 0x10 )
#define SupportedBDSVersions (Set<Byte, 0, 255> () << 0x1 << 0x2 << 0x3 << 0x4 << 0x5 << 0x6 << 0x7 << 0x8 << 0x9 )
#define BorRADToolRepositoryPagesSection "Repository Pages"
#define BorRADToolRepositoryDialogsPage "Dialogs"
#define BorRADToolRepositoryFormsPage "Forms"
#define BorRADToolRepositoryProjectsPage "Projects"
#define BorRADToolRepositoryDataModulesPage "Data Modules"
#define BorRADToolRepositoryObjectType "Type"
#define BorRADToolRepositoryFormTemplate "FormTemplate"
#define BorRADToolRepositoryProjectTemplate "ProjectTemplate"
#define BorRADToolRepositoryObjectName "Name"
#define BorRADToolRepositoryObjectPage "Page"
#define BorRADToolRepositoryObjectIcon "Icon"
#define BorRADToolRepositoryObjectDescr "Description"
#define BorRADToolRepositoryObjectAuthor "Author"
#define BorRADToolRepositoryObjectAncestor "Ancestor"
#define BorRADToolRepositoryObjectDesigner "Designer"
#define BorRADToolRepositoryDesignerDfm "dfm"
#define BorRADToolRepositoryDesignerXfm "xfm"
#define BorRADToolRepositoryObjectNewForm "DefaultNewForm"
#define BorRADToolRepositoryObjectMainForm "DefaultMainForm"
#define CompilerExtensionDCP ".dcp"
#define CompilerExtensionBPI ".bpi"
#define CompilerExtensionLIB ".lib"
#define CompilerExtensionTDS ".tds"
#define CompilerExtensionMAP ".map"
#define CompilerExtensionDRC ".drc"
#define CompilerExtensionDEF ".def"
#define SourceExtensionCPP ".cpp"
#define SourceExtensionH ".h"
#define SourceExtensionPAS ".pas"
#define SourceExtensionDFM ".dfm"
#define SourceExtensionXFM ".xfm"
#define SourceDescriptionPAS "Pascal source file"
#define SourceDescriptionCPP "C++ source file"
#define DesignerVCL "VCL"
#define DesignerCLX "CLX"
#define ProjectTypePackage "package"
#define ProjectTypeLibrary "library"
#define ProjectTypeProgram "program"
#define Personality32Bit "32 bit"
#define Personality64Bit "64 bit"
#define PersonalityDelphi "Delphi"
#define PersonalityDelphiDotNet "Delphi.net"
#define PersonalityBCB "C++Builder"
#define PersonalityCSB "C#Builder"
#define PersonalityVB "Visual Basic"
#define PersonalityDesign "Design"
#define PersonalityUnknown "Unknown personality"
#define PersonalityBDS "Borland Developer Studio"
extern PACKAGE char *BorRADToolEditionIDs[4];
#define BDSPlatformWin32 "Win32"
#define BDSPlatformWin64 "Win64"
#define BDSPlatformOSX32 "OSX32"
extern PACKAGE AnsiString JclBorPersonalityDescription[12];
extern PACKAGE AnsiString JclBorDesignerDescription[2];
extern PACKAGE AnsiString JclBorDesignerFormExtension[2];

}	/* namespace Jclideutils */
using namespace Jclideutils;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclideutils

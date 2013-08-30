// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclotautils.pas' rev: 10.00

#ifndef JclotautilsHPP
#define JclotautilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Comctrls.hpp>	// Pascal unit
#include <Actnlist.hpp>	// Pascal unit
#include <Menus.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Jcldebug.hpp>	// Pascal unit
#include <Jclideutils.hpp>	// Pascal unit
#include <Toolsapi.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclotautils
{
//-- type declarations -------------------------------------------------------
typedef TControlAction TDropDownAction;
;

class DELPHICLASS EJclExpertException;
class PASCALIMPLEMENTATION EJclExpertException : public Jclbase::EJclError 
{
	typedef Jclbase::EJclError inherited;
	
private:
	Jcldebug::TJclStackInfoList* FStackInfo;
	
public:
	__fastcall virtual ~EJclExpertException(void);
	virtual void __fastcall AfterConstruction(void);
	__property Jcldebug::TJclStackInfoList* StackInfo = {read=FStackInfo};
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EJclExpertException(const AnsiString Msg) : Jclbase::EJclError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EJclExpertException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Jclbase::EJclError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EJclExpertException(int Ident)/* overload */ : Jclbase::EJclError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EJclExpertException(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Jclbase::EJclError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EJclExpertException(const AnsiString Msg, int AHelpContext) : Jclbase::EJclError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EJclExpertException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Jclbase::EJclError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EJclExpertException(int Ident, int AHelpContext)/* overload */ : Jclbase::EJclError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EJclExpertException(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Jclbase::EJclError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
};


class DELPHICLASS TJclOTASettings;
class PASCALIMPLEMENTATION TJclOTASettings : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	AnsiString FKeyName;
	AnsiString FBaseKeyName;
	
public:
	__fastcall TJclOTASettings(AnsiString ExpertName);
	bool __fastcall LoadBool(AnsiString Name, bool Def);
	AnsiString __fastcall LoadString(AnsiString Name, AnsiString Def);
	int __fastcall LoadInteger(AnsiString Name, int Def);
	void __fastcall LoadStrings(AnsiString Name, Classes::TStrings* List);
	void __fastcall SaveBool(AnsiString Name, bool Value);
	void __fastcall SaveString(AnsiString Name, AnsiString Value);
	void __fastcall SaveInteger(AnsiString Name, int Value);
	void __fastcall SaveStrings(AnsiString Name, Classes::TStrings* List);
	__property AnsiString KeyName = {read=FKeyName};
	__property AnsiString BaseKeyName = {read=FBaseKeyName};
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclOTASettings(void) { }
	#pragma option pop
	
};


__interface IJclOTAOptionsCallback;
typedef System::DelphiInterface<IJclOTAOptionsCallback> _di_IJclOTAOptionsCallback;
typedef void __fastcall (__closure *TJclOTAAddPageFunc)(Controls::TControl* AControl, AnsiString PageName, _di_IJclOTAOptionsCallback Expert);

__interface IJclOTAOptionsCallback  : public IInterface 
{
	
public:
	virtual void __fastcall AddConfigurationPages(TJclOTAAddPageFunc AddPageFunc) = 0 ;
	virtual void __fastcall ConfigurationClosed(Controls::TControl* AControl, bool SaveChanges) = 0 ;
};

class DELPHICLASS TJclOTAExpertBase;
class PASCALIMPLEMENTATION TJclOTAExpertBase : public System::TInterfacedObject 
{
	typedef System::TInterfacedObject inherited;
	
private:
	AnsiString FRootDir;
	AnsiString FJCLRootDir;
	TJclOTASettings* FSettings;
	Classes::TStrings* FJCLSettings;
	unsigned __fastcall GetModuleHInstance(void);
	AnsiString __fastcall GetRootDir();
	AnsiString __fastcall GetJCLRootDir();
	Classes::TStrings* __fastcall GetJCLSettings(void);
	void __fastcall ReadEnvVariables(Classes::TStrings* EnvVariables);
	void __fastcall ConfigurationActionUpdate(System::TObject* Sender);
	void __fastcall ConfigurationActionExecute(System::TObject* Sender);
	Jclideutils::TJclBorPersonality __fastcall GetActivePersonality(void);
	AnsiString __fastcall GetDesigner();
	
public:
	/*         class method */ static Toolsapi::_di_INTAServices __fastcall GetNTAServices(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAServices __fastcall GetOTAServices(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTADebuggerServices __fastcall GetOTADebuggerServices(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAModuleServices __fastcall GetOTAModuleServices(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAPackageServices __fastcall GetOTAPackageServices(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAPersonalityServices __fastcall GetOTAPersonalityServices(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAGalleryCategoryManager __fastcall GetOTAGalleryCategoryManager(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAProjectManager __fastcall GetOTAProjectManager(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAMessageServices __fastcall GetOTAMessageServices(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAWizardServices __fastcall GetOTAWizardServices(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAProject __fastcall GetActiveProject(TMetaClass* vmt);
	/*         class method */ static Toolsapi::_di_IOTAProjectGroup __fastcall GetProjectGroup(TMetaClass* vmt);
	/*         class method */ static bool __fastcall IsPersonalityLoaded(TMetaClass* vmt, const AnsiString PersonalityName);
	/*         class method */ static void __fastcall AddExpert(TMetaClass* vmt, TJclOTAExpertBase* AExpert);
	/*         class method */ static void __fastcall RemoveExpert(TMetaClass* vmt, TJclOTAExpertBase* AExpert);
	/*         class method */ static int __fastcall GetExpertCount(TMetaClass* vmt);
	/*         class method */ static TJclOTAExpertBase* __fastcall GetExpert(TMetaClass* vmt, int Index);
	/*         class method */ static bool __fastcall ConfigurationDialog(TMetaClass* vmt, AnsiString StartName = "");
	/*         class method */ static void __fastcall CheckToolBarButton(TMetaClass* vmt, Comctrls::TToolBar* AToolBar, Actnlist::TCustomAction* AAction);
	/*         class method */ static int __fastcall GetActionCount(TMetaClass* vmt);
	/*         class method */ static Actnlist::TAction* __fastcall GetAction(TMetaClass* vmt, int Index);
	/*         class method */ static TJclOTASettings* __fastcall ActionSettings(TMetaClass* vmt);
	__fastcall virtual TJclOTAExpertBase(AnsiString AName);
	__fastcall virtual ~TJclOTAExpertBase(void);
	virtual void __fastcall AfterConstruction(void);
	virtual void __fastcall BeforeDestruction(void);
	bool __fastcall FindExecutableName(const AnsiString MapFileName, const AnsiString OutputDirectory, AnsiString &ExecutableFileName);
	AnsiString __fastcall GetDrcFileName(const Toolsapi::_di_IOTAProject Project);
	AnsiString __fastcall GetMapFileName(const Toolsapi::_di_IOTAProject Project);
	AnsiString __fastcall GetOutputDirectory(const Toolsapi::_di_IOTAProject Project);
	bool __fastcall IsInstalledPackage(const Toolsapi::_di_IOTAProject Project);
	bool __fastcall IsPackage(const Toolsapi::_di_IOTAProject Project);
	virtual void __fastcall AddConfigurationPages(TJclOTAAddPageFunc AddPageFunc);
	virtual void __fastcall ConfigurationClosed(Controls::TControl* AControl, bool SaveChanges);
	virtual void __fastcall RegisterCommands(void);
	virtual void __fastcall UnregisterCommands(void);
	void __fastcall RegisterAction(Actnlist::TCustomAction* Action);
	void __fastcall UnregisterAction(Actnlist::TCustomAction* Action);
	__property TJclOTASettings* Settings = {read=FSettings};
	__property AnsiString JCLRootDir = {read=GetJCLRootDir};
	__property Classes::TStrings* JCLSettings = {read=GetJCLSettings};
	__property AnsiString RootDir = {read=GetRootDir};
	__property Jclideutils::TJclBorPersonality ActivePersonality = {read=GetActivePersonality, nodefault};
	__property AnsiString Designer = {read=GetDesigner};
	__property unsigned ModuleHInstance = {read=GetModuleHInstance, nodefault};
private:
	void *__IJclOTAOptionsCallback;	/* Jclotautils::IJclOTAOptionsCallback */
	
public:
	operator IJclOTAOptionsCallback*(void) { return (IJclOTAOptionsCallback*)&__IJclOTAOptionsCallback; }
	
};


class DELPHICLASS TJclOTAExpert;
class PASCALIMPLEMENTATION TJclOTAExpert : public TJclOTAExpertBase 
{
	typedef TJclOTAExpertBase inherited;
	
public:
	virtual void __fastcall AfterSave(void);
	virtual void __fastcall BeforeSave(void);
	virtual void __fastcall Destroyed(void);
	virtual void __fastcall Modified(void);
	virtual void __fastcall Execute(void);
	virtual AnsiString __fastcall GetIDString();
	virtual AnsiString __fastcall GetName();
	virtual Toolsapi::TWizardState __fastcall GetState(void);
public:
	#pragma option push -w-inl
	/* TJclOTAExpertBase.Create */ inline __fastcall virtual TJclOTAExpert(AnsiString AName) : TJclOTAExpertBase(AName) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TJclOTAExpertBase.Destroy */ inline __fastcall virtual ~TJclOTAExpert(void) { }
	#pragma option pop
	
private:
	void *__IOTAWizard;	/* Toolsapi::IOTAWizard */
	
public:
	operator IOTANotifier*(void) { return (IOTANotifier*)&__IOTAWizard; }
	operator IOTAWizard*(void) { return (IOTAWizard*)&__IOTAWizard; }
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE bool JclDisablePostCompilationProcess;
extern PACKAGE bool __fastcall JclExpertShowExceptionDialog(System::TObject* AExceptionObj);
extern PACKAGE Jclideutils::TJclBorPersonality __fastcall PersonalityTextToId(const AnsiString PersonalityText);
extern PACKAGE Jclbase::TDynAnsiStringArray __fastcall GetProjectProperties(const Toolsapi::_di_IOTAProject AProject, const Jclbase::TDynAnsiStringArray PropIDs);
extern PACKAGE int __fastcall SetProjectProperties(const Toolsapi::_di_IOTAProject AProject, const Jclbase::TDynAnsiStringArray PropIDs, const Jclbase::TDynAnsiStringArray PropValues);
extern PACKAGE void __fastcall RegisterAboutBox(void);
extern PACKAGE void __fastcall RegisterSplashScreen(void);

}	/* namespace Jclotautils */
using namespace Jclotautils;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclotautils

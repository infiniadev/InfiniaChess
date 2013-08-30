// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclversioncontrolimpl.pas' rev: 10.00

#ifndef JclversioncontrolimplHPP
#define JclversioncontrolimplHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Menus.hpp>	// Pascal unit
#include <Actnlist.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Toolsapi.hpp>	// Pascal unit
#include <Jclversioncontrol.hpp>	// Pascal unit
#include <Jclotautils.hpp>	// Pascal unit
#include <Jclversionctrlcommonoptions.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclversioncontrolimpl
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclVersionControlStandardAction;
class PASCALIMPLEMENTATION TJclVersionControlStandardAction : public Actnlist::TCustomAction 
{
	typedef Actnlist::TCustomAction inherited;
	
private:
	Jclversioncontrol::TJclVersionControlActionType FControlAction;
	
public:
	__property Jclversioncontrol::TJclVersionControlActionType ControlAction = {read=FControlAction, write=FControlAction, nodefault};
public:
	#pragma option push -w-inl
	/* TCustomAction.Create */ inline __fastcall virtual TJclVersionControlStandardAction(Classes::TComponent* AOwner) : Actnlist::TCustomAction(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomAction.Destroy */ inline __fastcall virtual ~TJclVersionControlStandardAction(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclVersionControlDropDownAction;
class PASCALIMPLEMENTATION TJclVersionControlDropDownAction : public Controls::TControlAction 
{
	typedef Controls::TControlAction inherited;
	
private:
	Jclversioncontrol::TJclVersionControlActionType FControlAction;
	
public:
	__property Jclversioncontrol::TJclVersionControlActionType ControlAction = {read=FControlAction, write=FControlAction, nodefault};
public:
	#pragma option push -w-inl
	/* TCustomAction.Create */ inline __fastcall virtual TJclVersionControlDropDownAction(Classes::TComponent* AOwner) : Controls::TControlAction(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomAction.Destroy */ inline __fastcall virtual ~TJclVersionControlDropDownAction(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclVersionControlExpert;
class PASCALIMPLEMENTATION TJclVersionControlExpert : public Jclotautils::TJclOTAExpert 
{
	typedef Jclotautils::TJclOTAExpert inherited;
	
private:
	Menus::TMenuItem* FVersionCtrlMenu;
	Actnlist::TCustomAction* FActions[36];
	int FIconIndexes[36];
	bool FHideActions;
	Jclversionctrlcommonoptions::TIconType FIconType;
	bool FActOnTopSandbox;
	bool FSaveConfirmation;
	bool FDisableActions;
	Jclversionctrlcommonoptions::TJclVersionCtrlOptionsFrame* FOptionsFrame;
	Classes::TStringList* FMenuOrganization;
	void __fastcall SetIconType(const Jclversionctrlcommonoptions::TIconType Value);
	void __fastcall ActionUpdate(System::TObject* Sender);
	void __fastcall ActionExecute(System::TObject* Sender);
	void __fastcall IDEActionMenuClick(System::TObject* Sender);
	void __fastcall SubItemClick(System::TObject* Sender);
	void __fastcall DropDownMenuPopup(System::TObject* Sender);
	void __fastcall IDEVersionCtrlMenuClick(System::TObject* Sender);
	void __fastcall RefreshIcons(void);
	void __fastcall RefreshMenu(void);
	Jclversioncontrol::TJclVersionControlCache* __fastcall GetCurrentCache(void);
	Jclversioncontrol::TJclVersionControlPlugin* __fastcall GetCurrentPlugin(void);
	AnsiString __fastcall GetCurrentFileName();
	
public:
	__fastcall TJclVersionControlExpert(void);
	__fastcall virtual ~TJclVersionControlExpert(void);
	virtual void __fastcall RegisterCommands(void);
	virtual void __fastcall UnregisterCommands(void);
	virtual void __fastcall AddConfigurationPages(Jclotautils::TJclOTAAddPageFunc AddPageFunc);
	virtual void __fastcall ConfigurationClosed(Controls::TControl* AControl, bool SaveChanges);
	bool __fastcall SaveModules(const AnsiString FileName, const bool IncludeSubDirectories);
	__property bool ActOnTopSandbox = {read=FActOnTopSandbox, write=FActOnTopSandbox, nodefault};
	__property bool DisableActions = {read=FDisableActions, write=FDisableActions, nodefault};
	__property bool HideActions = {read=FHideActions, write=FHideActions, nodefault};
	__property bool SaveConfirmation = {read=FSaveConfirmation, write=FSaveConfirmation, nodefault};
	__property Jclversionctrlcommonoptions::TIconType IconType = {read=FIconType, write=SetIconType, nodefault};
	__property Jclversioncontrol::TJclVersionControlCache* CurrentCache = {read=GetCurrentCache};
	__property Jclversioncontrol::TJclVersionControlPlugin* CurrentPlugin = {read=GetCurrentPlugin};
	__property AnsiString CurrentFileName = {read=GetCurrentFileName};
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE bool __fastcall CharIsAmpersand(const char C);
extern PACKAGE void __fastcall Register(void);
extern PACKAGE bool __stdcall JCLWizardInit(const Toolsapi::_di_IBorlandIDEServices BorlandIDEServices, Toolsapi::TWizardRegisterProc RegisterProc, Toolsapi::TWizardTerminateProc &TerminateProc);
extern PACKAGE int __fastcall GetItemIndexA(const AnsiString Item);
extern PACKAGE int __fastcall GetItemIndexB(const AnsiString Item);
extern PACKAGE AnsiString __fastcall GetItemName(const AnsiString Item);

}	/* namespace Jclversioncontrolimpl */
using namespace Jclversioncontrolimpl;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclversioncontrolimpl

// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorcontainertemplates.pas' rev: 10.00

#ifndef JclpreprocessorcontainertemplatesHPP
#define JclpreprocessorcontainertemplatesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Jclideutils.hpp>	// Pascal unit
#include <Jclpreprocessortemplates.hpp>	// Pascal unit
#include <Jclpreprocessorcontainertypes.hpp>	// Pascal unit
#include <Jclpreprocessorcontainer1dtemplates.hpp>	// Pascal unit
#include <Jclpreprocessorcontainer2dtemplates.hpp>	// Pascal unit
#include <Jclpreprocessorparser.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessorcontainertemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclContainerParams;
class PASCALIMPLEMENTATION TJclContainerParams : public Jclpreprocessortemplates::TJclTemplateParams 
{
	typedef Jclpreprocessortemplates::TJclTemplateParams inherited;
	
private:
	Jclpreprocessorcontainer1dtemplates::TJclContainerTypeInfo* FTypeInfo;
	int FAllTypeIndex;
	int FTrueTypeIndex;
	Jclpreprocessorcontainer2dtemplates::TJclContainerMapInfo* FMapInfo;
	int FAllMapIndex;
	int FTrueMapIndex;
	int __fastcall GetAllTypeCount(void);
	int __fastcall GetHelpAllTypeCount(void);
	int __fastcall GetTrueTypeCount(void);
	int __fastcall GetHelpTrueTypeCount(void);
	void __fastcall SetAllTypeIndex(const int Value);
	void __fastcall SetTrueTypeIndex(const int Value);
	int __fastcall GetAllMapCount(void);
	int __fastcall GetHelpAllMapCount(void);
	int __fastcall GetTrueMapCount(void);
	int __fastcall GetHelpTrueMapCount(void);
	void __fastcall SetAllMapIndex(const int Value);
	void __fastcall SetMapTypeIndex(const int Value);
	
protected:
	AnsiString __fastcall ProcessConditional(const AnsiString MacroText, Jclpreprocessorcontainer1dtemplates::TJclContainerTypeInfo* ContainerTypeInfo);
	void __fastcall ProcessDefines(const AnsiString Prefix, const AnsiString Defines, const AnsiString Undefs);
	
public:
	__fastcall TJclContainerParams(void);
	__fastcall virtual ~TJclContainerParams(void);
	virtual AnsiString __fastcall ExpandMacro(const AnsiString AName, const Jclbase::TDynStringArray ParamValues);
	
__published:
	__property int AllTypeIndex = {read=FAllTypeIndex, write=SetAllTypeIndex, nodefault};
	__property int AllTypeCount = {read=GetAllTypeCount, nodefault};
	__property int HelpAllTypeCount = {read=GetHelpAllTypeCount, nodefault};
	__property int TrueTypeIndex = {read=FTrueTypeIndex, write=SetTrueTypeIndex, nodefault};
	__property int TrueTypeCount = {read=GetTrueTypeCount, nodefault};
	__property int HelpTrueTypeCount = {read=GetHelpTrueTypeCount, nodefault};
	__property int AllMapIndex = {read=FAllMapIndex, write=SetAllMapIndex, nodefault};
	__property int AllMapCount = {read=GetAllMapCount, nodefault};
	__property int HelpAllMapCount = {read=GetHelpAllMapCount, nodefault};
	__property int TrueMapIndex = {read=FTrueMapIndex, write=SetMapTypeIndex, nodefault};
	__property int TrueMapCount = {read=GetTrueMapCount, nodefault};
	__property int HelpTrueMapCount = {read=GetHelpTrueMapCount, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall RegisterContainerParams(const AnsiString PrototypeName, TMetaClass* InterfaceParamsClass)/* overload */;
extern PACKAGE void __fastcall RegisterContainerParams(const AnsiString PrototypeName, TMetaClass* ImplementationParamsClass, TMetaClass* InterfaceParamsClass)/* overload */;
extern PACKAGE void __fastcall FindContainerParams(const AnsiString PrototypeName, /* out */ TMetaClass* &InterfaceParamsClass, /* out */ TMetaClass* &ImplementationParamsClass);
extern PACKAGE void __fastcall CheckJclContainers(void);

}	/* namespace Jclpreprocessorcontainertemplates */
using namespace Jclpreprocessorcontainertemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorcontainertemplates

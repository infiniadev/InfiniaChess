// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorarraysetstemplates.pas' rev: 10.00

#ifndef JclpreprocessorarraysetstemplatesHPP
#define JclpreprocessorarraysetstemplatesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Jclpreprocessorcontainertypes.hpp>	// Pascal unit
#include <Jclpreprocessorcontainertemplates.hpp>	// Pascal unit
#include <Jclpreprocessorcontainer1dtemplates.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessorarraysetstemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclArraySetIntParams;
class PASCALIMPLEMENTATION TJclArraySetIntParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams inherited;
	
protected:
	virtual AnsiString __fastcall GetInterfaceAdditional();
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=65};
	__property AnsiString AncestorClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=56};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString ComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=35};
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString ArrayInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=54};
	__property AnsiString SetInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=63};
	__property InterfaceAdditional ;
	__property SectionAdditional ;
	__property CollectionFlags ;
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclArraySetIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclArraySetIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclArraySetImpParams;
class PASCALIMPLEMENTATION TJclArraySetImpParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams inherited;
	
public:
	virtual AnsiString __fastcall GetConstructorParameters();
	virtual AnsiString __fastcall GetSelfClassName();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=65};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property MacroFooter ;
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclArraySetImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclArraySetImpParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorarraysetstemplates */
using namespace Jclpreprocessorarraysetstemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorarraysetstemplates

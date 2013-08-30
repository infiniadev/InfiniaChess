// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorvectorstemplates.pas' rev: 10.00

#ifndef JclpreprocessorvectorstemplatesHPP
#define JclpreprocessorvectorstemplatesHPP

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

namespace Jclpreprocessorvectorstemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclVectorIntParams;
class PASCALIMPLEMENTATION TJclVectorIntParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams inherited;
	
protected:
	virtual AnsiString __fastcall GetInterfaceAdditional();
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=61};
	__property AncestorClassName ;
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString ArrayInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=54};
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property InterfaceAdditional ;
	__property SectionAdditional ;
	__property CollectionFlags ;
	__property OwnershipDeclaration ;
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DynArrayType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=17};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclVectorIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclVectorIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclVectorItrIntParams;
class PASCALIMPLEMENTATION TJclVectorItrIntParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=62};
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ListClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=61};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclVectorItrIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclVectorItrIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclVectorImpParams;
class PASCALIMPLEMENTATION TJclVectorImpParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams inherited;
	
public:
	virtual AnsiString __fastcall GetConstructorParameters();
	virtual AnsiString __fastcall GetSelfClassName();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=61};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=62};
	__property OwnershipDeclaration ;
	__property AnsiString OwnershipParameter = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=8};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
	__property AnsiString ReleaserName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=11};
	__property MacroFooter ;
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclVectorImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclVectorImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclVectorItrImpParams;
class PASCALIMPLEMENTATION TJclVectorItrImpParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams inherited;
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=62};
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ListClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=61};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclVectorItrImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclVectorItrImpParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorvectorstemplates */
using namespace Jclpreprocessorvectorstemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorvectorstemplates

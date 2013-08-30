// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessortreestemplates.pas' rev: 10.00

#ifndef JclpreprocessortreestemplatesHPP
#define JclpreprocessortreestemplatesHPP

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

namespace Jclpreprocessortreestemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclTreeTypeIntParams;
class PASCALIMPLEMENTATION TJclTreeTypeIntParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=70};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclTreeTypeIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclTreeTypeIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclTreeIntParams;
class PASCALIMPLEMENTATION TJclTreeIntParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams inherited;
	
protected:
	virtual AnsiString __fastcall GetOwnershipDeclaration();
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=70};
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=71};
	__property AncestorClassName ;
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString TreeInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=68};
	__property AnsiString StdItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString TreeItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=66};
	__property InterfaceAdditional ;
	__property SectionAdditional ;
	__property OwnershipDeclaration ;
	__property CollectionFlags ;
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclTreeIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclTreeIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclTreeItrIntParams;
class PASCALIMPLEMENTATION TJclTreeItrIntParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString BaseItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=72};
	__property AnsiString PreOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=73};
	__property AnsiString PostOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=74};
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=70};
	__property AnsiString TreeClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=71};
	__property AnsiString StdItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString TreeItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=66};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclTreeItrIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclTreeItrIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclTreeTypeImpParams;
class PASCALIMPLEMENTATION TJclTreeTypeImpParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams inherited;
	
__published:
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=70};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclTreeTypeImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclTreeTypeImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclTreeImpParams;
class PASCALIMPLEMENTATION TJclTreeImpParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams inherited;
	
protected:
	virtual AnsiString __fastcall GetConstructorParameters();
	virtual AnsiString __fastcall GetSelfClassName();
	virtual AnsiString __fastcall GetOwnershipDeclaration();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=71};
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=70};
	__property AnsiString PreOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=73};
	__property AnsiString PostOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=74};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString StdItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString TreeItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=66};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property OwnershipDeclaration ;
	__property AnsiString OwnershipParameter = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=8};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
	__property AnsiString ReleaserName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=11};
	__property MacroFooter ;
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclTreeImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclTreeImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclTreeItrImpParams;
class PASCALIMPLEMENTATION TJclTreeItrImpParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams inherited;
	
__published:
	__property AnsiString BaseItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=72};
	__property AnsiString PreOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=73};
	__property AnsiString PostOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=74};
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=70};
	__property AnsiString TreeClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=71};
	__property AnsiString StdItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString TreeItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=66};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
	__property AnsiString ReleaserName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=11};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclTreeItrImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclTreeItrImpParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessortreestemplates */
using namespace Jclpreprocessortreestemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessortreestemplates

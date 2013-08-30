// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorlinkedliststemplates.pas' rev: 10.00

#ifndef JclpreprocessorlinkedliststemplatesHPP
#define JclpreprocessorlinkedliststemplatesHPP

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

namespace Jclpreprocessorlinkedliststemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclLinkedListTypeIntParams;
class PASCALIMPLEMENTATION TJclLinkedListTypeIntParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString ItemClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=58};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclLinkedListTypeIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclLinkedListTypeIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclLinkedListIntParams;
class PASCALIMPLEMENTATION TJclLinkedListIntParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams inherited;
	
protected:
	virtual AnsiString __fastcall GetInterfaceAdditional();
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString ItemClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=58};
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=59};
	__property AncestorClassName ;
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property InterfaceAdditional ;
	__property SectionAdditional ;
	__property CollectionFlags ;
	__property OwnershipDeclaration ;
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclLinkedListIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclLinkedListIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclLinkedListItrIntParams;
class PASCALIMPLEMENTATION TJclLinkedListItrIntParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=60};
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ListClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=59};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString ItemClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=58};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclLinkedListItrIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclLinkedListItrIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclLinkedListImpParams;
class PASCALIMPLEMENTATION TJclLinkedListImpParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams inherited;
	
public:
	virtual AnsiString __fastcall GetConstructorParameters();
	virtual AnsiString __fastcall GetSelfClassName();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=59};
	__property AnsiString ItemClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=58};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=60};
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
	/* TJclImplementationParams.Create */ inline __fastcall TJclLinkedListImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclLinkedListImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclLinkedListItrImpParams;
class PASCALIMPLEMENTATION TJclLinkedListItrImpParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams inherited;
	
private:
	AnsiString FReleaserCall;
	AnsiString __fastcall GetReleaserCall();
	
public:
	virtual void __fastcall ResetDefault(bool Value);
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=60};
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ListClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=59};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString ItemClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=58};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
	__property AnsiString ReleaserCall = {read=GetReleaserCall, write=FReleaserCall};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclLinkedListItrImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclLinkedListItrImpParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorlinkedliststemplates */
using namespace Jclpreprocessorlinkedliststemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorlinkedliststemplates

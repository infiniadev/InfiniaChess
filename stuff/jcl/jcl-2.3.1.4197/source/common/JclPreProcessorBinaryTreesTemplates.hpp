// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorbinarytreestemplates.pas' rev: 10.00

#ifndef JclpreprocessorbinarytreestemplatesHPP
#define JclpreprocessorbinarytreestemplatesHPP

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

namespace Jclpreprocessorbinarytreestemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclBinaryTreeTypeIntParams;
class PASCALIMPLEMENTATION TJclBinaryTreeTypeIntParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=43};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclBinaryTreeTypeIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBinaryTreeTypeIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclBinaryTreeIntParams;
class PASCALIMPLEMENTATION TJclBinaryTreeIntParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams inherited;
	
private:
	AnsiString FConstructorDeclarations;
	
protected:
	AnsiString __fastcall GetConstructorDeclarations();
	virtual AnsiString __fastcall GetInterfaceAdditional();
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	virtual void __fastcall ResetDefault(bool Value);
	
__published:
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=43};
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=44};
	__property AncestorClassName ;
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString CompareFunctionName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString ComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=35};
	__property AnsiString TreeInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=68};
	__property AnsiString StdItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString TreeItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=66};
	__property InterfaceAdditional ;
	__property SectionAdditional ;
	__property AnsiString ConstructorDeclarations = {read=GetConstructorDeclarations, write=FConstructorDeclarations};
	__property OwnershipDeclaration ;
	__property CollectionFlags ;
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclBinaryTreeIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclCollectionInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBinaryTreeIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclBinaryTreeItrIntParams;
class PASCALIMPLEMENTATION TJclBinaryTreeItrIntParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString BaseItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=45};
	__property AnsiString PreOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=46};
	__property AnsiString InOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=47};
	__property AnsiString PostOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=48};
	__property AnsiString StdItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString StdTreeItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=66};
	__property AnsiString BinTreeItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=41};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=43};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclBinaryTreeItrIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBinaryTreeItrIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclBinaryTreeImpParams;
class PASCALIMPLEMENTATION TJclBinaryTreeImpParams : public Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams inherited;
	
private:
	AnsiString FConstructorAssignments;
	AnsiString FConstructorDeclarations;
	
protected:
	AnsiString __fastcall GetConstructorAssignments();
	AnsiString __fastcall GetConstructorDeclarations();
	
public:
	virtual AnsiString __fastcall GetConstructorParameters();
	virtual AnsiString __fastcall GetSelfClassName();
	virtual void __fastcall ResetDefault(bool Value);
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=44};
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=43};
	__property AnsiString PreOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=46};
	__property AnsiString InOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=47};
	__property AnsiString PostOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=48};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString StdItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString TreeItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=66};
	__property AnsiString ConstructorDeclarations = {read=GetConstructorDeclarations, write=FConstructorDeclarations};
	__property AnsiString ConstructorAssignments = {read=GetConstructorAssignments, write=FConstructorAssignments};
	__property AnsiString CompareFunctionName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
	__property OwnershipDeclaration ;
	__property AnsiString OwnershipParameter = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=8};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString ReleaserName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=11};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
	__property MacroFooter ;
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclBinaryTreeImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclCollectionImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBinaryTreeImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclBinaryTreeItrImpParams;
class PASCALIMPLEMENTATION TJclBinaryTreeItrImpParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams inherited;
	
__published:
	__property AnsiString BaseItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=45};
	__property AnsiString PreOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=46};
	__property AnsiString InOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=47};
	__property AnsiString PostOrderItrClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=48};
	__property AnsiString StdItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property AnsiString NodeTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=43};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=6};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
	__property AnsiString ReleaserName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=11};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclBinaryTreeItrImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBinaryTreeItrImpParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorbinarytreestemplates */
using namespace Jclpreprocessorbinarytreestemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorbinarytreestemplates

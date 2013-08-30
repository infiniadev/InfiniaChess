// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorcontainer1dtemplates.pas' rev: 10.00

#ifndef Jclpreprocessorcontainer1dtemplatesHPP
#define Jclpreprocessorcontainer1dtemplatesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Jclpreprocessorcontainertypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessorcontainer1dtemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclContainerTypeInfo;
class PASCALIMPLEMENTATION TJclContainerTypeInfo : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	AnsiString FCustomTypeAttributes[83];
	Jclpreprocessorcontainertypes::TTypeAttributes *FKnownTypeAttributes;
	Classes::TNotifyEvent FOnKnownTypeChange;
	AnsiString __fastcall GetCustomTypeAttribute(TTypeAttributeID Index);
	AnsiString __fastcall GetTypeName();
	
protected:
	bool __fastcall GetFloatType(void);
	bool __fastcall GetKnownType(void);
	AnsiString __fastcall GetOwnershipDeclaration();
	bool __fastcall GetStringType(void);
	bool __fastcall GetTObjectType(void);
	AnsiString __fastcall GetTypeAttribute(TTypeAttributeID Index);
	void __fastcall SetKnownType(bool Value);
	void __fastcall SetTypeAttribute(TTypeAttributeID Index, const AnsiString Value);
	void __fastcall SetTypeName(const AnsiString Value);
	
public:
	__property bool FloatType = {read=GetFloatType, nodefault};
	__property bool KnownType = {read=GetKnownType, write=SetKnownType, nodefault};
	__property bool StringType = {read=GetStringType, nodefault};
	__property bool TObjectType = {read=GetTObjectType, nodefault};
	__property Jclpreprocessorcontainertypes::PKnownTypeAttributes KnownTypeAttributes = {read=FKnownTypeAttributes};
	__property AnsiString CustomTypeAttributes[TTypeAttributeID Index] = {read=GetCustomTypeAttribute};
	__property AnsiString TypeAttributes[TTypeAttributeID Index] = {read=GetTypeAttribute, write=SetTypeAttribute};
	__property AnsiString TypeName = {read=GetTypeName, write=SetTypeName, stored=true};
	__property AnsiString OwnershipDeclaration = {read=GetOwnershipDeclaration};
	__property Classes::TNotifyEvent OnKnownTypeChange = {read=FOnKnownTypeChange, write=FOnKnownTypeChange};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclContainerTypeInfo(void) : System::TObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclContainerTypeInfo(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclContainerInterfaceParams;
class PASCALIMPLEMENTATION TJclContainerInterfaceParams : public Jclpreprocessorcontainertypes::TJclInterfaceParams 
{
	typedef Jclpreprocessorcontainertypes::TJclInterfaceParams inherited;
	
private:
	TJclContainerTypeInfo* FTypeInfo;
	
protected:
	virtual AnsiString __fastcall GetOwnershipDeclaration();
	AnsiString __fastcall GetTypeAttribute(TTypeAttributeID Index);
	bool __fastcall IsTypeAttributeStored(TTypeAttributeID Index);
	void __fastcall SetTypeAttribute(TTypeAttributeID Index, const AnsiString Value);
	
public:
	__property TJclContainerTypeInfo* TypeInfo = {read=FTypeInfo, write=FTypeInfo};
	__property AnsiString OwnershipDeclaration = {read=GetOwnershipDeclaration};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclContainerInterfaceParams(void) : Jclpreprocessorcontainertypes::TJclInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclContainerInterfaceParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclClassInterfaceParams;
class PASCALIMPLEMENTATION TJclClassInterfaceParams : public TJclContainerInterfaceParams 
{
	typedef TJclContainerInterfaceParams inherited;
	
protected:
	AnsiString FAncestorClassName;
	AnsiString FInterfaceAdditional;
	AnsiString FSectionAdditional;
	virtual AnsiString __fastcall GetAncestorClassName();
	virtual AnsiString __fastcall GetInterfaceAdditional();
	virtual AnsiString __fastcall GetSectionAdditional();
	
public:
	__property AnsiString AncestorClassName = {read=GetAncestorClassName, write=FAncestorClassName};
	__property AnsiString InterfaceAdditional = {read=GetInterfaceAdditional, write=FInterfaceAdditional};
	__property AnsiString SectionAdditional = {read=GetSectionAdditional, write=FSectionAdditional};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclClassInterfaceParams(void) : TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclClassInterfaceParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCollectionInterfaceParams;
class PASCALIMPLEMENTATION TJclCollectionInterfaceParams : public TJclClassInterfaceParams 
{
	typedef TJclClassInterfaceParams inherited;
	
protected:
	AnsiString FCollectionFlags;
	virtual AnsiString __fastcall GetAncestorClassName();
	virtual AnsiString __fastcall GetCollectionFlags();
	virtual AnsiString __fastcall GetInterfaceAdditional();
	
public:
	__property AnsiString CollectionFlags = {read=GetCollectionFlags, write=FCollectionFlags};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclCollectionInterfaceParams(void) : TJclClassInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCollectionInterfaceParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclTypeParams;
class PASCALIMPLEMENTATION TJclTypeParams : public TJclContainerInterfaceParams 
{
	typedef TJclContainerInterfaceParams inherited;
	
__published:
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=0};
	__property AnsiString Condition = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=1};
	__property AnsiString Defines = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=2};
	__property AnsiString Undefs = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=3};
	__property AnsiString Alias = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=4};
	__property AnsiString AliasCondition = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=5};
	__property AnsiString DefaultValue = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=6};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=7};
	__property AnsiString OwnershipParameter = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=8};
	__property AnsiString ReleaserName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=11};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=15};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=16};
	__property AnsiString DynArrayTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=17};
	__property AnsiString ArrayName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=18};
	__property AnsiString BaseContainer = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=19};
	__property AnsiString BaseCollection = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=20};
	__property AnsiString ContainerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=29};
	__property AnsiString ContainerInterfaceGUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=30};
	__property AnsiString FlatContainerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=31};
	__property AnsiString FlatContainerInterfaceGUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=32};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclTypeParams(void) : TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclTypeParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclContainerImplementationParams;
class PASCALIMPLEMENTATION TJclContainerImplementationParams : public Jclpreprocessorcontainertypes::TJclImplementationParams 
{
	typedef Jclpreprocessorcontainertypes::TJclImplementationParams inherited;
	
private:
	TJclContainerTypeInfo* __fastcall GetTypeInfo(void);
	
protected:
	virtual AnsiString __fastcall GetOwnershipDeclaration();
	AnsiString __fastcall GetTypeAttribute(TTypeAttributeID Index);
	bool __fastcall IsTypeAttributeStored(TTypeAttributeID Index);
	void __fastcall SetTypeAttribute(TTypeAttributeID Index, const AnsiString Value);
	
public:
	__property AnsiString OwnershipDeclaration = {read=GetOwnershipDeclaration};
	__property TJclContainerTypeInfo* TypeInfo = {read=GetTypeInfo};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclContainerImplementationParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainertypes::TJclImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclContainerImplementationParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclClassImplementationParams;
class PASCALIMPLEMENTATION TJclClassImplementationParams : public TJclContainerImplementationParams 
{
	typedef TJclContainerImplementationParams inherited;
	
protected:
	AnsiString FMacroFooter;
	virtual AnsiString __fastcall GetConstructorParameters(void) = 0 ;
	virtual AnsiString __fastcall GetSelfClassName(void) = 0 ;
	
public:
	virtual AnsiString __fastcall GetMacroFooter();
	virtual void __fastcall ResetDefault(bool Value);
	__property AnsiString MacroFooter = {read=GetMacroFooter, write=FMacroFooter};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclClassImplementationParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclContainerImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclClassImplementationParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCollectionImplementationParams;
class PASCALIMPLEMENTATION TJclCollectionImplementationParams : public TJclClassImplementationParams 
{
	typedef TJclClassImplementationParams inherited;
	
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclCollectionImplementationParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclClassImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCollectionImplementationParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorcontainer1dtemplates */
using namespace Jclpreprocessorcontainer1dtemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorcontainer1dtemplates

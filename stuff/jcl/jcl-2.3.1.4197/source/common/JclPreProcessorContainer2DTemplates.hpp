// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorcontainer2dtemplates.pas' rev: 10.00

#ifndef Jclpreprocessorcontainer2dtemplatesHPP
#define Jclpreprocessorcontainer2dtemplatesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Jclpreprocessorcontainertypes.hpp>	// Pascal unit
#include <Jclpreprocessorcontainer1dtemplates.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessorcontainer2dtemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclContainerMapInfo;
class PASCALIMPLEMENTATION TJclContainerMapInfo : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	AnsiString FCustomMapAttributes[11];
	Jclpreprocessorcontainertypes::TKnownMapAttributes *FKnownMapAttributes;
	Jclpreprocessorcontainer1dtemplates::TJclContainerTypeInfo* FValueTypeInfo;
	Jclpreprocessorcontainer1dtemplates::TJclContainerTypeInfo* FKeyTypeInfo;
	AnsiString __fastcall GetCustomMapAttribute(TMapAttributeID Index);
	AnsiString __fastcall GetKeyAttribute(TKeyAttributeID Index);
	AnsiString __fastcall GetValueAttribute(TValueAttributeID Index);
	void __fastcall SetKeyAttribute(TKeyAttributeID Index, const AnsiString Value);
	void __fastcall SetValueAttribute(TValueAttributeID Index, const AnsiString Value);
	AnsiString __fastcall GetKeyOwnershipDeclaration();
	AnsiString __fastcall GetValueOwnershipDeclaration();
	
protected:
	bool __fastcall GetKnownMap(void);
	AnsiString __fastcall GetMapAttribute(TMapAttributeID Index);
	bool __fastcall IsMapAttributeStored(TMapAttributeID Index);
	void __fastcall SetKnownMap(bool Value);
	void __fastcall SetMapAttribute(TMapAttributeID Index, const AnsiString Value);
	void __fastcall TypeKnownTypeChange(System::TObject* Sender);
	
public:
	__fastcall TJclContainerMapInfo(void);
	__fastcall virtual ~TJclContainerMapInfo(void);
	__property bool KnownMap = {read=GetKnownMap, write=SetKnownMap, nodefault};
	__property Jclpreprocessorcontainertypes::PKnownMapAttributes KnownMapAttributes = {read=FKnownMapAttributes};
	__property AnsiString CustomMapAttributes[TMapAttributeID Index] = {read=GetCustomMapAttribute};
	__property AnsiString MapAttributes[TMapAttributeID Index] = {read=GetMapAttribute, write=SetMapAttribute};
	__property AnsiString KeyAttributes[TKeyAttributeID Index] = {read=GetKeyAttribute, write=SetKeyAttribute};
	__property Jclpreprocessorcontainer1dtemplates::TJclContainerTypeInfo* KeyTypeInfo = {read=FKeyTypeInfo};
	__property AnsiString KeyOwnershipDeclaration = {read=GetKeyOwnershipDeclaration};
	__property AnsiString ValueAttributes[TValueAttributeID Index] = {read=GetValueAttribute, write=SetValueAttribute};
	__property Jclpreprocessorcontainer1dtemplates::TJclContainerTypeInfo* ValueTypeInfo = {read=FValueTypeInfo};
	__property AnsiString ValueOwnershipDeclaration = {read=GetValueOwnershipDeclaration};
};


class DELPHICLASS TJclMapInterfaceParams;
class PASCALIMPLEMENTATION TJclMapInterfaceParams : public Jclpreprocessorcontainertypes::TJclInterfaceParams 
{
	typedef Jclpreprocessorcontainertypes::TJclInterfaceParams inherited;
	
private:
	TJclContainerMapInfo* FMapInfo;
	AnsiString __fastcall GetKeyOwnershipDeclaration();
	AnsiString __fastcall GetValueOwnershipDeclaration();
	
protected:
	AnsiString __fastcall GetKeyAttribute(TKeyAttributeID Index);
	AnsiString __fastcall GetMapAttribute(TMapAttributeID Index);
	AnsiString __fastcall GetValueAttribute(TValueAttributeID Index);
	bool __fastcall IsMapAttributeStored(TMapAttributeID Index);
	void __fastcall SetKeyAttribute(TKeyAttributeID Index, const AnsiString Value);
	void __fastcall SetMapAttribute(TMapAttributeID Index, const AnsiString Value);
	void __fastcall SetValueAttribute(TValueAttributeID Index, const AnsiString Value);
	
public:
	__property AnsiString KeyOwnershipDeclaration = {read=GetKeyOwnershipDeclaration};
	__property TJclContainerMapInfo* MapInfo = {read=FMapInfo, write=FMapInfo};
	__property AnsiString ValueOwnershipDeclaration = {read=GetValueOwnershipDeclaration};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclMapInterfaceParams(void) : Jclpreprocessorcontainertypes::TJclInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclMapInterfaceParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclMapClassInterfaceParams;
class PASCALIMPLEMENTATION TJclMapClassInterfaceParams : public TJclMapInterfaceParams 
{
	typedef TJclMapInterfaceParams inherited;
	
protected:
	AnsiString FInterfaceAdditional;
	AnsiString FSectionAdditional;
	virtual AnsiString __fastcall GetInterfaceAdditional();
	virtual AnsiString __fastcall GetSectionAdditional();
	virtual AnsiString __fastcall GetComparisonSectionAdditional(void) = 0 ;
	
public:
	__property AnsiString InterfaceAdditional = {read=GetInterfaceAdditional, write=FInterfaceAdditional};
	__property AnsiString SectionAdditional = {read=GetSectionAdditional, write=FSectionAdditional};
	__property AnsiString KeyTypeName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=83};
	__property AnsiString ValueTypeName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=95};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclMapClassInterfaceParams(void) : TJclMapInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclMapClassInterfaceParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclMapImplementationParams;
class PASCALIMPLEMENTATION TJclMapImplementationParams : public Jclpreprocessorcontainertypes::TJclImplementationParams 
{
	typedef Jclpreprocessorcontainertypes::TJclImplementationParams inherited;
	
private:
	AnsiString __fastcall GetKeyOwnershipDeclaration();
	AnsiString __fastcall GetValueOwnershipDeclaration();
	TJclContainerMapInfo* __fastcall GetMapInfo(void);
	
protected:
	AnsiString __fastcall GetKeyAttribute(TKeyAttributeID Index);
	AnsiString __fastcall GetMapAttribute(TMapAttributeID Index);
	AnsiString __fastcall GetValueAttribute(TValueAttributeID Index);
	void __fastcall SetKeyAttribute(TKeyAttributeID Index, const AnsiString Value);
	void __fastcall SetMapAttribute(TMapAttributeID Index, const AnsiString Value);
	void __fastcall SetValueAttribute(TValueAttributeID Index, const AnsiString Value);
	
public:
	__property AnsiString KeyOwnershipDeclaration = {read=GetKeyOwnershipDeclaration};
	__property AnsiString ValueOwnershipDeclaration = {read=GetValueOwnershipDeclaration};
	__property TJclContainerMapInfo* MapInfo = {read=GetMapInfo};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclMapImplementationParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainertypes::TJclImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclMapImplementationParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclMapClassImplementationParams;
class PASCALIMPLEMENTATION TJclMapClassImplementationParams : public TJclMapImplementationParams 
{
	typedef TJclMapImplementationParams inherited;
	
protected:
	AnsiString FCreateKeySet;
	AnsiString FCreateValueCollection;
	AnsiString FMacroFooter;
	AnsiString FOwnershipAssignments;
	AnsiString __fastcall GetCreateKeySet();
	AnsiString __fastcall GetCreateValueCollection();
	AnsiString __fastcall GetOwnershipAssignment();
	virtual AnsiString __fastcall GetSelfClassName(void) = 0 ;
	
public:
	virtual AnsiString __fastcall GetConstructorParameters(void) = 0 ;
	virtual AnsiString __fastcall GetMacroFooter();
	virtual void __fastcall ResetDefault(bool Value);
	__property AnsiString MacroFooter = {read=GetMacroFooter, write=FMacroFooter};
	__property AnsiString KeyTypeName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=83};
	__property AnsiString KeyDefault = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=87};
	__property AnsiString KeyArraySetClassName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=94};
	__property AnsiString ValueTypeName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=95};
	__property AnsiString ValueDefault = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=98};
	__property AnsiString ValueArrayListClassName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=103};
	__property AnsiString OwnershipAssignments = {read=GetOwnershipAssignment, write=FOwnershipAssignments};
	__property AnsiString CreateKeySet = {read=GetCreateKeySet, write=FCreateKeySet};
	__property AnsiString CreateValueCollection = {read=GetCreateValueCollection, write=FCreateValueCollection};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclMapClassImplementationParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclMapImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclMapClassImplementationParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorcontainer2dtemplates */
using namespace Jclpreprocessorcontainer2dtemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorcontainer2dtemplates

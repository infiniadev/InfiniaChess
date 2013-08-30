// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorhashmapstemplates.pas' rev: 10.00

#ifndef JclpreprocessorhashmapstemplatesHPP
#define JclpreprocessorhashmapstemplatesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Jclpreprocessorcontainertypes.hpp>	// Pascal unit
#include <Jclpreprocessorcontainertemplates.hpp>	// Pascal unit
#include <Jclpreprocessorcontainer2dtemplates.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessorhashmapstemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclHashMapTypeIntParams;
class PASCALIMPLEMENTATION TJclHashMapTypeIntParams : public Jclpreprocessorcontainer2dtemplates::TJclMapInterfaceParams 
{
	typedef Jclpreprocessorcontainer2dtemplates::TJclMapInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString EntryTypeName = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=110};
	__property AnsiString BucketTypeName = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=111};
	__property AnsiString KeyTypeName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=83};
	__property AnsiString ValueTypeName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=95};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclHashMapTypeIntParams(void) : Jclpreprocessorcontainer2dtemplates::TJclMapInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclHashMapTypeIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclHashMapIntParams;
class PASCALIMPLEMENTATION TJclHashMapIntParams : public Jclpreprocessorcontainer2dtemplates::TJclMapClassInterfaceParams 
{
	typedef Jclpreprocessorcontainer2dtemplates::TJclMapClassInterfaceParams inherited;
	
protected:
	virtual AnsiString __fastcall GetComparisonSectionAdditional();
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString BucketTypeName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=111};
	__property AnsiString SelfClassName = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=112};
	__property AnsiString AncestorName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=109};
	__property AnsiString MapInterfaceName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=104};
	__property AnsiString KeySetInterfaceName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=93};
	__property AnsiString ValueCollectionInterfaceName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=102};
	__property InterfaceAdditional ;
	__property SectionAdditional ;
	__property KeyOwnershipDeclaration ;
	__property ValueOwnershipDeclaration ;
	__property AnsiString KeyConstKeyword = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=85};
	__property KeyTypeName ;
	__property AnsiString ValueConstKeyword = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=97};
	__property ValueTypeName ;
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclHashMapIntParams(void) : Jclpreprocessorcontainer2dtemplates::TJclMapClassInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclHashMapIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclHashMapTypeImpParams;
class PASCALIMPLEMENTATION TJclHashMapTypeImpParams : public Jclpreprocessorcontainer2dtemplates::TJclMapImplementationParams 
{
	typedef Jclpreprocessorcontainer2dtemplates::TJclMapImplementationParams inherited;
	
__published:
	__property AnsiString BucketTypeName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=111};
	__property AnsiString KeyDefault = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=87};
	__property AnsiString ValueDefault = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=98};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclHashMapTypeImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer2dtemplates::TJclMapImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclHashMapTypeImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclHashMapImpParams;
class PASCALIMPLEMENTATION TJclHashMapImpParams : public Jclpreprocessorcontainer2dtemplates::TJclMapClassImplementationParams 
{
	typedef Jclpreprocessorcontainer2dtemplates::TJclMapClassImplementationParams inherited;
	
public:
	virtual AnsiString __fastcall GetConstructorParameters();
	virtual AnsiString __fastcall GetMacroFooter();
	virtual AnsiString __fastcall GetSelfClassName();
	
__published:
	__property AnsiString SelfClassName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=112};
	__property AnsiString AncestorClassName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=109};
	__property AnsiString BucketTypeName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=111};
	__property AnsiString MapInterfaceName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=104};
	__property AnsiString KeySetInterfaceName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=93};
	__property KeyArraySetClassName ;
	__property AnsiString KeyItrInterfaceName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=92};
	__property AnsiString ValueCollectionInterfaceName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=102};
	__property ValueArrayListClassName ;
	__property KeyOwnershipDeclaration ;
	__property ValueOwnershipDeclaration ;
	__property OwnershipAssignments ;
	__property AnsiString KeyConstKeyword = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=85};
	__property AnsiString KeyParameterName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=86};
	__property KeyTypeName ;
	__property KeyDefault ;
	__property AnsiString KeySimpleEqualityCompareFunctionName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=89};
	__property AnsiString KeySimpleHashConvertFunctionName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=90};
	__property AnsiString KeyBaseContainer = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=91};
	__property AnsiString ValueConstKeyword = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=97};
	__property ValueTypeName ;
	__property ValueDefault ;
	__property AnsiString ValueSimpleEqualityCompareFunctionName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=100};
	__property AnsiString ValueBaseContainerClassName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=101};
	__property CreateKeySet ;
	__property CreateValueCollection ;
	__property MacroFooter ;
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclHashMapImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer2dtemplates::TJclMapClassImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclHashMapImpParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorhashmapstemplates */
using namespace Jclpreprocessorhashmapstemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorhashmapstemplates

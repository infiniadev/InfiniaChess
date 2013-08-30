// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorsortedmapstemplates.pas' rev: 10.00

#ifndef JclpreprocessorsortedmapstemplatesHPP
#define JclpreprocessorsortedmapstemplatesHPP

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

namespace Jclpreprocessorsortedmapstemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclSortedMapTypeIntParams;
class PASCALIMPLEMENTATION TJclSortedMapTypeIntParams : public Jclpreprocessorcontainer2dtemplates::TJclMapInterfaceParams 
{
	typedef Jclpreprocessorcontainer2dtemplates::TJclMapInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString EntryTypeName = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=113};
	__property AnsiString KeyTypeName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=83};
	__property AnsiString ValueTypeName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=95};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclSortedMapTypeIntParams(void) : Jclpreprocessorcontainer2dtemplates::TJclMapInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSortedMapTypeIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSortedMapIntParams;
class PASCALIMPLEMENTATION TJclSortedMapIntParams : public Jclpreprocessorcontainer2dtemplates::TJclMapClassInterfaceParams 
{
	typedef Jclpreprocessorcontainer2dtemplates::TJclMapClassInterfaceParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	virtual AnsiString __fastcall GetComparisonSectionAdditional();
	
__published:
	__property AnsiString EntryTypeName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=113};
	__property AnsiString SelfClassName = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=114};
	__property AnsiString AncestorName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=109};
	__property AnsiString StdMapInterfaceName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=104};
	__property AnsiString SortedMapInterfaceName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=107};
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
	/* TObject.Create */ inline __fastcall TJclSortedMapIntParams(void) : Jclpreprocessorcontainer2dtemplates::TJclMapClassInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSortedMapIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSortedMapImpParams;
class PASCALIMPLEMENTATION TJclSortedMapImpParams : public Jclpreprocessorcontainer2dtemplates::TJclMapClassImplementationParams 
{
	typedef Jclpreprocessorcontainer2dtemplates::TJclMapClassImplementationParams inherited;
	
public:
	virtual AnsiString __fastcall GetConstructorParameters();
	virtual AnsiString __fastcall GetMacroFooter();
	virtual AnsiString __fastcall GetSelfClassName();
	
__published:
	__property AnsiString SelfClassName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=114};
	__property AnsiString AncestorClassName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=109};
	__property AnsiString StdMapInterfaceName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=104};
	__property AnsiString SortedMapInterfaceName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=107};
	__property AnsiString KeySetInterfaceName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=93};
	__property AnsiString KeyItrInterfaceName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=92};
	__property AnsiString ValueCollectionInterfaceName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=102};
	__property KeyOwnershipDeclaration ;
	__property ValueOwnershipDeclaration ;
	__property OwnershipAssignments ;
	__property AnsiString KeyConstKeyword = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=85};
	__property KeyTypeName ;
	__property KeyDefault ;
	__property AnsiString KeySimpleCompareFunctionName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=88};
	__property AnsiString KeyBaseContainer = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=91};
	__property AnsiString ValueConstKeyword = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=97};
	__property ValueTypeName ;
	__property ValueDefault ;
	__property AnsiString ValueSimpleCompareFunctionName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=99};
	__property AnsiString ValueBaseContainerClassName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=101};
	__property CreateKeySet ;
	__property CreateValueCollection ;
	__property MacroFooter ;
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclSortedMapImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer2dtemplates::TJclMapClassImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSortedMapImpParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorsortedmapstemplates */
using namespace Jclpreprocessorsortedmapstemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorsortedmapstemplates

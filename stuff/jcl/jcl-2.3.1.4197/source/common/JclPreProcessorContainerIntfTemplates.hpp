// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorcontainerintftemplates.pas' rev: 10.00

#ifndef JclpreprocessorcontainerintftemplatesHPP
#define JclpreprocessorcontainerintftemplatesHPP

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
#include <Jclpreprocessorcontainer2dtemplates.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessorcontainerintftemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclContainerIntf1DParams;
class PASCALIMPLEMENTATION TJclContainerIntf1DParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams inherited;
	
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclContainerIntf1DParams(void) : Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclContainerIntf1DParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclContainerIntf2DParams;
class PASCALIMPLEMENTATION TJclContainerIntf2DParams : public Jclpreprocessorcontainer2dtemplates::TJclMapInterfaceParams 
{
	typedef Jclpreprocessorcontainer2dtemplates::TJclMapInterfaceParams inherited;
	
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclContainerIntf2DParams(void) : Jclpreprocessorcontainer2dtemplates::TJclMapInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclContainerIntf2DParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclContainerIntfAncestorParams;
class PASCALIMPLEMENTATION TJclContainerIntfAncestorParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
protected:
	AnsiString FAncestorName;
	virtual AnsiString __fastcall GetAncestorName();
	bool __fastcall IsAncestorNameStored(void);
	
public:
	__property AnsiString AncestorName = {read=GetAncestorName, write=FAncestorName, stored=IsAncestorNameStored};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclContainerIntfAncestorParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclContainerIntfAncestorParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclContainerIntfFlatAncestorParams;
class PASCALIMPLEMENTATION TJclContainerIntfFlatAncestorParams : public TJclContainerIntfAncestorParams 
{
	typedef TJclContainerIntfAncestorParams inherited;
	
protected:
	virtual AnsiString __fastcall GetAncestorName();
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclContainerIntfFlatAncestorParams(void) : TJclContainerIntfAncestorParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclContainerIntfFlatAncestorParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclIterProcedureParams;
class PASCALIMPLEMENTATION TJclIterProcedureParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString ProcName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=21};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclIterProcedureParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclIterProcedureParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclApplyFunctionParams;
class PASCALIMPLEMENTATION TJclApplyFunctionParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString FuncName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=22};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclApplyFunctionParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclApplyFunctionParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCompareFunctionParams;
class PASCALIMPLEMENTATION TJclCompareFunctionParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString FuncName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=23};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclCompareFunctionParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCompareFunctionParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclEqualityCompareFunctionParams;
class PASCALIMPLEMENTATION TJclEqualityCompareFunctionParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString FuncName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=25};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclEqualityCompareFunctionParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclEqualityCompareFunctionParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclHashFunctionParams;
class PASCALIMPLEMENTATION TJclHashFunctionParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString FuncName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=27};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclHashFunctionParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclHashFunctionParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSortFunctionParams;
class PASCALIMPLEMENTATION TJclSortFunctionParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString ProcName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=53};
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString CompareFuncName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclSortFunctionParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSortFunctionParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclEqualityComparerParams;
class PASCALIMPLEMENTATION TJclEqualityComparerParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=33};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=34};
	__property AnsiString EqualityCompareTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=25};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclEqualityComparerParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclEqualityComparerParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclComparerParams;
class PASCALIMPLEMENTATION TJclComparerParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=35};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=36};
	__property AnsiString CompareTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclComparerParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclComparerParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclHashConverterParams;
class PASCALIMPLEMENTATION TJclHashConverterParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=37};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=38};
	__property AnsiString HashConvertTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=27};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclHashConverterParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclHashConverterParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclReleaseEventParams;
class PASCALIMPLEMENTATION TJclReleaseEventParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString EventTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=13};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclReleaseEventParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclReleaseEventParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclOwnerParams;
class PASCALIMPLEMENTATION TJclOwnerParams : public TJclContainerIntfAncestorParams 
{
	typedef TJclContainerIntfAncestorParams inherited;
	
protected:
	AnsiString FOwnerAdditional;
	virtual AnsiString __fastcall GetAncestorName();
	AnsiString __fastcall GetOwnerAdditional();
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=9};
	__property AncestorName ;
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=10};
	__property AnsiString ReleaserName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=11};
	__property AnsiString ReleaseEventName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=12};
	__property AnsiString ReleaseEventTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=13};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString OwnerAdditional = {read=GetOwnerAdditional, write=FOwnerAdditional};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclOwnerParams(void) : TJclContainerIntfAncestorParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclOwnerParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclIteratorParams;
class PASCALIMPLEMENTATION TJclIteratorParams : public TJclContainerIntfAncestorParams 
{
	typedef TJclContainerIntfAncestorParams inherited;
	
protected:
	virtual AnsiString __fastcall GetAncestorName();
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=39};
	__property AncestorName ;
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=40};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclIteratorParams(void) : TJclContainerIntfAncestorParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclIteratorParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclTreeIteratorParams;
class PASCALIMPLEMENTATION TJclTreeIteratorParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=66};
	__property AnsiString AncestorName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=67};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclTreeIteratorParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclTreeIteratorParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclBinaryTreeIteratorParams;
class PASCALIMPLEMENTATION TJclBinaryTreeIteratorParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=41};
	__property AnsiString AncestorName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=66};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=42};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclBinaryTreeIteratorParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBinaryTreeIteratorParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCollectionParams;
class PASCALIMPLEMENTATION TJclCollectionParams : public TJclContainerIntfFlatAncestorParams 
{
	typedef TJclContainerIntfFlatAncestorParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=49};
	__property AncestorName ;
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=50};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString ItrName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclCollectionParams(void) : TJclContainerIntfFlatAncestorParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCollectionParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclListParams;
class PASCALIMPLEMENTATION TJclListParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=51};
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString AncestorName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=52};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
	__property AnsiString PropName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=18};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclListParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclListParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclArrayParams;
class PASCALIMPLEMENTATION TJclArrayParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=54};
	__property AnsiString AncestorName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=55};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
	__property AnsiString PropName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=18};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclArrayParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclArrayParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSetParams;
class PASCALIMPLEMENTATION TJclSetParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=63};
	__property AnsiString SetInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=63};
	__property AnsiString AncestorName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString CollectionInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=64};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclSetParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSetParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclTreeParams;
class PASCALIMPLEMENTATION TJclTreeParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=68};
	__property AnsiString AncestorName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=49};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=69};
	__property AnsiString ItrName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=66};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclTreeParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclTreeParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclMapParams;
class PASCALIMPLEMENTATION TJclMapParams : public TJclContainerIntf2DParams 
{
	typedef TJclContainerIntf2DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=104};
	__property AnsiString AncestorName = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=106};
	__property AnsiString GUID = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=105};
	__property AnsiString ConstKeyword = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=85};
	__property AnsiString TypeName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=83};
	__property AnsiString SetName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=93};
	__property AnsiString CollectionName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=102};
	__property AnsiString KeyConstKeyword = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=85};
	__property AnsiString KeyTypeName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=83};
	__property AnsiString KeySetName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=93};
	__property AnsiString ValueConstKeyword = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=97};
	__property AnsiString ValueTypeName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=95};
	__property AnsiString ValueCollectionName = {read=GetValueAttribute, write=SetValueAttribute, stored=false, index=102};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclMapParams(void) : TJclContainerIntf2DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclMapParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclQueueParams;
class PASCALIMPLEMENTATION TJclQueueParams : public TJclContainerIntfAncestorParams 
{
	typedef TJclContainerIntfAncestorParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=75};
	__property AncestorName ;
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=76};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclQueueParams(void) : TJclContainerIntfAncestorParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclQueueParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSortedMapParams;
class PASCALIMPLEMENTATION TJclSortedMapParams : public TJclContainerIntf2DParams 
{
	typedef TJclContainerIntf2DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=107};
	__property AnsiString AncestorName = {read=GetMapAttribute, write=SetMapAttribute, stored=false, index=104};
	__property AnsiString GUID = {read=GetMapAttribute, write=SetMapAttribute, stored=IsMapAttributeStored, index=108};
	__property AnsiString KeyConstKeyword = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=85};
	__property AnsiString KeyTypeName = {read=GetKeyAttribute, write=SetKeyAttribute, stored=false, index=83};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclSortedMapParams(void) : TJclContainerIntf2DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSortedMapParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSortedSetParams;
class PASCALIMPLEMENTATION TJclSortedSetParams : public TJclContainerIntf1DParams 
{
	typedef TJclContainerIntf1DParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=78};
	__property AnsiString AncestorName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=63};
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=79};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclSortedSetParams(void) : TJclContainerIntf1DParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSortedSetParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclStackParams;
class PASCALIMPLEMENTATION TJclStackParams : public TJclContainerIntfAncestorParams 
{
	typedef TJclContainerIntfAncestorParams inherited;
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString InterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=80};
	__property AncestorName ;
	__property AnsiString GUID = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=81};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclStackParams(void) : TJclContainerIntfAncestorParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclStackParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorcontainerintftemplates */
using namespace Jclpreprocessorcontainerintftemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorcontainerintftemplates

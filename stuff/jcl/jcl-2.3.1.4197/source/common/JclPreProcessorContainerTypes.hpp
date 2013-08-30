// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorcontainertypes.pas' rev: 10.00

#ifndef JclpreprocessorcontainertypesHPP
#define JclpreprocessorcontainertypesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Jclpreprocessortemplates.hpp>	// Pascal unit
#include <Jclnotify.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#define TTypeAttributeID int
#define TKeyAttributeID int
#define TValueAttributeID int
#define TMapAttributeID int

namespace Jclpreprocessorcontainertypes
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TAllTypeAttributeID { taTypeName, taCondition, taDefines, taUndefs, taAlias, taAliasCondition, taDefaultValue, taConstKeyword, taOwnershipParameter, taOwnershipInterfaceName, taOwnershipInterfaceGUID, taReleaserName, taReleaseEventName, taReleaseEventTypeName, taGetterName, taSetterName, taParameterName, taDynArrayTypeName, taArrayName, taBaseContainer, taBaseCollection, taIterateProcedureName, taApplyFunctionName, taCompareFunctionName, taSimpleCompareFunctionName, taEqualityCompareFunctionName, taSimpleEqualityCompareFunctionName, taHashConvertFunctionName, taSimpleHashConvertFunctionName, taContainerInterfaceName, taContainerInterfaceGUID, taFlatContainerInterfaceName, taFlatContainerInterfaceGUID, taEqualityComparerInterfaceName, taEqualityComparerInterfaceGUID, taComparerInterfaceName, taComparerInterfaceGUID, taHashConverterInterfaceName, taHashConverterInterfaceGUID, taIteratorInterfaceName, taIteratorInterfaceGUID, taBinaryTreeIteratorInterfaceName, taBinaryTreeIteratorInterfaceGUID
	, taBinaryTreeNodeTypeName, taBinaryTreeClassName, taBinaryTreeBaseIteratorClassName, taBinaryTreePreOrderIteratorClassName, taBinaryTreeInOrderIteratorClassName, taBinaryTreePostOrderIteratorClassName, taCollectionInterfaceName, taCollectionInterfaceGUID, taListInterfaceName, taListInterfaceGUID, taSortProcedureName, taArrayInterfaceName, taArrayInterfaceGUID, taArrayListClassName, taArrayIteratorClassName, taLinkedListItemClassName, taLinkedListClassName, taLinkedListIteratorClassName, taVectorClassName, taVectorIteratorClassName, taSetInterfaceName, taSetInterfaceGUID, taArraySetClassName, taTreeIteratorInterfaceName, taTreeIteratorInterfaceGUID, taTreeInterfaceName, taTreeInterfaceGUID, taTreeNodeClassName, taTreeClassName, taTreeBaseIteratorClassName, taTreePreOrderIteratorClassName, taTreePostOrderIteratorClassName, taQueueInterfaceName, taQueueInterfaceGUID, taQueueClassName, taSortedSetInterfaceName, taSortedSetInterfaceGUID, taStackInterfaceName, taStackInterfaceGUID, taStackClassName, kaKeyTypeName, kaKeyOwnershipParameter
	, kaKeyConstKeyword, kaKeyParameterName, kaKeyDefaultValue, kaKeySimpleCompareFunctionName, kaKeySimpleEqualityCompareFunctionName, kaKeySimpleHashConvertFunctionName, kaKeyBaseContainerClassName, kaKeyIteratorInterfaceName, kaKeySetInterfaceName, kaKeyArraySetClassName, vaValueTypeName, vaValueOwnershipParameter, vaValueConstKeyword, vaValueDefaultValue, vaValueSimpleCompareFunctionName, vaValueSimpleEqualityCompareFunctionName, vaValueBaseContainerClassName, vaValueCollectionInterfaceName, vaValueArrayListClassName, maMapInterfaceName, maMapInterfaceGUID, maMapInterfaceAncestorName, maSortedMapInterfaceName, maSortedMapInterfaceGUID, maMapAncestorClassName, maHashMapEntryTypeName, maHashMapBucketTypeName, maHashMapClassName, maSortedMapEntryTypeName, maSortedMapClassName };
#pragma option pop

typedef Set<TAllTypeAttributeID, taTypeName, maSortedMapClassName>  TAllTypeAttributeIDs;

typedef AnsiString TTypeAttributes[83];

typedef AnsiString TKnownTypeAttributes[83];

typedef TTypeAttributes *PKnownTypeAttributes;

typedef AnsiString TMapAttributes[11];

struct TKnownMapAttributes
{
	
public:
	AnsiString MapAttributes[11];
	TTypeAttributes *KeyAttributes;
	TTypeAttributes *ValueAttributes;
} ;

typedef TKnownMapAttributes *PKnownMapAttributes;

struct TTypeAttributeInfo
{
	
public:
	bool IsGUID;
	AnsiString DefaultValue;
} ;

typedef TTypeAttributeInfo JclPreProcessorContainerTypes__1[83];

typedef TTypeAttributeInfo JclPreProcessorContainerTypes__2[11];

class DELPHICLASS EJclContainerException;
class PASCALIMPLEMENTATION EJclContainerException : public Jclbase::EJclError 
{
	typedef Jclbase::EJclError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EJclContainerException(const AnsiString Msg) : Jclbase::EJclError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EJclContainerException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Jclbase::EJclError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EJclContainerException(int Ident)/* overload */ : Jclbase::EJclError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EJclContainerException(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Jclbase::EJclError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EJclContainerException(const AnsiString Msg, int AHelpContext) : Jclbase::EJclError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EJclContainerException(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Jclbase::EJclError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EJclContainerException(int Ident, int AHelpContext)/* overload */ : Jclbase::EJclError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EJclContainerException(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Jclbase::EJclError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EJclContainerException(void) { }
	#pragma option pop
	
};


#pragma option push -b-
enum TCodeLocation { clDefault, clAtCursor, clInterface, clImplementation };
#pragma option pop

class DELPHICLASS TJclMacroParams;
class PASCALIMPLEMENTATION TJclMacroParams : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	virtual bool __fastcall IsDefault(void);
	virtual void __fastcall ResetDefault(bool Value);
	virtual AnsiString __fastcall GetMacroHeader();
	virtual AnsiString __fastcall GetMacroFooter();
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclMacroParams(void) : System::TObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclMacroParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclInterfaceParams;
class PASCALIMPLEMENTATION TJclInterfaceParams : public TJclMacroParams 
{
	typedef TJclMacroParams inherited;
	
public:
	virtual TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclInterfaceParams(void) : TJclMacroParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclInterfaceParams(void) { }
	#pragma option pop
	
};


typedef TMetaClass* TJclInterfaceParamsClass;

class DELPHICLASS TJclImplementationParams;
class PASCALIMPLEMENTATION TJclImplementationParams : public TJclMacroParams 
{
	typedef TJclMacroParams inherited;
	
private:
	TJclInterfaceParams* FInterfaceParams;
	
public:
	__fastcall TJclImplementationParams(TJclInterfaceParams* AInterfaceParams);
	__property TJclInterfaceParams* InterfaceParams = {read=FInterfaceParams};
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclImplementationParams(void) { }
	#pragma option pop
	
};


typedef TMetaClass* TJclImplementationParamsClass;

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TTypeAttributeInfo TypeAttributeInfos[83];
extern PACKAGE TAllTypeAttributeID KeyAttributeInfos[12];
extern PACKAGE TAllTypeAttributeID ValueAttributeInfos[9];
extern PACKAGE TTypeAttributeInfo MapAttributeInfos[11];

}	/* namespace Jclpreprocessorcontainertypes */
using namespace Jclpreprocessorcontainertypes;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorcontainertypes

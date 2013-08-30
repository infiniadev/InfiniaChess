// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorqueuestemplates.pas' rev: 10.00

#ifndef JclpreprocessorqueuestemplatesHPP
#define JclpreprocessorqueuestemplatesHPP

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

namespace Jclpreprocessorqueuestemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclQueueIntParams;
class PASCALIMPLEMENTATION TJclQueueIntParams : public Jclpreprocessorcontainer1dtemplates::TJclClassInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclClassInterfaceParams inherited;
	
protected:
	virtual AnsiString __fastcall GetInterfaceAdditional();
	
public:
	virtual Jclpreprocessorcontainertypes::TAllTypeAttributeIDs __fastcall AliasAttributeIDs();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=77};
	__property AnsiString QueueInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=75};
	__property AncestorClassName ;
	__property AnsiString DynArrayTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=17};
	__property AnsiString EqualityComparerInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=33};
	__property InterfaceAdditional ;
	__property SectionAdditional ;
	__property OwnershipDeclaration ;
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclQueueIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclClassInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclQueueIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclQueueImpParams;
class PASCALIMPLEMENTATION TJclQueueImpParams : public Jclpreprocessorcontainer1dtemplates::TJclClassImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclClassImplementationParams inherited;
	
public:
	virtual AnsiString __fastcall GetConstructorParameters();
	virtual AnsiString __fastcall GetSelfClassName();
	
__published:
	__property AnsiString SelfClassName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=77};
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
	/* TJclImplementationParams.Create */ inline __fastcall TJclQueueImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclClassImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclQueueImpParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorqueuestemplates */
using namespace Jclpreprocessorqueuestemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorqueuestemplates

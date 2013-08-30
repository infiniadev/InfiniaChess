// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessoralgorithmstemplates.pas' rev: 10.00

#ifndef JclpreprocessoralgorithmstemplatesHPP
#define JclpreprocessoralgorithmstemplatesHPP

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

namespace Jclpreprocessoralgorithmstemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclAlgorithmsIntParams;
class PASCALIMPLEMENTATION TJclAlgorithmsIntParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams inherited;
	
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclAlgorithmsIntParams(void) : Jclpreprocessorcontainer1dtemplates::TJclContainerInterfaceParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclAlgorithmsIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclAlgorithmsIntProcParams;
class PASCALIMPLEMENTATION TJclAlgorithmsIntProcParams : public TJclAlgorithmsIntParams 
{
	typedef TJclAlgorithmsIntParams inherited;
	
protected:
	AnsiString FOverload;
	AnsiString FProcName;
	virtual AnsiString __fastcall GetProcName();
	bool __fastcall IsProcNameStored(void);
	
public:
	__property AnsiString Overload = {read=FOverload, write=FOverload};
	__property AnsiString ProcName = {read=GetProcName, write=FProcName, stored=IsProcNameStored};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclAlgorithmsIntProcParams(void) : TJclAlgorithmsIntParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclAlgorithmsIntProcParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclAlgorithmsImpProcParams;
class PASCALIMPLEMENTATION TJclAlgorithmsImpProcParams : public Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams 
{
	typedef Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams inherited;
	
protected:
	AnsiString __fastcall GetProcName();
	void __fastcall SetProcName(const AnsiString Value);
	
public:
	__property AnsiString ProcName = {read=GetProcName, write=SetProcName, stored=false};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclAlgorithmsImpProcParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : Jclpreprocessorcontainer1dtemplates::TJclContainerImplementationParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclAlgorithmsImpProcParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclMoveArrayIntParams;
class PASCALIMPLEMENTATION TJclMoveArrayIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property Overload ;
	__property ProcName ;
	__property AnsiString DynArrayTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=17};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclMoveArrayIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclMoveArrayIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclMoveArrayImpParams;
class PASCALIMPLEMENTATION TJclMoveArrayImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString DynArrayTypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=17};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclMoveArrayImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclMoveArrayImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclIterateIntParams;
class PASCALIMPLEMENTATION TJclIterateIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property Overload ;
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=21};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclIterateIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclIterateIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclIterateImpParams;
class PASCALIMPLEMENTATION TJclIterateImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=21};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclIterateImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclIterateImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclApplyIntParams;
class PASCALIMPLEMENTATION TJclApplyIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property Overload ;
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=22};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclApplyIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclApplyIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclApplyImpParams;
class PASCALIMPLEMENTATION TJclApplyImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=22};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclApplyImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclApplyImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSimpleCompareIntParams;
class PASCALIMPLEMENTATION TJclSimpleCompareIntParams : public TJclAlgorithmsIntParams 
{
	typedef TJclAlgorithmsIntParams inherited;
	
__published:
	__property AnsiString ProcName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=24};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclSimpleCompareIntParams(void) : TJclAlgorithmsIntParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSimpleCompareIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSimpleEqualityCompareIntParams;
class PASCALIMPLEMENTATION TJclSimpleEqualityCompareIntParams : public TJclAlgorithmsIntParams 
{
	typedef TJclAlgorithmsIntParams inherited;
	
__published:
	__property AnsiString ProcName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=26};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclSimpleEqualityCompareIntParams(void) : TJclAlgorithmsIntParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSimpleEqualityCompareIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSimpleHashConvertIntParams;
class PASCALIMPLEMENTATION TJclSimpleHashConvertIntParams : public TJclAlgorithmsIntParams 
{
	typedef TJclAlgorithmsIntParams inherited;
	
__published:
	__property AnsiString ProcName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=IsTypeAttributeStored, index=28};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclSimpleHashConvertIntParams(void) : TJclAlgorithmsIntParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSimpleHashConvertIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclFindIntParams;
class PASCALIMPLEMENTATION TJclFindIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclFindIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclFindIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclFindImpParams;
class PASCALIMPLEMENTATION TJclFindImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclFindImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclFindImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclFindEqIntParams;
class PASCALIMPLEMENTATION TJclFindEqIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=25};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclFindEqIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclFindEqIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclFindEqImpParams;
class PASCALIMPLEMENTATION TJclFindEqImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=25};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclFindEqImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclFindEqImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCountObjectIntParams;
class PASCALIMPLEMENTATION TJclCountObjectIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclCountObjectIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCountObjectIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCountObjectImpParams;
class PASCALIMPLEMENTATION TJclCountObjectImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclCountObjectImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCountObjectImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCountObjectEqIntParams;
class PASCALIMPLEMENTATION TJclCountObjectEqIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=25};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclCountObjectEqIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCountObjectEqIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCountObjectEqImpParams;
class PASCALIMPLEMENTATION TJclCountObjectEqImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=25};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclCountObjectEqImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCountObjectEqImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCopyIntParams;
class PASCALIMPLEMENTATION TJclCopyIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclCopyIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCopyIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclCopyImpParams;
class PASCALIMPLEMENTATION TJclCopyImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclCopyImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclCopyImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclGenerateIntParams;
class PASCALIMPLEMENTATION TJclGenerateIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property ProcName ;
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclGenerateIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclGenerateIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclGenerateImpParams;
class PASCALIMPLEMENTATION TJclGenerateImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclGenerateImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclGenerateImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclFillIntParams;
class PASCALIMPLEMENTATION TJclFillIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclFillIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclFillIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclFillImpParams;
class PASCALIMPLEMENTATION TJclFillImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString ConstKeyword = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=7};
	__property AnsiString ParameterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=16};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclFillImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclFillImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclReverseIntParams;
class PASCALIMPLEMENTATION TJclReverseIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclReverseIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclReverseIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclReverseImpParams;
class PASCALIMPLEMENTATION TJclReverseImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
__published:
	__property ProcName ;
	__property AnsiString ItrInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=39};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclReverseImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclReverseImpParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclSortIntParams;
class PASCALIMPLEMENTATION TJclSortIntParams : public TJclAlgorithmsIntProcParams 
{
	typedef TJclAlgorithmsIntProcParams inherited;
	
private:
	AnsiString FLeft;
	AnsiString FRight;
	AnsiString __fastcall GetLeft();
	AnsiString __fastcall GetRight();
	bool __fastcall IsLeftStored(void);
	bool __fastcall IsRightStored(void);
	
protected:
	virtual AnsiString __fastcall GetProcName();
	
__published:
	__property ProcName ;
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString Left = {read=GetLeft, write=FLeft, stored=IsLeftStored};
	__property AnsiString Right = {read=GetRight, write=FRight, stored=IsRightStored};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclSortIntParams(void) : TJclAlgorithmsIntProcParams() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclSortIntParams(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclQuickSortImpParams;
class PASCALIMPLEMENTATION TJclQuickSortImpParams : public TJclAlgorithmsImpProcParams 
{
	typedef TJclAlgorithmsImpProcParams inherited;
	
private:
	AnsiString __fastcall GetLeft();
	AnsiString __fastcall GetRight();
	void __fastcall SetLeft(const AnsiString Value);
	void __fastcall SetRight(const AnsiString Value);
	
__published:
	__property ProcName ;
	__property AnsiString ListInterfaceName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=51};
	__property AnsiString Left = {read=GetLeft, write=SetLeft, stored=false};
	__property AnsiString Right = {read=GetRight, write=SetRight, stored=false};
	__property AnsiString CallbackType = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=23};
	__property AnsiString TypeName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=0};
	__property AnsiString GetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=14};
	__property AnsiString SetterName = {read=GetTypeAttribute, write=SetTypeAttribute, stored=false, index=15};
public:
	#pragma option push -w-inl
	/* TJclImplementationParams.Create */ inline __fastcall TJclQuickSortImpParams(Jclpreprocessorcontainertypes::TJclInterfaceParams* AInterfaceParams) : TJclAlgorithmsImpProcParams(AInterfaceParams) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclQuickSortImpParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessoralgorithmstemplates */
using namespace Jclpreprocessoralgorithmstemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessoralgorithmstemplates

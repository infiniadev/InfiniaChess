// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclusesutils.pas' rev: 10.00

#ifndef JclusesutilsHPP
#define JclusesutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclusesutils
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EUsesListError;
class PASCALIMPLEMENTATION EUsesListError : public Jclbase::EJclError 
{
	typedef Jclbase::EJclError inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EUsesListError(const AnsiString Msg) : Jclbase::EJclError(Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EUsesListError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size) : Jclbase::EJclError(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EUsesListError(int Ident)/* overload */ : Jclbase::EJclError(Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EUsesListError(int Ident, System::TVarRec const * Args, const int Args_Size)/* overload */ : Jclbase::EJclError(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EUsesListError(const AnsiString Msg, int AHelpContext) : Jclbase::EJclError(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EUsesListError(const AnsiString Msg, System::TVarRec const * Args, const int Args_Size, int AHelpContext) : Jclbase::EJclError(Msg, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EUsesListError(int Ident, int AHelpContext)/* overload */ : Jclbase::EJclError(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EUsesListError(System::PResStringRec ResStringRec, System::TVarRec const * Args, const int Args_Size, int AHelpContext)/* overload */ : Jclbase::EJclError(ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EUsesListError(void) { }
	#pragma option pop
	
};


class DELPHICLASS TUsesList;
class PASCALIMPLEMENTATION TUsesList : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	AnsiString operator[](int Index) { return Items[Index]; }
	
private:
	AnsiString FText;
	int __fastcall GetCount(void);
	AnsiString __fastcall GetItems(int Index);
	
public:
	__fastcall TUsesList(const char * AText);
	int __fastcall Add(const AnsiString UnitName);
	int __fastcall IndexOf(const AnsiString UnitName);
	void __fastcall Insert(int Index, const AnsiString UnitName);
	void __fastcall Remove(int Index);
	__property AnsiString Text = {read=FText};
	__property int Count = {read=GetCount, nodefault};
	__property AnsiString Items[int Index] = {read=GetItems/*, default*/};
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TUsesList(void) { }
	#pragma option pop
	
};


class DELPHICLASS TCustomGoal;
class PASCALIMPLEMENTATION TCustomGoal : public System::TObject 
{
	typedef System::TObject inherited;
	
public:
	__fastcall virtual TCustomGoal(char * Text) = 0 ;
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TCustomGoal(void) { }
	#pragma option pop
	
};


class DELPHICLASS TProgramGoal;
class PASCALIMPLEMENTATION TProgramGoal : public TCustomGoal 
{
	typedef TCustomGoal inherited;
	
private:
	AnsiString FTextAfterUses;
	AnsiString FTextBeforeUses;
	TUsesList* FUsesList;
	
public:
	__fastcall virtual TProgramGoal(char * Text);
	__fastcall virtual ~TProgramGoal(void);
	__property AnsiString TextAfterUses = {read=FTextAfterUses};
	__property AnsiString TextBeforeUses = {read=FTextBeforeUses};
	__property TUsesList* UsesList = {read=FUsesList};
};


class DELPHICLASS TLibraryGoal;
class PASCALIMPLEMENTATION TLibraryGoal : public TCustomGoal 
{
	typedef TCustomGoal inherited;
	
private:
	AnsiString FTextAfterUses;
	AnsiString FTextBeforeUses;
	TUsesList* FUsesList;
	
public:
	__fastcall virtual TLibraryGoal(char * Text);
	__fastcall virtual ~TLibraryGoal(void);
	__property AnsiString TextAfterUses = {read=FTextAfterUses};
	__property AnsiString TextBeforeUses = {read=FTextBeforeUses};
	__property TUsesList* UsesList = {read=FUsesList};
};


class DELPHICLASS TUnitGoal;
class PASCALIMPLEMENTATION TUnitGoal : public TCustomGoal 
{
	typedef TCustomGoal inherited;
	
private:
	AnsiString FTextAfterImpl;
	AnsiString FTextAfterIntf;
	AnsiString FTextBeforeIntf;
	TUsesList* FUsesImpl;
	TUsesList* FUsesIntf;
	
public:
	__fastcall virtual TUnitGoal(char * Text);
	__fastcall virtual ~TUnitGoal(void);
	__property AnsiString TextAfterImpl = {read=FTextAfterImpl};
	__property AnsiString TextAfterIntf = {read=FTextAfterIntf};
	__property AnsiString TextBeforeIntf = {read=FTextBeforeIntf};
	__property TUsesList* UsesImpl = {read=FUsesImpl};
	__property TUsesList* UsesIntf = {read=FUsesIntf};
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE TCustomGoal* __fastcall CreateGoal(char * Text);

}	/* namespace Jclusesutils */
using namespace Jclusesutils;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclusesutils

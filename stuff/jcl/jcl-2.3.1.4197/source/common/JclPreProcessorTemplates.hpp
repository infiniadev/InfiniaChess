// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessortemplates.pas' rev: 10.00

#ifndef JclpreprocessortemplatesHPP
#define JclpreprocessortemplatesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Jclpreprocessorparser.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessortemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclTemplateParams;
class PASCALIMPLEMENTATION TJclTemplateParams : public Jclpreprocessorparser::TPppState 
{
	typedef Jclpreprocessorparser::TPppState inherited;
	
public:
	__fastcall TJclTemplateParams(void);
public:
	#pragma option push -w-inl
	/* TPppState.Destroy */ inline __fastcall virtual ~TJclTemplateParams(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
#define ModulePattern "%MODULENAME%"
#define FormPattern "%FORMNAME%"
#define AncestorPattern "%ANCESTORNAME%"
extern PACKAGE AnsiString __fastcall GetFinalFormContent(const AnsiString Content, const AnsiString FormIdent, const AnsiString AncestorIdent);
extern PACKAGE AnsiString __fastcall GetFinalHeaderContent(const AnsiString Content, const AnsiString ModuleIdent, const AnsiString FormIdent, const AnsiString AncestorIdent);
extern PACKAGE AnsiString __fastcall GetFinalSourceContent(const AnsiString Content, const AnsiString ModuleIdent, const AnsiString FormIdent, const AnsiString AncestorIdent);
extern PACKAGE AnsiString __fastcall ApplyTemplate(const AnsiString Template, const TJclTemplateParams* Params);

}	/* namespace Jclpreprocessortemplates */
using namespace Jclpreprocessortemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessortemplates

// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclversionctrlgitimpl.pas' rev: 10.00

#ifndef JclversionctrlgitimplHPP
#define JclversionctrlgitimplHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Jclversioncontrol.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclversionctrlgitimpl
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclVersionControlGIT;
class PASCALIMPLEMENTATION TJclVersionControlGIT : public Jclversioncontrol::TJclVersionControlPlugin 
{
	typedef Jclversioncontrol::TJclVersionControlPlugin inherited;
	
private:
	AnsiString FTortoiseGITProc;
	
protected:
	virtual bool __fastcall GetEnabled(void);
	virtual Jclversioncontrol::TJclVersionControlActionTypes __fastcall GetFileActions(const AnsiString FileName);
	AnsiString __fastcall GetGitBaseDir(const AnsiString FileName);
	virtual AnsiString __fastcall GetName();
	virtual Jclversioncontrol::TJclVersionControlActionTypes __fastcall GetSupportedActionTypes();
	bool __fastcall IsGitSupportedDir(const AnsiString FileDir);
	
public:
	__fastcall virtual TJclVersionControlGIT(void);
	__fastcall virtual ~TJclVersionControlGIT(void);
	virtual bool __fastcall ExecuteAction(const AnsiString FileName, const Jclversioncontrol::TJclVersionControlActionType Action);
	virtual bool __fastcall GetSandboxNames(const AnsiString FileName, Classes::TStrings* SdBxNames);
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclversionctrlgitimpl */
using namespace Jclversionctrlgitimpl;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclversionctrlgitimpl

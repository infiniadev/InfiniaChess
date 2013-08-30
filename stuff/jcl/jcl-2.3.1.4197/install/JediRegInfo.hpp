// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jedireginfo.pas' rev: 10.00

#ifndef JedireginfoHPP
#define JedireginfoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jedireginfo
{
//-- type declarations -------------------------------------------------------
struct TJediInformation
{
	
public:
	AnsiString Version;
	AnsiString DcpDir;
	AnsiString BplDir;
	AnsiString RootDir;
} ;

//-- var, const, procedure ---------------------------------------------------
extern PACKAGE bool __fastcall InstallJediRegInformation(const AnsiString IdeRegKey, const AnsiString ProjectName, const AnsiString PlatformName, const AnsiString Version, const AnsiString DcpDir, const AnsiString BplDir, const AnsiString RootDir, HKEY RootKey = (HKEY)(0x80000001));
extern PACKAGE void __fastcall RemoveJediRegInformation(const AnsiString IdeRegKey, const AnsiString ProjectName, const AnsiString PlatformName, HKEY RootKey = (HKEY)(0x80000001));
extern PACKAGE bool __fastcall ReadJediRegInformation(const AnsiString IdeRegKey, const AnsiString ProjectName, const AnsiString PlatformName, /* out */ AnsiString &Version, /* out */ AnsiString &DcpDir, /* out */ AnsiString &BplDir, /* out */ AnsiString &RootDir, HKEY RootKey = (HKEY)(0x80000001))/* overload */;
extern PACKAGE TJediInformation __fastcall ReadJediRegInformation(const AnsiString IdeRegKey, const AnsiString ProjectName, const AnsiString PlatformName, HKEY RootKey = (HKEY)(0x80000001))/* overload */;
extern PACKAGE unsigned __fastcall ParseVersionNumber(const AnsiString VersionStr);

}	/* namespace Jedireginfo */
using namespace Jedireginfo;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jedireginfo

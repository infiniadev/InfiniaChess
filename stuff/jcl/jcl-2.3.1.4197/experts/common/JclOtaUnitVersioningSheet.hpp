// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclotaunitversioningsheet.pas' rev: 10.00

#ifndef JclotaunitversioningsheetHPP
#define JclotaunitversioningsheetHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Sysutils.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Jclunitversioning.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Comctrls.hpp>	// Pascal unit
#include <Stdctrls.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclotaunitversioningsheet
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclOtaUnitVersioningFrame;
class PASCALIMPLEMENTATION TJclOtaUnitVersioningFrame : public Forms::TFrame 
{
	typedef Forms::TFrame inherited;
	
__published:
	Stdctrls::TMemo* MemoUnitVersioning;
	Stdctrls::TButton* ButtonCopyToClipboard;
	Stdctrls::TButton* ButtonSaveAsText;
	Dialogs::TSaveDialog* SaveDialogText;
	void __fastcall ButtonCopyToClipboardClick(System::TObject* Sender);
	void __fastcall ButtonSaveAsTextClick(System::TObject* Sender);
	
public:
	__fastcall virtual TJclOtaUnitVersioningFrame(Classes::TComponent* AOwner);
public:
	#pragma option push -w-inl
	/* TScrollingWinControl.Destroy */ inline __fastcall virtual ~TJclOtaUnitVersioningFrame(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJclOtaUnitVersioningFrame(HWND ParentWindow) : Forms::TFrame(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclotaunitversioningsheet */
using namespace Jclotaunitversioningsheet;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclotaunitversioningsheet

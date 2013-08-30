// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclotaactionconfiguresheet.pas' rev: 10.00

#ifndef JclotaactionconfiguresheetHPP
#define JclotaactionconfiguresheetHPP

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
#include <Dialogs.hpp>	// Pascal unit
#include <Comctrls.hpp>	// Pascal unit
#include <Stdctrls.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclotaactionconfiguresheet
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclOtaActionConfigureFrame;
class PASCALIMPLEMENTATION TJclOtaActionConfigureFrame : public Forms::TFrame 
{
	typedef Forms::TFrame inherited;
	
__published:
	Comctrls::TListView* ListViewActions;
	Stdctrls::TLabel* LabelActions;
	Comctrls::THotKey* HotKeyShortcut;
	Stdctrls::TLabel* LabelShortcut;
	Stdctrls::TButton* ButtonRestore;
	void __fastcall HotKeyShortcutExit(System::TObject* Sender);
	void __fastcall ButtonRestoreClick(System::TObject* Sender);
	void __fastcall ListViewActionsSelectItem(System::TObject* Sender, Comctrls::TListItem* Item, bool Selected);
	
public:
	__fastcall virtual TJclOtaActionConfigureFrame(Classes::TComponent* AOwner);
	void __fastcall SaveChanges(void);
public:
	#pragma option push -w-inl
	/* TScrollingWinControl.Destroy */ inline __fastcall virtual ~TJclOtaActionConfigureFrame(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJclOtaActionConfigureFrame(HWND ParentWindow) : Forms::TFrame(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclotaactionconfiguresheet */
using namespace Jclotaactionconfiguresheet;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclotaactionconfiguresheet

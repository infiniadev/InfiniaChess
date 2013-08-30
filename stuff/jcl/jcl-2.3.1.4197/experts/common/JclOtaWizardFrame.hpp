// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclotawizardframe.pas' rev: 10.00

#ifndef JclotawizardframeHPP
#define JclotawizardframeHPP

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

//-- user supplied -----------------------------------------------------------

namespace Jclotawizardframe
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TJclWizardDirection { wdForward, wdBackward };
#pragma option pop

class DELPHICLASS TJclWizardFrame;
class PASCALIMPLEMENTATION TJclWizardFrame : public Forms::TFrame 
{
	typedef Forms::TFrame inherited;
	
protected:
	virtual bool __fastcall GetSupportsFinish(void);
	virtual bool __fastcall GetSupportsNext(void);
	virtual bool __fastcall GetSupportsPrevious(void);
	
public:
	virtual void __fastcall PageActivated(TJclWizardDirection Direction);
	virtual void __fastcall PageDesactivated(TJclWizardDirection Direction);
	__property bool SupportsNext = {read=GetSupportsNext, nodefault};
	__property bool SupportsPrevious = {read=GetSupportsPrevious, nodefault};
	__property bool SupportsFinish = {read=GetSupportsFinish, nodefault};
	__property Caption ;
public:
	#pragma option push -w-inl
	/* TCustomFrame.Create */ inline __fastcall virtual TJclWizardFrame(Classes::TComponent* AOwner) : Forms::TFrame(AOwner) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TScrollingWinControl.Destroy */ inline __fastcall virtual ~TJclWizardFrame(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJclWizardFrame(HWND ParentWindow) : Forms::TFrame(ParentWindow) { }
	#pragma option pop
	
};


typedef TMetaClass* TJclWizardFrameClass;

//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclotawizardframe */
using namespace Jclotawizardframe;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclotawizardframe

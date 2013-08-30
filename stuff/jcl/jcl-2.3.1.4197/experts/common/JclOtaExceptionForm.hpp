// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclotaexceptionform.pas' rev: 10.00

#ifndef JclotaexceptionformHPP
#define JclotaexceptionformHPP

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
#include <Stdctrls.hpp>	// Pascal unit
#include <Jclotautils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclotaexceptionform
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclExpertExceptionForm;
class PASCALIMPLEMENTATION TJclExpertExceptionForm : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TMemo* MemoDetails;
	Stdctrls::TLabel* LabelURL;
	Stdctrls::TMemo* MemoCallStack;
	Stdctrls::TButton* ButtonClose;
	void __fastcall LabelURLClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	
protected:
	virtual void __fastcall CreateParams(Controls::TCreateParams &Params);
	
public:
	void __fastcall ShowException(System::TObject* AExceptionObj);
	bool __fastcall Execute(void);
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TJclExpertExceptionForm(Classes::TComponent* AOwner) : Forms::TForm(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TJclExpertExceptionForm(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TJclExpertExceptionForm(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJclExpertExceptionForm(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclotaexceptionform */
using namespace Jclotaexceptionform;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclotaexceptionform

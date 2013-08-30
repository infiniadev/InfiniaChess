// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclotawizardform.pas' rev: 10.00

#ifndef JclotawizardformHPP
#define JclotawizardformHPP

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
#include <Extctrls.hpp>	// Pascal unit
#include <Actnlist.hpp>	// Pascal unit
#include <Jclotawizardframe.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclotawizardform
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclWizardForm;
class PASCALIMPLEMENTATION TJclWizardForm : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TButton* ButtonCancel;
	Stdctrls::TButton* ButtonFinish;
	Stdctrls::TButton* ButtonNext;
	Stdctrls::TButton* ButtonPrevious;
	Extctrls::TBevel* Bevel1;
	Extctrls::TPanel* PanelTitle;
	Extctrls::TImage* ImageJcl;
	Stdctrls::TLabel* LabelJcl;
	Stdctrls::TLabel* LabelProgression;
	Actnlist::TActionList* ActionListButtons;
	Actnlist::TAction* ActionPrevious;
	Actnlist::TAction* ActionNext;
	Actnlist::TAction* ActionFinish;
	Extctrls::TPanel* PanelPages;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall ActionPreviousExecute(System::TObject* Sender);
	void __fastcall ActionPreviousUpdate(System::TObject* Sender);
	void __fastcall ActionNextExecute(System::TObject* Sender);
	void __fastcall ActionNextUpdate(System::TObject* Sender);
	void __fastcall ActionFinishExecute(System::TObject* Sender);
	void __fastcall ActionFinishUpdate(System::TObject* Sender);
	
private:
	AnsiString FDescription;
	int FPageIndex;
	bool FExecuting;
	int __fastcall GetPageCount(void);
	int __fastcall GetPageIndex(void);
	void __fastcall SetPageIndex(const int Value);
	Jclotawizardframe::TJclWizardFrame* __fastcall GetActivePage(void);
	Jclotawizardframe::TJclWizardFrame* __fastcall GetPage(int Index);
	
public:
	int __fastcall AddPage(const Jclotawizardframe::TJclWizardFrame* WizardFrame);
	bool __fastcall Execute(void);
	__property int PageCount = {read=GetPageCount, nodefault};
	__property int PageIndex = {read=GetPageIndex, write=SetPageIndex, nodefault};
	__property AnsiString Description = {read=FDescription, write=FDescription};
	__property Jclotawizardframe::TJclWizardFrame* Pages[int Index] = {read=GetPage};
	__property Jclotawizardframe::TJclWizardFrame* ActivePage = {read=GetActivePage};
	__property bool Executing = {read=FExecuting, nodefault};
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TJclWizardForm(Classes::TComponent* AOwner) : Forms::TForm(AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TJclWizardForm(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TJclWizardForm(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJclWizardForm(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclotawizardform */
using namespace Jclotawizardform;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclotawizardform

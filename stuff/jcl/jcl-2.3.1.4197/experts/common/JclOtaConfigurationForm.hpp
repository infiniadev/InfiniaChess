// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclotaconfigurationform.pas' rev: 10.00

#ifndef JclotaconfigurationformHPP
#define JclotaconfigurationformHPP

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
#include <Comctrls.hpp>	// Pascal unit
#include <Jclotautils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclotaconfigurationform
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclOtaOptionsForm;
class PASCALIMPLEMENTATION TJclOtaOptionsForm : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TButton* ButtonOk;
	Stdctrls::TButton* ButtonCancel;
	Extctrls::TPanel* PanelName;
	Extctrls::TPanel* PanelTree;
	Extctrls::TPanel* PanelOptions;
	Extctrls::TSplitter* SplitterSep;
	Comctrls::TTreeView* TreeViewCategories;
	Stdctrls::TLabel* LabelSelectPage;
	Stdctrls::TLabel* LabelHomePage;
	void __fastcall LabelHomePageClick(System::TObject* Sender);
	void __fastcall TreeViewCategoriesChange(System::TObject* Sender, Comctrls::TTreeNode* Node);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	
private:
	Jclotautils::TJclOTASettings* FSettings;
	
protected:
	virtual void __fastcall CreateParams(Controls::TCreateParams &Params);
	
public:
	__fastcall virtual TJclOtaOptionsForm(Classes::TComponent* AOwner);
	__fastcall virtual ~TJclOtaOptionsForm(void);
	void __fastcall AddPage(Controls::TControl* AControl, AnsiString PageName, Jclotautils::_di_IJclOTAOptionsCallback Expert);
	bool __fastcall Execute(AnsiString PageName);
	__property Jclotautils::TJclOTASettings* Settings = {read=FSettings};
public:
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TJclOtaOptionsForm(Classes::TComponent* AOwner, int Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJclOtaOptionsForm(HWND ParentWindow) : Forms::TForm(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclotaconfigurationform */
using namespace Jclotaconfigurationform;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclotaconfigurationform

// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclversionctrlcommonoptions.pas' rev: 10.00

#ifndef JclversionctrlcommonoptionsHPP
#define JclversionctrlcommonoptionsHPP

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
#include <Comctrls.hpp>	// Pascal unit
#include <Actnlist.hpp>	// Pascal unit
#include <Menus.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclversionctrlcommonoptions
{
//-- type declarations -------------------------------------------------------
#pragma option push -b-
enum TIconType { itNone, itJCL };
#pragma option pop

class DELPHICLASS TJclVersionCtrlOptionsFrame;
class PASCALIMPLEMENTATION TJclVersionCtrlOptionsFrame : public Forms::TFrame 
{
	typedef Forms::TFrame inherited;
	
__published:
	Stdctrls::TCheckBox* CheckBoxHideActions;
	Stdctrls::TLabel* LabelIcons;
	Stdctrls::TComboBox* ComboBoxIcons;
	Comctrls::TTreeView* TreeViewMenu;
	Stdctrls::TLabel* LabelMenuOrganization;
	Stdctrls::TCheckBox* CheckBoxDisableActions;
	Stdctrls::TButton* ButtonNewSeparator;
	Stdctrls::TButton* ButtonDelete;
	Stdctrls::TButton* ButtonRename;
	Stdctrls::TButton* ButtonMoveUp;
	Stdctrls::TButton* ButtonMoveDown;
	Actnlist::TActionList* ActionListVersionCtrl;
	Actnlist::TAction* ActionNewSeparator;
	Actnlist::TAction* ActionDeleteItem;
	Actnlist::TAction* ActionRenameItem;
	Actnlist::TAction* ActionMoveItemUp;
	Actnlist::TAction* ActionMoveItemDown;
	Stdctrls::TCheckBox* CheckBoxSaveConfirmation;
	Menus::TPopupMenu* PopupMenuActions;
	Actnlist::TAction* ActionNewAction;
	Stdctrls::TButton* ButtonNewAction;
	Actnlist::TAction* ActionNewSubMenu;
	Stdctrls::TButton* ButtonNewSubMenu;
	Stdctrls::TCheckBox* CheckBoxActOnTopSandbox;
	void __fastcall ActionActOnTopSandboxUpdate(System::TObject* Sender);
	void __fastcall ActionNewActionExecute(System::TObject* Sender);
	void __fastcall ActionNewActionUpdate(System::TObject* Sender);
	void __fastcall ActionRenameItemExecute(System::TObject* Sender);
	void __fastcall ActionNewSubMenuExecute(System::TObject* Sender);
	void __fastcall ActionNewSubMenuUpdate(System::TObject* Sender);
	void __fastcall ActionNewSeparatorExecute(System::TObject* Sender);
	void __fastcall ActionMoveItemUpExecute(System::TObject* Sender);
	void __fastcall ActionMoveItemDownExecute(System::TObject* Sender);
	void __fastcall ActionDeleteItemExecute(System::TObject* Sender);
	void __fastcall ActionSaveConfirmationUpdate(System::TObject* Sender);
	void __fastcall ActionRenameItemUpdate(System::TObject* Sender);
	void __fastcall ActionNewSeparatorUpdate(System::TObject* Sender);
	void __fastcall ActionMoveItemUpUpdate(System::TObject* Sender);
	void __fastcall ActionMoveItemDownUpdate(System::TObject* Sender);
	void __fastcall ActionHideUnSupportedActionsUpdate(System::TObject* Sender);
	void __fastcall ActionDisableActionsUpdate(System::TObject* Sender);
	void __fastcall ActionDeleteItemUpdate(System::TObject* Sender);
	void __fastcall TreeViewMenuEditing(System::TObject* Sender, Comctrls::TTreeNode* Node, bool &AllowEdit);
	void __fastcall TreeViewMenuEdited(System::TObject* Sender, Comctrls::TTreeNode* Node, AnsiString &S);
	
private:
	Classes::TStrings* FMenuTree;
	bool __fastcall GetActOnTopSandbox(void);
	void __fastcall SetActOnTopSandbox(const bool Value);
	bool __fastcall GetSaveConfirmation(void);
	void __fastcall SetSaveConfirmation(const bool Value);
	bool __fastcall GetDisableActions(void);
	bool __fastcall GetHideActions(void);
	TIconType __fastcall GetIconType(void);
	Classes::TStrings* __fastcall GetMenuTree(void);
	void __fastcall SetDisableActions(const bool Value);
	void __fastcall SetHideActions(const bool Value);
	void __fastcall SetIconType(const TIconType Value);
	void __fastcall SetMenuTree(const Classes::TStrings* Value);
	void __fastcall MenuItemNewActionClick(System::TObject* Sender);
	
public:
	__fastcall virtual TJclVersionCtrlOptionsFrame(Classes::TComponent* AOwner);
	__fastcall virtual ~TJclVersionCtrlOptionsFrame(void);
	void __fastcall SetActions(Actnlist::TCustomAction* const * Actions, const int Actions_Size);
	__property bool ActOnTopSandbox = {read=GetActOnTopSandbox, write=SetActOnTopSandbox, nodefault};
	__property bool DisableActions = {read=GetDisableActions, write=SetDisableActions, nodefault};
	__property bool HideActions = {read=GetHideActions, write=SetHideActions, nodefault};
	__property TIconType IconType = {read=GetIconType, write=SetIconType, nodefault};
	__property Classes::TStrings* MenuTree = {read=GetMenuTree, write=SetMenuTree};
	__property bool SaveConfirmation = {read=GetSaveConfirmation, write=SetSaveConfirmation, nodefault};
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TJclVersionCtrlOptionsFrame(HWND ParentWindow) : Forms::TFrame(ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclversionctrlcommonoptions */
using namespace Jclversionctrlcommonoptions;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclversionctrlcommonoptions

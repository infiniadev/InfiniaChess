// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclpreprocessorexcdlgtemplates.pas' rev: 10.00

#ifndef JclpreprocessorexcdlgtemplatesHPP
#define JclpreprocessorexcdlgtemplatesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Jclideutils.hpp>	// Pascal unit
#include <Jclpreprocessortemplates.hpp>	// Pascal unit
#include <Jclpreprocessorparser.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclpreprocessorexcdlgtemplates
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TJclExcDlgParams;
class PASCALIMPLEMENTATION TJclExcDlgParams : public Jclpreprocessortemplates::TJclTemplateParams 
{
	typedef Jclpreprocessortemplates::TJclTemplateParams inherited;
	
private:
	bool FHookDll;
	AnsiString FFileName;
	bool FCodeDetails;
	bool FModuleName;
	bool FModuleOffset;
	bool FDelayedTrace;
	AnsiString FFormName;
	bool FLogFile;
	AnsiString FLogFileName;
	bool FAutoSaveWorkingDirectory;
	bool FAutoSaveApplicationDirectory;
	bool FAutoSaveDesktopDirectory;
	bool FLogSaveDialog;
	bool FAddressOffset;
	bool FVirtualAddress;
	Jclideutils::TJclBorPersonality FActivePersonality;
	Jclideutils::TJclBorPersonality FLanguage;
	Jclideutils::TJclBorPersonalities FLanguages;
	bool FRawData;
	bool FSendEMail;
	AnsiString FEMailAddress;
	AnsiString FFormAncestor;
	bool FModalDialog;
	bool FSizeableDialog;
	AnsiString FEMailSubject;
	Jclideutils::TJclBorDesigner FDesigner;
	bool FModuleList;
	bool FUnitVersioning;
	bool FOSInfo;
	bool FActiveControls;
	bool FDisableIfDebuggerAttached;
	bool FStackList;
	bool FAutoScrollBars;
	bool FCatchMainThread;
	bool FAllThreads;
	bool FAllRegisteredThreads;
	bool FMainExceptionThreads;
	bool FExceptionThread;
	bool FMainThread;
	bool FTraceEAbort;
	Classes::TStrings* FIgnoredExceptions;
	int FIgnoredExceptionsIndex;
	bool FTraceAllExceptions;
	int __fastcall GetIgnoredExceptionsCount(void);
	bool __fastcall GetReportAllThreads(void);
	bool __fastcall GetReportExceptionThread(void);
	bool __fastcall GetReportMainThread(void);
	AnsiString __fastcall GetIgnoredException();
	
public:
	__fastcall TJclExcDlgParams(void);
	__fastcall virtual ~TJclExcDlgParams(void);
	
__published:
	__property Jclideutils::TJclBorPersonality Language = {read=FLanguage, write=FLanguage, nodefault};
	__property Jclideutils::TJclBorPersonalities Languages = {read=FLanguages, write=FLanguages, nodefault};
	__property Jclideutils::TJclBorPersonality ActivePersonality = {read=FActivePersonality, write=FActivePersonality, nodefault};
	__property AnsiString FileName = {read=FFileName, write=FFileName};
	__property AnsiString FormName = {read=FFormName, write=FFormName};
	__property AnsiString FormAncestor = {read=FFormAncestor, write=FFormAncestor};
	__property Jclideutils::TJclBorDesigner Designer = {read=FDesigner, write=FDesigner, nodefault};
	__property bool ModalDialog = {read=FModalDialog, write=FModalDialog, nodefault};
	__property bool SendEMail = {read=FSendEMail, write=FSendEMail, nodefault};
	__property AnsiString EMailAddress = {read=FEMailAddress, write=FEMailAddress};
	__property AnsiString EMailSubject = {read=FEMailSubject, write=FEMailSubject};
	__property bool SizeableDialog = {read=FSizeableDialog, write=FSizeableDialog, nodefault};
	__property bool AutoScrollBars = {read=FAutoScrollBars, write=FAutoScrollBars, nodefault};
	__property bool DelayedTrace = {read=FDelayedTrace, write=FDelayedTrace, nodefault};
	__property bool HookDll = {read=FHookDll, write=FHookDll, nodefault};
	__property bool OSInfo = {read=FOSInfo, write=FOSInfo, nodefault};
	__property bool ModuleList = {read=FModuleList, write=FModuleList, nodefault};
	__property bool UnitVersioning = {read=FUnitVersioning, write=FUnitVersioning, nodefault};
	__property bool ActiveControls = {read=FActiveControls, write=FActiveControls, nodefault};
	__property bool CatchMainThread = {read=FCatchMainThread, write=FCatchMainThread, nodefault};
	__property bool DisableIfDebuggerAttached = {read=FDisableIfDebuggerAttached, write=FDisableIfDebuggerAttached, nodefault};
	__property bool LogFile = {read=FLogFile, write=FLogFile, nodefault};
	__property AnsiString LogFileName = {read=FLogFileName, write=FLogFileName};
	__property bool AutoSaveWorkingDirectory = {read=FAutoSaveWorkingDirectory, write=FAutoSaveWorkingDirectory, nodefault};
	__property bool AutoSaveApplicationDirectory = {read=FAutoSaveApplicationDirectory, write=FAutoSaveApplicationDirectory, nodefault};
	__property bool AutoSaveDesktopDirectory = {read=FAutoSaveDesktopDirectory, write=FAutoSaveDesktopDirectory, nodefault};
	__property bool LogSaveDialog = {read=FLogSaveDialog, write=FLogSaveDialog, nodefault};
	__property bool TraceAllExceptions = {read=FTraceAllExceptions, write=FTraceAllExceptions, nodefault};
	__property bool TraceEAbort = {read=FTraceEAbort, write=FTraceEAbort, nodefault};
	__property AnsiString IgnoredException = {read=GetIgnoredException};
	__property Classes::TStrings* IgnoredExceptions = {read=FIgnoredExceptions, write=FIgnoredExceptions};
	__property int IgnoredExceptionsIndex = {read=FIgnoredExceptionsIndex, write=FIgnoredExceptionsIndex, nodefault};
	__property int IgnoredExceptionsCount = {read=GetIgnoredExceptionsCount, nodefault};
	__property bool StackList = {read=FStackList, write=FStackList, nodefault};
	__property bool RawData = {read=FRawData, write=FRawData, nodefault};
	__property bool ModuleName = {read=FModuleName, write=FModuleName, nodefault};
	__property bool ModuleOffset = {read=FModuleOffset, write=FModuleOffset, nodefault};
	__property bool AllThreads = {read=FAllThreads, write=FAllThreads, nodefault};
	__property bool AllRegisterThreads = {read=FAllRegisteredThreads, write=FAllRegisteredThreads, nodefault};
	__property bool MainExceptionThreads = {read=FMainExceptionThreads, write=FMainExceptionThreads, nodefault};
	__property bool ExceptionThread = {read=FExceptionThread, write=FExceptionThread, nodefault};
	__property bool MainThread = {read=FMainThread, write=FMainThread, nodefault};
	__property bool ReportMainThread = {read=GetReportMainThread, nodefault};
	__property bool ReportAllThreads = {read=GetReportAllThreads, nodefault};
	__property bool ReportExceptionThread = {read=GetReportExceptionThread, nodefault};
	__property bool CodeDetails = {read=FCodeDetails, write=FCodeDetails, nodefault};
	__property bool VirtualAddress = {read=FVirtualAddress, write=FVirtualAddress, nodefault};
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclpreprocessorexcdlgtemplates */
using namespace Jclpreprocessorexcdlgtemplates;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclpreprocessorexcdlgtemplates

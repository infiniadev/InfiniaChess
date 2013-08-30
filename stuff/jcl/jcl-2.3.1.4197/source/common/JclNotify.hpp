// Borland C++ Builder
// Copyright (c) 1995, 2005 by Borland Software Corporation
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Jclnotify.pas' rev: 10.00

#ifndef JclnotifyHPP
#define JclnotifyHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member functions
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <Sysinit.hpp>	// Pascal unit
#include <Jclbase.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Jclnotify
{
//-- type declarations -------------------------------------------------------
__interface IJclListener;
typedef System::DelphiInterface<IJclListener> _di_IJclListener;
__interface IJclNotificationMessage;
typedef System::DelphiInterface<IJclNotificationMessage> _di_IJclNotificationMessage;
__interface  INTERFACE_UUID("{26A52ECC-4C22-4B71-BC88-D0EB98AF4ED5}") IJclListener  : public IInterface 
{
	
public:
	virtual void __stdcall Notification(_di_IJclNotificationMessage msg) = 0 ;
};

__interface  INTERFACE_UUID("{2618CCC6-0C7D-47EE-9A91-7A7F5264385D}") IJclNotificationMessage  : public IInterface 
{
	
};

__interface IJclNotifier;
typedef System::DelphiInterface<IJclNotifier> _di_IJclNotifier;
__interface  INTERFACE_UUID("{CAAD7814-DD04-497C-91AC-558C2D5BFF81}") IJclNotifier  : public IInterface 
{
	
public:
	virtual void __stdcall Add(_di_IJclListener listener) = 0 ;
	virtual void __stdcall Remove(_di_IJclListener listener) = 0 ;
	virtual void __stdcall Notify(_di_IJclNotificationMessage msg) = 0 ;
};

class DELPHICLASS TJclBaseListener;
class PASCALIMPLEMENTATION TJclBaseListener : public System::TInterfacedObject 
{
	typedef System::TInterfacedObject inherited;
	
public:
	virtual void __stdcall Notification(_di_IJclNotificationMessage msg);
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclBaseListener(void) : System::TInterfacedObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBaseListener(void) { }
	#pragma option pop
	
private:
	void *__IJclListener;	/* Jclnotify::IJclListener */
	
public:
	operator IJclListener*(void) { return (IJclListener*)&__IJclListener; }
	
};


class DELPHICLASS TJclBaseNotificationMessage;
class PASCALIMPLEMENTATION TJclBaseNotificationMessage : public System::TInterfacedObject 
{
	typedef System::TInterfacedObject inherited;
	
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclBaseNotificationMessage(void) : System::TInterfacedObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBaseNotificationMessage(void) { }
	#pragma option pop
	
private:
	void *__IJclNotificationMessage;	/* Jclnotify::IJclNotificationMessage */
	
public:
	operator IJclNotificationMessage*(void) { return (IJclNotificationMessage*)&__IJclNotificationMessage; }
	
};


class DELPHICLASS TJclBaseNotifier;
class PASCALIMPLEMENTATION TJclBaseNotifier : public System::TInterfacedObject 
{
	typedef System::TInterfacedObject inherited;
	
public:
	__fastcall TJclBaseNotifier(void);
	__fastcall virtual ~TJclBaseNotifier(void);
	
private:
	Classes::TInterfaceList* FListeners;
	
public:
	void __stdcall Add(_di_IJclListener listener);
	void __stdcall Notify(_di_IJclNotificationMessage msg);
	void __stdcall Remove(_di_IJclListener listener);
private:
	void *__IJclNotifier;	/* Jclnotify::IJclNotifier */
	
public:
	operator IJclNotifier*(void) { return (IJclNotifier*)&__IJclNotifier; }
	
};


typedef DynamicArray<System::TMethod >  TJclMethodArray;

class DELPHICLASS TJclMethodBroadCast;
class PASCALIMPLEMENTATION TJclMethodBroadCast : public System::TObject 
{
	typedef System::TObject inherited;
	
protected:
	DynamicArray<System::TMethod >  FHandlers;
	int FHandlerCount;
	System::TMethod __fastcall GetHandler(int Index);
	
public:
	int __fastcall AddHandler(const System::TMethod &AHandler);
	void __fastcall RemoveHandler(const System::TMethod &AHandler);
	void __fastcall DeleteHandler(int Index);
	__property int HandlerCount = {read=FHandlerCount, nodefault};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclMethodBroadCast(void) : System::TObject() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclMethodBroadCast(void) { }
	#pragma option pop
	
};


class DELPHICLASS TJclNotifyEventBroadcast;
class PASCALIMPLEMENTATION TJclNotifyEventBroadcast : public TJclMethodBroadCast 
{
	typedef TJclMethodBroadCast inherited;
	
protected:
	HIDESBASE Classes::TNotifyEvent __fastcall GetHandler(int Index);
	
public:
	HIDESBASE int __fastcall AddHandler(const Classes::TNotifyEvent AHandler);
	HIDESBASE void __fastcall RemoveHandler(const Classes::TNotifyEvent AHandler);
	void __fastcall Notify(System::TObject* Sender);
	__property Classes::TNotifyEvent Handlers[int Index] = {read=GetHandler};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclNotifyEventBroadcast(void) : TJclMethodBroadCast() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclNotifyEventBroadcast(void) { }
	#pragma option pop
	
};


typedef void __fastcall (__closure *TJclProcedureEvent)(void);

class DELPHICLASS TJclProcedureEventBroadcast;
class PASCALIMPLEMENTATION TJclProcedureEventBroadcast : public TJclMethodBroadCast 
{
	typedef TJclMethodBroadCast inherited;
	
protected:
	HIDESBASE TJclProcedureEvent __fastcall GetHandler(int Index);
	
public:
	HIDESBASE int __fastcall AddHandler(const TJclProcedureEvent AHandler);
	HIDESBASE void __fastcall RemoveHandler(const TJclProcedureEvent AHandler);
	void __fastcall CallAllProcedures(void);
	__property TJclProcedureEvent Handlers[int Index] = {read=GetHandler};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclProcedureEventBroadcast(void) : TJclMethodBroadCast() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclProcedureEventBroadcast(void) { }
	#pragma option pop
	
};


typedef void __fastcall (__closure *TJclBooleanProcedureEvent)(bool Value);

class DELPHICLASS TJclBooleanProcedureEventBroadcast;
class PASCALIMPLEMENTATION TJclBooleanProcedureEventBroadcast : public TJclMethodBroadCast 
{
	typedef TJclMethodBroadCast inherited;
	
protected:
	HIDESBASE TJclBooleanProcedureEvent __fastcall GetHandler(int Index);
	
public:
	HIDESBASE int __fastcall AddHandler(const TJclBooleanProcedureEvent AHandler);
	HIDESBASE void __fastcall RemoveHandler(const TJclBooleanProcedureEvent AHandler);
	void __fastcall CallAllProcedures(bool Value);
	__property TJclBooleanProcedureEvent Handlers[int Index] = {read=GetHandler};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclBooleanProcedureEventBroadcast(void) : TJclMethodBroadCast() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBooleanProcedureEventBroadcast(void) { }
	#pragma option pop
	
};


typedef bool __fastcall (__closure *TJclBooleanEvent)(void);

class DELPHICLASS TJclBooleanEventBroadcast;
class PASCALIMPLEMENTATION TJclBooleanEventBroadcast : public TJclMethodBroadCast 
{
	typedef TJclMethodBroadCast inherited;
	
protected:
	HIDESBASE TJclBooleanEvent __fastcall GetHandler(int Index);
	
public:
	HIDESBASE int __fastcall AddHandler(const TJclBooleanEvent AHandler);
	HIDESBASE void __fastcall RemoveHandler(const TJclBooleanEvent AHandler);
	bool __fastcall LogicalAnd(void);
	__property TJclBooleanEvent Handlers[int Index] = {read=GetHandler};
public:
	#pragma option push -w-inl
	/* TObject.Create */ inline __fastcall TJclBooleanEventBroadcast(void) : TJclMethodBroadCast() { }
	#pragma option pop
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TJclBooleanEventBroadcast(void) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------

}	/* namespace Jclnotify */
using namespace Jclnotify;
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Jclnotify

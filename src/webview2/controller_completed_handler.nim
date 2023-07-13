import winim
import com
import types
import globals

const GUID = DEFINE_GUID"6C4819F3-C9B7-4260-8127-C9F5BDE7F68C"
const  IID_ICoreWebView2Controller2 = DEFINE_GUID"C979903E-D4CA-4228-92EB-47EE3FA96EAB"

using
  self: ptr ICoreWebView2CreateCoreWebView2ControllerCompletedHandler

proc Invoke*(self;
    errorCode: HRESULT;
    createdController: ptr ICoreWebView2Controller): HRESULT {.stdcall.} =
  echo "ICoreWebView2CreateCoreWebView2ControllerCompletedHandler.Invoke"
  if errorCode != S_OK:
    return errorCode
  let e = createdController.lpVtbl.QueryInterface(cast[ptr IUnknown](createdController), IID_ICoreWebView2Controller2.unsafeAddr, cast[ptr pointer](controller.addr))
  if e != S_OK:
    return e
  let hr = createdController.lpVtbl.GetCoreWebView2(createdController, view.addr)
  if S_OK != hr:
    return hr
  echo "GetCoreWebView2"
  return S_OK

proc AddRef*(self): ULONG {.stdcall.} =
  return 1

proc Release*(self): ULONG {.stdcall.} =
  return 0

proc QueryInterface*(self; riid: REFIID; ppvObject: ptr pointer): HRESULT {.stdcall.} =
  if ppvObject == nil:
    return E_NOINTERFACE
  if riid[] == GUID or riid[] == IID_IUnknown:
    ppvObject[] = self
    return S_OK
  else:
    ppvObject[] = nil
    return E_NOINTERFACE

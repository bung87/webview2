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
  # discard createdController.lpVtbl.AddRef(cast[ptr IUnknown](createdController))
  # let e = createdController.lpVtbl.QueryInterface(cast[ptr IUnknown](createdController), IID_ICoreWebView2Controller2.unsafeAddr, cast[ptr pointer](controller.addr))
  # if e != S_OK:
  #   return e
  var theView: ptr ICoreWebView2
  let hr = createdController.lpVtbl.get_CoreWebView2(createdController, theView.addr)

  # discard createdController.lpVtbl.Release(cast[ptr IUnknown](createdController))
  if S_OK != hr:
    return hr
  echo "GetCoreWebView2"
  echo repr theView
  echo repr theView[].lpVtbl.Navigate
  discard theView[].lpVtbl.Navigate(theView[], L"about:blank")
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
